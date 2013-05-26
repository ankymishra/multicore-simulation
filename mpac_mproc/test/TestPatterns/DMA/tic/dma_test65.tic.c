/*1.  BustoDmem, para1: TR_WIDTH = 3, SC = 10, SI =  7, SAddr = 0x1, BSZ = 24, DC =  5, DI = 4, DAddr = 0x1.  */
/*               para2: TR_WIDTH = 2, SC = 10, SI =  7, SAddr = 0x0, BSZ = 24, DC =  5, DI = 4, DAddr = 0x0.  */
/*               para3: TR_WIDTH = 1, SC = 10, SI =  7, SAddr = 0x0, BSZ = 33, DC =  5, DI = 4, DAddr = 0x0.  */
/*               para4: TR_WIDTH = 0, SC =  3, SI = 23, SAddr = 0x0, BSZ = 18, DC =  5, DI = 4, DAddr = 0x0.  */

#include "header.h"
#include "ticmacros.h"

#define NO_Mask 0xFFFFFFFF /* 32 bits 1 */
#define All_Mask 0x00000000

int main()
{

	int i ;
	
  /* Flush Cache*/
  A(0x90A4001C);
  W(0x00000001); 	

  /* Data memory addressing mode (0: not interleaved 1: interleaved) */
  A(0x90A80008);
  W(0x00000000);
  
  /* Data memory access priority (0: Core>BIU>CFU 1: BIU>Core>CFU) */
  A(0x90A8000C);
  W(0x00000000);    
                 
  /* Base Address */
  A(0x90A80004);
  W(0x90A00000);

  /* DBGISR */
  A(0x90A0001C);
  W(0x10000000);

  /* EXCISR */
  A(0x90A00020);
  W(0x10000000);
  
  /* FIQISR */
  A(0x90A00024);
  W(0x10000000);

  /* IRQISR */
  A(0x90A00028);
  W(0x10000000); 
      
  /* Start address to PSCU */
  A(0x90A00000);
  W(0x10000000);
  
  /* Start Address to ICache */
  A(0x90A40008);
  W(0x10000000);
  
  /* Initial program size to ICache */
  A(0x90A4000C);
  W(0x00000B6C); /* Size x 1024bits */

  /* Miss program size to ICache */
  A(0x90A40018);
  W(0x00000003); /* Size x 1024bits */

  /* Configure ICache size*/
  A(0x90A40000);
  W(0x00000000);  
  
  /* Configure ICache to cahce/scratch pad mode*/
  A(0x90A40004);
  W(0x00000000);   
  
  /* Start ICache initialization*/
  A(0x90A40010);
  W(0x00000000); 
  
  /* Start the program operation  */ 
  A(0x90A00004);
  W(0x00000001);

  /* Control vector (two address vector followed by one read/write vector) */
  /* WAIT     = {Bit[11]}												   */
  /* HPROT    = {Bit[10:9], Bit[6:5]}									   */
  /* HLOCK    = {Bit[4]} 										   	 	   */
  /* HsizeGen = {Bit[3:2]}										    	   */
  A(0xC0000000);             
  for (i = 0; i <= 500; i++) 
    R(0x00000000,All_Mask);  
      A(0x25000000); W(0x00000000);
      A(0x25000004); W(0x00000000);
      
    /* Parameter 1 */
      A(0x25000010); W(0x00000000);
      A(0x25000014); W(0x00000000);
      A(0x25000018); W(0x00000000);
      A(0x2500001C); W(0x00000000);
    
    /* Parameter 2 */
      A(0x25000020); W(0x00000000);
      A(0x25000024); W(0x00000000);
      A(0x25000028); W(0x00000000);
      A(0x2500002C); W(0x00000000);
      A(0x25000030); W(0x00000000);

      
    /* Parameter 3 */
      A(0x25000040); W(0x00000000);
      A(0x25000044); W(0x00000000);
      A(0x25000048); W(0x00000000);
      A(0x2500004C); W(0x00000000);
      A(0x25000050); W(0x00000000);
      A(0x25000054); W(0x00000000);
      A(0x25000058); W(0x00000000);
      A(0x2500005C); W(0x00000000);
  /* Result check */
    /* Parameter 0 */
      A(0x25000000); R(0x03020100,0xFFFFFFFF);
      A(0x25000004); R(0x00000004,0x000000FF);
      
    /* Parameter 1 */
      A(0x25000010); R(0x13121110,0xFFFFFFFF);
      A(0x25000014); R(0x19161514,0xFFFFFFFF);
      A(0x25000018); R(0x1D1C1B1A,0xFFFFFFFF);
      A(0x2500001C); R(0x00221F1E,0x00FFFFFF);
    
    /* Parameter 2 */
      A(0x25000020); R(0x33323130,0xFFFFFFFF);
      A(0x25000024); R(0x3B363534,0xFFFFFFFF);
      A(0x25000028); R(0x3F3E3D3C,0xFFFFFFFF);
      A(0x2500002C); R(0x47464140,0xFFFFFFFF);
      A(0x25000030); R(0x4B4A4948,0xFFFFFFFF);

      
    /* Parameter 3 */
      A(0x25000040); R(0x54535251,0xFFFFFFFF);
      A(0x25000044); R(0x58575655,0xFFFFFFFF);
      A(0x25000048); R(0x5C5B5A59,0xFFFFFFFF);
      A(0x2500004C); R(0x63626160,0xFFFFFFFF);
      A(0x25000050); R(0x67666564,0xFFFFFFFF);
      A(0x25000054); R(0x6B6A6968,0xFFFFFFFF);
      A(0x25000058); R(0x7271706F,0xFFFFFFFF);
      A(0x2500005C); R(0x00007473,0x0000FFFF);
      
  E();
          
  return 0;  
  
} 
