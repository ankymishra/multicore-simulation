core3begin
//Write data to 25015000 to polling.
A(0x25015000); W(0x12121212);

A(0x30001300); R(0x1341349a);
A(0x30001304); R(0x13413492);
A(0x30001308); R(0x13413493);
A(0x3000130C); R(0x13413494);
A(0x30001330); R(0x13413495);
A(0x30001334); R(0x13413496);
A(0x30001338); R(0x13413497);
A(0x3000133C); R(0x13413498);
A(0x30001380); R(0x13413499);
A(0x30001384); R(0x1341349b);
A(0x30001388); R(0x1341349c);
A(0x3000138C); R(0x1341349d);
A(0x300013A0); R(0x13413490);
A(0x300013A4); R(0x13413491);
A(0x300013A8); R(0x1341342a);
A(0x300013AC); R(0x1341343a);

//M1 DMA3 partition;
//MB1
A(0x24300000); W(0x55229988,NO_Mask); 
A(0x24300780); W(0x11223344,NO_Mask);
A(0x24300F00); W(0x55687abc,NO_Mask);
A(0x24301680); W(0x76854321,NO_Mask);
//MB2
A(0x24300004); W(0x11223344,NO_Mask); 
A(0x24300784); W(0x56789abc,NO_Mask);
A(0x24300F04); W(0x55556666,NO_Mask);
A(0x24301684); W(0x77778888,NO_Mask);
//MB3
A(0x24300008); W(0x55667788,NO_Mask); 
A(0x24300788); W(0x11133322,NO_Mask);
A(0x24300F08); W(0x999aa111,NO_Mask);
A(0x24301688); W(0x33322111,NO_Mask);
//MB4
A(0x2430000C); W(0x55667788,NO_Mask); 
A(0x2430078C); W(0x11133322,NO_Mask);
A(0x24300F0C); W(0x999aa111,NO_Mask);
A(0x2430168C); W(0x33322111,NO_Mask);
//MB5
A(0x24300010); W(0x55667788,NO_Mask); 
A(0x24300790); W(0x99887766,NO_Mask);
A(0x24300F10); W(0xaabbccdd,NO_Mask);
A(0x24301690); W(0xccddeeff,NO_Mask);
//MB6
A(0x24300014); W(0x44556677,NO_Mask); 
A(0x24300794); W(0x99556644,NO_Mask);
A(0x24300F14); W(0x00005555,NO_Mask);
A(0x24301694); W(0x55550000,NO_Mask);
//MB7
A(0x24300018); W(0x99995555,NO_Mask); 
A(0x24300798); W(0xbbaaccdd,NO_Mask);
A(0x24300F18); W(0x66664444,NO_Mask);
A(0x24301698); W(0x778899aa,NO_Mask);
//MB8
A(0x2430001C); W(0x44466666,NO_Mask); 
A(0x2430079C); W(0x12345678,NO_Mask);
A(0x24300F1C); W(0x87654321,NO_Mask);
A(0x2430169C); W(0x44466666,NO_Mask);
//MB9
A(0x24300020); W(0x22222222,NO_Mask); 
A(0x243007A0); W(0x44446666,NO_Mask);
A(0x24300F20); W(0x55557777,NO_Mask);
A(0x243016A0); W(0x22222222,NO_Mask);
//MB10
A(0x24300024); W(0x33333333,NO_Mask); 
A(0x243007A4); W(0xeeeeaaaa,NO_Mask);
A(0x24300F24); W(0xaaaabbbb,NO_Mask);
A(0x243016A4); W(0x33333333,NO_Mask);
//MB11
A(0x24300028); W(0x11133322,NO_Mask); 
A(0x243007A8); W(0x00001111,NO_Mask);
A(0x24300F28); W(0x22220000,NO_Mask);
A(0x243016A8); W(0x8889999a,NO_Mask);
//MB12
A(0x2430002C); W(0x999aa111,NO_Mask); 
A(0x243007AC); W(0xaaaa1111,NO_Mask);
A(0x24300F2C); W(0x2222aaaa,NO_Mask);
A(0x243016AC); W(0x33322111,NO_Mask);
//MB13
A(0x24300030); W(0xccccdddd,NO_Mask); 
A(0x243007B0); W(0x99991111,NO_Mask);
A(0x24300F30); W(0x22229999,NO_Mask);
A(0x243016B0); W(0xaaaa4444,NO_Mask);
//MB14
A(0x24300034); W(0xffff0000,NO_Mask); 
A(0x243007B4); W(0xaaaa2222,NO_Mask);
A(0x24300F34); W(0x2222bbbb,NO_Mask);
A(0x243016B4); W(0x0000dddd,NO_Mask);
//MB15
A(0x24300038); W(0xddddaaaa,NO_Mask); 
A(0x243007B8); W(0x44466666,NO_Mask);
A(0x24300F38); W(0x33333333,NO_Mask);
A(0x243016B8); W(0xaaaadddd,NO_Mask);
//MB16
A(0x2430003C); W(0x33322111,NO_Mask); 
A(0x243007BC); W(0x55555555,NO_Mask);
A(0x24300F3C); W(0x8889999a,NO_Mask);
A(0x243016BC); W(0xffffffff,NO_Mask);

