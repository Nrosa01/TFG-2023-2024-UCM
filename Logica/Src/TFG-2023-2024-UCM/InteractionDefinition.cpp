#include "InteractionDefinition.h"

Interaction InteractionDefinition::BuildFromDefinition(const InteractionDefinition& definition)
{
	
	// WHY THIS NOT COMPILE :(
	const InteractionMap& map = ParticleDefinitionsHandler::getInstance().getInteractionMap();

	return Interaction(nullptr, nullptr);

	/*	map.get_function(definition.condition),
		map.get_function(definition.definition)*/

	
}
