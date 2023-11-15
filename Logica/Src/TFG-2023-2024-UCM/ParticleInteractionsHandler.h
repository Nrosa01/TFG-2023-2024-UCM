#pragma once
#include <vector>
#include <string>
#include <unordered_map>
#include "Particle.h"
#include "ParticleData.h"
#include "ParticleDataRegistry.h"
class ParticleSimulation;

class ParticleInteractionsHandler
{
private:
	ParticleRegistry &data_registry;

	std::vector<std::vector<bool>> interactionMask;
	// {{"die" , function}, ...}
	std::unordered_map<std::string, Interaction> interaction_map;
	// {{ 3(gas), {function, function etc} } , }
	std::vector<std::pair<uint32_t, std::vector<Interaction>>> particle_interaction_map;

public:
	ParticleInteractionsHandler(ParticleRegistry &reg) : data_registry(reg) {}
	~ParticleInteractionsHandler() {}

	std::vector<Interaction> getInteractions(std::vector<std::string> &interaction_names);
	// just interaction adding
	void addInteractionToMap(const std::string name, Interaction interaction);
	void addInteractionsToMap(std::vector<std::pair<std::string, Interaction>> inter_map);

	void addInteractionToParticle(const std::string src, const std::string interaction, const std::vector<std::string> *dst);
	void addInteractionsToParticle(std::vector<std::tuple<std::string, std::string, std::vector<std::string>>> interactions_info);

	inline const std::vector<std::pair<uint32_t, std::vector<Interaction>>> getInteractionMap()
	{
		return particle_interaction_map;
	}
	inline const std::vector<Interaction> getParticleInteractions()
	{
	}
};
