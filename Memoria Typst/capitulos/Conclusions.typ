The Lua implementation turns out to be very versatile given its performance and ease of use considering a technical profile. For use in video games this option can be viable with a little more work to simulate only groups of active particles and not all the particles in memory.

The web simulation is suitable for small sized simulations. Due to its user-friendly interface this implementation can be used to teach basic programming and simulation concepts, as well as an introduction to sand and cellular automata simulators.

Developing GPU simulators turns out to be a good option when high computational power is required or when the size of the simulation is very large, but implementing new behaviors is complicated.

As future work there are several tasks and extensions that can be done. Firstly, in the web simulation, vector calculation could be added, this would allow to perform operations with particles that are far away and not only within the immediate neighbors. It would also be interesting to replicate the web simulation with native code to achieve higher performance. In addition, this would allow exploring the possibility of generating GLSL code from the block interface to be able to run the simulation on GPU. Accomplishing this would involve creating a Blockly-like visual programming interface from scratch.

The web simulation could be modified so that its processing is similar to that of a cellular automaton as in the Lua implementation, this would allow to create the game of life, since in the current state it is not possible.

The Lua implementation could be improved by adding more data for the particles, since currently they only have the `clock` and `id` variables. If this extension were realized, it would be possible to create the aforementioned native visual programming interface to be able to generate Lua code.