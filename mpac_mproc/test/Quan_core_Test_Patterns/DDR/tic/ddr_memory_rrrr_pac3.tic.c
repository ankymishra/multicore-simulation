core3begin
//Write data to 25005000 to polling.
A(0x25015000); W(0x12121212);
\\Write data to DDR Memory;
A(0x300013C0); W(0x3005F001,NO_Mask);
A(0x300013C4); W(0x3005F01A,NO_Mask);
A(0x300013C8); W(0x3005F000,NO_Mask);
A(0x300013CC); W(0x3005F01A,NO_Mask);
A(0x30001380); W(0x3005F000,NO_Mask);
A(0x30001384); W(0x3005F01A,NO_Mask);
A(0x30001388); W(0x3005F000,NO_Mask);
A(0x3000138C); W(0x3005F01A,NO_Mask);
A(0x300013F0); W(0x3005F000,NO_Mask);
A(0x300013F4); W(0x3005F01A,NO_Mask);
A(0x300013F8); W(0x3005F000,NO_Mask);
A(0x300013FC); W(0x3005F01A,NO_Mask);
A(0x300013A0); W(0x3005F000,NO_Mask);
A(0x300013A4); W(0x3005F01A,NO_Mask);
A(0x300013A8); W(0x3005F000,NO_Mask);
A(0x300013AC); W(0x3005F01A,NO_Mask);

\\Verification;
\\Read data from M2 Memory;
A(0x243013C0); R(0x3005F001);
A(0x243013C4); R(0x3005F01A);
A(0x243013C8); R(0x3005F000);
A(0x243013CC); R(0x3005F01A);
A(0x24301380); R(0x3005F000);
A(0x24301384); R(0x3005F01A);
A(0x24301388); R(0x3005F000);
A(0x2430138C); R(0x3005F01A);
A(0x243013F0); R(0x3005F000);
A(0x243013F4); R(0x3005F01A);
A(0x243013F8); R(0x3005F000);
A(0x243013FC); R(0x3005F01A);
A(0x243013A0); R(0x3005F000);
A(0x243013A4); R(0x3005F01A);
A(0x243013A8); R(0x3005F000);
A(0x243013AC); R(0x3005F01A);

//MB1
A(0x300A2000); W(0x55229988,NO_Mask); 
A(0x300A2780); W(0x11223344,NO_Mask);
A(0x300A2F00); W(0x55687abc,NO_Mask);
A(0x300A3680); W(0x76854321,NO_Mask);

//MB2
A(0x300A2004); W(0x11223344,NO_Mask); 
A(0x300A2784); W(0x56789abc,NO_Mask);
A(0x300A2F04); W(0x55556666,NO_Mask);
A(0x300A3684); W(0x77778888,NO_Mask);

//MB3
A(0x300A2008); W(0x55667788,NO_Mask); 
A(0x300A2788); W(0x44444444,NO_Mask);
A(0x300A2F08); W(0x88888888,NO_Mask);
A(0x300A3688); W(0x99999999,NO_Mask);

//MB4
A(0x300A200C); W(0x55667788,NO_Mask); 
A(0x300A278C); W(0x44444444,NO_Mask);
A(0x300A2F0C); W(0x88888888,NO_Mask);
A(0x300A368C); W(0x99999999,NO_Mask);

//MB5
A(0x300A2010); W(0x55667788,NO_Mask); 
A(0x300A2790); W(0x99887766,NO_Mask);
A(0x300A2F10); W(0xaabbccdd,NO_Mask);
A(0x300A3690); W(0xccddeeff,NO_Mask);

//MB6
A(0x300A2014); W(0x44556677,NO_Mask); 
A(0x300A2794); W(0x99556644,NO_Mask);
A(0x300A2F14); W(0x00005555,NO_Mask);
A(0x300A3694); W(0x55550000,NO_Mask);

