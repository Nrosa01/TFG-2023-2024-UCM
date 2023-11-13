#pragma once
#include "TypedefInteractionFunction.h"

struct Interaction
{
	// Function that takes a uint32_t posX, uint32_t posY, uint32_t movement_pass and Particle** and returns a bool
	InteractionFunction interaction_function;

	Interaction(InteractionFunction interaction_function) :
		interaction_function(interaction_function)
	{

	}
};