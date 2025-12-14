# Makefile

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

WAVES ?= 1

VERILOG_SOURCES += $(wildcard $(PWD)/*.sv)
# use VHDL_SOURCES for VHDL files

# COCOTB_TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
COCOTB_TOPLEVEL = spi_loop

# COCOTB_TEST_MODULES is the basename of the Python test file(s)
COCOTB_TEST_MODULES = tb

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

