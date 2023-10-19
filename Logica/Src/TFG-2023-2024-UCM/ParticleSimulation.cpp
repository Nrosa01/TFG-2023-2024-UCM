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

	chunk_state = new Particle [width * height];
	

	has_been_updated = new bool[width * height];
	std::memset(has_been_updated, false, width * height);

	textureData.resize(width * height * 4, 0);
	initializeTexture();
	quad = std::make_unique<Quad>(wWidth, wHeight, textureID);
}

ParticleSimulation::~ParticleSimulation() {
	
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
	for (int x = width * height  - 1 ; x >= 0; --x) {
			colour_t c{ 0,0,0,0 };
			switch (chunk_state[x].mat)
			{
			case sand:
				c = yellow;
				break;
			case gas:
				c = grey;
				c.a = grey.a * chunk_state[x].life_time / Particle::gas_life_time;
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
			
			int pos_text = (x) * 4;
			textureData[pos_text + 0] = c.r;   // R
			textureData[pos_text + 1] = c.g;   // G
			textureData[pos_text + 2] = c.b;   // B
			textureData[pos_text + 3] = c.a;   // A
		
	}

	// Luego, actualiza la textura con los nuevos datos
	glBindTexture(GL_TEXTURE_2D, textureID);
	glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, textureData.data());
	glBindTexture(GL_TEXTURE_2D, 0);
}


bool ParticleSimulation::isEmpty(uint32_t x, uint32_t y) {
	return  chunk_state[x + width *y].mat == empty;
}

void ParticleSimulation::updateTemporalParticle(position next_pos, position last_pos, const Particle& particle) {
	/*chunk_state[next_pos.x][next_pos.y].mat = particle.mat;
	chunk_state[next_pos.x][next_pos.y].life_time = particle.life_time;
	has_been_updated[next_pos.x + next_pos.y * width] = true;
	chunk_state[last_pos.x][last_pos.y].mat = empty;*/
}

void ParticleSimulation::pushOtherParticle(position pos) {
	for (int i = -3; i < 3; ++i) {
		for (int j = 1; j < 10; ++j) {
			if (isInside(pos.x + i, pos.y + j	)) {
				uint8_t current_density = Particle::material_physics[chunk_state[computeIndex(pos.x + i, pos.y + j)].mat].density;
				if (current_density < Particle::material_physics[chunk_state[computeIndex(pos.x, pos.y)].mat].density) {
					chunk_state[computeIndex(pos.x+i, pos.y + j)] = chunk_state[computeIndex(pos.x, pos.y)];
					chunk_state[computeIndex(pos.x,  pos.y)] = Particle();
					break;
				}
			}
		}
	}
}

bool ParticleSimulation::goFlat(const int& dir_x, const int& dir_y, uint32_t x, uint32_t y, const Particle& particle, uint32_t& pixelsToMove)
{
	int i = 0;
	uint32_t x_pos = x, y_pos = y;

	while (pixelsToMove > 0)
	{
		x_pos += dir_x;
		y_pos += dir_y;
		if (!isInside(x_pos, y_pos) || !isEmpty(x_pos, y_pos))
			break;
		else
			i++;

		pixelsToMove--;
	}

	if (i == 0)
		return false;

	chunk_state[computeIndex(x + dir_x * i, y + dir_y * i)] = particle;
	has_been_updated[computeIndex(x + dir_x * i, y + dir_y * i)] = true;
	chunk_state[computeIndex(x, y)] = Particle();

	return true;
}

bool ParticleSimulation::goDiagonal(const int& dir_x, const int& dir_y, uint32_t x, uint32_t y, const Particle& particle, uint32_t& pixelsToMove)
{
	uint32_t new_x = x, new_y = y;

	while (pixelsToMove > 0) {
		new_x += dir_x;
		new_y += dir_y;
		if (isInside(new_x, new_y) && isEmpty(new_x, new_y)) {

			chunk_state[computeIndex(new_x, new_y)] = particle;
			has_been_updated[computeIndex(new_x, new_y)] = true;
			chunk_state[computeIndex(x, y)] = Particle();
			has_been_updated[y * width + x] = true;

			pixelsToMove--;
		}
		else {
			break;
		}
	}
	return true;


}


bool ParticleSimulation::goDown(uint32_t x, uint32_t y, const Particle& particle, uint32_t& pixelsToMove) {
	int i = 0;
	while (pixelsToMove > 0)
	{
		const uint32_t y_pos = y - 1 - i;
		if (y_pos > height || !isEmpty(x, y_pos))
			break;
		else
			i++;

		pixelsToMove--;
	}

	if (i == 0)
		return false;

	chunk_state[computeIndex(x, y - i)] = particle;
	has_been_updated[computeIndex(x, (y - i))] = true;
	chunk_state[computeIndex(x, y)] = Particle();

	return true;
}


