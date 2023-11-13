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

static const double PI = 3.1415926535;

ParticleSimulation::ParticleSimulation(int width, int height, int wWidth, int wHeight) : width(width), height(height), wWidth(wWidth), wHeight(wHeight), clock(0), registry(ParticleDefinitionsHandler::getInstance()) {

	chunk_state = new Particle * [width];
	for (int x = 0; x < width; ++x) {
		chunk_state[x] = new Particle[height];

		for (int y = 0; y < height; ++y)
			chunk_state[x][y].type = 0;
	}


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
		for (int y = 0; y < height; y++)
		{
			ParticleProject::colour_t c = addGranularity(getParticleData(x, y).particle_color,
				chunk_state[x][y].random_granularity);

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

const bool ParticleSimulation::isEmpty(const uint32_t& x, const uint32_t& y) const
{
	return chunk_state[x][y].type == 0;
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

const bool ParticleSimulation::moveParticle(const int& dir_x, const int& dir_y, const uint32_t& x, const uint32_t& y)
{
	const uint32_t new_x = x + dir_x;
	const uint32_t new_y = y + dir_y;

	if (isInside(new_x, new_y) && isEmpty(new_x, new_y)) {

		chunk_state[new_x][new_y] = chunk_state[x][y];
		chunk_state[x][y] = ParticleFactory::createParticle(0);

		return true;
	}
	else
		return false;
}

inline void ParticleSimulation::updateParticle(const uint32_t& x, const uint32_t& y)
{
	const ParticleDefinition& data = getParticleData(x, y);
	const std::vector<Interaction>& interactions = data.interactions;
	const uint32_t particle_movement_passes_amount = data.movement_passes.size();

	if (chunk_state[x][y].clock != clock || particle_movement_passes_amount == 0)
	{
		chunk_state[x][y].clock = !clock;
		return; // This particle has already been updated
	}

	uint32_t particle_movement_passes_index = 0;
	uint32_t pixelsToMove = 1; // Temporal
	bool particleIsMoving = true;
	bool particleCollidedLastIteration = false;
	uint32_t new_pos_x = x;
	uint32_t new_pos_y = y;

	while (pixelsToMove > 0 && particleIsMoving)
	{
		// Gather particle direction
		const int32_t dir_x = data.movement_passes[particle_movement_passes_index].x;
		const int32_t dir_y = data.movement_passes[particle_movement_passes_index].y;

		const bool particleMoved = moveParticle(dir_x, dir_y, new_pos_x, new_pos_y);

		// If particle cant move we HAVE to process interactions
		bool should_break = false;
		for (const Interaction& interaction : interactions)
		{
			// True means simulation can continue, false stops the simulation for the current particle
			should_break = !interaction.interaction_function(new_pos_x, new_pos_y, particle_movement_passes_index, chunk_state);
			
			if (should_break)
				break;
		}


		if (should_break)
			break;

		if (!particleMoved)
		{
			// Increment movement pass looping through the passes
			particle_movement_passes_index++;

			// If we reached the last pass, we reset the index
			if (particle_movement_passes_index == particle_movement_passes_amount)
			{
				particle_movement_passes_index = 0;

				if (particleCollidedLastIteration)
					particleIsMoving = false;

				particleCollidedLastIteration = true;
			}
		}
		else
		{
			particleCollidedLastIteration = false;
			particleIsMoving = true;
			pixelsToMove--;
			new_pos_x += dir_x;
			new_pos_y += dir_y;
		}
	}

	// clock_handler:


	chunk_state[x][y].clock = !clock;

	// Update final position of the particle
	chunk_state[new_pos_x][new_pos_y].clock = !clock;
}

const inline ParticleDefinition& ParticleSimulation::getParticleData(const uint32_t& x, const uint32_t& y) const
{
	return registry.getParticleData(chunk_state[x][y].type);
	// This makes the simulation run 7 times slower, just leavint it as a note
	//return ParticleRegistry::getInstance().getParticleData(chunk_state[x][y].type);
}

void ParticleSimulation::setMaterial(int mat)
{
	type_particle = mat;
}

// TODO: Update methods should recibe the index directly, right now
// Update from bottom to up
// We prefer from up to bottom but we're doing this now because it allows us to spot behaviour bugs by sight better
void ParticleSimulation::update() {
	for (uint32_t y = 0; y < width; ++y) {
		for (uint32_t x = 0; x < height; ++x)
			updateParticle(x, y);
	}

	clock = !clock;

	updateTexture();
}

const bool ParticleSimulation::isInside(uint32_t x, uint32_t y) const {
	return x >= 0 && x < width && y >= 0 && y < height;
}

void ParticleSimulation::setParticle(uint32_t x, uint32_t y) {
	// Convierte las coordenadas de pantalla a coordenadas de la simulaci�n
	int simX = (x * width) / wWidth;
	int simY = height - (y * height) / wHeight - 1;
	int simX_aux = simX;
	int simY_aux = simY;

	for (int i = simX - radius_brush; i < simX + radius_brush; ++i)
		for (int j = simY - radius_brush; j < simY + radius_brush; ++j) {
			int simX_aux = i - simX; // horizontal offset
			int simY_aux = j - simY; // vertical offset
			// Id 0 is an special harcoded case now that represents the empty particle. We should do something about that at some point
			if ((simX_aux * simX_aux + simY_aux * simY_aux) <= (radius_brush * radius_brush) && isInside(i, j) && (isEmpty(i, j) || type_particle == 0))
			{
				chunk_state[i][j] = ParticleFactory::createParticle(type_particle);
			}
		}
}

const bool ParticleSimulation::isParticle(uint32_t x, uint32_t y) const {
	if (isInside(x, y)) {
		return  !chunk_state[x][y].type == 0;
	}
	return false;
}

const int ParticleSimulation::getWidth() const {
	return width;
}

const int ParticleSimulation::getHeight() const {
	return height;
}

void ParticleSimulation::render() {
	quad->render();
}
