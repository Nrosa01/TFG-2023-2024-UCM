#pragma once

#include <glm.hpp>

class Viewport {
public:
    Viewport(int width, int height);
    void setSize(int width, int height);
    glm::mat4 getProjectionMatrix() const;
    glm::mat4 getViewMatrix() const;

private:
    int screenWidth;
    int screenHeight;
};
