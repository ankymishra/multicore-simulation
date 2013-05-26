#ifndef PAC_DSPCORE_DEF_H_INCLUDED
#define PAC_DSPCORE_DEF_H_INCLUDED

// opcode table
#define Ari_Base	0	// 32
#define Cmp_Base	35	// 28
#define Bit_Base	70	// 25
#define Data_Base	100	// 25
#define Load_Base	130	// 24
#define Spc_Base	160	// 21
#define Mul_Base	185	// 35
#define Ari1_Base	230	// 0
#define Prg_Base	240	// 6

// No Operation
#define NOP             254

// Arithmetic
#define ABS		Ari_Base+1
#define ABSD		Ari_Base+2
#define ABSQ		Ari_Base+3
#define ADD		Ari_Base+4
#define ADDD		Ari_Base+5
#define ADDDS		Ari_Base+6
#define ADDQ		Ari_Base+7
#define ADDQS		Ari_Base+8
#define ADDI		Ari_Base+9
#define ADDID		Ari_Base+10
#define ADDIDS	        Ari_Base+11
#define ADDU		Ari_Base+12	// v2.0?
#define ADDUD		Ari_Base+13
#define ADDUDS	        Ari_Base+14
#define ADDUQ		Ari_Base+15
#define ADDUQS	        Ari_Base+16
#define MERGEA		Ari_Base+17	// v3.0
#define NEG		Ari_Base+18
#define SUB		Ari_Base+19
#define SUBD		Ari_Base+20
#define SUBDS		Ari_Base+21
#define SUBQ		Ari_Base+22
#define SUBQS		Ari_Base+23
#define SUBU		Ari_Base+24	// v2.0?
#define SUBUD		Ari_Base+25
#define SUBUDS	        Ari_Base+26
#define SUBUQ		Ari_Base+27
#define SUBUQS	        Ari_Base+28
#define ADDIUD          Ari_Base+29	// v3.0
#define ADDIUDS         Ari_Base+30	// v3.0
#define MERGES          Ari_Base+31	// v3.0
#define ADDC            Ari_Base+32	// v3.0
#define ADDCU           Ari_Base+33	// v3.0
#define ADDS            Ari_Base+34
#define SUBS            Ari_Base+35

// Comparison
#define DMAX		Cmp_Base+1
#define DMIN  	        Cmp_Base+2
#define MAX   	        Cmp_Base+3
#define MAXD 		Cmp_Base+4
#define MAXQ 		Cmp_Base+5
#define MAXU  	        Cmp_Base+6
#define MAXUD		Cmp_Base+7
#define MAXUQ		Cmp_Base+8
#define MIN   	        Cmp_Base+9
#define MIND 		Cmp_Base+10
#define MINQ 		Cmp_Base+11
#define MINU  	        Cmp_Base+12
#define MINUD		Cmp_Base+13
#define MINUQ		Cmp_Base+14
#define SEQ   	        Cmp_Base+15
//#define SGT       Cmp_Base+16 // v3.0 Psuedo
#define SGTI  	        Cmp_Base+16
//#define SGTU      Cmp_Base+18 // v3.0 Psuedo
#define SLT   	        Cmp_Base+17
#define SLTI  	        Cmp_Base+18
#define SLTU  	        Cmp_Base+19
#define SLTL            Cmp_Base+20	// v3.0
#define SLTH            Cmp_Base+21	// v3.0
#define SLTUL           Cmp_Base+22	// v3.0
#define SLTUH           Cmp_Base+23	// v3.0
//#define SGTLL     Cmp_Base+26 // v3.0 Psuedo
//#define SGTHH     Cmp_Base+27 // v3.0 Psuedo
//#define SGTULL    Cmp_Base+28 // v3.0 Psuedo
//#define SGTUHH    Cmp_Base+29 // v3.0 Psuedo
#define SEQL            Cmp_Base+24	// v3.0
#define SEQH            Cmp_Base+25	// v3.0
#define SEQI            Cmp_Base+26	// v3.0
#define DMINU           Cmp_Base+27	// v3.0
#define DMAXU           Cmp_Base+28	// v3.0
#define SEQIU           Cmp_Base+29
#define SLTIU           Cmp_Base+30
#define SGTIU           Cmp_Base+31

