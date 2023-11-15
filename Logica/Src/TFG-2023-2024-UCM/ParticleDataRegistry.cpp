#include "ParticleDataRegistry.h"
#include "ParticleFactory.h"

ParticleDefinitionsHandler::ParticleDefinitionsHandler()
{
	interaction_map.add_function("Always", [](uint32_t, uint32_t, uint32_t, Particle**, uint32_t, uint32_t) { return true; });

	interaction_map.add_function("Push", [this](uint32_t x, uint32_t y, uint32_t, Particle** chunk, uint32_t width, uint32_t height)
		{
			std::function<bool(uint32_t, uint32_t)> is_inside = [width, height](uint32_t x, uint32_t y) {
				return x >= 0 && x < width && y >= 0 && y < height;
				};

			for (int i = -3; i < 3; ++i) {
				for (int j = 1; j < 10; ++j) {
					if (is_inside(x + i, y + j)) {
						const uint8_t current_density = particle_data[chunk[x + i][y + j].type].properties.density;
						const uint8_t other_density = particle_data[chunk[x][y].type].properties.density;
						if (current_density < other_density) {
							chunk[x + i][y + j] = chunk[x][y];
							chunk[x][y] = ParticleFactory::createParticle();
							break;
						}
					}
				}
			}

			return true;
		});
}
