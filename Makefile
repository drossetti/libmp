#use_nccl:=1
#use_gdr:=1
#use_singlestream:=1

CC=mpic++
LD=mpic++ 
#nvcc
NVCC=nvcc
CPPFLAGS=-I. -I${MPI_HOME}/include -DHAVE_VERBS
# -DMACOSX
CFLAGS=-O2 -g
LDFLAGS=-L${MPI_HOME}/lib64 -lmpi -libverbs
#-lpthread
NVCCFLAGS=
#-O2 -arch=sm_60 -Xptxas -dlcm=ca -Xptxas=-v -DPROFILE_NVTX_RANGES

CUDADIR= /usr/local/cuda-8.0
CUDAINCLUDEDIR= $(CUDADIR)/include
CUDALDFLAGS=-L$(CUDADIR)/lib -lcudart

OBJ=oob.o oob_mpi.o oob_socket.o tl.o tl_verbs.o raw_pt2pt.o

ifdef use_gdr
	CPPFLAGS+=-DGPURDMA
endif

.PHONY: all clean

all: raw_pt2pt

raw_pt2pt: $(OBJ)
	$(LD) -o raw_pt2pt $(OBJ) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS}

.cc.o:
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@


clean:
	rm -rf *.o raw_pt2pt