//Chroma
//MB1 4x2
A(0x24304000); W(0x11223344,NO_Mask); 
A(0x24304780); W(0x55556666,NO_Mask); 
//MB2 4x2
A(0x24304004); W(0x99995555,NO_Mask); 
A(0x24304784); W(0x77886655,NO_Mask); 
//MB3 4x2
A(0x24304008); W(0x11112222,NO_Mask); 
A(0x24304788); W(0x33334444,NO_Mask); 
//MB4 4x2
A(0x2430400C); W(0x55557777,NO_Mask); 
A(0x2430478C); W(0x44446666,NO_Mask); 
//MB5 4x2
A(0x24304010); W(0x99998888,NO_Mask); 
A(0x24304790); W(0x11112222,NO_Mask); 
//MB6 4x2
A(0x24304014); W(0x00009999,NO_Mask); 
A(0x24304794); W(0x88889999,NO_Mask); 
//MB7 4x2
A(0x24304018); W(0x77779999,NO_Mask); 
A(0x24304798); W(0x8888aaaa,NO_Mask); 
//MB8 4x2
A(0x2430401C); W(0x66664444,NO_Mask); 
A(0x2430479C); W(0x11117777,NO_Mask); 
//MB9 4x2
A(0x24304020); W(0x55555555,NO_Mask); 
A(0x243047A0); W(0x22222222,NO_Mask); 
//MB10 4x2
A(0x24304024); W(0xffffffff,NO_Mask); 
A(0x243047A4); W(0x44466666,NO_Mask); 
//MB11 4x2
A(0x24304028); W(0xdddddddd,NO_Mask); 
A(0x243047A8); W(0x44445555,NO_Mask); 
//MB12 4x2
A(0x2430402C); W(0x55558888,NO_Mask); 
A(0x243047AC); W(0x11114444,NO_Mask); 
//MB13 4x2
A(0x24304030); W(0x0000ffff,NO_Mask); 
A(0x243047B0); W(0xffff0000,NO_Mask); 
//MB14 4x2
A(0x24304034); W(0xccccffff,NO_Mask); 
A(0x243047B4); W(0xffffdddd,NO_Mask); 
//MB15 4x2
A(0x24304038); W(0x66665555,NO_Mask); 
A(0x243047B8); W(0x99997777,NO_Mask); 
//MB16 4x2
A(0x2430403C); W(0x66665555,NO_Mask); 
A(0x243047BC); W(0xaaaacccc,NO_Mask); 

