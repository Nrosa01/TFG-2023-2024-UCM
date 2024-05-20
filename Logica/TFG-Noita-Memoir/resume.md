# Portada

# Resumen

Este trabajo de fin de grado presenta una comparación entre diferentes soluciones en términos de computación respecto a la simulacion de particulas en un entorno 2D:

- Simulación generalista desarrollada con C++ y OpenGL
- Simulación dirigida por datos en LUA y LOVE
- Simulación dirigida por código en Rust y Vulkano

Las distintas versiones desarrolladas han tenido distintos origenes a la vez que diferentes objetivos , condicionadas por diversas limitaciones fisicas (hardware) y digitales (software). Más adelante se hablará en mayor detalle de cada versión y sus limitaciones.

## Palabras clave

Hardware:parte física y tangible de un sistema informático
Software: programas, aplicaciones y datos que son utilizados por un sistema informático
Cellular automata:modelos matemáticos y computacionales que consisten en una cuadrícula discreta de celdas, cada una con un estado específico. Estas celdas evolucionan en el tiempo siguiendo reglas predefinidas basadas en el estado de las celdas vecinas
Core/Nucleo: unidad de procesamiento independiente para la ejecución de tareas de manera simultánea.

# Indice

- [Portada](#portada)
- [Resumen](#resumen)
  - [Palabras clave](#palabras-clave)
- [Indice](#indice)
- [Estructura de capítulos](#estructura-de-capítulos)
- [Capitulo 1](#capitulo-1)
- [Introduccion](#introduccion)
  - [Motivacion](#motivacion)
  - [Antecedentes](#antecedentes)
    - [Noita](#noita)
    - [Falling Sand Game](#falling-sand-game)
    - [Powder Toy](#powder-toy)
    - [Sandspiel](#sandspiel)
    - [Sandspiel Club](#sandspiel-club)
  - [Objetivos](#objetivos)
    - [Objetivos iniciales](#objetivos-iniciales)
    - [Objetivos nacidos durante el desarrollo](#objetivos-nacidos-durante-el-desarrollo)
    - [Plan de trabajo](#plan-de-trabajo)
- [Capitulo 2](#capitulo-2)
  - [Fundamentos y contexto](#fundamentos-y-contexto)
  - [Introduccion](#introduccion-1)
  - [CPUs](#cpus)
  - [GPUs](#gpus)
  - [Simulaciones de Partículas](#simulaciones-de-partículas)
- [Resultados](#resultados)
- [Conclusiones](#conclusiones)
  - [Cositas](#cositas)

# Estructura de capítulos

aun no tenemos una base de capitulos asi que me voy a ahorrar el "resumirlos"

# Capitulo 1

# Introduccion

## Motivacion

La primera aparición de un videojuego/simulador perteneciente al hoy subgenero de simuladores de arena data del 2005 con la creación del juego "World of Sand" por Dofi Blog. Este juego permitía a los usuarios manipular varios elementos como arena, agua, fuego, etc, y observar cómo interactuaban entre sí. Sin embargo, es importante destacar que podría haber proyectos similares anteriores que no hayan recibido la misma atención.

Desde entonces se han llevado a cabo numerosas iteraciones de la misma idea; darle a un usuario la capacidad de hacer interaccionar diferentes materiales de la manera más libre posible.

Con el paso de los años, por motivos obvios como el simple avance de la capacidad del hardware, las iteraciones de la idea han ido mejorando poco a poco, siendo algunas iteraciones de este concepto: wxSand, This is Sand, The powder toy, the sandbox, sandspiel y por último, nuestra inspiracion inicial para desarrollar este proyecto, Noita.

Noita lleva la simulación de arena a otro nivel, creando un entorno procedural navegable donde un mago avanza por diferentes niveles y mazmorras donde todo el terreno esta formado por particulas potencialmente interactuables.

Nuestro objetivo inicial con este proyecto fue el crear un simulador físico y químico que se asemejase a los de Noita con obvias limitaciones debido a los recursos y tiempo necesarios que tomaría crear una simulación de la escala de Noita.

## Antecedentes

(Además de hablar de videojuegos aqui hay que hacer mencion a papers, charlas, libros etc los cuales ya estaban establecidos cuando hemos empezado y de los cuales hemos tomado inspiracion o dirección)

Algunas de las demostraciones más notables de simuladores de partículas son:

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

## Objetivos

### Objetivos iniciales

Nuestro objetivo principal al iniciar el proyecto era el desarrollo y familiarizacion con el funcionamiento de la mecánica principal del videojuego Noita.

De este modo, el objetivo se descomponía en varias metas de desarrollo:
La creación de un mundo creado enteramente a través de partículas independientes
La habilitación de este mundo a ser navegable por un jugador, con los respectivos requerimientos que ello supone, como el manejo de cámara, el guardado y cargado de partidas, la optimización de carga de zonas de juego en pantalla, etc.
Y por supuesto hacer todo con el mayor rendimiento posible, ya que comprendíamos desde un primer momento la dificultad de rendimiento que supone el crear un mundo donde se ejecuta una simulación para cada pixel en pantalla

### Objetivos nacidos durante el desarrollo

Durante el progreso de desarrollo, nuestra meta cambió a medida que analizamos el propósito de nuestro proyecto.

(Aqui no se muy bien como contarlo o separarlo sin que suene a : nos dio la gana cambiar el objetivo por que sí)

Realizamos múltiples iteraciones donde se buscaban objetivos diferentes, (...)

### Plan de trabajo

Aqui hay que contar como teniamos planeado el desarrollo y demás, no teniamos un plan inicial escrito en piedra asi que no se muy bien como contarlo, ya lo haremos cuando hayamos terminado

# Capitulo 2

## Fundamentos y contexto

Para entender de manera exitosa nuestro proyecto de desarrollo, hace falta la exposición de ciertos conceptos y fundamentos con los cuales el lector puede no estar familiarizado.

## Introduccion

Antes de poder hablar sobre partículas, es conveniente conocer la arquitectura de las CPUs y GPUs, ya que son las que se encargan de realizar los cálculos y sus diferencias son relevantes para este trabajo.
Tambien es conveniente

## CPUs

CPU son las siglas proveniente de inglés que significa "Central Processing Unit" o Unidad Central de Procesamiento. Es el cerebro de un ordenador, el encargado de realizar las operaciones lógicas y aritméticas de un programa. En este caso, se va a hablar de la arquitectura de CPU de propósito general, es decir, CPUs que no están diseñadas para un propósito específico, como puede ser una GPU o una FPGA.

Estos dispositivos son lo que posibilita que tengamos ordenadores personales o móviles, que vendrían a ser lo mismo en miniatura. Una de las partes de este ensayo se centra en el aprovechamiento de la CPU, sin embargo, antes de adentrarnos en ello, es necesario conocer su arquitectura y funcionamiento.

A grande rasgos, una CPU lo que hace es recibir una entrada o comando, ejecutar una o varias operaciones y devolver una salida. Esto se puede ver en la siguiente figura:

<Figure>
Entrada => CPU => Salida
</Figure>

Cada vez que un procesador realiza una instrucción, decimos que se ha producido un ciclo de reloj. El reloj es un oscilador que emite una señal periódica, que se utiliza para sincronizar las operaciones de la CPU. El número de ciclos de reloj por segundo se mide en hercios (Hz). El objetivo de los desarrolladores, es usar el menor número de ciclos de reloj posible. Mientras menos ciclos usemos, más rápido se ejecutará nuestro programa, además de que consumiremos menos energía y permitimos que otros programas usen la CPU.

(este parrafo o lo borraria o lo resumiria en la introduccion)
La CPU es idónea para procesar datos secuenciales, es decir, datos que se procesan uno detrás de otro. Pongamos por ejemplo, una serie de operaciones matemáticas, donde el resultado de la operación anterior se usa en la siguiente. Por el contrario, la GPU (de la que se hablará en detalle en el siguiente apartado). Es muy superior a la CPU en el procesamiento de datos paralelos, es decir, datos que se procesan a la vez. Por ejemplo, si tenemos una serie de operaciones matemáticas, donde el resultado de la operación anterior no se usa en la siguiente, la GPU puede realizar todas las operaciones a la vez, mientras que la CPU debe esperar a que se resuelva una operación para pasar a la siguiente.

Las CPUs son muy complejas y apenas se ha cubierto lo más básico de esta. A medida que se profundize en ciertas secciones del ensayo, se explicarán ciertos detalles más sobre su funcionamiento.

## GPUs

La GPU, de siglas provenientes del inglés con el significado "Graphics processing unit", es un componente fundamental de cualquier ordenador, encargado del procesamiento de tareas que impliquen elementos gráficos. En específico, la GPU está especializada en la realizacion de cálculos matemáticos de la manera más rápida posible, paralelizando los cálculos en sus cientos o miles de núcleos.

La arquitectura de la GPU se presta especialmente bien a aplicaciones que pueden dividirse en tareas más pequeñas y cuyo resultado es independiente del procesamiento de otras tareas. Cada núcleo de la GPU puede trabajar en un pequeño fragmento de datos de manera independiente, acelerando en gran medida la velocidad del procesamiento total. Este enfoque de paralelización masiva es el motivo por los que las GPUs son tan efectivas en tareas gráficas y en otras aplicaciones que implican el procesamiento de grandes cantidades de datos, como pueden ser la edición de video o, de manera más actual, el machine learning o aprendizaje automatico.

Si bien esta arquitectura facilita en gran medida ciertas tareas, transmite una carga al programador, que es la de pensar y cuidar el orden y la forma en la que se realizarán ciertas tareas para asegurarse de obtener el resultado deseado y hacerlo de manera óptima. En caso de no cumplir con estas condiciones, el resultado puede ser nefasto, ya que la GPU al ser un componente tan especializado en la realización de una tarea, no dispone de la facilidad de manejo de errores que puede tener una CPU, por lo que hay que ser cuidadoso con su utilización.

La GPU dispone de una memoria más amplia y compartida que la de la CPU, ya que prioriza la manipulación eficiente de bloques extensos de datos. Además, utiliza una memoria gráfica dedicada (VRAM) que se especializa en la gestión eficaz de texturas, shaders y otros elementos gráficos.

## Simulaciones de Partículas

Las simulaciones de partículas son un tipo de simulación que se encarga de simular el comportamiento de partículas. Un ejemplo popular es el juego de la vida de Conway

<Figure>

Imagen del juego de la vida de Conway

</Figure>

En este juego, cada partícula o pixel puede estar "vivo" o "muerto". Por convenio, una partícula viva se representa con un color blanco, por el contrario, una partícula muerta se representa con el color negro. El juego de la vida de Conway tiene una serie de reglas simples que se aplican a cada partícula en la simulación en cada frame o iteración lógica.

- Si una partícula viva está rodeada de más de 3 partículas vivas, muere por sobrepoblación.
- Si una partícula viva está rodeada de menos de 2 partículas vivas, muere por soledad.
- Si una partícula muerta está rodeada exactamente de 3 partículas vivas, se convierte en una partícula viva.

Este tipo de simulación de partículas tiene un nombre en concreto, autómatas celulares. Un autómata celular se [caracteriza por](https://puga.uaz.edu.mx/project/que-es-un-automata-celular/)

(No sé si debería explicar los siguientes puntos, imagino que sí pero a este ritmo la mitad del TFG va a ser explicar sobre que se fundamente más que lo que hemos hecho en sí)

- Espacio regular
- Conjunto de estados **finito**
- Configuración inicial
- Vecindades
- Función de transición local

A continuación vermos una serie de simulaciones y/o juegos en los que se basa nuestro trabajo y fueron nuestra fuente de inspiración.

# Resultados

# Conclusiones

## Cositas

Simulación original en C++ y OpenGL, 800*800 a 60 fps
Simulación en LUA y LOVE, 800*800 a 60 fps multihilo
Simulación en Rust y Vulkano, 1000\*1000 a 60 fps multihiloS
DLL llamada simple vs Lua vs LuaJit

Hablar de automatas celulares, luego simulaciones de arena

1. Introducción: to be defined

2. Autómatas celulares y simuladores de arena

2.1. Autómatas celulares

2.2. Simuladores de arena

3. Programación paralela

3.1. CPU

- Multithreading
- Cache

  3.2. GPU

4. Plug-ins y lenguajes de script

- Sobrecarga por DLLs
- JIT

5. Simulador en CPU

6. Simulador en GPU

7. Comparación y pruebas

8. Conclusiones y trabajo futuro
