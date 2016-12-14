//
// Yinnon Sanders      25 November 2016
//

#include "Cell.h"
using namespace std;

#define MAXCOORDVELOCITY 1.0
#define MAXRADIUSVELOCITY 0.05

const double maxCoordVelocity = 1.0;
const double maxRadiusVelocity = 0.02;

class HoleVelocity
{
private:
    double xVelocity;
    double yVelocity;
    double radiusVelocity;
public:
    // initialize a HoleVelocity object
    HoleVelocity(double = 0.0, double = 0.0, double = 0.0);
    // initialize a HoleVelocity object with random parameters
    // (true = random radius velocity, false = no radius velocity)
    HoleVelocity(bool);
    // change x velocity
    void setXVelocity(double);
    // change y velocity
    void setYVelocity(double);
    // change radius velocity
    void setRadiusVelocity(double);
    // return x velocity
    double getXVelocity();
    // return y velocity
    double getYVelocity();
    // return radius velocity
    double getRadiusVelocity();
    // move a hole according to velocity
    void move(Hole*);
    // find direction from one hole to another
    static HoleVelocity findDirection(Hole*, Hole*);
    // multiply by scalar
    void multiplyByScalar(double);
    // add velocity
    void addOtherVelocity(HoleVelocity*);
    // print attributes of hole velocity
    void print();
};

class CellVelocity
{
private:
    HoleVelocity * holeVelocityList;
    int numHoleVelocities;
public:
    // initialize a cell velocity
    CellVelocity();
    // return list of hole velocities
    HoleVelocity * getHoleVelocities();
    // return number of hole velocities
    int getNumHoleVelocities();
    // add a hole velocity
    void addHoleVelocity(double = 0.0, double = 0.0, double = 0.0);
    void addHoleVelocity(HoleVelocity);
    // add a random hole velocity
    // (true = random radius velocity, false = no radius velocity)
    void addRandomHoleVelocity(bool);
    // change a hole velocity
    void setHoleVelocity(HoleVelocity*, double = 0.0, double = 0.0, double = 0.0);
    // delete hole velocity
    void deleteHoleVelocity(HoleVelocity*);
    // move a cell according to velocity
    void move(Cell*);
    // find direction from one cell to another
    static CellVelocity findDirection(Cell*, Cell*);
    // multiply by scalar
    void multiplyByScalar(double);
    // add velocity
    void addOtherVelocity(CellVelocity*);
    // print attributes of all hole velocities in cell
    void print();
};
