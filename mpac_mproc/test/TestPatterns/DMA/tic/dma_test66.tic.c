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
      A(0x25000008); W(0x00000000);
      A(0x2500000C); W(0x00000000);
      A(0x25000010); W(0x00000000);
      
    /* Parameter 1 */
      A(0x25000020); W(0x00000000);
      A(0x25000024); W(0x00000000);
      A(0x25000028); W(0x00000000);
      A(0x2500002C); W(0x00000000);
      A(0x25000030); W(0x00000000);
      A(0x25000034); W(0x00000000);
      A(0x25000038); W(0x00000000);
      A(0x2500003C); W(0x00000000);
      A(0x25000040); W(0x00000000);
      A(0x25000044); W(0x00000000);
      A(0x25000048); W(0x00000000);
      A(0x2500004C); W(0x00000000);
      A(0x25000050); W(0x00000000);
      A(0x25000054); W(0x00000000);
      A(0x25000058); W(0x00000000);
      A(0x2500005C); W(0x00000000);
      A(0x25000060); W(0x00000000);
      A(0x25000064); W(0x00000000);
      A(0x25000068); W(0x00000000);
      A(0x2500006C); W(0x00000000);
      A(0x25000070); W(0x00000000);
      A(0x25000074); W(0x00000000);
      A(0x25000078); W(0x00000000);
      A(0x2500007C); W(0x00000000);
      A(0x25000080); W(0x00000000);
      A(0x25000084); W(0x00000000);
      A(0x25000088); W(0x00000000);
      A(0x2500008C); W(0x00000000);
   
    /* Parameter 2 */
      A(0x25000090); W(0x00000000);
      A(0x25000094); W(0x00000000);
      A(0x25000098); W(0x00000000);
      A(0x2500009C); W(0x00000000);  
  /* Result check */
    /* Parameter 0 */
      A(0x25000000); R(0x03020100,0xFFFFFFFF);
      A(0x25000004); R(0x07060504,0xFFFFFFFF);
      A(0x25000008); R(0x0B0A0908,0xFFFFFFFF);
      A(0x2500000C); R(0x1211100C,0xFFFFFFFF);
      A(0x25000010); R(0x00001413,0x0000FFFF);
      
    /* Parameter 1 */
      A(0x25000020); R(0x23222120,0xFFFFFFFF);
      A(0x25000024); R(0x27262524,0xFFFFFFFF);
      A(0x25000028); R(0x2B2A2928,0xFFFFFFFF);
      A(0x2500002C); R(0x2F2E2D2C,0x00FFFFFF);
      A(0x25000030); R(0x33323130,0xFFFFFFFF);
      A(0x25000034); R(0x37363534,0xFFFFFFFF);
      A(0x25000038); R(0x3B3A3938,0xFFFFFFFF);
      A(0x2500003C); R(0x3F3E3D3C,0x00FFFFFF);
      A(0x25000040); R(0x43424140,0xFFFFFFFF);
      A(0x25000044); R(0x47464544,0xFFFFFFFF);
      A(0x25000048); R(0x4B4A4948,0xFFFFFFFF);
      A(0x2500004C); R(0x4F4E4D4C,0x00FFFFFF);
      A(0x25000050); R(0x53525150,0xFFFFFFFF);
      A(0x25000054); R(0x57565554,0xFFFFFFFF);
      A(0x25000058); R(0x5B5A5958,0xFFFFFFFF);
      A(0x2500005C); R(0x5F5E5D5C,0x00FFFFFF);
      A(0x25000060); R(0x63626160,0xFFFFFFFF);
      A(0x25000064); R(0x67666564,0xFFFFFFFF);
      A(0x25000068); R(0x6B6A6968,0xFFFFFFFF);
      A(0x2500006C); R(0x6F6E6D6C,0x00FFFFFF);
      A(0x25000070); R(0x73727170,0xFFFFFFFF);
      A(0x25000074); R(0x77767574,0xFFFFFFFF);
      A(0x25000078); R(0x7B7A7978,0xFFFFFFFF);
      A(0x2500007C); R(0x7F7E7D7C,0x00FFFFFF);
      A(0x25000080); R(0x83828180,0xFFFFFFFF);
      A(0x25000084); R(0x87868584,0xFFFFFFFF);
      A(0x25000088); R(0x8B8A8988,0xFFFFFFFF);
      A(0x2500008C); R(0x8F8E8D8C,0x00FFFFFF);
   
    /* Parameter 2 */
      A(0x25000090); R(0x93929190,0xFFFFFFFF);
      A(0x25000094); R(0x97969594,0xFFFFFFFF);
      A(0x25000098); R(0x9C9A9998,0xFFFFFFFF);
      A(0x2500009C); R(0x0000009D,0x000000FF);

  E();
          
  return 0;  
  
} 
