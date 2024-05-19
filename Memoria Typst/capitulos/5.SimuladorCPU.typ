#import "@preview/sourcerer:0.2.1": code
#import "../utilities/gridfunc.typ": *
#import "../data/gridexamples.typ": *
#import "@preview/subpar:0.1.0"

Este trabajo trata sobre simuladores de arena y, como se mencionó en la @simuladoresArena, los simuladores de arena no son paralelizables debido a que cada celda puede modificar el estado de las demás. En este capítulo se muestran distintas implementaciones de simuladores de arena que se ejecutan en la CPU para poder compararlos.

Para poder realizar la comparativa, se han realizado 3 simuladores diferentes basados en explotar la CPU. Cada uno de ellos tiene sus propias ventajas y desventajas, además de distintos propósitos. 

A continuación se detalla cada implementación, profundizando en sus rasgos particulares.

== Generalidades

En todas las implementaciones, una partícula es una estructura de datos con al menos dos propiedades: id y clock. La propiedad `id` es un valor que indica el tipo de partícula, mientras que `clock` es un valor que alterna entre 0 y 1 en cada iteración. Esto permite que una partícula no sea procesada dos veces en la misma generación. Es decir, si una partícula de arena se mueve "hacia abajo" y la actualización del simulador procesa las partículas de arriba a abajo, la partícula de arena que se movió hacia abajo volverá a ser procesada dentro de la misma generación. Para evitar este problema, se usa el valor `clock` para marcar si una partícula fue procesada en la generación actual. Para evitar tener que resetear el valor de `clock` de todas las partículas en cada generación, se alterna entre 0 y 1 en cada iteración y se compara con el valor clock del sistema, que también alterna entre 0 y 1 en cada iteración.

== Simulador en C++

El primer simulador fue desarrollado en C++ con OpenGL y GLFW. Este simulador sirve como base comparativa de las siguientes implementaciones. Este sistema posee 6 partículas: Arena, Agua, Aire, Gas, Roca y Ácido. En este sistema las partículas están programadas en el sistema y no son modificables de forma externa. Cada partícula tiene una serie de propiedades: color, densidad, granularidad, id y movimiento. El color es el color de la partícula, la densidad es un valor númerico que indica la pesadez relativa respecto otras partículas, la granularidad es un valor que modifica ligeramente el color de la partícula, la id es un valor que indica el tipo de partícula y el movimiento es una serie de valores que describe el movimiento de la partícula. Estos rasgos son particulares de esta implementación y no se repiten en las siguientes a excepción del identificador de la particula, que es común a todas las implementaciones.

Este sistema es limitado, pues los comportamientos de las partículas dependen de estos parámetros y el sistema que las procesa. Con todo, esto permite generar variaciones de partículas con facilidad. El valor del movimiento permite crear los tipos de movimientos más comunes (arena, agua, lava, gas, etc). La densidad permite controlar que partícula puede intercambiarse por otra sin tener que controlarlo manualmente para cada partícula... Al ser un sistema cerrado, se da lugar a un sistema más rápido y eficiente que los siguientes ya que el compilador puede optimizar el código de forma más eficiente.

La @simuladorcplusplus muestra la interacción entre partículas en este simulador en un mundo de $100*100$ celdas.

#subpar.grid(
  figure(image("../images/simuladorcplusplus.png"), caption: [
    Antes de que la arena llegue al agua
  ]),
  figure(image("../images/simuladorcplusplus2.png"), caption: [
    Arena hundiéndose en el agua
  ]),
  gap: 15pt,
  columns: (1fr, 1fr),
  caption: [Interacción entre partículas en el simulador de C++],
  label: <simuladorcplusplus>,
)

Esta implementación ejecuta una lógica directa en un solo hilo. Debido a esto es la base para comparar el rendimiento de las siguientes implementaciones.

Para poder mostrar el estado de la simulación de forma visual, se escribe en un buffer el color de cada partícula después de cada paso de simulación. Este buffer se envía a la GPU para ser renderizado en pantalla. 

#text(red)[Esto lo cuento aquí porque en Lua y Rust lo hago distinto y no hay ningún libro o consenso al respecto de como hacerlo, es una decisión nuestra por lo cual no quería meterlo en estado del arte. En Lua es similar pero en multihilo, y en Rust el buffer se modifica al modificar una particula porque en esa simulación nos dimos cuenta de que actualizar el buffer cada vez que editas una partícula es más eficiente que hacerlo al final de la generación. ¿Es injusto de cara a la comparación? Quizás, pero que hacemos si no, ¿no lo contamos? Porque la versión de C++  no se ha tocado desde diciembre y por como está implementada sería un poco complicado porque la clase que ejecuta la lógica está totalmente separada de la clase que renderiza. La alternativa sería evitar hablar de este tema directamente o modificar la simulación en C++... Por ahora nos estamos centrando en pulir la memoria y si hay tiempo quizás podemos cambiar la versión de C++ y volver a ejecutar las pruebas de rendimiento.

