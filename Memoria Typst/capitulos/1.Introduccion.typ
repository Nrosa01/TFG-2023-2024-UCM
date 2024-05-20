== Motivación

Los simuladores de arena fueron un subgénero emergente durante la década de los noventa, y continuaron siendo populares hasta principios de los años 2000. Durante ese tiempo, surgieron muchos programas y juegos que permitían a la gente interactuar con mundos virtuales llenos de partículas simuladas. Esto atrajo tanto a amantes de la simulación como a desarrolladores de videojuegos. Sin embargo, tras un período de relativa tranquilidad, estamos presenciando un nuevo auge del género de la mano de videojuegos como Noita o simuladores sandbox como Sandspiel.

Este proyecto nace del deseo de sumergirnos en el mundo de los simuladores de arena. Queremos explorar sus diferentes aspectos y características así como entender mejor las ventajas y desventajas de diferentes enfoques de desarrollo de cara al usuario, para así poder contribuir a su evolución y expansión, ya que consideremos que es un subgénero que puede dar muy buenas experiencias de juego y de uso. 

En resumen, queremos entender y ayudar a mejorar los simuladores de arena  para hacerlos más útiles y efectivos para los usuarios.


== Objetivos <Objetivos>

El principal objetivo de este TFG es estudiar el comportamiento y aprendizaje de usuarios haciendo uso de diferentes implementaciones de simuladores de arena. 

Se valorará la funcionalidad de cada implementación haciendo uso de los siguientes parámetros:

- Comparación de rendimiento: se compararán bajo las mismas condiciones, tanto a nivel de hardware como en uso de partículas midiendo el rendimiento final conseguido. Este rendimiento se comparará haciendo uso de razón nº partículas / frames por segundo conseguidos. Idealmente se averiguará la mayor cantidad de partículas que cada simulador puede soportar manteniendo 60 fps.

- Comparación de usabilidad: se estudiará el comportamiento de un grupo de usuarios para valorar la facilidad de uso y de entendimiento de sistemas de ampliación de los sistemas que permitan expansión por parte del usuario. Se valorará la rapidez para realizar un set de tareas asi como los posibles desentendimientos que puedan tener a la hora de usar el sistema.

Con estos análisis, se pretende explorar las características que contribuyen a una experiencia de usuario óptima en un simulador de arena, tanto en términos de facilidad de uso como de rendimiento esperado por parte del sistema. Al comprender mejor estas características, se podrán identificar áreas de mejora y desarrollar recomendaciones para optimizar la experiencia general del usuario con los simuladores de arena.

Nuestro objetivo es encontrar un balance entre rendimiento y facilidad de extensión que proporcione tanto un entorno lúdico a usuarios casuales como una base sólida de desarrollo para desarrolladores interesados en los simuladores de arena. 

== Plan de trabajo

La planificación de trabajo se realizó mayormente entre los autores del TFG, apoyandonos en nuestro tutor mediante reuniones periódicas para ayudarnos a medir nuestro ritmo de trabajo. Al comienzo del proyecto se definieron una serie de tareas necesarias para considerar al desarrollo exitoso. Estas tareas se planificaron en este orden:

- Investigación preliminar sobre los conceptos fundamentales de los autómatas celulares y los simuladores de arena, así como decidir y discutir qué librerias y que software se utilizará.

- Implementación del Simulador en C++, haciendo uso de OpenGL y GLFW: el objetivo de este simulador era tener una base referencial sobre la que apoyarnos a la hora de desarrollar el resto de simuladores, además de permitirnos aplicar de manera un poco más laxa los conocimientos aprendidos en la fase preliminar de investigación sobre autómatas celulares. 

- Desarrollo de Simulador en LUA con LÖVE: el objetivo de esta implementación era aplicar la funcionalidad del sistema anterior añadiendo capacidad de adición de parículas personalizadas por parte del usuario, además de añadir capacidad de multithreading para mejorar el rendimiento.

- Desarrollo de Simulador con ejecución de lógica mediante GPU: el objetivo de esta implementación era tener una referencia a nivel de rendimiento sobre la que comparar el resto de implementaciones, así como explorar la viabilidad de programar el sistema al completo mediante GPU.

- Desarrollo de Simulador en Rust haciendo uso de Macroquad y Blockly para la creación de bloques personalizados: el objetivo de esta implementación era explorar la opción de crear una version cuya accesibilidad mayor para un perfil de usuario no técnico,además de un rendimiento potencialmente superior en comparación a la implementación de LUA.

- Realización de pruebas de usuario: comparar mediante los parámetros mencionados anteriormente @Objetivos[] . 

- Análisis de los datos y comparativa entre los resultados obtenidos por las diferentes implementaciones.

- Conclusiones y trabajo futuro: a partir del análisis de los datos previos, se extraen conclusiones y se explora el potencial para futuras expansiones del proyecto.


