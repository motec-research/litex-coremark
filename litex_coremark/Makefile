# location of this Makefile
MK_DIR := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))
BUILD_DIR := $(shell pwd)/

# default to known workinmg configuration
COREMARK_MEM?= rom_sram
OPATH := $(BUILD_DIR)$(COREMARK_MEM)/

COREMARK_ELF = $(OPATH)coremark.elf
COREMARK_BIN = $(BUILD_DIR)coremark.bin
all: $(COREMARK_BIN)

$(COREMARK_BIN): $(COREMARK_ELF)
	$(OBJCOPY) -O binary $< $@
ifneq ($(OS),Windows_NT)
	chmod -x $@
endif

MAKE_VARS := SOFTWARE_DIR=$(BUILD_DIR)/..
MAKE_VARS += PORT_DIR=../litex
MAKE_VARS += OPATH=$(OPATH)
MAKE_VARS += COREMARK_MEM=$(COREMARK_MEM)

.PHONY : $(COREMARK_ELF)
$(COREMARK_ELF):
	$(MAKE) -C $(MK_DIR)/coremark $(MAKE_VARS) $@

include ../include/generated/variables.mak
include $(SOC_DIRECTORY)/software/common.mak
