;============================================================================================================================================================================================================================================================================================================================================
;               frame=23807  mbx=25  mby=23
;============================================================================================================================================================================================================================================================================================================================================
.data

; Raw Y (+0)
.global InYBaseAddr
.align 3
InYBaseAddr:
.byte    94, 83, 96,170,210,178,208,133,250, 84,216, 53,232,212,102,130
.byte   100,152,217,168,135,117,101,112, 90,138, 63, 98,128, 41, 68,222
.byte   124,165,137, 78, 87, 89,211, 81,173,172,134,149,128,236, 23,228
.byte   133,241,140, 12,102,241,124,192,124,187, 34,252,228,102,218, 97
.byte    11, 99,175, 98,188,131,180,105, 47, 58,255,175, 39, 22,147,172
.byte     7, 31,184,109, 17, 52, 45,141,239, 79,137,212,182, 99, 53,193
.byte   199,228, 36,131,103,216,237,150, 18,236, 69, 57,  2,216,229, 10
.byte   248,157,119,  9,209,165,150,193,244, 31,149,170,130,202,108, 73
.byte   174,144,205, 22,104,186,172,122,166,242,180,168,202,153,178,194
.byte    55, 42,203,  8,207, 97,201,195,128, 94,110,  3, 40,218, 76,215
.byte   106, 25,237,210,211,153, 76,121,139,  0, 34, 86,154,212, 24,209
.byte   254,228,217,205, 69,163,145,198,  1,255,201, 42,217, 21,  1, 67
.byte    47,238, 21,  2,135, 97,124, 19, 98,158,105,252,114,129,205,113
.byte   101,166, 62,171, 73,207,113, 75,206, 58,117,167, 79,118,234,126
.byte   100,255,129,235, 97,253,254,195,155,103,191, 13,233,140,126, 78
.byte    50,189,249,124,140,106,199, 91,164, 60,  2,244,178,237,114, 22

; Raw Cb (+256)
.global InCbBaseAddr
.align 3
InCbBaseAddr:
.byte   236,  1,240, 16,103,153, 91,159
.byte   212, 10,  3,188, 13,155,171,213
.byte     1,229,214,125,197,142, 46,175
.byte   198, 99,138,112,222, 86, 26, 33
.byte     1, 13,253, 22,161,227,210,210
.byte    75, 97, 85,108,221,188,237, 19
.byte   229,199,171,164,129, 28, 26,235
.byte    36, 59, 30,172,106,243, 70, 71

; Raw Cr (+320)
.global InCrBaseAddr
.align 3
InCrBaseAddr:
.byte   243, 77,  0,139,207, 80, 23,142
.byte   152, 97,209,167,190,191, 14,152
.byte   214,242,246, 62, 22, 33, 45,  2
.byte   185,201, 31,151, 12,137, 43, 27
.byte     7,216,139,194,164,207,146,152
.byte    53,213,209, 51,194,247,222,239
.byte    32,226,221, 77,136, 83,238,102
.byte    76,121,168,251,104, 88,  6, 43

