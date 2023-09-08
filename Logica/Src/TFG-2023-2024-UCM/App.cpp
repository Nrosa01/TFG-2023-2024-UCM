#define WINDOW_WIDTH 800
#define WINDOW_HEIGHT 800

#include "App.h"
#include <iostream>
#include <imgui_impl_glfw.h>
#include <imgui_impl_opengl3.h>
#include <thread>

#include "Viewport.h"
#include "Camera.h"
#include "Triangle.h"
#include "SandSimulation.h"
#include "Quad.h"

App* App::currentApp = nullptr;

App::App() : window(nullptr, glfwDestroyWindow), isRunning(true), viewport(nullptr), camera(nullptr), io(nullptr) {
	currentApp = this;
}

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
	glfwSetMouseButtonCallback(window.get(), mouseCallback);

	triangle = std::make_unique<Triangle>();
	sandSimulation = std::make_unique<SandSimulation>(100, 100, WINDOW_WIDTH, WINDOW_HEIGHT);

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
	double targetFrameTime = 1.0 / static_cast<double>(TARGET_FPS);
	double lastFrameTime = glfwGetTime();
	double fpsUpdateTime = 0.0;
	int frameCount = 0;

	while (!glfwWindowShouldClose(window.get()) && isRunning) {
		double currentTime = glfwGetTime();
		double deltaTime = currentTime - lastFrameTime;

		// Limitar la velocidad de actualización a 60 FPS
		if (deltaTime >= targetFrameTime) {
			update();
			render();

			lastFrameTime = currentTime;

			fpsUpdateTime += deltaTime;
			frameCount++;

			// Calcular FPS y mostrarlos en la consola
			if (fpsUpdateTime >= 1.0) {
				double fps = static_cast<double>(frameCount) / fpsUpdateTime;
				std::cout << "FPS: " << fps << std::endl;
				frameCount = 0;
				fpsUpdateTime = 0.0;
			}

			// Calcular el tiempo que debemos dormir para alcanzar 60 FPS
			double sleepTime = targetFrameTime - deltaTime;
			if (sleepTime > 0.0) {
				std::this_thread::sleep_for(std::chrono::duration<double>(sleepTime));
			}
		}
	}


	//sin sleep_for
	//while (!glfwWindowShouldClose(window.get()) && isRunning) {
	//	double currentTime = glfwGetTime();
	//	double deltaTime = currentTime - lastFrameTime;
	//	
	//	
	//	// Limitar la velocidad de actualización a 60 FPS (por alguna razón no va a más de 40)
	//	if (deltaTime >= targetFrameTime) {
	//		update();
	//		render();

	//		lastFrameTime = currentTime;

	//		fpsUpdateTime += deltaTime;
	//		frameCount++;
	//		// Calcular FPS y mostrarlos en la consola
	//		if (fpsUpdateTime >= 1.0) {
	//			double fps = (double)(frameCount) / fpsUpdateTime;
	//			std::cout << "FPS: " << fps << std::endl;
	//			frameCount = 0;
	//			fpsUpdateTime = 0.0;
	//		}
	//	}
	//}
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

void App::mouseCallback(GLFWwindow* window, int button, int action, int mods) {
	//Handle input here, so you don't handle input while interacting with ImGui component
	if (!currentApp->io->WantCaptureMouse)
	{
		if (action == GLFW_PRESS && button == GLFW_MOUSE_BUTTON_LEFT)
			currentApp->pressingMouse = true;
		else if (action == GLFW_RELEASE)
			currentApp->pressingMouse = false;
	}
}

void App::render()
{
	// Specify the color of the background
	glClearColor(0.07f, 0.13f, 0.17f, 1.0f);
	// Clean the back buffer and assign the new color to it
	glClear(GL_COLOR_BUFFER_BIT);

	// We have to make some wrapper for this kind of stuff idk
	ImGui_ImplOpenGL3_NewFrame();
	ImGui_ImplGlfw_NewFrame();
	ImGui::NewFrame();

	//quad->render();
	sandSimulation->render();
	//triangle->render();

	ImGui::Render();
	ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());

	// Swap the back buffer with the front buffer
	glfwSwapBuffers(window.get());
	// Take care of all GLFW events
	glfwPollEvents();
}

void App::update()
{
	if (pressingMouse)
	{
		double mouseX, mouseY;
		glfwGetCursorPos(window.get(), &mouseX, &mouseY);

		// Convierte las coordenadas del cursor a las coordenadas de la simulación
		int simX = static_cast<int>(mouseX);
		int simY = static_cast<int>(mouseY);

		// Agrega partículas de arena en las coordenadas de la simulación
		currentApp->sandSimulation->setParticle(simX, simY);
	}

	sandSimulation->update();
}
