`timescale 1ns/1ps

`include "defines.vh"

module ALU(
    input wire [1:0] Asel,
    input wire [1:0] Bsel,
    input wire [3:0] op,
    input wire [31:0] pc,
    input wire [31:0] ext,
    input wire [31:0] RF_rD1,
    input wire [31:0] RF_rD2,
    output reg [31:0] ALU_C,
    output reg f

);

    reg [31:0] ALU_A;
    reg [31:0] ALU_B;
    reg [31:0] temp_answer;
    wire [4:0]  stamp;

    assign stamp = {ALU_B[4:0]};

    always @(*) begin
        if(Asel == `ALU_PC_4)begin
            ALU_A = pc;
        end else if(Asel == `ALU_Data_1)begin
            ALU_A = RF_rD1;
        end    
    end

    always @(*) begin
        if(Bsel == `ALU_Data_Imm)begin
            ALU_B = ext;
        end else if(Bsel == `ALU_Data_2)begin
            ALU_B = RF_rD2;
        end    
    end

    always@(*)begin
        temp_answer = ($signed(ALU_A)) - ($signed(ALU_B));
    end


    always @(*) begin
        case (op)
            `ALU_ADD:ALU_C = ALU_A + ALU_B;
            `ALU_SUB:ALU_C = ALU_A - ALU_B;
            `ALU_AND:ALU_C = ALU_A & ALU_B;
            `ALU_OR :ALU_C = ALU_A | ALU_B;
            `ALU_XOR:ALU_C = ALU_A ^ ALU_B;
            `ALU_SLL:ALU_C = ALU_A << stamp;
            `ALU_SRL:ALU_C = ALU_A >> stamp;
            `ALU_SRA:ALU_C = ($signed(ALU_A)) >>> stamp;
            `ALU_SW :ALU_C = ALU_A + ALU_B;
            `ALU_BEQ:ALU_C = ALU_A + ALU_B;
            `ALU_BNE:ALU_C = ALU_A + ALU_B;
            `ALU_BLT:ALU_C = ALU_A + ALU_B;
            `ALU_BGE:ALU_C = ALU_A + ALU_B;
            default: ALU_C = 32'b0;
        endcase
    end

    always @(*) begin
        case (op)
            `ALU_ADD:f = 0;
            `ALU_SUB:f = 0;
            `ALU_AND:f = 0;
            `ALU_OR :f = 0;
            `ALU_XOR:f = 0;
            `ALU_SLL:f = 0;
            `ALU_SRL:f = 0;
            `ALU_SRA:f = 0;
            `ALU_SW :f = 0;
            `ALU_BEQ:
                if(!temp_answer) begin
                    f = 1;
                end else begin 
                    f = 0;
                end
            `ALU_BNE:
                if(temp_answer) begin
                    f = 1;
                end else begin 
                    f = 0;
                end
            `ALU_BLT:
                if(($signed(ALU_A)) < ($signed(ALU_B))) begin
                    f = 1;
                end else begin 
                    f = 0;
                end
            `ALU_BGE:
                if(($signed(ALU_A)) >= ($signed(ALU_B))) begin
                    f = 1;
                end else begin 
                    f = 0;
                end
            default: f = 0;
        endcase
    end

endmodule