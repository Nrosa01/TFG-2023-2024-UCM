// ParticleSimulation.h

#pragma once

#include <glad/glad.h>

#include <memory>
#include <vector>
#include "Particle.h"
#include "Common_utils.h"
#include "ParticleDataRegistry.h"

class Quad;
class ParticleChunk;

class ParticleSimulation {
public:
    ParticleSimulation(int width, int height, int wWidth, int wHeight);
    ~ParticleSimulation();

    void update(); // Actualiza el estado de la simulaci�n
    void setParticle(uint32_t x, uint32_t y); // Coloca una part�cula en la posici�n (x, y)
    void setMaterial(int mat); //change the material to be used

    void render();
private:
    ParticleChunk* chunk;

    int type_particle = 0;

    float brush_size;
    float radius_brush;

    int wWidth;
    int wHeight;

    GLuint textureID; // ID de la textura
    std::unique_ptr<Quad> quad;
    std::vector<unsigned char> textureData; // Datos de textura RGBA

    void initializeTexture();
    void updateTexture();

    inline ParticleProject::colour_t addGranularity(const ParticleProject::colour_t& original, const uint8_t granularity) {

        ParticleProject::colour_t result;
        result.r = std::min(original.r + granularity, 255);
        result.g = std::min(original.g + granularity, 255);
        result.b = std::min(original.b + granularity, 255);
        result.a = original.a;

        return result;
    }
};

