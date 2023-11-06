`timescale 1ns / 1ps

module miniRV_sim();

    reg fpga_rst;
    reg fpga_clk;
    reg [23:0] switch;
    reg [ 4:0] button;
    
    wire [ 7:0]  dig_en;
    wire         DN_A;
    wire         DN_B;
    wire         DN_C;
    wire         DN_D;
    wire         DN_E;
    wire         DN_F;
    wire         DN_G;
    wire         DN_DP;
    wire [23:0]  led;

    initial begin
        fpga_rst = 1;
        fpga_clk = 0;
        #23
        fpga_rst = 0;
        switch   = 24'h20_12_34;
        button   = 5'h0;
    end

    always #5 fpga_clk = !fpga_clk;

    miniRV_SoC DUT (
        .fpga_rst   (fpga_rst),
        .fpga_clk   (fpga_clk),
        .Switch     (switch),
        .button     (button),
        .dig_en     (dig_en),
        .DN_A       (DN_A),
        .DN_B       (DN_B),
        .DN_C       (DN_C),
        .DN_D       (DN_D),
        .DN_E       (DN_E),
        .DN_F       (DN_F),
        .DN_G       (DN_G),
        .DN_DP      (DN_DP),
        .led        (led)
    );

endmodule