bool ParticleSimulation::goDownLeft(uint32_t x, uint32_t y, const Particle& particle, uint32_t& pixelsToMove) {
	bool can_move_left = (x > 0) && (y > 0)  && isEmpty(x - 1, y - 1);

	if (can_move_left) {
		uint32_t new_x = x;
		uint32_t new_y = y;
		while (pixelsToMove > 0) {
			if (new_x > 0 && new_y > 0 && isEmpty(new_x - 1, new_y - 1)) {
				new_x -= 1;
				new_y -= 1;
				chunk_state[computeIndex(new_x,new_y)] = particle;
				has_been_updated[computeIndex(new_x, new_y)] = true;			
				chunk_state[computeIndex(x, y)] = Particle();
				has_been_updated[y * width + x] = true;
			
				pixelsToMove--;
			}
			else {
				break;
			}
		}
		return true;
	}

	return false;
}

bool ParticleSimulation::goDownRight(uint32_t x, uint32_t y, const Particle& particle, uint32_t& pixelsToMove) {
	bool can_move_right = (y > 0) && (x + 1 < width) && isEmpty(x + 1, y - 1);

	if (can_move_right) {
		uint32_t new_x = x;
		uint32_t new_y = y;

		while (pixelsToMove > 0) {
			if (new_y > 0 && new_x + 1 < width && isEmpty(new_x + 1, new_y - 1)) {
				new_x += 1;
				new_y -= 1;
				chunk_state[computeIndex(new_x, new_y)] = particle;
				has_been_updated[computeIndex(new_x, new_y)] = true;
				chunk_state[computeIndex(x, y)] = Particle();
				has_been_updated[computeIndex(x, y)] = true;
				
				pixelsToMove--;
			}
			else {
				break;
			}
		}

		return true;
	}

	return false;
}


bool ParticleSimulation::goDownDensity(uint32_t x, uint32_t y, const Particle& particle, uint32_t& speed) {
    if (y > 0 && speed > 0) {
        int i = 1;
        while (i <= y && speed > 0) {
            const uint32_t y_pos = y - i;
            if (y_pos < height) {
                uint8_t target_density = Particle::material_physics[chunk_state[computeIndex(x, y_pos)].mat].density;
                if (target_density < Particle::material_physics[particle.mat].density) {
                    pushOtherParticle({ x, y_pos });
					has_been_updated[x, y_pos] = true;
                    chunk_state[computeIndex(x, y_pos)] = particle;
                    chunk_state[computeIndex(x, y)] = Particle();
                    speed--;
                } else {
                    break;
                }
            }
            i++;
        }
        return speed == 0;
    }
    return false;
}

bool ParticleSimulation::goDownLeftDensity(uint32_t x, uint32_t y, const Particle & particle, uint32_t & pixelsToMove) {
	
	bool can_move_left = (x > 0) && (y > 0) ;

	if (can_move_left) {
		uint32_t new_x = x;
		uint32_t new_y = y;
		
		while (pixelsToMove > 0) {
			uint8_t target_density = Particle::material_physics[chunk_state[computeIndex(new_x -1, new_y-1)].mat].density;
			if (new_x > 0 && new_y > 0 && target_density < Particle::material_physics[particle.mat].density) {
				
				new_x -= 1;
				new_y -= 1;
				pushOtherParticle({ new_x,new_y });

				chunk_state[computeIndex(new_x, new_y)] = particle;
				has_been_updated[computeIndex(new_x, new_y)] = true;
				chunk_state[computeIndex(x, y)] = Particle();
				has_been_updated[computeIndex(x, y)] = true;

				pixelsToMove--;
			}
			else {
				break;
			}
		}
		return true;
	}

	return false;
}

bool ParticleSimulation::goDownRightDensity(uint32_t x, uint32_t y, const Particle& particle, uint32_t& pixelsToMove) {

	bool can_move_right = (y > 0) && (x + 1 < width) ;

	if (can_move_right) {
		uint32_t new_x = x;
		uint32_t new_y = y;

		while (pixelsToMove > 0) {
			uint8_t target_density = Particle::material_physics[chunk_state[computeIndex(new_x + 1, new_y - 1)].mat].density;
			if (new_y > 0 && new_x + 1 < width && target_density < Particle::material_physics[particle.mat].density) {

				new_x += 1;
				new_y -= 1;
				pushOtherParticle({ new_x,new_y });

				chunk_state[computeIndex(new_x, new_y)] = particle;
				has_been_updated[computeIndex(new_x, new_y)] = true;
				chunk_state[computeIndex(x, y)] = Particle();
				has_been_updated[computeIndex(x, y)] = true;

				pixelsToMove--;
			}
			else {
				break;
			}
		}
		return true;
	}

	return false;
}

inline uint32_t ParticleSimulation::computeIndex(const uint32_t& x, const uint32_t& y) const
{ 
	return y * width + x;	
}

inline uint32_t ParticleSimulation::computeIndex(const uint32_t&& x, const uint32_t&& y) const
{
	return y * width + x;
}

