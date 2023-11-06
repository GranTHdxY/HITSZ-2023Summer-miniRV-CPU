module LED(
    input wire rst,
    input wire clk,
    input wire wen,
    input wire[11:0] addr,
    input wire[31:0] wdata,
    output reg[23:0] led
);

always@(posedge clk or posedge rst)begin
    if(rst)begin
        led <= 24'b0;
    end else if(wen)begin
        led <= {wdata[23:0]};
    end
end

endmodule