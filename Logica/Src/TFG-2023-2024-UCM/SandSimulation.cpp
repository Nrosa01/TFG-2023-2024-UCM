#include "SandSimulation.h"
#include <vector>
#include <algorithm>
#include <glm.hpp>
#include <gtc/type_ptr.hpp>
#include <ext/matrix_clip_space.hpp>

// Vertex Shader source code
const char* sandVertexShaderSource = R"(
    #version 330 core
    layout (location = 0) in vec2 position;

    uniform mat4 projection; // Matriz de proyección

    void main()
    {
        // Aplica la matriz de proyección a la posición del vértice
        gl_Position = projection * vec4(position, 0.0, 1.0);
    }

)";

// Fragment Shader source code
const char* sandFragmentShaderSource = R"(
    #version 330 core
    out vec4 FragColor;
    void main()
    {
        FragColor = vec4(1.0, 0.8, 0.0, 1.0); // Color de las partículas (amarillo)
    }
)";

SandSimulation::SandSimulation(int width, int height) : width(width), height(height) {
    currentFrame = new bool* [width];
    nextFrame = new bool* [width];

    for (int x = 0; x < width; ++x) {
        currentFrame[x] = new bool[height];
        nextFrame[x] = new bool[height];

        for (int y = 0; y < height; ++y) {
            currentFrame[x][y] = false;
            nextFrame[x][y] = false;
        }
    }

    initializeBuffers();
    createShaderProgram();
}

SandSimulation::~SandSimulation() {
    for (int x = 0; x < width; ++x) {
        delete[] currentFrame[x];
        delete[] nextFrame[x];
    }
    delete[] currentFrame;
    delete[] nextFrame;

    glDeleteVertexArrays(1, &VAO);
    glDeleteBuffers(1, &VBO);
    glDeleteProgram(shaderProgram);
}

void SandSimulation::initializeBuffers() {
    // Crear y configurar el Vertex Array Object (VAO)
    glGenVertexArrays(1, &VAO);
    glBindVertexArray(VAO);

    // Crear y configurar el Vertex Buffer Object (VBO)
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);

    // Configurar el atributo de posición de los vértices
    GLint posAttrib = glGetAttribLocation(shaderProgram, "position");
    glEnableVertexAttribArray(posAttrib);
    glVertexAttribPointer(posAttrib, 2, GL_FLOAT, GL_FALSE, 0, 0);

    // Desvincular el VAO y el VBO
    glBindVertexArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

void SandSimulation::createShaderProgram() {
    // Crear el Vertex Shader
    GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader, 1, &sandVertexShaderSource, NULL);
    glCompileShader(vertexShader);

    // Crear el Fragment Shader
    GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &sandFragmentShaderSource, NULL);
    glCompileShader(fragmentShader);

    // Crear el Shader Program y enlazar los shaders
    shaderProgram = glCreateProgram();
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    glLinkProgram(shaderProgram);

    // Eliminar los shaders compilados ya que no los necesitamos más
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
}

void SandSimulation::update() {
    for (int x = 0; x < width; ++x) {
        for (int y = height - 2; y >= 0; --y) {
            if (currentFrame[x][y]) {
                // Si hay una partícula en esta posición, mueva hacia abajo si es posible
                if (!currentFrame[x][y + 1] && !nextFrame[x][y + 1]) {
                    nextFrame[x][y + 1] = true;
                    currentFrame[x][y] = false;
                }
                else if (!currentFrame[x - 1][y + 1] && !nextFrame[x - 1][y + 1]) {
                    // Si no puede moverse hacia abajo, intente moverse hacia la izquierda
                    nextFrame[x - 1][y + 1] = true;
                    currentFrame[x][y] = false;
                }
                else if (!currentFrame[x + 1][y + 1] && !nextFrame[x + 1][y + 1]) {
                    // Si no puede moverse hacia abajo ni hacia la izquierda, intente moverse hacia la derecha
                    nextFrame[x + 1][y + 1] = true;
                    currentFrame[x][y] = false;
                }
            }
        }
    }

    // Intercambia los frames actual y siguiente después de una actualización, esto no es eficiente porque es O(n) pero en fin
    std::swap(currentFrame, nextFrame);
}

bool SandSimulation::isInside(int x, int y) const {
    return x >= 0 && x < width && y >= 0 && y < height;
}

void SandSimulation::setParticle(int x, int y) {
    if (isInside(x, y)) {
        currentFrame[x][y] = true;
    }
}

bool SandSimulation::isParticle(int x, int y) const {
    if (isInside(x, y)) {
        return currentFrame[x][y];
    }
    return false;
}

int SandSimulation::getWidth() const {
    return width;
}

int SandSimulation::getHeight() const {
    return height;
}

void SandSimulation::render() {
    // Configura la matriz de proyección ortográfica
    glm::mat4 projection = glm::ortho(0.0f, static_cast<float>(width), 0.0f, static_cast<float>(height), -1.0f, 1.0f);

    // Obtén la ubicación de la variable uniform "projection" en el shader
    GLint projectionLoc = glGetUniformLocation(shaderProgram, "projection");

    // Envía la matriz de proyección al shader
    glUniformMatrix4fv(projectionLoc, 1, GL_FALSE, value_ptr(projection));

    glUseProgram(shaderProgram);
    glBindVertexArray(VAO);

    // Renderiza partículas de arena como puntos
    glPointSize(10.0f); // Tamaño de los puntos para representar las partículas

    std::vector<GLfloat> vertices;
    for (int x = 0; x < width; ++x) {
        for (int y = 0; y < height; ++y) {
            if (isParticle(x, y)) {
                vertices.push_back(static_cast<GLfloat>(x));
                vertices.push_back(static_cast<GLfloat>(y));
            }
        }
    }

    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * vertices.size(), vertices.data(), GL_STATIC_DRAW);

    glDrawArrays(GL_POINTS, 0, static_cast<GLsizei>(vertices.size() / 2));

    glBindVertexArray(0);
}
