//
// Yinnon Sanders      23 November 2016
//

#include <fstream>
#include "Cell.h"
using namespace std;

// initialize a Cell object with no holes
Cell::Cell()
{
    numHoles = 0;
    avgAbsorption = -1.0;
    holeList = (Hole *) malloc(MAXHOLES * sizeof(Hole));
    absorptions = (double*) malloc(NUMFREQUENCIES * sizeof(double));
}

// initialize a Cell object from another (copy constructor)
Cell::Cell(const Cell &obj)
{
   numHoles = obj.numHoles;
   avgAbsorption = obj.avgAbsorption;
   holeList = (Hole *) malloc(MAXHOLES * sizeof(Hole));
   copy(obj.holeList, obj.holeList + numHoles, holeList);
   absorptions = (double*) malloc(NUMFREQUENCIES * sizeof(double));
}

// return efficiency, compute if unknown
double Cell::getAvgAbsorption()
{
    if (avgAbsorption == -1.0)
    {
        computeAbsorptions();
    }
    return avgAbsorption;
}

double * Cell::getAbsorptions()
{
    if (avgAbsorption == -1.0)
    {
        computeAbsorptions();
    }
    return absorptions;
}

double * Cell::getFrequencies()
{
    double * frequencies = (double*) malloc(NUMFREQUENCIES*sizeof(double));
    ifstream in("/home/ubuntu/solar-cell-gen-alg/C++/freqs.txt");
    for (int i = 0; i < NUMFREQUENCIES; i++)
    {
        in >> frequencies[i];
    }
    return frequencies;
}

// reset efficiency
void Cell::resetAbsorption()
{
    avgAbsorption = -1.0;
}

// return list of holes
Hole * Cell::getHoles()
{
    return holeList;
}

// return number of holes
int Cell::getNumHoles()
{
    return numHoles;
}

// add a hole
void Cell::addHole(double x, double y, double r)
{
    if (numHoles >= MAXHOLES)
    {
        throw invalid_argument("too many holes");
    }
    holeList[numHoles] = Hole(x,y,r);
    numHoles++;
    avgAbsorption = -1.0;
}

void Cell::addHole(Hole h)
{
    if (numHoles >= MAXHOLES)
    {
        throw invalid_argument("too many holes");
    }
    holeList[numHoles] = h;
    numHoles++;
    avgAbsorption = -1.0;
}

// add a random hole
// (true = random radius, false = default radius)
void Cell::addRandomHole(bool randomRadius)
{
    if (numHoles >= MAXHOLES)
    {
        throw invalid_argument("too many holes");
    }
    holeList[numHoles] = Hole(randomRadius);
    numHoles++;
    avgAbsorption = -1.0;
}

// change a hole
void Cell::setHole(Hole* h, double x, double y, double r)
{
    for (int i = 0; i < numHoles; i++)
    {
        if (holeList + i == h)
        {
            // found hole to change
            holeList[i].setX(x);
            holeList[i].setY(y);
            holeList[i].setRadius(r);
            avgAbsorption = -1.0;
            return;
        }
    }
    throw invalid_argument("hole not found");
}

// delete hole
void Cell::deleteHole(Hole* h)
{
    for (int i = 0; i < numHoles; i++)
    {
        if (holeList+ i == h)
        {
            // found hole to delete
            holeList[i] = holeList[numHoles - 1]; // replace with last hole
            numHoles--;
            avgAbsorption = -1.0;
            return;
        }
    }
    throw invalid_argument("hole not found");
}

// print attributes of all holes in cell
void Cell::print()
{
    printf("There are %d holes in the cell:\n", numHoles);
    for (int i = 0; i < numHoles; i++)
    {
        holeList[i].print();
    }
}

void Cell::computeAbsorptions()
{
    ofstream rp;
    string rpFilepath = "/home/ubuntu/solar-cell-gen-alg/C++/rodpos.txt";
    rp.open(rpFilepath, ios::out | ios::trunc);
    if(rp.is_open())
    {
        for(int i = 0; i < numHoles; i++)
        {
            rp << holeList[i].getX() << "\t"
               << holeList[i].getY() << "\t"
               << holeList[i].getRadius() << "\n" << endl;
        }
        rp.close();
    }
    else printf("Unable to open file");
    string cmd = "/home/ubuntu/solar-cell-gen-alg/C++/findAbsorption.sh";
    system(cmd.c_str()); // run simulation
    ifstream emptyrfluxes("/home/ubuntu/solar-cell-gen-alg/C++/emptyrfluxes.txt");
    ifstream emptytfluxes("/home/ubuntu/solar-cell-gen-alg/C++/emptytfluxes.txt");
    ifstream rfluxes("/home/ubuntu/solar-cell-gen-alg/C++/rfluxes.txt");
    ifstream tfluxes("/home/ubuntu/solar-cell-gen-alg/C++/tfluxes.txt");
    double erf;
    double etf;
    double rf;
    double tf;
    double r;
    double t;
    double absSum = 0;
    for (int i = 0; i < NUMFREQUENCIES; i++)
    {
        emptyrfluxes >> erf;
        emptytfluxes >> etf;
        rfluxes >> rf;
        tfluxes >> tf;
        r = -rf / erf;
        t = tf / etf;
        abs = 1.0 - t - r;
        absorptions[i] = abs;
        absSum += abs;
    }
    avgAbsorption = absSum / NUMFREQUENCIES;
}