// Bit Manipulation
#define AND		Bit_Base+1
#define ANDP		Bit_Base+2
#define EXTRACT	        Bit_Base+3
#define EXTRACTU        Bit_Base+4
#define INSERT	        Bit_Base+5
#define NOT		Bit_Base+6
#define NOTP		Bit_Base+7
#define OR		Bit_Base+8
#define ORP		Bit_Base+9
#define ROL		Bit_Base+10
#define ROR		Bit_Base+11
#define SLL		Bit_Base+12
#define SLLD		Bit_Base+13
#define SLLI		Bit_Base+14
#define SLLID	        Bit_Base+15
#define SRA		Bit_Base+16
#define SRAD		Bit_Base+17
#define SRAI		Bit_Base+18
#define SRAID	        Bit_Base+19
#define SRL		Bit_Base+20
#define SRLD		Bit_Base+21
#define SRLI		Bit_Base+22
#define SRLID	        Bit_Base+23
#define XOR		Bit_Base+24
#define XORP		Bit_Base+25
#define ANDI		Bit_Base+26
#define ORI		Bit_Base+27
#define XORI		Bit_Base+28

#define COPY_CFI	Bit_Base+29	//v3.6 2009.8.28

// Data Transfer
#define COPY		Data_Base+1
#define LIMBCP	        Data_Base+2
#define LIMBUCP	        Data_Base+3
#define LIMHWCP	        Data_Base+4
#define LIMHWUCP        Data_Base+5
#define MOVIH	        Data_Base+6
#define MOVIL	        Data_Base+7
#define PACK2		Data_Base+8
#define PACK4		Data_Base+9
#define SWAP2		Data_Base+10
#define SWAP4		Data_Base+11
#define SWAP4E	        Data_Base+12
#define READ_FLAG       Data_Base+13	// v3.0
#define WRITE_FLAG      Data_Base+14	// v3.0
#define UNPACK4	        Data_Base+15
#define UNPACK4U        Data_Base+16
#define MOVIUH          Data_Base+17
#define LIMWCP          Data_Base+18
#define LIMWUCP         Data_Base+19
#define MOVI            Data_Base+20	// v3.0
#define MOVIU           Data_Base+21	// v3.0
#define COPY_FC         Data_Base+22	// v3.0
#define COPY_FV         Data_Base+23	// v3.0
#define SET_CPI         Data_Base+24	// v3.0
#define READ_CPI        Data_Base+25	// v3.0
#define PERMH2          Data_Base+26	// v3.0
#define PERMH4          Data_Base+27	// v3.0
#define COPYU           Data_Base+28	// v3.0
#define UNPACK2         Data_Base+29
#define UNPACK2U        Data_Base+30

// Load & Store
#define DLH		Load_Base+1
#define DLHU	        Load_Base+2
#define DLW		Load_Base+3
#define DSB		Load_Base+4
//#define DSH       Load_Base+5   // v2.0
#define DSW		Load_Base+5
#define LB		Load_Base+6
//#define LBD       Load_Base+8   // v2.0
//#define LBHD          Load_Base+9   // v2.0
#define LBU		Load_Base+7
//#define LBUD          Load_Base+11  // v2.0
#define LH		Load_Base+8
//#define LHD       Load_Base+13  // v2.0
#define LHU		Load_Base+9
#define LNW		Load_Base+10
#define LW		Load_Base+11
#define SB		Load_Base+12
//#define SBD       Load_Base+18  // v2.0
//#define SH        Load_Base+19  // v2.0
//#define SHD       Load_Base+20  // v2.0
#define SW		Load_Base+13
#define LWU             Load_Base+14	// v3.0
#define DLWU            Load_Base+15	// v3.0
#define LNWU            Load_Base+16	// v3.0
#define DLNW            Load_Base+17	// v3.0
#define DLNWU           Load_Base+18	// v3.0
#define SNW             Load_Base+19	// v3.0
#define DSNW            Load_Base+20	// v3.0
#define SH		Load_Base+21	// v3.0
//#define SHL       Load_Base+22 // v3.0
#define DSH		Load_Base+23	// v3.0
//#define DSHL      Load_Base+24 // v3.0

#define CLIP		Load_Base+25	//v3.6 2010.7.7
#define CLIPD		Load_Base+26	//v3.6 2010.7.7
#define CLIPU		Load_Base+27	//v3.6 2010.7.7
#define CLIPUD		Load_Base+28	//v3.6 2010.7.7

// Special
#define BDR		Spc_Base+1
#define BDT		Spc_Base+2
//#define CLR       Spc_Base+3
#define DBDR	        Spc_Base+4
#define DBDT	        Spc_Base+5
#define DDEX	        Spc_Base+6
#define DEX		Spc_Base+7
#define LMBD	        Spc_Base+8
#define TRAP            Spc_Base+9
#define SFRA            Spc_Base+10
#define SFRAD           Spc_Base+11
#define SAAQ            Spc_Base+12
#define BF              Spc_Base+13
#define BFD             Spc_Base+14
#define CLS             Spc_Base+15
#define RND             Spc_Base+16
#define ROE             Spc_Base+17
//#define VERSION   Spc_Base+18 // v2.0
//#define SET_MODE  Spc_Base+19 // v3.0 Psuedo
#define DCLR            Spc_Base+19	// v3.0
#define DEXU            Spc_Base+20	// v3.0
#define BDTU            Spc_Base+21	// v3.0

