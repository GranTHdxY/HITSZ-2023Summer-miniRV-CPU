# 语法格式为create_clock -name (clock name) -period (time) [get_ports (port name)]
create_clock -name fpga_clk -period 10 [get_ports fpga_clk]
