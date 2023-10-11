// ParticleSimulation.h

#pragma once

#include <glad/glad.h>

#include <memory>
#include <vector>
#include "Particle.h"


//type of particle to be used
//this is just for testing, it will be removed in the future

static const float brush_size = 2;

class Quad;

class ParticleSimulation {
public:
    ParticleSimulation(int width, int height, int wWidth, int wHeight);
    ~ParticleSimulation();


    void update(); // Actualiza el estado de la simulación
    void setParticle(int x, int y); // Coloca una partícula en la posición (x, y)
    bool isParticle(int x, int y) const; // Verifica si hay una partícula en la posición (x, y)
    bool isInside(int x, int y) const;
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

    Particle** chunk_state;
    bool* has_been_updated;
    GLuint textureID; // ID de la textura
    std::unique_ptr<Quad> quad;
    std::vector<unsigned char> textureData; // Datos de textura RGBA

    void initializeTexture();
    void updateTexture();

    bool isEmpty(uint32_t x, uint32_t y);

    bool isGas(uint32_t x, uint32_t y);

    void updateParticle(position next_pos, position last_pos, const Particle& particle);

    void updateWater(uint32_t x, uint32_t y);

    void updateGas(uint32_t x, uint32_t y);

    void updateSand(uint32_t x, uint32_t y);

   

    
};

