//
// Yinnon Sanders      25 November 2016
//

#include "Cell.h"
using namespace std;

int main()
{
	Cell cell1;
	cell1.addRandomHole(true);
	cell1.addRandomHole(false);
	Hole * holeList = cell1.getHoles();
	Hole* holePointer1 = holeList;
	holePointer1->print();
	cell1.deleteHole(holePointer1);
	cell1.print();
}
