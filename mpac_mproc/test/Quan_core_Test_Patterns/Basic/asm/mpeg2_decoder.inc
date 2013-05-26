;
; Definition of the data structure for Mpeg2 Decoder Rev. 0.2_SCT_7056 (20100527)
;

;PACDSP Memory Map Address

;DSP0_BASE_ADDR					= 0x1e000000 
DSP0_BASE_ADDR					= 0x24000000

DSP0_DMA_BASE					= DSP0_BASE_ADDR + 0x58000

;
DMEM							= 0x00000 ; Data Memory 64KB , 0x1e000000~0x1e00ffff

M2_BASE_ADDR            =0x25000000

;;;
;;; DMA register offset
;;;

DSP0_DMASR					    	= 0x0054	;R	R	DMA status register
; channel 0
DSP0_DMASAR0						  = 0x4070	;RW	RW	DMA start address
DSP0_DMADAR0   					  = 0x4074	;RW	RW	DMA destination address
DSP0_DMASGR0   					  = 0x4078	;RW	RW	Source gather register
DSP0_DMADSR0   				  	= 0x407C	;RW	RW	Destination scatter
DSP0_DMACTL0   					  = 0x4080	;RW	RW	DMA control register
DSP0_DMAEN0   						= 0x4084	;W	W	Enable the data movement
DSP0_DMACLR0						  = 0x4088	;W	W	Clear the DMA interruption signal
DSP0_DMALLST0						  = 0x408C
DSP0_DMAPDCTL0						= 0x4090
DSP0_DMASHAPE0						= 0x4094
DSP0_DMARES0						  = 0x4098
 
; channel 1
DSP0_DMASAR1						  = 0x40B0	;RW	RW	DMA start address
DSP0_DMADAR1   					  = 0x40B4	;RW	RW	DMA destination address
DSP0_DMASGR1   					  = 0x40B8	;RW	RW	Source gather register
DSP0_DMADSR1   				  	= 0x40BC	;RW	RW	Destination scatter
DSP0_DMACTL1   					  = 0x40C0	;RW	RW	DMA control register
DSP0_DMAEN1   						= 0x40C4	;W	W	Enable the data movement
DSP0_DMACLR1						  = 0x40C8	;W	W	Clear the DMA interruption signal
DSP0_DMALLST1						  = 0x40CC
DSP0_DMAPDCTL1						= 0x40D0
DSP0_DMASHAPE1						= 0x40D4
DSP0_DMARES1						  = 0x40D8

; channel 2
DSP0_DMASAR2						  = 0x40F0	;RW	RW	DMA start address
DSP0_DMADAR2   					  = 0x40F4	;RW	RW	DMA destination address
DSP0_DMASGR2   					  = 0x40F8	;RW	RW	Source gather register
DSP0_DMADSR2   				  	= 0x40FC	;RW	RW	Destination scatter
DSP0_DMACTL2   					  = 0x4100	;RW	RW	DMA control register
DSP0_DMAEN2   						= 0x4104	;W	W	Enable the data movement
DSP0_DMACLR2						  = 0x4108	;W	W	Clear the DMA interruption signal
DSP0_DMALLST2						  = 0x410C
DSP0_DMAPDCTL2						= 0x4110
DSP0_DMASHAPE2						= 0x4114
DSP0_DMARES2						  = 0x4118

; channel 3
DSP0_DMASAR3						  = 0x4130	;RW	RW	DMA start address
DSP0_DMADAR3   					  = 0x4134	;RW	RW	DMA destination address
DSP0_DMASGR3   					  = 0x4138	;RW	RW	Source gather register
DSP0_DMADSR3   				  	= 0x413C	;RW	RW	Destination scatter
DSP0_DMACTL3   					  = 0x4140	;RW	RW	DMA control register
DSP0_DMAEN3   						= 0x4144	;W	W	Enable the data movement
DSP0_DMACLR3						  = 0x4148	;W	W	Clear the DMA interruption signal
DSP0_DMALLST3						  = 0x414C
DSP0_DMAPDCTL3						= 0x4150
DSP0_DMASHAPE3						= 0x4154
DSP0_DMARES3						  = 0x4158



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;
; Definition of the data structure for Mpeg2 Decoder Rev.  0.2_SCT_7056 (20100527)
;

