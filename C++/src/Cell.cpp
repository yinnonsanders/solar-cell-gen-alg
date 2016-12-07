//
// Yinnon Sanders      23 November 2016
//

#include <fstream>
#include "Cell.h"
using namespace std;

bool Cell::isTaken[MAXCELLS] = {false};

// initialize a Cell object with no holes
Cell::Cell()
{
    numHoles = 0;
    avgAbsorption = -1.0;
    holeList = (Hole *) malloc(MAXHOLES * sizeof(Hole));
    for (int i = 0; i < MAXCELLS; i++)
    {
        if (!isTaken[i])
        {
            ID = i;
            isTaken[i] = true;
            return;
        }
    }
    throw invalid_argument("too many cells");
}

// initialize a Cell object from another (copy constructor)
Cell::Cell(const Cell &obj)
{
   numHoles = obj.numHoles;
   avgAbsorption = obj.avgAbsorption;
   holeList = (Hole *) malloc(MAXHOLES * sizeof(Hole));
   copy(obj.holeList, obj.holeList + numHoles, holeList);
   for (int i = 0; i < MAXCELLS; i++)
    {
        if (!isTaken[i])
        {
            ID = i;
            isTaken[i] = true;
            return;
        }
    }
    throw invalid_argument("too many cells");
}

// initialize a Cell object from another (assignment constructor)
Cell& Cell::operator=(const Cell &obj)
{
   numHoles = obj.numHoles;
   avgAbsorption = obj.avgAbsorption;
   holeList = (Hole *) malloc(MAXHOLES * sizeof(Hole));
   copy(obj.holeList, obj.holeList + numHoles, holeList);
   for (int i = 0; i < MAXCELLS; i++)
    {
        if (!isTaken[i])
        {
            ID = i;
            isTaken[i] = true;
            return *this;
        }
    }
    throw invalid_argument("too many cells");
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

// reset efficiency
void Cell::resetAvgAbsorption()
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

void Cell::computeAvgAbsorption()
{
    ofstream rp;
    string rpFilepath = "/home/ubuntu/solar-cell-gen-alg/C++/files/" + to_string(ID) + "/rodpos.txt";
    rp.open(rpFilepath, ios::out | ios::trunc);
    if (rp.is_open())
    {
        for (int i = 0; i < numHoles; i++)
        {
            rp << holeList[i].getX() << "\t"
               << holeList[i].getY() << "\t"
               << holeList[i].getRadius() << "\n" << endl;
        }
        rp.close();
    }
    else printf("Unable to open file");
    string cmd = "~/solar-cell-gen-alg/runParallel.sh " + to_string(ID);
    system(cmd.c_str()); // run simulation
    ifstream aa;
    aa.open("/home/ubuntu/solar-cell-gen-alg/C++/files/" + to_string(ID) + "/avgAbsorption.txt", ios::in);
    aa >> avgAbsorption;
}
