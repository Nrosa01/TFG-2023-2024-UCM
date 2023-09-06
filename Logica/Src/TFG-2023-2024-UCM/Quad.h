#pragma once
#include <glad/glad.h>
#include <GLFW/glfw3.h>

class Quad
{
public:
    Quad(float width, float height);
    ~Quad();

    void render();

private:
    float width, height;
    GLuint VAO, VBO;
    GLuint shaderProgram;
};
