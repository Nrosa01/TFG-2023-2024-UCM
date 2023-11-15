#pragma once

#include <cstdint>
#include "Colour.h"
#include "Vector2D.h"
namespace ParticleProject
{
	static const colour_t empty{ 0,0,0,0 };
	static const colour_t yellow{ 230,230,0,255 };
	static const colour_t grey{ 128,128,128,255 };
	static const colour_t blue{ 173, 216, 230,255 };
	static const colour_t dark_grey{ 169, 169, 169 ,255 };
	static const colour_t saturated_green{ 67, 226, 49 ,255 };

	static const Vector2D up{ 0,1 };
	static const Vector2D down{ 0,-1 };
	static const Vector2D left{ -1,0 };
	static const Vector2D right{ 1,0 };
	static const Vector2D up_left{ -1,1 };
	static const Vector2D up_right{ 1,1 };
	static const Vector2D down_left{ -1,-1 };
	static const Vector2D down_right{ 1,-1 };
}