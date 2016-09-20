//
// Yinnon Sanders      20 September 2016
//
#include <string>
using namespace std;

enum Shape { circle, square, triangle };

class Hole
{
private:
    double xPosition;
    double yPosition;
    Shape shape;
    double radius;
public:
    // initialize a Hole object
    Hole(double, double, Shape, double);
    // initialize a Hole object with default shape (circle)
    Hole(double, double, double);
    // initialize a Hole object with default radius
    Hole(double, double, Shape, double);
    // initialize a Hole object with default shape and radius
    Hole(double, double);
    // change x coordinate of hole
    void setX(double);
    // change y coordinate of hole
    void setY(double);
    // change radius of hole
    void setRadius(double);
    // change shape of hole
    void setShape(Shape);
    // return x coordinate of hole
    double getX();
    // return y coordinate of hole
    double getY();
    // return radius of hole
    double getRadius(double);
    // return shape of hole
    Shape getShape(Shape);
    // print attributes of hole
    void displayAttributes();
};