#define ADSR		Spc_Base+22	// v3.6 2008.8.18
#define ADSRD		Spc_Base+23	// v3.6 2008.8.18
#define ADSRU		Spc_Base+24	// v3.6 2008.8.18
#define ADSRUD		Spc_Base+25	// v3.6 2008.8.18


// Multiplaction & MAC
#define FMUL	        Mul_Base+1
#define FMULuu	        Mul_Base+2
#define FMULus	        Mul_Base+3
#define FMULsu	        Mul_Base+4
#define FMULD	        Mul_Base+5
#define FMULuuD	        Mul_Base+6
#define FMULusD	        Mul_Base+7
#define FMULsuD	        Mul_Base+8
//#define MUL           Mul_Base+9   // v2.0
#define MULD	        Mul_Base+9
//#define XMUL          Mul_Base+11  // v2.0
#define XMULD	        Mul_Base+10
#define FMAC	        Mul_Base+11
#define FMACuu	        Mul_Base+12
#define FMACus	        Mul_Base+13
#define FMACsu	        Mul_Base+14
#define FMACD	        Mul_Base+15
#define FMACuuD	        Mul_Base+16
#define FMACusD	        Mul_Base+17
#define FMACsuD	        Mul_Base+18
//#define MAC           Mul_Base+21  // v2.0
#define MACD	        Mul_Base+19
//#define XMAC          Mul_Base+23  // v2.0
#define XMACD	        Mul_Base+20
#define XMACDS          Mul_Base+21
#define DOTP2	        Mul_Base+22
#define MULDS           Mul_Base+23	// v3.0
#define XFMUL           Mul_Base+24	// v3.0
#define XFMULuu         Mul_Base+25	// v3.0
#define XFMULus         Mul_Base+26	// v3.0
#define XFMULsu         Mul_Base+27	// v3.0
#define MACDS           Mul_Base+28	// v3.0
#define MSUD            Mul_Base+29	// v3.0
#define MSUDS           Mul_Base+30	// v3.0
#define XFMAC           Mul_Base+31	// v3.0
#define XFMACD          Mul_Base+32	// v3.0
#define XMSUD           Mul_Base+33	// v3.0
#define XMSUDS          Mul_Base+34	// v3.0
#define XDOTP2          Mul_Base+35	// v3.0
#define XFMULD          Mul_Base+36	// v3.0

#define ADSRF		Mul_Base+40	// v3.6 2009.12.1
#define ADSRFU		Mul_Base+41	// v3.6 2009.12.1
#define ADSRFD		Mul_Base+42	// v3.6 2009.12.1
#define ADSRFUD		Mul_Base+43	// v3.6 2009.12.1

// Ari
#define SUBUS           Ari1_Base+1
#define ADDCUS          Ari1_Base+2
#define ADDUS           Ari1_Base+3
#define ADDCS           Ari1_Base+4
#define BFS             Ari1_Base+5
#define MERGESS         Ari1_Base+6
#define MERGEAS         Ari1_Base+7
#define BFDS            Ari1_Base+8
#define ADDIS           Ari1_Base+9

// Program Control
#define LBCB	        Prg_Base+1
//#define SET_LBCI  Prg_Base+2 // v3.0 Psuedo
//#define SET_LBC   Prg_Base+3 // v3.0 Psuedo
//#define SET_WTMR  Prg_Base+4 // v3.0 Psuedo
#define TEST	        Prg_Base+2
#define PAC_WAIT	Prg_Base+3
#define B	        Prg_Base+4
#define BR              Prg_Base+5
#define BRR             Prg_Base+6
//#define J         Prg_Base+7 // v3.0 Psuedo
//#define JR        Prg_Base+8 // v3.0 Psuedo
//#define JRR       Prg_Base+9 // v3.0 Psuedo
//#define SET_WTMRI Prg_Base+13 // v3.0 Psuedo

typedef union _cap_type {
	unsigned short RAW;

	struct {
		unsigned short ct:1;
		unsigned short ps:1;
		unsigned short ls1:1;
		unsigned short a1:1;
		unsigned short ls2:1;
		unsigned short a2:1;
		unsigned short bls:1;
		unsigned short ba:1;
		unsigned short reserved8:2;
		unsigned short pl:6;
	} Normal;

	struct {
		unsigned short ct:1;
		unsigned short op:3;
		unsigned short func:4;
		unsigned short reserved8:4;
		unsigned short imm:4;
	} VC;
} cap_type;

