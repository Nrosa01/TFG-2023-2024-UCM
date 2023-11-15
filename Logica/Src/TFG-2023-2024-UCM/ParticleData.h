#pragma once
#include <string>
#include <vector>
#include "Colour.h"
#include "Vector2D.h"
#include <functional>
#include "typedef_interaction.h"
//using Interaction = ParticleSimulation::std::function<bool(uint32_t, uint32_t)>*;


struct PhysicsProperties {
	int density{};
	int color{};
	int flammability{};
	int explosiveness{};
	int boilingPoint{};
	int startingTemperature{};
};

// Keep fields non mutable even if they are not const	
struct ParticleData
{
	//it makes sense that different materials have different levels of granularity, maybe
	//we can group the colour and this in a structure so the visuals are in a single member, idk

	std::string text_id; // We might want to change this to char text_id[16] for performance reasons
	
	ParticleProject::colour_t particle_color; // Should this be a physics property?
	int random_granularity = 0;

	std::vector<ParticleProject::Vector2D> movement_passes; // We could just use Direction2D*, a vector has many stuff we don't really want that might be slow
	PhysicsProperties physics_properties;
	
	std::vector<Interaction> interactions;

};