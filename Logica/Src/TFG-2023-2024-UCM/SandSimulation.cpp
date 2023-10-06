#include "SandSimulation.h"
#include <vector>
#include <algorithm>
#include <glm.hpp>
#include <gtc/type_ptr.hpp>
#include <ext/matrix_clip_space.hpp>
#include <GLFW/glfw3.h>
#include "Quad.h"

SandSimulation::SandSimulation(int width, int height, int wWidth, int wHeight) : width(width), height(height), wWidth(wWidth), wHeight(wHeight) {
  
    chunk_state = new Particle * [width];
    for (int x = 0; x < width; ++x) {
        chunk_state[x] = new Particle[height];

        for (int y = 0; y < height; ++y) {
            chunk_state[x][y].has_been_updated = false;
            chunk_state[x][y].mat = empty;
        
        }
    }

    textureData.resize(width * height * 4, 0);
    initializeTexture();
    quad = std::make_unique<Quad>(wWidth, wHeight, textureID);
}

SandSimulation::~SandSimulation() {
    for (int x = 0; x < width; ++x) {
        delete[] chunk_state[x];
   
    }
    delete[] chunk_state;
   
}

void SandSimulation::initializeTexture()
{
    glGenTextures(1, &textureID);
    glBindTexture(GL_TEXTURE_2D, textureID);

    // Define par�metros de la textura (puedes ajustarlos seg�n tus necesidades)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

    // Define el tama�o y el formato de la textura (RGBA)
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, nullptr);

    // Establece los datos iniciales de la textura
    std::fill(textureData.begin(), textureData.end(), 0);

    glBindTexture(GL_TEXTURE_2D, 0);
}

void SandSimulation::updateTexture() {
    // Recorre los datos de la simulaci�n y actualiza textureData seg�n el estado actual
    for (int x = 0; x < width; ++x) {
        for (int y = 0; y < height; ++y) {
          
            colour_t c {0,0,0,0};
            switch (chunk_state[x][y].mat)
            {
            case sand: {
                c = yellow;
            }
            default:
              
                break;
            }
            int pos_text = (y * width + x) * 4;
            textureData[pos_text + 0] = c.r;   // R
            textureData[pos_text + 1] = c.g;   // G
            textureData[pos_text + 2] = c.b;   // B
            textureData[pos_text + 3] = c.a;   // A
        }
    }

    // Luego, actualiza la textura con los nuevos datos
    glBindTexture(GL_TEXTURE_2D, textureID);
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, textureData.data());
    glBindTexture(GL_TEXTURE_2D, 0);
}


bool SandSimulation::isEmpty(uint32_t x, uint32_t y) {
    return  chunk_state[x][y].mat == empty;
}

void SandSimulation::updateParticle(position next_pos, position last_pos) {
    chunk_state[next_pos.x][next_pos.y].mat = sand;
    chunk_state[next_pos.x][next_pos.y].has_been_updated = true;
    chunk_state[last_pos.x][last_pos.y].mat = empty;
}

void SandSimulation::updateSand(uint32_t x, uint32_t y) {

    Particle p = chunk_state[x][y];

    //nada que comprobar, ya es suelo fijo;
    if (p.is_stagnant || p.has_been_updated) return;
    
    // Si hay una part�cula en esta posici�n, mueva hacia abajo si es posible
    if (y > 0 && isEmpty(x, y - 1))
        updateParticle({ x,y - 1 }, { x,y });

    // Si no puede moverse hacia abajo, intente moverse hacia la izquierda
    else if (x > 0 && y > 0 && isEmpty(x - 1, y - 1))
        updateParticle({ x - 1,y - 1 }, { x,y });

    else if (x < width - 1 && y > 0 && isEmpty(x + 1, y - 1))
        // Si no puede moverse hacia abajo ni hacia la izquierda, intente moverse hacia la derecha
        updateParticle({ x + 1 ,y - 1 }, { x,y });

    // en verdad esto es solo util ahora, cuando haya varios chunks y todo sea destruible no va a valer de nada
    // se�ala que un bloque de arena no se va a mover mas, ya que ya es base de otros bloques
     else p.is_stagnant = true;
}

void SandSimulation::update() {

    // se actualiza en orden de abajo a arriba
    for (uint32_t y = height - 1; y > 0; --y) {
        for (uint32_t x = 0; x < width; x++) {
            material mat = chunk_state[x][y].mat;
            if(chunk_state[x][y].mat == sand)
                updateSand(x, y);
           
        }
    }

    updateTexture();

    //se�alo otra vez todas las particulas como no modificadas
    for (int i = 0; i < height; i++)
        for (int j = 0; j < width; j++)
            chunk_state[i][j].has_been_updated = false;
}

bool SandSimulation::isInside(int x, int y) const {
    return x >= 0 && x < width && y >= 0 && y < height;
}

void SandSimulation::setParticle(int x, int y) {
    // Convierte las coordenadas de pantalla a coordenadas de la simulaci�n
    int simX = (x * width) / wWidth;
    int simY = height - (y * height) / wHeight - 1;

    if (isInside(simX, simY)) {
        chunk_state[simX][simY].mat = sand;
    }
}

bool SandSimulation::isParticle(int x, int y) const {
    if (isInside(x, y)) {
        return  chunk_state[x][y].mat == sand;
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
