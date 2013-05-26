core3begin
//Write data to 25005000 to polling.
A(0x25005000); W(0x12121212);

A(0x2415001C); W(0x55229988,NO_Mask); 
A(0x24150020); W(0x11223344,NO_Mask);

//Verification;
A(0x2410001C); R(0x55229988); 
A(0x24100020); R(0x11223344); 
core3end
