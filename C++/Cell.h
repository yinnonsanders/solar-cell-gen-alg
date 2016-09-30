//
// Yinnon Sanders      20 September 2016
//
#include <string>
#include <vector>
#include "Hole.h"
using namespace std;

class Cell
{
private:
    vector<Hole> holeList;
    double efficiency;
    // utility function, cannot be accessed outside
    void computeEfficiency();
public:
    // initialize a cell with no holes
    Cell();
    // copy a cell
    Cell(Cell);
    // return efficiency, compute if unknown
    double getEfficiency();
    // return list of holes
    vector<Hole> getHoles();
    /* For the addHole function, at a minimum the location must be specified. If
     * the shape is omitted, the default shape, a circle, will be used. If the
     * radius is omitted, the default radius, to be determined, will be used.
     * The order is X, Y[, shape][, radius]
     * */
    // add a hole
    void addHole(double, double, Shape, double);
    // add a hole with default radius
    void addHole(double, double, Shape = circle);
    // add a hole with default shape (circle)
    void addHole(double, double, double);
    // add a hole with default shape and radius
    void addHole(double, double);
    /* For the addHoleRand function, the user can either specify the location
     * and shape or leave them up to a random number generator. For the radius,
     * however, either a specific or a range must be entered.
     * The order is [X, Y,] [shape,] [radius]/[radiusMin, radiusMax]
     * */
    // add a hole with random radius within specified range
    void addHoleRand(double, double, Shape, double, double);
    // add a hole with random shape
    void addHoleRand(double, double, double);
    // add a hole with random shape and radius within specified range
    void addHoleRand(double, double, double, double);
    // add a hole with random location
    void addHoleRand(Shape, double);
    // add a hole with random location and radius within specified range
    void addHoleRand(Shape, double, double);
    // add a hole with random location and shape
    void addHoleRand(double);
    // add a hole with random location, shape, and radius
    void addHoleRand(double, double);
    /* For the deleteHole function, either the X and Y coordinates or the
     * position of the hole to be deleted in the array must be specified.
     * */
    // delete hole at specified location
    void deleteHole(double, double);
    // delete random hole
    void deleteHoleRand();
    // print attributes of all holes in cell
    void displayHoles();
};
