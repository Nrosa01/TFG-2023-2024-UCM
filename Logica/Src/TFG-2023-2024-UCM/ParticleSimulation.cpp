#include "ParticleSimulation.h"
#include <vector>
#include <algorithm>
#include <glm.hpp>
#include <gtc/type_ptr.hpp>
#include <ext/matrix_clip_space.hpp>
#include <GLFW/glfw3.h>
#include "Quad.h"
#include <iostream>

ParticleSimulation::ParticleSimulation(int width, int height, int wWidth, int wHeight) : width(width), height(height), wWidth(wWidth), wHeight(wHeight) {
  
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

ParticleSimulation::~ParticleSimulation() {
    for (int x = 0; x < width; ++x) {
        delete[] chunk_state[x];
   
    }
    delete[] chunk_state;
   
}

void ParticleSimulation::initializeTexture()
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

void ParticleSimulation::updateTexture() {
    // Recorre los datos de la simulaci�n y actualiza textureData seg�n el estado actual
    for (int x = 0; x < width; ++x) {
        for (int y = 0; y < height; ++y) {
          
            colour_t c {0,0,0,0};
            switch (chunk_state[x][y].mat)
            {
            case sand: 
                c = yellow;
                break;
            case gas:
                c = grey;
                c.a = grey.a * chunk_state[x][y].frame_life / 300;
            	break;
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


bool ParticleSimulation::isEmpty(uint32_t x, uint32_t y) {
    return  chunk_state[x][y].mat == empty ;
}

void ParticleSimulation::updateParticle(position next_pos, position last_pos,const Particle& particle) {
    chunk_state[next_pos.x][next_pos.y].mat = particle.mat;
    chunk_state[next_pos.x][next_pos.y].frame_life = particle.frame_life;
    chunk_state[next_pos.x][next_pos.y].has_been_updated = true;
    chunk_state[last_pos.x][last_pos.y].mat = empty;
}


void ParticleSimulation::updateWater(uint32_t x, uint32_t y) {

}

void ParticleSimulation::updateGas(uint32_t x, uint32_t y) {
    Particle& p = chunk_state[x][y];
    
    p.frame_life = p.frame_life - 1;
    if (p.frame_life <= 0) {
		p.mat = empty;
		return;
	}
    //nada que comprobar, ya es suelo fijo;
    if (p.has_been_updated) return;

    // Si hay una part�cula en esta posici�n, mueva hacia abajo si es posible
    if (y < height && isEmpty(x, y + 1))
        updateParticle({ x,y + 1 }, { x,y }, p);

    // Si no puede moverse hacia abajo, intente moverse hacia la izquierda
    else if (x > 0 && y < height && isEmpty(x - 1, y + 1))
        updateParticle({ x - 1,y + 1 }, { x,y }, p);

    else if (x < width - 1 && y < height && isEmpty(x + 1, y + 1))
        // Si no puede moverse hacia abajo ni hacia la izquierda, intente moverse hacia la derecha
        updateParticle({ x + 1 ,y + 1 }, { x,y }, p);

 
    // en verdad esto es solo util ahora, cuando haya varios chunks y todo sea destruible no va a valer de nada
    // se�ala que un bloque de arena no se va a mover mas, ya que ya es base de otros bloques
    else p.is_stagnant = true;

   
    std::cout << p.frame_life << "\n";
}

void ParticleSimulation::updateSand(uint32_t x, uint32_t y) {

    Particle& p = chunk_state[x][y];

    //nada que comprobar, ya es suelo fijo;
    if (p.has_been_updated) return;

    //std::cout << "position: " << x << " " << y << "\n";
    
    // Si hay una part�cula en esta posici�n, mueva hacia abajo si es posible
    if (y > 0 && isEmpty(x, y - 1) )
        updateParticle({ x,y - 1 }, { x,y }, p);

    // Si no puede moverse hacia abajo, intente moverse hacia la izquierda
    else if (x > 0 && y > 0 && isEmpty(x - 1, y - 1))
        updateParticle({ x - 1,y - 1 }, { x,y }, p);

    else if (x < width - 1 && y > 0 && isEmpty(x + 1, y - 1))
        // Si no puede moverse hacia abajo ni hacia la izquierda, intente moverse hacia la derecha
        updateParticle({ x + 1 ,y - 1 }, { x,y }, p);

    // en verdad esto es solo util ahora, cuando haya varios chunks y todo sea destruible no va a valer de nada
    // se�ala que un bloque de arena no se va a mover mas, ya que ya es base de otros bloques
     else p.is_stagnant = true;
}

void ParticleSimulation::update() {

    // se actualiza en orden de abajo a arriba
    for (uint32_t y = 0; y < height; ++y) {
        for (uint32_t x = 0; x < width; x++) {
            material mat = chunk_state[x][y].mat;
            if (mat != empty)
                int n = 0;
            switch (mat)
            {
            case sand:
                updateSand(x, y);
                break;
            case gas:
                updateGas(x, y);
                break;
            case water:
                break;
            case empty:
                break;
            default:
                break;
            }
            

        }
    }

    updateTexture();

    //se�alo otra vez todas las particulas como no modificadas
    for (int i = 0; i < height; i++)
        for (int j = 0; j < width; j++)
            chunk_state[i][j].has_been_updated = false;
}

bool ParticleSimulation::isInside(int x, int y) const {
    return x >= 0 && x < width && y >= 0 && y < height;
}

void ParticleSimulation::setParticle(int x, int y) {
    // Convierte las coordenadas de pantalla a coordenadas de la simulaci�n
    int simX = (x * width) / wWidth;
    int simY = height - (y * height) / wHeight - 1;

    if (isInside(simX, simY)) {
        switch (type_particle) {
            case sand: 
                chunk_state[simX][simY].mat = sand;
                break;
            
            case gas: 
                chunk_state[simX][simY].mat = gas;
                break;

            case water: 
                //chunk_state[simX][simY].mat = water;
                break;
            
        }
       
    
     }

}

bool ParticleSimulation::isParticle(int x, int y) const {
    if (isInside(x, y)) {
        return  chunk_state[x][y].mat == sand;
    }
    return false;
}

int ParticleSimulation::getWidth() const {
    return width;
}

int ParticleSimulation::getHeight() const {
    return height;
}

void ParticleSimulation::render() {
    quad->render();
}