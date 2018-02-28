CC = gcc
CFLAGS = -O3 -march=native -std=c99 -Wall -Wextra -Wshadow -Wpointer-arith -Wcast-qual -Wstrict-prototypes -Wmissing-prototypes

MEX = $(MATLAB_ROOT)/bin/mex
ifeq ($(USE_OPENMP),1)
	OMPFLAGS = CFLAGS="\$$CFLAGS -D USE_OPENMP -fopenmp" LDFLAGS="\$$LDFLAGS -fopenmp"
endif
MEXFLAGS = -IFFHT $(OMPFLAGS)
LDLIBS = FFHT/fht.o
ext = $(shell $(MATLAB_ROOT)/bin/mexext)

.PHONY: all clean test patch

all: ffht.$(ext)

# Replace 'inline' with 'static inline' in FFHT source (see FALCONN-LIB/FFHT#14)
ifeq ($(shell uname -s),Darwin)
patch:
	cd FFHT && grep -q static fht_avx.c || \
		sed -i '' 's/inline/static inline/g' fht_avx.c
	cd FFHT && grep -q static fht_sse.c || \
		sed -i '' 's/inline/static inline/g' fht_sse.c
	cd FFHT && grep -q static gen.py || \
		sed -i '' 's/inline/static inline/g' gen.py
else
patch:
	cd FFHT && grep -q static fht_avx.c || \
		sed -i 's/inline/static inline/g' fht_avx.c
	cd FFHT && grep -q static fht_sse.c || \
		sed -i 's/inline/static inline/g' fht_sse.c
	cd FFHT && grep -q static gen.py || \
		sed -i 's/inline/static inline/g' gen.py
endif

ffht.$(ext): ffht.c patch FFHT/fht.o
	$(MEX) $(MEXFLAGS) $(LDLIBS) $<

clean:
	-$(RM) FFHT/fht.o
	-$(RM) ffht.$(ext)

test: ffht.$(ext)
	$(MATLAB_ROOT)/bin/matlab -nodesktop -nojvm -r 'A = randn(2^20,100); tic; ffht(A); toc; exit;'
