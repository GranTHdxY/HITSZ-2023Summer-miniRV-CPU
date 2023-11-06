module Switch(
    input wire rst,
    input wire clk,
    input wire[11:0] addr,
    input wire[23:0] switch,
    output reg[31:0] rdata 
);

always@(posedge clk or posedge rst)begin
    if(rst)begin
        rdata <= 32'b0;
    end else begin
        rdata <= {8'b0,switch};
    end
end

endmodule