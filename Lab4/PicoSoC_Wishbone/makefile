RISV_TOOL_PREFIX := /home/elgrush/CodingSpace/tools/riscv/riscv/bin
MEMSIZE          := 4096
CSRC             := $(wildcard firmware/*.c)
SSRC             := $(wildcard firmware/*.S)
COBJ             := $(addsuffix .o,$(CSRC))
SOBJ             := $(addsuffix .o,$(SSRC))
OBJ              := $(COBJ) $(SOBJ)
CFLAGS           := -Os -nostdlib -ffreestanding --std=gnu99 -mabi=ilp32e -march=rv32e -c
LDFLAGS          := -Bstatic -T ./firmware/firmware.lds -Map ./firmware/firmware.map
LDFLAGS          += --strip-debug -m elf32lriscv

.PHONY: all
all: simulate

$(COBJ): %.c.o : %.c
	$(RISV_TOOL_PREFIX)/riscv32-unknown-elf-gcc $(CFLAGS) -o $@ $<

$(SOBJ): %.S.o : %.S
	$(RISV_TOOL_PREFIX)/riscv32-unknown-elf-gcc $(CFLAGS) -o $@ $<

firmware/firmware.elf: $(OBJ)
	$(RISV_TOOL_PREFIX)/riscv32-unknown-elf-ld $(LDFLAGS) -o $@ $^

firmware/firmware.bin: firmware/firmware.elf
	$(RISV_TOOL_PREFIX)/riscv32-unknown-elf-objcopy -O binary $< $@

firmware/firmware.hex: firmware/firmware.bin
	python3 ./firmware/makehex.py $< $(MEMSIZE) > $@

.PHONY: build
build: firmware/firmware.hex
	cp firmware/firmware.hex firmware.mem

.PHONY: simulate
simulate: build
	iverilog -o qqq *.v *.sv -g2012
	vvp qqq
  #gtkwave system.vcd

.PHONY: clean
clean:
	rm -rf firmware/*.o firmware/*.elf firmware/*.map firmware/*.hex firmware.mem qqq system.vcd
