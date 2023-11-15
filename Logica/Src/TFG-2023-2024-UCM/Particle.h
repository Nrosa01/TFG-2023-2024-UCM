#pragma once
#include <cstdint>
#include "Common_utils.h"	

struct Particle {
	Particle() : type(0), temperature(0), random_granularity(0), clock(false), life_time(0) {}

	// Type is an integer that index the ParticleData structure array
	uint32_t type;
	
	int temperature;
	// bool is_stagnant = false;
	uint8_t random_granularity;
	// Instead of using an external boolean array, we can just use a counter to check against that changes with each iteration
	// This counter can be used to track update of particle groups
	bool clock = false;
	uint32_t life_time;
};