; 1. Sequence_Header structure (offset) Total 173 bytes
start_code				=	0	; 1 bytes
Error_flag				=	1	; 1 bytes
aspect_ratio_information		=	2	; 1 bytes
frame_rate_code				=	3	; 1 bytes
bit_rate				=	4	; 4 bytes
horizontal_size				=	8	; 4 bytes
vertical_size				=	12	; 4 bytes
Image_size				=	16	; 4 bytes
Chroma_size				=	20	; 4 bytes
intra_quantiser_matrix			=	24	; 64 bytes
non_intra_quantiser_matrix		= 	88	; 64 bytes
vbv_buffer_size_value			=	152	; 2 bytes
constrained_parameter_flag		=	154	; 1 byte
load_intra_quantiser_matrix		=	155	; 1 byte
load_non_intra_quantiser_matrix		=	156	; 1 byte
mb_width				=	157	; 1 byte
mb_height				=	158	; 1 byte
frame_16x16_flag    = 159 ; 1 byte
display_order				=	160	; 2 byte
Rev_2B              = 162 ; 2 bytes
Coded_Image_size				=	164	; 4 bytes
Coded_Chroma_size				=	168	; 4 bytes
Mpeg2_flag          = 172 ; 1 byte


; 2. Sequence_Extension structure (offset) Total 11 bytes
profile_and_level_indication		=	0	; 1 byte
progressive_sequence			=	1	; 1 byte
horizontal_size_extension		=	2	; 1 byte
vertical_size_extension			=	3	; 1 byte
bit_rate_extension			=	4	; 2 byte
chroma_format				=	6	; 1 byte
vbv_buffer_size_extension		=	7	; 1 byte
low_delay				=	8	; 1 byte
frame_rate_extension_n			=	9	; 1 byte
frame_rate_extension_d			=	10	; 1 byte

; 3. GOP_header structure (offset) Total 7 bytes
time_code				=	0	; 4 byte
closed_gop				=	4	; 1 byte
broken_link				=	5; 1 byte
field_count_flag			=	6	; 1 byte

; 4. Picture_data (Picture_header and Picture_coding_extension structure) (offset) Total 39 bytes
temporal_reference			=	0	; 2 bytes
picture_coding_type			=	2	; 1 byte
mb_row_reg				=	3	; 1 byte
increment_flag				=	4	; 1 byte
increment_temp				=	5	; 1 byte
previous_MB_address			=	6	; 2 byte
vbv_delay				=	8	; 2 byte
extra_information_picture		=	10	; 1 byte
IP_frame_retain				=	11	; 1 byte
f_code00	 			=	12	; 1 byte
f_code01 				=	13	; 1 byte
f_code10 				=	14	; 1 byte
f_code11 				=	15	; 1 byte
intra_dc_precision 			=	16	; 1 byte
picture_structure 			=	17	; 1 byte
frame_pred_frame_dct 			=	18	; 1 byte
concealment_motion_vectors 		=	19	; 1 byte
q_scale_type 				=	20	; 1 byte
intra_vlc_format 			=	21	; 1 byte
alternate_scan 				=	22	; 1 byte
top_field_first				=	23	; 1 byte
composite_display_flag			=	24	; 1 byte
repeat_first_field			=	25	; 1 byte
chroma_420_type				=	26	; 1 byte
progressive_frame			=	27	; 1 byte
v_axis					=	28	; 1 byte
field_sequence				=	29	; 1 byte
sub_carrier				=	30	; 1 byte
burst_amplitude				=	31	; 1 byte
sub_carrier_phase			=	32	; 1 byte
intra_dc_mult			    =	33	; 1 byte
full_pel_vector_0     = 34  ; 1 byte
full_pel_vector_1     = 35  ; 1 byte
Pipeline_flag_A       = 36  ; 1 byte
Pipeline_flag_B       = 37  ; 1 byte
Pipeline_skip_flag    = 38  ; 1 byte

