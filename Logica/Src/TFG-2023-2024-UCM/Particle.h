#pragma once
#include <cstdint>
#include <unordered_map>
#include <string>
#include "Common_utils.h"
#include <vector>
#include <vec2.hpp>

enum Direction { UP, DOWN, LEFT, RIGHT, UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT};

struct PhysicsProperties {
	int density;
	int color;
	int flammability;
	int explosiveness;
	int boilingPoint;
	int startingTemperature;
	int fallSpeed;
	int spreadSpeed;
};

struct ParticleData
{
	std::string text_id; // We might want to change this to char text_id[16] for performance reasons
	uint8_t id; // We are not using 256 particles right?
	ParticleProject::colour_t particle_color; // Should this be a physics property?
	std::vector<ParticleProject::Vector2D> movement_passes; // We could just use Direction2D*, a vector has many stuff we don't really want that might be slow
	PhysicsProperties physics_properties;
};

struct Particle {
	// Type is an integer that index the ParticleData structure array
	uint32_t type;
	
	int temperature;
	bool is_stagnant = false;
	
	// Instead of using an external boolean array, we can just use a counter to check against that changes with each iteration
	// This counter can be used to track update of particle groups
	uint8_t clock;
	uint32_t life_time = 0;
};

// This should be a singleton, I think. Kinda ugly but should work for testing
class ParticleDataManager
{
public:
	inline static const ParticleData& getParticleData(int index) noexcept
	{
		// TODO: Make sure we correctly handle stuff here. This function should not raise exception for performance reasons
		// User should provide a correct index
		return particle_data[index];
	};

	inline static void addParticleData(const ParticleData data)
	{
		particle_data.push_back(data);
		particle_data_size++;
	};
private:
	static std::vector<const ParticleData> particle_data;
	static uint16_t particle_data_size; // This will be useful in the future
};





