#include "ParticleDataManager.h"
#include <assert.h>

bool ParticleDataManager::Init()
{
    assert(instance == nullptr);
    instance = new ParticleDataManager();

    if (instance ->privateInit())
        return true;

    delete instance;
    instance = nullptr;

    return false;
}

void ParticleDataManager::Release()
{
}

ParticleDataManager* ParticleDataManager::Instance()
{
    return instance;
}

bool ParticleDataManager::privateInit()
{
    return true;
}

inline const ParticleData& ParticleDataManager::getParticleData(int index) noexcept
{
    // TODO: Make sure we correctly handle stuff here. This function should not raise exception for performance reasons
    // User should provide a correct index
    return particle_data[index];
}

inline void ParticleDataManager::addParticleData(const ParticleData data)
{
    particle_data.push_back(data);
    // instance->particle_data_size++;
}

inline ParticleDataManager::ParticleDataManager() {}

inline ParticleDataManager::~ParticleDataManager() {}
