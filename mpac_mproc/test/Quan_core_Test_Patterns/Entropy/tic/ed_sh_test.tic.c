#include "header.h"
#include "ticmacros.h"

#define NO_Mask 0xFFFFFFFF /* 32 bits 1 */
#define All_Mask 0x00000000

int main()
{
	
  int i ;

  /* Initial DATA */
  /* =================== */
  /* InputParamsBaseAddr */
	A(0x25000000);W(0x00280020);
	A(0x25000004);W(0x00500030);
	A(0x25000008);W(0x01100060);
	A(0x2500000C);W(0x00000440);
	A(0x25000010);W(0x00000800);
	A(0x25000014);W(0x00000000);

  /* SPSBaseAddr */
  A(0x25000020);W(0x00090501);
  A(0x25000024);W(0x0000010A);

  /* PPSBaseAddr */
  A(0x25000028);W(0x08070001);

  /* SlicdHeaderBaseAddr */
  A(0x25000030);W(0x00000000);
  A(0x25000034);W(0x00000000);
  A(0x25000038);W(0x00000000);
  A(0x2500003C);W(0x00000000);
  A(0x25000040);W(0x00000000);

  /* BitstreamStartBaseAddr */
  A(0x25000440);W(0x0040019a);
  A(0x25000444);W(0x00003e03);



  A(0x90A0F000);
  for (i = 0; i <= 100; i++)
    R(0x00000000,All_Mask);

  /* Result check */
  /* SlicdHeaderBaseAddr */
  A(0x25000030);R(0x00050807,NO_Mask);
  A(0x25000034);R(0x00010001,NO_Mask);
  A(0x25000038);R(0x00000000,NO_Mask);
  A(0x2500003C);R(0x000000E7,NO_Mask);
  A(0x25000040);R(0x00000000,NO_Mask);

  /* BitstreamEndBaseAddr */
  A(0x25000018);R(0x002F0440,NO_Mask);

  E();
          
  return 0;  
  
}  
