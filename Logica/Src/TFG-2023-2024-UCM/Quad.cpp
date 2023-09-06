#include "Quad.h"

const char* quadVertexShaderSource = R"(
    #version 330 core
	layout (location = 0) in vec2 aPos;
	out vec2 texCoord;

	uniform float width;
	uniform float height;

	void main()
	{
	    gl_Position = vec4(aPos.x * width, aPos.y * height, 0.0, 1.0);
	    texCoord = (vec2(aPos.x * width, aPos.y * height) + 1.0) / 2.0;
	}	
)";

const char* quadFragmentShaderSource = R"(
	#version 330 core
	out vec4 FragColor;
	in vec2 texCoord;

	uniform sampler2D textureSampler;

	void main()
	{
	    FragColor = texture(textureSampler, texCoord);
	}
)";

const char* quadFragmentShaderSource2 = R"(
    #version 330 core
    out vec4 FragColor;

    uniform sampler2D textureSampler;

    void main()
    {
        FragColor = texture(textureSampler, vec2(1.0 - gl_FragCoord.x, gl_FragCoord.y));
    }
)";

Quad::Quad(float width, float height, GLuint textureId) :width(width), height(height), textureId(textureId)
{
	GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
	glShaderSource(vertexShader, 1, &quadVertexShaderSource, NULL);
	glCompileShader(vertexShader);

	GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
	glShaderSource(fragmentShader, 1, &quadFragmentShaderSource, NULL);
	glCompileShader(fragmentShader);

	shaderProgram = glCreateProgram();
	glAttachShader(shaderProgram, vertexShader);
	glAttachShader(shaderProgram, fragmentShader);
	glLinkProgram(shaderProgram);

	glDeleteShader(vertexShader);
	glDeleteShader(fragmentShader);

	GLfloat vertices[] =
	{
		-0.5f, -0.5f,
		0.5f, -0.5f,
		0.5f, 0.5f,
		-0.5f, -0.5f,
		0.5f, 0.5f,
		-0.5f, 0.5f
	};

	glGenVertexArrays(1, &VAO);
	glGenBuffers(1, &VBO);

	glBindVertexArray(VAO);
	glBindBuffer(GL_ARRAY_BUFFER, VBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

	glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(float), (void*)0);
	glEnableVertexAttribArray(0);

	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glBindVertexArray(0);
}

Quad::~Quad()
{
	glDeleteVertexArrays(1, &VAO);
	glDeleteBuffers(1, &VBO);
	glDeleteProgram(shaderProgram);
}

void Quad::render()
{
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glUseProgram(shaderProgram);
	glBindVertexArray(VAO);

	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, textureId);

	glUniform1f(glGetUniformLocation(shaderProgram, "width"), width);
	glUniform1f(glGetUniformLocation(shaderProgram, "height"), height);
	glUniform4f(glGetUniformLocation(shaderProgram, "color"), 0.8f, 0.3f, 0.02f, 1.0f);
	glUniform1i(glGetUniformLocation(shaderProgram, "textureSampler"), 0);

	glDrawArrays(GL_TRIANGLES, 0, 6);

	glBindVertexArray(0);
	glBindTexture(GL_TEXTURE_2D, 0);
	glDisable(GL_BLEND);
}
