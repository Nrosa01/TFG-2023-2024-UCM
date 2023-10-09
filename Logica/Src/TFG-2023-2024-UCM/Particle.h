#pragma once
#include <cstdint>

//Sand particle


enum material { sand,gas,water,rock, empty };


struct position {
	uint32_t x;
	uint32_t y;
};
	

struct colour_t {
	uint8_t r;
	uint8_t g;
	uint8_t b;
	uint8_t a;
	
};


struct Particle {
	bool is_stagnant = false;
	material mat = empty;

	//time in which the particles dissapear
	//only applicable to gas and combustionable particles
	uint32_t life_time = 0;


	//colour_t colour;
};


const static colour_t yellow{ 255,255,0,255 };
const static colour_t grey{ 128,128,128,255 };
const static colour_t blue{ 173, 216, 230,255 };
const static colour_t dark_grey{ 169, 169, 169 ,255 };

const static int gas_life_time = 400;

//const static colour_t empty_colour{ 0,0,0,0 };
//
//const static Particle empty_particle{ false,empty,0 };
//const static Particle sand_particle{ false,sand,0  };
//const static Particle gas_particle{ false,gas,300 };



