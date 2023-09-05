#pragma once
#include <glad/glad.h>
#include <GLFW/glfw3.h>

class Triangle
{
public:
	Triangle();
	~Triangle();

	void render();

private:
	bool show;
	float color[4];
	float size;

	GLuint VAO, VBO;
	GLuint shaderProgram;
};