//M1_Luma_result
//No.1 Luma 4x4MB
A(0x30001A00); R(0x55229988);
A(0x30001A04); R(0x11223344);
A(0x30001A08); R(0x55687abc);
A(0x30001A0C); R(0x76854321);
//No.2 Luma 4x4MB
A(0x30001A10); R(0x11223344);
A(0x30001A14); R(0x56789abc);
A(0x30001A18); R(0x55556666);
A(0x30001A1C); R(0x77778888);
//No.3 Luma 4x4MB
A(0x30001A20); R(0x55667788);
A(0x30001A24); R(0x11133322);
A(0x30001A28); R(0x999aa111);
A(0x30001A2C); R(0x33322111);
//No.4 Luma 4x4MB
A(0x30001A30); R(0x55667788);
A(0x30001A34); R(0x11133322);
A(0x30001A38); R(0x999aa111);
A(0x30001A3C); R(0x33322111);
//No.5 Luma 4x4MB
A(0x30001A40); R(0x55667788);
A(0x30001A44); R(0x99887766);
A(0x30001A48); R(0xaabbccdd);
A(0x30001A4C); R(0xccddeeff);
//No.6 Luma 4x4MB
A(0x30001A50); R(0x44556677);
A(0x30001A54); R(0x99556644);
A(0x30001A58); R(0x00005555);
A(0x30001A5C); R(0x55550000);
//No.7 Luma 4x4MB
A(0x30001A60); R(0x99995555);
A(0x30001A64); R(0xbbaaccdd);
A(0x30001A68); R(0x66664444);
A(0x30001A6C); R(0x778899aa);
//No.8 Luma 4x4MB
A(0x30001A70); R(0x44466666);
A(0x30001A74); R(0x12345678);
A(0x30001A78); R(0x87654321);
A(0x30001A7C); R(0x44466666);
//No.9 Luma 4x4MB
A(0x30001A80); R(0x22222222);
A(0x30001A84); R(0x44446666);
A(0x30001A88); R(0x55557777);
A(0x30001A8C); R(0x22222222);
//No.10 Luma 4x4MB
A(0x30001A90); R(0x33333333);
A(0x30001A94); R(0xeeeeaaaa);
A(0x30001A98); R(0xaaaabbbb);
A(0x30001A9C); R(0x33333333);
//No.11 Luma 4x4MB
A(0x30001AA0); R(0x11133322);
A(0x30001AA4); R(0x00001111);
A(0x30001AA8); R(0x22220000);
A(0x30001AAC); R(0x8889999a);
//No.12 Luma 4x4MB
A(0x30001AB0); R(0x999aa111);
A(0x30001AB4); R(0xaaaa1111);
A(0x30001AB8); R(0x2222aaaa);
A(0x30001ABC); R(0x33322111);
//No.13 Luma 4x4MB
A(0x30001AC0); R(0xccccdddd);
A(0x30001AC4); R(0x99991111);
A(0x30001AC8); R(0x22229999);
A(0x30001ACC); R(0xaaaa4444);
//No.14 Luma 4x4MB
A(0x30001AD0); R(0xffff0000);
A(0x30001AD4); R(0xaaaa2222);
A(0x30001AD8); R(0x2222bbbb);
A(0x30001ADC); R(0x0000dddd);
//No.15 Luma 4x4MB
A(0x30001AE0); R(0xddddaaaa);
A(0x30001AE4); R(0x44466666);
A(0x30001AE8); R(0x33333333);
A(0x30001AEC); R(0xaaaadddd);
//No.16 Luma 4x4MB
A(0x30001AF0); R(0x33322111);
A(0x30001AF4); R(0x55555555);
A(0x30001AF8); R(0x8889999a);
A(0x30001AFC); R(0xffffffff);

//M1_Chroma_result    
//No.1 Chroma 4x2MB 
A(0x30001B00); R(0x11223344);
A(0x30001B04); R(0x55556666);
//No.2 Chroma 4x2MB 
A(0x30001B08); R(0x99995555);
A(0x30001B0C); R(0x77886655);
//No.3 Chroma 4x2MB 
A(0x30001B10); R(0x11112222);
A(0x30001B14); R(0x33334444);
//No.4 Chroma 4x2MB 
A(0x30001B18); R(0x55557777);
A(0x30001B1C); R(0x44446666);
//No.5 Chroma 4x2MB 
A(0x30001B20); R(0x99998888);
A(0x30001B24); R(0x11112222);
//No.6 Chroma 4x2MB 
A(0x30001B28); R(0x00009999);
A(0x30001B2C); R(0x88889999);
//No.7 Chroma 4x2MB 
A(0x30001B30); R(0x77779999);
A(0x30001B34); R(0x8888aaaa);
//No.8 Chroma 4x2MB 
A(0x30001B38); R(0x66664444);
A(0x30001B3C); R(0x11117777);
//No.9 Chroma 4x2MB 
A(0x30001B40); R(0x55555555);
A(0x30001B44); R(0x22222222);
//No.10 Chroma 4x2MB 
A(0x30001B48); R(0xffffffff);
A(0x30001B4C); R(0x44466666);
//No.11 Chroma 4x2MB 
A(0x30001B50); R(0xdddddddd);
A(0x30001B54); R(0x44445555);
//No.12 Chroma 4x2MB 
A(0x30001B58); R(0x55558888);
A(0x30001B5C); R(0x11114444);
//No.13 Chroma 4x2MB 
A(0x30001B60); R(0x0000ffff);
A(0x30001B64); R(0xffff0000);
//No.14 Chroma 4x2MB 
A(0x30001B68); R(0xccccffff);
A(0x30001B6C); R(0xffffdddd);
//No.15 Chroma 4x2MB 
A(0x30001B70); R(0x66665555);
A(0x30001B74); R(0x99997777);
//No.16 Chroma 4x2MB 
A(0x30001B78); R(0x66665555);
A(0x30001B7C); R(0xaaaacccc);

