#pragma once
#include <cstdint>
#include <unordered_map>

//Sand particle

enum material { sand, gas, water, rock, empty };

/*
* density summary:
* 0 = go-through (gas)
* 1 = light-fluid (water)
* 2 = heavy-fluid (oil)
* 3 = solid (sand, rock etc)
* the rest of the values are multipliers for velocity, 1 is normal, 2 is twice as fast, 0 is immobile
*/

struct physics_data {
	uint8_t density;
	uint8_t falling_speed ;
	uint8_t propagation_speed;
};

class Particle {


	
public:
	static std::unordered_map<material, physics_data> materialPhysics;
	static const int gas_life_time = 300;
	static void initializeMaterialPhysics();

	bool is_stagnant = false;
	material mat = empty;

	//time in which the particles dissapear
	//only applicable to gas and combustionable particles
	uint32_t life_time = 0;
	


	//colour_t colour;
};






