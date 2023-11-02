#pragma once
#include <cstdint>
#include <unordered_map>
#include <string>
#include "Common_utils.h"
#include <vector>

enum Direction { UP, DOWN, LEFT, RIGHT, UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT};

enum material { empty, sand, gas, water, rock, acid };

struct PhysicsProperties {
	const int density;
	const int color;
	const int flammability;
	const int explosiveness;
	const int boilingPoint;
	const int startingTemperature;
};

struct ParticleData
{
	const std::string text_id; // We might want to change this to char text_id[16] for performance reasons
	const uint8_t id; // We are not using 256 particles right?
	const ParticleProject::colour_t particle_color; // Should this be a physics property?
	const std::vector<ParticleProject::Vector2D> movement_passes; // We could just use Direction2D*, a vector has many stuff we don't really want that might be slow
	// PhysicsProperties physics_properties;
};

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




