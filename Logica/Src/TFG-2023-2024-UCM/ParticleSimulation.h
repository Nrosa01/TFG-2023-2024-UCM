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


    void update(); // Actualiza el estado de la simulaci�n
    void setParticle(uint32_t x, uint32_t y); // Coloca una part�cula en la posici�n (x, y)
    bool isParticle(uint32_t x, uint32_t y) const; // Verifica si hay una part�cula en la posici�n (x, y)
    bool isInside(uint32_t x, uint32_t y) const;
    int getWidth() const; // Obtiene el ancho de la simulaci�n
    int getHeight() const; // Obtiene la altura de la simulaci�n
    void setMaterial(material mat); //change the material to be used

    void render();



private:
    material type_particle = sand;

    int wWidth;
    int wHeight;
    int width;
    int height;

    Particle* chunk_state;
    uint8_t clock; // Add 1 in every update call, check against particle clock to see whether they have been updated or not
    GLuint textureID; // ID de la textura
    std::unique_ptr<Quad> quad;
    std::vector<unsigned char> textureData; // Datos de textura RGBA

    void initializeTexture();
    void updateTexture();

    bool isEmpty(uint32_t index);

    //inline void pushOtherParticle(uint32_t index);

    inline bool moveParticle(const int& dir_x, const int& dir_y, uint32_t x, uint32_t y, const Particle& particle);

    inline void updateParticle(uint32_t index);

    const inline ParticleData& getParticleData(uint32_t index) const;

    inline uint32_t computeIndex(const uint32_t& x, const uint32_t& y) const;
    
    inline uint32_t computeIndex(const uint32_t &&x, const uint32_t &&y) const;
};