Por otro lado, en las notas mencionas que no contamos suficiente en este apartado, pero es que no hay más, esta es una implementación simple, cerrada y eficiente que sirvió de base a las demás, pero más allá de que tiene una serie de parámetros que ya se han mencionado no tiene nada más destacable que contar, la chicha está en las otras implementaciones. (que en esas hay mucho más de lo que parece)]


== Simulador en Lua con LÖVE

LÖVE @akinlaja-2013 es un framework de desarrollo de videojuegos en Lua orientado a juegos 2D. Permite dibujar gráficos en pantalla y gestionar la entrada del usuario sin tener que preocuparase de la plataforma en la que se ejecuta. LÖVE usa LuaJIT, por lo que es posible alcanzar un rendimiento muy alto sin sacrificar flexibilidad.

Para mejorar aún más el rendimiento, esta implementación se basa de la librería FFI de LuaJit. Esta permite a Lua interactuar con código de C de forma nativa. Además, al poder declarar structs en C, es posible acceder a los datos de forma más rápida que con las tablas de Lua y consumir menos memoria.

Este sistema también usa la técnica de clock para gestionar la ejecución de las particulas. Sin embargo, a diferencia del anterior, el orden en que se actualizan las particulas cambia en un ciclo de 2 fotogramas. Primero se actualiza la matriz de derecha a izquierda y de arriba a abajo, y luego de izquierda a derecha y de abajo a arriba. Esto se debe a que si siempre se actualizan las partículas de izquierda a derecha o viceversa, el sistema presentará un sesgo en la dirección en la que se actualizan las partículas que provoca que el resultado tras varias iteraciones no sea el esperado. Debido a que este efecto se debe a una acumulación de resultados a lo largo de distintas generaciones, se omitirá una explicación detallada. La @luasesgo muestra la diferencia entre actualizar las partículas variando o no el orden de actualización.

#subpar.grid(
  figure(image("../images/luasesgo2.png"), caption: [
    Sin variar el orden de actualización
  ]), <luasesgo1>,
  figure(image("../images/luasesgo1.png"), caption: [
    Variando el orden de actualización
  ]), <b>,
  gap: 15pt,
  columns: (1fr, 1fr),
  caption: [Diferencia entre variar y no el orden de actualización al procesar partículas],
  label: <luasesgo>,
)

#v(5pt)

En ambos casos el código para simular la particula de arena es el mismo. Pero puede observarse en la @luasesgo1 como las partículas tienden a ir primero hacia la derecha.

Para facilitar la extensión y usabilidad de esta versión, se creó un API que permite definir partículas en Lua de forma externa. Una particula está definida por su nombre, su color y una función a ejecutar. Una vez hecho esto, el usaurio solo debe arrastrar su archivo a la ventana de juego para cargar su "mod".

Sin embargo, simular tantas partículas es un proceso costoso. Además, las particulas no tienen acceso a toda la simulación, debido a esto, se optimizó mediante la implementación de multihilo.

=== Multithreading en Lua

#text(red)[Para poder hacer este apartado en condiciones necesito haber hablado antes de las condiciones de carrera en el apartado de CPU.]

Si bien Lua es un lenguaje muy sencillo y ligero, tiene ciertas carencias, una de ellas es el multithreading. Lua no soporta multithreading de forma nativa. La alternativa a esto es instanciar una máquina virtual de Lua para cada hilo, esto es exactamente lo que love.threads hace. LÖVE permite crear hilos en Lua, pero además de esto, permite compartir datos entre hilos mediante `love.bytedata`, una tabla especial que puede ser enviada entre hilos por referencia. Además de esto, LÖVE provee canales de comunicación entre hilos, que permiten enviar mensajes de un hilo a otro y sincronizarlos. Esto permitió enviar trabajo a los hilos bajo demanda.

La implementación del multihilo dio lugar a problemas que no se tenían antes: escritura simultánea y condiciones de carrera. Esto supuso un desfío que fue resuelto implementando la actualización por bloques. En lugar de simular todas las particulas posible a la vez, se ejecutarían subregiones específicas de la simulación en 4 lotes. Se dividió la grilla en un patron de ajedrez. Esto permite que dos partículas no accedan a la misma casilla al mismo tiempo, ya que cada lote de procesado está separado de los demás para que si la particula se sale, pueda coincidir con otra.

#grid_example("Patrón de ajedrez de actualización", (luaimpl_ex1,), vinit: -20pt) // No sé por qué el espaciado en este párrafo es enorme así que nada, lo ajusot manualmente con el vinit

