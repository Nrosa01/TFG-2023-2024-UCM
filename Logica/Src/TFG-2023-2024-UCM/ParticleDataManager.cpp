#include "ParticleDataManager.h"

inline const ParticleData& ParticleDataManager::getParticleData(int index) noexcept
{
    // TODO: Make sure we correctly handle stuff here. This function should not raise exception for performance reasons
    // User should provide a correct index
    return instance->particle_data[index];
}

inline void ParticleDataManager::addParticleData(const ParticleData data)
{
    instance->particle_data.push_back(data);
    // instance->particle_data_size++;
}

inline ParticleDataManager::ParticleDataManager() {}

inline ParticleDataManager::~ParticleDataManager() {}
