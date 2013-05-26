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
  
   /*Set ch1 Linked List item2*/
  /*SAR*/
  A(0x2400B000);  W(0x08000077);
  
  /*DAR*/
  A(0x2400B004);  W(0x00072000);
  
  /*SGR*/
  A(0x2400B008);  W(0x00A0000D);
  
  /*DSR*/
  A(0x2400B00C);  W(0x00B00012);
  
  /*CTL*/
  A(0x2400B010);  W(0x0001F30C);
  
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
  for (i = 0; i <= 200; i++) 
    R(0x00000000,All_Mask);   
       
  A(0xC0000000);             
  for (i = 0; i <= 1000; i++) 
    R(0x00000000,All_Mask);
/* Parameter 2 */
  A(0x240020A0); W(0x00000000);
  A(0x240020A4); W(0x00000000);
  A(0x240020A8); W(0x00000000);
  A(0x240020AC); W(0x00000000);
  A(0x240020B0); W(0x00000000);
  A(0x240020B4); W(0x00000000);
  A(0x240020B8); W(0x00000000);
  A(0x240020BC); W(0x00000000);
  A(0x240020C0); W(0x00000000);
  A(0x240020C4); W(0x00000000);
  A(0x240020C8); W(0x00000000);
  A(0x240020CC); W(0x00000000);    
  /* Result check */
  /* Parameter 2 */
  A(0x240020A0); R(0x00000000,0x00000000);
  A(0x240020A4); R(0x34333200,0xFFFFFF00);
  A(0x240020A8); R(0x39373635,0xFFFFFFFF);
  A(0x240020AC); R(0x3D3C3B3A,0xFFFFFFFF);
  A(0x240020B0); R(0x4241403E,0xFFFFFFFF);
  A(0x240020B4); R(0x47454443,0xFFFFFFFF);
  A(0x240020B8); R(0x4B4A4948,0xFFFFFFFF);
  A(0x240020BC); R(0x504F4E4C,0xFFFFFFFF);
  A(0x240020C0); R(0x55535251,0xFFFFFFFF);
  A(0x240020C4); R(0x59585756,0xFFFFFFFF);
  A(0x240020C8); R(0x5E5D5C5A,0xFFFFFFFF);
  A(0x240020CC); R(0x6361605F,0xFFFFFFFF);
  
  A(0xC0000000);             
  for (i = 0; i <= 100; i++) 
    R(0x00000000,All_Mask);

  E();
          
  return 0;  
  
} 