typedef union _inst_type {
	unsigned long long RAW;

	struct {
		unsigned int type:3;
		unsigned int length:3;
		unsigned int uc:1;
		unsigned int opcode:2;
		unsigned int reserved9:1;
		unsigned int ceb:4;
		unsigned int func1:2;
		unsigned int reserved16:3;
		unsigned int rd:5;
		unsigned int imm0:8;
		unsigned char imm1;
		unsigned char imm2;
		unsigned char imm3;
	} A11;

	struct {
		unsigned int type:3;
		unsigned int length:3;
		unsigned int uc:1;
		unsigned int opcode:2;
		unsigned int rd:5;
		unsigned int func1:2;
		unsigned int imm0:8;
		unsigned int imm1:8;
		unsigned char imm2;
		unsigned char imm3;
	} A12;

	struct {
		unsigned int type:2;
		unsigned int uc:1;
		unsigned int opcode:3;
		unsigned int func1:3;
		unsigned int reserved9:1;
		unsigned int ceb:4;
		unsigned int rs2:5;
		unsigned int rs1:5;
		unsigned int rd:5;
		unsigned int reserved29:3;
	} B11;

	struct {
		unsigned int type:2;
		unsigned int uc:1;
		unsigned int opcode:3;
		unsigned int func1:3;
		unsigned int rd:5;
		unsigned int rs2:5;
		unsigned int rs1:5;
		unsigned int reserved24:8;
	} B12;

	struct {
		unsigned int type:3;
		unsigned int length:3;
		unsigned int opcode:2;
		unsigned int func1:2;
		unsigned int ceb:4;
		unsigned int rd:5;
		unsigned int rs1:5;
		unsigned int imm0:8;
		unsigned char imm1;
		unsigned char imm2;
		unsigned char imm3;
	} C11;

	struct {
		unsigned int type:4;
		unsigned int length:2;
		unsigned int opcode:2;
		unsigned int func1:2;
		unsigned int ceb:4;
		unsigned int rsd:4;
		unsigned int am:1;
		unsigned int rd:5;
		unsigned int imm0:8;
		unsigned char imm1;
		unsigned char imm2;
	} C21;

	struct {
		unsigned int type:3;
		unsigned int length:2;
		unsigned int opcode:3;
		unsigned int func1:2;
		unsigned int ceb:4;
		unsigned int rsd:5;
		unsigned int rs1:5;
		unsigned int imm0:8;
		unsigned char imm1;
		unsigned char imm2;
	} C31;

	struct {
		unsigned int type:4;
		unsigned int opcode:3;
		unsigned int length:3;
		unsigned int ceb:4;
		unsigned int rs2:5;
		unsigned int rs1:5;
		unsigned int rsd:5;
		unsigned int func1:3;
		unsigned char imm0;
		unsigned char imm1;
		unsigned char imm2;
	} C41;

	struct {
		unsigned int type:4;
		unsigned int length:3;
		unsigned int opcode:2;
		unsigned int u:1;
		unsigned int ceb:4;
		unsigned int rd:5;
		unsigned int rs1:5;
		unsigned int pd1:4;
		unsigned int pd2:4;
		unsigned char imm0;
		unsigned char imm1;
		unsigned char imm2;
		unsigned char imm3;
	} C51;

	struct {
		unsigned int type:5;
		unsigned int opcode:3;
		unsigned int func1:2;
		unsigned int ceb:4;
		unsigned int rs2:5;
		unsigned int rd:5;
		unsigned int reserved24:8;
	} D11;

	struct {
		unsigned int type:5;
		unsigned int op:1;
		unsigned int reserved8:4;
		unsigned int ceb:4;
		unsigned int rs2:5;
		unsigned int rs1:5;
		unsigned int reserved24:8;
	} D21;

	struct {
		unsigned int type:7;
		unsigned int reserved7:1;
		unsigned int pd1:4;
		unsigned int pd2:4;
		unsigned int imm0:8;
		unsigned int imm1:8;
		unsigned char imm2;
		unsigned char imm3;
	} D31;

	struct {
		unsigned int type:4;
		unsigned int op:1;
		unsigned int rd:5;
		unsigned int ceb:4;
		unsigned int rs2:5;
		unsigned int rs1:5;
		unsigned int imm0:8;
	} D41;

	struct {
		unsigned int type:5;
		unsigned int rsd:5;
		unsigned int ceb:4;
		unsigned int op:1;
		unsigned int u:1;
		unsigned int imm0:8;
		unsigned int imm1:8;
	} D51;

	struct {
		unsigned int type:7;
		unsigned int reserved7:3;
		unsigned int rsd:5;
		unsigned int reserved15:1;
		unsigned int imm0:8;
		unsigned int imm1:8;
		unsigned char imm2;
		unsigned char imm3;
	} D61;

	struct {
		unsigned int type:6;
		unsigned int opcode:2;
		unsigned int func1:2;
		unsigned int ceb:4;
		unsigned int rs2:5;
		unsigned int rs1:5;
		unsigned int rd:5;
		unsigned int reserved29:3;
		unsigned char pd1:4;
		unsigned char pd2:4;
	} D71;
} inst_type;

