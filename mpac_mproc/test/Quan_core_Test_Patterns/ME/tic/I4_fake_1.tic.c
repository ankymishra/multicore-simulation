#include "header.h"
#include "ticmacros.h"

#define NO_Mask 0xFFFFFFFF /* 32 bits 1 */
#define All_Mask 0x00000000

int main()
{



  /* Initial DATA */
  /* =================== */

  /* raw data */
  A(0x25000000); W(0x8c7217a3);

  A(0x25000004); W(0xf87ffc81);

  A(0x25000008); W(0x933baed3);

  A(0x2500000c); W(0xa5daa1b0);

  A(0x25000010); W(0xe9380e84);

  A(0x25000014); W(0xd199ba0a);

  A(0x25000018); W(0xeaa2c6a1);

  A(0x2500001c); W(0xd0a2ed2d);

  A(0x25000020); W(0x855c1404);

  A(0x25000024); W(0xe37ddc10);

  A(0x25000028); W(0x3a77b98a);

  A(0x2500002c); W(0xdfdf515a);

  A(0x25000030); W(0x6ac8185f);

  A(0x25000034); W(0x733b61d2);

  A(0x25000038); W(0x545dde27);

  A(0x2500003c); W(0xd024ffcb);

  A(0x25000040); W(0x23558113);

  A(0x25000044); W(0xe707d35d);

  A(0x25000048); W(0xe6217e8c);

  A(0x2500004c); W(0x2ec500cf);

  A(0x25000050); W(0xeb988e18);

  A(0x25000054); W(0x175ed4ef);

  A(0x25000058); W(0x7d6bbcb2);

  A(0x2500005c); W(0xcf4d90bb);

  A(0x25000060); W(0x6ef2a311);

  A(0x25000064); W(0x0255f976);

  A(0x25000068); W(0x46e87677);

  A(0x2500006c); W(0x8f75ae76);

  A(0x25000070); W(0x2b7a0d3c);

  A(0x25000074); W(0x9342d8e1);

  A(0x25000078); W(0x5011ae94);

  A(0x2500007c); W(0x4f1f5e3e);

  A(0x25000080); W(0x77bd1101);

  A(0x25000084); W(0x8279120b);

  A(0x25000088); W(0xfec96288);

  A(0x2500008c); W(0x4c8d3e10);

  A(0x25000090); W(0x2d77074b);

  A(0x25000094); W(0x74c0bae0);

  A(0x25000098); W(0xa6c4d168);

  A(0x2500009c); W(0x31f5e330);

  A(0x250000a0); W(0x00a9b2f5);

  A(0x250000a4); W(0x4c8222c4);

  A(0x250000a8); W(0x944a4b84);

  A(0x250000ac); W(0xd5e0d889);

  A(0x250000b0); W(0xbf0258df);

  A(0x250000b4); W(0x7a34c212);

  A(0x250000b8); W(0xc420f894);

  A(0x250000bc); W(0xd1f515dc);

  A(0x250000c0); W(0x8bd19ec7);

  A(0x250000c4); W(0x45d753c1);

  A(0x250000c8); W(0x28da219f);

  A(0x250000cc); W(0xd9fdbaf9);

  A(0x250000d0); W(0x2498ff12);

  A(0x250000d4); W(0x569eccc2);

  A(0x250000d8); W(0xa11abec5);

  A(0x250000dc); W(0x9a720fd3);

  A(0x250000e0); W(0x6f2543ae);

  A(0x250000e4); W(0x35b4fc96);

  A(0x250000e8); W(0x175e8e1e);

  A(0x250000ec); W(0x5bf05b49);

  A(0x250000f0); W(0x1d80895b);

  A(0x250000f4); W(0x1a731e55);

  A(0x250000f8); W(0xb0bb8ddd);

  A(0x250000fc); W(0x4a4b2d9c);

  /* PreRowPelY */
  A(0x25000100); W(0xb61c83d2);

  A(0x25000104); W(0x2a14ca46);

  A(0x25000108); W(0xe4a0134a);

  A(0x2500010c); W(0x47d907e9);

  A(0x25000110); W(0x8658e9e6);

  A(0x25000114); W(0x00000000);

  /* PreColPelY */
  A(0x25000118); W(0x0fde5ef5);

  A(0x2500011c); W(0xae0da011);

  A(0x25000120); W(0x3b94a366);

  A(0x25000124); W(0x559644a5);

  A(0x25000128); W(0x0000007d);

  A(0x2500012c); W(0x00000000);

  /* parameters setting */
  A(0x25000130); W(0x01a00f00);

  A(0x25000134); W(0x01180190);

  A(0x25000138); W(0x00000100);

  /* =================== */
  /* End of initial DATA */


  /* compare result */
  /* Keep reading CBUSY for delaying the result check */
  int i;

  A(0x24050008);
  for (i = 0; i <= 800; i++)
    R(0x00000000,All_Mask);

  /* Result */
  A(0x25000190); R(0x00003a5f,NO_Mask);
  /* Intra4x4PredMode */
  A(0x250001a0); R(0x05070207,NO_Mask);
  A(0x250001a4); R(0x06030708,NO_Mask);
  A(0x250001a8); R(0x04010203,NO_Mask);
  A(0x250001ac); R(0x06030606,NO_Mask);


  E();

  return 0;

}