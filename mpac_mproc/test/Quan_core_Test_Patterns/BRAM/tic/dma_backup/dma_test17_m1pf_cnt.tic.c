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
  for (i = 0; i <= 2000; i++) 
    R(0x00000000,All_Mask);  
    /* Parameter 0 */
  A(0x24007000); W(0x00000000);
  A(0x24007004); W(0x00000000);
  A(0x24007008); W(0x00000000);
  A(0x2400700C); W(0x00000000);
  A(0x24007010); W(0x00000000);
  A(0x24007014); W(0x00000000);
  A(0x24007018); W(0x00000000);
  A(0x2400701C); W(0x00000000);
  A(0x24007020); W(0x00000000);
  A(0x24007024); W(0x00000000);
  A(0x24007028); W(0x00000000);
  A(0x2400702C); W(0x00000000);
  /* Parameter 1 */
  A(0x240050E0); W(0x00000000);
  A(0x240050E4); W(0x00000000);
  A(0x240050E8); W(0x00000000);
  A(0x240050EC); W(0x00000000);
  A(0x240050F0); W(0x00000000);
  A(0x240050F4); W(0x00000000);
  A(0x240050F8); W(0x00000000);
  A(0x240050FC); W(0x00000000);
  A(0x24005100); W(0x00000000);
  A(0x24005104); W(0x00000000);
  A(0x24005108); W(0x00000000);
  A(0x2400510C); W(0x00000000);
  A(0x24005110); W(0x00000000);
  A(0x24005114); W(0x00000000);
  A(0x24005118); W(0x00000000);
  A(0x2400511C); W(0x00000000);
  A(0x24005120); W(0x00000000);
  /* Parameter 2 */
  A(0x24000130); W(0x00000000);
  A(0x24000134); W(0x00000000);
  A(0x24000138); W(0x00000000);
  A(0x2400013C); W(0x00000000);
  A(0x24000140); W(0x00000000);
  A(0x24000144); W(0x00000000);
  A(0x24000148); W(0x00000000);
  A(0x2400014C); W(0x00000000);
  A(0x24000150); W(0x00000000);
  A(0x24000154); W(0x00000000);
  A(0x24000158); W(0x00000000);
  A(0x2400015C); W(0x00000000); 
  A(0x24000160); W(0x00000000);
  A(0x24000164); W(0x00000000);
  A(0x24000168); W(0x00000000);
  A(0x2400016C); W(0x00000000);
  A(0x24000170); W(0x00000000);
  A(0x24000174); W(0x00000000);
  A(0x24000178); W(0x00000000);
  A(0x2400017C); W(0x00000000);
  A(0x24000180); W(0x00000000);
  A(0x24000184); W(0x00000000);
  /* Result check */
  /* Parameter 0 */
  A(0x24007000); R(0x00000000,0x00000000);
  A(0x24007004); R(0x06050403,0xFFFFFFFF);
  A(0x24007008); R(0x1E090807,0xFFFFFFFF);
  A(0x2400700C); R(0x00000000,0x00000000);
  A(0x24007010); R(0x00000000,0x00000000);
  A(0x24007014); R(0x201F0000,0xFFFF0000);
  A(0x24007018); R(0x24232221,0xFFFFFFFF);
  A(0x2400701C); R(0x00003A39,0x0000FFFF);
  A(0x24007020); R(0x00000000,0x00000000);
  A(0x24007024); R(0x00000000,0x00000000);
  A(0x24007028); R(0x3E3D3C3B,0xFFFFFFFF);
  A(0x2400702C); R(0x5655543F,0xFFFFFFFF);
  /* Parameter 1 */
  A(0x240050E0); R(0xA6A5A4A3,0xFFFFFFFF);
  A(0x240050E4); R(0xAAA9A8A7,0xFFFFFFFF);
  A(0x240050E8); R(0x000000AD,0x000000FF);
  A(0x240050EC); R(0xB1B0AFAE,0xFFFFFFFF);
  A(0x240050F0); R(0xB7B4B3B2,0xFFFFFFFF);
  A(0x240050F4); R(0x000000B8,0x000000FF);
  A(0x240050F8); R(0xBCBBBAB9,0xFFFFFFFF);
  A(0x240050FC); R(0xC2C1BEBD,0xFFFFFFFF);
  A(0x24005100); R(0x000000C3,0x000000FF);
  A(0x24005104); R(0xC7C6C5C4,0xFFFFFFFF);
  A(0x24005108); R(0xCDCCCBC8,0xFFFFFFFF);
  A(0x2400510C); R(0x000000CE,0x000000FF);
  A(0x24005110); R(0xD2D1D0CF,0xFFFFFFFF);
  A(0x24005114); R(0xD8D7D6D5,0xFFFFFFFF);
  A(0x24005118); R(0x000000D9,0x000000FF);
  A(0x2400511C); R(0xDFDCDBDA,0xFFFFFFFF);
  A(0x24005120); R(0xE3E2E1E0,0xFFFFFFFF);
  /* Parameter 2 */
  A(0x24000130); R(0x00000000,0x00000000);
  A(0x24000134); R(0xA8A7A600,0xFFFFFF00);
  A(0x24000138); R(0xACABAAA9,0xFFFFFFFF);
  A(0x2400013C); R(0xB0AFAEAD,0xFFFFFFFF);
  A(0x24000140); R(0xB4B3B2B1,0xFFFFFFFF);
  A(0x24000144); R(0xB8B7B6B5,0xFFFFFFFF);
  A(0x24000148); R(0xBBBA00B9,0xFFFF00FF);
  A(0x2400014C); R(0xBFBEBDBC,0xFFFFFFFF);
  A(0x24000150); R(0xC3C2C1C0,0xFFFFFFFF);
  A(0x24000154); R(0xC7C6C5C4,0xFFFFFFFF);
  A(0x24000158); R(0xCBCAC9C8,0xFFFFFFFF);
  A(0x2400015C); R(0xCE00CDCC,0xFF00FFFF); 
  A(0x24000160); R(0xD2D1D0CF,0xFFFFFFFF);
  A(0x24000164); R(0xD6D5D4D3,0xFFFFFFFF);
  A(0x24000168); R(0xDAD9D8D7,0xFFFFFFFF);
  A(0x2400016C); R(0xDEDDDCDB,0xFFFFFFFF);
  A(0x24000170); R(0x00E1E0DF,0x00FFFFFF);
  A(0x24000174); R(0xE5E4E3E2,0xFFFFFFFF);
  A(0x24000178); R(0xE9E8E7E6,0xFFFFFFFF);
  A(0x2400017C); R(0xEDECEBEA,0xFFFFFFFF);
  A(0x24000180); R(0xF1F0EFEE,0xffFFFFFF);
  A(0x24000184); R(0xF5F4F3F2,0xFFFFFFFF);

  A(0x24059000); R(0x00000115,0xFFFFFFFF);
  A(0x24059004); R(0x00000111,0xFFFFFFFF);
  A(0x24059008); R(0x00000008,0xFFFFFFFF);
  A(0x2405900C); R(0x00000032,0xFFFFFFFF);      
 
  E();
          
  return 0;  
  
} 
