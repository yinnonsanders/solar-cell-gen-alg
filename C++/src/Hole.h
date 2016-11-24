//
// Yinnon Sanders      23 November 2016
//

#include <string>
using namespace std;

const double defaultRadius = .200;
const double maxX = 8.0;
const double maxY = 8.0;

class Hole
{
private:
    double xCoordinate;
    double yCoordinate;
    double radius;
public:
    // initialize a Hole object
    Hole(double, double, double = defaultRadius);
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
    void displayAttributes();
    // check equality of holes
    bool operator== (const Hole &);
};
