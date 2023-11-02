#pragma once
#include <vector>
#include "Particle.h"

class ParticleRegistry {
public:
	static ParticleRegistry& getInstance() {
		static ParticleRegistry instance;
		return instance;
	}

	void addParticleData(const ParticleData& data) {
		particle_data.push_back(data);
	}

	ParticleData& getParticleData(const uint32_t& index) {
// We want performance, and this should never happen in the system, so we only test this in debug
#ifdef _DEBUG
		if (index >= particle_data.size()) {
			throw std::exception("Index was out of range on getParticleData");
		}
#endif
		return particle_data[index];
	}

private:
	ParticleRegistry() {}
	ParticleRegistry(const ParticleRegistry&) = delete;
	ParticleRegistry& operator=(const ParticleRegistry&) = delete;

	std::vector<ParticleData> particle_data;
};