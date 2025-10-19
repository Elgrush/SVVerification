module = uart_loop
all:
	verilator -Wno-lint --cc $(module).sv
	verilator -Wall -Wno-lint --trace -cc $(module).sv --exe tb.cpp
	make -C obj_dir -f V$(module).mk V$(module)
	obj_dir/V$(module)
	gtkwave waveform.vcd
	rm -rf obj_dir