; 5. Slice_data structure (offset) Total 1768 bytes
slice_vertical_position_extension	=	0   	; 1 byte
slice_quantiser_scale_code              =       1       ; 1 byte
mb_row                                  =       2       ; 1 byte
mb_column                               =       3       ; 1 byte
Same_slice_flag                         =       4       ; 1 byte
intra_slice_flag                        =       5       ; 1 byte
intra_slice                             =       6       ; 1 byte
extra_information_slice                 =       7       ; 1 byte
dc_dct_pred0    	                =       8  	; 2 bytes 
dc_dct_pred1	                        =       10      ; 2 bytes 
dc_dct_pred2            	        =       12 	; 2 bytes 
MB_type                                 =       14   	; 1 byte
dct_type                                =       15 	; 1 byte
PMV0_0_0                              	=       16	; 2 bytes
PMV0_0_1                              	=       18      ; 2 bytes
PMV0_1_0                              	=       20 	; 2 bytes
PMV0_1_1                              	=       22      ; 2 bytes
PMV1_0_0                             	=       24      ; 2 bytes
PMV1_0_1                              	=       26      ; 2 bytes
PMV1_1_0                              	=       28 	; 2 bytes
PMV1_1_1	                      	=       30      ; 2 bytes
opposite_vec_0_0                        =     32  ; 2 bytes
opposite_vec_0_1                        =     34  ; 2 bytes
opposite_vec_1_0                        =     36  ; 2 bytes
opposite_vec_1_1                        =     38  ; 2 bytes
MV0_vector_0_0                      	=       40 	; 2 bytes
MV0_vector_0_1                     	=       42      ; 2 bytes
MV0_vector_1_0                      	=       44      ; 2 bytes
MV0_vector_1_1                      	=       46      ; 2 bytes
MV0_vector_chroma_0_0               	=       48      ; 2 bytes
MV0_vector_chroma_0_1               	=       50      ; 2 bytes
MV0_vector_chroma_1_0               	=       52      ; 2 bytes
MV0_vector_chroma_1_1               	=       54      ; 2 bytes
MV1_vector_0_0                     	=       56 	; 2 bytes
MV1_vector_0_1                      	=       58      ; 2 bytes
MV1_vector_1_0                      	=       60      ; 2 bytes
MV1_vector_1_1                      	=       62      ; 2 bytes
MV1_vector_chroma_0_0               	=       64      ; 2 bytes
MV1_vector_chroma_0_1               	=       66      ; 2 bytes
MV1_vector_chroma_1_0               	=       68      ; 2 bytes
MV1_vector_chroma_1_1               	=       70      ; 2 bytes
MB_quantiser_scale_code                 =       72      ; 1 byte
mv_format                               =       73      ; 1 byte
prediction_type                         =       74      ; 1 byte
dmv                                     =       75      ; 1 byte
motion_vertical_field_select_0_0      	=       76      ; 1 byte
motion_vertical_field_select_0_1      	=       77      ; 1 byte
motion_vertical_field_select_1_0      	=       78      ; 1 byte
motion_vertical_field_select_1_1	      =       79      ; 1 byte
motion_vector_count                     =       80      ; 1 byte
field_select                            =       81      ; 1 byte
pattern_code                            =       82      ; 1 byte
Ent_run                                 =       83	; 1 bytes
Ent_level                               =       84	; 2 bytes
dc_dct_differential                     =       86	; 2 bytes
QFS	                                =       88 	; 64x2= 128 bytes
block_in                             	=       216	; 64x4= 256 bytes
block_out                            	=       472	; 64x4=256 bytes
QF                                   	=       728	; 64x2= 128 bytes
Quantize_matrix                      	=       856	; 64 bytes
Ref_num                                 =       920 	; 1 byte
Mode_select                             =       921   ; 1 byte
dmvector_0                              =       922   ; 1 byte
dmvector_1                              =       923   ; 1 byte
IQ_value                                =       924   ; 1 byte
Ref_count                               =       925 	; 1 byte

Mpeg1_MB_Space					                =	926	; 1 byte
IDCT_Mode                               = 927 ; 1 byte


Prediction_buf_0                        = 928 ; 4 bytes
half_flag_0_0                           = 932 ; 1 byte
half_flag_0_1                           = 933 ; 1 byte
half_flag_chroma_0_0                    = 934 ; 1 byte
half_flag_chroma_0_1                    = 935 ; 1 byte
row_size_0                              = 936 ; 1 byte
row_step_ref_0                          = 937 ; 1 byte
average_flag_0                          = 938 ; 1 byte
ref_y_0                                 = 939 ; 1 byte
row_start_0                             = 940 ; 1 byte
row_step_0                              = 941 ; 1 byte
Rev_2B_0					                      =	942	; 2 bytes

Prediction_buf_1                        = 944 ; 4 bytes
half_flag_1_0                           = 948 ; 1 byte
half_flag_1_1                           = 949 ; 1 byte
half_flag_chroma_1_0                    = 950 ; 1 byte
half_flag_chroma_1_1                    = 951 ; 1 byte
row_size_1                              = 952 ; 1 byte
row_step_ref_1                          = 953 ; 1 byte
average_flag_1                          = 954 ; 1 byte
ref_y_1                                 = 955 ; 1 byte
row_start_1                             = 956 ; 1 byte
row_step_1                              = 957 ; 1 byte
Rev_2B_1					                      =	958	; 2 bytes