typedef struct _inst_t {
	unsigned char op;
	unsigned char Rs1_Addr;
	unsigned char Rs1_Type;
	unsigned char Rs2_Addr;
	unsigned char Rs2_Type;
	unsigned char Rd1_Addr;
	unsigned char Rd1_Type;
	unsigned char Rd2_Addr;
	unsigned char Rd2_Type;
	unsigned char P_Addr;
	unsigned int Imm32;
	unsigned char Imm32_Valid;
	unsigned char CEB;
	unsigned char shamt;
	unsigned short offset;	// B, J
	unsigned char width;
	unsigned short WM;	// TEST, WAIT
	unsigned short WV;	// TEST, WAIT
	unsigned int WB_Data;
	unsigned int WB_Data1;
	unsigned int Memory_Addr;
	unsigned char use_label;
	unsigned char SEZE;
	char *label;
} inst_t;

typedef void (*pac_funcs)(inst_t *curinst);

typedef struct _instr_t {
	inst_t inst;
	unsigned char execute;	// If NOP {execute = 0} else {execute = 1}
} instr_t;

typedef struct _inst_packet_t {
	unsigned int PC;
	unsigned int breakpoint;
	instr_t instr[5];
} inst_packet;

typedef struct _write_node_t {
	unsigned char type;
	unsigned char addr;
	unsigned long long data;
} write_node_t;

#define UPDATE_REGMAX	32
typedef struct _write_log {
	int update_regnum;
	write_node_t write_node[UPDATE_REGMAX];
} write_log;

typedef struct _inst_package_more {
	inst_packet package;
	int packet_len;
} Inst_Package_more;

#define P_CFU_INFO	0xFFFF1234
#define INST_NO		5
#define EXT_MEMORY_MASK 0x00FFFFFF

/* Global register file */
struct _RF_t {
	//A[0][8]		Address Register			: A0 - A7
	//AC[1][8]		Accumulator Register		: AC0 - AC7
	//C[2][8]		Constant Register			: C0 - C7
	//CP[3][2]		Constant Pointer			: CF2/CF3
	//D[4][16]		Data Register				: D0 - D15
	//P[5][16]		Predict Register			: P0 - P16
	//R[6][16]		General Purpose Register	: R0 - R16
	//CR[7][16]		Control Register			: SR0 - SR15
	//AMCR[8][1]	Addressing Mode Control Register : CF6
	//CPP[9][2]									: CF0/CF1
	unsigned long long RF[10][32];
	unsigned char PSR[5][7];	// control Register

	unsigned short sim_end;
};

typedef struct _RF_t RF_t;

#define Reg_A        0
#define Reg_AC       1
#define Reg_C        2
#define Reg_CP       3
#define Reg_D        4
#define Reg_P        5
#define Reg_R        6
#define Reg_CR       7
#define Reg_AMCR     8
#define Reg_CPP      9
#define Reg_PSR      10

#define Reg_Maxindex 9
#define Reg_Maxnum   15

#define PSR_OV       0
#define PSR_CA       1
#define PSR_SATS     2
#define PSR_SATD     3
#define PSR_SATQ     4
#define PSR_SATP     5
#define PSR_SATAcc   6
#define PSR_Maxnum   6

#define INVALID_REG  -1

#define PP_IF  0
#define PP_IDP 1
#define PP_ID  2
#define PP_RO  3
#define PP_E1  4
#define PP_E2  5
#define PP_E3  6
#define PP_WB  7

#define STATE_NORMAL 0xffffffff
#define STATE_BRANCH_SLOT1 5
#define STATE_BRANCH_SLOT2 4
#define STATE_BRANCH_SLOT3 3
#define STATE_BRANCH_SLOT4 2
#define STATE_BRANCH_SLOT5 1
#define STATE_BREAK_IN_SLOT 0x80000000
#define STATE_PIPELINE_EMPT 5

#endif