//MB7
A(0x300A2018); W(0x99995555,NO_Mask); 
A(0x300A2798); W(0xbbaaccdd,NO_Mask);
A(0x300A2F18); W(0x66664444,NO_Mask);
A(0x300A3698); W(0x778899aa,NO_Mask);

//MB8
A(0x300A201C); W(0x11111111,NO_Mask); 
A(0x300A279C); W(0x12345678,NO_Mask);
A(0x300A2F1C); W(0x87654321,NO_Mask);
A(0x300A369C); W(0x11111111,NO_Mask);

//MB9
A(0x300A2020); W(0x22222222,NO_Mask); 
A(0x300A27A0); W(0x44446666,NO_Mask);
A(0x300A2F20); W(0x55557777,NO_Mask);
A(0x300A36A0); W(0x22222222,NO_Mask);

//MB10
A(0x300A2024); W(0x33333333,NO_Mask); 
A(0x300A27A4); W(0xeeeeaaaa,NO_Mask);
A(0x300A2F24); W(0xaaaabbbb,NO_Mask);
A(0x300A36A4); W(0x33333333,NO_Mask);

//MB11
A(0x300A2028); W(0x44444444,NO_Mask); 
A(0x300A27A8); W(0x00001111,NO_Mask);
A(0x300A2F28); W(0x22220000,NO_Mask);
A(0x300A36A8); W(0x77777777,NO_Mask);

//MB12
A(0x300A202C); W(0x88888888,NO_Mask); 
A(0x300A27AC); W(0xaaaa1111,NO_Mask);
A(0x300A2F2C); W(0x2222aaaa,NO_Mask);
A(0x300A36AC); W(0x99999999,NO_Mask);

//MB13
A(0x300A2030); W(0xccccdddd,NO_Mask); 
A(0x300A27B0); W(0x99991111,NO_Mask);
A(0x300A2F30); W(0x22229999,NO_Mask);
A(0x300A36B0); W(0xaaaa4444,NO_Mask);

//MB14
A(0x300A2034); W(0xffff0000,NO_Mask); 
A(0x300A27B4); W(0xaaaa2222,NO_Mask);
A(0x300A2F34); W(0x2222bbbb,NO_Mask);
A(0x300A36B4); W(0x0000dddd,NO_Mask);

//MB15
A(0x300A2038); W(0xddddaaaa,NO_Mask); 
A(0x300A27B8); W(0x11111111,NO_Mask);
A(0x300A2F38); W(0x33333333,NO_Mask);
A(0x300A36B8); W(0xaaaadddd,NO_Mask);

//MB16
A(0x300A203C); W(0x99999999,NO_Mask); 
A(0x300A27BC); W(0x55555555,NO_Mask);
A(0x300A2F3C); W(0x77777777,NO_Mask);
A(0x300A36BC); W(0xffffffff,NO_Mask);


//Chroma
//MB1 4x2
A(0x300B0000); W(0x11223344,NO_Mask); 
A(0x300B0780); W(0x55556666,NO_Mask); 

//MB2 4x2
A(0x300B0004); W(0x99995555,NO_Mask); 
A(0x300B0784); W(0x77886655,NO_Mask); 

//MB3 4x2
A(0x300B0008); W(0x11112222,NO_Mask); 
A(0x300B0788); W(0x33334444,NO_Mask); 

//MB4 4x2
A(0x300B000C); W(0x55557777,NO_Mask); 
A(0x300B078C); W(0x44446666,NO_Mask); 

//MB5 4x2
A(0x300B0010); W(0x99998888,NO_Mask); 
A(0x300B0790); W(0x11112222,NO_Mask); 

//MB6 4x2
A(0x300B0014); W(0x00009999,NO_Mask); 
A(0x300B0794); W(0x88889999,NO_Mask); 

//MB7 4x2
A(0x300B0018); W(0x77779999,NO_Mask); 
A(0x300B0798); W(0x8888aaaa,NO_Mask); 

