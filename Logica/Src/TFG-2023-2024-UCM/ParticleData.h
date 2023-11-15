#pragma once
#include <string>
#include <vector>
#include "Colour.h"
#include "Vector2D.h"
#include <functional>
#include "InteractionDefinition.h"
#include "Properties.h"
#include "Interaction.h"


// Keep fields non mutable even if they are not const	
struct ParticleDefinition
{
	std::string text_id; // We might want to change this to char text_id[16] for performance reasons
	ParticleProject::colour_t particle_color; // Should this be a physics property?
	std::vector<ParticleProject::Vector2D> movement_passes; // We could just use Direction2D*, a vector has many stuff we don't really want that might be slow
	Properties properties;
	std::vector<Interaction> interactions;

	ParticleDefinition(std::string text_id, ParticleProject::colour_t particle_color, std::vector<ParticleProject::Vector2D> movement_passes, Properties properties, std::vector<Interaction> interactions) :
		text_id(text_id),
		particle_color(particle_color),
		movement_passes(movement_passes),
		properties(properties),
		interactions(interactions)
	{

	}
};