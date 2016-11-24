//
// Yinnon Sanders      23 November 2016
//

#include <fstream>
#include "Cell.h"
using namespace std;

// initialize a cell with no holes
Cell::Cell()
{
    holeList = (Hole *) malloc(300 * sizeof(Hole));
    numHoles = 0;
    avgAbsorption = -1.0;
}

// return efficiency, compute if unknown
double Cell::getAvgAbsorption()
{
    if (avgAbsorption == -1.0)
    {
        computeAvgAbsorption();
    }
    return avgAbsorption;
}

// return list of holes
Hole * Cell::getHoles()
{
    return holeList;
}

// add a hole
void Cell::addHole(double x, double y, double r)
{
    if (numHoles >= 300)
    {
        throw invalid_argument("too many holes");
    }
    holeList[numHoles] = Hole(x,y,r);
    numHoles++;
}

// change a hole
void Cell::setHole(Hole h, double x, double y, double r)
{
    for (int i = 0; i < numHoles; i++)
    {
        if (holeList[i] == h)
        {
            // found hole to change
            h.setX(x);
            h.setY(y);
            h.setRadius(r);
            return;
        }
    }
    throw invalid_argument("hole not found");
}

// delete hole
void Cell::deleteHole(Hole h)
{
    for (int i = 0; i < numHoles; i++)
    {
        if (holeList[i] == h)
        {
            // found hole to delete
            holeList[i] = holeList[numHoles - 1]; // replace with last hole
            numHoles--;
            return;
        }
    }
    throw invalid_argument("hole not found");
}

// print attributes of all holes in cell
void Cell::displayHoles()
{
    printf("There are %d holes in the cell:\n", numHoles);
    for (int i = 0; i < numHoles; i++)
    {
        holeList[i].displayAttributes();
    }
}

void Cell::computeAvgAbsorption()
{
    ofstream rp;
    rp.open("rodpos.txt", ios::out | ios::trunc);
    for (int i = 0; i < numHoles; i++)
    {
        rp << holeList[i].getX() << "\t"
           << holeList[i].getY() << "\t"
           << holeList[i].getRadius() << "\n" << endl;
    }
    rp.close();
    system("mpirun... > out.txt"); // run simulation
    system("~/findAbsorption.sh out.txt"); // calculate absorptions
    ifstream aa;
    rp.open("avgAbsorption.txt", ios::in);
    aa >> avgAbsorption;
}