; Search Window Luma (+384)
.global SWBaseAddr
.align 3
YSWBaseAddr:
;         0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31 
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte    99, 88,101,175,215,183,213,138,255, 89,221, 58,237,217,107,135,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte   105,157,222,173,140,122,106,117, 95,143, 68,103,133, 46, 73,227,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte   129,170,142, 83, 92, 94,216, 86,178,177,139,154,133,241, 28,233,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte   138,246,145, 17,107,246,129,197,129,192, 39,247,233,107,223,102,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte    16,104,180,103,193,136,185,110, 52, 63,250,180, 44, 27,152,177,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte    12, 36,189,114, 22, 57, 50,146,244, 84,142,217,187,104, 58,198,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte   204,233, 41,136,108,221,242,155, 23,241, 74, 62,  7,221,234, 15,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte   253,162,124, 14,214,170,155,198,249, 36,154,175,135,207,113, 78,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte   179,149,210, 27,109,191,177,127,171,247,185,173,207,158,183,199,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte    60, 47,208, 13,212,102,206,200,133, 99,115,  8, 45,223, 81,220,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte   111, 30,242,215,216,158, 81,126,144,  5, 39, 91,159,217, 29,214,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte   249,233,222,210, 74,168,150,203,  6,250,206, 47,222, 26,  6, 72,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte    52,243, 26,  7,140,102,129, 24,103,163,110,247,119,134,210,118,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte   106,171, 67,176, 78,212,118, 80,211, 63,122,172, 84,123,239,131,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte   105,250,134,240,102,248,249,200,160,108,196, 18,238,145,131, 83,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte    55,194,254,129,145,111,204, 96,169, 65,  7,249,183,242,119, 27,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
; Search Window Chroma (+1408)
.global SWBaseAddr
.align 3
CSWBaseAddr:
;         0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31 
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0, 84,154,188, 14,168,172,243, 76,  0,  0,  0,  0,  0,  0,  0,  0, 72, 10,213, 24, 68, 91,142,215
.byte     0,  0,  0,  0,  0,  0,  0,  0, 45,  9,229,196,175,163,127,173,  0,  0,  0,  0,  0,  0,  0,  0,155, 66,  6, 51,205,132, 45,212
.byte     0,  0,  0,  0,  0,  0,  0,  0,118,222, 28, 74, 48, 32,133,251,  0,  0,  0,  0,  0,  0,  0,  0, 71, 50,236,196,246, 35,108,178
.byte     0,  0,  0,  0,  0,  0,  0,  0,  7,244, 11, 32,134, 62,241,217,  0,  0,  0,  0,  0,  0,  0,  0,  4,236,185,186,195,  5,236,103
.byte     0,  0,  0,  0,  0,  0,  0,  0, 51,153,163, 20,217,247,160, 16,  0,  0,  0,  0,  0,  0,  0,  0,183, 80,227,211, 52, 94,242,168
.byte     0,  0,  0,  0,  0,  0,  0,  0,246,148,190,188,120, 73,230,208,  0,  0,  0,  0,  0,  0,  0,  0,  5,  1,180, 68,250,105, 35, 26
.byte     0,  0,  0,  0,  0,  0,  0,  0,218,106, 76, 81,179,132, 58,251,  0,  0,  0,  0,  0,  0,  0,  0,105,126,126, 37, 72, 83,148, 49
.byte     0,  0,  0,  0,  0,  0,  0,  0,153, 50, 68,155,233, 37,  8,233,  0,  0,  0,  0,  0,  0,  0,  0,144, 87,238,188,229,207,245,226
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
.byte     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0


; Pre-row Luma (+2432)
.global PreRowPelYBaseAddr
.align 3
PreRowPelYBaseAddr:
  .byte  246, 199,  22, 158, 115,  17,   8, 219,   4,  96,  34,  10, 167,  77,  49, 181,  91,   3, 160,  13,   0,   0,   0,   0
; Pre-col Luma (+2456)
.global PreColPelYBaseAddr
.align 3
PreColPelYBaseAddr:
  .byte   38,  14,  13, 210, 235, 178,  31, 108,  58,  59, 192,  84,  42, 171, 186,  78, 248,   0,   0,   0,   0,   0,   0,   0
; PreColPelCb (+2480)
.global PreColPelCbBaseAddr
.align 3
PreColPelCbBaseAddr:
  .byte   0x22,0x47,0xcd,0x87,0x56,0x70,0x9c,0xea,0x98,0x00,0x00,0x00,0x00,0x00,0x00,0x00

; PreColPelCr (+2496)
.global PreColPelCrBaseAddr
.align 3
PreColPelCrBaseAddr:
  .byte   0x0d,0x5d,0x9b,0x78,0xd5,0x4c,0x86,0x0f,0xf2,0x00,0x00,0x00,0x00,0x00,0x00,0x00

; PreRowPelCb (+2512)
.global PreRowPelCbBaseAddr
.align 3
PreRowPelCbBaseAddr:
  .byte   0xeb,0x53,0xa7,0x5a,0xb0,0xdb,0xc2,0x5d

; PreRowPelCr (+2520)
.global PreRowPelCrBaseAddr
.align 3
PreRowPelCrBaseAddr:
  .byte   0x9c,0x0d,0xfa,0xd8,0xb5,0x50,0xfd,0x09

