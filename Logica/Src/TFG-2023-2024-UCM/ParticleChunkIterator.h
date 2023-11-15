#pragma once
#include <iterator>
#include "Particle.h"

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