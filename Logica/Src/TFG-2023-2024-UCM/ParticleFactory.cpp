#include "ParticleFactory.h"

Particle ParticleFactory::createSandParticle()
{
    Particle particle = Particle();
    particle.mat = sand;
    particle.speed = 1;
    return particle;
}

Particle ParticleFactory::createGasParticle()
{
    Particle particle = Particle();
    particle.mat = gas;
    // We might need to do something about this
    particle.life_time = Particle::gas_life_time;
    particle.speed = 3;
    return particle;
}

Particle ParticleFactory::createWaterParticle()
{
    Particle particle = Particle();
    particle.mat = water;
    particle.speed = 5;
    return particle;
}

Particle ParticleFactory::createRockParticle()
{
    Particle particle = Particle();
    particle.mat = rock;
    return particle;
}

Particle ParticleFactory::createEmptyParticle()
{
    return Particle();
}
