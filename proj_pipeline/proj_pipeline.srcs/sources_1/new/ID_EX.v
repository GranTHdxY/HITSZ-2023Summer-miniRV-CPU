`timescale 1ns/1ps

`include "defines.vh"
module ID_EX(
    input wire clk,
    input wire rst,
    input wire ID_EX_stall,
    input wire pc_stall,
    input wire IF_ID_stall,
    input wire [2:0] ID_NPC_OP,
    input wire [3:0] ID_ALU_OP,
    input wire ID_MemRW,
    input wire [1:0] ID_Asel,
    input wire [1:0] ID_Bsel,
    input wire [31:0] ID_pc,
    input wire [31:0] ID_rD1,
    input wire [31:0] ID_rD2,
    input wire [31:0] ID_ext,
    input wire ID_RegWen,
    input wire [2:0] ID_WBSel,
    input wire [31:0] ID_inst,
    input wire ID_have_inst,

    output reg EX_have_inst,
    output reg [2:0] EX_WBSel,
    output reg [31:0] EX_inst,
    output reg EX_RegWen,
    output reg [2:0] EX_NPC_OP,
    output reg [3:0] EX_ALU_OP,
    output reg EX_MemRW,
    output reg [1:0] EX_Asel,
    output reg [1:0] EX_Bsel,
    output reg [31:0] EX_rD1,
    output reg [31:0] EX_rD2,
    output reg [31:0] EX_ext,
    output reg [31:0] EX_pc

);
    wire [6:0] jsign;
    assign jsign  = {ID_inst[6:0]};

    //inst
    always @ (posedge clk or posedge rst) begin
        if (rst)                                EX_inst <= 32'b0;//无效
        else if(pc_stall & ID_EX_stall)         EX_inst <= 32'b0;
        else if(IF_ID_stall & ID_EX_stall)      EX_inst <= ID_inst;
        else                                    EX_inst <= ID_inst;
    end

    //WBsel
    always @ (posedge clk or posedge rst) begin
        if (rst)                            EX_WBSel <= `WB_ALU;//无效
        else if(pc_stall & ID_EX_stall )    EX_WBSel <= `WB_ALU;
        else if(IF_ID_stall & ID_EX_stall)  EX_WBSel <= `WB_ALU;
        else                                EX_WBSel <= ID_WBSel;
    end


    //NPC_OP
    always @ (posedge clk or posedge rst) begin
        if (rst)                                EX_NPC_OP <= `NPC_PC4;//无效
        else if(pc_stall & ID_EX_stall)         EX_NPC_OP <= `NPC_PC4;
        else if(IF_ID_stall & ID_EX_stall)      EX_NPC_OP <= `NPC_PC4;
        else                                    EX_NPC_OP <= ID_NPC_OP;
    end

    //ALU_OP
    always @ (posedge clk or posedge rst) begin
        if (rst)                            EX_ALU_OP <= 4'b0;//无效
        else if(pc_stall & ID_EX_stall)     EX_ALU_OP <= 4'b0;
        else if(IF_ID_stall & ID_EX_stall)  EX_ALU_OP <= 4'b0;
        else                                EX_ALU_OP <= ID_ALU_OP;
    end

    //MemRW
    always @ (posedge clk or posedge rst) begin
        if (rst)                            EX_MemRW <= 0;//无效
        else if(pc_stall & ID_EX_stall)     EX_MemRW <= 0;
        else if(IF_ID_stall & ID_EX_stall)  EX_MemRW <= 0;
        else                                EX_MemRW <= ID_MemRW;
    end

    //Asel
    always @ (posedge clk or posedge rst) begin
        if (rst)                            EX_Asel <= `ALU_Data_1;//无效
        else if(pc_stall & ID_EX_stall)     EX_Asel <= `ALU_Data_1;
        else if(IF_ID_stall & ID_EX_stall)  EX_Asel <= `ALU_Data_1;
        else                                EX_Asel <= ID_Asel;
    end

    //Bsel
    always @ (posedge clk or posedge rst) begin
        if (rst)                            EX_Bsel <= `ALU_Data_2;//无效
        else if(pc_stall & ID_EX_stall)     EX_Bsel <= `ALU_Data_2;
        else if(IF_ID_stall & ID_EX_stall)  EX_Bsel <= `ALU_Data_2;
        else                                EX_Bsel <= ID_Bsel;
    end

    //pc
    always @ (posedge clk or posedge rst) begin
        if (rst)                            EX_pc <= 32'b0;
        else if(pc_stall & ID_EX_stall)     EX_pc <= ID_pc;
        else if(IF_ID_stall & ID_EX_stall)  EX_pc <= ID_pc;
        else                                EX_pc <= ID_pc;
    end


    //rD1
    always @ (posedge clk or posedge rst) begin
        if (rst)                            EX_rD1 <= 32'b0;
        else if(pc_stall & ID_EX_stall)     EX_rD1 <= EX_rD1;
        else if(IF_ID_stall & ID_EX_stall)  EX_rD1 <= EX_rD1;
        else                                EX_rD1 <= ID_rD1;
    end

    //rD2
    always @ (posedge clk or posedge rst) begin
        if (rst)                            EX_rD2 <= 32'b0;
        else if(pc_stall & ID_EX_stall)     EX_rD2 <= 32'b0;
        else if(IF_ID_stall & ID_EX_stall)  EX_rD2 <= 32'b0;
        else                                EX_rD2 <= ID_rD2;
    end

    //ext
    always @ (posedge clk or posedge rst) begin
        if (rst)                            EX_ext <= 32'b0;
        else if(pc_stall & ID_EX_stall)     EX_ext <= 32'b0;
        else if(IF_ID_stall & ID_EX_stall)  EX_ext <= 32'b0;
        else                                EX_ext <= ID_ext;
    end

    //RegWen
    always @ (posedge clk or posedge rst) begin
        if (rst)                            EX_RegWen <= 0;//无效
        else if(pc_stall & ID_EX_stall)     EX_RegWen <= 0;
        else if(IF_ID_stall & ID_EX_stall)  EX_RegWen <= 0;
        else                                EX_RegWen <= ID_RegWen;
    end
    
    //have_inst
    always @ (posedge clk or posedge rst) begin
        if (rst)                             EX_have_inst <= 1'b0;
        else if(pc_stall & ID_EX_stall)      EX_have_inst <= 1'b0;
        else if(IF_ID_stall & ID_EX_stall)   EX_have_inst <= 1'b0;
        else                                 EX_have_inst <= ID_have_inst;
    end

endmodule