core0begin
//Write data
A(0x2405001C); W(0x55229988,NO_Mask); 
A(0x24050020); W(0x11223344,NO_Mask);

//Verification;
A(0x2400001C); R(0x55229988); 
A(0x24000020); R(0x11223344); 
core0end
