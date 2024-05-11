En este capítulo se detalla la aportación de cada uno de los alumnos en el desarrollo del proyecto. 

== Nicolás Rosa Caballero

#text(red)[Según la normativa hay que sacar 4 páginas de esto, 2 cada uno pero a pesar de que consider que he hecho muchísimas cosas enumerarlas no ocupa tanto espacio. Además de que estoy poniendo solo lo que al final se ha quedado, hay cosas que al final se descartaron u otras que no pero que fueron problemáticas y llevaron mucho tiempo. Esta simple enumeración no refleja el esfuerzo que ha llevado cada una de estas tareas.]

#text(red)[Trato de hablar impersonal en este apartado pero dado que es un apartado de contribuciones no sé si sería posible hablar en primera persona.]

Existen 3 aportaciones principales de Nicolás al proyecto:

- Simulador en C++

Se realizó la maquetación inicial del proyecto, así como la implementación de OpenGL, GLFW y IMGUI. Además, se encargó de la implementación de la lógica inicial de la simulación de arena y la interacción con el usuario. Se implementaron las particula básicas para este modelo: Arena, Agua, Ácido, Roca, Aire y Gas. Se creó e implementó parte del sistema de interacciones entre partículas. Se realizaron las optimizaciones y revisiones del código pertinentes para asegurar que la implementación sea un buen referente comparativo para el resto de implementaciones.

- Simulador en Lua con Love2D

Esta implementación fue completamente realizada por Nicolás. Para ello se implementó la lógica de la simulación de arena, el API de interacción de partículas, la interfaz con IMGUI, un sistema de entidades para manejar distintos objetos del programa y el sistema multithreading. Para el sistema multithreading se diseñó un sistema de comunicación y sincronización entre threads mediante canales. También se implementó un sistema de procesamiento basado en doble buffer para lidiar con las condiciones de carreras y asegurar la consistencia de los datos. Finalmente se elaboró un documento introductorio a Lua que describe el API del sistema para que los usuarios tuvieran una referencia de como extender el simulador.

- Simulador en Rust con Macroquad

Al igual que en la implementación anterior, todo el código fue escrito por Nicolás. Sin embargo, aunque la base inicial del proyecto fue realizada en solitario, el desarrollo de los plugins web fue asistido por Jonathan. Nicolás diseño la arquitectura del proyecto basada en plugins y el soporte para poder serializar y deserializar datos de un fichero JSON. También implementó la lógica que interpreta dichos datos, así como el API que mediante instrucciones se representa en Blockly como bloques. Este API puede ser usado también por partículas programadas en Rust compiladas a DLLs.

- Web Vue3 envoltorio del ejecutable de Rust

La web fue realizada en su mayoría por Nicolás, siendo la mayor excepción Blockly, en lo cual solo se ayudó a su integración en el sitio y comunicación con el binario mediante código pegamento de JavaScript. El diseño de la web, botones de partículas, sonidos, menú de ayuda, gestos, sistema de guardado y cargado de plugins, integración continúa y logo fueron implementados por Nicolás.

- Memoria

#text(red)[No sé si este apartado es necesario]

Nicolás creó la estructura de la memoria, la portada, el índice, la sección de autómatas celulares (mas no la de simuladores de arena), la sección de Plugins y Lenguajes de scripting, la sección de CPU y multithreading, la sección de Simualdor en CPU y parte de las secciones de comparación y conclusiones.

== Jonathan Andrade Gordillo

- Simulador en C++

Configuración incial del proyecto así como configurado de solución, proyecto y biblicotecas

Implementación de partículas iniciales como agua, roca y gas

Asistido en la interaccion con el usuario añadiendo pincel ajustable

Añadido propiedades físicas a las particulas como la densidad, permitiendo movimiento que se ajuste a estos parámetros

Investigación de sistema alternativo de interaccion entre partículas

Solución de bugs a lo largo del desarrollo

- Simulador en Rust con Vulkan haciendo uso de GPU

Investigación de posibles formas de hacer uso de la GPU para el cálculo de la lógica

Desarrollo de pipeline gráfico básico haciendo uso de Vulkan

Implementación de partícula de arena 

Investigación y desarrollo de compute shaders que permitan delegar el movimiento a la GPU


- Blockly para simulador de Rust

Investigación sobre las necesidades del proyecto y los requisitos del módulo de Blockly.

Creación de todos los bloques presentes en el proyecto, así como de los posibles mutadores que necesiten a excepcion de uno

Ajuste del toolbox para incluir los bloques desarrollados

Implementación de los generadores para cada bloque creado, aunque algunos de ellos tuvieron que ser corregidos más tarde junto a Nicolás de

Colaboración con mi compañero para incluir Blockly en la página web