# Copyright 2018 Embedded Microprocessor Benchmark Consortium (EEMBC)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 
# Original Author: Shay Gal-on

#File : core_portme.mak

# FLAG : OPATH
# Path to the output folder. Default - current folder but overriden by litex.
OPATH?= ./

# Litex integration
SOFTWARE_DIR?=$(OPATH)..

include $(SOFTWARE_DIR)/include/generated/variables.mak
LITEX_LIBS:=$(LIBS)

# Flag : OUTFLAG
#	Use this flag to define how to to get an executable (e.g -o)
OUTFLAG= -o
# Flag : CC
#	Use this flag to define compiler to use

# Extract of CC defined in litex/soc/software/common.mak
ifeq ($(TRIPLE),--native--)
TARGET_PREFIX=
else
TARGET_PREFIX=$(TRIPLE)-
endif

ifeq ($(CLANG),1)
CC_normal      := $(CCACHE) clang -target $(TRIPLE) -integrated-as
CX_normal      := $(CCACHE) clang++ -target $(TRIPLE) -integrated-as
else
CC_normal      := $(CCACHE) $(TARGET_PREFIX)gcc -std=gnu99
CX_normal      := $(CCACHE) $(TARGET_PREFIX)g++
endif
AR_normal      := $(TARGET_PREFIX)gcc-ar
LD_normal      := $(TARGET_PREFIX)ld
OBJCOPY_normal := $(TARGET_PREFIX)objcopy

CC_quiet      = @echo " CC      " $@ && $(CC_normal)
CX_quiet      = @echo " CX      " $@ && $(CX_normal)
AR_quiet      = @echo " AR      " $@ && $(AR_normal)
LD_quiet      = @echo " LD      " $@ && $(LD_normal)
OBJCOPY_quiet = @echo " OBJCOPY " $@ && $(OBJCOPY_normal)

ifeq ($(V),1)
	CC = $(CC_normal)
	CX = $(CX_normal)
	AR = $(AR_normal)
	LD = $(LD_normal)
	OBJCOPY = $(OBJCOPY_normal)
else
	CC = $(CC_quiet)
	CX = $(CX_quiet)
	AR = $(AR_quiet)
	LD = $(LD_quiet)
	OBJCOPY = $(OBJCOPY_quiet)
endif

# Flag : CFLAGS
#	Use this flag to define compiler options. Note, you can add compiler options from the command line using XCFLAGS="other flags"
# CFLAGS based on litex/soc/software/common.mak

# Generate *.d Makefile dependencies fragments, include using;
# -include $(OBJECTS:.o=.d)
DEPFLAGS += -MD -MP

PORT_CFLAGS := $(DEPFLAGS) -O2 $(CPUFLAGS)
PORT_CFLAGS += -I$(BUILDINC_DIRECTORY)
PORT_CFLAGS += -I$(BUILDINC_DIRECTORY)/../libc
PORT_CFLAGS += -I$(CPU_DIRECTORY)
PORT_CFLAGS += -I$(SOC_DIRECTORY)/software
PORT_CFLAGS += -I$(SOC_DIRECTORY)/software/include

FLAGS_STR = "$(PORT_CFLAGS) $(XCFLAGS) $(XLFLAGS) $(LFLAGS_END)"
CFLAGS = $(PORT_CFLAGS) -I$(PORT_DIR) -I. -DFLAGS_STR=\"$(FLAGS_STR)\"

#Flag : LFLAGS_END
#	Define any libraries needed for linking or other flags that should come at the end of the link line (e.g. linker scripts). 
#	Note : On certain platforms, the default clock_gettime implementation is supported but requires linking of librt.
LFLAGS_END = -L$(SOFTWARE_DIR)/include -T ../litex/linker_$(FIRMWARE_MEM).ld
LFLAGS_END += $(PACKAGES:%=-L$(SOFTWARE_DIR)/%) $(LIBS:lib%=-l%)

# Flag : SEPARATE_COMPILE
# You must also define below how to create an object file, and how to link.
SEPARATE_COMPILE=1
ifdef SEPARATE_COMPILE
OFLAG 	= -o

# Flag : PORT_SRCS
# 	Port specific source files can be added here
PORT_SRCS = core_portme.c crt0.S
PORT_OBJS = $(addsuffix .o,$(basename $(PORT_SRCS)))

# pull in dependency info for *existing* .o files
-include $(OBJS:.o=.d)

# depend of generated files
$(OUTFILE): $(addprefix $(SOFTWARE_DIR)/include/generated, output_format.ld regions.ld)

VPATH = $(PORT_DIR):$(CPU_DIRECTORY)

$(OPATH)%.o : %.c
	$(CC) -c $(CFLAGS) $(XCFLAGS) $< -o $@

$(OPATH)%.o : %.S
	$(CC) -c $(CFLAGS) $< -o $@

else
PORT_SRCS = $(PORT_DIR)/core_portme.c $(CPU_DIRECTORY)/crt0.S
LFLAGS_END += -nostdlib -nodefaultlibs

endif

# Flag : LOAD
#	For a simple port, we assume self hosted compile and run, no load needed.

# Flag : RUN
#	For a simple port, we assume self hosted compile and run, simple invocation of the executable

#For native compilation and execution
LOAD = true
RUN = 

OEXT = .o
EXE = .elf

# Target : port_pre% and port_post%
# For the purpose of this simple port, no pre or post steps needed.

.PHONY : port_prebuild port_postbuild port_prerun port_postrun port_preload port_postload
port_pre% port_post% : 

MKDIR = mkdir -p

