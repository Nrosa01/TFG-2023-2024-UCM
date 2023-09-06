#include "Quad.h"

const char* quadVertexShaderSource = R"(
    #version 330 core
    layout (location = 0) in vec2 aPos;
    
    uniform float width;
    uniform float height;

    void main()
    {
        gl_Position = vec4(aPos.x * width, aPos.y * height, 0.0, 1.0);
    }
)";

const char* quadFragmentShaderSource = R"(
    #version 330 core
    out vec4 FragColor;

    uniform vec4 color;

    void main()
    {
        FragColor = color;
    }
)";

Quad::Quad(float width, float height):width(width),height(height)
{
    GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader, 1, &quadVertexShaderSource, NULL);
    glCompileShader(vertexShader);

    GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &quadFragmentShaderSource, NULL);
    glCompileShader(fragmentShader);

    shaderProgram = glCreateProgram();
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    glLinkProgram(shaderProgram);

    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);

    GLfloat vertices[] =
    {
        -0.5f, -0.5f,
        0.5f, -0.5f,
        0.5f, 0.5f,
        -0.5f, -0.5f,
        0.5f, 0.5f,
        -0.5f, 0.5f
    };

    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);

    glBindVertexArray(VAO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);

    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
}

Quad::~Quad()
{
    glDeleteVertexArrays(1, &VAO);
    glDeleteBuffers(1, &VBO);
    glDeleteProgram(shaderProgram);
}

void Quad::render()
{
    glUseProgram(shaderProgram);
    glBindVertexArray(VAO);

    glUniform1f(glGetUniformLocation(shaderProgram, "width"), width);
    glUniform1f(glGetUniformLocation(shaderProgram, "height"), height);

    glUniform4f(glGetUniformLocation(shaderProgram, "color"), 0.8f, 0.3f, 0.02f, 1.0f);

    glDrawArrays(GL_TRIANGLES, 0, 6);

    glBindVertexArray(0);
}
