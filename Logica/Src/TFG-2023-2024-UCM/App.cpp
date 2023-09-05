#define WINDOW_WIDTH 800
#define WINDOW_HEIGHT 800

#include "App.h"
#include <iostream>
#include <imgui_impl_glfw.h>
#include <imgui_impl_opengl3.h>

#include "Viewport.h"
#include "Camera.h"
#include "Triangle.h"

App::App() : window(nullptr, glfwDestroyWindow), isRunning(true), viewport(nullptr), camera(nullptr), io(nullptr) {}

App::~App() {}

bool App::init() {
    if (!glfwInit()) {
        return false;
    }

    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);

    window = std::unique_ptr<GLFWwindow, decltype(&glfwDestroyWindow)>(glfwCreateWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "TFG-2023", nullptr, nullptr), glfwDestroyWindow);
    if (!window) {
        std::cerr << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
        return false;
    }

    glfwMakeContextCurrent(window.get());
    gladLoadGLLoader((GLADloadproc)glfwGetProcAddress);

    viewport = std::make_unique<Viewport>(WINDOW_WIDTH, WINDOW_HEIGHT); // Ancho y alto de la ventana
    camera = std::make_unique<Camera>();

    glfwSetKeyCallback(window.get(), keyCallback);

    triangle = std::make_unique<Triangle>();

    // Init ImGui
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    io = &ImGui::GetIO();
    ImGui::StyleColorsDark();
    ImGui_ImplGlfw_InitForOpenGL(window.get(), true);
    ImGui_ImplOpenGL3_Init("#version 330"); // Because I'm using version 3.3 of GLSL

    return true;
}

void App::run() {
    while (!glfwWindowShouldClose(window.get()) && isRunning) {
        // Specify the color of the background
        glClearColor(0.07f, 0.13f, 0.17f, 1.0f);
        // Clean the back buffer and assign the new color to it
        glClear(GL_COLOR_BUFFER_BIT);

        // We have to make some wrapper for this kind of stuff idk
        ImGui_ImplOpenGL3_NewFrame();
        ImGui_ImplGlfw_NewFrame();
        ImGui::NewFrame();

        if (!io->WantCaptureMouse)
        {
            //Handle input here, so you don't handle input while interacting with ImGui component
        }

        triangle->render();

        ImGui::Render();
        ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());

        // Swap the back buffer with the front buffer
        glfwSwapBuffers(window.get());
        // Take care of all GLFW events
        glfwPollEvents();
    }
}

void App::release() {
    // Terminate ImGui
    ImGui_ImplOpenGL3_Shutdown();
    ImGui_ImplGlfw_Shutdown();
    ImGui::DestroyContext();

    glfwTerminate();
}

void App::keyCallback(GLFWwindow* window, int key, int scancode, int action, int mods) {
    if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
        glfwSetWindowShouldClose(window, GLFW_TRUE);
    }
}
