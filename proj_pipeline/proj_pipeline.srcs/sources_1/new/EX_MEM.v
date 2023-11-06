`timescale 1ns/1ps

`include "defines.vh"

module EX_MEM(
    input wire clk,
    input wire rst,
    input wire EX_MemRW,
    input wire [31:0] EX_ALU_C,
    input wire [31:0] EX_rD2,
    input wire [31:0] EX_ext,
    input wire EX_RegWEn,
    input wire [31:0] EX_inst,
    input wire [2:0] EX_WBSel,
    input wire EX_have_inst,
    input wire [31:0] EX_pc,

    output reg [31:0] MEM_pc,
    output reg MEM_have_inst,
    output reg [2:0] MEM_WBSel,
    output reg [31:0] MEM_inst,
    output reg MEM_RegWEn,
    output reg [31:0] MEM_ext,
    output reg MEM_MemRW,
    output reg [31:0] MEM_ALU_C,
    output reg [31:0] MEM_rD2
);
    //inst
    always @ (posedge clk or posedge rst) begin
        if (rst)    MEM_inst <= 32'b0;
        else        MEM_inst <= EX_inst;   
    end

    //pc
    always @ (posedge clk or posedge rst) begin
        if (rst)    MEM_pc <= 32'b0;
        else        MEM_pc <= EX_pc;   
    end

    //have_inst
    always @ (posedge clk or posedge rst) begin
        if (rst)    MEM_have_inst <= 1'b0;
        else        MEM_have_inst <= EX_have_inst;   
    end

    //WBsel
    always @ (posedge clk or posedge rst) begin
        if (rst)            MEM_WBSel <= 3'b0;//无效
        else                MEM_WBSel <= EX_WBSel;
    end

    //MewRW
    always @ (posedge clk or posedge rst) begin
        if (rst)    MEM_MemRW <= 0;//无效
        else        MEM_MemRW <= EX_MemRW;
    end

    //RegWen
    always @ (posedge clk or posedge rst) begin
        if (rst)    MEM_RegWEn <= 0;//无效
        else        MEM_RegWEn <= EX_RegWEn;
    end

    //ALU_C
    always @ (posedge clk or posedge rst) begin
        if (rst)    MEM_ALU_C <= 32'b0;
        else        MEM_ALU_C <= EX_ALU_C;
    end

    //MEM_rD2
    always @ (posedge clk or posedge rst) begin
        if (rst)    MEM_rD2 <= 32'b0;
        else        MEM_rD2 <= EX_rD2;
    end

    //MEM_ext
    always @ (posedge clk or posedge rst) begin
        if (rst)    MEM_ext <= 32'b0;
        else        MEM_ext <= EX_ext;
    end


endmodule