`timescale 1ns/1ps

`include "defines.vh"
module IF_ID(
    input wire clk,
    input wire rst,
    input wire IF_ID_stall,
    input wire pc_stall,
    input wire [31:0] IF_pc,
    input wire [31:0] IF_pc4,
    input wire [31:0] IF_inst,
    input wire IF_have_inst,

    output reg ID_have_inst,
    output reg [31:0] ID_pc,
    output reg [31:0] ID_pc4,
    output reg [31:0] ID_inst
    
);
    

    reg [1:0] if_pc_updata;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            if_pc_updata <= 2'b00;
        end else if(if_pc_updata == 2'b00)begin
            if_pc_updata <= 2'b01;
        end else if(if_pc_updata >= 2'b01)begin
            if_pc_updata <= 2'b10;
        end
        
    end


    always @ (posedge clk or posedge rst) begin
        if (rst)                        ID_pc4 <= 32'b0;
        else if (if_pc_updata >= 2'b01) begin
            if(pc_stall)                ID_pc4 <= ID_pc4;//todo
            else if(IF_ID_stall)        ID_pc4 <= 32'b0;
            else                        ID_pc4 <= IF_pc4;
        end else begin
            ID_pc4 <= IF_pc4; 
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst)                        ID_inst <= 32'b0;
        else if (if_pc_updata >= 2'b01) begin
            if(pc_stall)                ID_inst <= ID_inst;//todo
            else if(IF_ID_stall)        ID_inst <= 32'b0;
            else                        ID_inst <= IF_inst;
        end else begin
            ID_inst <= IF_inst;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst)                        ID_pc <= 32'b0;
        else if (if_pc_updata >= 2'b01) begin
            if(pc_stall)                ID_pc <= ID_pc;//todo
            else if(IF_ID_stall)        ID_pc <= 32'b0;
            else                        ID_pc <= IF_pc;
        end else begin
            ID_pc <= IF_pc; 
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst)                        ID_have_inst <= 1'b0;
        else if (if_pc_updata >= 2'b01) begin
            if(pc_stall)                ID_have_inst <= 1'b1;//todo
            else if(IF_ID_stall)        ID_have_inst <= 1'b0;
            else                        ID_have_inst <= 1'b1;
        end
        else begin
            ID_have_inst <= 1'b1; 
        end
    end

endmodule
//     always @ (posedge clk or posedge rst) begin
//         if (rst)                        ID_pc4 <= 32'b0;
//         else begin
//             if(pc_stall)                ID_pc4 <= ID_pc4;//todo
//             else if(IF_ID_stall)        ID_pc4 <= 32'b0;
//             else                        ID_pc4 <= IF_pc4;
//         end
//     end

//     always @ (posedge clk or posedge rst) begin
//         if (rst)                        ID_inst <= 32'b0;
//         else begin
//             if(pc_stall)                ID_inst <= ID_inst;//todo
//             else if(IF_ID_stall)        ID_inst <= 32'b0;
//             else                        ID_inst <= IF_inst;
//         end
//     end

//     always @ (posedge clk or posedge rst) begin
//         if (rst)                        ID_pc <= 32'b0;
//         else  begin
//             if(pc_stall)                ID_pc <= ID_pc;//todo
//             else if(IF_ID_stall)        ID_pc <= 32'b0;//problem
//             else                        ID_pc <= IF_pc;
//         end
//     end
    

//     always @ (posedge clk or posedge rst) begin
//         if (rst)                        ID_have_inst <= 1'b0;
//         else begin
//             if(pc_stall)                ID_have_inst <= 1'b1;//todo
//             else if(IF_ID_stall)        ID_have_inst <= 1'b0;
//             else                        ID_have_inst <= 1'b1;
//         end
//     end 

// endmodule