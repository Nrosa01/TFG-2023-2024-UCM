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
	
	//std::memset(chunk_state , empty, width * height);
	for (int x = 0; x < width * height; ++x) 
			chunk_state[x].mat = empty;

	Particle::initializeMaterialPhysics();


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
	for (int x = width * height  - 1 ; x > 0; --x) {
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

// We should update it to use memset or something to overwrite all particle stuff withuot having us to change us everytime we change the
// particle struct
void ParticleSimulation::updateParticle(position next_pos, position last_pos, const Particle& particle) {
	
	chunk_state[next_pos.x + width * next_pos.y] = particle;
	/*chunk_state[next_pos.x][next_pos.y].mat = particle.mat;
	chunk_state[next_pos.x][next_pos.y].speed = particle.speed;*/
	
	chunk_state[last_pos.x + width * last_pos.y].mat = empty;
	has_been_updated[next_pos.x + next_pos.y * width] = true;
}
void ParticleSimulation::pushOtherParticle(position pos) {

	for (int i = -3; i < 3; ++i) {
		for (int j = 1; j < 10; ++j) {
			if (isInside(pos.x + i, pos.y + j) && isEmpty(pos.x + i, pos.y + j)) {
				updateParticle({ pos.x + i, pos.y + j }, pos, chunk_state[pos.x + width * pos.y]);
				break;
			}
		}
	}
}


bool ParticleSimulation::goDown(uint32_t x, uint32_t y, const Particle& particle, uint32_t speed) {
	int i = 0;
	bool has_moved = false;

	while (speed > 0) {
		const uint32_t y_pos = y - 1 - i;

		if (y_pos >= height) {
			break;
		}

		// Density of current particle
		uint8_t current_density = Particle::materialPhysics[chunk_state[computeIndex(x, y_pos)].mat].density;

		// Density check
		if (current_density == 0 || current_density == 1 || current_density == 2) {
			// Pushing is now swapping
			std::swap(chunk_state[computeIndex(x, y)], chunk_state[x+ width *y_pos]);
			has_been_updated[computeIndex(x, y_pos)] = true;
			y -= 1;
			has_moved = true;
		}
		else {
			break;
		}

		speed--;
		i++;
	}

	return has_moved;
}


bool ParticleSimulation::goDownLeft(uint32_t x, uint32_t y, const Particle& particle, uint32_t speed) {
	bool can_move_left = (x > 0) && (y > 0) && (x - 1 < width) && (y - 1 < height) && isEmpty(x - 1, y - 1);

	if (can_move_left) {
		uint32_t new_x = x;
		uint32_t new_y = y;

		while (speed > 0) {
			if (new_x > 0 && new_y > 0 && new_x - 1 < width && new_y - 1 < height && isEmpty(new_x - 1, new_y - 1)) {
				chunk_state[(new_x - 1) + (width * (new_y - 1))] = particle;
				has_been_updated[((new_y - 1) * width) + (new_x - 1)] = true;
				chunk_state[computeIndex(x, y)] = Particle();
				has_been_updated[y * width + x] = true;
				new_x -= 1;
				new_y -= 1;
				speed--;
			}
			else {
				break;
			}
		}

		return true;
	}

	return false;
}

bool ParticleSimulation::goDownRight(uint32_t x, uint32_t y, const Particle& particle, uint32_t speed) {
	bool can_move_right = (x < width - 1) && (y > 0) && (x + 1 < width) && (y - 1 < height) && isEmpty(x + 1, y - 1);

	if (can_move_right) {
		uint32_t new_x = x;
		uint32_t new_y = y;

		while (speed > 0) {
			if (new_x < width - 1 && new_y > 0 && new_x + 1 < width && new_y - 1 < height && isEmpty(new_x + 1, new_y - 1)) {
				chunk_state[(new_x + 1) + (width * (new_y - 1))] = particle;
				has_been_updated[((new_y - 1) * width) + (new_x + 1)] = true;
				chunk_state[computeIndex(x, y)] = Particle();
				has_been_updated[y * width + x] = true;
				new_x += 1;
				new_y -= 1;
				speed--;
			}
			else {
				break;
			}
		}

		return true;
	}

	return false;
}


bool ParticleSimulation::goDownDensity(uint32_t x, uint32_t y, const Particle& particle, uint32_t speed) {

	//check if the particles below have lower density
	if (y > 0 && Particle::materialPhysics[particle.mat].density > Particle::materialPhysics[chunk_state[x + width * (y - 1)].mat].density) {
		pushOtherParticle({ x,y - 1 });
		updateParticle({ x,y - 1 }, { x,y }, particle);
		return true;
	}

	else if (x > 0 && y > 0 && Particle::materialPhysics[particle.mat].density > Particle::materialPhysics[chunk_state[x - 1 + width * (y - 1)].mat].density) {
		pushOtherParticle({ x - 1,y - 1 });
		updateParticle({ x - 1,y - 1 }, { x,y }, particle);
		return true;
	}
	else if (x < width - 1 && y > 0 && Particle::materialPhysics[particle.mat].density > Particle::materialPhysics[chunk_state[x + 1 + width * (y - 1)].mat].density) {
		pushOtherParticle({ x + 1,y - 1 });
		updateParticle({ x + 1 ,y - 1 }, { x,y }, particle);
		return true;
	}
	return false;
}

bool ParticleSimulation::goSides(uint32_t x, uint32_t y, const Particle& particle, uint32_t speed) {
	bool can_move_left = x > 0 && y > 0 && isEmpty(x - 1, y);
	bool can_move_right = x < width - 1 && y > 0 && isEmpty(x + 1, y);

	if (can_move_left && can_move_right) {
		int left = rand() % 2;
		if (left)
			updateParticle({ x - 1,y }, { x,y }, particle);
		else
			updateParticle({ x + 1 ,y }, { x,y }, particle);
	}
	// Si no puede moverse hacia abajo, intente moverse hacia la izquierda
	else if (can_move_left)
		updateParticle({ x - 1,y }, { x,y }, particle);
	// Si no puede moverse hacia abajo ni hacia la izquierda, intente moverse hacia la derecha
	else if (can_move_right)
		updateParticle({ x + 1 ,y }, { x,y }, particle);
	return can_move_left || can_move_right;
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
	if (has_been_updated[y * width + x]) return;

	if (goDown(x, y, p, p.speed)) return;
	if (goDownLeft(x, y, p, p.speed)) return;
	if (goDownRight(x, y, p, p.speed)) return;
	//if (goDownDensity(x, y, p, p.speed)) return;
	else p.is_stagnant = true;
}


void ParticleSimulation::updateWater(uint32_t x, uint32_t y) {
	Particle& p = chunk_state[computeIndex(x, y)];

	//nada que comprobar, ya es suelo fijo;
	if (has_been_updated[y * width + x]) return;

	if (goDown(x, y, p, p.speed)) return;
	if (goDownLeft(x, y, p, p.speed)) return;
	if (goDownRight(x, y, p, p.speed)) return;
	if (goSides(x, y, p, p.speed)) return;
	//if (goDownDensity(x, y, p, p.speed)) return;
	else p.is_stagnant = true;
}

void ParticleSimulation::updateGas(uint32_t x, uint32_t y) {
	//Particle& p = chunk_state[x][y];

	//p.life_time = p.life_time - 1;
	//if (p.life_time <= 0) {
	//	p.mat = empty;
	//	return;
	//}
	////nada que comprobar, ya es suelo fijo;
	//if (has_been_updated[y * width + x]) return;


	//// Si hay una partícula en esta posición, mueva hacia abajo si es posible
	//if (y < height && isEmpty(x, y + 1))
	//	updateTemporalParticle({ x,y + 1 }, { x,y }, p);

	//// Si no puede moverse hacia abajo, intente moverse hacia la izquierda
	//else if (x > 0 && y < height && isEmpty(x - 1, y + 1))
	//	updateTemporalParticle({ x - 1,y + 1 }, { x,y }, p);

	//else if (x < width - 1 && y < height && isEmpty(x + 1, y + 1))
	//	// Si no puede moverse hacia abajo ni hacia la izquierda, intente moverse hacia la derecha
	//	updateTemporalParticle({ x + 1 ,y + 1 }, { x,y }, p);
	//	// en verdad esto es solo util ahora, cuando haya varios chunks y todo sea destruible no va a valer de nada
	//	// señala que un bloque de arena no se va a mover mas, ya que ya es base de otros bloques
	//else p.is_stagnant = true;
}


void ParticleSimulation::setMaterial(material mat)
{
	type_particle = mat;
}

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
					chunk_state[i + width * j].mat = sand;
					chunk_state[i + width * j].speed = 1;
					break;

				case gas:
					chunk_state[i + width * j].mat = gas;
					chunk_state[i + width * j].life_time = Particle::gas_life_time;
					chunk_state[i + width * j].speed = 10;
					break;

				case water:
					chunk_state[i + width * j].mat = water;
					chunk_state[i + width * j].speed = 5;
					break;
				case rock:
					chunk_state[i + width * j].mat = rock;
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
