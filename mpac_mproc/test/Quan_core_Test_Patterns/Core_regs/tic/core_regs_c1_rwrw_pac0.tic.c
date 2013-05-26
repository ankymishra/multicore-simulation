core0begin
//Write data
A(0x2415001C); W(0x55229988,NO_Mask); 
A(0x24150020); W(0x11223344,NO_Mask);

//Verification;
A(0x2410001C); R(0x55229988); 
A(0x24100020); R(0x11223344); 
core0end