Prediction_buf_2                        = 960 ; 4 bytes
half_flag_2_0                           = 964 ; 1 byte
half_flag_2_1                           = 965 ; 1 byte
half_flag_chroma_2_0                    = 966 ; 1 byte
half_flag_chroma_2_1                    = 967 ; 1 byte
row_size_2                              = 968 ; 1 byte
row_step_ref_2                          = 969 ; 1 byte
average_flag_2                          = 970 ; 1 byte
ref_y_2                                 = 971 ; 1 byte
row_start_2                             = 972 ; 1 byte
row_step_2                              = 973 ; 1 byte
Rev_2B_2					                      =	974	; 2 bytes

Prediction_buf_3                        = 976 ; 4 bytes
half_flag_3_0                           = 980 ; 1 byte
half_flag_3_1                           = 981 ; 1 byte
half_flag_chroma_3_0                    = 982 ; 1 byte
half_flag_chroma_3_1                    = 983 ; 1 byte
row_size_3                              = 984 ; 1 byte
row_step_ref_3                          = 985 ; 1 byte
average_flag_3                          = 986 ; 1 byte
ref_y_3                                 = 987 ; 1 byte
row_start_3                             = 988 ; 1 byte
row_step_3                              = 989 ; 1 byte
Rev_2B_3					                      =	990	; 2 bytes

MB_reg_Y				                        =  992	; 2x2=512 bytes
MB_reg_U				                        =	1504	; 64x2=128 bytes
MB_reg_V				                        =	1632	; 64x2=128 bytes

clip_start_offset                       =  1760     ;2 bytes
clip_type                               =  1762     ;1 byte
Rev_1B                                  =  1763     ;1 byte
slice_start_flag                        =  1764     ;1 byte
mb_Pipeline_bit                         =  1765     ;1 byte
mb_row_Pipeline                         =  1766     ; 1 byte
mb_column_Pipeline                      =  1767     ; 1 byte


; 6. Frame_memory (Frame and store memory) (offset) Total 4442 bytes
Forward_pred_Y				=	0	; 256x1=256 bytes
Forward_pred_U				=	256	; 64x1=64 bytes
Forward_pred_V				=	320	; 64x1=64 bytes
Backward_pred_Y				=	384	; 256x1=256 bytes
Backward_pred_U				=	640	; 64x1=64 bytes
Backward_pred_V				=	704	; 64x1=64 bytes

M1_M2_OFFSET          = M2_BASE_ADDR - DSP0_BASE_ADDR ; (0x25000000-0x24000000)
Ref_MB_0_Y				=	M1_M2_OFFSET + 768	; 17x34 = 578 bytes + 6
Ref_MB_0_U				=	M1_M2_OFFSET + 1352	; 9x18=162 bytes + 6
Ref_MB_0_V				=	M1_M2_OFFSET + 1520	; 9x18=162 bytes + 6
Ref_MB_1_Y				=	M1_M2_OFFSET + 1688	; 17x34 = 578 bytes + 6
Ref_MB_1_U				=	M1_M2_OFFSET + 2272	; 9x18=162 bytes + 6
Ref_MB_1_V				=	M1_M2_OFFSET + 2440	; 9x18=162 bytes + 6
Ref_MB_2_Y				=	M1_M2_OFFSET + 2608	; 17x34 = 578 bytes + 6
Ref_MB_2_U				=	M1_M2_OFFSET + 3192	; 9x18=162 bytes + 6
Ref_MB_2_V				=	M1_M2_OFFSET + 3360	; 9x18=162 bytes + 6
Ref_MB_3_Y				=	M1_M2_OFFSET + 3528	; 17x34 = 578 bytes + 6
Ref_MB_3_U				=	M1_M2_OFFSET + 4112	; 9x18=162 bytes + 6
Ref_MB_3_V				=	M1_M2_OFFSET + 4280	; 9x18=162 bytes

;Ref_MB_0_Y				=	768	; 17x34 = 578 bytes + 6
;Ref_MB_0_U				=	1352	; 9x18=162 bytes + 6
;Ref_MB_0_V				=	1520	; 9x18=162 bytes + 6
;Ref_MB_1_Y				=	1688	; 17x34 = 578 bytes + 6
;Ref_MB_1_U				=	2272	; 9x18=162 bytes + 6
;Ref_MB_1_V				=	2440	; 9x18=162 bytes + 6
;Ref_MB_2_Y				=	2608	; 17x34 = 578 bytes + 6
;Ref_MB_2_U				=	3192	; 9x18=162 bytes + 6
;Ref_MB_2_V				=	3360	; 9x18=162 bytes + 6
;Ref_MB_3_Y				=	3528	; 17x34 = 578 bytes + 6
;Ref_MB_3_U				=	4112	; 9x18=162 bytes + 6
;Ref_MB_3_V				=	4280	; 9x18=162 bytes


