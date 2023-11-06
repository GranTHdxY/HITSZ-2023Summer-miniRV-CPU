`timescale 1ns/1ps

`include "defines.vh"

module PC(
    input wire rst,
    input wire clk,
    output reg [31:0] din,
    output reg [31:0] pc
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

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            pc <= 32'b0;
        end else if (if_pc_updata >= 2'b01) begin
            pc <= din;
        end

    end

endmodule