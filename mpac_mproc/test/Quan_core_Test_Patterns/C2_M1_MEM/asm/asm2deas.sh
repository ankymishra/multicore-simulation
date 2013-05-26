#!/bin/bash

# ====================================================================================
# generate object file
Gen_OBJ()
{
  pacdsp-elf-as $PWD/$FN.s -horizontaledit -o $PWD/$FN.o
  if [ ! -e $PWD/$FN.o ] ; then
    echo "Error! No such $FN.o file exist!"  
    exit 1
  fi
};

# ====================================================================================
Gen_OUT()
{
  pacdsp-elf-ld $PWD/$FN.o -o $PWD/$FN.out
  if [ ! -e $PWD/$FN.out ] ; then
    echo "Error! No such $FN.out file exist!"  
    exit 1
  fi 
  
  pacdsp-elf-objdump -D $PWD/$FN.out > $PWD/DIS_AS/$FN.dias
  if [ ! -e $PWD/DIS_AS/$FN.dias ] ; then
    echo "Error! No such $FN.dias file exist!"  
    exit 1
  fi 
   
};

# ====================================================================================
if [ $# -ne 1 ] ; then
   echo "Usage : pacdsp-dis_assembler.sh INPUT_ASM_File_Name"
   exit 1
fi

FN="$1"

if [ ! -d $PWD/DIS_AS ] ; then
  mkdir $PWD/DIS_AS
fi

Gen_OBJ;
Gen_OUT;
rm -f $PWD/$FN.o
rm -f $PWD/$FN.out

echo "OK! covert `printf "\e"`[1;32m $FN.s `printf "\e"`[0m to `printf "\e"`[1;31m $FN.dias `printf "\e"`[0m is done!"
echo " "