void ParticleSimulation::updateSand(uint32_t x, uint32_t y) {
	Particle& p = chunk_state[computeIndex(x, y)];

	//nada que comprobar, ya es suelo fijo;
	if (has_been_updated[computeIndex(x, y)]) return;

	uint32_t pixelsToMove = p.speed;

	// We could even get rid of the ifs as, if pixelsToMove is 0, the method would be "called" but would inmediately return
	// Assuming the method is inlined, this won't trigger a call stack allocation
	goDown(x, y, p, pixelsToMove);
	goDownDensity(x, y, p, p.speed);
	goDownLeft(x, y, p, pixelsToMove);
	goDownLeftDensity(x, y, p, pixelsToMove);
	//goDownRight(x, y, p, pixelsToMove);
	goDownRightDensity(x, y, p, pixelsToMove);
	
	p.is_stagnant = pixelsToMove == 0;
}


void ParticleSimulation::updateWater(uint32_t x, uint32_t y) {
	Particle& p = chunk_state[computeIndex(x, y)];

	//nada que comprobar, ya es suelo fijo;
	if (has_been_updated[computeIndex(x, y)]) return;

	uint32_t pixelsToMove = p.speed;

	goDown(x, y, p, pixelsToMove);
	goDownLeft(x, y, p, pixelsToMove);
	goDownRight(x, y, p, pixelsToMove);
	goFlat(-1,0,x,y,p,pixelsToMove);
	goFlat(1, 0, x, y, p, pixelsToMove);
	//if (goDownDensity(x, y, p, p.speed)) return;
	p.is_stagnant = pixelsToMove == 0;
}

void ParticleSimulation::updateGas(uint32_t x, uint32_t y) {

	Particle& p = chunk_state[computeIndex(x, y)];

	p.life_time -= 1;
	if (p.life_time <= 0)
	{
		p.mat = empty;
		return;
	}

	//nada que comprobar, ya es suelo fijo;
	if (has_been_updated[computeIndex(x, y)]) return;

	uint32_t pixelsToMove = p.speed;

	// We could even get rid of the ifs as, if pixelsToMove is 0, the method would be "called" but would inmediately return
	// Assuming the method is inlined, this won't trigger a call stack allocation
	goFlat(0,1,x, y, p, pixelsToMove);
	goDiagonal(-1,1,x, y, p, pixelsToMove);
	goDiagonal(1,1,x, y, p, pixelsToMove);


	p.is_stagnant = pixelsToMove == 0;

}


void ParticleSimulation::setMaterial(material mat)
{
	type_particle = mat;
}

// TODO: Update methods should recibe the index directly, right now
// we are passing x and y just to use computeIndex later which doesn't make sense
void ParticleSimulation::update() {

	// se actualiza en orden de abajo a arriba
	for (uint32_t x = 0; x < width * height - 1; ++x) {
		//for (uint32_t x = 0; x < width; x++) {
			switch (chunk_state[x].mat)
			{
			case sand:
				updateSand(x % width, x / width);
				break;
			case gas:
				updateGas(x % width, x/width);
				break;
			case water:
				updateWater(x % width, x/width);
				break;
			case rock:
				break;
			case empty:
				break;
			default:
				break;
			}


		
	}

	updateTexture();

	//señalo otra vez todas las particulas como no modificadas
	std::memset(has_been_updated, false, width * height);
}

bool ParticleSimulation::isInside(uint32_t x, uint32_t y) const {
	return x >= 0 && x < width && y >= 0 && y < height;
}



void ParticleSimulation::setParticle(uint32_t x, uint32_t y) {
	// Convierte las coordenadas de pantalla a coordenadas de la simulación
	int simX = (x * width) / wWidth;
	int simY = height - (y * height) / wHeight - 1;
	int simX_aux = simX;
	int simY_aux = simY;

	for (int i = simX - radius_brush; i < simX + radius_brush; ++i)
		for (int j = simY - radius_brush; j < simY + radius_brush; ++j) {
			int simX_aux = i - simX; // horizontal offset
			int simY_aux = j - simY; // vertical offset
			if ((simX_aux * simX_aux + simY_aux * simY_aux) <= (radius_brush * radius_brush) && isInside(i, j) && isEmpty(i, j))
			{
				// TODO: Create a particle factory
				switch (type_particle) {
				case sand:
					chunk_state[computeIndex(i,j)].mat = sand;
					chunk_state[computeIndex(i,j)].speed = 1;
					break;

				case gas:
					chunk_state[computeIndex(i,j)].mat = gas;
					chunk_state[computeIndex(i,j)].life_time = Particle::gas_life_time;
					chunk_state[computeIndex(i,j)].speed = 5;
					break;

				case water:
					chunk_state[computeIndex(i,j)].mat = water;
					chunk_state[computeIndex(i,j)].speed = 5;
					break;
				case rock:
					chunk_state[computeIndex(i,j)].mat = rock;
				}
			}
		}
}

bool ParticleSimulation::isParticle(uint32_t x, uint32_t y) const {
	if (isInside(x, y)) {
		return  !chunk_state[computeIndex(x, y)].mat == empty;
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
