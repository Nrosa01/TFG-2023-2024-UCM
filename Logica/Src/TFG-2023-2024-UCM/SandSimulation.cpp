#include "SandSimulation.h"
#include <vector>
#include <algorithm>
#include <glm.hpp>
#include <gtc/type_ptr.hpp>
#include <ext/matrix_clip_space.hpp>
#include "Quad.h"

SandSimulation::SandSimulation(int width, int height, int wWidth, int wHeight) : width(width), height(height), wWidth(wWidth), wHeight(wHeight) {
    currentFrame = new bool* [width];
    nextFrame = new bool* [width];

    for (int x = 0; x < width; ++x) {
        currentFrame[x] = new bool[height];
        nextFrame[x] = new bool[height];

        for (int y = 0; y < height; ++y) {
            currentFrame[x][y] = false;
            nextFrame[x][y] = currentFrame[x][y];
        }
    }

    textureData.resize(width * height * 4, 0);
    initializeTexture();
    quad = std::make_unique<Quad>(wWidth, wHeight, textureID);
}

SandSimulation::~SandSimulation() {
    for (int x = 0; x < width; ++x) {
        delete[] currentFrame[x];
        delete[] nextFrame[x];
    }
    delete[] currentFrame;
    delete[] nextFrame;
}

void SandSimulation::initializeTexture()
{
    glGenTextures(1, &textureID);
    glBindTexture(GL_TEXTURE_2D, textureID);

    // Define parámetros de la textura (puedes ajustarlos según tus necesidades)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

    // Define el tamaño y el formato de la textura (RGBA)
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, nullptr);

    // Establece los datos iniciales de la textura
    std::fill(textureData.begin(), textureData.end(), 0);

    glBindTexture(GL_TEXTURE_2D, 0);
}

void SandSimulation::updateTexture() {
    // Recorre los datos de la simulación y actualiza textureData según el estado actual
    for (int x = 0; x < width; ++x) {
        for (int y = 0; y < height; ++y) {
            if (currentFrame[x][y]) {
                // Si hay una partícula en esta posición, establece el color a amarillo (255, 255, 0, 255)
                textureData[(y * width + x) * 4 + 0] = 255; // R
                textureData[(y * width + x) * 4 + 1] = 255; // G
                textureData[(y * width + x) * 4 + 2] = 0;   // B
                textureData[(y * width + x) * 4 + 3] = 255; // A
            }
            else {
                // Si no hay partícula, establece el color a transparente (0, 0, 0, 0)
                textureData[(y * width + x) * 4 + 0] = 0;   // R
                textureData[(y * width + x) * 4 + 1] = 0;   // G
                textureData[(y * width + x) * 4 + 2] = 0;   // B
                textureData[(y * width + x) * 4 + 3] = 0;   // A
            }
        }
    }

    // Luego, actualiza la textura con los nuevos datos
    glBindTexture(GL_TEXTURE_2D, textureID);
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, textureData.data());
    glBindTexture(GL_TEXTURE_2D, 0);
}


void SandSimulation::update() {
    for (int x = 0; x < width; ++x) {
        for (int y = 0; y < height; ++y) { // Cambiar el bucle para ir de abajo hacia arriba
            if (currentFrame[x][y]) {
                // Si hay una partícula en esta posición, mueva hacia abajo si es posible
                if (y > 0 && !currentFrame[x][y - 1] && !nextFrame[x][y - 1]) {
                    nextFrame[x][y - 1] = true;
                    currentFrame[x][y] = false;
                }
                // Si no puede moverse hacia abajo, intente moverse hacia la izquierda
                else if (x > 0 && y > 0 && !currentFrame[x - 1][y - 1] && !nextFrame[x - 1][y - 1]) {
                    nextFrame[x - 1][y - 1] = true;
                    currentFrame[x][y] = false;
                }
                else if (x < width - 1 && y > 0 && !currentFrame[x + 1][y - 1] && !nextFrame[x + 1][y - 1]) {
                    // Si no puede moverse hacia abajo ni hacia la izquierda, intente moverse hacia la derecha
                    nextFrame[x + 1][y - 1] = true;
                    currentFrame[x][y] = false;
                }
                else
                    // Si no puede moverse, todo se mantiene igual
                    nextFrame[x][y] = currentFrame[x][y];
            }
        }
    }

    // Intercambia los frames actual y siguiente después de una actualización
    std::swap(currentFrame, nextFrame);
    updateTexture();
}

bool SandSimulation::isInside(int x, int y) const {
    return x >= 0 && x < width && y >= 0 && y < height;
}

void SandSimulation::setParticle(int x, int y) {
    // Convierte las coordenadas de pantalla a coordenadas de la simulación
    int simX = (x * width) / wWidth;
    int simY = height - (y * height) / wHeight - 1;

    if (isInside(simX, simY)) {
        currentFrame[simX][simY] = true;
    }
}

bool SandSimulation::isParticle(int x, int y) const {
    if (isInside(x, y)) {
        return currentFrame[x][y];
    }
    return false;
}

int SandSimulation::getWidth() const {
    return width;
}

int SandSimulation::getHeight() const {
    return height;
}

void SandSimulation::render() {
    quad->render();
}
