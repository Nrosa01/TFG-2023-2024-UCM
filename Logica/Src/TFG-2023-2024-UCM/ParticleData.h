#pragma once
#include <string>
#include <vector>
#include "Colour.h"
#include "Vector2D.h"
#include <functional>

struct Properties {
	int density;
	int flammability;
	int explosiveness;
	int boilingPoint;
	int startingTemperature;
};

struct Interaction
{
	// Function that takes a uint32_t posX, uint32_t posY, uint32_t movement_pass and Particle** and returns a bool
	std::function<bool(uint32_t, uint32_t, uint32_t, Particle**)> interaction_function;
};

struct InteractionDefinition
{
	std::string definition;

	static Interaction BuildFromDefinition(const InteractionDefinition& definition)
	{
		return {}; // TODO
	}

	static std::vector<Interaction> BuildFromDefinitions(const std::vector<InteractionDefinition>& definitions)
	{
		std::vector<Interaction> interactions;
		for (const InteractionDefinition& definition : definitions)
			interactions.push_back(BuildFromDefinition(definition));

		return interactions;
	}
};


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