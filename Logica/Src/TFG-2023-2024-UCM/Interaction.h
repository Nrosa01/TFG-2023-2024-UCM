#pragma once
#include "TypedefInteractionFunction.h"
#include "TypedefInteractionCondition.h"

struct Interaction
{
	// Function that takes a uint32_t posX, uint32_t posY, uint32_t movement_pass and Particle** and returns a bool
	InteractionCondition interaction_condition;
	InteractionFunction interaction_function;
};