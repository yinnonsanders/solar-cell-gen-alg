#include <meep.hpp>
using namespace meep;
using namespace std;

const double eps1 = 12.0; // epsilon of layer 1
const double eps2 = 1.0; // epsilon of layer 2
const double grating_periodicity = 1.0;
const double d1 = sqrt(eps2) / (sqrt(eps1)+sqrt(eps2)); // quarter wave stack dimensions
const double d2 = sqrt(eps1) / (sqrt(eps1)+sqrt(eps2));
const double half_cavity_width = d2;
const int N = 5;

const double pml_thickness = 1.0;
const double z_center = half_cavity_width + N*grating_periodicity + pml_thickness;

double eps(const vec &p) {
	vec r = p - vec(z_center);
	if (abs(r.z()) < half_cavity_width)
		return 1.0;
	else {
		double dz = abs(r.z()) - half_cavity_width;
		while (dz > grating_periodicity)
			dz -= grating_periodicity;
	return (dz < d1) ? eps1 : eps2;
	}
}

int main(int argc, char **argv){ 
	initialize mpi(argc,argv);
	const double amicron = 10.0;
	const grid_volume vol = vol1d(2*z_center,amicron);
	structure s(vol,eps,pml(pml_thickness));
	fields f(&s);

	const double w_midgap = (sqrt(eps1)+sqrt(eps2))/(4*sqrt(eps1)*sqrt(eps2));
	gaussian_src_time src(w_midgap, 1.0, 0.0, 5.0);
	f.add_point_source(Ex, src, vol.center());

	while (f.time() < f.last_source_time()) f.step();

	int maxbands = 5;
	int ttot = int(400/f.dt)+1; 
	complex<double> *p = new complex<double>[ttot];
	complex<double> *amps = new complex<double>[maxbands];
	double *freq_re = new double[maxbands];
	double *freq_im = new double[maxbands];

	int i=0;
	while (f.time() < f.last_source_time() + 400) {
		f.step();
		p[i++] = f.get_field(Ex,vol.center());
	}

	int num =  do_harminv(p, ttot, f.dt, 0.8*w_midgap, 1.2*w_midgap, maxbands, amps, freq_re, freq_im);

	master_printf("frequency,amplitude,quality factor\n"); 
	for (int i=0; i<num; ++i) 
		master_printf("%0.6g%+0.6gi,%0.5g%+0.5gi,%g\n",freq_re[i],freq_im[i],real(amps[i]),imag(amps[i]),-0.5*freq_re[i]/freq_im[i]);
	return 0;
	}
