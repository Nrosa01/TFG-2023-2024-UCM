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

The work methodology to be used will be a variant of Scrum tailored to our needs. A task board will be created to reflect the tasks to be performed, the status of each task, and the estimated time for their completion. There will be no daily meetings, but to-do tasks will be assigned weekly, along with weekly meetings to review the project status and adjust the task board accordingly.

Additionally, bi-weekly meetings with the supervisor are planned to review the project status and receive feedback on the work done, as well as guidance on future tasks.

Regarding the work, the first step will be to conduct preliminary research on the fundamental concepts of cellular automata and sand simulators, as well as existing systems to understand how problems have been approached in the past. This research is expected to take approximately two months.

After this, four implementations are planned:

- Base native simulation: This will be the simulation used as the baseline for comparing the others. It must be efficient and establish the foundations of particle processing. This implementation will be difficult to expand due to this. It is expected to be implemented in C or C++ due to familiarity with the language. This implementation is expected to take between one and one and a half months.

- GPU simulation: This implementation will be done in a programming language that allows GPU code execution, such as CUDA or OpenCL. The goal of this implementation is to explore the feasibility of performing particle simulation on the GPU and to compare its performance with the other implementations. This implementation is also expected to be difficult to expand. It is expected to be completed in one month.

- Native simulation extended with a scripting language: It will be necessary to research and choose a scripting language that allows the base simulation to be easily extended while maintaining the highest possible performance. This implementation is expected to take between one and two months.

- Simulation accessible via visual programming language: Libraries and frameworks that allow code or data to be defined through visual programming will be investigated. This implementation is expected to be the easiest to expand and the most accessible for non-technical users. The possibility of running this simulation on the web for greater accessibility will be explored. This implementation is expected to take between one and two months.

The possibility of creating more simulators will be considered if the research reveals an alternative that adds value to the comparison.

After completing the different implementations, user tests will be conducted to compare the results obtained from each. The data obtained will be analyzed, and the results will be compared to draw conclusions about the advantages and disadvantages of each implementation. These tests are expected to take two to three weeks.

== Relevant links

#set text(10pt)

Project repository: https://github.com/Nrosa01/TFG-2023-2024-UCM

Base C++ simulation: https://youtu.be/Z-1gW8dN7lM

GPU simulation: https://youtu.be/XyaOdjyOXFU

Simulation with Lua: https://youtu.be/ZlvuIUjA7Ug

Web simulation with Blockly: https://youtu.be/obA7wZbHb9M