; 7. Init_table (0ffset) Total 864 bytes
Default_intra_quantiser_matrix		=	0	; 64 bytes
Scan					=	64	; 2x64=128 bytes
Quantiser_scale				=	192	; 32 bytes
scale					=	224	; 2x64=128 bytes
IS_address    = 352 ; 4*64=256 bytes
IS_address2   = 608 ; 4*64=256 bytes

; 8. Entropy_table [Table B-1 ~ B-4, B-9 ~ B-15] (offset) Total 1304 bytes
B1_startbit				=	0	; 1 byte
B1_maxcomptimes				=	1	; 1 byte
tableB1					=	2	; 108 bytes
B2_startbit				=	110	; 1 byte
B2_maxcomptimes				=	111	; 1 byte
tableB2					=	112	; 8 bytes
B3_startbit				=	120	; 1 byte
B3_maxcomptimes				=	121	; 1 byte
tableB3					=	122	; 32 bytes
B4_startbit				=	154	; 1 byte
B4_maxcomptimes				=	155	; 1 byte
tableB4					=	156	; 36 bytes
B9_startbit				=	192	; 1 byte
B9_maxcomptimes				=	193	; 1 byte
tableB9					=	194	; 220 bytes
B10_startbit				=	414	; 1 byte
B10_maxcomptimes			=	415	; 1 byte
tableB10				=	416	; 108 bytes
B12_startbit				=	524	; 1 byte
B12_maxcomptimes			=	525	; 1 byte
tableB12				=	526	; 48 bytes
B13_startbit				=	574	; 1 byte
B13_maxcomptimes			=	575	; 1 byte
tableB13				=	576	; 64 bytes
B14_startbit				=	640	; 1 byte
B14_maxcomptimes			=	641	; 1 byte
tableB14				=	642	; 316 bytes
B15_startbit				=	958	; 1 byte
B15_maxcomptimes			=	959	; 1 byte
tableB15				=	960	; 344 bytes

; 9. BitStream data structure (offset) Total 31 bytes                     
H264BitStream         			=	0    	; 4 bytes 
H264BitStreamSize     			=	4     	; 4 bytes
H264BitStreamByteCount			=	8      	; 4 bytes
CurrentBuffer         			= 	12      ; 4 bytes
BytePos               			= 	16     	; 4 bytes
DataCache             			=	20   	; 4 bytes
ByteLeft              			=    	24   	; 4 bytes
LastLength				= 	28   	; 2 bytes
BitLeftInCache        			=	30     	; 1 byte

; 10. Global variables (offset) Total 48 bytes   
REFFRAME_ADDR	  =  0 ; 4 bytes  (0xb00a1f00)
Frame_Count	    =  4 ; 4 bytes  (0xb00a1f04)
YSize		        =  8 ; 4 bytes  (0xb00a1f08)
MB_Count        = 12 ; 4 bytes  (0xb00a1f0c)
FrameWidth_Multi= 16 ; 4 bytes  (0xb00a1f10) ;horizontal_size*1.5
Ref_Front_ADDR  = 20 ; 4 bytes  (0xb00a1f14)
Ref_Back_ADDR   = 24 ; 4 bytes  (0xb00a1f18)
Decode_ADDR     = 28 ; 4 bytes  (0xb00a1f1c)
Memcpy_Mode     = 32 ; 4 bytes  (0xb00a1f20)
Padding_Luma    = 36 ; 4 bytes  (0xb00a1f24)
Padding_Chroma  = 40 ; 4 bytes  (0xb00a1f28)
Ref_Copy_ADDR   = 44 ; 4 bytes  (0xb00a1f2c)
Print_Start_ADDR= 48 ; 4 bytes  (0xb00a1f30)
Print_End_ADDR  = 52 ; 4 bytes  (0xb00a1f34)
SDMA_Moving_Times  = 56 ; 4 bytes  (0xb00a1f38)
Last_SDMA_Moving_Size  = 60 ; 4 bytes  (0xb00a1f3c)
Frame_Size_420 = 64  ; 4 bytes  (0xb00a1f40)
Exception_Flag = 68  ; 4 bytes  (0xb00a1f44)
; ===============================
; Constant definition
; ===============================

Iframe					=	1
Pframe					=	2
Bframe					=	3
Dframe					=	4

