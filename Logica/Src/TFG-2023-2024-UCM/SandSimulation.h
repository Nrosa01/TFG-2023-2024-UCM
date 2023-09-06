// SandSimulation.h

#pragma once

#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <memory>
#include <vector>

class Quad;

class SandSimulation {
public:
    SandSimulation(int width, int height);
    ~SandSimulation();

    void update(); // Actualiza el estado de la simulación
    void setParticle(int x, int y); // Coloca una partícula en la posición (x, y)
    bool isParticle(int x, int y) const; // Verifica si hay una partícula en la posición (x, y)
    bool isInside(int x, int y) const;
    int getWidth() const; // Obtiene el ancho de la simulación
    int getHeight() const; // Obtiene la altura de la simulación

    void render();

private:
    int width;
    int height;
    bool** currentFrame; // Estado actual
    bool** nextFrame; // Estado siguiente
    GLuint textureID; // ID de la textura
    std::unique_ptr<Quad> quad;
    std::vector<unsigned char> textureData; // Datos de textura RGBA

    void initializeTexture();
    void updateTexture();
};