; input parameters (+2528)
.global Input_Addr
.align 3
Input_Addr:
    .byte 0x34              ; Func_Mode             (52)
    .byte 0x0f              ; IntraRefAval          (15)
    .byte 0x00              ; SWSearchRange         (0)
    .byte 0x20              ; SWB_Width             (32)
    .byte 0x00              ; SW_Start_Offset       (0)
    .byte 0x08              ; SW_Start_Offset_Chroma       (8)
    .half 0x000a            ; Skip_SAD_Thrld        (10)
    .half 0x0064            ; Inter_SAD_Thrld       (100)
    .half 0xffff            ; CBP
    .half 0xffff            ; CBP_Cb
    .half 0xffff            ; CBP_Cr
    .word 0x00000000        ; MVP                   (0,0)
    .half 384               ; YSWBaseAddr
    .half 1408              ; CSWBaseAddr
    .half 9080              ; MVBaseAddr
    .half 9064              ; Intra4x4PredModeBaseAddr
    .half 9000              ; OutAddr
    .half 9144              ; OutYBaseAddr
    .half 9400              ; OutCbBaseAddr
    .half 9464              ; OutCrBaseAddr
    .half 9528              ; YResidualBaseAddr
    .half 10040             ; CbResidualBaseAddr
    .half 10168             ; CrResidualBaseAddr
    .half 2456              ; PreColPelYBaseAddr
    .half 2432              ; PreRowPelYBaseAddr
    .half 2480              ; PreColPelCbBaseAddr
    .half 2512              ; PreRowPelCbBaseAddr
    .half 2496              ; PreColPelCrBaseAddr
    .half 2520              ; PreRowPelCrBaseAddr
    .half 0                 ; InYBaseAddr
    .half 256               ; InCbBaseAddr
    .half 320               ; InCrBaseAddr
.text
; set CFU_Info_Sel(SR13) according to interested

    {   MOVI.L SR13, 2                          |   NOP |   NOP |   NOP |   NOP }

; store Input_Addr(Base+2528) to ME (SR4-7 = CFU0-3, ME use SR6)
    {   MOVI R0, 0x800009e0                 |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R0                                |   NOP |   NOP |   NOP |   NOP }

; test if store success
    {   TEST P1, P2, 0xFFFF, 0x8000 |   NOP |   NOP |   NOP |   NOP }

; start function (encode md reconstruct)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00b0                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20b0 |   NOP |   NOP |   NOP |   NOP }

; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 4000                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00b0         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                       |   NOP |   NOP |   NOP |   NOP }
; check MBType
; load MBType to R7
    {   moviu r8, 0x25002328                 |   NOP |   NOP |   NOP |   NOP }
    {   lb r7, r8, 4                       |   NOP |   NOP |   NOP |   NOP }
    {   NOP                       |   NOP |   NOP |   NOP |   NOP }
    {   NOP                       |   NOP |   NOP |   NOP |   NOP }
; compare R7 and MBTYPE_Skip(value)
    {   seqi r9, p7, p8, r7, 8                       |   NOP |   NOP |   NOP |   NOP }
    {   (p7)b    enc_trap                       |   NOP |   NOP |   NOP |   NOP }
    {   NOP                       |   NOP |   NOP |   NOP |   NOP }
    {   NOP                       |   NOP |   NOP |   NOP |   NOP }
    {   NOP                       |   NOP |   NOP |   NOP |   NOP }
    {   NOP                       |   NOP |   NOP |   NOP |   NOP }

; compare R7 and MBTYPE_I4x4(value)
    {   seqi r9, p5, p6, r7, 0                       |   NOP |   NOP |   NOP |   NOP }
; branch to Inter_and_I16
    {   (p6)b   Inter_or_I16                     |   NOP |   NOP |   NOP |   NOP }
    {   NOP                       |   NOP |   NOP |   NOP |   NOP }
    {   NOP                       |   NOP |   NOP |   NOP |   NOP }
    {   NOP                       |   NOP |   NOP |   NOP |   NOP }
    {   NOP                       |   NOP |   NOP |   NOP |   NOP }

    {   NOP         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 0                                                                               
;=======================================================================================
; start function (encode I4 reconstruct)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00c0                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20c0 |   NOP |   NOP |   NOP |   NOP }

; wait for phase 0 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00c0         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 1                                                                               
;=======================================================================================
; start function (encode I4 reconstruct)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00c1                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20c1 |   NOP |   NOP |   NOP |   NOP }

