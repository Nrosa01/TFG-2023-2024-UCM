#pragma once
#include "Particle.h"

// This is not a singleton because it's just a collection of methods
// that doesn't need to handle internal data

// This can't be inlined for some reason, so I'm not sure if the compiler will inline it.
// As this factory is simple this could also be done with macros but... I prefer to avoid macros for now
class ParticleFactory
{
public:
	static inline Particle createParticle(uint32_t particle_type) {
		Particle particle = Particle();
		particle.type = particle_type;

		// We should also init here lifetime, temperature and whateve more data the particle have but for testing basic stuff now 
		// we I don't need that

		return particle;
	};
};

