#pragma once
#include <vector>
#include "Particle.h"
#include <unordered_map>
#include "ParticleData.h"

struct PhysicsProperties {
	const int density;
	const int color;
	const int flammability;
	const int explosiveness;
	const int boilingPoint;
	const int startingTemperature;
};

class ParticleRegistry {
public:
	static ParticleRegistry& getInstance() {
		static ParticleRegistry instance;
		return instance;
	}

	void addParticleData(const ParticleData& data)
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

	const ParticleData& getParticleData(const uint32_t& index) const {
// We want performance, and this should never happen in the system, so we only test this in debug
#ifdef _DEBUG
		if (index >= particle_data.size()) {
			throw std::exception("Index was out of range on getParticleData");
		}
#endif
		return particle_data[index];
	}

	const std::vector<ParticleData>& getParticleDataVector() const
	{
		return particle_data;
	}

private:
	ParticleRegistry() {}
	ParticleRegistry(const ParticleRegistry&) = delete;
	ParticleRegistry& operator=(const ParticleRegistry&) = delete;

	std::vector<ParticleData> particle_data;
	std::unordered_map < std::string, uint32_t> text_to_id_map;
};