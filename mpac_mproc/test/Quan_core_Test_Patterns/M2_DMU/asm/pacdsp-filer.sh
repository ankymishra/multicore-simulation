#!/bin/bash

# ****************************************************************************************************
# FILE NAME    :	 pacdsp-filer.sh      
# VERSION      :	 1.0
# DATE         :	 December 12, 2006
# AUTHOR       :	 Zyson Wu, E100/STC/ITRI ( sunrise0611@itri.org.tw )
# DESCRIPTION  :	 This script can generate versate formats used by PACDSP below.
#                    .s   => .out; (.tic.inst,.tic.c); (.text.hex,.data.hex); (.text.bin,.data.bin) 
#                    .out => (.tic.inst,.tic.c); (.text.hex,.data.hex); (.text.bin,.data.bin)
#                    .bin => .hex
#                     
#                    [asm] : Assembly File     => Assemble Source of PACDSP   
#                    [out] : Executable File   => Input of Functional ISS     
#                    [tic] : TIC File          => Input of Verilog Simulation 
#                    [bin] : Binary File       => Input of FPGA Simulation 
#                    [hex] : Hexadecimal File  => Input of FPGA Simulation
# MODIFICATION :  
# ****************************************************************************************************


# check input if valid
Check_Input()
{
  case $1 in
       asm)
            if [ ! -e $PWD/$FN.s ] ; then
              echo "Error! No such $FN.s file exist!"  
              exit 1
            fi
            ;;
       out)
            if [ ! -e $PWD/$FN.out ] ; then
              echo "Error! No such $FN.out file exist!"  
              exit 1
            fi
            ;;
       bin)
            if [ ! -e $PWD/$FN.bin ] ; then
              echo "Error! No such $FN.bin file exist!"  
              exit 1
            fi
            ;;
       *  )
            ;;
  esac	
};


# generate object file
Gen_OBJ()
{
  pacdsp-elf-as $PWD/$FN.s -horizontaledit -o $PWD/$FN.o
  if [ ! -e $PWD/$FN.o ] ; then
    echo "Error! No such $FN.o file exist!"  
    exit 1
  fi
};


# generate executable file
Gen_OUT()
{
  pacdsp-elf-ld $PWD/$FN.o -o $PWD/$FN.out
  if [ ! -e $PWD/$FN.out ] ; then
    echo "Error! No such $FN.out file exist!"  
    exit 1
  fi  
};


# seperate data section and text section from executable file into binary file
Gen_BIN()
{
  pacdsp-elf-objcopy -O binary -R .data $PWD/$FN.out $PWD/$FN.text.bin	
  pacdsp-elf-objcopy -O binary -R .text $PWD/$FN.out $PWD/$FN.data.bin 
  if [ ! -e $PWD/$FN.text.bin ] || [ ! -e $PWD/$FN.data.bin ] ; then
     echo "Error! No such $FN.text.bin & $FN.data.bin file exist!"  
     exit 1  
  fi  
};
  

# convert binary file to hexadecimal file
Gen_HEX()
{ 
  od -v -t x4 -w4 $1 | awk '{print $2}' > $PWD/$FN.hex 
  if [ ! -e $PWD/$FN.hex ] ; then
    echo "Error! No such $FN.hex file exist!"  
    exit 1
  fi 
};


# check instruction size if exceed Icache range (256 lines x 1Kb = 32KB ) 
Check_Isize()
{
  count=`grep -c '[0-9a-f]' $1`    # count represents total instruciton count(Word)
  size=`expr $count / 32 + 2`      # 1 line = 1024*byte = 128*Byte = 32*Word
  if [ $size -gt 256 ] ; then
     echo "Warning! Instruction Size is Out Of Icache Range (256 lines)"
  fi
};


