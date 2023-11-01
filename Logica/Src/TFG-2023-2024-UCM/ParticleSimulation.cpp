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
#include "ParticleFactory.h"
#include "ParticleDataManager.h"

static const double PI = 3.1415926535;


ParticleSimulation::ParticleSimulation(int width, int height, int wWidth, int wHeight) : width(width), height(height), wWidth(wWidth), wHeight(wHeight) {

	chunk_state = new Particle[width * height];

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
	for (int x = width * height - 1; x >= 0; --x) {
		ParticleProject::colour_t c = getParticleData(x).particle_color;

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


bool ParticleSimulation::isEmpty(uint32_t index) {
	return  chunk_state[index].type == empty;
}

//void ParticleSimulation::pushOtherParticle(position pos) {
//	for (int i = -3; i < 3; ++i) {
//		for (int j = 1; j < 10; ++j) {
//			if (isInside(pos.x + i, pos.y + j)) {
//				uint8_t current_density = Particle::material_physics[chunk_state[computeIndex(pos.x + i, pos.y + j)].mat].density;
//				if (current_density < Particle::material_physics[chunk_state[computeIndex(pos.x, pos.y)].mat].density) {
//					chunk_state[computeIndex(pos.x + i, pos.y + j)] = chunk_state[computeIndex(pos.x, pos.y)];
//					chunk_state[computeIndex(pos.x, pos.y)] = ParticleFactory::createEmptyParticle();
//					break;
//				}
//			}
//		}
//	}
//}

bool ParticleSimulation::moveParticle(const int& dir_x, const int& dir_y, uint32_t x, uint32_t y, const Particle& particle)
{
	uint32_t new_x = x, new_y = y;

	new_x += dir_x;
	new_y += dir_y;
	
	if (isInside(new_x, new_y) && isEmpty(computeIndex(new_x, new_y))) {

		chunk_state[computeIndex(new_x, new_y)] = particle;
		chunk_state[computeIndex(new_x, new_y)].clock++;
		chunk_state[computeIndex(x, y)] = ParticleFactory::createEmptyParticle();
		chunk_state[computeIndex(x, y)].clock++;

		return true;
	}
	else
		return false;
}

inline void ParticleSimulation::updateParticle(uint32_t index)
{

}

const inline ParticleData& ParticleSimulation::getParticleData(uint32_t index) const
{
	return ParticleDataManager::Instance()->getParticleData(chunk_state[index].type);
}

inline uint32_t ParticleSimulation::computeIndex(const uint32_t& x, const uint32_t& y) const
{
	return y * width + x;
}

inline uint32_t ParticleSimulation::computeIndex(const uint32_t&& x, const uint32_t&& y) const
{
	return y * width + x;
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
		updateParticle(x);
	}

	clock++;

	updateTexture();
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
			if ((simX_aux * simX_aux + simY_aux * simY_aux) <= (radius_brush * radius_brush) && isInside(i, j) && isEmpty(computeIndex(i, j)))
			{
				// TODO: Create a particle factory
				switch (type_particle) {
				case sand:
					chunk_state[computeIndex(i, j)] = ParticleFactory::createSandParticle();
					break;
				case gas:
					chunk_state[computeIndex(i, j)] = ParticleFactory::createGasParticle();
					break;
				case water:
					chunk_state[computeIndex(i, j)] = ParticleFactory::createWaterParticle();
					break;
				case rock:
					chunk_state[computeIndex(i, j)] = ParticleFactory::createRockParticle();
					break;
				case acid:
					chunk_state[computeIndex(i, j)] = ParticleFactory::createAcidParticle();
					break;
				}
			}
		}
}

bool ParticleSimulation::isParticle(uint32_t x, uint32_t y) const {
	if (isInside(x, y)) {
		return  !chunk_state[computeIndex(x, y)].type == empty;
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
