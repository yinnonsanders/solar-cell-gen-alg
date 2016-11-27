//
// Yinnon Sanders      25 November 2016
//

#include "Velocity.h"
#include <cstdlib>
#include <pthread.h>
using namespace std;

/* 	for each particle i = 1, ..., S do
 *   	Initialize the particle's position
 *		Initialize the particle's velocity: vi ~ U(-|bup-blo|, |bup-blo|)
 *  	Initialize the particle's best known position to its initial position: pi ← xi
 *  	if f(pi) < f(g) then
 *      	update the swarm's best known  position: g ← pi
 *	while a termination criterion is not met do:
 *  	for each particle i = 1, ..., S do
 *        	Pick random numbers: rp, rg ~ U(0,1)
 *        	Update the particle's velocity: vi,d ← ω vi,d + φp rp (pi,d-xi,d) + φg rg (gd-xi,d)
 *			Update the particle's position: xi ← xi + vi
 *			if f(xi) < f(pi) then
 *           	Update the particle's best known position: pi ← xi
 *           	if f(pi) < f(g) then
 *              	Update the swarm's best known position: g ← pi
 * */

#define NUMPARTICLES 11
#define HOLESPERCELL 10
#define RANDOMRADIUS true
#define OMEGA 0.9
#define THETAPARTICLE 0.1
#define THETASWARM 0.1

Cell particles[NUMPARTICLES];
CellVelocity velocities[NUMPARTICLES];
Cell* bestSwarmPosition = NULL;
double bestSwarmAvgAbsorption = 0.0;
Cell* bestParticlePositions[NUMPARTICLES];
double bestParticleAvgAbsorptions[NUMPARTICLES];

void *computeAvgAbsorption(void* ptr)
{
	Cell* cellPtr = (Cell*) ptr;
	cellPtr->getAvgAbsorption();
	pthread_exit(NULL);
}

void updateVelocity(int i)
{
	Cell* c = &particles[i];
	CellVelocity* cv = &velocities[i];
	CellVelocity bestParticleDirection = findDirection(c, bestParticlePositions[i]);
	CellVelocity bestSwarmDirection = findDirection(c, bestSwarmPosition);
	cv->multiplyByScalar(OMEGA);
	cv->addOtherVelocity(bestParticleDirection.multiplyByScalar(THETAPARTICLE));
	cv->addOtherVelocity(bestSwarmDirection.multiplyByScalar(THETASWARM));
}

void findBestPositions()
{
	for (int i = 0; i < NUMPARTICLES; i++)
	{
		if (particles[i].getAvgAbsorption() > bestParticleAvgAbsorptions[i])
		{
			bestParticleAvgAbsorptions[i] = particles[i].getAvgAbsorption();
			bestParticlePositions[i] = &particles[i];
			if(particles[i].getAvgAbsorption() > bestSwarmAvgAbsorption)
			{
				bestSwarmAvgAbsorption = particles[i].getAvgAbsorption();
				bestSwarmPosition = &particles[i];
			}
		}
	}
}

int main()
{
	pthread_t threads[NUMPARTICLES];

	// initialize a cell with random holes
	Cell initialCell;
	for (int i = 0; i < HOLESPERCELL; i++)
	{
		initialCell.addRandomHole(RANDOMRADIUS);
	}

	// create initial velocities and particles
	for (int i = 0; i < NUMPARTICLES; i++)
	{
		for (int j = 0; j < HOLESPERCELL; j++)
		{
			velocities[i].addRandomHoleVelocity(RANDOMRADIUS);
		}
		particles[i] = initialCell;
		velocities[i].move(&particles[i]);
	}
	
	// compute average absorptions
	for (int i = 0; i < NUMPARTICLES; i++)
	{
		pthread_create(&threads[i], NULL, computeAvgAbsorption, (void*) (&particles[i]));
	}

	for (int i = 0; i < NUMPARTICLES; i++)
	{
		pthread_join(threads[i], NULL);
	}

	// find each particle's and overall swarm's best position
	findBestPositions();

	printf("Best Position = %.2f\n", bestSwarmAvgAbsorption);

	while(TBD)
	{
		// update each particle's velocity and position
		for (int i = 0; i < NUMPARTICLES; i++)
		{
			updateVelocity(i);
			velocities[i].move(&particles[i]);
		}

		// compute average absorptions
		for (int i = 0; i < NUMPARTICLES; i++)
		{
			pthread_create(&threads[i], NULL, computeAvgAbsorption, (void*) (&particles[i]));
		}

		for (int i = 0; i < NUMPARTICLES; i++)
		{
			pthread_join(threads[i], NULL);
		}

		// find each particle's and overall swarm's best position
		findBestPositions();
	}
}
