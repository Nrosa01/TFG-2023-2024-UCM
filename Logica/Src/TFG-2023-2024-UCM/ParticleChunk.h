#pragma once
#include <cstdint>
#include <iterator>
#include "ParticleDataRegistry.h"

struct Particle;
struct ParticleDefinitionsHandler;

class ParticleChunk
{
public:
    struct ParticleChunkIterator
    {
        using iterator_category = std::forward_iterator_tag;
        using difference_type = std::ptrdiff_t;
        using value_type = Particle;
        using pointer = Particle*;
        using data = Particle**;
        using reference = Particle&;

    private:
        data collection;
        pointer m_ptr;
        int m_width;
        int m_currentX;
        int m_currentY;

    public:
        ParticleChunkIterator(data collection, int width) : 
            m_ptr(&collection[0][0]), 
            collection(collection), 
            m_width(width), 
            m_currentX(0), 
            m_currentY(0) { }

        reference operator*() const { return *m_ptr; }

        pointer operator->() const { return m_ptr; }

        ParticleChunkIterator& operator++()
        {
            ++m_currentX;

            if (m_currentX >= m_width)
            {
                m_currentX = 0;
                ++m_currentY;
            }

            m_ptr = &collection[m_currentX][m_currentY];

            return *this;
        }

        ParticleChunkIterator operator++(int)
        {
            ParticleChunkIterator tmp = *this;
            ++(*this);
            return tmp;
        }

        friend bool operator== (const ParticleChunkIterator& a, const ParticleChunkIterator& b)
        {
            return a.m_ptr == b.m_ptr;
        };

        friend bool operator!= (const ParticleChunkIterator& a, const ParticleChunkIterator& b)
        {
            return a.m_ptr != b.m_ptr;
        };
    };


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
	inline const Particle& getParticle(int x, int y) const;

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

    // Iterator

    ParticleChunkIterator begin() const
    {
        return ParticleChunkIterator(chunk_state, width);
    }

    ParticleChunkIterator end() const
    {
        return ParticleChunkIterator(chunk_state + width * height, width);
    }
};