// ParticleSimulation.h

#pragma once

#include <glad/glad.h>

#include <memory>
#include <vector>
#include "Particle.h"
#include "Common_utils.h"


static const float brush_size = 5;
static const float radius_brush = brush_size / 2;

class Quad;

class ParticleSimulation {
public:
    ParticleSimulation(int width, int height, int wWidth, int wHeight);
    ~ParticleSimulation();


    void update(); // Actualiza el estado de la simulación
    void setParticle(uint32_t x, uint32_t y); // Coloca una partícula en la posición (x, y)
    bool isParticle(uint32_t x, uint32_t y) const; // Verifica si hay una partícula en la posición (x, y)
    bool isInside(uint32_t x, uint32_t y) const;
    int getWidth() const; // Obtiene el ancho de la simulación
    int getHeight() const; // Obtiene la altura de la simulación
    void setMaterial(material mat); //change the material to be used

    void render();



private:
    material type_particle = sand;

    int wWidth;
    int wHeight;
    int width;
    int height;

    Particle* chunk_state;
    bool* has_been_updated;
    GLuint textureID; // ID de la textura
    std::unique_ptr<Quad> quad;
    std::vector<unsigned char> textureData; // Datos de textura RGBA

    void initializeTexture();
    void updateTexture();

    bool isEmpty(uint32_t x, uint32_t y);

    void updateTemporalParticle(position next_pos, position last_pos, const Particle& particle);

    bool isGas(uint32_t x, uint32_t y);

    void updateParticle(position next_pos, position last_pos, const Particle& particle);

    void pushOtherParticle(position pos);

    void updateWater(uint32_t x, uint32_t y);

    void updateGas(uint32_t x, uint32_t y);

    void updateSand(uint32_t x, uint32_t y);
    
    inline bool goDown(uint32_t x, uint32_t y, const Particle& particle, uint32_t speed);

    inline bool goDownRight(uint32_t x, uint32_t y, const Particle& particle, uint32_t speed);
    
    inline bool goDownLeft(uint32_t x, uint32_t y, const Particle& particle, uint32_t speed);

    inline bool goDownDensity(uint32_t x, uint32_t y, const Particle& particle, uint32_t speed);

    inline bool goSides(uint32_t x, uint32_t y, const Particle& particle, uint32_t speed);

    inline uint32_t computeIndex(const uint32_t& x, const uint32_t& y) const;
    
    inline uint32_t computeIndex(const uint32_t &&x, const uint32_t &&y) const;
};

