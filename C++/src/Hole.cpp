//
// Yinnon Sanders      23 November 2016
//

#include "Hole.h"
#include <random>
using namespace std;

// initialize a Hole object
Hole::Hole(double x, double y, double r)
{
	setX(x);
	setY(y);
	setRadius(r);
}

// initialize a Hole object with random parameters
// (true = random radius, false = default radius)
Hole::Hole(bool randomRadius)
{
	random_device rd;
    mt19937 gen(rd());
	uniform_real_distribution<double> unifCoord(0.0, MAXCOORD);
	setX(unifCoord(gen));
	setY(unifCoord(gen));
	if (randomRadius)
	{
		normal_distribution<double> normRad(DEFAULTRADIUS, RADIUSSTDEV);
		setRadius(normRad(gen));
	}
	else
		setRadius(DEFAULTRADIUS);
}

// change x coordinate of hole
void Hole::setX(double x)
{
	if (x < 0)
		xCoordinate = 0;
	else if (x > MAXCOORD)
		x = MAXCOORD;
	else
		xCoordinate = x;
}

// change y coordinate of hole
void Hole::setY(double y)
{
	if (y < 0)
		yCoordinate = 0;
	else if (y > MAXCOORD)
		yCoordinate = MAXCOORD;
	else
		yCoordinate = y;
}

// change radius of hole
void Hole::setRadius(double r)
{
	if (r < 0)
		radius = 0;
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
void Hole::print()
{
	printf("Hole at (%.2f, %.2f) with radius of %.3f\n",
		xCoordinate, yCoordinate, radius);
}