Top_field				=	1
Bottom_field				=	2
Frame_picture				=	3
block_count				=	6

;Start code
sequence_start_code			=	0xb3
extension_start_code			=	0xb5
sequence_end_code			=	0xb7
GOP_start_code				=	0xb8
picture_start_code			=	0x00
slice_start_code_low			=	0x01
slice_start_code_high			=	0xaf

; macroblock type
macroblock_quant      =	0x10
macroblock_motion_forward		=	0x08
macroblock_motion_backward		=	0x04
macroblock_pattern			=	0x02
macroblock_intra			=	0x01

Frame_buffer_size			=	32
StreamBufferSize 			= 0x0800 	  ; 2048 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


   
   EMDMAC_ADDR    =     0x25820000
   M2_DMA_TEMP_ADDR = 0x2501f000
   ;M2_EMDMA_OFFSET = 0x801000     ;(0x25820000 - 0x2501f000)
   M2_EMDMA_OFFSET = 0

	 R054_DMASTAT    =    M2_EMDMA_OFFSET + 0x054 
	 
;;// Channel 0 Registers
	 R070_SAR0      =     M2_EMDMA_OFFSET + 0x070 
   R074_DAR0      =     M2_EMDMA_OFFSET + 0x074 
   R078_SGR0      =     M2_EMDMA_OFFSET + 0x078 
   R07C_DSR0      =     M2_EMDMA_OFFSET + 0x07C
	 R080_CTL0      =     M2_EMDMA_OFFSET + 0x080 
	 R084_EN0       =     M2_EMDMA_OFFSET + 0x084 
	 R088_CLR0      =     M2_EMDMA_OFFSET + 0x088 
	 R08C_LLST0     =     M2_EMDMA_OFFSET + 0x08C 
	 R090_PDCTL0    =     M2_EMDMA_OFFSET + 0x090 
	 R094_SHAPE0    =     M2_EMDMA_OFFSET + 0x094 
	 R098_RES0      =     M2_EMDMA_OFFSET + 0x098 
	 
    

;;// Channel 1 Registers

	 R0B0_SAR1      =     M2_EMDMA_OFFSET + 0x0B0 
   R0B4_DAR1      =     M2_EMDMA_OFFSET + 0x0B4 
   R0B8_SGR1      =     M2_EMDMA_OFFSET + 0x0B8 
   R0BC_DSR1      =     M2_EMDMA_OFFSET + 0x0BC
	 R0C0_CTL1      =     M2_EMDMA_OFFSET + 0x0C0 
	 R0C4_EN1       =     M2_EMDMA_OFFSET + 0x0C4 
	 R0C8_CLR1      =     M2_EMDMA_OFFSET + 0x0C8 
	 R0CC_LLST1     =     M2_EMDMA_OFFSET + 0x0CC 
	 R0D0_PDCTL1    =     M2_EMDMA_OFFSET + 0x0D0 
	 R0D4_SHAPE1    =     M2_EMDMA_OFFSET + 0x0D4 
	 R0D8_RES1      =     M2_EMDMA_OFFSET + 0x0D8 
	 
   
	 
;;// Channel 2 Registers

	 R0F0_SAR2      =     M2_EMDMA_OFFSET + 0x0F0 
   R0F4_DAR2      =     M2_EMDMA_OFFSET + 0x0F4 
   R0F8_SGR2      =     M2_EMDMA_OFFSET + 0x0F8 
   R0FC_DSR2      =     M2_EMDMA_OFFSET + 0x0FC
	 R100_CTL2      =     M2_EMDMA_OFFSET + 0x100 
	 R104_EN2       =     M2_EMDMA_OFFSET + 0x104 
	 R108_CLR2      =     M2_EMDMA_OFFSET + 0x108 
	 R10C_LLST2     =     M2_EMDMA_OFFSET + 0x10C 
	 R110_PDCTL2    =     M2_EMDMA_OFFSET + 0x110 
	 R114_SHAPE2    =     M2_EMDMA_OFFSET + 0x114 
	 R118_RES2      =     M2_EMDMA_OFFSET + 0x118 

   
	 
