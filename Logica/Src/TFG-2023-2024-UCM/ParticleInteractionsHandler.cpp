#include "ParticleInteractionsHandler.h"
#include "ParticleSimulation.h"
#include <tuple>
#include "typedef_interaction.h"

std::vector<Interaction> ParticleInteractionsHandler::getInteractions(std::vector<std::string> &interaction_names)
{

	std::vector<Interaction> interactions;
	for (auto &name : interaction_names)
		interactions.push_back(interaction_map[name]);

	return interactions;
}

void ParticleInteractionsHandler::addInteractionToMap(const std::string name, Interaction interaction)
{
	interaction_map.insert(std::make_pair(name, interaction));
}

void ParticleInteractionsHandler::addInteractionsToMap(std::vector<std::pair<std::string, Interaction>> inter_map)
{
	for (auto &pair : inter_map)
		addInteractionToMap(pair.first, pair.second);
}

void ParticleInteractionsHandler::addInteractionToParticle(const std::string src, const std::string interaction, const std::vector<std::string> *dst = nullptr)
{
	if (dst != nullptr)
	{
	}
	data_registry.addInteractionToParticle(src, interaction_map[interaction]);
}
void ParticleInteractionsHandler::addInteractionsToParticle(std::vector<std::tuple<std::string, std::string, std::vector<std::string>>> interactions_info) // std::vector<std::pair<std::string, Interaction>> inter_map, const std::vector<std::string>* dst)
{
	for (auto &interaction : interactions_info)
		addInteractionToParticle(std::get<0>(interaction), std::get<1>(interaction), &std::get<2>(interaction));
}
