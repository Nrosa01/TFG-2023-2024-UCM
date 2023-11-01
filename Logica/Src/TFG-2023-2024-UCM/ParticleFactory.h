#pragma once
#include "Particle.h"

// This is not a singleton because it's just a collection of methods
// that doesn't need to handle internal data

// This can't be inlined for some reason, so I'm not sure if the compiler will inline it.
// As this factory is simple this could also be done with macros but... I prefer to avoid macros for now
class ParticleFactory
{
public:
	static inline Particle createSandParticle() {
		Particle particle = Particle();
		particle.type = sand;
		return particle;
	};
	static inline Particle createGasParticle() {
		Particle particle = Particle();
		particle.type = gas;
		return particle;
	};
	static inline Particle createWaterParticle() {
		Particle particle = Particle();
		particle.type = water;
		return particle;
	};
	static inline Particle createRockParticle() {
		Particle particle = Particle();
		particle.type = rock;
		return particle;
	};
	static inline Particle createAcidParticle()
	{
		Particle particle = Particle();
		particle.type = acid;
		return particle;
	};
	static inline Particle createEmptyParticle() {
		return Particle();
	};
};

