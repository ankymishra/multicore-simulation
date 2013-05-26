core3begin
//Initial for polling
A(0x25005000); W(0x12121212);

A(0x25810038); W(0xFEDCBA98,NO_Mask);
A(0x2581003C); W(0x134132F7,NO_Mask);

\\Verification;
A(0x24300038); R(0x0);
A(0x2430003C); R(0x0);
core3end
