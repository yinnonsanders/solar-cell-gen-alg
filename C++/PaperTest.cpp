//
// Created by Yinnon on 9/26/16.
//

#include "meep.hpp"
#include <vector>

using namespace meep;
using namespace std;

const double epsSi = 12.0; // dielectric constant of cell material (Si)

// Dimensions
const double t = 1.0; // cell thickness
const double sy = 50.0; // size of cell in y direction
const double sx = 50.0; // size of cell in x direction
const double sz = 2 * t; // height of computational cell

const double resolution = 25; // pixels per unit

const double diameter = 2.7 * t; // diameter of holes
const double r = diameter / 2; // radius of holes

const vector<double> holeLocations = {{25.0,25.0}};

const double minFreq = .07; // lowest frequency
const double maxFreq = .09; // highest frequency
const int nFreq = 10; // number of frequencies at which to compute flux
const double dFreq =
        (maxFreq - minFreq) / (nFreq - 1); // difference between frequencies

const double tStop = 1.5; // time to run simulation

double epsEmpty(const vec &) // epsilon function of air
{
    return 1.0; // dielectric constant of air
}

double epsPlain(const vec &p) // epsilon function of cell with no holes
{
    if(p.z() < t) {
        // below cell
        return 1.0; // dielectric constant of air
    }
    return epsSi;
}

double epsHoles(const vec &p) // epsilon function of cell with holes
{
    if(p.z() < t) {
        // below cell
        return 1.0; // dielectric constant of air
    }
    double distance;
    for (int i = 0; i < (holeLocations.size() / 2); i++) {
        distance = pow(p.x() - holeLocations[i], 2.0)
        if(p.x())
    }
    return epsSi;
}

void transmission(double *T, double *R) {

    //define size of computational cell
    grid_volume gv = vol3d(sx,sy,sz,resolution);

    // define structure and fields with plain cell
    structure sPlain(gv, epsPlain);
    fields fPlain(&sPlain);
    fPlain.use_real_fields();

    // define structure and fields with air
    structure sEmpty(gv, epsEmpty);
    fields fEmpty(&sEmpty);
    fEmpty.use_real_fields();

    // define plane to be the source of waves
    volume srcPlane(vec(0,0,0),vec(sx,sy,0));

    // define transmission and reflection flux planes
    volume tFluxPlane(vec(0,0,sz),vec(sx,sy,sz));
    volume rFluxPlane(vec(0,0,t),vec(sx,sy,t));

    // define source frequency
    complex<double> sourceFreq = complex<double>((minFreq + maxFreq) / 2);

    // define source
    continuous_src_time src(sourceFreq, 0.0);
    // gaussian_src_time src((minFreq + maxFreq) * 0.5, 0.5, 0, 5);

    // add source to fields
    fPlain.add_volume_source(Ez, src, srcPlane);
    fEmpty.add_volume_source(Ez, src, srcPlane);

    // add flux planes
    dft_flux tFluxPlain =
            fPlain.add_dft_flux_plane(tFluxPlane, minFreq, maxFreq, nFreq);
    dft_flux rFluxPlain =
            fPlain.add_dft_flux_plane(rFluxPlane, minFreq, maxFreq, nFreq);
    dft_flux tFluxEmpty =
            fEmpty.add_dft_flux_plane(tFluxPlane, minFreq, maxFreq, nFreq);
    dft_flux rFluxEmpty =
            fEmpty.add_dft_flux_plane(rFluxPlane, minFreq, maxFreq, nFreq);

    while (fEmpty.time() < tStop) fEmpty.step();

    while (fPlain.time() < tStop) fPlain.step();

    // subtract the fields for the reflection
    rFluxPlain -= rFluxEmpty;

    double *fluxPlain = tFluxPlain.flux();
    double *fluxEmpty = tFluxEmpty.flux();
    for (int i = 0; i < nFreq; ++i) {
        T[i] = fluxPlain[i] / fluxEmpty[i];
    }
    fluxPlain = rFluxPlain.flux();
    fluxEmpty = rFluxEmpty.flux();
    for (int i = 0; i < nFreq; ++i) {
        R[i] = fluxPlain[i] / fluxEmpty[i];
    }
    delete[] fluxPlain;
    delete[] fluxEmpty;
}

int main(int argc,char **argv){
    initialize mpi(argc,argv);

    double *T = new double[nFreq];
    double *R = new double[nFreq];

    transmission(T,R);

    master_printf("transmission:, freq (t/lambda), T, R\n");
    for (int i = 0; i < nFreq; ++i) {
        master_printf("transmission:, %g, %g, %g\n",
                      minFreq + i * dFreq, T[i], R[i]);
    }
    master_printf("finished.\n");

    return 0;
}
