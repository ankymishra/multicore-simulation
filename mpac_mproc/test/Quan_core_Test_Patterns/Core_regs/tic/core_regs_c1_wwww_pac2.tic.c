core2begin
//Verification;
A(0x24150068); R(0x00000001); 
//'h50070 get 31'b0,BIU_TIMER0_EN,BIU_TIMER0
//                   1 bit,        32 bits     
A(0x24150074); R(0x00000001); 
//'h50078 get 31'b0,BIU_TIMER0_EN,BIU_TIMER0
//                   1 bit,        32 bits     
A(0x2415007C); R(0x00000001); 
core2end
