#pragma once
#include <cstdint>
#include "Common_utils.h"	

enum Direction { UP, DOWN, LEFT, RIGHT, UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT};

struct Particle {
	// Type is an integer that index the ParticleData structure array
	uint32_t type = 0;
	
	int temperature;
	// bool is_stagnant = false;
	
	// Instead of using an external boolean array, we can just use a counter to check against that changes with each iteration
	// This counter can be used to track update of particle groups
	bool clock = false;
	uint32_t life_time = 0;
};




