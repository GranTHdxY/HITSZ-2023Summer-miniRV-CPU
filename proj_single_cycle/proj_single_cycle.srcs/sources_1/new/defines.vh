// Annotate this macro before synthesis
//`define RUN_TRACE

// TODO: 在此处定义你的宏
// 
//NPC_OP
`define NPC_PC4 3'b000
`define NPC_JMP 3'b001
`define NPC_BEQ 3'b010
`define NPC_BNE 3'b010
`define NPC_BLT 3'b100
`define NPC_BGE 3'b101

//SEXT Imm_sel
`define SEXT_I 3'b001
`define SEXT_S 3'b010
`define SEXT_B 3'b011
`define SEXT_U 3'b100
`define SEXT_J 3'b101

//ALU_OP
//define nothing 0
`define ALU_ADD 4'b0001
`define ALU_SUB 4'b0010
`define ALU_AND 4'b0011
`define ALU_OR  4'b0100
`define ALU_XOR 4'b0101
`define ALU_SLL 4'b0110
`define ALU_SRL 4'b0111
`define ALU_SRA 4'b1000
`define ALU_SW  4'b1001
`define ALU_BEQ 4'b1010
`define ALU_BNE 4'b1011
`define ALU_BLT 4'b1100
`define ALU_BGE 4'b1101


//controller_opcode
`define opcode_R 7'b0110011
`define opcode_I 7'b0010011
`define opcode_I_lw 7'b0000011
`define opcode_I_jalr 7'b1100111
`define opcode_S 7'b0100011
`define opcode_B 7'b1100011
`define opcode_U 7'b0110111
`define opcode_J 7'b1101111

//controller_funct7
`define  funct7_first_type 7'b0000000
`define  funct7_second_type 7'b0100000

//WB_sel
`define  WB_ALU 3'b001
`define  WB_DM  3'b010
`define  WB_PC_4 3'b011
`define  WB_SEXT 3'b100

//Asel
`define ALU_Data_1 2'b00
`define ALU_PC_4   2'b01

//Bsel
`define ALU_Data_2 2'b00
`define ALU_Data_Imm 2'b01


//Asel Bsel nofunc
`define nofunc 2'b10

// 外设I/O接口电路的端口地�?
`define PERI_ADDR_DIG   32'hFFFF_F000
`define PERI_ADDR_LED   32'hFFFF_F060
`define PERI_ADDR_SW    32'hFFFF_F070
`define PERI_ADDR_BTN   32'hFFFF_F078


