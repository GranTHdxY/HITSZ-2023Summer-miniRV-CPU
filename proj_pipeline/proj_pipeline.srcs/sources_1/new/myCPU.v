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

    //Interface to PC
    wire [31:0] PC_pc;
    wire pc_have_inst;

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
    wire [6:0] ID_inst_opcode;
    wire [2:0] ID_inst_funct3;
    wire [6:0] ID_inst_funct7;
    wire [4:0] ID_inst_rR1;
    wire [4:0] ID_inst_rR2;
    wire [4:0] ID_inst_wR;
    wire [24:0] ID_inst_din;

    

    //Interface to IF_ID
    wire [31:0] ID_pc4;
    wire [31:0] ID_inst;
    wire [31:0] ID_pc;
    wire ID_have_inst;

    assign ID_inst_opcode = {ID_inst[6:0]};
    assign ID_inst_funct3 = {ID_inst[14:12]};
    assign ID_inst_funct7 = {ID_inst[31:25]};
    assign ID_inst_rR1 = {ID_inst[19:15]};
    assign ID_inst_rR2 = {ID_inst[24:20]};
    assign ID_inst_din = {ID_inst[31:7]};

    //Interface to ID_EX
    wire [2:0] EX_NPC_OP;
    wire [3:0] EX_ALU_OP;
    wire EX_RegWEn;
    wire EX_MemRW;
    wire [2:0] EX_WBSel;
    wire EX_have_inst;
    wire [4:0] EX_inst_wR;
    wire [1:0] EX_Asel;
    wire [1:0] EX_Bsel;
    wire [31:0] EX_pc;
    wire [31:0] EX_rD1;
    wire [31:0] EX_rD2;
    wire [31:0] EX_ext;
    wire [31:0] EX_inst;

    //Interface to EX_MEM
    wire MEM_MemRW;
    wire MEM_RegWEn;
    wire [2:0] MEM_WBSel;
    wire MEM_have_inst;
    wire [4:0] MEM_inst_wR;
    wire [31:0] MEM_pc;
    wire [31:0] MEM_inst;
    wire [31:0] MEM_ALU_C;
    wire [31:0] MEM_rD2;
    wire [31:0] MEM_ext;

    //Interface to MEM_WB
    wire WB_RegWEn;
    wire [2:0] WB_WBSel;
    wire WB_have_inst;
    wire [4:0] WB_inst_wR;
    wire [31:0] WB_pc;
    wire [31:0] WB_pc4;
    wire [31:0] WB_inst;
    wire [31:0] WB_rdo;
    wire [31:0] WB_ALU_C;
    wire [31:0] WB_ext;

    assign ID_inst_wR = {ID_inst[11:7]};
    assign EX_inst_wR = {EX_inst[11:7]};
    assign MEM_inst_wR = {MEM_inst[11:7]};
    assign WB_inst_wR = {WB_inst[11:7]};

    //Interface to if_stop
    wire  if_stop_pc_stall;
    wire  if_stop_IF_ID_stall;
    wire  if_stop_ID_EX_stall;

    if_stop if_stop_0(
        .rst(cpu_rst),
        .if_stop_inst(ID_inst),
        .EX_we(EX_RegWEn),   
        .EX_wr(EX_inst_wR),
        .MEM_we(MEM_RegWEn),
        .MEM_wr(MEM_inst_wR),
        .WB_we(WB_RegWEn),
        .WB_wr(WB_inst_wR),
        .ex_npc_op(EX_NPC_OP),
        .ex_alu_f(ALU_f),

        .pc_stall(if_stop_pc_stall),
        .IF_ID_stall(if_stop_IF_ID_stall),
        .ID_EX_stall(if_stop_ID_EX_stall)
    );

    PC PC_0(
        .clk(cpu_clk),
        .rst(cpu_rst),
        .pc_pc_stall(if_stop_pc_stall),
        .IF_ID_stall(if_stop_IF_ID_stall),
        .pc_have_inst(pc_have_inst),
        .din(NPC_npc),
        .pc(PC_pc)
    );

    assign inst_addr = {PC_pc [15:2]};

    NPC NPC_0(
        .br(ALU_f),
        .PC(PC_pc),
        .op(EX_NPC_OP),
        .aluc(ALU_ALU_C),
        .ex_pc(EX_pc),
        .offset(EX_ext),
        .pc4(NPC_pc4),
        .npc(NPC_npc)
    );

    SEXT SEXT_0(
        .op(Controller_Imm_Sel),
        .din(ID_inst_din),
        .ext(SEXT_ext)
    );

    controller controller_0(
        .opcode(ID_inst_opcode),
        .funct3(ID_inst_funct3),
        .funct7(ID_inst_funct7),
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
        .we(WB_RegWEn),
        .rR1(ID_inst_rR1),
        .rR2(ID_inst_rR2),
        .wR(WB_inst_wR),
        .WBsel(WB_WBSel),
        .ext(WB_ext),
        .ALU_C(WB_ALU_C),
        .rdom(WB_rdo),
        .pc4(WB_pc4),

        .W_D(Rf_W_D),
        .rD1(Rf_rD1),
        .rD2(Rf_rD2)
    );

    ALU ALU_0(
        .Asel(EX_Asel),
        .Bsel(EX_Bsel),
        .op(EX_ALU_OP),
        .pc(EX_pc),
        .ext(EX_ext),
        .RF_rD1(EX_rD1),
        .RF_rD2(EX_rD2),
        .ALU_C(ALU_ALU_C),
        .f(ALU_f)
    );

    IF_ID IF_ID_0(
        .clk(cpu_clk),
        .rst(cpu_rst),

        .IF_pc(PC_pc),
        .IF_pc4(NPC_pc4),
        .IF_inst(inst),
        .IF_have_inst(pc_have_inst),

        .IF_ID_stall(if_stop_IF_ID_stall),
        .pc_stall(if_stop_pc_stall),

        .ID_have_inst(ID_have_inst),
        .ID_pc4(ID_pc4),
        .ID_pc(ID_pc),
        .ID_inst(ID_inst)
    );

    ID_EX ID_EX_0(
        .clk(cpu_clk),
        .rst(cpu_rst),
        .ID_NPC_OP(Controller_NPC_OP),
        .ID_ALU_OP(Controller_ALU_OP),
        .ID_MemRW(Controller_MemRW),
        .ID_Asel(Controller_Asel),
        .ID_Bsel(Controller_Bsel),
        .ID_pc(ID_pc),
        .ID_rD1(Rf_rD1),
        .ID_rD2(Rf_rD2),
        .ID_ext(SEXT_ext),
        .ID_inst(ID_inst),
        .ID_RegWen(Controller_RegWEn),
        .ID_WBSel(Controller_WBsel),
        .ID_EX_stall(if_stop_ID_EX_stall),
        .ID_have_inst(ID_have_inst),
        .pc_stall(if_stop_pc_stall),
        .IF_ID_stall(if_stop_IF_ID_stall),

        .EX_have_inst(EX_have_inst),
        .EX_WBSel(EX_WBSel),
        .EX_inst(EX_inst),
        .EX_RegWen(EX_RegWEn),
        .EX_NPC_OP(EX_NPC_OP),
        .EX_ALU_OP(EX_ALU_OP),
        .EX_MemRW(EX_MemRW),
        .EX_Asel(EX_Asel),
        .EX_Bsel(EX_Bsel),
        .EX_pc(EX_pc),
        .EX_rD1(EX_rD1),
        .EX_rD2(EX_rD2),
        .EX_ext(EX_ext)
    );

    EX_MEM EX_MEM_0(
        .clk(cpu_clk),
        .rst(cpu_rst),
        .EX_MemRW(EX_MemRW),
        .EX_ext(EX_ext),
        .EX_ALU_C(ALU_ALU_C),
        .EX_rD2(EX_rD2),
        .EX_RegWEn(EX_RegWEn),
        .EX_inst(EX_inst),
        .EX_WBSel(EX_WBSel),
        .EX_have_inst(EX_have_inst),
        .EX_pc(EX_pc),

        .MEM_pc(MEM_pc),
        .MEM_have_inst(MEM_have_inst),
        .MEM_WBSel(MEM_WBSel),
        .MEM_inst(MEM_inst),
        .MEM_RegWEn(MEM_RegWEn),
        .MEM_ext(MEM_ext),
        .MEM_MemRW(MEM_MemRW),
        .MEM_ALU_C(MEM_ALU_C),
        .MEM_rD2(MEM_rD2)
    );

    MEM_WB MEM_WB_0(
        .clk(cpu_clk),
        .rst(cpu_rst),
        .MEM_ext(MEM_ext),
        .MEM_rdo(Bus_rdata),
        .MEM_ALU_C(MEM_ALU_C),
        .MEM_RegWEn(MEM_RegWEn),
        .MEM_inst(MEM_inst),
        .MEM_WBSel(MEM_WBSel),
        .MEM_pc(MEM_pc),
        .MEM_have_inst(MEM_have_inst),

        .WB_have_inst(WB_have_inst),
        .WB_pc(WB_pc),
        .WB_WBSel(WB_WBSel),
        .WB_RegWEn(WB_RegWEn),
        .WB_rdo(WB_rdo),
        .WB_ALU_C(WB_ALU_C),
        .WB_ext(WB_ext),
        .WB_inst(WB_inst),
        .WB_pc4(WB_pc4)
    );

    assign Bus_addr = MEM_ALU_C;
    assign Bus_wen =  MEM_MemRW;
    assign Bus_wdata = MEM_rD2; 


// `ifdef RUN_TRACE
//     // Debug Interface
//     assign debug_wb_have_inst = 1;
//     assign debug_wb_pc        = PC_pc;
//     assign debug_wb_ena       = Controller_RegWEn;
//     assign debug_wb_reg       = ID_inst_wR;
//     assign debug_wb_value     = Rf_W_D;
// `endif

`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst = WB_have_inst;//;//0;
    assign debug_wb_pc        = WB_pc;
    assign debug_wb_ena       = WB_RegWEn;
    assign debug_wb_reg       = WB_inst_wR;
    assign debug_wb_value     = Rf_W_D;
`endif

endmodule
