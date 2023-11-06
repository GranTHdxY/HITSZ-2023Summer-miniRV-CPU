`timescale 1ns/1ps

`include "defines.vh"

module RF(
    input wire clk,
    input wire we,
    input wire [4:0] rR1,       //read address1
    input wire [4:0] rR2,       //read address2
    input wire [4:0] wR,        //wirte address

    input wire [2:0] WBsel,
    
    input wire [31:0] ext,
    input wire [31:0] ALU_C,
    input wire [31:0] rdom,
    input wire [31:0] pc4,

    output reg [31:0] rD1,
    output reg [31:0] W_D,
    output reg [31:0] rD2
    
);

    reg [31:0] rf [0:31];       //32�?32位寄存器
    reg [31:0] WD;

    always @(*) begin
        case (WBsel)
            `WB_ALU:     WD = ALU_C;
            `WB_DM:      WD = rdom;
            `WB_PC_4:    WD = pc4;
            `WB_SEXT:    WD = ext;
            default:    WD = 3'b000;
        endcase
        W_D = WD;
    end

    always @(*) begin
        rD1 = rf[rR1];
        rD2 = rf[rR2];
    end

    always @(posedge clk) begin
        if (we && wR != 5'b00000) begin
            rf[wR] <= WD;
        end
    end
    

endmodule