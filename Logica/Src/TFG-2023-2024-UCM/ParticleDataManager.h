#pragma once
#include <vector>
#include "Particle.h"

// This should be a singleton, I think. Kinda ugly but should work for testing
class ParticleDataManager
{
private:
	ParticleDataManager();
	~ParticleDataManager();
	bool privateInit();
	static ParticleDataManager* instance;

	std::vector<ParticleData> particle_data;
	// uint16_t particle_data_size; // This will be useful in the future
public:
	static bool Init();
	static void Release();
	static ParticleDataManager* Instance();
	
	inline const ParticleData& getParticleData(int index) noexcept;
	inline void addParticleData(const ParticleData data);
};