Primero se procesan los chunks azules, luego los negros, luego los blancos y por último los rojos. Es decir, se alternan filas y columnas. Esto permite que las partículas no sobreescriban otras que estén siendo procesadas. Por lo tanto, hay 4 pases de actualización. La divisón de la simulación en grid se realiza automáticamente el base al número de cores del sistema y al tamaño de la simulación. Un chunk debe ser como mínimo de 16 \* 16 pixeles. Esto permite que una partícula pueda interactuar con partículas que no estén inmediatamente cerca sin que acceda a al chunk que está siendo procesado por otro hilo.

Este sistema permite procesar chunks de particula de manera simultánea, aprovechando los recursos de la CPU y mejorando el rendimiento de la simulación. Sin embargo, existe un grave problema que está ligado al orden de actualización de simulación y el mencionado sesgo que esto conlleva. 

Además de esto existe otro problema. Podían surgir artefactos visuales cuando una partícula se movía fuera de la región que se estaba ejecutando. A continuación se muestra un ejemplo de este problema. Cada imagen es una generación de la simulación.


#grid_example_from("Problema de multithreading", (grid(
  columns: 2,
  rect(fill: rgb("#BFDCF5"), inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_1)],
  rect(fill: rgb("#BFBFBF"), inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_2)],
  rect(fill: rgb("#FFCFCC"), inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_1)],
  rect(fill: rgb("#838383"), inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_1)],
),grid(
  columns: 2,
  rect(fill: rgb("#BFDCF5"), inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_1)],
  rect(fill: rgb("#BFBFBF"), inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_4)],
  rect(fill: rgb("#FFCFCC"), inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_1)],
  rect(fill: rgb("#838383"), inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_5)],
),grid(
  columns: 2,
  rect(fill: rgb("#BFDCF5"), inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_1)],
  rect(fill: rgb("#BFBFBF"), inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_4)],
  rect(fill: rgb("#FFCFCC"), inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_1)],
  rect(fill: rgb("#838383"), inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_6)],
)))

La tercera generacion ya deja ver el problema. Si la simulación fuera single thread,  el estado de la simulación sería el siguiente:

#grid_example_from("Resultado esperado", (grid(
  columns: 2,
  rect(fill: rgb("#BFDCF5"), inset: 0pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_1)],
  rect(fill: rgb("#BFBFBF"), inset: 0pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_2)],
  rect(fill: rgb("#FFCFCC"), inset: 0pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_1)],
  rect(fill: rgb("#838383"), inset: 0pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_1)],
),grid(
  columns: 2,
  rect(fill: rgb("#BFDCF5"), inset: 0pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_1)],
  rect(fill: rgb("#BFBFBF"), inset: 0pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_4)],
  rect(fill: rgb("#FFCFCC"), inset: 0pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_1)],
  rect(fill: rgb("#838383"), inset: 0pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_5)],
),grid(
  columns: 2,
  rect(fill: rgb("#BFDCF5"), inset: 0pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_1)],
  rect(fill: rgb("#BFBFBF"), inset: 0pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_1)],
  rect(fill: rgb("#FFCFCC"), inset: 0pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_1)],
  rect(fill: rgb("#838383"), inset: 0pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_3)],
)))

Alcanzar la solución esperada en la figura 17 es teóricamente imposible. Sin embargo es posible convertir el comportamiento indeseado en la norma. Para ello se decidió cambiar el procesamiento del sistema a un sistema de doble buffer. Para una mayor comprensión, este sistema puede entender como el usado en los autómata celulares formales. Todas las celdas se ejecutan "a la vez", es decir, si una celda camnbia así lo dictan las reglas del sistema, las vecinas no percibirán ese cambio hasta la siguiente iteración. Esto permite que el procesimiento sea más uniforme aún cuando la particula se mueve fuera de su área de procesamiento.


Con esto el sistema funciona satisfactoriamente, es suficientemente rápido y fácil de extender mediante mods que son arrastrar y soltar. Existe un API (PDF, documento adjunto, no sé como indicarlo) que explica a los usuarios como crear sus propias particulas. El sistema permite referenciar otras particulas. Es decir, una partícula de arena puede comprobar si debajo de ella hay agua. Esto otorga una gran flexibilidad y portabilidad, además de un rendimiento competente gracias a la compilación `Just in Time` y el aprovechamiento de los recursos de la CPU.

Finalmente, se explora la posibilidad de tener un sistema más eficiente manteniendo la flexibilidad. Para ello, se implementó una versión en Rust con Macroquad.


== Simulador en Rust con Macroquad


#text(red)[Para poder mencionar Vue, Blockly y GitHub Pages necesito un capitulo de estado del arte para explicar dichas tecnologías y luego simplemente referenciarlas aquí.]

Rust es un lenguaje de programación de propósito general con características de lenguajes funcionales y orientados a objetos. Es un lenguaje con características de bajo y alto nivel, es decir, permite manipular la memoria directamente pero al mismo tiempo permite programar con atajos y abstracciones que ocultan lógica subyacente para simplificar la tarea del programador.

