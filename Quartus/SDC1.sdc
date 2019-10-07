create_clock -name {clk} -period 20.000 [get_ports {CLOCK_50}]
create_clock -name {pix_clk} -period 40.000 [get_ports {GPIO_1[0]]}]

derive_pll_clocks