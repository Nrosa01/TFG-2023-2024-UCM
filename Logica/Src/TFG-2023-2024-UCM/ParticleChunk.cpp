#include "ParticleChunk.h"
#include "Particle.h"
#include "ParticleData.h"
#include "ParticleFactory.h"

ParticleChunk::ParticleChunk(int width, int height) : width(width), height(height), clock(0)
{
	chunk_state = new Particle * [width];
	for (int x = 0; x < width; ++x) {
		chunk_state[x] = new Particle[height];

		for (int y = 0; y < height; ++y)
			chunk_state[x][y].type = 0;
	}
}

ParticleChunk::~ParticleChunk()
{
	delete[] chunk_state;
}

inline void ParticleChunk::updateParticle(const uint32_t& x, const uint32_t& y, const ParticleDefinitionsHandler& registry)
{
	const ParticleDefinition& data = registry.getParticleData(getParticleType(x, y));
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

		bool particleMoved = moveParticle(new_pos_x, new_pos_y, dir_x, dir_y);

		// If particle cant move we HAVE to process interactions
		bool should_break = false;
		for (const Interaction& interaction : interactions)
		{
			// True means simulation can continue, false stops the simulation for the current particle
			should_break = !interaction.interaction_function(new_pos_x, new_pos_y, particle_movement_passes_index, chunk_state, width, height);

			if (should_break)
				goto clock_handler;
		}

		// If interaction didn't cut the update, see if particle didn't move, if so, try pushing
		// This way we don't have to loop
		if (!particleMoved)
			particleMoved = tryPushParticle(new_pos_x, new_pos_y, dir_x, dir_y);

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

clock_handler:


	chunk_state[x][y].clock = !clock;

	// Update final position of the particle
	chunk_state[new_pos_x][new_pos_y].clock = !clock;
}

inline const int ParticleChunk::getWidth() const
{
	return width;
}

inline const int ParticleChunk::getHeight() const
{
	return height;
}

inline const Particle& ParticleChunk::getParticle(int x, int y) const
{
	return chunk_state[x][y];
}

inline const bool ParticleChunk::isInside(uint32_t x, uint32_t y) const
{
	return x >= 0 && x < width && y >= 0 && y < height;;
}

inline const bool ParticleChunk::isEmpty(const uint32_t& x, const uint32_t& y) const
{
	return chunk_state[x][y].type == 0;
}

inline const bool ParticleChunk::canPush(const uint32_t& other_x, const uint32_t& other_y, const uint32_t& x, const uint32_t& y) const
{
	return ParticleDefinitionsHandler::getInstance().getParticleData(getParticleType(other_x, other_y)).properties.density < ParticleDefinitionsHandler::getInstance().getParticleData(getParticleType(x, y)).properties.density;
}

inline const int ParticleChunk::getParticleType(const uint32_t& x, const uint32_t& y) const
{
	return chunk_state[x][y].type;
}

void ParticleChunk::update()
{
	ParticleDefinitionsHandler& registry = ParticleDefinitionsHandler::getInstance();

	for (uint32_t y = 0; y < width; ++y) {
		for (uint32_t x = 0; x < height; ++x)
			updateParticle(x, y, registry);
	}

	clock = !clock;
}

inline void ParticleChunk::setParticle(uint32_t x, uint32_t y, const Particle& particle)
{
}

inline bool ParticleChunk::tryPushParticle(const uint32_t& x, const uint32_t& y, const int& dir_x, const int& dir_y)
{
	const uint32_t new_x = x + dir_x;
	const uint32_t new_y = y + dir_y;

	//this is going to glu glu the performance hehehehe
	if (isInside(new_x, new_y) && canPush(new_x, new_y, x, y)) {
		Particle aux = chunk_state[new_x][new_y];
		chunk_state[new_x][new_y] = chunk_state[x][y];
		chunk_state[x][y] = ParticleFactory::createParticle(0);
		//search for an empty space to move
		for (int i = -5; i < 5; ++i) {
			for (int j = 1; j < 20; ++j) {
				if (isInside(new_x + i, new_y + j) && isEmpty(new_x + i, new_y + j)) {
					chunk_state[new_x + i][new_y + j] = aux;
					return true;
				}
			}
		}
		return true;
	}
	else
		return false;
}

inline const bool ParticleChunk::moveParticle(const uint32_t& x, const uint32_t& y, const int& dir_x, const int& dir_y)
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