# tic.c generation
Gen_TIC()
{
#================================== TIC Part 1 ==================================	
cat > $PWD/$FN.tic.c << EOF
#include "header.h"
#include "ticmacros.h"

#define NO_Mask 0xFFFFFFFF /* 32 bits 1 */
#define All_Mask 0x00000000

int main()
{

  /* Data memory addressing mode (0: not interleaved 1: interleaved) */
  A(0x90A5003C);
  W(0x00000000);
  
  /* Data memory access priority (0: Core>BIU>CFU 1: BIU>Core>CFU) */
  A(0x90A50040);
  W(0x00000000);    
                 
  /* Base Address */
  A(0x90A50038);
  W(0x90A00000);

  /* DBGISR */
  A(0x90A5001C);
  W(0x10000000);

  /* EXCISR */
  A(0x90A50020);
  W(0x10000000);
  
  /* FIQISR */
  A(0x90A50024);
  W(0x10000000);

  /* IRQISR */
  A(0x90A50028);
  W(0x10000000); 
      
  /* Start address to PSCU */
  A(0x90A50000);
  W(0x10000000);
  
  /* Start Address to ICache */
  A(0x90A50010);
  W(0x10000000);
	 
EOF
#================================== TIC Part 2 ==================================  
echo "  /* Initial program size to ICache */"                 >> $PWD/$FN.tic.c 
echo "  A(0x90A50014);"                                       >> $PWD/$FN.tic.c
echo -n "  W(0x"`echo $size | awk '{printf "%08X",$1}'`");"   >> $PWD/$FN.tic.c
echo " /* Size x 1024bits */"                                 >> $PWD/$FN.tic.c
echo " "                                                      >> $PWD/$FN.tic.c
echo "  /* Miss program size to ICache */"                    >> $PWD/$FN.tic.c
echo "  A(0x90A50018);"                                       >> $PWD/$FN.tic.c
echo "  W(0x00000004); /* Size x 1024bits */"                 >> $PWD/$FN.tic.c
echo " "                                                      >> $PWD/$FN.tic.c
#================================== TIC Part 3 ==================================
echo "  /* Initial DATA */"         >> $PWD/$FN.tic.c  
echo "  /* =================== */"  >> $PWD/$FN.tic.c
addr=2426404864 # Base Address : 2426404864 = 0x90A0_0000
for token in `cat $FN.data.hex`
do
  if [ $addr -ne 2426404864 ]; then  # Base Address : 2426404864 = 0x90A0_0000
     echo " "  >> $PWD/$FN.tic.c
  fi
	echo "  A(0x"`echo $addr| awk '{printf "%X", $1}'`");"  >> $PWD/$FN.tic.c
	echo "  W(0x"$token");"                                 >> $PWD/$FN.tic.c
	addr=`expr $addr + 4`	
done
echo "  /* =================== */"  >> $PWD/$FN.tic.c 
echo "  /* End of initial DATA */"  >> $PWD/$FN.tic.c 
#================================== TIC Part 4 ==================================
cat >> $PWD/$FN.tic.c << EOF
  /* Start the program operation (0:start directly 1:start while Ich_Done) */ 
  A(0x90A50004);
  W(0x00000001);
    
  /* Start the instruction cache initialization */ 
  A(0x90A50048);
  W(0x00000000);  
  
  E();
          
  return 0;  
  
}  
EOF
};


