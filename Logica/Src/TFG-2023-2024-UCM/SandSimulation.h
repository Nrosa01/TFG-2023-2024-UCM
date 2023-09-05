#pragma once

#include <glad/glad.h>
#include <GLFW/glfw3.h>

class SandSimulation {
public:
    SandSimulation(int width, int height);
    ~SandSimulation();

    void update(); // Actualiza el estado de la simulaci�n
    void setParticle(int x, int y); // Coloca una part�cula en la posici�n (x, y)
    bool isParticle(int x, int y) const; // Verifica si hay una part�cula en la posici�n (x, y)
    bool isInside(int x, int y) const;
    int getWidth() const; // Obtiene el ancho de la simulaci�n
    int getHeight() const; // Obtiene la altura de la simulaci�n

    void render();

private:
    int width;
    int height;
    bool** currentFrame; // Estado actual
    bool** nextFrame; // Estado siguiente
    GLuint VAO;
    GLuint VBO;
    GLuint shaderProgram;

    void initializeBuffers();
    void createShaderProgram();
};