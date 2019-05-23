
# This is a GNU Makefile.

# It can be used to compile an OpenCL program with
# the Altera Beta OpenCL Development Kit.
# See README.txt for more information.


# You must configure ALTERAOCLSDKROOT to point the root directory of the Altera SDK for OpenCL
# software installation.
# See doc/getting_started.txt for more information on installing and
# configuring the Altera SDK for OpenCL.


# Creating a static library
TARGET = mysort 

# Where is the Altera SDK for OpenCL software?
#ifeq ($(wildcard $(ALTERAOCLSDKROOT)),)
#$(error Set ALTERAOCLSDKROOT to the root directory of the Altera SDK for OpenCL software installation)
#endif
#ifeq ($(wildcard $(ALTERAOCLSDKROOT)/host/include/CL/opencl.h),)
#$(error Set ALTERAOCLSDKROOT to the root directory of the Altera SDK for OpenCL software installation.)
#endif

# Libraries to use, objects to compile
SRCS = mysort.cpp pthread_sort.cpp cudasort.cu
SRCS_FILES = $(foreach F, $(SRCS), ./$(F))
#OBJS=$(SRCS:.c*=.o)
#COMMON_FILES = ./common/src/AOCL_Utils.cpp
CXX_FLAGS = -lpthread -lm -O3 -g -lcuda -lcudart

# arm cross compiler
#CROSS-COMPILE = arm-linux-gnueabihf-

# OpenCL compile and link flags.
#AOCL_COMPILE_CONFIG=$(shell aocl compile-config --arm) -I./common/inc 
#AOCL_LINK_CONFIG=$(shell aocl link-config --arm) 


# Make it all!
all : mysort.o pthread_sort.o cudasort.o
#	nvcc  $(CXX_FLAGS) $(SRCS_FILES) $(COMMON_FILES) -c
	nvcc $(CXX_FLAGS) mysort.o pthread_sort.o cudasort.o -o $(TARGET)
#	$(CROSS-COMPILE)g++ $(SRCS_FILES) $(COMMON_FILES) $(CXX_FLAGS) -c   $(AOCL_COMPILE_CONFIG) $(AOCL_LINK_CONFIG)
#	$(CROSS-COMPILE)g++ $(SRCS_FILES) $(COMMON_FILES) $(CXX_FLAGS) -c   $(AOCL_COMPILE_CONFIG) $(AOCL_LINK_CONFIG)
#	$(CROSS-COMPILE)g++ $(CXX_FLAGS) $(OBJS) -o $(TARGET)  $(AOCL_COMPILE_CONFIG) $(AOCL_LINK_CONFIG)

mysort.o: mysort.cpp 
	nvcc $(CXX_FLAGS) mysort.cpp -c 
    
pthread_sort.o: pthread_sort.cpp 
	nvcc $(CXX_FLAGS) pthread_sort.cpp -c
    
cudasort.o: cudasort.cu 
	nvcc $(CXX_FLAGS) cudasort.cu -c

#fpgasort.aocx: 
#	aoc fpgasort.cl -o fpgasort.aocx --board de1soc_sharedonly

# Standard make targets
clean :
	@rm -f *.o $(TARGET)