;;// Channel 3 Registers

	 R130_SAR3      =     M2_EMDMA_OFFSET + 0x130 
   R134_DAR3      =     M2_EMDMA_OFFSET + 0x134 
   R138_SGR3      =     M2_EMDMA_OFFSET + 0x138 
   R13C_DSR3      =     M2_EMDMA_OFFSET + 0x13C
	 R140_CTL3      =     M2_EMDMA_OFFSET + 0x140 
	 R144_EN3       =     M2_EMDMA_OFFSET + 0x144 
	 R148_CLR3      =     M2_EMDMA_OFFSET + 0x148 
	 R14C_LLST3     =     M2_EMDMA_OFFSET + 0x14C 
	 R150_PDCTL3    =     M2_EMDMA_OFFSET + 0x150 
	 R154_SHAPE3    =     M2_EMDMA_OFFSET + 0x154 
	 R158_RES3      =     M2_EMDMA_OFFSET + 0x158 
	 
    
	 
;;// Channel 4 Registers

	 R170_SAR4      =     M2_EMDMA_OFFSET + 0x170 
   R174_DAR4      =     M2_EMDMA_OFFSET + 0x174 
   R178_SGR4      =     M2_EMDMA_OFFSET + 0x178 
   R17C_DSR4      =     M2_EMDMA_OFFSET + 0x17C
	 R180_CTL4      =     M2_EMDMA_OFFSET + 0x180 
	 R184_EN4       =     M2_EMDMA_OFFSET + 0x184 
	 R188_CLR4      =     M2_EMDMA_OFFSET + 0x188 
	 R18C_LLST4     =     M2_EMDMA_OFFSET + 0x18C 
	 R190_PDCTL4    =     M2_EMDMA_OFFSET + 0x190 
	 R194_SHAPE4    =     M2_EMDMA_OFFSET + 0x194 
	 R198_RES4      =     M2_EMDMA_OFFSET + 0x198 

   
	 
;;// Channel 5 Registers

	 R1B0_SAR5      =     M2_EMDMA_OFFSET + 0x1B0 
   R1B4_DAR5      =     M2_EMDMA_OFFSET + 0x1B4 
   R1B8_SGR5      =     M2_EMDMA_OFFSET + 0x1B8 
   R1BC_DSR5      =     M2_EMDMA_OFFSET + 0x1BC
	 R1C0_CTL5      =     M2_EMDMA_OFFSET + 0x1C0 
	 R1C4_EN5       =     M2_EMDMA_OFFSET + 0x1C4 
	 R1C8_CLR5      =     M2_EMDMA_OFFSET + 0x1C8 
	 R1CC_LLST5     =     M2_EMDMA_OFFSET + 0x1CC 
	 R1D0_PDCTL5    =     M2_EMDMA_OFFSET + 0x1D0 
	 R1D4_SHAPE5    =     M2_EMDMA_OFFSET + 0x1D4 
	 R1D8_RES5      =     M2_EMDMA_OFFSET + 0x1D8 

   
;;// Channel 6 Registers
	 
	 R1F0_SAR6      =     M2_EMDMA_OFFSET + 0x1F0 
   R1F4_DAR6      =     M2_EMDMA_OFFSET + 0x1F4 
   R1F8_SGR6      =     M2_EMDMA_OFFSET + 0x1F8 
   R1FC_DSR6      =     M2_EMDMA_OFFSET + 0x1FC
	 R200_CTL6      =     M2_EMDMA_OFFSET + 0x200 
	 R204_EN6       =     M2_EMDMA_OFFSET + 0x204 
	 R208_CLR6      =     M2_EMDMA_OFFSET + 0x208 
	 R20C_LLST6     =     M2_EMDMA_OFFSET + 0x20C 
	 R210_PDCTL6    =     M2_EMDMA_OFFSET + 0x210 
	 R214_SHAPE6    =     M2_EMDMA_OFFSET + 0x214 
	 R218_RES6      =     M2_EMDMA_OFFSET + 0x218 
		


   
	 
;;// Channel 7 Registers

	 R230_SAR7      =     M2_EMDMA_OFFSET + 0x230 
   R234_DAR7      =     M2_EMDMA_OFFSET + 0x234 
   R238_SGR7      =     M2_EMDMA_OFFSET + 0x238 
   R23C_DSR7      =     M2_EMDMA_OFFSET + 0x23C
	 R240_CTL7      =     M2_EMDMA_OFFSET + 0x240 
	 R244_EN7       =     M2_EMDMA_OFFSET + 0x244 
	 R248_CLR7      =     M2_EMDMA_OFFSET + 0x248 
	 R24C_LLST7     =     M2_EMDMA_OFFSET + 0x24C 
	 R250_PDCTL7    =     M2_EMDMA_OFFSET + 0x250 
	 R254_SHAPE7    =     M2_EMDMA_OFFSET + 0x254 
	 R258_RES7      =     M2_EMDMA_OFFSET + 0x258 
		

   
	 

	 ;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Memory allocation for mpeg2 decoder data structure on pacdsp (single core) Mpeg2 Decoder Rev.  0.2_SCT_7056 (20100527)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;memory BANK >> 4KB
