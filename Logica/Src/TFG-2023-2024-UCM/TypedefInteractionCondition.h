#pragma once
#include <functional>
#include <cstdint>

class Particle;

using InteractionCondition = std::function<bool(uint32_t, uint32_t, uint32_t, Particle**)>;

namespace InteractionConditionUtilities
{
	const InteractionCondition ALWAYS = [](uint32_t, uint32_t, uint32_t, Particle**)
		{
			return true;
		};
}