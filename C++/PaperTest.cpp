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
const double pml_thickness = 1.0; // thickness of pml

const double resolution = 15; // pixels per unit

const double diameter = 2.7 * t; // diameter of holes
const double r = diameter / 2; // radius of holes

double holeLocations[] = {25.0,25.0};
const int numHoles = 1;

const double minFreq = .07; // lowest frequency
const double maxFreq = .09; // highest frequency
const int nFreq = 10; // number of frequencies at which to compute flux
const double dFreq =
        (maxFreq - minFreq) / (nFreq - 1); // difference between frequencies

const double tStop = 20.0; // time to run simulation

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
    double sqdistance;
    for (int i = 0; i < 2 * numHoles; i += 2) {
        sqdistance = pow(p.x() - holeLocations[i], 2.0) +
                     pow(p.y() - holeLocations[i + 1], 2.0);
        if(sqdistance < pow(r, 2.0)) return 1.0; // inside a hole
    }
    return epsSi;
}

void transmission(double *THoles, double *RHoles, double *AHoles,
                  double *TPlain, double *RPlain, double *APlain) {

    //define size of computational cell
    grid_volume gv = vol3d(sx + 2 * pml_thickness, sy + 2 * pml_thickness,
                           sz + 2 * pml_thickness, resolution);

    // define structure and fields with plain cell
    structure sPlain(gv, epsPlain, pml(pml_thickness));
    fields fPlain(&sPlain);
    fPlain.use_real_fields();

    // define structure and fields with cell with holes
    structure sHoles(gv, epsHoles);
    fields fHoles(&sHoles);
    fHoles.use_real_fields();

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
    fHoles.add_volume_source(Ez, src, srcPlane);
    fPlain.add_volume_source(Ez, src, srcPlane);
    fEmpty.add_volume_source(Ez, src, srcPlane);

    // add flux planes
    dft_flux tFluxHoles =
            fHoles.add_dft_flux_plane(tFluxPlane, minFreq, maxFreq, nFreq);
    dft_flux rFluxHoles =
            fHoles.add_dft_flux_plane(rFluxPlane, minFreq, maxFreq, nFreq);
    dft_flux tFluxPlain =
            fPlain.add_dft_flux_plane(tFluxPlane, minFreq, maxFreq, nFreq);
    dft_flux rFluxPlain =
            fPlain.add_dft_flux_plane(rFluxPlane, minFreq, maxFreq, nFreq);
    dft_flux tFluxEmpty =
            fEmpty.add_dft_flux_plane(tFluxPlane, minFreq, maxFreq, nFreq);
    dft_flux rFluxEmpty =
            fEmpty.add_dft_flux_plane(rFluxPlane, minFreq, maxFreq, nFreq);

    while (fHoles.time() < tStop) fHoles.step();

    while (fPlain.time() < tStop) fPlain.step();

    while (fEmpty.time() < tStop) fEmpty.step();

    // subtract the fields for the reflection
    rFluxHoles -= rFluxEmpty;
    rFluxPlain -= rFluxEmpty;

    double *fluxHoles = tFluxHoles.flux();
    double *fluxPlain = tFluxPlain.flux();
    double *fluxEmpty = tFluxEmpty.flux();
    for (int i = 0; i < nFreq; i++) {
        THoles[i] = fluxHoles[i] / fluxEmpty[i];
        TPlain[i] = fluxPlain[i] / fluxEmpty[i];
    }
    fluxHoles = rFluxHoles.flux();
    fluxPlain = rFluxPlain.flux();
    fluxEmpty = rFluxEmpty.flux();
    for (int i = 0; i < nFreq; i++) {
        RHoles[i] = -fluxHoles[i] / fluxEmpty[i];
        RPlain[i] = -fluxPlain[i] / fluxEmpty[i];
    }
    for (int i = 0; i < nFreq; i++) {
        AHoles[i] = 1 - THoles[i] - RHoles[i];
        APlain[i] = 1 - TPlain[i] - RPlain[i];
    }
    delete[] fluxPlain;
    delete[] fluxEmpty;
}

int main(int argc,char **argv){
    initialize mpi(argc,argv);

    double *THoles = new double[nFreq];
    double *RHoles = new double[nFreq];
    double *AHoles = new double[nFreq];
    double *TPlain = new double[nFreq];
    double *RPlain = new double[nFreq];
    double *APlain = new double[nFreq];

    transmission(THoles, RHoles, AHoles, TPlain, RPlain, APlain);

    master_printf("transmission: freq (t/lambda), T, R, A, T(Holes), R(Holes), A(Holes)\n");
    for (int i = 0; i < nFreq; ++i) {
        master_printf("transmission: %g, %g, %g, %g, %g, %g, %g\n",
                      minFreq + i * dFreq, TPlain[i], RPlain[i], APlain[i],
                      THoles[i], RHoles[i], AHoles[i]);
    }
    master_printf("finished.\n");

    return 0;
}
