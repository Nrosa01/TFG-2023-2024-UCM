#pragma once
#include <functional>
#include <cstdint>

class Particle;

using InteractionFunction = std::function<bool(uint32_t, uint32_t, uint32_t, Particle**, uint32_t, uint32_t)>;