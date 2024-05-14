#import "../utilities/gridfunc.typ": *
#import "../data/gridexamples.typ": *
#import "../data/data.typ": *

== Simuladores de arena <simuladoresArena>

En esta sección, se hablará de manera resumida acerca de qué son los simuladores de arena y su funcionamiento. Más tarde, se presentan una serie de antecedentes que se han tomado de base para el desarrollo del proyecto.

=== Introducción

Los simuladores de arena son simuladores cuyo  
objetivo es representar con precisión interacciones dinámicas entre elementos físicos como granos de arena u otros materiales granulares presentes en el mundo real. Estos comparten muchas similitudes estructurales y conceptuales con los autómatas celulares.

El "mapa" de la simulación está formado por un conjunto de celdas dentro de un número finito de dimensiones, representado como una matriz. Cada una de estas celdas se encuentra, en cada paso discreto de la simulación, en un estado concreto dentro de un número finito de estados en los que puede encontrarse. Cada uno de estos estados representa el tipo de la partícula que se encuentra en la celda.

Sin embargo, a diferencia de los autómatas celulares, donde la evolución de cada celda está estrictamente determinada por reglas locales con sus celdas vecinas y pueden procesarse todas las partículas sin seguir un orden específico, un simulador de arena funciona de manera secuencial y no determinista. El estado futuro de una celda no solo es influenciado por el estado de sus celdas vecinas, sino también por el orden en que las partículas son procesadas. Además, el procesar una celda, no necesariamente se limita a afectar solo a esa celda. Por ejemplo, el simular fenómenos físicos como la gravedad, implica mover partículas por la matriz de celdas, fenómeno no contemplado en los autómatas celulares. 

En un simulador de arena, pueden existir multitud de tipos de partículas, cada una con unas reglas distintas de evolución e interacción con otras celdas de la matriz, lo que puede dar lugar a ejecuciones con dinámicas muy complejas. Para explicar el funcionamiento de los simuladores de arena, se tomará un ejemplo básico de un simulador que contenga solo un tipo de partícula, la de arena. Esta partícula tiene el siguiente comportamiento:

- Si la celda de abajo esta vacía, me muevo a ella.
- En caso de que la celda de abajo esté ocupada por otra partícula, intento moverme en dirección abajo izquierda y abajo derecha, si las celdas están vacías.
- En caso de que no se cumpla ninguna de estas condiciones, la partícula no se mueve.

#grid_example("Ejemplo de simulador de arena", (sand_simulator_01, sand_simulator_02, sand_simulator_03, sand_simulator_04), vinit: 1pt)

Esta ejecución toma como base un orden de ejecución de abajo a arriba y de derecha a izquierda. Para un orden de ejecución de arriba a abajo y de izquierda a derecha el resultado sería el siguiente.

#grid_example("Ejemplo de simulador de arena, diferente orden", (sand_simulator_lr_01, sand_simulator_lr_02, sand_simulator_lr_03, sand_simulator_lr_04), vinit: 1pt)

Como puede verse, el orden en el que se procesan las celdas de la matriz afecta al resultado final.

=== Simuladores de arena dentro de los videojuegos

Dentro de la industria de los videojuegos, se han utilizado simuladores de arena con diferentes fines, como pueden ser mejorar la calidad visual o aportarle variabilidad al diseño y jugabilidad del propio videojuego.

Este proyecto toma como principal referencia a "Noita", un videojuego indie roguelike que utiliza la simulación de partículas como núcleo principal de su jugabilidad. En "Noita", cada píxel en pantalla representa un material y está simulado siguiendo unas reglas físicas y químicas específicas de ese material. Esto permite que los diferentes materiales sólidos, líquidos y gaseosos se comporten de manera realista de acuerdo a sus propiedades. El jugador tiene la capacidad de provocar reacciones en este entorno, por ejemplo destruyéndolo o haciendo que interactúen entre sí.


#figure(
  image("../images/Noita.png", width: 50%),
  caption: [
    Imagen gameplay de Noita
  ],
)

Noita no es el primer videojuego que hace uso de los simuladores de partículas. A continuación, se enumeran algunos de los títulos, tanto videojuegos como sandbox, más notables de simuladores de los cuales el proyecto ha tomado inspiración durante el desarrollo.

- Falling Sand Game @falling_sand_game
Probablemente el primer videojuego comercial de este subgénero. A diferencia de Noita, este videojuego busca proporcionarle al jugador la capacidad de experimentar con diferentes partículas físicas así como fluidos y gases, ofreciendo la posibilidad de ver como interaccionan tanto en un apartado físico como químicas. Este videojuego estableció una base que luego tomaron otros videojuegos más adelante.
- Powder Toy @powder_toy
Actualmente el sandbox basado en partículas más completo y complejo del mercado. Este no solo proporciona interacciones ya existentes en sus predecesores, como Falling Sand Game, sino que añade otros elementos físicos de gran complejidad como pueden ser temperatura, presión, gravedad, fricción, conductividad, densidad, viento etc.
- Sandspiel @sandspiel
Este proyecto utiliza la misma base que sus predecesores, proporcionando al jugador libertad de hacer interaccionar partículas a su gusto. Además, añade elementos presentes en Powder Toy como el viento, aunque la escala de este proyecto es mas limitada que la de proyectos anteriores. De Sandspiel, nace otro proyecto llamado Sandspiel Club @sandspiel_club, el cual utiliza como base Sandspiel, pero, en esta versión, el creador porporciona a cualquier usuario de este proyecto la capacidad de crear partículas propias mediante un sistema de scripting visual haciendo uso de la librería Blockly @blockly de Google. Además, similar a otros títulos menos relevantes como Powder Game (no confundir con Powder Toy), es posible guardar el estado de la simulación y compartirla con otros usuarios.

//habria que ser consistentes con estas introducciones, o se ponen en todos lados o no se pone en ninguno
#text(weight: "bold")[Proximo capítulo]

Cuanto más grande sea el tamaño de la matriz que represente el estado de un autómata celular, menor será el rendimiento, ya que procesar las reglas de evolución de cada una de las celdas de manera secuencial, que es la forma que tiene la CPU de ejecutar instrucciones, llega a resultar muy costoso a medida que aumenta el número de celdas. Sin embargo, se puede aprovechar una particularidad de los autómatas celulares, y es que el cálculo de evolución de cada celda es independiente del cálculo de evolución del resto de celdas. Este tipo de problemas se conoce comúnmente como 'Embarrassingly parallel', problemas donde la sub-separación de una tarea grande en tareas muy pequeñas independientes entre ellas es obvia o directa.

Esto no ocurre de manera tan directa en los simuladores de arena, donde el orden de ejecución de las celdas afecta al resultado final, aunque se verá en el @SimuladorGPU cómo modificando un poco las reglas, se puede conseguir transformar un problema de simulación de partículas en un problema 'Embarrassingly parallel'.

Existe un componente de ordenador que, por su arquitectura, es muy eficaz en la resolución de este tipo de problemas. Este componente se llama GPU, y se hablará de él a continuación. 

