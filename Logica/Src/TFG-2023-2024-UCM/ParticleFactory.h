#pragma once
#include "Particle.h"
#include <random>

class ParticleFactory
{
public:
	static inline Particle createParticle(uint32_t particle_type = 0) {
		Particle particle = Particle();
		particle.type = particle_type;

		// We should also init here lifetime, temperature and whateve more data the particle have but for testing basic stuff now 
		// we I don't need that
		
		//particle.temperature = 0;
		//particle.life_time = 0;
		//magic number, ik
		particle.random_granularity =
			rand() % (ParticleDefinitionsHandler::getInstance().getParticleData(particle_type).random_granularity + 1);
		
		return particle;
	};
};