En esta versión se decidió usar Macroquad como librería para poder gestionar la ventana, input y gráficos. Macroquad es un framework de Rust inspirado en Raylib. Es multiplataforma y compila de forma nativa a WebAssembly, por lo que el mismo código puede ser usado para la versión web y la nativa. Como desventaja, el game loop viene hecho y no permite cambiar la tasa de refresco, la justificación del desarrollador es que en WebAssembly la tasa de refresco depende de la función de JavaScript `requestAnimationFrame` usada para implementar el game loop. A pesar de este inconveniente, Macroquad es muy sencillo de usar y tiene una documentación muy completa.

Para este sistema se implementó una interfaz abstracta de carga de plugins. Esto permite que un plugin pueda ser una librería dinámica, un fichero de configuración o incluso usar un lenguaje de scripting. En este sistema, las partículas son estructuras que tienen un identificador, la variable clock para gestionar su actualización y dos campos extras: light y extra. Light controla la opacidad de la particula en un rango de 0 a 100 mientras que extra es un campo de 8 bits que puede ser usado para guardar información adicional. 

Este proyecto se dividió en 3 sub proyectos: plugins, app-core y app. Plugins contiene plugins por defecto para inicializar la aplicación con algo más que una particula vacía, app-core contiene toda la lógica de la simulación y la interfaz abstracta de plugin (traits, en nomenclatura de Rust), app es un crate binario que usa app-core para crear la simulación y renderizarla, es decir, es la aplicación principal. 

El objetivo de esta implementación era su uso en una web con integración de Blockly para permitir a los usuarios crear particulas de forma visual. Debido a esto, esta implementación es monohilo, pues no es posible procesar WebAssembly en multihilo. 

WebAssembly (también conocido como wasm) es un formato de código binario portable y de bajo nivel diseñado para ejecutarse de manera eficiente en navegadores web. Es un estándar abierto respaldado por la mayoría de los principales navegadores web, lo que permite ejecutar código escrito en lenguajes de programación de alto nivel, como C++, Rust y JavaScript, en el navegador a una velocidad cercana a la ejecución nativa.

La principal ventaja de WebAssembly es su capacidad para mejorar el rendimiento de las aplicaciones web al permitir la ejecución de código de manera más eficiente en el navegador. A diferencia de JavaScript, que es un lenguaje interpretado, WebAssembly se compila en un formato binario que se puede ejecutar directamente por el navegador, lo que resulta en una ejecución más rápida y eficiente.

Además, WebAssembly es un formato independiente de la plataforma, lo que significa que se puede ejecutar en diferentes sistemas operativos y arquitecturas de CPU sin necesidad de realizar modificaciones en el código fuente. Esto lo hace ideal para aplicaciones que requieren un alto rendimiento, como juegos, simulaciones y aplicaciones de edición de imágenes.

Sin embargo, WebAssembly también tiene algunas limitaciones. Los tipos disponibles son limitados y esto complica la comunicación entre WebAssembly y JavaScript. 

Como se ha mencionado, es priotiario la flexibilidad y la extensibilidad del sistema. Para ello, se implementó un sistema de plugins que permite a los usuarios crear sus propias particulas y añadirlas al sistema. Para permitir esto, se definió una serie de instrucciones en Rust que pueden ser cargadas de un fichero JSON. Dicho fichero no sería creado manualmente, sino que se generaría a partir de un editor visual de bloques. Este editor visual de bloques se implementó en Blockly, una librería de Google que permite crear interfaces gráficas de programación.

Para poder comunicar WebAssembly con Blockly, se creó una página web usando el framework Vue3. Vue3 es un framework de JavaScript que permite crear interfaces de usuario de forma sencilla y eficiente. Además, Vue3 es muy flexible y permite integrar otras librerías de JavaScript de forma sencilla. Esto permitió definir una interfaz de usuario amigable y permitir el uso del sistema de bloques definido en Blockly comunicando el binario WebAssembly con el código JavaScript de la página. Debido a que el sistema está preparado para recibir plugins, se implementó en la web un sistema de carga y descarga de lotes de plugins para facilitar el testeo del sistema y al mismo tiempo permitir a los usuarios guardar sus creaciones.

Finalmente cabe destacar que para simplificar el proceso de desarrollo, se optó por alojar la página en GitHub Pages. GitHub Pages es un servicio de alojamiento web gratuito que permite a los usuarios publicar sitios web estáticos directamente desde un repositorio de GitHub. Se configuró un flujo de trabajo de GitHub Actions para automatizar la compilación y despliegue de la página web en GitHub Pages. Esto permite que cualquier cambio en el repositorio se refleje automáticamente en la página web, lo que facilita la colaboración y el desarrollo del proyecto.