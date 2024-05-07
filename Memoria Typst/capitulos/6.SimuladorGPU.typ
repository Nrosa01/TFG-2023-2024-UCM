Existe una distinción con respecto a las simulaciones anteriores en cuanto al procesado de partículas. En la introducción del capítulo anterior, Simulador CPU @SimuladorCPU/*meter referencia al cap*/,  se declara que la implementación de los simuladores de arena difiere de los automatas celulares en que las partículas pueden observar los cambios que se han producido en otras partículas al momento, sin tener que esperar a que se procesen todas.

Por el funcionamiento y arquitectura de la GPU, cada hilo de ejecución, que procesará una partícula independiente, debe ser completamente ajeno a cambios de las partículas de su alrededor. Podría manejarse también haciendo un uso muy controlado de los hilos, bloques de hilos y de la memoria compartida, pero en cierta manera el establecer tanto control para el actualizado de partículas limitaría la fortaleza de la GPU, que es paralelizar lo máximo posible una tarea. Por lo tanto la aproximación que toma este simulador es de que cada celda sea capaz de determinar su estado en el siguiente frame con solo la información de sus vecinas, de la misma manera que cualquier autómata celular. 

Esto a su vez, trae una serie de problemas, y es que a mayor sea la cantidad de tipos de partículas que existan en el mapa, mas variabilidad habrá a la hora de decidir el siguiente estado de la simulación. Por estos problemas, este proyecto solo dispone de la partícula de arena para probar su funcionamiento.

El procesamiento de partículas se realiza mediante un doble buffer, donde se lee la información de partículas de input, se determina el nuevo estado por partícula, se escribe en el buffer de output y se intercambian los buffers para volver a realizar la misma secuencia. 

La lógica de una partícula de roca que se apilase verticalmente sería el siguiente: 

- Si el hilo esta procesando una partícula vacía , comprueba si encima suyo hay una partícla de roca, en cuyo caso, sobreescribe la partícula actual para que sea una de roca.

- En caso de que esté observando una partícula de roca, solo hay dos opciones, o la partícula inmediatamente inferior es vacía y puede caer, en cuyo caso la posición actual se convierte en vacío, o la partícula inferior es roca y no puede caer. 

Véase que la partícula no se preocupa acerca del comportamiento o estado mas allá de las casillas vecinas , ya que esto implicaría la necesidad de una ejecución secuencial. Este comportamiento provoca que se generen huecos a la hora de colocar partículas, ya que en el aire se van separando de la misma manera que se da en los simuladores de CPU, pero en este caso en se produce esta separación entre todas las lineas de partículas.

Para añadir otros movimientos, en concreto, moverse hacia abajo a la izquierda y abajo a la derecha para añadir comportamiento de arena, es necesario crear un compute shader diferente  y ejecutarlos de manera separada, ya que si se intentase realizar todo el movimiento en una sola pasada, se generarían inconsistencias por obvios motivos. Una partícula, si bien no necesita conocer el estado inmediato de las vecinas, si necesita el inmediatamente anterior para poder determinar su próximo estado. Por lo que el movimiento de una partícula de arena comprueba, según la cantidad de movimiento por frame que tenga que realizar, si se puede mover hacia abajo, y hacia abajo a la izquiera o derecha y se repite el bucle hasta que se terminen los movimientos por realizar.

Esta implementación, a cambio de ser la más rápida en ejecución, no aporta flexibilidad al usuario, ya que el código de lógica de movimiento se ejecuta mediante compute shaders escritos en .GLSL, y requiere trabajo pensar en las interacciones entre partículas.

Se utilizó Vulkano, una librería hecha en Rust que actúa como wrapper de Vulkan como librería gráfica para renderizar partículas debido a la flexibilidad y rendimiento que aporta el tener control sobre el pipeline gráfico a la hora del renderizado. 
Se hizo uso de bevy, motor de videojuegos hecho en Rust para implementar mecánicas básicas como el bucle principal de juego, manejo de interfaces, procesamiento de input etc. 