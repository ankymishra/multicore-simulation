core1begin
//Write 00000005,00000009 to avoid to enable timer;
A(0x24250074); W(0x00000005,NO_Mask);  
A(0x2415007C); W(0x00000009,NO_Mask); 

//Verification;
A(0x24200074); R(0x00000000); 
A(0x2420007C); R(0x00000000); 
core1end
