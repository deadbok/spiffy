BINARY = spiffy

############
#
# Paths
#
############

home = $(shell pwd)
sourcedir = $(home)/src
builddir = $(home)/build


#############
#
# Build tools
#
#############

CC = gcc $(COMPILEROPTIONS)
LD = ld
GDB = gdb
OBJCOPY = objcopy
OBJDUMP = objdump
MKDIR = mkdir -p

###############
#
# Files and libs
#
###############

FLAGS	+= -DCONFIG_BUILD_SPIFFS
CFILES = main.c
CFILES	+= spiffs_nucleus.c
CFILES	+= spiffs_gc.c
CFILES	+= spiffs_hydrogen.c
CFILES	+= spiffs_cache.c
CFILES	+= spiffs_check.c

INCLUDE_DIRECTIVES = -I./${sourcedir}
COMPILEROPTIONS = $(INCLUDE_DIRECTIVES) 
		
############
#
# Tasks
#
############

vpath %.c ${sourcedir} ${sourcedir}/default ${sourcedir}/test

OBJFILES = $(CFILES:%.c=${builddir}/%.o)

DEPFILES = $(CFILES:%.c=${builddir}/%.d)

ALLOBJFILES += $(OBJFILES)

DEPENDENCIES = $(DEPFILES) 

# link object files, create binary
$(BINARY): $(ALLOBJFILES)
	@echo "... linking"
	${CC} $(LINKEROPTIONS) -o ${builddir}/$(BINARY) $(ALLOBJFILES) $(LIBS)	   	

# compile c files
$(OBJFILES) : ${builddir}/%.o:%.c Makefile
		@echo "... compile $@"
		${CC} -MD -g -c -o $@ $<

all: ${builddir} $(BINARY) 

${builddir}:
	$(MKDIR) $@

clean:
	@echo ... removing build files in ${builddir}
	rm -f ${builddir}/*

	
#Include .d files with targets and dependencies.
-include $(patsubst %.c,${builddir}/%.d,$(CFILES))
