//
// Yinnon Sanders      23 November 2016
//

#include "Hole.h"
using namespace std;

// initialize a Hole object
Hole::Hole(double x, double y, double r)
{
	setX(x);
	setY(y);
	setRadius(r);
}

// change x coordinate of hole
void Hole::setX(double x)
{
	if (x < 0 || x > maxX)
		throw invalid_argument("x coordinate out of bounds");
	xCoordinate = x;
}

// change y coordinate of hole
void Hole::setY(double y)
{
	if (y < 0 || y > maxY)
		throw invalid_argument("y coordinate out of bounds");
	yCoordinate = y;
}

// change radius of hole
void Hole::setRadius(double r)
{
	if (r < 0)
		throw invalid_argument( "radius cannot be negative" );
	radius = r;
}

// return x coordinate of hole
double Hole::getX()
{
	return xCoordinate;
}

// return y coordinate of hole
double Hole::getY()
{
	return yCoordinate;
}

// return radius of hole
double Hole::getRadius()
{
	return radius;
}

// print attributes of hole
void Hole::displayAttributes()
{
	printf("Hole at %.2f, %.2f with radius of %.3f\n",
		xCoordinate, yCoordinate, radius);
}

bool Hole::operator==(const Hole& other)
{
	return (xCoordinate == other.xCoordinate &&
			yCoordinate == other.yCoordinate &&
			radius == other.radius);
}
