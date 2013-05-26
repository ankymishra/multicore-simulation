core3begin
//Write data to 25005000 to polling.
A(0x25005000); W(0x12121212);

//Verification;
A(0x24250024); R(0x12345678); 
A(0x24250028); R(0x53342212); 
core3end