//MB8 4x2
A(0x300B001C); W(0x66664444,NO_Mask); 
A(0x300B079C); W(0x11117777,NO_Mask); 

//MB9 4x2
A(0x300B0020); W(0x55555555,NO_Mask); 
A(0x300B07A0); W(0x22222222,NO_Mask); 

//MB10 4x2
A(0x300B0024); W(0xffffffff,NO_Mask); 
A(0x300B07A4); W(0x11111111,NO_Mask); 

//MB11 4x2
A(0x300B0028); W(0xdddddddd,NO_Mask); 
A(0x300B07A8); W(0x44445555,NO_Mask); 

//MB12 4x2
A(0x300B002C); W(0x55558888,NO_Mask); 
A(0x300B07AC); W(0x11114444,NO_Mask); 

//MB13 4x2
A(0x300B0030); W(0x0000ffff,NO_Mask); 
A(0x300B07B0); W(0xffff0000,NO_Mask); 

//MB14 4x2
A(0x300B0034); W(0xccccffff,NO_Mask); 
A(0x300B07B4); W(0xffffdddd,NO_Mask); 

//MB15 4x2
A(0x300B0038); W(0x66665555,NO_Mask); 
A(0x300B07B8); W(0x99997777,NO_Mask); 

//MB16 4x2
A(0x300B003C); W(0x66665555,NO_Mask); 
A(0x300B07BC); W(0xaaaacccc,NO_Mask); 


//M1_Luma_result
//No.1 Luma 4x4MB
A(0x24300000); R(0x55229988);
A(0x24300004); R(0x11223344);
A(0x24300008); R(0x55687abc);
A(0x2430000C); R(0x76854321);
//No.2 Luma 4x4MB
A(0x24300010); R(0x11223344);
A(0x24300014); R(0x56789abc);
A(0x24300018); R(0x55556666);
A(0x2430001C); R(0x77778888);
//No.3 Luma 4x4MB
A(0x24300020); R(0x55667788);
A(0x24300024); R(0x44444444);
A(0x24300028); R(0x88888888);
A(0x2430002C); R(0x99999999);
//No.4 Luma 4x4MB
A(0x24300030); R(0x55667788);
A(0x24300034); R(0x44444444);
A(0x24300038); R(0x88888888);
A(0x2430003C); R(0x99999999);
//No.5 Luma 4x4MB
A(0x24300040); R(0x55667788);
A(0x24300044); R(0x99887766);
A(0x24300048); R(0xaabbccdd);
A(0x2430004C); R(0xccddeeff);
//No.6 Luma 4x4MB
A(0x24300050); R(0x44556677);
A(0x24300054); R(0x99556644);
A(0x24300058); R(0x00005555);
A(0x2430005C); R(0x55550000);
//No.7 Luma 4x4MB
A(0x24300060); R(0x99995555);
A(0x24300064); R(0xbbaaccdd);
A(0x24300068); R(0x66664444);
A(0x2430006C); R(0x778899aa);
//No.8 Luma 4x4MB
A(0x24300070); R(0x11111111);
A(0x24300074); R(0x12345678);
A(0x24300078); R(0x87654321);
A(0x2430007C); R(0x11111111);
//No.9 Luma 4x4MB
A(0x24300080); R(0x22222222);
A(0x24300084); R(0x44446666);
A(0x24300088); R(0x55557777);
A(0x2430008C); R(0x22222222);
//No.10 Luma 4x4MB
A(0x24300090); R(0x33333333);
A(0x24300094); R(0xeeeeaaaa);
A(0x24300098); R(0xaaaabbbb);
A(0x2430009C); R(0x33333333);
//No.11 Luma 4x4MB
A(0x243000A0); R(0x44444444);
A(0x243000A4); R(0x00001111);
A(0x243000A8); R(0x22220000);
A(0x243000AC); R(0x77777777);
//No.12 Luma 4x4MB
A(0x243000B0); R(0x88888888);
A(0x243000B4); R(0xaaaa1111);
A(0x243000B8); R(0x2222aaaa);
A(0x243000BC); R(0x99999999);
//No.13 Luma 4x4MB
A(0x243000C0); R(0xccccdddd);
A(0x243000C4); R(0x99991111);
A(0x243000C8); R(0x22229999);
A(0x243000CC); R(0xaaaa4444);
//No.14 Luma 4x4MB
A(0x243000D0); R(0xffff0000);
A(0x243000D4); R(0xaaaa2222);
A(0x243000D8); R(0x2222bbbb);
A(0x243000DC); R(0x0000dddd);
//No.15 Luma 4x4MB
A(0x243000E0); R(0xddddaaaa);
A(0x243000E4); R(0x11111111);
A(0x243000E8); R(0x33333333);
A(0x243000EC); R(0xaaaadddd);
//No.16 Luma 4x4MB
A(0x243000F0); R(0x99999999);
A(0x243000F4); R(0x55555555);
A(0x243000F8); R(0x77777777);
A(0x243000FC); R(0xffffffff);

