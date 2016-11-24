//
// Yinnon Sanders      23 November 2016
//

#include <vector>
#include "Hole.h"
using namespace std;

class Cell
{
private:
    Hole * holeList;
    int numHoles;
    double avgAbsorption;
    // utility function, cannot be accessed outside
    void computeAvgAbsorption();
public:
    // initialize a cell with no holes
    Cell();
    // return efficiency, compute if unknown
    double getAvgAbsorption();
    // return list of holes
    Hole * getHoles();
    /* For the addHole function, at a minimum the location must be specified.
     * If the radius is omitted, the default radius, .200, will be used.
     * The order is X, Y[, radius]
     * */
    // add a hole
    void addHole(double, double, double = defaultRadius);
    // change a hole
    void setHole(Hole, double, double, double = defaultRadius);
    // delete hole
    void deleteHole(Hole);
    // print attributes of all holes in cell
    void displayHoles();
};
