#include <algorithm>
#include <complex>
#include <iostream>

#include <fftw3.h>


int main(int ac, char** av)
{
    const int N = 256;

    std::complex<double>* in  = new std::complex<double>[N];
    for (int w = N / 4, i = 0, f = 1; i < N; i += w, f *= -1)
    {
        std::fill(in + i, in + i + w, std::complex<double>(1.0 * f, 0.0));
    }

    std::complex<double>* out = new std::complex<double>[N];

    fftw_plan p = fftw_plan_dft_1d(
        N,
        reinterpret_cast<fftw_complex*>(in),
        reinterpret_cast<fftw_complex*>(out),
        FFTW_FORWARD,
        FFTW_ESTIMATE
    );
    fftw_execute(p);
    fftw_destroy_plan(p);

    delete [] in;

    for (int i = 0; i < N; i++)
    {
        std::cout << out[i] << std::endl;
    }
    delete [] out;
}
