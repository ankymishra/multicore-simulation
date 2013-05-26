core3begin
//Write data to 25005000 to polling.
A(0x25005000); W(0x12121212);

//Verification;
A(0x24350060); R(0x24681357); 
A(0x24350070); R(0x24681357); 
A(0x24350078); R(0x24681357); 
core3end
