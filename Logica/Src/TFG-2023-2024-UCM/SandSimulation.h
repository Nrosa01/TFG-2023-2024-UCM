// SandSimulation.h

#pragma once

#include <glad/glad.h>

#include <memory>
#include <vector>
#include "Particle.h"


class Quad;

class SandSimulation {
public:
    SandSimulation(int width, int height, int wWidth, int wHeight);
    ~SandSimulation();


    void update(); // Actualiza el estado de la simulaci�n
    void setParticle(int x, int y); // Coloca una part�cula en la posici�n (x, y)
    bool isParticle(int x, int y) const; // Verifica si hay una part�cula en la posici�n (x, y)
    bool isInside(int x, int y) const;
    int getWidth() const; // Obtiene el ancho de la simulaci�n
    int getHeight() const; // Obtiene la altura de la simulaci�n

    void render();



private:
    int wWidth;
    int wHeight;
    int width;
    int height;

    Particle** chunk_state;
    GLuint textureID; // ID de la textura
    std::unique_ptr<Quad> quad;
    std::vector<unsigned char> textureData; // Datos de textura RGBA

    void initializeTexture();
    void updateTexture();

    bool isEmpty(uint32_t x, uint32_t y);

    void updateParticle(position lastPos, position nextPos);

    void updateSand(uint32_t x, uint32_t y);
};

