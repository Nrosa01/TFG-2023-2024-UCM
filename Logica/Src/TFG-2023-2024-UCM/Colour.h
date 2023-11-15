#pragma once
#include <cstdint>
#include <algorithm>
namespace ParticleProject
{
	struct colour_t {
		uint8_t r;
		uint8_t g;
		uint8_t b;
		uint8_t a;
	
		/*colour_t operator+(const colour_t& c2) {

			colour_t result;
			result.r = std::min(r + c2.r, 255);
			result.g = std::min(g + c2.g, 255);
			result.b = std::min(b + c2.b, 255);
			result.a = std::min(a + c2.a, 255);
			return result;
		};*/
		

	};

	


}