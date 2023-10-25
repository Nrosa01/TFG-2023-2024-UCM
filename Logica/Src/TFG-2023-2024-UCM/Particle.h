#pragma once
#include <cstdint>
#include <unordered_map>
#include "Common_utils.h"

//Sand particle

enum material { sand, gas, water, rock, acid, empty };

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

//I dont know where to put the direction info, so I'm just putting it in particle for the moment

enum direction { up, down, left, right, upleft, upright, downleft, downright };

struct Particle {
	// TODO: Convert everything to camelCase. Const members should be ALL_CAPS
	static std::unordered_map<material, physics_data> material_physics;
	static std::unordered_map<direction, vector2D> direction_vectors;
	static const int gas_life_time = 300;


	bool is_stagnant = false;
	material mat = empty;

	//time in which the particles dissapear
	//only applicable to gas and combustionable particles
	uint32_t life_time = 0;
	
	// This variable control how many pixels per frame the particle will transverse
	// This generates dependency from the physics step, but we prefer this. We could also measeure the time
	// in miliseconds between frame to not be depending on the number of times the physics process is called but...
	// That brings inconsistency in the update, fixed update was implemented to avoid this, so it doesn't make sense to add it at all...
	// Best we can do for now it's stick with this and disallow users to be able to change the physics update rate.
	
	// Furthermore this speed parameter doesn't make sense, is this falling speed? propagation? This is just here temporarilly to test the speed implmenetation
	uint32_t speed = 0;
	//colour_t colour;
};






