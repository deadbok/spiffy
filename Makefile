#Final target name.
TARGET := spiffy
#Directory where the Makefile was run.
CURRENT_DIR := $(shell pwd)

#Directories.
SRC_DIR = $(CURRENT_DIR)/src
BUILD_DIR = $(CURRENT_DIR)/build

#Commands.
CC := gcc
LD := ld
MKDIR := mkdir -p

#Files
SRC := $(foreach sdir,$(SRC_DIR),$(wildcard $(sdir)/*.c))
OBJ	:= $(patsubst %.c,$(BUILD_DIR)/%.o,$(notdir $(SRC)))

ifeq ($(DEBUG), 1)
CFLAGS += -g -O0 -DDEBUG
endif

#Build rules.
#############
vpath %.c $(SRC_DIR)
vpath %.h $(SRC_DIR)

all: $(TARGET) 

# link object files, create binary
$(TARGET): $(BUILD_DIR) $(OBJ)
	$(CC) $(LDFLAGS) -o $@ $(OBJ) $(LIBS)	   	

# compile c files
$(BUILD_DIR)/%.o: %.c
	$(CC) $(CFLAGS) -I$(SRC_DIR) -MD -c -o $@ $<

${BUILD_DIR}:
	$(MKDIR) $@

clean:
	rm -f $(TARGET)
	rm -fR $(BUILD_DIR)
	
#Include .d files with targets and dependencies.
-include $(patsubst %.c,$(BUILD_DIR)/%.d,$(notdir $(SRC)))
