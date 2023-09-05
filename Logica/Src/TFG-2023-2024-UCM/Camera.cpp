#include "camera.h"
#include <gtc/matrix_transform.hpp>

//TODO: Comentar y quitar numeros magicos
Camera::Camera() : position(glm::vec3(0.0f, 0.0f, 3.0f)), front(glm::vec3(0.0f, 0.0f, -1.0f)), up(glm::vec3(0.0f, 1.0f, 0.0f)), yaw(-90.0f), pitch(0.0f), fov(45.0f) {}

glm::mat4 Camera::getViewMatrix() const {
    return glm::lookAt(position, position + front, up);
}

void Camera::moveForward(float speed) {
    position += front * speed;
}

void Camera::moveBackward(float speed) {
    position -= front * speed;
}

void Camera::moveLeft(float speed) {
    position -= glm::normalize(glm::cross(front, up)) * speed;
}

void Camera::moveRight(float speed) {
    position += glm::normalize(glm::cross(front, up)) * speed;
}

void Camera::rotate(float x, float y) {
    const float sensitivity = 0.1f;
    x *= sensitivity;
    y *= sensitivity;

    yaw += x;
    pitch += y;

    if (pitch > 89.0f) {
        pitch = 89.0f;
    }
    if (pitch < -89.0f) {
        pitch = -89.0f;
    }

    glm::vec3 newFront;
    newFront.x = cos(glm::radians(yaw)) * cos(glm::radians(pitch));
    newFront.y = sin(glm::radians(pitch));
    newFront.z = sin(glm::radians(yaw)) * cos(glm::radians(pitch));
    front = glm::normalize(newFront);
}

void Camera::zoom(float amount) {
    if (fov >= 1.0f && fov <= 45.0f) {
        fov -= amount;
    }
    if (fov <= 1.0f) {
        fov = 1.0f;
    }
    if (fov >= 45.0f) {
        fov = 45.0f;
    }
}
