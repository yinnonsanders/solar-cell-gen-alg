//
// Yinnon Sanders      23 November 2016
//

#include "Hole.h"
using namespace std;

int main()
{
	// initialize a hole
	Hole hole1(4.0, 4.0, .100);
	hole1.displayAttributes();
	Hole hole2(5.0, 5.0);
	hole2.displayAttributes();
}
