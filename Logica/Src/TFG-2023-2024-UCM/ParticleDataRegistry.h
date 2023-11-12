#pragma once
#include <vector>
#include "Particle.h"
#include <unordered_map>
#include "ParticleData.h"
#include "TypedefInteractionFunction.h"

struct InteractionMap
{
	std::unordered_map<std::string, InteractionFunction> functions;


public:
	const InteractionFunction get_function(const std::string& key) const
	{
		// No checking, a particle can't define a function that doesn't exist by design
		return functions.at(key);
	}

	void add_function(const std::string& key, const InteractionFunction& function)
	{
		functions.insert({ key, function });
	}

};

class ParticleDefinitionsHandler {
public:
	static ParticleDefinitionsHandler& getInstance() {
		static ParticleDefinitionsHandler instance;
		return instance;
	}

	void addParticleData(const ParticleDefinition& data)
	{
		// Check if the text_id is already in the map
		// It's possible that a interaction was defined with a particle that doesn't exist
		// If the particle is registered, we overwrite it
		if (text_to_id_map.find(data.text_id) != text_to_id_map.end()) {
			const uint32_t index = text_to_id_map[data.text_id];

			// Given the ParticleData fields are constant, we can't assign them directly by doing
			// particle_data[index] = data (won't work)
			// So there are 2 options
			// 1- Making the fields non constant. GIven we always return a const reference in getParticleData, this 
			// won't really be a problem buuuuut... ParticleData fields should be inmutable by design, it makes no sense that those data can chance
			// 2- Removing the old data and inserting the new. This is way worse performance wise as is O(n), but this is a very specific situation that 
			// might be called only in 1 frame in the entire lifetime. ParticleData vector won't be higher than 256 elements so it won't really have a noticeable impact on the simulation
			//particle_data.erase(particle_data.begin() + index);
			//particle_data.insert(particle_data.begin() + index, data);

			// Finally, we chose the 1 option becaus we can't use the erase method, internally it calls the copy constructor which is undefined
			particle_data[index] = data;
			return;
		}

		particle_data.push_back(data);

		// Add the text_id to the map
		text_to_id_map.insert({ data.text_id, particle_data.size() - 1 });
	}

	// Returns -1 if the particle doesn't exist in the map
	// We could also use an uint32_t and return MAX_UINT_32 instead, we could use the max value as a null value
	// But for now we're keeping this
	const int32_t getParticleId(const std::string particle_text_id)
	{
		if (text_to_id_map.find(particle_text_id) == text_to_id_map.end()) {
			return -1;
		}

		return text_to_id_map[particle_text_id];
	}

	const int32_t getRegisteredParticlesCount() const
	{
		return particle_data.size();
	}

	const ParticleDefinition& getParticleData(const uint32_t& index) const {
		// We want performance, and this should never happen in the system, so we only test this in debug
#ifdef _DEBUG
		if (index >= particle_data.size()) {
			throw std::exception("Index was out of range on getParticleData");
		}
#endif
		return particle_data[index];
	}

	const std::vector<ParticleDefinition>& getParticleDataVector() const
	{
		return particle_data;
	}

	InteractionMap& getInteractionMap()
	{
		return interaction_map;
	}
private:
	ParticleDefinitionsHandler() {}
	ParticleDefinitionsHandler(const ParticleDefinitionsHandler&) = delete;
	ParticleDefinitionsHandler& operator=(const ParticleDefinitionsHandler&) = delete;

	std::vector<ParticleDefinition> particle_data;
	std::unordered_map < std::string, uint32_t> text_to_id_map;
	InteractionMap interaction_map;
	//std::unordered_map<std
};