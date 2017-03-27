//
// Yinnon Sanders      25 November 2016
//

#include <vector>
#include "Hole.h"
using namespace std;

#define MAXHOLES 300
#define MAXCELLS 24
#define NUMFREQUENCIES 300

class Cell
{
private:
    Hole * holeList;
    int numHoles;
    int * absorptions;
    double avgAbsorption;
    // utility function, cannot be accessed outside
    void computeAbsorptions();
    static double * frequencies;
public:
    // initialize a Cell object with no holes
    Cell();
    // initialize a Cell object from another (copy constructor)
    Cell(const Cell &obj);
    // initialize a Cell object from another (assignment constructor)
    Cell& operator=(const Cell& obj);
    // return efficiency, compute if unknown
    double getAvgAbsorption();
    // return absorptions, compute if unknown
    double * getAbsorptions();
    // reset efficiency
    void resetAbsorption();
    // return list of holes
    Hole * getHoles();
    // return number of holes
    int getNumHoles();
    /* For the addHole function, at a minimum the location must be specified.
     * If the radius is omitted, the default radius, .200, will be used.
     * The order is X, Y[, radius]
     * */
    // add a hole
    void addHole(double, double, double = DEFAULTRADIUS);
    void addHole(Hole h);
    // add a random hole
    // (true = random radius, false = default radius)
    void addRandomHole(bool);
    // change a hole
    void setHole(Hole*, double, double, double = DEFAULTRADIUS);
    // delete hole
    void deleteHole(Hole*);
    // print attributes of all holes in cell
    void print();
};