# main code
# ====================================================================================
if [ $# -ne 1 ] ; then
   echo "Usage : pacdsp-filer.sh \$FN"
   exit 1
fi

FN="$1"

echo -n "`printf "\e"`[1;33m"
echo "[asm] : Assembly File     => Assemble Source of PACDSP   "
echo "[out] : Executable File   => Input of Functional ISS     "
echo "[tic] : TIC File          => Input of Verilog Simulation "
echo "[bin] : Binary File       => Input of FPGA Simulation    "
echo "[hex] : Hexadecimal File  => Input of FPGA Simulation    "
echo -n "`printf "\e"`[0m"

PS3="Please make a selection => "
export PS3

select format in asm2bin asm2hex asm2out asm2tic out2bin out2hex out2tic bin2hex
do	 	
  case $format in   
	   asm2bin)
	            echo "**********************************************"
	            echo "Convert *.s To *.text.bin, *.data.bin         "
	            echo "**********************************************"
	            Check_Input asm;
	            Gen_OBJ;
	            Gen_OUT;
	            Gen_BIN;
	            if [ ! -d $PWD/$FN ] ; then
	               mkdir $PWD/$FN
	            fi
	            mv $PWD/$FN.text.bin $PWD/$FN
	            mv $PWD/$FN.data.bin $PWD/$FN 
	            rm -f $PWD/$FN.o
	            rm -f $PWD/$FN.out
	            echo "OK! covert `printf "\e"`[1;32m $FN.s `printf "\e"`[0m to `printf "\e"`[1;31m $FN.text.bin  $FN.data.bin `printf "\e"`[0m is done!"
                echo " "
	            break;;
	   asm2hex)
	            echo "**********************************************"
	            echo "Convert *.s To *.text.hex, *.data.hex         "
	            echo "**********************************************"
	            Check_Input asm;
	            Gen_OBJ;
	            Gen_OUT;
	            Gen_BIN;
	            Gen_HEX $PWD/$FN.text.bin;
	            mv $PWD/$FN.hex $PWD/$FN.text.hex; 
	            Gen_HEX $PWD/$FN.data.bin; 
	            mv $PWD/$FN.hex $PWD/$FN.data.hex; 
	            if [ ! -d $PWD/$FN ] ; then
	               mkdir $PWD/$FN
	            fi
	            mv $PWD/$FN.text.hex $PWD/$FN
	            mv $PWD/$FN.data.hex $PWD/$FN          
	            rm -f $PWD/$FN.o
	            rm -f $PWD/$FN.out
	            rm -f $PWD/$FN.text.bin	 $PWD/$FN.data.bin  
	            echo "OK! covert `printf "\e"`[1;32m $FN.s `printf "\e"`[0m to `printf "\e"`[1;31m $FN.text.hex  $FN.data.hex `printf "\e"`[0m is done!"
                echo " "
	            break;;
	   asm2out)
	            echo "**********************************************"
	            echo "Convert *.s To *.out                          "
	            echo "**********************************************"
	            Check_Input asm;
	            Gen_OBJ;
	            Gen_OUT;
	            if [ ! -d $PWD/$FN ] ; then
	               mkdir $PWD/$FN
	            fi
	            mv $PWD/$FN.out $PWD/$FN
	            rm -f $PWD/$FN.o 	            
	            echo "OK! covert `printf "\e"`[1;32m $FN.s `printf "\e"`[0m to `printf "\e"`[1;31m $FN.out `printf "\e"`[0m is done!"
                echo " "                
	            break;;	
	   asm2tic)
	            echo "**********************************************"
	            echo "Convert *.s To *.tic.inst                     "
	            echo "**********************************************"
	            Check_Input asm;
	            Gen_OBJ;
	            Gen_OUT;
	            Gen_BIN;
	            Gen_HEX $PWD/$FN.text.bin;	
	            mv $PWD/$FN.hex $PWD/$FN.text.hex;             
	            Gen_HEX $PWD/$FN.data.bin;
	            mv $PWD/$FN.hex $PWD/$FN.data.hex;
	            Check_Isize $PWD/$FN.text.hex;
	            #Gen_TIC;     # useless .tic.c file, mark by JH
	            if [ ! -d $PWD/$FN ] ; then
	               mkdir $PWD/$FN
	            fi
	            mv $PWD/$FN.text.hex $PWD/$FN/$FN.tic.inst
	            #mv $PWD/$FN.tic.c    $PWD/$FN/$FN.tic.c 
	            rm -f $PWD/$FN.o
	            rm -f $PWD/$FN.out
	            rm -f $PWD/$FN.text.bin	 $PWD/$FN.data.bin
	            rm -f $PWD/$FN.text.hex	 $PWD/$FN.data.hex
	            echo "OK! covert `printf "\e"`[1;32m $FN.s `printf "\e"`[0m to `printf "\e"`[1;31m $FN.tic.inst  $FN.tic.c `printf "\e"`[0m is done!"
                echo " "
	            break;;
	   out2bin)
	            echo "**********************************************"
	            echo "Convert *.out To *.text.bin, *.data.bin       "
	            echo "**********************************************"
	            Check_Input out;	
	            Gen_BIN;	            
	            if [ ! -d $PWD/$FN ] ; then
	               mkdir $PWD/$FN
	            fi	            
	            mv $PWD/$FN.text.bin $PWD/$FN
	            mv $PWD/$FN.data.bin $PWD/$FN
	            rm -f $PWD/$FN.o
	            echo "OK! covert `printf "\e"`[1;32m $FN.out `printf "\e"`[0m to `printf "\e"`[1;31m $FN.text.bin  $FN.data.bin `printf "\e"`[0m is done!"
                echo " "
	            break;;
	   out2hex)
	            echo "**********************************************"
	            echo "Convert *.out To *.text.hex, *.data.hex       "
	            echo "**********************************************"
	            Check_Input out;
	            Gen_BIN;
	            Gen_HEX $PWD/$FN.text.bin;
	            mv $PWD/$FN.hex $PWD/$FN.text.hex; 
	            Gen_HEX $PWD/$FN.data.bin; 
	            mv $PWD/$FN.hex $PWD/$FN.data.hex;  
	            if [ ! -d $PWD/$FN ] ; then
	               mkdir $PWD/$FN
	            fi
	            mv $PWD/$FN.text.hex $PWD/$FN
	            mv $PWD/$FN.data.hex $PWD/$FN 
	            rm -f $PWD/$FN.o
	            rm -f $PWD/$FN.text.bin	 $PWD/$FN.data.bin 
	            echo "OK! covert `printf "\e"`[1;32m $FN.out `printf "\e"`[0m to `printf "\e"`[1;31m $FN.text.hex  $FN.data.hex `printf "\e"`[0m is done!"
                echo " "
	            break;;
	   out2tic)
	            echo "**********************************************"
	            echo "Convert *.out To *.tic.inst, *.tic.c            "
	            echo "**********************************************"
	            Check_Input out;
	            Gen_BIN;
	            Gen_HEX $PWD/$FN.text.bin;	
	            mv $PWD/$FN.hex $PWD/$FN.text.hex;             
	            Gen_HEX $PWD/$FN.data.bin;
	            mv $PWD/$FN.hex $PWD/$FN.data.hex;
	            Check_Isize $PWD/$FN.text.hex;
	            Gen_TIC;
	            if [ ! -d $PWD/$FN ] ; then
	               mkdir $PWD/$FN
	            fi
	            mv $PWD/$FN.text.hex $PWD/$FN/$FN.tic.inst
	            mv $PWD/$FN.tic.c    $PWD/$FN/$FN.tic.c 
	            rm -f $PWD/$FN.o
	            rm -f $PWD/$FN.text.bin	 $PWD/$FN.data.bin
	            rm -f $PWD/$FN.text.hex	 $PWD/$FN.data.hex
	            echo "OK! covert `printf "\e"`[1;32m $FN.out `printf "\e"`[0m to `printf "\e"`[1;31m $FN.tic.inst  $FN.tic.c `printf "\e"`[0m is done!"
                echo " "
	            break;;
	   bin2hex)
	            echo "**********************************************"
	            echo "Convert *.bin To *.hex                        "
	            echo "**********************************************"
	            Check_Input bin;
                Gen_HEX $PWD/$FN.bin;
	            if [ ! -d $PWD/$FN ] ; then
	               mkdir $PWD/$FN
	            fi
	            mv $PWD/$FN.hex $PWD/$FN
	            echo "OK! covert `printf "\e"`[1;32m $FN.bin `printf "\e"`[0m to `printf "\e"`[1;31m $FN.hex `printf "\e"`[0m is done!"
                echo " "
	            break;;	   
	   *)
	            echo "Error! Invalid Operation!"
                break;;
  esac
done