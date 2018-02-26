#ifdef USE_OPENMP
#include <omp.h>
#endif
#include <math.h>
#include <string.h>
#include "mex.h"
#include "fht.h"


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *A;    /* pointers to input matrices */
    double *B;    /* in/out arguments to fht */
    size_t m,n;   /* matrix dimensions */
    int p;        /* log2 number of rows: m = 2^p */
    size_t i;

 	/* Check for proper number of arguments. */
    if ( nrhs != 1) {
        mexErrMsgIdAndTxt("MATLAB:fht_mex:rhs",
            "This function requires 1 input matrix.");
    }
    if ( nlhs > 1) {
        mexErrMsgIdAndTxt("MATLAB:fht_mex:lhs",
            "This function provides a single output");
    }
    A = mxGetPr(prhs[0]); /* pointer to input matrix */
    m = mxGetM(prhs[0]);
    n = mxGetN(prhs[0]);

    /* Validate input arguments */
    p = (int) log2((double)m);
    if ((1 << p) != m) {
        mexErrMsgIdAndTxt("MATLAB:fht_mex:rhs",
            "Number of rows in input must be a power of 2.");
    }

    /* fht_double works in-place; copy the input first */
    plhs[0] = mxCreateDoubleMatrix(m, n, mxREAL);
    B = mxGetPr(plhs[0]);
    memcpy(B, A, m*n*mxGetElementSize(prhs[0]));

    /* Call fht_double */
    #pragma omp parallel for num_threads(omp_get_num_procs())
    for (i=0;i<n;i++) {
        fht_double(B+i*m, p);
    }
    /* plhs[0] now holds ffht(A) */
}
