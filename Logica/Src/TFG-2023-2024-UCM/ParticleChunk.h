#pragma once
#include <cstdint>
#include <iterator>
#include "ParticleDataRegistry.h"
#include <vector>

struct Particle;
struct ParticleDefinitionsHandler;

class ParticleChunk
{
public:
	// Constructor
	ParticleChunk(int width, int height);
	~ParticleChunk();

private:
	Particle** chunk_state;

	int width;
	int height;

	bool clock;

	inline void updateParticle(const uint32_t& x, const uint32_t& y, const  ParticleDefinitionsHandler& registry);
public:
	// Getteres
	const int getWidth() const; // Obtiene el ancho de la simulaci�n
	const int getHeight() const; // Obtiene la altura de la simulaci�n
	const Particle& getParticle(int x, int y) const;

	// Const methods
	inline const bool isInside(uint32_t x, uint32_t y) const;
	inline const bool isEmpty(const uint32_t& x, const uint32_t& y) const;
	inline const bool canPush(const uint32_t& other_x, const uint32_t& other_y, const uint32_t& x, const uint32_t& y) const;
	inline const int getParticleType(const uint32_t& x, const uint32_t& y) const;

	// Side effects methods
	void update(); // Actualiza el estado de la simulaci�n

	void setParticle(uint32_t x, uint32_t y, const Particle& particle); // Coloca una part�cula en la posici�n (x, y)
	inline bool tryPushParticle(const uint32_t& x, const uint32_t& y, const int& dir_x, const int& dir_y);
	inline const bool moveParticle(const uint32_t& x, const uint32_t& y, const int& dir_x, const int& dir_y);
};