//M2 DMA0 partition;
//Chroma
//MB1 4x2
A(0x25005000); W(0x11223344,NO_Mask); 
A(0x25005780); W(0x55556666,NO_Mask); 
//MB2 4x2
A(0x25005004); W(0x99995555,NO_Mask); 
A(0x25005784); W(0x77886655,NO_Mask); 
//MB3 4x2
A(0x25005008); W(0x11112222,NO_Mask); 
A(0x25005788); W(0x33334444,NO_Mask); 
//MB4 4x2
A(0x2500500C); W(0x55557777,NO_Mask); 
A(0x2500578C); W(0x44446666,NO_Mask); 
//MB5 4x2
A(0x25005010); W(0x99998888,NO_Mask); 
A(0x25005790); W(0x11112222,NO_Mask); 
//MB6 4x2
A(0x25005014); W(0x00009999,NO_Mask); 
A(0x25005794); W(0x88889999,NO_Mask); 
//MB7 4x2
A(0x25005018); W(0x77779999,NO_Mask); 
A(0x25005798); W(0x8888aaaa,NO_Mask); 
//MB8 4x2
A(0x2500501C); W(0x66664444,NO_Mask); 
A(0x2500579C); W(0x11117777,NO_Mask); 
//MB9 4x2
A(0x25005020); W(0x55555555,NO_Mask); 
A(0x250057A0); W(0x22222222,NO_Mask); 
//MB10 4x2
A(0x25005024); W(0xffffffff,NO_Mask); 
A(0x250057A4); W(0x44466666,NO_Mask); 
//MB11 4x2
A(0x25005028); W(0xdddddddd,NO_Mask); 
A(0x250057A8); W(0x44445555,NO_Mask); 
//MB12 4x2
A(0x2500502C); W(0x55558888,NO_Mask); 
A(0x250057AC); W(0x11114444,NO_Mask); 
//MB13 4x2
A(0x25005030); W(0x0000ffff,NO_Mask); 
A(0x250057B0); W(0xffff0000,NO_Mask); 
//MB14 4x2
A(0x25005034); W(0xccccffff,NO_Mask); 
A(0x250057B4); W(0xffffdddd,NO_Mask); 
//MB15 4x2
A(0x25005038); W(0x66665555,NO_Mask); 
A(0x250057B8); W(0x99997777,NO_Mask); 
//MB16 4x2
A(0x2500503C); W(0x66665555,NO_Mask); 
A(0x250057BC); W(0xaaaacccc,NO_Mask); 


//M2_Chroma_result    
//No.1 Chroma 4x2MB 
A(0x30000B00); R(0x11223344);
A(0x30000B04); R(0x55556666);
//No.2 Chroma 4x2MB 
A(0x30000B08); R(0x99995555);
A(0x30000B0C); R(0x77886655);
//No.3 Chroma 4x2MB 
A(0x30000B10); R(0x11112222);
A(0x30000B14); R(0x33334444);
//No.4 Chroma 4x2MB 
A(0x30000B18); R(0x55557777);
A(0x30000B1C); R(0x44446666);
//No.5 Chroma 4x2MB 
A(0x30000B20); R(0x99998888);
A(0x30000B24); R(0x11112222);
//No.6 Chroma 4x2MB 
A(0x30000B28); R(0x00009999);
A(0x30000B2C); R(0x88889999);
//No.7 Chroma 4x2MB 
A(0x30000B30); R(0x77779999);
A(0x30000B34); R(0x8888aaaa);
//No.8 Chroma 4x2MB 
A(0x30000B38); R(0x66664444);
A(0x30000B3C); R(0x11117777);
//No.9 Chroma 4x2MB 
A(0x30000B40); R(0x55555555);
A(0x30000B44); R(0x22222222);
//No.10 Chroma 4x2MB 
A(0x30000B48); R(0xffffffff);
A(0x30000B4C); R(0x44466666);
//No.11 Chroma 4x2MB 
A(0x30000B50); R(0xdddddddd);
A(0x30000B54); R(0x44445555);
//No.12 Chroma 4x2MB 
A(0x30000B58); R(0x55558888);
A(0x30000B5C); R(0x11114444);
//No.13 Chroma 4x2MB 
A(0x30000B60); R(0x0000ffff);
A(0x30000B64); R(0xffff0000);
//No.14 Chroma 4x2MB 
A(0x30000B68); R(0xccccffff);
A(0x30000B6C); R(0xffffdddd);
//No.15 Chroma 4x2MB 
A(0x30000B70); R(0x66665555);
A(0x30000B74); R(0x99997777);
//No.16 Chroma 4x2MB 
A(0x30000B78); R(0x66665555);
A(0x30000B7C); R(0xaaaacccc);
core3end