;; DSP MEMORY BANK0
Sequence_header_ADDR	= DSP0_BASE_ADDR + DMEM + 0x0000 ; 192 bytes (0x0000 ~ 0x00bf)
Sequence_ext_ADDR		= DSP0_BASE_ADDR + DMEM + 0x00c0 ; 16 bytes (0x00c0 ~ 0x00cf)
GOP_header_ADDR		= DSP0_BASE_ADDR + DMEM + 0x00d0 ; 16 bytes (0x00d0 ~ 0x00df) 
Picture_data_ADDR		= DSP0_BASE_ADDR + DMEM + 0x00e0 ; 48 bytes (0x00e0 ~ 0x010f)
BitStream_ADDR			= DSP0_BASE_ADDR + DMEM + 0x0110 ; 48 bytes (0x0110 ~ 0x13f)
Slice_data0_ADDR		= DSP0_BASE_ADDR + DMEM + 0x0140 ; 1776 bytes (0x0140 ~ 0x082f)


;; DSP MEMORY BANK1
; global variables (0x1f00 ~ 0x1fff) 256 bytes
GLOBAL_POINTER_ADDR 	= DSP0_BASE_ADDR + DMEM + 0x1f00 ; 256 bytes (0x1f00 ~ 0x1fff)
; Stack address									
STACKER_POINTER_ADDR 	= DSP0_BASE_ADDR + DMEM + 0x1ffc ; 256 bytes (0x1f00 ~ 0x1fff)

;; DSP MEMORY BANK2
Frame_memory_ADDR		= DSP0_BASE_ADDR + DMEM + 0x2000 ; 768 bytes  (0x2000 ~ 0x2300)

;; DSP MEMORY BANK3

Init_table_ADDR		= DSP0_BASE_ADDR + DMEM + 0x3400   ; 1024 bytes  (0x3400 ~ 0x37ff)
Entropy_table_ADDR 		= DSP0_BASE_ADDR + DMEM + 0x3800 ; 1312 bytes(0x3800 ~ 0x3d1f)

;; DSP MEMORY BANK4
StreamBuffer0			= DSP0_BASE_ADDR + DMEM + 0x4000 ; 2048 bytes (0x4000 ~ 0x47ff)

;; DSP MEMORY BANK5
StreamBuffer1			= DSP0_BASE_ADDR + DMEM + 0x5000 ; 2048 bytes (0x5000 ~ 0x57ff)

;; DSP MEMORY BANK6
Slice_data1_ADDR		= DSP0_BASE_ADDR + DMEM + 0x6000 ; 1776 bytes (0x6000 ~ 0xc6ef)

;; DSP MEMORY BANK7
Frame_memory1_ADDR	= DSP0_BASE_ADDR + DMEM + 0x7000 ; 768 bytes (0x7000 ~ 0x7300)

; debug variable
DBG_ADDR				= DSP0_BASE_ADDR + DMEM + 0x7fff



;; M2 Memory
Reference_Data0 = M2_BASE_ADDR + 0x02300 ; 3616 bytes (0x25002300 ~ 0x25003120)
Reference_Data1 = M2_BASE_ADDR + 0x07300 ; 3616 bytes (0x25007300 ~ 0x25008120)

DMA_LLST_ADDR   = 0x1f070 ; (2048 bytes) 
DMA_LLST_OFFSET	= 0x801000; (EMDMAC_ADDR(0x25820000)-0x2501f000)
DMA_step_size   = 0x80

LLST_U_070    =     0x070 
LLST_U_074    =     0x074 
LLST_U_078    =     0x078 
LLST_U_07C    =     0x07C
LLST_U_080    =     0x080 
LLST_U_084    =     0x084 
LLST_U_088    =     0x088 
LLST_U_08C    =     0x08C 
LLST_U_090    =     0x090 
LLST_U_094    =     0x094 
LLST_U_098    =     0x098 

LLST_V_0B0    =     0x0B0 
LLST_V_0B4    =     0x0B4 
LLST_V_0B8    =     0x0B8 
LLST_V_0BC    =     0x0BC
LLST_V_0C0    =     0x0C0 
LLST_V_0C4    =     0x0C4 
LLST_V_0C8    =     0x0C8 
LLST_V_0CC    =     0x0CC 
LLST_V_0D0    =     0x0D0 
LLST_V_0D4    =     0x0D4 
LLST_V_0D8    =     0x0D8 