; wait for phase 1 done (250 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 250                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00c1         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 2                                                                               
;=======================================================================================
; start function (encode I4 reconstruct)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00c2                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20c2 |   NOP |   NOP |   NOP |   NOP }

; wait for phase 2 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00c2         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 4                                                                               
;=======================================================================================
; start function (encode I4 reconstruct)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00c4                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20c4 |   NOP |   NOP |   NOP |   NOP }

; wait for phase 4 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00c4         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 3                                                                               
;=======================================================================================
; start function (encode I4 reconstruct)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00c3                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20c3 |   NOP |   NOP |   NOP |   NOP }

; wait for phase 3 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00c3         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 5                                                                               
;=======================================================================================
; start function (encode I4 reconstruct)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00c5                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20c5 |   NOP |   NOP |   NOP |   NOP }

; wait for phase 5 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00c5         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 8                                                                               
;=======================================================================================
; start function (encode I4 reconstruct)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00c8                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20c8 |   NOP |   NOP |   NOP |   NOP }

; wait for phase 8 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00c8         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 6                                                                               
;=======================================================================================
; start function (encode I4 reconstruct)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00c6                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20c6 |   NOP |   NOP |   NOP |   NOP }

; wait for phase 6 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00c6         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 9                                                                               
;=======================================================================================
; start function (encode I4 reconstruct)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00c9                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20c9 |   NOP |   NOP |   NOP |   NOP }

; wait for phase 9 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00c9         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 7                                                                               
;=======================================================================================
; start function (encode I4 reconstruct)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00c7                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20c7 |   NOP |   NOP |   NOP |   NOP }

; wait for phase 7 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00c7         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 10                                                                               
;=======================================================================================
; start function (encode I4 reconstruct)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00ca                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20ca |   NOP |   NOP |   NOP |   NOP }

; wait for phase 7 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00ca         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 12                                                                               
;=======================================================================================
; start function (encode I4 reconstruct)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00cc                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20cc |   NOP |   NOP |   NOP |   NOP }

; wait for phase 12 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00cc         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 11                                                                               
;=======================================================================================
; start function (encode I4 reconstruct)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00cb                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20cb |   NOP |   NOP |   NOP |   NOP }

; wait for phase 11 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00cb         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 13                                                                               
;=======================================================================================
; start function (encode I4 reconstruct)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00cd                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20cd |   NOP |   NOP |   NOP |   NOP }

; wait for phase 13 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00cd         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 14                                                                               
;=======================================================================================
; start function (encode I4 reconstruct)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00ce                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20ce |   NOP |   NOP |   NOP |   NOP }

; wait for phase 14 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00ce         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 15                                                                               
;=======================================================================================
; start function (encode I4 reconstruct)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00cf                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20cf |   NOP |   NOP |   NOP |   NOP }

; wait for phase 15 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00cf         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; final Chroma reconstruct                                                              
;=======================================================================================
; start function (final Chroma reconstruct)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00b3                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20b3 |   NOP |   NOP |   NOP |   NOP }

; wait for phase 15 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00b3         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
; I4 finish

    {   b    enc_trap                       |   NOP |   NOP |   NOP |   NOP }
    {   NOP         |   NOP |   NOP |   NOP |   NOP }
    {   NOP         |   NOP |   NOP |   NOP |   NOP }
    {   NOP         |   NOP |   NOP |   NOP |   NOP }
    {   NOP         |   NOP |   NOP |   NOP |   NOP }
    {   NOP         |   NOP |   NOP |   NOP |   NOP }
Inter_or_I16:
;=======================================================================================
; inter Chroma Residual                                                                 
;=======================================================================================
; start function (Inter)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00b1                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20b1 |   NOP |   NOP |   NOP |   NOP }

; wait for inter Chroma Residual done (500 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 500                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00b1         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; inter Luma Reconstruct                                                                
;=======================================================================================
; start function (Inter)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00b2                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20b2 |   NOP |   NOP |   NOP |   NOP }

; wait for inter Luma Reconstruct done (300 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 300                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00b2         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; inter Chroma Reconstruct                                                              
;=======================================================================================
; start function (Inter)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00b3                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20b3 |   NOP |   NOP |   NOP |   NOP }

; wait for inter Chroma Reconstruct done (500 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 500                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00b3         |   NOP |   NOP |   NOP |   NOP }

; trap
enc_trap:
    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
    { TRAP                      |   NOP |   NOP |   NOP |   NOP }

