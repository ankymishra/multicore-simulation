#include "header.h"
#include "ticmacros.h"

#define NO_Mask 0xFFFFFFFF /* 32 bits 1 */
#define All_Mask 0x00000000

int main()
{



  /* Initial DATA */
  /* =================== */

  /* Raw Cb */
  A(0x25000000); W(0x3c6db970);

  A(0x25000004); W(0xa1f6a2fc);

  A(0x25000008); W(0x8c3f6e1c);

  A(0x2500000c); W(0x5575cd6e);

  A(0x25000010); W(0x807cec88);

  A(0x25000014); W(0x0ab6bec3);

  A(0x25000018); W(0xdc594380);

  A(0x2500001c); W(0x71c1d217);

  A(0x25000020); W(0x2b873f35);

  A(0x25000024); W(0x6b4904e3);

  A(0x25000028); W(0xa87e8987);

  A(0x2500002c); W(0x1ba1210f);

  A(0x25000030); W(0xc21a88f0);

  A(0x25000034); W(0xafd4969d);

  A(0x25000038); W(0xc39f3cb0);

  A(0x2500003c); W(0xd5767f5e);

  /* Raw Cr */
  A(0x25000040); W(0x8b6e0770);

  A(0x25000044); W(0x5193459a);

  A(0x25000048); W(0x1ce17121);

  A(0x2500004c); W(0xe5180a47);

  A(0x25000050); W(0x7929f50e);

  A(0x25000054); W(0xd25fb923);

  A(0x25000058); W(0xc7cfc078);

  A(0x2500005c); W(0x4a278ca9);

  A(0x25000060); W(0x4ac0b25e);

  A(0x25000064); W(0xc90e99e9);

  A(0x25000068); W(0x9566e0ae);

  A(0x2500006c); W(0xd692d17a);

  A(0x25000070); W(0xfdb3775a);

  A(0x25000074); W(0x5b01e6c6);

  A(0x25000078); W(0xaee42e39);

  A(0x2500007c); W(0x679affe4);

  /* PreColPelCb */
  A(0x25000080); W(0x3e9bedf6);

  A(0x25000084); W(0x47165cbe);

  A(0x25000088); W(0x00000043);

  A(0x2500008c); W(0x00000000);

  /* PreColPelCr */
  A(0x25000090); W(0xdf289907);

  A(0x25000094); W(0x5c789193);

  A(0x25000098); W(0x0000005c);

  A(0x2500009c); W(0x00000000);

  /* PreRowPelCb */
  A(0x250000a0); W(0x2e716f86);

  A(0x250000a4); W(0xff9b349f);

  /* PreRowPelCr */
  A(0x250000a8); W(0x4b58278d);

  A(0x250000ac); W(0x882af814);

  /* parameters setting */
  A(0x250000b0); W(0x01900f00);

  A(0x250000b4); W(0x02800200);

  A(0x250000b8); W(0x00a00080);

  A(0x250000bc); W(0x00a80090);

  A(0x250000c0); W(0x00400000);

  /* =================== */
  /* End of initial DATA */


  /* compare result */
  /* Keep reading CBUSY for delaying the result check */
  int i;

  A(0x24050008);
  for (i = 0; i <= 200; i++)
    R(0x00000000,All_Mask);

  /* Result */
  A(0x25000190); R(0x00000000,NO_Mask);
  /* Residual Cb */
  A(0x25000200); R(0x002fffe6,NO_Mask);
  A(0x25000204); R(0xffb2ffe3,NO_Mask);
  A(0x25000208); R(0x00070061,NO_Mask);
  A(0x2500020c); R(0x0006005b,NO_Mask);
  A(0x25000210); R(0xffe4ff92,NO_Mask);
  A(0x25000214); R(0x0002ffb5,NO_Mask);
  A(0x25000218); R(0x0032ffd3,NO_Mask);
  A(0x2500021c); R(0xffbaffda,NO_Mask);
  A(0x25000220); R(0x0062fffe,NO_Mask);
  A(0x25000224); R(0xfff6fff2,NO_Mask);
  A(0x25000228); R(0x00230028,NO_Mask);
  A(0x2500022c); R(0xff6f001b,NO_Mask);
  A(0x25000230); R(0xffb9fff6,NO_Mask);
  A(0x25000234); R(0x0052ffcf,NO_Mask);
  A(0x25000238); R(0x0037ff7c,NO_Mask);
  A(0x2500023c); R(0xffd60026,NO_Mask);
  A(0x25000240); R(0xffe1ffd7,NO_Mask);
  A(0x25000244); R(0xffcd0029,NO_Mask);
  A(0x25000248); R(0xff870066,NO_Mask);
  A(0x2500024c); R(0xffeeffcc,NO_Mask);
  A(0x25000250); R(0x002b0029,NO_Mask);
  A(0x25000254); R(0x004a0020,NO_Mask);
  A(0x25000258); R(0xffa4ff92,NO_Mask);
  A(0x2500025c); R(0xff9e0024,NO_Mask);
  A(0x25000260); R(0x002a0092,NO_Mask);
  A(0x25000264); R(0x0064ffbc,NO_Mask);
  A(0x25000268); R(0x00190020,NO_Mask);
  A(0x2500026c); R(0x00320057,NO_Mask);
  A(0x25000270); R(0xffde0052,NO_Mask);
  A(0x25000274); R(0x00650041,NO_Mask);
  A(0x25000278); R(0x0002ffe1,NO_Mask);
  A(0x2500027c); R(0x0058fff9,NO_Mask);
  /* Residual Cr */
  A(0x25000280); R(0xffa70010,NO_Mask);
  A(0x25000284); R(0x002b000e,NO_Mask);
  A(0x25000288); R(0xffd5002a,NO_Mask);
  A(0x2500028c); R(0xffe10023,NO_Mask);
  A(0x25000290); R(0x0011ffc1,NO_Mask);
  A(0x25000294); R(0xffbc0081,NO_Mask);
  A(0x25000298); R(0xff9affd7,NO_Mask);
  A(0x2500029c); R(0x0075ffa8,NO_Mask);
  A(0x250002a0); R(0x0095ffae,NO_Mask);
  A(0x250002a4); R(0x0019ffc9,NO_Mask);
  A(0x250002a8); R(0x0049ffb3,NO_Mask);
  A(0x250002ac); R(0x0062ffef,NO_Mask);
  A(0x250002b0); R(0x00600018,NO_Mask);
  A(0x250002b4); R(0x0067006f,NO_Mask);
  A(0x250002b8); R(0x001c0039,NO_Mask);
  A(0x250002bc); R(0xffdaffb7,NO_Mask);
  A(0x250002c0); R(0x0034ffe0,NO_Mask);
  A(0x250002c4); R(0xffcc0042,NO_Mask);
  A(0x250002c8); R(0x00220072,NO_Mask);
  A(0x250002cc); R(0x0052ff97,NO_Mask);
  A(0x250002d0); R(0x00620030,NO_Mask);
  A(0x250002d4); R(0x0017ffe8,NO_Mask);
  A(0x250002d8); R(0x005a0003,NO_Mask);
  A(0x250002dc); R(0x005f001b,NO_Mask);
  A(0x250002e0); R(0xfff9ffdc,NO_Mask);
  A(0x250002e4); R(0x007f0035,NO_Mask);
  A(0x250002e8); R(0x006f004f,NO_Mask);
  A(0x250002ec); R(0xffe4ff8a,NO_Mask);
  A(0x250002f0); R(0xffb0ffbb,NO_Mask);
  A(0x250002f4); R(0x00300066,NO_Mask);
  A(0x250002f8); R(0x0088006d,NO_Mask);
  A(0x250002fc); R(0xfff00023,NO_Mask);


  E();

  return 0;

}
