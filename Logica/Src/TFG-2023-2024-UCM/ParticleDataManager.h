#pragma once
#include <vector>
#include "Particle.h"

 // This should be a singleton, I think. Kinda ugly but should work for testing
 class ParticleDataManager
 {
 public:
 	inline static const ParticleData& getParticleData(int index) noexcept;

 	inline static void addParticleData(const ParticleData data);
 private:
 	ParticleDataManager();
 	~ParticleDataManager();
 	static ParticleDataManager* instance;
 	std::vector<ParticleData> particle_data;
 	// uint16_t particle_data_size; // This will be useful in the future
 };
