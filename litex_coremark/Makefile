# location of this Makefile
MK_DIR := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))
OPATH := $(shell pwd)/

# main_ram or rom
FIRMWARE_MEM?= main_ram

all: $(OPATH)coremark.bin

$(OPATH)%.bin: $(OPATH)%.elf
	$(OBJCOPY) -O binary $< $@
ifneq ($(OS),Windows_NT)
	chmod -x $@
endif

.PHONY : $(OPATH)coremark.elf
$(OPATH)coremark.elf:
	$(MAKE) -C $(MK_DIR)/coremark PORT_DIR=../litex OPATH=$(OPATH) FIRMWARE_MEM=$(FIRMWARE_MEM) $@

include ../include/generated/variables.mak
include $(SOC_DIRECTORY)/software/common.mak
