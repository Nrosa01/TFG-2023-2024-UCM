#pragma once
#include <cstdint>
#include <iterator>

struct Particle;
struct ParticleDefinitionsHandler;

class ParticleChunkIterator : public std::iterator<std::forward_iterator_tag, Particle>
{
private:
    Particle** current;
    Particle** end;

public:
    ParticleChunkIterator(Particle** start, Particle** stop) : current(start), end(stop) {}

    ParticleChunkIterator& operator++()
    {
        ++current;
        return *this;
    }

    ParticleChunkIterator operator++(int)
    {
        ParticleChunkIterator tmp = *this;
        ++(*this);
        return tmp;
    }

    bool operator==(const ParticleChunkIterator& other) const
    {
        return current == other.current;
    }

    bool operator!=(const ParticleChunkIterator& other) const
    {
        return !(*this == other);
    }

    Particle& operator*() const
    {
        return **current;
    }
};


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
	inline const int getWidth() const; // Obtiene el ancho de la simulaci�n
	inline const int getHeight() const; // Obtiene la altura de la simulaci�n
	inline const Particle& getParticle(int x, int y) const;

	// Const methods
	inline const bool isInside(uint32_t x, uint32_t y) const;
	inline const bool isEmpty(const uint32_t& x, const uint32_t& y) const;
	inline const bool canPush(const uint32_t& other_x, const uint32_t& other_y, const uint32_t& x, const uint32_t& y) const;
	inline const int getParticleType(const uint32_t& x, const uint32_t& y) const;

	// Side effects methods
	void update(); // Actualiza el estado de la simulaci�n

	inline void setParticle(uint32_t x, uint32_t y, const Particle& particle); // Coloca una part�cula en la posici�n (x, y)
	inline bool tryPushParticle(const uint32_t& x, const uint32_t& y, const int& dir_x, const int& dir_y);
	inline const bool moveParticle(const uint32_t& x, const uint32_t& y, const int& dir_x, const int& dir_y);

    // Iterator

    ParticleChunkIterator begin() const
    {
        return ParticleChunkIterator(chunk_state, chunk_state + width * height);
    }

    ParticleChunkIterator end() const
    {
        return ParticleChunkIterator(chunk_state + width * height, chunk_state + width * height);
    }
};