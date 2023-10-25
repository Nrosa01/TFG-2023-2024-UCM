#include "Particle.h"
#include <unordered_map>

std::unordered_map<material, physics_data> Particle::material_physics = {
	{sand , { 3, 1, 3 }},
	{gas ,{ 0, 3, 4 }},
	{water , { 1, 3, 4 }},
	{rock , { 3, 0, 0 }},
	{acid , { 2, 2, 3 }}
};

std::unordered_map<direction, vector2D> Particle::direction_vectors = {
	{up, {0,1}},
	{down, {0,-1}},
	{left, {-1,0}},
	{right, {1,0}},
	{upleft, {-1,1}},
	{upright, {1,1}},
	{downleft, {-1,-1}},
	{downright, {1,-1}},
};

