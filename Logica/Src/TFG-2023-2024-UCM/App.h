#pragma once

#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <memory>
#include <imgui.h>
#include <queue>

class ParticleSimulation;
class Triangle;
class Viewport;
class Camera;
enum material;

class App {
public:
    App();
    ~App();
    bool init();
    void run();
    void release();
    static void keyCallback(GLFWwindow* window, int key, int scancode, int action, int mods);
    static void mouseCallback(GLFWwindow* window, int button, int action, int mods);

private:
    const double PHYSICS_STEP = 0.02;
    const uint16_t MAX_PHYSICS_STEP_PER_FRAME = 5;
    double accumulator;

    void handleInput();
    void render();
    void update();
    void fixedUpdate(float deltaTime);
    
    bool pressingMouse = false; //esta feo pero por ahora sive
    //inpput events
    std::queue<int> events;

    static App* currentApp;
    static const int TARGET_FPS = 60;

    std::unique_ptr<GLFWwindow, decltype(&glfwDestroyWindow)> window;
    std::unique_ptr<Viewport> viewport;
    std::unique_ptr<Camera> camera;
    bool isRunning;

    ImGuiIO* io;
    std::unique_ptr<Triangle> triangle;
    std::unique_ptr<ParticleSimulation> sandSimulation;

    material selectedMaterial;
    bool showMaterialNames = true;
};
