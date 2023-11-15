#include "InteractionDefinition.h"

Interaction InteractionDefinition::BuildFromDefinition(const InteractionDefinition& definition)
{
	
	// WHY THIS NOT COMPILE :(
	const InteractionMap& map = ParticleDefinitionsHandler::getInstance().getInteractionMap();

	return Interaction(map.get_function(definition.interaction));
}
