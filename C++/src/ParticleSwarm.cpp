//
// Yinnon Sanders      25 November 2016
//

#include "Velocity.h"
#include <cstdlib>
#include <pthread.h>
#include <random>
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
#define HOLESPERCELL 40
#define RANDOMRADIUS true
#define OMEGA .5
#define THETAPARTICLE 2.8
#define THETASWARM 1.3

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
	random_device rd;
    mt19937 gen(rd());
	uniform_real_distribution<double> unif(0, 1);
	Cell* c = &particles[i];
	CellVelocity* cv = &velocities[i];
	CellVelocity bestParticleDirection = CellVelocity::findDirection(c, bestParticlePositions[i]);
	bestParticleDirection.multiplyByScalar(THETAPARTICLE * unif(gen));
	CellVelocity bestSwarmDirection = CellVelocity::findDirection(c, bestSwarmPosition);
	bestSwarmDirection.multiplyByScalar(THETASWARM * unif(gen));
	cv->multiplyByScalar(OMEGA + unif(gen) / 2);
	cv->addOtherVelocity(&bestParticleDirection);
	cv->addOtherVelocity(&bestSwarmDirection);
}

void findBestPositions()
{
	for (int i = 0; i < NUMPARTICLES; i++)
	{
		printf("Particle %d has an average absorption of %.10f\n", i, particles[i].getAvgAbsorption());
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
	printf("Best average absorption so far is %.10f\n", bestSwarmAvgAbsorption);
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

	printf("Initial cell created.\n");
	initialCell.print();
	printf("Creating particles...\n");

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
	
	printf("Computing absorptions...\n");

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

	while(bestSwarmAvgAbsorption < .00005)
	{
		printf("Updating velocities and positions...\n");

		// update each particle's velocity and position
		for (int i = 0; i < NUMPARTICLES; i++)
		{
			updateVelocity(i);
			velocities[i].move(&particles[i]);
		}

		printf("Computing absorptions...\n");

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

	printf("Cell optimization complete.\n");
	bestSwarmPosition->print();
}