//M1_Chroma_result    
//No.1 Chroma 4x2MB 
A(0x24301000); R(0x11223344);
A(0x24301004); R(0x55556666);
//No.2 Chroma 4x2MB 
A(0x24301008); R(0x99995555);
A(0x2430100C); R(0x77886655);
//No.3 Chroma 4x2MB 
A(0x24301010); R(0x11112222);
A(0x24301014); R(0x33334444);
//No.4 Chroma 4x2MB 
A(0x24301018); R(0x55557777);
A(0x2430101C); R(0x44446666);
//No.5 Chroma 4x2MB 
A(0x24301020); R(0x99998888);
A(0x24301024); R(0x11112222);
//No.6 Chroma 4x2MB 
A(0x24301028); R(0x00009999);
A(0x2430102C); R(0x88889999);
//No.7 Chroma 4x2MB 
A(0x24301030); R(0x77779999);
A(0x24301034); R(0x8888aaaa);
//No.8 Chroma 4x2MB 
A(0x24301038); R(0x66664444);
A(0x2430103C); R(0x11117777);
//No.9 Chroma 4x2MB 
A(0x24301040); R(0x55555555);
A(0x24301044); R(0x22222222);
//No.10 Chroma 4x2MB 
A(0x24301048); R(0xffffffff);
A(0x2430104C); R(0x11111111);
//No.11 Chroma 4x2MB 
A(0x24301050); R(0xdddddddd);
A(0x24301054); R(0x44445555);
//No.12 Chroma 4x2MB 
A(0x24301058); R(0x55558888);
A(0x2430105C); R(0x11114444);
//No.13 Chroma 4x2MB 
A(0x24301060); R(0x0000ffff);
A(0x24301064); R(0xffff0000);
//No.14 Chroma 4x2MB 
A(0x24301068); R(0xccccffff);
A(0x2430106C); R(0xffffdddd);
//No.15 Chroma 4x2MB 
A(0x24301070); R(0x66665555);
A(0x24301074); R(0x99997777);
//No.16 Chroma 4x2MB 
A(0x24301078); R(0x66665555);
A(0x2430107C); R(0xaaaacccc);

//M2 DMA0 Chroma;
 //Chroma
