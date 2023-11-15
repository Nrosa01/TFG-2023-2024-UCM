#pragma once
#include <iterator>

struct Particle;

class ParticleChunkIterator : public std::iterator<std::forward_iterator_tag, Particle>
{
private:
	Particle** current;
	Particle** end;

public:
	ParticleChunkIterator(Particle** start, Particle** stop) : current(start), end(stop) {}

	ParticleChunkIterator& operator++();

	ParticleChunkIterator operator++(int);

	bool operator==(const ParticleChunkIterator& other) const;

	bool operator!=(const ParticleChunkIterator& other) const;

	Particle& operator*() const;
};