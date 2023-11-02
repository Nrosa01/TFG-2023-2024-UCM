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

	void addParticleData(const ParticleData& data) {
		particle_data.push_back(data);
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