#include "viewport.h"
#include <gtc/matrix_transform.hpp>

//TODO: Bueno, usarlo xD. Quizás esta clase ni siquiera debería existir. ¿Debería llamar a esto window y meter cosas de window y vierport juntas?
Viewport::Viewport(int width, int height) : screenWidth(width), screenHeight(height) {}

void Viewport::setSize(int width, int height) {
    screenWidth = width;
    screenHeight = height;
}

glm::mat4 Viewport::getProjectionMatrix() const {
    return glm::perspective(glm::radians(45.0f), static_cast<float>(screenWidth) / static_cast<float>(screenHeight), 0.1f, 100.0f);
}

glm::mat4 Viewport::getViewMatrix() const {
    return glm::lookAt(glm::vec3(0.0f, 0.0f, 3.0f), glm::vec3(0.0f, 0.0f, 0.0f), glm::vec3(0.0f, 1.0f, 0.0f));
}