; values to be checked

;.align 4
;OutAddr  (+9000):
;SAD:
;.half   0x0500

;SAD_MV0:
;.half   0x0500

;MbType:
;.byte   0x04

;B8x8Mode:
;.byte   0x00

;Intra16x16PredMode:
;.byte   0x03

;IntraChromaPredMode:
;.byte   0x00

; Intra4x4PredModeBaseAddr (+9064)
;Intra4x4PredModeBaseAddr:
;.byte   0x02
;.byte   0x02
;.byte   0x02
;.byte   0x02
;.byte   0x04
;.byte   0x02
;.byte   0x06
;.byte   0x02
;.byte   0x03
;.byte   0x00
;.byte   0x01
;.byte   0x02
;.byte   0x03
;.byte   0x06
;.byte   0x03
;.byte   0x02

;MVBaseAddr:
;OutMV0:
;.word   0x00000000
;OutMV1:
;.word   0x00000000
;OutMV2:
;.word   0x00000000
;OutMV3:
;.word   0x00000000
;OutMV4:
;.word   0x00000000
;OutMV5:
;.word   0x00000000
;OutMV6:
;.word   0x00000000
;OutMV7:
;.word   0x00000000
;OutMV8:
;.word   0x00000000
;OutMV9:
;.word   0x00000000
;OutMV10:
;.word   0x00000000
;OutMV11:
;.word   0x00000000
;OutMV12:
;.word   0x00000000
;OutMV13:
;.word   0x00000000
;OutMV14:
;.word   0x00000000
;OutMV15:
;.word   0x00000000
;  /* OutYReconstructed I4*/
;  .byte    94, 83, 96,170,210,178,208,133,250, 84,216, 53,232,212,102,130
;  .byte   100,152,217,168,135,117,101,112, 90,138, 63, 98,128, 41, 68,222
;  .byte   124,165,137, 78, 87, 89,211, 81,173,172,134,149,128,236, 23,228
;  .byte   133,241,140, 12,102,241,124,192,124,187, 34,252,228,102,218, 97
;  .byte    11, 99,175, 98,188,131,180,105, 47, 58,255,175, 39, 22,147,172
;  .byte     7, 31,184,109, 17, 52, 45,141,239, 79,137,212,182, 99, 53,193
;  .byte   199,228, 36,131,103,216,237,150, 18,236, 69, 57,  2,216,229, 10
;  .byte   248,157,119,  9,209,165,150,193,244, 31,149,170,130,202,108, 73
;  .byte   174,144,205, 22,104,186,172,122,166,242,180,168,202,153,178,194
;  .byte    55, 42,203,  8,207, 97,201,195,128, 94,110,  3, 40,218, 76,215
;  .byte   106, 25,237,210,211,153, 76,121,139,  0, 34, 86,154,212, 24,209
;  .byte   254,228,217,205, 69,163,145,198,  1,255,201, 42,217, 21,  1, 67
;  .byte    47,238, 21,  2,135, 97,124, 19, 98,158,105,252,114,129,205,113
;  .byte   101,166, 62,171, 73,207,113, 75,206, 58,117,167, 79,118,234,126
;  .byte   100,255,129,235, 97,253,254,195,155,103,191, 13,233,140,126, 78
;  .byte    50,189,249,124,140,106,199, 91,164, 60,  2,244,178,237,114, 22
;OutYReconstructed I16:
;  .byte    94, 83, 96,170,210,178,208,133,250, 84,216, 53,232,212,102,130
;  .byte   100,152,217,168,135,117,101,112, 90,138, 63, 98,128, 41, 68,222
;  .byte   124,165,137, 78, 87, 89,211, 81,173,172,134,149,128,236, 23,228
;  .byte   133,241,140, 12,102,241,124,192,124,187, 34,252,228,102,218, 97
;  .byte    11, 99,175, 98,188,131,180,105, 47, 58,255,175, 39, 22,147,172
;  .byte     7, 31,184,109, 17, 52, 45,141,239, 79,137,212,182, 99, 53,193
;  .byte   199,228, 36,131,103,216,237,150, 18,236, 69, 57,  2,216,229, 10
;  .byte   248,157,119,  9,209,165,150,193,244, 31,149,170,130,202,108, 73
;  .byte   174,144,205, 22,104,186,172,122,166,242,180,168,202,153,178,194
;  .byte    55, 42,203,  8,207, 97,201,195,128, 94,110,  3, 40,218, 76,215
;  .byte   106, 25,237,210,211,153, 76,121,139,  0, 34, 86,154,212, 24,209
;  .byte   254,228,217,205, 69,163,145,198,  1,255,201, 42,217, 21,  1, 67
;  .byte    47,238, 21,  2,135, 97,124, 19, 98,158,105,252,114,129,205,113
;  .byte   101,166, 62,171, 73,207,113, 75,206, 58,117,167, 79,118,234,126
;  .byte   100,255,129,235, 97,253,254,195,155,103,191, 13,233,140,126, 78
;  .byte    50,189,249,124,140,106,199, 91,164, 60,  2,244,178,237,114, 22

