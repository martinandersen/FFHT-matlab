# MATLAB Interface to Fast Fast Hadamard Transform (FFHT)

This project provides a very basic MATLAB interface to [FFHT](https://github.com/FALCONN-LIB/FFHT), an optimized C99 implementation of the Fast Hadamard Transform. It is significantly faster than `fwht()` (Fast Welsh–Hadamard Transform) from MATLAB's Signal Processing Toolbox. Note that unlike `fwht()`, the FFHT implementation computes the *unnormalized* Hadamard transformation.


## Getting Started

### Prerequisites

The interface consists of a single MATLAB MEX file. Compiling the MEX file requires a MATLAB installation as well as a MATLAB supported compiler. For more information, refer to MATLAB's documentation: [What You Need to Build MEX Files](https://www.mathworks.com/help/matlab/matlab_external/what-you-need-to-build-mex-files.html)

### Compiling the MEX file

```
git clone --recursive https://github.com/martinandersen/FFHT-matlab.git
cd FFHT-matlab
make MATLAB_ROOT=/path/to/matlab/root
```

```
make MATLAB_ROOT=/path/to/matlab/root test
```

## Example

```matlab
>> X = randn(2^20,100);
>> Y = ffht(X);
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
