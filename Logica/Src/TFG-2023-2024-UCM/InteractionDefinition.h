#pragma once
#include "ParticleDataRegistry.h"
#include "Interaction.h"
#include <string>
#include <vector>

struct InteractionDefinition
{
	std::string condition;
	std::string interaction;

	static Interaction BuildFromDefinition(const InteractionDefinition& definition);
	

	static std::vector<Interaction> BuildFromDefinitions(const std::vector<InteractionDefinition>& definitions)
	{
		std::vector<Interaction> interactions;
		for (const InteractionDefinition& definition : definitions)
			interactions.push_back(BuildFromDefinition(definition));

		return interactions;
	}
};
