core3begin
//Write data to 25005000 to polling.
A(0x25005000); W(0x12121212);

//Verification;
A(0x24150068); R(0x00000001); 
//'h50070 get 31'b0,BIU_TIMER0_EN,BIU_TIMER0
//                   1 bit,        32 bits     
A(0x24150074); R(0x00000000); 
//'h50078 get 31'b0,BIU_TIMER0_EN,BIU_TIMER0
//                   1 bit,        32 bits     
A(0x2415007C); R(0x00000000); 
core3end
