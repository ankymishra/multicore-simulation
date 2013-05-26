core3begin
//Write data to 25005000 to polling.
A(0x25005000); W(0x12121212);

//Verification;
A(0x2415001C); R(0x12345678); 
A(0x24150020); R(0x87654321); 
core3end
