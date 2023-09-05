#pragma once

#include <glm.hpp>

class Camera {
public:
    Camera();
    glm::mat4 getViewMatrix() const;
    void moveForward(float speed);
    void moveBackward(float speed);
    void moveLeft(float speed);
    void moveRight(float speed);
    void rotate(float x, float y);
    void zoom(float amount);

private:
    glm::vec3 position;
    glm::vec3 front;
    glm::vec3 up;
    float yaw;
    float pitch;
    float fov;
};