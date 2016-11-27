//
// Yinnon Sanders      25 November 2016
//

#include "Velocity.h"
using namespace std;

int main()
{
	CellVelocity cv1;
	cv1.addRandomHoleVelocity(true);
	cv1.addRandomHoleVelocity(false);
	HoleVelocity * hvList = cv1.getHoleVelocities();
	HoleVelocity * hvPointer1 = hvList;
	hvPointer1->print();
	cv1.deleteHoleVelocity(hvPointer1);
	cv1.print();
}
