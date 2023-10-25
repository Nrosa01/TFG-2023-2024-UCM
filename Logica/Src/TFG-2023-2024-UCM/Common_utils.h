#pragma once

#include <cstdint>

struct position {
	uint32_t x;
	uint32_t y;
};
struct vector2D {
	int x; 
	int y;
};

struct colour_t {
	uint8_t r;
	uint8_t g;
	uint8_t b;
	uint8_t a;

};
static const colour_t yellow{ 255,255,0,255 };
static const colour_t grey{ 128,128,128,255 };
static const colour_t blue{ 173, 216, 230,255 };
static const colour_t dark_grey{ 169, 169, 169 ,255 };
static const colour_t saturated_green{ 67, 226, 49 ,255 };
