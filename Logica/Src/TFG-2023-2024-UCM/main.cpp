#include <iostream>
#include "App.h"

// Main code
int main(int, char**)
{
	_CrtSetDbgFlag(_CRTDBG_ALLOC_MEM_DF | _CRTDBG_LEAK_CHECK_DF); //Hay que estar en Debug
	App app;
	srand(time(NULL));
	if (!app.init())
	{
		app.release();
		return 1;
	}

	app.run();

	app.release();
	return 0;
}