;OutYReconstructed Inter:
;  .byte    94, 83, 96,170,210,178,208,133,250, 84,216, 53,232,212,102,130
;  .byte   100,152,217,168,135,117,101,112, 90,138, 63, 98,128, 41, 68,222
;  .byte   124,165,137, 78, 87, 89,211, 81,173,172,134,149,128,236, 23,228
;  .byte   133,241,140, 12,102,241,124,192,124,187, 34,252,228,102,218, 97
;  .byte    11, 99,175, 98,188,131,180,105, 47, 58,255,175, 39, 22,147,172
;  .byte     7, 31,184,109, 17, 52, 45,141,239, 79,137,212,182, 99, 53,193
;  .byte   199,228, 36,131,103,216,237,150, 18,236, 69, 57,  2,216,229, 10
;  .byte   248,157,119,  9,209,165,150,193,244, 31,149,170,130,202,108, 73
;  .byte   174,144,205, 22,104,186,172,122,166,242,180,168,202,153,178,194
;  .byte    55, 42,203,  8,207, 97,201,195,128, 94,110,  3, 40,218, 76,215
;  .byte   106, 25,237,210,211,153, 76,121,139,  0, 34, 86,154,212, 24,209
;  .byte   254,228,217,205, 69,163,145,198,  1,255,201, 42,217, 21,  1, 67
;  .byte    47,238, 21,  2,135, 97,124, 19, 98,158,105,252,114,129,205,113
;  .byte   101,166, 62,171, 73,207,113, 75,206, 58,117,167, 79,118,234,126
;  .byte   100,255,129,235, 97,253,254,195,155,103,191, 13,233,140,126, 78
;  .byte    50,189,249,124,140,106,199, 91,164, 60,  2,244,178,237,114, 22

;.align 4
;OutCbBaseAddr:
;/* ReconstructCb Intra*/
;.byte   236,  1,240, 16,103,153, 91,159
;.byte   212, 10,  3,188, 13,155,171,213
;.byte     1,229,214,125,197,142, 46,175
;.byte   198, 99,138,112,222, 86, 26, 33
;.byte     1, 13,253, 22,161,227,210,210
;.byte    75, 97, 85,108,221,188,237, 19
;.byte   229,199,171,164,129, 28, 26,235
;.byte    36, 59, 30,172,106,243, 70, 71

;.align 4
;OutCrBaseAddr:
;/* ReconstructCr Intra*/
;.byte   243, 77,  0,139,207, 80, 23,142
;.byte   152, 97,209,167,190,191, 14,152
;.byte   214,242,246, 62, 22, 33, 45,  2
;.byte   185,201, 31,151, 12,137, 43, 27
;.byte     7,216,139,194,164,207,146,152
;.byte    53,213,209, 51,194,247,222,239
;.byte    32,226,221, 77,136, 83,238,102
;.byte    76,121,168,251,104, 88,  6, 43

;OutCbBaseAddr:
;OutCbReconstructed Inter:
;.byte   236,  1,240, 16,103,153, 91,159
;.byte   212, 10,  3,188, 13,155,171,213
;.byte     1,229,214,125,197,142, 46,175
;.byte   198, 99,138,112,222, 86, 26, 33
;.byte     1, 13,253, 22,161,227,210,210
;.byte    75, 97, 85,108,221,188,237, 19
;.byte   229,199,171,164,129, 28, 26,235
;.byte    36, 59, 30,172,106,243, 70, 71

