#import "../utilities/gridfunc.typ": *
#import "../data/gridexamples.typ": *
#import "../data/data.typ": *

Ejecutar una simulación de partículas en la GPU supone un desafío. Como se explicó en la @simuladoresArena, y se mencionó en la @SimuladorCPU, los simuladores de arena de por sí no son paralelizables, ya que son dependientes del orden de ejecución y cada celda puede potencialmente modificar al resto de celdas de la matriz. Sin embargo, es posible, reescribiendo las condiciones de evolución de las partículas, transformar un simulador de arena en un autómata celular. Para ello, hay que volver del concepto de partícula al de celda. Esto supone que cada celda tiene que poder conocer su próximo estado mediante reglas locales con sus vecinas, y cada celda solo se modificará a sí misma.

Tomando de nuevo el ejemplo de la @simuladoresArena de simulador básico con un solo tipo de partícula, la de arena, se va a mostrar como se puede convertir este simulador en un autómata celular con un comportamiento similar. Cada celda de este autómata celular solo tiene dos estados, vacío y arena.

La partícula de arena necesita tener el siguiente comportamiento: 
- Si la celda de abajo esta vacía, me muevo a ella.
- En caso de que la celda de abajo esté ocupada por una partícula de arena, intento moverme en dirección abajo izquierda y abajo derecha si las celdas están vacías.
- En caso de que no se cumpla ninguna de estas condiciones, la partícula no se mueve.

Ahora, tomando cada celda como entidad aislada, se puede lograr un comportamiento similar de la siguiente forma:

- Si la celda es una partícula vacía, comprueba si encima suyo hay una partícla de arena, en cuyo caso, la celda se convierte en una partícula de arena. 

- Si la celda es una partícula de arena, solo existen dos opciones:
  - La celda inmediatamente inferior es vacía, por lo tanto puede caer. La celda actual se convierte en vacía.
  - La celda inferior es arena. En este caso, no es posible saber en el mismo paso de la simulación si la celda inferior también puede caer, por lo que la celda no se mueve y se queda como partícula de arena. Nótese que esto provoca que se produzcan artefactos visuales entre partículas al caer, de manera similar a lo que sucedía en la simulación de Lua con multithreading cuando una partícula se movía fuera de la región en la que se estaba ejecutando. Solo que en este caso, se producen entre todas las partículas en todo momento, ya que cada celda es un hilo de ejecución separado. Se puede observar que caen en líneas horizontales con espacios entre ellas.

#grid_example("Artefactos visuales", (gpu_01,gpu_03,gpu_04), vinit: 0pt)

Para realizar movimientos diagonales, se llevan a cabo las mismas comprobaciones que para el movimiento de caída vertical. Sin embargo, en lugar de verificar las celdas ubicadas arriba y abajo, se realizan comprobaciones en las direcciones arriba derecha, abajo izquierda y arriba izquierda, abajo derecha respectivamente.

Desde el punto de vista de desarrollo, para poder ejecutar estas instrucciones de movimiento en la GPU, es necesario programar las reglas de movimiento dentro de un compute shader. Éste recibe como input el estado de la simulación actual y devuelve como output el estado de la simulación tras realizar uno de los tres movimientos. 

Cada comprobación de movimiento se realiza de manera separada, es decir, se ejecuta el compute shader de movimiento hacia abajo, y el output de éste lo procesa el compute shader de movimiento diagonal. Es necesario, a su vez, separar la lógica de movimiento abajo derecha y abajo izquierda ya que no sería posible realizar el movimiento hacia ambas diagonales en un solo paso de simulación. Dado el siguiente estado de la matriz:

#grid_example("Ejemplo problema movimiento diagonal", (gpu_02,), vinit: -80pt)

Tanto la partícula de arriba a la izquierda como la de arriba a la derecha pueden moverse a la celda central, sin embargo, la celda central, que es la que tiene que decidir si en el siguiente paso de la simulación existe materia o no en esa posición, no puede saber si alguna de esas partículas se va a mover a esa posición, ninguna de ellas, o ambas.

Esta implementación, a cambio de ser la más rápida en ejecución, como ya se verá en el capítulo de comparaciones, no aporta flexibilidad de ampliación alguna al usuario, ya que el código de lógica de movimiento se ejecuta mediante compute shaders escritos en .GLSL, lo cual es una tarea que puede ser complicada incluso para programadores que no tengan muchos conocimientos de informática gráfica y programacion de GPUs. A su vez, otro problema que presenta esta implementación es que el añadir partículas e interacciones entre ellas requiere mucho más trabajo que sus contrapartes en CPU, ya que requiere transformar las normas de movimiento y de interacciones entre partículas a reglas locales de celdas. La dificultad que presenta ampliar este sistema ha hecho que actualmente solo tenga implementada la partícula de arena.

Se utilizó Vulkano @vulkano, una librería hecha en Rust que actúa como wrapper de Vulkan @vulkan, como librería gráfica para renderizar partículas debido a la flexibilidad y rendimiento que aporta el tener control sobre el pipeline gráfico a la hora del renderizado. 
Se hizo uso de Bevy @bevy, motor de videojuegos hecho en Rust, para implementar mecánicas básicas como el bucle principal de juego o procesamiento de input y de Egui @egui para crear la interfaz. 





