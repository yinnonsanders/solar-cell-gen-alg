//
// Yinnon Sanders      25 November 2016
//

#include <string>
using namespace std;

#define DEFAULTRADIUS .200
#define RADIUSSTDEV .050
#define MAXCOORD 4.0

class Hole
{
private:
    double xCoordinate;
    double yCoordinate;
    double radius;
public:
    // initialize a Hole object
    Hole(double, double, double = DEFAULTRADIUS);
    // initialize a Hole object with random parameters
    // (true = random radius, false = default radius)
    Hole(bool);
    // change x coordinate of hole
    void setX(double);
    // change y coordinate of hole
    void setY(double);
    // change radius of hole
    void setRadius(double);
    // return x coordinate of hole
    double getX();
    // return y coordinate of hole
    double getY();
    // return radius of hole
    double getRadius();
    // print attributes of hole
    void print();
};
