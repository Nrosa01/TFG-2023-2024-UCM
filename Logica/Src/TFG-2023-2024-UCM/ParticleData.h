#pragma once
#include <string>
#include <vector>
#include "Colour.h"
#include "Vector2D.h"

// Keep fields non mutable even if they are not const	
struct ParticleData
{
	std::string text_id; // We might want to change this to char text_id[16] for performance reasons
	ParticleProject::colour_t particle_color; // Should this be a physics property?
	std::vector<ParticleProject::Vector2D> movement_passes; // We could just use Direction2D*, a vector has many stuff we don't really want that might be slow
	// PhysicsProperties physics_properties;
};