;.align 4
;OutCrBaseAddr:
;OutCrReconstructed Inter:
;.byte   243, 77,  0,139,207, 80, 23,142
;.byte   152, 97,209,167,190,191, 14,152
;.byte   214,242,246, 62, 22, 33, 45,  2
;.byte   185,201, 31,151, 12,137, 43, 27
;.byte     7,216,139,194,164,207,146,152
;.byte    53,213,209, 51,194,247,222,239
;.byte    32,226,221, 77,136, 83,238,102
;.byte    76,121,168,251,104, 88,  6, 43

;  /* Residual Y I16*/
;  .half     -81,  -86,  -67,   14,   60,   34,   71,    2,  126,  -34,  104,  -52,  133,  119,   16,   50
;  .half     -75,  -17,   55,   12,  -15,  -26,  -36,  -19,  -34,   20,  -49,   -7,   29,  -52,  -18,  142
;  .half     -51,   -4,  -25,  -78,  -62,  -54,   74,  -49,   49,   54,   23,   44,   29,  144,  -63,  148
;  .half     -42,   73,  -22, -144,  -47,   98,  -13,   62,    0,   69,  -77,  147,  129,   10,  132,   17
;  .half    -163,  -69,   13,  -57,   39,  -12,   44,  -25,  -77,  -59,  144,   70,  -59,  -70,   61,   93
;  .half    -167, -137,   22,  -46, -132,  -91,  -91,   11,  115,  -38,   26,  107,   84,    7,  -32,  114
;  .half      25,   60, -125,  -24,  -46,   74,  101,   20, -105,  119,  -42,  -47,  -96,  124,  144,  -69
;  .half      74,  -11,  -42, -146,   60,   23,   14,   63,  121,  -86,   39,   66,   32,  111,   23,   -6
;  .half       0,  -23,   44, -133,  -44,   44,   36,   -7,   43,  125,   70,   64,  104,   62,   93,  115
;  .half    -119, -125,   42, -147,   59,  -45,   66,   66,    5,  -22,    0, -101,  -57,  127,   -9,  137
;  .half     -67, -142,   76,   56,   63,   11,  -59,   -8,   16, -116,  -76,  -18,   57,  121,  -61,  131
;  .half      81,   61,   57,   51,  -79,   22,   10,   69, -121,  139,   91,  -61,  120,  -70,  -83,  -11
;  .half    -126,   71, -139, -152,  -13,  -44,  -11, -110,  -24,   42,   -5,  149,   17,   38,  121,   35
;  .half     -72,    0,  -98,   17,  -74,   66,  -22,  -53,   84,  -58,    8,   64,  -18,   28,  150,   48
;  .half     -73,   89,  -31,   81,  -50,  112,  119,   67,   33,  -13,   82,  -90,  137,   50,   42,    1
;  .half    -122,   23,   89,  -29,   -7,  -35,   65,  -37,   42,  -55, -107,  141,   82,  147,   30,  -55

;  /* Residual Y I4*/
;  .half     -19,  -30,  -17,   57,  112,   80,  110,   35,  106,    3,  158,    9,  104,   84,  -26,    2
;  .half     -13,   39,  104,   55,   37,   19,    3,   14,  -59,   -6,  -18,   40,    0,  -87,  -60,   94
;  .half      11,   52,   24,  -35,  -11,   -9,  113,  -17,   63,   23,  -10,   68,    0,  108, -105,  100
;  .half      20,  128,   27, -101,    4,  143,   26,   94,    7,   77, -115,  108,  100,  -26,   90,  -31
;  .half    -124,  -36,   40,  -37,   62,    5,   54,  -21, -102,  -95,   98,   42, -118, -135,  -10,   15
;  .half    -128, -104,   49,  -26, -109,  -74,  -81,   15,  116,  -57,  -12,   59,   25,  -58, -104,   36
;  .half      64,   93,  -99,   -4,  -23,   90,  111,   24, -128,  102,  -54,  -79, -155,   59,   72, -147
;  .half     113,   22,  -16, -126,   83,   39,   24,   67,   72, -128,    3,   36,  -27,   45,  -49,  -84
;  .half       4,   43,  118, -126, -105,   21,   22,  -71,   52,  117,   25,   10,   33,   -7,   20,   33
;  .half     -46,  -45,   55, -164,   -2,  -68,   51,    2,    3,  -61,  -48, -158,  -46,   91,  -93,   55
;  .half      19, -123,   65,   45,    2,  -12,  -74,  -72,  -16, -158, -127,  -37,  109,  147,  -62,   82
;  .half     106,   56,   52,   23, -140,   -2,   -5,    5, -157,   94,   78,  -40,  153,  -33,  -44,    2
;  .half       5,  196,  -21,  -40,   -3,  -41,  -14, -119,  -80,  -17,  -21,  128,   -9,    6,   82,  -10
;  .half     -70,   -5, -109,    0,  -65,   69,  -25,  -63,   31,  -68,   -7,  102,  -44,   -5,  111,    3
;  .half     -86,   69,  -57,   49,  -41,  115,  116,   57,   29,  -21,  126,  -10,  110,   17,    3,  -45
;  .half     -28,  111,  171,   46,    2,  -32,   61,  -47,   40,   -5,  -21,  193,   55,  114,   -9, -101

