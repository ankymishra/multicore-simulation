#!/bin/bash

asm2inst="r"
### -----------------------------------------
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

### -----------------------------------------
# generate object file
Gen_OBJ()
{
  pacdsp-elf-as $PWD/$FN.s -horizontaledit -o $PWD/$FN.o
  if [ ! -e $PWD/$FN.o ] ; then
    echo "Error! No such $FN.o file exist!"  
    exit 1
  fi
};

### -----------------------------------------
# generate executable file
Gen_OUT()
{
  pacdsp-elf-ld $PWD/$FN.o -o $PWD/$FN.out
  if [ ! -e $PWD/$FN.out ] ; then
    echo "Error! No such $FN.out file exist!"  
    exit 1
  fi  
};

### -----------------------------------------
# seperate data section and text section from executable file into binary file
Gen_BIN()
{
  pacdsp-elf-objcopy -O binary -R .data $PWD/$FN.out $PWD/$FN.text.bin	
  #pacdsp-elf-objcopy -O binary -R .text $PWD/$FN.out $PWD/$FN.data.bin 
  if [ ! -e $PWD/$FN.text.bin ] ; then
     echo "Error! No such $FN.text.bin file exist!"  
     exit 1  
  fi  
};

### -----------------------------------------
# convert binary file to hexadecimal file
Gen_HEX()
{ 
  od -v -t x4 -w4 $1 | awk '{print $2}' > $PWD/$FN.hex 
  if [ ! -e $PWD/$FN.hex ] ; then
    echo "Error! No such $FN.hex file exist!"  
    exit 1
  fi 
};



### -----------------------------------------
function sim(){
  
  echo $fn > tmp.rf 
  
  FN=`awk -F "." '{print $1}' tmp.rf` 
  
  Check_Input asm;
  Gen_OBJ;
  Gen_OUT;
	Gen_BIN;
	Gen_HEX $PWD/$FN.text.bin;	
	
	
	mv $PWD/$FN.hex $PWD/tic_inst/$FN.tic.inst; 
	
	rm -f $PWD/$FN.o
	rm -f $PWD/$FN.out
	rm -f $PWD/$FN.text.bin
	
	echo $FN " OK! covert"
};

### ---------------------
if [ -n "$asm2inst" ]; then
echo "--- asm2inst ---";

if [ ! -d $PWD/tic_inst ] ; then
	mkdir $PWD/tic_inst
fi

for fn in `grep [A-Za-z0-9] ./asm.rf | sed 's/\r//g'`
do
  sim asm
done

rm -rf tmp.rf



fi