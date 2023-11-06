`timescale 1ns/1ps

`include "defines.vh"

module NPC(
    input wire br,
    input wire [2:0] op,
    input wire [31:0] PC,
    input wire [31:0] aluc,
    input wire [31:0] offset,
    input wire [31:0] ex_pc,
    output reg [31:0] pc4,
    output reg [31:0] npc

);
    
    always @(*)begin
        pc4 = PC + 4;  
    end

    always @(*) begin
        if (op == `NPC_PC4) begin
            npc = PC + 4;
            
        end else if(op == `NPC_JMP) begin    
            npc = aluc;

        end else begin               //条件跳转
            if (!br) begin           
                npc = PC + 4;
            end else begin
                npc = ex_pc + offset;
            end
        end
    end


endmodule