;  /* Residual Y Inter*/
;  .half      -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5
;  .half      -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5
;  .half      -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5
;  .half      -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,    5,   -5,   -5,   -5,   -5
;  .half      -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,    5,   -5,   -5,   -5,   -5,   -5
;  .half      -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5
;  .half      -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5
;  .half      -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5
;  .half      -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5
;  .half      -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5
;  .half      -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5
;  .half       5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,    5,   -5,   -5,   -5,   -5,   -5,   -5
;  .half      -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,    5,   -5,   -5,   -5,   -5
;  .half      -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5
;  .half      -5,    5,   -5,   -5,   -5,    5,    5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5
;  .half      -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5

;OutCbBaseAddr:
;/* ResidualCb Intra*/
;.half     108, -127,  112, -112,  -68,  -18,  -80,  -12
;.half      84, -118, -125,   60, -158,  -16,    0,   42
;.half    -127,  101,   86,   -3,   26,  -29, -125,    4
;.half      70,  -29,   10,  -16,   51,  -85, -145, -138
;.half    -146, -134,  106, -125,    2,   68,   51,   51
;.half     -72,  -50,  -62,  -39,   62,   29,   78, -140
;.half      82,   52,   24,   17,  -30, -131, -133,   76
;.half    -111,  -88, -117,   25,  -53,   84,  -89,  -88

;.align 4
;OutCrBaseAddr:
;/* ResidualCr Intra*/
;.half     116,  -50, -127,   12,   76,  -51, -108,   11
;.half      25,  -30,   82,   40,   59,   60, -117,   21
;.half      87,  115,  119,  -65, -109,  -98,  -86, -129
;.half      58,   74,  -96,   24, -119,    6,  -88, -104
;.half    -103,  106,   29,   84,   44,   87,   26,   32
;.half     -57,  103,   99,  -59,   74,  127,  102,  119
;.half     -78,  116,  111,  -33,   16,  -37,  118,  -18
;.half     -34,   11,   58,  141,  -16,  -32, -114,  -77

;OutCbBaseAddr:
;/* ResidualCb Inter*/
;.half     152, -153,   52,    2,  -65,  -19, -152,   83
;.half     167,    1, -226,   -8, -162,   -8,   44,   40
;.half    -117,    7,  186,   51,  149,  110,  -87,  -76
;.half     191, -145,  127,   80,   88,   24, -215, -184
;.half     -50, -140,   90,    2,  -56,  -20,   50,  194
;.half    -171,  -51, -105,  -80,  101,  115,    7, -189
;.half      11,   93,   95,   83,  -50, -104,  -32,  -16
;.half    -117,    9,  -38,   17, -127,  206,   62, -162

;.align 4
;OutCrBaseAddr:
;/* ResidualCr Inter*/
;.half     171,   67, -213,  115,  139,  -11, -119,  -73
;.half      -3,   31,  203,  116,  -15,   59,  -31,  -60
;.half     143,  192,   10, -134, -224,   -2,  -63, -176
;.half     181,  -35, -154,  -35, -183,  132, -193,  -76
;.half    -176,  136,  -88,  -17,  112,  113,  -96,  -16
;.half      48,  212,   29,  -17,  -56,  142,  187,  213
;.half     -73,  100,   95,   40,   64,    0,   90,   53
;.half     -68,   34,  -70,   63, -125, -119, -239, -183

