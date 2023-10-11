#include "ParticleSimulation.h"
#include <vector>
#include <algorithm>
#include <glm.hpp>
#include <gtc/type_ptr.hpp>
#include <ext/matrix_clip_space.hpp>
#include <GLFW/glfw3.h>
#include "Quad.h"
#include <iostream>
#include "Common_utils.h"

static const double PI = 3.1415926535;


ParticleSimulation::ParticleSimulation(int width, int height, int wWidth, int wHeight) : width(width), height(height), wWidth(wWidth), wHeight(wHeight) {
  
    chunk_state = new Particle * [width];
    for (int x = 0; x < width; ++x) {
        chunk_state[x] = new Particle[height];

        for (int y = 0; y < height; ++y) 
            chunk_state[x][y].mat = empty;
        
        
    }
    Particle::initializeMaterialPhysics();


    has_been_updated = new bool [width * height] ;
    std::memset(has_been_updated, false, width * height);

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

void ParticleSimulation::updateTexture() {
    // Recorre los datos de la simulación y actualiza textureData según el estado actual
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
                c.a = grey.a * chunk_state[x][y].life_time / Particle::gas_life_time;
            	break;
            case water:
                c = blue;
				break;
            case rock:
                c = dark_grey;
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
    return  chunk_state[x][y].mat == empty;
}

void ParticleSimulation::updateTemporalParticle(position next_pos, position last_pos, const Particle& particle) {
    chunk_state[next_pos.x][next_pos.y].mat = particle.mat;
    chunk_state[next_pos.x][next_pos.y].life_time = particle.life_time;
    has_been_updated[next_pos.x + next_pos.y * width] = true;
    chunk_state[last_pos.x][last_pos.y].mat = empty;
}


void ParticleSimulation::updateParticle(position next_pos, position last_pos,const Particle& particle) {
    chunk_state[next_pos.x][next_pos.y].mat = particle.mat;
    has_been_updated[next_pos.x + next_pos.y* width] = true;
    chunk_state[last_pos.x][last_pos.y].mat = empty;
}
void ParticleSimulation::pushOtherParticle(position pos) {
    
    for (int i = -3; i < 3; ++i) {
        for (int j = 1; j < 10; ++j) {
            if (isInside(pos.x+i, pos.y+j) && isEmpty(pos.x + i, pos.y + j)) {
                updateParticle({ pos.x + i, pos.y + j }, pos, chunk_state[pos.x][pos.y]);
                break;
            }
        }
    }
}


void ParticleSimulation::updateSand(uint32_t x, uint32_t y) {

    Particle& p = chunk_state[x][y];

    //nada que comprobar, ya es suelo fijo;
    if (has_been_updated[y * width + x]) return;
    
    // Si hay una partícula en esta posición, mueva hacia abajo si es posible
    if (y > 0 && isEmpty(x, y - 1))
        updateParticle({ x,y - 1 }, { x,y }, p);

    else {
        bool can_move_left = x > 0 && y > 0 && isEmpty(x - 1, y - 1);
        bool can_move_right = x < width - 1 && y > 0 && isEmpty(x + 1, y - 1);

        if (can_move_left && can_move_right) {
            int left = rand() % 2;
            if(left)
				updateParticle({ x - 1,y - 1 }, { x,y }, p);
			else
				updateParticle({ x + 1 ,y - 1 }, { x,y }, p);
        }
        // Si no puede moverse hacia abajo, intente moverse hacia la izquierda
        else if (can_move_left)
            updateParticle({ x - 1,y - 1 }, { x,y }, p);
        // Si no puede moverse hacia abajo ni hacia la izquierda, intente moverse hacia la derecha
        else if (can_move_right)
            updateParticle({ x + 1 ,y - 1 }, { x,y }, p);
        //std::cout << "position: " << x << " " << y << "\n";

            //check if the particles below have lower density
        else if (y > 0 && Particle::materialPhysics[p.mat].density > Particle::materialPhysics[chunk_state[x][y - 1].mat].density) {
            pushOtherParticle({ x,y - 1 });
            updateParticle({ x,y - 1 }, { x,y }, p);
        }

        else if (x > 0 && y > 0 && Particle::materialPhysics[p.mat].density > Particle::materialPhysics[chunk_state[x - 1][y - 1].mat].density) {
            pushOtherParticle({ x - 1,y - 1 });
            updateParticle({ x - 1,y - 1 }, { x,y }, p);
        }
        else if (x < width - 1 && y > 0 && Particle::materialPhysics[p.mat].density > Particle::materialPhysics[chunk_state[x + 1][y - 1].mat].density) {
            pushOtherParticle({ x + 1,y - 1 });
            updateParticle({ x + 1 ,y - 1 }, { x,y }, p);
        }


        // en verdad esto es solo util ahora, cuando haya varios chunks y todo sea destruible no va a valer de nada
        // señala que un bloque de arena no se va a mover mas, ya que ya es base de otros bloques
        else p.is_stagnant = true;
    }
}


void ParticleSimulation::updateWater(uint32_t x, uint32_t y) {
    Particle& p = chunk_state[x][y];

    //nada que comprobar, ya es suelo fijo;
    if (has_been_updated[y * width + x]) return;

    //std::cout << "position: " << x << " " << y << "\n";

     // Si hay una partícula en esta posición, mueva hacia abajo si es posible
    if (y > 0 && isEmpty(x, y - 1))
        updateParticle({ x,y - 1 }, { x,y }, p);

    else {
        bool can_move_left = x > 0 && y > 0 && isEmpty(x - 1, y - 1);
        bool can_move_right = x < width - 1 && y > 0 && isEmpty(x + 1, y - 1);

        if (can_move_left && can_move_right) {
            int left = rand() % 2;
            if (left)
                updateParticle({ x - 1,y - 1 }, { x,y }, p);
            else
                updateParticle({ x + 1 ,y - 1 }, { x,y }, p);
        }
        // Si no puede moverse hacia abajo, intente moverse hacia la izquierda
        else if (can_move_left)
            updateParticle({ x - 1,y - 1 }, { x,y }, p);
        // Si no puede moverse hacia abajo ni hacia la izquierda, intente moverse hacia la derecha
        else if (can_move_right)
            updateParticle({ x + 1 ,y - 1 }, { x,y }, p);
        //std::cout << "position: " << x << " " << y << "\n";
        else {
            can_move_left = x > 0 && y > 0 && isEmpty(x - 1, y);
            can_move_right = x < width - 1 && y > 0 && isEmpty(x + 1, y);

            if (can_move_left && can_move_right) {
                int left = rand() % 2;
                if (left)
                    updateParticle({ x - 1,y }, { x,y }, p);
                else
                    updateParticle({ x + 1 ,y }, { x,y }, p);
            }
            // Si no puede moverse hacia abajo, intente moverse hacia la izquierda
            else if (can_move_left)
                updateParticle({ x - 1,y }, { x,y }, p);
            // Si no puede moverse hacia abajo ni hacia la izquierda, intente moverse hacia la derecha
            else if (can_move_right)
                updateParticle({ x + 1 ,y }, { x,y }, p);
            else p.is_stagnant = true;
        }
        // en verdad esto es solo util ahora, cuando haya varios chunks y todo sea destruible no va a valer de nada
        // señala que un bloque de arena no se va a mover mas, ya que ya es base de otros bloques
      
    }
}

void ParticleSimulation::updateGas(uint32_t x, uint32_t y) {
    Particle& p = chunk_state[x][y];
    
    p.life_time = p.life_time - 1;
    if (p.life_time <= 0) {
		p.mat = empty;
		return;
	}
    //nada que comprobar, ya es suelo fijo;
    if (has_been_updated[y * width + x]) return;

    // Si hay una partícula en esta posición, mueva hacia abajo si es posible
    if (y < height && isEmpty(x, y + 1))
        updateTemporalParticle({ x,y + 1 }, { x,y }, p);

    // Si no puede moverse hacia abajo, intente moverse hacia la izquierda
    else if (x > 0 && y < height && isEmpty(x - 1, y + 1))
        updateTemporalParticle({ x - 1,y + 1 }, { x,y }, p);

    else if (x < width - 1 && y < height && isEmpty(x + 1, y + 1))
        // Si no puede moverse hacia abajo ni hacia la izquierda, intente moverse hacia la derecha
        updateTemporalParticle({ x + 1 ,y + 1 }, { x,y }, p);

 
    // en verdad esto es solo util ahora, cuando haya varios chunks y todo sea destruible no va a valer de nada
    // señala que un bloque de arena no se va a mover mas, ya que ya es base de otros bloques
    else p.is_stagnant = true;

   
    //std::cout << p.life_time << "\n";
}


void ParticleSimulation::setMaterial(material mat)
{
    type_particle = mat;
}

void ParticleSimulation::update() {

    // se actualiza en orden de abajo a arriba
    for (uint32_t y = 0; y < height; ++y) {
        for (uint32_t x = 0; x < width; x++) {
            switch (chunk_state[x][y].mat)
            {
            case sand:
                updateSand(x, y);
                break;
            case gas:
                updateGas(x, y);
                break;
            case water:
                updateWater(x, y);
                break;
            case rock:
                break;
            case empty:
                break;
            default:
                break;
            }
            

        }
    }

    updateTexture();

    //señalo otra vez todas las particulas como no modificadas
    std::memset(has_been_updated, false, width * height);
}

bool ParticleSimulation::isInside(int x, int y) const {
    return x >= 0 && x < width && y >= 0 && y < height;
}



void ParticleSimulation::setParticle(int x, int y) {
    // Convierte las coordenadas de pantalla a coordenadas de la simulación
    int simX = (x * width) / wWidth;
    int simY = height - (y * height) / wHeight - 1;
    int simX_aux = simX;
    int simY_aux = simY;

    for(int i = simX- radius_brush; i< simX + radius_brush; ++i)
        for (int j = simY - radius_brush; j < simY + radius_brush; ++j) {
            int simX_aux = i - simX; // horizontal offset
            int simY_aux = j - simY; // vertical offset
            if ((simX_aux * simX_aux + simY_aux * simY_aux) <= (radius_brush * radius_brush) && isInside (i, j) && isEmpty(i,j))
            {
               
                switch (type_particle) {
                case sand:
                    chunk_state[i][j].mat = sand;
                    break;

                case gas:
                    chunk_state[i][j].mat = gas;
                    chunk_state[i][j].life_time = Particle::gas_life_time;
                    break;

                case water:
                    chunk_state[i][j].mat = water;
                    break;
                case rock:
                    chunk_state[i][j].mat = rock;
                }
            }
        }
   
  


    //if (isInside(simX + x1, simY + y1)) {
    //    simX_aux = simX + x1;
    //    simY_aux = simY + y1;
    //    switch (type_particle) {
    //    case sand:
    //        chunk_state[simX_aux][simY_aux].mat = sand;
    //        break;

    //    case gas:
    //        chunk_state[simX_aux][simY_aux].mat = gas;
    //        chunk_state[simX_aux][simY_aux].life_time = gas_life_time;
    //        break;

    //    case water:
    //        chunk_state[simX_aux][simY_aux].mat = water;
    //        break;
    //    case rock:
    //        chunk_state[simX_aux][simY_aux].mat = rock;
    //    }
    //}
}

bool ParticleSimulation::isParticle(int x, int y) const {
    if (isInside(x, y)) {
        return  !chunk_state[x][y].mat == empty;
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
