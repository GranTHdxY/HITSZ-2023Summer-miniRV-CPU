module Button(
    input wire rst,
    input wire clk,
    input wire [11:0] addr,
    input wire [4:0]  button,
    output reg [31:0] rdata 
);

always@(posedge clk or posedge rst)begin
    if(rst)begin
        rdata <= 32'b0;
    end else begin
        rdata <= {27'b0,button};
    end
end

endmodule