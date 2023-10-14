#include "Particle.h"
#include <unordered_map>

std::unordered_map<material, physics_data> Particle::materialPhysics;

void Particle::initializeMaterialPhysics()
{
	materialPhysics[sand] = { 3, 1, 3 };
	materialPhysics[gas] = { 0, 3, 4 };
	materialPhysics[water] = { 1, 3, 4 };
	materialPhysics[rock] = { 3, 0, 0 };
}
