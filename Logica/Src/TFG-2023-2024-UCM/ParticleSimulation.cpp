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
#include "ParticleChunk.h"

static const double PI = 3.1415926535;

ParticleSimulation::ParticleSimulation(int width, int height, int wWidth, int wHeight) : wWidth(wWidth), wHeight(wHeight) {

	chunk = new ParticleChunk(width, height);

	brush_size = width / 20;
	radius_brush = brush_size / 2;

	textureData.resize(width * height * 4, 0);
	initializeTexture();
	quad = std::make_unique<Quad>(wWidth, wHeight, textureID);
}

ParticleSimulation::~ParticleSimulation() {

	delete[] chunk;

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
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, chunk->getWidth(), chunk->getHeight(), 0, GL_RGBA, GL_UNSIGNED_BYTE, nullptr);

	// Establece los datos iniciales de la textura
	std::fill(textureData.begin(), textureData.end(), 0);

	glBindTexture(GL_TEXTURE_2D, 0);
}

void ParticleSimulation::updateTexture() {
	// Recorre los datos de la simulaci�n y actualiza textureData seg�n el estado actual
	const int width = chunk->getWidth();
	const int height = chunk->getHeight();
	
	ParticleDefinitionsHandler& handler = ParticleDefinitionsHandler::getInstance();

	for (auto it = chunk->begin(); it != chunk->end(); ++it)
	{
		Particle& particle = *it;
		
		// Obtener las coordenadas x e y desde el iterador
		int x = std::distance(chunk->begin(), it) % width;
		int y = std::distance(chunk->begin(), it) / width;

		ParticleProject::colour_t c = addGranularity(handler.getParticleData(particle.type).particle_color, particle.random_granularity);

		int pos_text = (y * width + x) * 4;
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

void ParticleSimulation::setMaterial(int mat)
{
	type_particle = mat;
}

// TODO: Update methods should recibe the index directly, right now
// Update from bottom to up
// We prefer from up to bottom but we're doing this now because it allows us to spot behaviour bugs by sight better
void ParticleSimulation::update() {
	chunk->update();
	updateTexture();
}

void ParticleSimulation::setParticle(uint32_t x, uint32_t y) {
	// Convierte las coordenadas de pantalla a coordenadas de la simulaci�n
	int simX = (x * chunk->getWidth()) / wWidth;
	int simY = chunk->getHeight() - (y * chunk->getHeight()) / wHeight - 1;
	int simX_aux = simX;
	int simY_aux = simY;

	for (int i = simX - radius_brush; i < simX + radius_brush; ++i)
		for (int j = simY - radius_brush; j < simY + radius_brush; ++j) {
			int simX_aux = i - simX; // horizontal offset
			int simY_aux = j - simY; // vertical offset
			// Id 0 is an special harcoded case now that represents the empty particle. We should do something about that at some point
			if ((simX_aux * simX_aux + simY_aux * simY_aux) <= (radius_brush * radius_brush) && isInside(i, j) && (isEmpty(i, j) || type_particle == 0))
			{
				chunk->setParticle(i, j, ParticleFactory::createParticle(type_particle));
			}
		}
}

void ParticleSimulation::render() {
	quad->render();
}
