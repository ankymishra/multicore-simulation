core2begin
A(0x24350024); W(0x53342212,NO_Mask);  
A(0x24350028); W(0x34555533,NO_Mask);  
A(0x2435005C); W(0x12345678,NO_Mask);  
A(0x24350060); W(0x87654321,NO_Mask);  

//Verification;
A(0x24300024); R(0x53342212); 
A(0x24300028); R(0x34555533);
A(0x2430005C); R(0x12345678); 
A(0x24300060); R(0x87654321);
core2end