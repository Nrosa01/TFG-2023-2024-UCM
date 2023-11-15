#include "ParticleChunkIterator.h"

inline ParticleChunkIterator& ParticleChunkIterator::operator++()
{
	++current;
	return *this;
}

inline ParticleChunkIterator ParticleChunkIterator::operator++(int)
{
	ParticleChunkIterator tmp = *this;
	++(*this);
	return tmp;
}

inline bool ParticleChunkIterator::operator==(const ParticleChunkIterator& other) const
{
	return current == other.current;
}

inline bool ParticleChunkIterator::operator!=(const ParticleChunkIterator& other) const
{
	return !(*this == other);
}

inline Particle& ParticleChunkIterator::operator*() const
{
	return **current;
}
