- [Introducción](#introducción)
  - [CPUs](#cpus)
  - [GPUs](#gpus)
  - [Simulaciones de Partículas](#simulaciones-de-partículas)
  - [Juegos destacables](#juegos-destacables)
    - [Noita](#noita)
    - [Falling Sand Game](#falling-sand-game)
    - [Powder Toy](#powder-toy)
    - [Sandspiel](#sandspiel)
    - [Sandspiel Club](#sandspiel-club)
- [Desafios / Desarrollo (no sé)](#desafios--desarrollo-no-sé)
- [Conclusiones](#conclusiones)
- [Bibliografía](#bibliografía)

# Introducción

Definir objetivo del ensayo, en este caso, comparar rendimiento y arquitectura de simulaciones de partículas no deterministas en CPU y GPU. Aunque mi versión de CPU actual es determinista, podría no serlo en un futuro por optimizaciones. Además, la versión de GPU es no determinista por definición. Este apartado es un mero borrador. Además, tengo dudas de si hablar de CPUs y GPUs al principio o si hablar primero de sistemas de partículas sin entrar en detalles técnicos, pero introducir problemas y pequeñas cosas, como decir que la CPU procesa de forma secuencial y más adelante en el apartado de CPU explicarlo. No estoy seguro la verdad.

- Objetivos y metodología

## CPUs

Antes de poder hablar sobre partículas, es conveniente conocer la arquitectura de las CPUs y GPUs, ya que son las que se encargan de realizar los cálculos y sus diferencias son relevantes para este trabajo. En este apartado se hablará de la arquitectura de las CPUs, mientras que en el siguiente se hablará de las GPUs.

CPU son las siglas proveniente de inglés que significa "Central Processing Unit" o Unidad Central de Procesamiento. Es el cerebro de un ordenador, el encargado de realizar las operaciones lógicas y aritméticas de un programa. En este caso, se va a hablar de la arquitectura de CPU de propósito general, es decir, CPUs que no están diseñadas para un propósito específico, como puede ser una GPU o una FPGA.

Estos dispositivos son lo que posibilita que tengamos ordenadores personales o móviles, que vendrían a ser lo mismo en miniatura. Una de las partes de este ensayo se centra en el aprovechamiento de la CPU, sin embargo, antes de adentrarnos en ello, es necesario conocer su arquitectura y funcionamiento.

A grande rasgos, una CPU lo que hace es recibir una entrada o comando, ejecutar una o varias operaciones y devolver una salida. Esto se puede ver en la siguiente figura:

<Figure>
Entrada => CPU => Salida
</Figure>

Cada vez que un procesador realiza una instrucción, decimos que se ha producido un ciclo de reloj. El reloj es un oscilador que emite una señal periódica, que se utiliza para sincronizar las operaciones de la CPU. El número de ciclos de reloj por segundo se mide en hercios (Hz). El objetivo de los desarrolladores, es usar el menor número de ciclos de reloj posible. Mientras menos ciclos usemos, más rápido se ejecutará nuestro programa, además de que consumiremos menos energía y permitimos que otros programas usen la CPU.

La CPU es idónea para procesar datos secuenciales, es decir, datos que se procesan uno detrás de otro. Pongamos por ejemplo, una serie de operaciones matemáticas, donde el resultado de la operación anterior se usa en la siguiente. Por el contrario, la GPU (de la que se hablará en detalle en el siguiente apartado). Es muy superior a la CPU en el procesamiento de datos paralelos, es decir, datos que se procesan a la vez. Por ejemplo, si tenemos una serie de operaciones matemáticas, donde el resultado de la operación anterior no se usa en la siguiente, la GPU puede realizar todas las operaciones a la vez, mientras que la CPU debe esperar a que se resuelva una operación para pasar a la siguiente.

Las CPUs son muy complejas y apenas se ha cubierto lo más básico de esta. A medida que se profundize en ciertas secciones del ensayo, se explicarán ciertos detalles más sobre su funcionamiento.

## GPUs

Eso para Joni

## Simulaciones de Partículas

Las simulaciones de partículas son un tipo de simulación que se encarga de simular el comportamiento de partículas. Un ejemplo popular es el juego de la vida de Conway

<Figure>

Imagen del juego de la vida de Conway

</Figure>

En este juego, cada partícula o pixel puede estar "vivo" o "muerto". Por convenio, una partícula viva se representa con un color blanco, por el contrario, una partícula muerta se representa con el color negro. El juego de la vida de Conway tiene una serie de reglas simples que se aplican a cada partícula en la simulación en cada frame o iteración lógica.

- Si una partícula viva está rodeada de más de 3 partículas vivas, muere por sobrepoblación.
- Si una partícula viva está rodeada de menos de 2 partículas vivas, muere por soledad.
- Si una partícula muerta está rodeada exactamente de 3 partículas vivas, se convierte en una partícula viva.

Este tipo de simulación de partículas es tiene un nombre en concreto, autómatas celulares. Un autómata celular se [caracteriza por](https://puga.uaz.edu.mx/project/que-es-un-automata-celular/)

(No sé si debería explicar los siguientes puntos, imagino que sí pero a este ritmo la mitad del TFG va a ser explicar sobre que se fundamente más que lo que hemos hecho en sí)

- Espacio regular
- Conjunto de estados **finito**
- Configuración inicial
- Vecindades
- Función de transición local

A continuación vermos una serie de simulaciones y/o juegos en los que se basa nuestro trabajo y fueron nuestra fuente de inspiración.

## Juegos destacables

### Noita

Noita es un juego de acción roguelite en 2D desarrollado por Nolla Games y publicado por Devolver Digital. El juego utiliza un motor de física basado en píxeles que permite a los jugadores manipular libremente el entorno. El juego fue desarrollado por cuatro personas, Petri Purho, Olli Harjola, Arvi Teikari y Juha Kangas. El juego fue inspirado, entre otros, por Powder Game.

Noida se caracteriza por tener un amplio catálogo de partículas, finito, pero extenso. Admeás, a diferencia de otras simulaciones, esta no es un simple sandbox, es un juego completo, que además tiene un sistema de físicas. Todo es destructible, todo son partículas.

<Figure>

Iimagen de Noita

</Figure>

El rango de interacciones es amplio como es esperable en esta clase de juegos o simulaciones, agua, fuego, lava, electricidad, ácido, veneno, aceite, sangre, pólvora...

### Falling Sand Game

Enlace: https://dan-ball.jp/en/javagame/dust/
Información: https://danball.fandom.com/wiki/Powder_Game (si, es un enlace a fandom, pero es la única fuente que he encontrado)

A diferencia de Noita, este juego es un sandbox, no tiene un objetivo, simplemente es un juego de simulación de partículas. El juego tiene un conjunto de partículas más reducido que Noita, pero aún así, es bastante amplio. Además, tiene un sistema de físicas, aunque no tan complejo como el de Noita. Puedes poner viento, burbujas, ruedas y otros elementos que no son directamente partículas, pero que interactuan con ellas. Además, el juego soporta entrada de teclado, hay un elemento especial llamado "Player" que invoca un cubito con piernas que puedes controlar con el teclado, es un control muy pocho basado en ragdoll, pero interactúa con la mayoría de partículas.

Además, al ser un juego web, permite el registro del usuario para guardar el estado de la simulación, además, dicho estado puede compartirse con otros usuarios.

(No tengo ni idea de como funcionan algunas partículas de ese juego, me da mucha curiosidad)

### Powder Toy

Powder Toy es actualmente el sandbox de simulación de partículas más completo y complejo. No solo tiene un catálogo de partículas mucho más amplio que lo ejemplos anteriores, las partículas reaccionan al entorno en función de fenómenos físicos tales como la temperatura, presión, gravedad, fricción, conductividad, densidad, viento...

Explicar más en profundidad

### Sandspiel

Este juego de simulación de arena lo conocimos realizando este proyecto (no sé si eso es algo relevante o algo que se debería mencionar). Este es mucho más simple que los anteriores, siendo lo más destacable que este proyecto está escrito en Rust y compilado a webassembly. A parte de las partículas elementales básicas tiene un elemento aire que no es una partícula. Tienen un blog [en el que explica su desarrollo](https://maxbittker.com/making-sandspiel)

### Sandspiel Club

Esta simulación es el sucedor de Sandspiel y fue una fuente de inspiración para nuestro proyecto. A diferencia de Sandspiel, este proyecto no se enfoca en tener un sistema pequeño pero muy bien optimizado. Este proyecto está enteramente escrito en javascript y tiene la particularidad de que permite a los usuarios crear sus propias particulas mediante un sistema de scripting visual basado en la librería blockly de Google, con la única restricción de que el máximo de partículas a tener es 16. Además, al igual que powder game, este permite guardar el estado de la simulación y compartirlo con otros usuarios. Sin embargo, ya no hay viento como en la versión anterior, todo en este sandbox son partículas.

# Desafios / Desarrollo (no sé)

Hablar, por mi parte, de las complejidades de diseñar un sistema de particulas, optimización, multithreading y lo más importante, extensiones y sistemas de plugins, además de como esto provoca que a un nivel teórico-matemático, sea dudoso considerar este sistema un autómata celular, ya que al ser extensible, el conjunto de estados no es finito. Se podría considerar que es un sistema que admite diferentes configuraciones o estados iniciales.

- Arquitectura del sistema
- Implementacion
- Optimizacion
- Pruebas y resultados
- Comparacion con otros sistemas (GPU)
- Trabajo a futuro


# Conclusiones

# Bibliografía


----------

Prototipo estructura 2

1. **Introducción**
    - Objetivos de la tesis
    - Metodología

2. **Antecedentes**
    - Definición y conceptos básicos de la simulación de partículas
    - Autómatas celulares

3. **Conceptos Básicos de Hardware**
    - CPU
    - GPU
    - Caché

4. **Análisis de sistemas existentes**
    - Powder Toy
    - Sandspiel
    - Sandspiel Club
    - (Introdocir algún sistema de partícula en GPU)

5. **Desarrollo de la simulación de partículas**
    - Arquitectura del sistema
    - Implementación
    - Optimización
    - Pruebas y resultados
    - Comparación con otros sistemas (GPU)

6. **Desafíos y complejidades**
   1. CPU
    - Diseño de un sistema de partículas
    - Multithreading
    - Extensiones y sistemas de plugins
    - Persistencia del estado de la simulación
    - Consideraciones teóricas y matemáticas
    - Intentos fallidos
   2. GPU
    - Implementación en la GPU
    - Diferencias con la CPU
    - Ventajas y desventajas
    - Comparación con la CPU

7. **Trabajo a futuro**
    - Mejoras propuestas
    - Funcionalidades adicionales

8. **Conclusiones**
    - Resumen de los hallazgos
    - Impacto de la investigación (en otras memorias tienen este apartado, pero en nuestro caso...)

9.  **Bibliografía**
    - Referencias

10. **Apéndices** (no sé si es necesario por como vamos a usar latex)
    - Código fuente
    - Diagramas detallados
    - Datos de prueba y resultados