// ParticleSimulation.h

#pragma once

#include <glad/glad.h>

#include <memory>
#include <vector>
#include "Particle.h"
#include "Common_utils.h"
#include "ParticleDataRegistry.h"

static const float brush_size = 5;
static const float radius_brush = brush_size / 2;

class Quad;

class ParticleSimulation {
public:
    ParticleSimulation(int width, int height, int wWidth, int wHeight);
    ~ParticleSimulation();


    void update(); // Actualiza el estado de la simulaci�n
    void setParticle(uint32_t x, uint32_t y); // Coloca una part�cula en la posici�n (x, y)
    const bool isParticle(uint32_t x, uint32_t y) const; // Verifica si hay una part�cula en la posici�n (x, y)
    const bool isInside(uint32_t x, uint32_t y) const;
    const int getWidth() const; // Obtiene el ancho de la simulaci�n
    const int getHeight() const; // Obtiene la altura de la simulaci�n
    void setMaterial(int mat); //change the material to be used

    void render();
private:
    int type_particle = 0;

    ParticleDataRegistry& registry;
    int wWidth;
    int wHeight;
    int width;
    int height;

    Particle** chunk_state;
    bool clock; // Add 1 in every update call, check against particle clock to see whether they have been updated or not
    GLuint textureID; // ID de la textura
    std::unique_ptr<Quad> quad;
    std::vector<unsigned char> textureData; // Datos de textura RGBA

    void initializeTexture();
    void updateTexture();

    const bool isEmpty(const uint32_t& x, const uint32_t& y) const;

    //inline void pushOtherParticle(uint32_t index);

    inline const bool moveParticle(const int& dir_x, const int& dir_y, const uint32_t& x, const uint32_t& y);

    inline void updateParticle(const uint32_t& x, const uint32_t& y);

    const inline ParticleDefinition& getParticleData(const uint32_t& x, const uint32_t& y) const;


    inline ParticleProject::colour_t addGranularity(const ParticleProject::colour_t& original, const uint8_t granularity) {

        ParticleProject::colour_t result;
        result.r = std::min(original.r + granularity, 255);
        result.g = std::min(original.g + granularity, 255);
        result.b = std::min(original.b + granularity, 255);
        result.a = original.a;

        return result;
    }
};

