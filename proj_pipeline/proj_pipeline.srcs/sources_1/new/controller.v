`timescale  1ns/1ps

`include "defines.vh"

module controller(
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    output reg [2:0] Imm_sel,
    output reg [2:0] NPC_OP,
    output reg [3:0] ALU_OP,
    output reg [2:0] WBSel,
    output reg [1:0] Asel,
    output reg [1:0] Bsel,
    output reg MemRW,
    output reg RegWEn
);
    
    //NPC_OP controller
    always @(*) begin
        case (opcode)
            `opcode_R:       NPC_OP = `NPC_PC4;
            `opcode_I:       NPC_OP = `NPC_PC4;
            `opcode_I_lw:    NPC_OP = `NPC_PC4;
            `opcode_I_jalr:  NPC_OP = `NPC_JMP;
            `opcode_S:       NPC_OP = `NPC_PC4;
            `opcode_B:
                case (funct3)
                    3'b000: NPC_OP = `NPC_BEQ;
                    3'b001: NPC_OP = `NPC_BNE;
                    3'b100: NPC_OP = `NPC_BLT;
                    3'b101: NPC_OP = `NPC_BGE;
                    default:NPC_OP = `NPC_PC4;
                endcase
            `opcode_U:       NPC_OP = `NPC_PC4;
            `opcode_J:       NPC_OP = `NPC_JMP;
            default:         NPC_OP = `NPC_PC4;
        endcase
    end

    //RegWEn controller
    always @(*) begin
        case (opcode)
            `opcode_R:       RegWEn = 1;
            `opcode_I:       RegWEn = 1;
            `opcode_I_lw:    RegWEn = 1;
            `opcode_I_jalr:  RegWEn = 1;
            `opcode_S:       RegWEn = 0;
            `opcode_B:       RegWEn = 0;
            `opcode_U:       RegWEn = 1;
            `opcode_J:       RegWEn = 1;
            default:         RegWEn = 0; 
        endcase
    end


    //WBSel controller
    always @(*) begin
        case (opcode)
            `opcode_R:       WBSel = `WB_ALU;
            `opcode_I:       WBSel = `WB_ALU;
            `opcode_I_lw:    WBSel = `WB_DM;
            `opcode_I_jalr:  WBSel = `WB_PC_4;
            `opcode_S:       WBSel = 3'b000;
            `opcode_B:       WBSel = 3'b000;
            `opcode_U:       WBSel = `WB_SEXT;
            `opcode_J:       WBSel = `WB_PC_4;
            default:         WBSel = 3'b000;
        endcase
    end

    //Immsel controller
    always @(*) begin
        case (opcode)
            `opcode_R:       Imm_sel = 3'b000;
            `opcode_I:       Imm_sel = `SEXT_I;
            `opcode_I_lw:    Imm_sel = `SEXT_I;
            `opcode_I_jalr:  Imm_sel = `SEXT_I;
            `opcode_S:       Imm_sel = `SEXT_S;
            `opcode_B:       Imm_sel = `SEXT_B;
            `opcode_U:       Imm_sel = `SEXT_U;
            `opcode_J:       Imm_sel = `SEXT_J;
            default:         Imm_sel = 3'b000;
        endcase
    end

    //Asel controller
    always @(*) begin
        case (opcode)
            `opcode_R:       Asel = `ALU_Data_1;
            `opcode_I:       Asel = `ALU_Data_1;
            `opcode_I_lw:    Asel = `ALU_Data_1;
            `opcode_I_jalr:  Asel = `ALU_Data_1;
            `opcode_S:       Asel = `ALU_Data_1;
            `opcode_B:       Asel = `ALU_Data_1;
            `opcode_U:       Asel = `nofunc;
            `opcode_J:       Asel = `ALU_PC_4;
            default:         Asel = `ALU_Data_1;
        endcase
    end


    //Bsel controller
    always @(*) begin
        case (opcode)
            `opcode_R:       Bsel = `ALU_Data_2;
            `opcode_I:       Bsel = `ALU_Data_Imm;
            `opcode_I_lw:    Bsel = `ALU_Data_Imm;
            `opcode_I_jalr:  Bsel = `ALU_Data_Imm;
            `opcode_S:       Bsel = `ALU_Data_Imm;
            `opcode_B:       Bsel = `ALU_Data_2;
            `opcode_U:       Bsel = `nofunc;
            `opcode_J:       Bsel = `ALU_Data_Imm;
            default:         Bsel = `ALU_Data_2;
        endcase
    end

    //MemRW controller
    always @(*) begin
        case (opcode)
            `opcode_R:       MemRW = 0;
            `opcode_I:       MemRW = 0;
            `opcode_I_lw:    MemRW = 0;
            `opcode_I_jalr:  MemRW = 0;
            `opcode_S:       MemRW = 1;
            `opcode_B:       MemRW = 0;
            `opcode_U:       MemRW = 0;
            `opcode_J:       MemRW = 0;
            default:         MemRW = 0;
        endcase
    end

    //ALU_OP controller
    always @(*) begin
        case (opcode)
            `opcode_R:
                case (funct3)
                    3'b000://add and sub
                        case (funct7)
                            `funct7_first_type:     ALU_OP = `ALU_ADD;
                            `funct7_second_type:    ALU_OP = `ALU_SUB;
                            default:                ALU_OP = 4'b0000; 
                        endcase
                    3'b111:ALU_OP = `ALU_AND;//AND
                    3'b110:ALU_OP = `ALU_OR;//or
                    3'b100:ALU_OP = `ALU_XOR;//xor
                    3'b001:ALU_OP = `ALU_SLL;//sll
                    3'b101://srl and sra
                        case (funct7)
                            `funct7_first_type:     ALU_OP = `ALU_SRL;
                            `funct7_second_type:    ALU_OP = `ALU_SRA;
                            default:                ALU_OP = 4'b0000; 
                        endcase
                    default:ALU_OP = 4'b0000; 
                endcase 

            `opcode_I:
                case (funct3)
                    3'b000:ALU_OP = `ALU_ADD;//addi
                    3'b111:ALU_OP = `ALU_AND;//andi
                    3'b110:ALU_OP = `ALU_OR;//ori
                    3'b100:ALU_OP = `ALU_XOR;//xori
                    3'b001:ALU_OP = `ALU_SLL;//slli
                    3'b101://srli and srai
                        case (funct7)
                            `funct7_first_type:     ALU_OP = `ALU_SRL;
                            `funct7_second_type:    ALU_OP = `ALU_SRA;
                            default:                ALU_OP = 4'b0000; 
                        endcase
                    default:ALU_OP = 4'b0000; 
                endcase
            `opcode_I_jalr:ALU_OP = `ALU_ADD;
            `opcode_I_lw:  ALU_OP = `ALU_ADD;
            `opcode_S:     ALU_OP = `ALU_SW;
            `opcode_B:
                case(funct3)
                    3'b000:ALU_OP = `ALU_BEQ;
                    3'b001:ALU_OP = `ALU_BNE;
                    3'b100:ALU_OP = `ALU_BLT;
                    3'b101:ALU_OP = `ALU_BGE;
                endcase
            `opcode_U:     ALU_OP = 4'b0000;
            `opcode_J:     ALU_OP = `ALU_ADD;
            default:       ALU_OP = 4'b0000;
        endcase        
    end


endmodule