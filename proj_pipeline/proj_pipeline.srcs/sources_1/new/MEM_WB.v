`timescale 1ns/1ps

`include "defines.vh"

module MEM_WB(
    input wire clk,
    input wire rst,
    
    input wire [31:0] MEM_rdo,
    input wire [31:0] MEM_ALU_C,
    input wire [31:0] MEM_ext,
    input wire MEM_RegWEn,
    input wire [31:0] MEM_inst,
    input wire [2:0] MEM_WBSel,
    input wire MEM_have_inst,
    input wire [31:0] MEM_pc,

    output reg [31:0] WB_pc,
    output reg WB_have_inst,
    output reg [2:0] WB_WBSel,
    output reg [31:0] WB_inst,
    output reg WB_RegWEn,
    output reg  [31:0] WB_ext,
    output reg [31:0] WB_rdo,
    output reg [31:0] WB_ALU_C,
    output reg [31:0] WB_pc4
);

    //inst
    always @ (posedge clk or posedge rst) begin
        if (rst)    WB_inst <= 32'b0;
        else        WB_inst <= MEM_inst;   
    end


    //pc
    always @ (posedge clk or posedge rst) begin
        if (rst)    WB_pc <= 32'b0;
        else        WB_pc <= MEM_pc;   
    end

    //pc4
    always @ (posedge clk or posedge rst) begin
        if (rst)    WB_pc4 <= 32'b0;
        else        WB_pc4 <= MEM_pc + 32'h4;   
    end



    //have_inst
    always @ (posedge clk or posedge rst) begin
        if (rst)    WB_have_inst <= 1'b0;
        else        WB_have_inst <= MEM_have_inst;   
    end

    //WBsel
    always @ (posedge clk or posedge rst) begin
        if (rst)            WB_WBSel <= 3'b0;//无效
        else                WB_WBSel <= MEM_WBSel;
    end

    //rdo
    always @ (posedge clk or posedge rst) begin
        if (rst)    WB_rdo <= 32'b0;//无效
        else        WB_rdo <= MEM_rdo;
    end

    //ALU_C
    always @ (posedge clk or posedge rst) begin
        if (rst)    WB_ALU_C <= 32'b0;
        else        WB_ALU_C <= MEM_ALU_C;
    end

    //WB_ext
    always @ (posedge clk or posedge rst) begin
        if (rst)    WB_ext <= 32'b0;
        else        WB_ext <= MEM_ext;
    end
    
    //RegWen
    always @ (posedge clk or posedge rst) begin
        if (rst)    WB_RegWEn <= 0;//无效
        else        WB_RegWEn <= MEM_RegWEn;
    end

    

endmodule