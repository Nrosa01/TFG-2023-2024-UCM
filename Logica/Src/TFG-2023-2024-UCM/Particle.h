#pragma once
#include <cstdint>

//Sand particle

#define yellow {255,255,0,255}

enum material { sand, empty };


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
	int velocity = 100;
	bool has_been_updated = false;
	double last_mov = 0;
	//colour_t colour;
};