//MB1 4x2
A(0x30100000); W(0x11223344,NO_Mask); 
A(0x30100780); W(0x55556666,NO_Mask); 
//MB2 4x2
A(0x30100004); W(0x99995555,NO_Mask); 
A(0x30100784); W(0x77886655,NO_Mask); 
//MB3 4x2
A(0x30100008); W(0x11112222,NO_Mask); 
A(0x30100788); W(0x33334444,NO_Mask); 
//MB4 4x2
A(0x3010000C); W(0x55557777,NO_Mask); 
A(0x3010078C); W(0x44446666,NO_Mask); 
//MB5 4x2
A(0x30100010); W(0x99998888,NO_Mask); 
A(0x30100790); W(0x11112222,NO_Mask); 
//MB6 4x2
A(0x30100014); W(0x00009999,NO_Mask); 
A(0x30100794); W(0x88889999,NO_Mask); 
//MB7 4x2
A(0x30100018); W(0x77779999,NO_Mask); 
A(0x30100798); W(0x8888aaaa,NO_Mask); 
//MB8 4x2
A(0x3010001C); W(0x66664444,NO_Mask); 
A(0x3010079C); W(0x11117777,NO_Mask); 
//MB9 4x2
A(0x30100020); W(0x55555555,NO_Mask); 
A(0x301007A0); W(0x22222222,NO_Mask); 
//MB10 4x2
A(0x30100024); W(0xffffffff,NO_Mask); 
A(0x301007A4); W(0x11111111,NO_Mask); 
//MB11 4x2
A(0x30100028); W(0xdddddddd,NO_Mask); 
A(0x301007A8); W(0x44445555,NO_Mask); 
//MB12 4x2
A(0x3010002C); W(0x55558888,NO_Mask); 
A(0x301007AC); W(0x11114444,NO_Mask); 
//MB13 4x2
A(0x30100030); W(0x0000ffff,NO_Mask); 
A(0x301007B0); W(0xffff0000,NO_Mask); 
//MB14 4x2
A(0x30100034); W(0xccccffff,NO_Mask); 
A(0x301007B4); W(0xffffdddd,NO_Mask); 
//MB15 4x2
A(0x30100038); W(0x66665555,NO_Mask); 
A(0x301007B8); W(0x99997777,NO_Mask); 
//MB16 4x2
A(0x3010003C); W(0x66665555,NO_Mask); 
A(0x301007BC); W(0xaaaacccc,NO_Mask); 

//M2_Chroma_result    
//No.1 Chroma 4x2MB 
A(0x25004000); R(0x11223344);
A(0x25004004); R(0x55556666);
//No.2 Chroma 4x2MB 
A(0x25004008); R(0x99995555);
A(0x2500400C); R(0x77886655);
//No.3 Chroma 4x2MB 
A(0x25004010); R(0x11112222);
A(0x25004014); R(0x33334444);
//No.4 Chroma 4x2MB 
A(0x25004018); R(0x55557777);
A(0x2500401C); R(0x44446666);
//No.5 Chroma 4x2MB 
A(0x25004020); R(0x99998888);
A(0x25004024); R(0x11112222);
//No.6 Chroma 4x2MB 
A(0x25004028); R(0x00009999);
A(0x2500402C); R(0x88889999);
//No.7 Chroma 4x2MB 
A(0x25004030); R(0x77779999);
A(0x25004034); R(0x8888aaaa);
//No.8 Chroma 4x2MB 
A(0x25004038); R(0x66664444);
A(0x2500403C); R(0x11117777);
//No.9 Chroma 4x2MB 
A(0x25004040); R(0x55555555);
A(0x25004044); R(0x22222222);
//No.10 Chroma 4x2MB 
A(0x25004048); R(0xffffffff);
A(0x2500404C); R(0x11111111);
//No.11 Chroma 4x2MB 
A(0x25004050); R(0xdddddddd);
A(0x25004054); R(0x44445555);
//No.12 Chroma 4x2MB 
A(0x25004058); R(0x55558888);
A(0x2500405C); R(0x11114444);
//No.13 Chroma 4x2MB 
A(0x25004060); R(0x0000ffff);
A(0x25004064); R(0xffff0000);
//No.14 Chroma 4x2MB 
A(0x25004068); R(0xccccffff);
A(0x2500406C); R(0xffffdddd);
//No.15 Chroma 4x2MB 
A(0x25004070); R(0x66665555);
A(0x25004074); R(0x99997777);
//No.16 Chroma 4x2MB 
A(0x25004078); R(0x66665555);
A(0x2500407C); R(0xaaaacccc);
core3end