`timescale 1ns/1ps

`include "defines.vh"

module SEXT(
    input wire [2:0] op,
    input wire [24:0] din,
    output reg [31:0] ext
);

    wire sgn = din[24];//符号位

    always @(*) begin
        case (op)
            `SEXT_I:  ext = {sgn ? 20'hFFFFF : 20'b0, din[24:13]};
            `SEXT_S:  ext = {sgn ? 20'hFFFFF : 20'b0, din[24:18], din[4:0]};
            `SEXT_B:  ext = {sgn ? 19'h7FFFF : 19'b0, din[24], din[0], din[23:18], din[4:1], 1'b0};
            `SEXT_U:  ext = {din[24:5], 12'b0};
            `SEXT_J:  ext = {sgn ? 11'h7FF : 11'b0, din[24], din[12:5], din[13], din[23:14], 1'b0};
            default: ext = 32'b0;
        endcase
    end
    

endmodule