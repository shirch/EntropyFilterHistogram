transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/QUARTUS/lab3mips/ex9/rtlMips/WriteBack.VHD}
vcom -93 -work work {C:/QUARTUS/lab3mips/ex9/rtlMips/MEM_WB.VHD}
vcom -93 -work work {C:/QUARTUS/lab3mips/ex9/rtlMips/IF_ID.VHD}
vcom -93 -work work {C:/QUARTUS/lab3mips/ex9/rtlMips/ID_EX.VHD}
vcom -93 -work work {C:/QUARTUS/lab3mips/ex9/rtlMips/EX_MEM.VHD}
vcom -93 -work work {C:/QUARTUS/lab3mips/ex9/rtlMips/Hazard_Unit.VHD}
vcom -93 -work work {C:/QUARTUS/lab3mips/ex9/rtlMips/MIPS.vhd}
vcom -93 -work work {C:/QUARTUS/lab3mips/ex9/rtlMips/IFETCH.VHD}
vcom -93 -work work {C:/QUARTUS/lab3mips/ex9/rtlMips/IDECODE.VHD}
vcom -93 -work work {C:/QUARTUS/lab3mips/ex9/rtlMips/EXECUTE.VHD}
vcom -93 -work work {C:/QUARTUS/lab3mips/ex9/rtlMips/DMEMORY.VHD}
vcom -93 -work work {C:/QUARTUS/lab3mips/ex9/rtlMips/CONTROL.VHD}

vcom -93 -work work {C:/QUARTUS/lab3mips/ex9/quartus/../tb/mips_tester_struct.vhd}
vcom -93 -work work {C:/QUARTUS/lab3mips/ex9/quartus/../tb/mips_tb_struct.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii -L rtl_work -L work -voptargs="+acc"  MIPS_tb

add wave *
view structure
view signals
run 20 us
