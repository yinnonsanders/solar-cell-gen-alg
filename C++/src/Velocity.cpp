//
// Yinnon Sanders      25 November 2016
//

#include "Velocity.h"
#include <cstdlib>
#include <random>
using namespace std;

// initialize a HoleVelocity object
HoleVelocity::HoleVelocity(double xv, double yv, double rv)
{
	setXVelocity(xv);
	setYVelocity(yv);
	setRadiusVelocity(rv);
}

// initialize a HoleVelocity object with random parameters
// (true = random radius velocity, false = no radius velocity)
HoleVelocity::HoleVelocity(bool randomRadiusVelocity)
{
	random_device rd;
    mt19937 gen(rd());
	uniform_real_distribution<double> unifCoord(-MAXCOORDVELOCITY, MAXCOORDVELOCITY);
	setXVelocity(unifCoord(gen));
	setYVelocity(unifCoord(gen));
	if (randomRadiusVelocity)
	{
		uniform_real_distribution<double> unifRad(-MAXRADIUSVELOCITY, MAXRADIUSVELOCITY);
		setRadiusVelocity(unifRad(gen));
	}
	else
		setRadiusVelocity(0.0);
}

// change x velocity
void HoleVelocity::setXVelocity(double xv)
{
	if (xv > MAXCOORDVELOCITY)
		xVelocity = MAXCOORDVELOCITY;
	else if (xv < -MAXCOORDVELOCITY)
		xVelocity = -MAXCOORDVELOCITY;
	else
		xVelocity = xv;
}

// change y velocity
void HoleVelocity::setYVelocity(double yv)
{
	if (yv > MAXCOORDVELOCITY)
		yVelocity = MAXCOORDVELOCITY;
	else if (yv < -MAXCOORDVELOCITY)
		yVelocity = -MAXCOORDVELOCITY;
	else
		yVelocity = yv;
}

// change radius velocity
void HoleVelocity::setRadiusVelocity(double rv)
{
	if (rv > MAXRADIUSVELOCITY)
		radiusVelocity = MAXRADIUSVELOCITY;
	else if (rv < -MAXRADIUSVELOCITY)
		radiusVelocity = -MAXRADIUSVELOCITY;
	else
		radiusVelocity = rv;
}

// return x velocity
double HoleVelocity::getXVelocity()
{
	return xVelocity;
}

// return y velocity
double HoleVelocity::getYVelocity()
{
	return yVelocity;
}

// return radius velocity
double HoleVelocity::getRadiusVelocity()
{
	return radiusVelocity;
}

void HoleVelocity::move(Hole* h)
{
	h->setX(h->getX() + xVelocity);
	h->setY(h->getY() + yVelocity);
	h->setRadius(h->getRadius() + radiusVelocity);
}

// print attributes of hole velocity
void HoleVelocity::print()
{
	printf("Hole velocity is (%.2f, %.2f) with radius velocity of %.3f\n",
		xVelocity, yVelocity, radiusVelocity);
}

// initialize a CellVelocity object
CellVelocity::CellVelocity()
{
    numHoleVelocities = 0;
    holeVelocityList = (HoleVelocity *) malloc(MAXHOLES * sizeof(HoleVelocity));
}

// return list of hole velocities
HoleVelocity * CellVelocity::getHoleVelocities()
{
    return holeVelocityList;
}

// return number of hole velocities
int CellVelocity::getNumHoleVelocities()
{
    return numHoleVelocities;
}

// add a hole velocity
void CellVelocity::addHoleVelocity(double xv, double yv, double rv)
{
    if (numHoleVelocities >= MAXHOLES)
    {
        throw invalid_argument("too many hole velocities");
    }
    holeVelocityList[numHoleVelocities] = HoleVelocity(xv,yv,rv);
    numHoleVelocities++;
}

// add a random hole velocity
// (true = random radius velocity, false = no radius velocity)
void CellVelocity::addRandomHoleVelocity(bool randomRadiusVelocity)
{
    if (numHoleVelocities >= MAXHOLES)
    {
        throw invalid_argument("too many holes");
    }
    holeVelocityList[numHoleVelocities] = HoleVelocity(randomRadiusVelocity);
    numHoleVelocities++;
}

// change a hole velocity
void CellVelocity::setHoleVelocity(HoleVelocity* hv, double xv, double yv, double rv)
{
    for (int i = 0; i < numHoleVelocities; i++)
    {
        if (holeVelocityList + i == hv)
        {
            // found hole velocity to change
            holeVelocityList[i].setXVelocity(xv);
            holeVelocityList[i].setYVelocity(yv);
            holeVelocityList[i].setRadiusVelocity(rv);
            return;
        }
    }
    throw invalid_argument("hole velocity not found");
}

// delete hole velocity
void CellVelocity::deleteHoleVelocity(HoleVelocity* hv)
{
    for (int i = 0; i < numHoleVelocities; i++)
    {
        if (holeVelocityList + i == hv)
        {
            // found hole velocity to delete
            holeVelocityList[i] = holeVelocityList[numHoleVelocities - 1]; // replace with last hole velocity
            numHoleVelocities--;
            return;
        }
    }
    throw invalid_argument("hole velocity not found");
}

// move a cell according to velocity
void CellVelocity::move(Cell* c)
{
	if (c->getNumHoles() != numHoleVelocities)
	{
		throw invalid_argument("incorrect number of holes");
	}
	Hole* hl = c->getHoles();
	for (int i = 0; i < numHoleVelocities; i++)
	{
		holeVelocityList[i].move(hl + i);
	}
}

// print attributes of all hole velocities in cell
void CellVelocity::print()
{
    printf("There are %d hole velocities in the cell velocity:\n", numHoleVelocities);
    for (int i = 0; i < numHoleVelocities; i++)
    {
        holeVelocityList[i].print();
    }
}
