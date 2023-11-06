`timescale 1ns / 1ps

`include "defines.vh"

module myCPU (
    input  wire         cpu_rst,
    input  wire         cpu_clk,

    // Interface to IROM
    output wire [13:0]  inst_addr,
    input  wire [31:0]  inst,
    
    // Interface to Bridge
    output wire [31:0]  Bus_addr,
    input  wire [31:0]  Bus_rdata,
    output wire         Bus_wen,
    output wire [31:0]  Bus_wdata
    
`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst,
    output wire [31:0]  debug_wb_pc,
    output              debug_wb_ena,
    output wire [ 4:0]  debug_wb_reg,
    output wire [31:0]  debug_wb_value
`endif
);

    // TODO: 完成你自己的单周期CPU设计
    //Interface to PC
    wire [31:0] PC_pc;

    //Interface to NPC
    wire [31:0] NPC_npc;
    wire [31:0] NPC_pc4;
    //Interface to Controller
    wire [2:0] Controller_NPC_OP;
    wire [2:0] Controller_Imm_Sel;
    wire [3:0] Controller_ALU_OP;
    wire [2:0] Controller_WBsel;
    wire [1:0] Controller_Asel;
    wire [1:0] Controller_Bsel;
    wire Controller_MemRW;
    wire Controller_RegWEn;

    //Interface to SEXT
    wire [31:0] SEXT_ext;

    //Interface to RF
    wire [31:0] Rf_W_D;
    wire [31:0] Rf_rD1;
    wire [31:0] Rf_rD2;

    //Interface to ALU
    wire ALU_f;
    wire [31:0] ALU_ALU_C;
    
    //Interface to IROM
    wire [6:0] IROM_inst_opcode;
    wire [2:0] IROM_inst_funct3;
    wire [6:0] IROM_inst_funct7;
    wire [4:0] IROM_inst_rR1;
    wire [4:0] IROM_inst_rR2;
    wire [4:0] IROM_inst_wR;
    wire [24:0] IROM_inst_din;

    assign IROM_inst_opcode = {inst[6:0]};
    assign IROM_inst_funct3 = {inst[14:12]};
    assign IROM_inst_funct7 = {inst[31:25]};
    assign IROM_inst_rR1 = {inst[19:15]};
    assign IROM_inst_rR2 = {inst[24:20]};
    assign IROM_inst_wR = {inst[11:7]};
    assign IROM_inst_din = {inst[31:7]};


    PC PC_0(
        .clk(cpu_clk),
        .rst(cpu_rst),
        .din(NPC_npc),
        .pc(PC_pc)
    );

    assign inst_addr = {PC_pc [15:2]};

    NPC NPC_0(
        .br(ALU_f),
        .PC(PC_pc),
        .op(Controller_NPC_OP),
        .aluc(ALU_ALU_C),
        .offset(SEXT_ext),
        .pc4(NPC_pc4),
        .npc(NPC_npc)
    );

    SEXT SEXT_0(
        .op(Controller_Imm_Sel),
        .din(IROM_inst_din),
        .ext(SEXT_ext)
    );

    controller controller_0(
        .opcode(IROM_inst_opcode),
        .funct3(IROM_inst_funct3),
        .funct7(IROM_inst_funct7),
        .Imm_sel(Controller_Imm_Sel),
        .NPC_OP(Controller_NPC_OP),
        .ALU_OP(Controller_ALU_OP),
        .WBSel(Controller_WBsel),
        .Asel(Controller_Asel),
        .Bsel(Controller_Bsel),
        .MemRW(Controller_MemRW),
        .RegWEn(Controller_RegWEn)
    );

    RF RF_0(
        .clk(cpu_clk),
        .we(Controller_RegWEn),
        .rR1(IROM_inst_rR1),
        .rR2(IROM_inst_rR2),
        .wR(IROM_inst_wR),
        .WBsel(Controller_WBsel),
        .ext(SEXT_ext),
        .ALU_C(ALU_ALU_C),
        .rdom(Bus_rdata),
        .pc4(NPC_pc4),
        .W_D(Rf_W_D),
        .rD1(Rf_rD1),
        .rD2(Rf_rD2)
    );

    ALU ALU_0(
        .Asel(Controller_Asel),
        .Bsel(Controller_Bsel),
        .op(Controller_ALU_OP),
        .pc(PC_pc),
        .ext(SEXT_ext),
        .RF_rD1(Rf_rD1),
        .RF_rD2(Rf_rD2),
        .ALU_C(ALU_ALU_C),
        .f(ALU_f)
    );

    assign Bus_addr = ALU_ALU_C;
    assign Bus_wen =  Controller_MemRW;
    assign Bus_wdata = Rf_rD2; 


`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst = 1;
    assign debug_wb_pc        = PC_pc;
    assign debug_wb_ena       = Controller_RegWEn;
    assign debug_wb_reg       = IROM_inst_wR;
    assign debug_wb_value     = Rf_W_D;
`endif

endmodule
