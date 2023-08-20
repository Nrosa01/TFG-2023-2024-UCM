#include "imgui.h"
#include <stdio.h>
#include <iostream>
#include <glad/glad.h>
#include <GLFW/glfw3.h>

#define WINDOW_WIDTH 800
#define WINDOW_HEIGHT 600

// Main code
int main(int, char**)
{
	_CrtSetDbgFlag(_CRTDBG_ALLOC_MEM_DF | _CRTDBG_LEAK_CHECK_DF); //Hay que estar en Debug
	
	glfwInit();

	// Tell GLFW what version of OpenGL we are using (OpenGL 3.3)
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);

	// Tell GLFW we are using core profile, that means we are using the modern functions without any compatibility with old ones
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

	std::unique_ptr<GLFWwindow, decltype(&glfwDestroyWindow)> window(glfwCreateWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "TFG-2023", nullptr, nullptr), glfwDestroyWindow);

	if (window == nullptr)
	{
		std::cerr << "Failed to create GLFW window" << std::endl;
		glfwTerminate();
		return -1;
	}

	glfwMakeContextCurrent(window.get());

	// Load GLAD so it configures OpenGL
	gladLoadGL();

	//Specify the viewport of OpenGL in the Window
	glViewport(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);

	glClearColor(0.07f, 0.13f, 0.17f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT);
	glfwSwapBuffers(window.get());

	while (!glfwWindowShouldClose(window.get()))
	{
		// Equivalent to SDL poll events
		glfwPollEvents();
	}

	glfwTerminate();
	return 0;
}
