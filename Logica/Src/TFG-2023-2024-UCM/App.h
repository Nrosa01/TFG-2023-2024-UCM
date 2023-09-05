#pragma once

#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <memory>
#include <imgui.h>

class Triangle;
class Viewport;
class Camera;

class App {
public:
    App();
    ~App();
    bool init();
    void run();
    void release();
    static void keyCallback(GLFWwindow* window, int key, int scancode, int action, int mods);

private:
    std::unique_ptr<GLFWwindow, decltype(&glfwDestroyWindow)> window;
    std::unique_ptr<Viewport> viewport;
    std::unique_ptr<Camera> camera;
    bool isRunning;

    ImGuiIO* io;
    std::unique_ptr<Triangle> triangle;
};
