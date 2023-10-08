#pragma once
#include <cstdint>

//Sand particle


enum material { sand,gas,water, empty };


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
	//colour_t colour;
	bool has_been_updated = false;

	//time in which the particles dissapear
	//only applicable to gas and combustionable particles
	uint32_t frame_life = 300;
};


const static colour_t yellow{ 255,255,0,255 };
const static colour_t grey{ 128,128,128,255 };
