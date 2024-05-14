== Motivation

Sand simulators were a prominent subgenre during the 1990s, and remained popular until the early 2000s. During that time, many programs and games emerged that allowed people to interact with virtual worlds filled with simulated particles. This attracted both simulation lovers and video game developers. However, after a period of relative calm, we are witnessing a renaissance of the genre thanks to video games like Noita or sandbox simulators like Sandspiel.

This project comes from the desire to immerse ourselves in the world of sand simulators. We want to explore its different aspects and characteristics as well as better understand the advantages and disadvantages of different development approaches for the user, in order to contribute to its evolution and expansion, since we consider that it is a subgenre that can provide very good gaming and user experiences.

In short, we want to understand and help improve arena simulators to make them more useful and effective for users.

== Objectives <Objectives>

The main objective of this TFG is to study the behavior and ease of learning of different users using different implementations of sand simulators.

The functionality of each implementation will be assessed using the following parameters:

- Performance comparison: they will be compared under the same conditions, both at the hardware level and in the use of particles, measuring the final performance achieved. This performance will be compared using the ratio of number of particles / frames per second achieved. Ideally, you will find out the largest number of particles that each simulator can support while maintaining 60 fps.

- Comparison of usability: the behavior of a group of users will be studied to assess the ease of use and understanding of expansion systems that allow expansion by the user. The speed of completing a set of tasks will be assessed, as well as any possible misunderstandings they may have when using the system.

With these analyses, we aim to explore the characteristics that contribute to an optimal user experience in an arena simulator, both in terms of ease of use and expected performance of the system. By better understanding these characteristics, areas for improvement can be identified and recommendations developed to optimize the overall user experience with arena simulators.

Our goal is to find a balance between performance and extensibility that provides both a playful environment for casual users and a development base for developers interested in arena simulators.

== Work plan

Work planning was mostly carried out between the authors of the TFG, relying on our tutor through regular meetings to help us measure our work pace. At the beginning of the project, a series of tasks were defined as necessary for successful development. These tasks were planned in this order:

- Preliminary research on the fundamental concepts of cellular automata and sand simulators, as well as deciding and discussing which libraries and software will be used.

- Implementation of the Simulator in C++, using OpenGL and GLFW: the aim of this simulator was to have a reference base to support us when developing the rest of the simulators, as well as allowing us to apply in a slightly more lax way the knowledge learned in the preliminary research phase on cellular automata.

- Development of Simulator in LUA with LÖVE: the aim of this implementation was to apply the functionality of the previous system by adding the ability for the user to add custom particles, as well as adding multithreading capability to improve performance.

- Development of Simulator with logic execution through GPU: the aim of this implementation was to have a performance reference to compare the rest of the implementations, as well as to explore the viability of programming the entire system through GPU.

- Development of Simulator in Rust using Macroquad and Blockly for the creation of custom blocks: the aim of this implementation was to explore the option of creating a version with greater accessibility for a non-technical user profile, as well as potentially superior performance compared to the LUA implementation.

- User testing: compare using the parameters mentioned above @Objectives[].

- Analysis of the data and comparison between the results obtained by the different implementations.

- Conclusions and future work: from the analysis of the previous data, conclusions are drawn and the potential for future project expansions is explored.