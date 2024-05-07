#import "@preview/sourcerer:0.2.1": code
#import "../utilities/gridfunc.typ": *
#import "../data/gridexamples.typ": *

Para poder realizar la comparativa, se han realizado 3 simuladores diferentes basados en explotar la CPU. Cada uno de ellos tiene sus propias ventajas y desventajas, además de distintos propósitos. 

A diferencia de los autómatas celulares, estas implementaciones se procesan de forma secuencial. Si una partícula cambia su estado, las demás partículas verán esos cambios reflejos al momento sin tener que esperar a que todas las demás partículas hayan sido procesadas.

A continuación se detalla cada implementación, profundizando en sus rasgos particulares.

== Simulador en C++

El primer simulador fue desarrollado en C++ con OpenGL y GLFW. Este simulador sirve como base comparativa de las siguientes implementaciones. Este sistema posee 6 partículas: Arena, Agua, Aire, Gas, Roca y Ácido. En este sistema las partículas están programadas en el sistema y no son modificables de forma externa. Cada partícula tiene una serie de propiedades: color, densidad, granularidad, id y movimiento. El color es el color de la partícula, la densidad es un valor númerico que indica la pesadez relativa respecto otras partículas, la granularidad es un valor que modifica ligeramente el color de la partícula, la id es un valor que indica el tipo de partícula y el movimiento es una serie de valores que describe el movimiento de la partícula.

Es importante no procesar una misma partícula dos veces. Tanto en esta como en las demás implementaciones, la grilla de partículas se representa como un array bidimensional. Además, en este simulador se actualizar de "arriba a abajo y de izquierda a derecha". Es decir, se procesa primero la primera fila, luego la segunda, y así sucesivamente. Dentro de cada fila, se procesa de izquierda a derecha. Esto provoca que si una partícula se "mueve" hacia abajo, se procesará de nuevo en la siguiente iteración. Para evitar este problema, cada particula tiene un valor llamado clock que tiene dos posibles estados y alterna en cada iteración. Cuando una partícula "se mueve", cambia su valor de clock y no vuelve a ser procesada. Puede pensarse como un marcador que al cambiar indica que dicha partícula fue procesada para la generación actual y no debe volver a procesarse. Es necesario definir que significa que una partícula "se mueva". Esto es una ilusión visual, el sistema ejecuta una transformación de la matriz de partículas en base a unas reglas en pasos discretos de tiempo. Se define "moverse" el proceso por el cual una particula se borra de una celda para escribirse en otra. Esto provoca la sensación de movimiento.

Esta implementación ejecuta una lógica directa en un solo hilo. Debidoo a esto es la base para comparar el rendimiento de las siguientes implementaciones. La siguiente versión a implementar fue desarrollada usando LuaJIT en el framework LÖVE.

== Simulador en Lua con LÖVE

LÖVE es un framework de desarrollo de videojuegos en Lua orientado a juegos 2D. Permite dibujar gráficos en pantalla y gestionar input sin tener que preocuparase de la plataforma en la que se ejecuta. LÖVE usa LuaJIT, por lo que es posible alcanzar un rendimiento muy alto sin sacrificar flexibilidad.

Para mejorar aún más el rendimiento, esta implementación se basa de la librería FFI de Lua. FFI significa Foreign Function Interface, es una librería que permite a Lua interactuar con código C de forma nativa. Además, al poder declarar structs en C, es posible acceder a los datos de forma más rápida que con las tablas de Lua y consumir menos memoria.

#code(
  lang: "Lua",
  ```lua
-- Particle.lua

ffi.cdef [[
typedef struct { uint8_t type; bool clock; } Particle;
]]

local Particle = ffi.metatype("Particle", {})
```
)

Este sistema también usa la técnica de clock para gestionar la ejecución de las particulas. Sin embargo, a diferencia del anterior, el orden en que se actualizan las particulas cambia en un ciclo de 4 fotogramas. Esto permite conseguir un resultado visual más uniforme.

Para facilitar la extensión y usabilidad de esta versión, se creó un API que permite definir partículas en Lua de forma externa. Una particula está definida por su nombre, su color y su función a ejecutar. Una vez hecho esto, el usaurio solo debe arrastrar su archivo a la ventana de juego para cargar su plugin.

Sin embargo, simular partículas es un proceso intensivo. Además, las particulas no tienen acceso a toda la simulación, debido a esto, se optimizó mediante la implementación de multihilo.

=== Multithreading en Lua

Si bien Lua es un lenguaje muy sencillo y ligero, tiene ciertas carencias, una de ellas es el multithreading. Lua no soporta multithreading de forma nativa. La alternativa a esto es instanciar una máquina virtual de Lua para cada hilo, esto es exacamente lo que love.threads hace. LÖVE permite crear hilos en Lua, pero además de esto, permite compartir datos entre hilos mediante `love.bytedata`, una tabla especial que puede ser enviada entre hilos por referencia. Además de esto, love proveee canales de comunicación entre hilos, que permiten enviar mensajes de un hilo a otro y sincronizarlos. Esto permitió enviar trabajo a los hilos bajo demanda.

La implementación del multihilo dio lugar a problemas que no se tenían antes: escritura simultánea y condiciones de carreras. Esto supuso un desfío que fue resuelto implementando la actualización por bloques. En lugar de simular todas las particulas posible a la vez, se ejecutarían subregiones específicas de la simulación en 4 lotes. Se dividió la grilla en un patron de ajedrez. Esto permite que dos partículas no accedan a la misma casilla al mismo tiempo, ya que cada lote de procesado está separado de los demás para que si la particula se sale, pueda coincidir con otra.

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

Alcanzar la solución esperada en la figura 17 es teóricamente imposible. Sin embargo es posible convertir el comportamiento indeseado en la norma. Para ello se decidió cambiar el procesamiento del sistema a un sistema de doble buffer. Para una mayor comprensión, este sistema puede entender como el usado en los autómata celulares formales. Todas las celdas se ejecutan "a la vez", es decir, si unca celda camnbia así lo dictan las reglas del sistema, las vecinas no percibirán ese cambio hasta la siguiente iteración. Esto permite que el procesimiento sea más uniforme aún cuando la particula se mueve fuera de su área de procesamiento.


Con esto el sistema funciona satisfactoriamente, es suficientemente rápido y fácil de extender mediante mods que son arrastrar y soltar. Existe un API (PDF, documento adjunto, no sé como indicarlo) que explica a los usuarios como crear sus propias particulas. El sistema permite referenciar otras particulas. Es decir, una partícula de arena puede comprobar si debajo de ella hay agua. Esto otorga una gran flexibilidad y portabilidad, además de un rendimiento competente gracias a la compilación `Just in Time` y el aprovechamiento de los recursos de la CPU.

Finalmente, se explora la posibilidad de tener un sistema más eficiente manteniendo la flexibilidad. Para ello, se implementó una versión en Rust con Macroquad.

== Simulador en Rust con Macroquad

Rust es un lenguaje de programación de propósito general con características de lenguajes funcionales y orientados a objetos. Es un lenguaje con características de bajo y alto nivel, es decir, permite manipular la memoria directamtene pero al mismo tiempo permite programar con atajos y abstracciones que ocultan lógica subyacente para simplificar la tarea del progrmador.

En esta versión se decidió usar Macroquad como librería para poder gestionar la ventana, input y gráficos. Macroquad es un framework de Rust inspirado en raylib. Es multiplataforma y compila de forma nativa a WebAssembly, por lo que el mismo código puede ser usado para la versión web y la nativa. Como desventaja, el game loop viene hecho y no permite cambiar la tasa de refresco, la justificación del desarrollador es que en WebAssembly la tasa de refresco depende de la función de Javascript `requestAnimationFrame` usada para implementar el game loop. A pesar de este inconveniente, Macroquad es muy sencillo de usar y tiene una documentación muy completa.

Para este sistema se implementó una interfaz abstracta de carga de plugins. Esto permite que un plugin pueda ser una librería dinámica, un fichero de configuración o incluso usar un lenguaje de scripting. En este sistema, las partículas son estructuras que tienen un identificador, la variable clock para gestionar su actualización y dos campos extras: light y extra. Light controla la opacidad de la particula en un rango de 0 a 100 mientras que extra es un campo de 8 bits que puede ser usado para guardar información adicional. 

Este proyecto se dividió en 3 sub proyectos: plugins, app-core y app. Plugins contiene plugins por defecto para inicializar la aplicación con algo más que una particula vacía, app-core contiene toda la lógica de la simulación y la interfaz abstracta de plugin (traits, en nomenclatura de Rust), app es un crate binario que usa app-core para crear la simulación y renderizarla, es decir, es la aplicación principal. 

El objetivo de esta implementación era su uso en una web con integración de Blockly para permitir a los usuarios crear particulas de forma visual. Debido a esto, esta implementación es monohilo, pues no es posible procesar WebAssembly en multihilo. 

WebAssembly (también conocido como wasm) es un formato de código binario portátil y de bajo nivel diseñado para ejecutarse de manera eficiente en navegadores web. Es un estándar abierto respaldado por la mayoría de los principales navegadores web, lo que permite ejecutar código escrito en lenguajes de programación de alto nivel, como C++, Rust y JavaScript, en el navegador a una velocidad cercana a la ejecución nativa.

La principal ventaja de WebAssembly es su capacidad para mejorar el rendimiento de las aplicaciones web al permitir la ejecución de código de manera más eficiente en el navegador. A diferencia de JavaScript, que es un lenguaje interpretado, WebAssembly se compila en un formato binario que se puede ejecutar directamente por el navegador, lo que resulta en una ejecución más rápida y eficiente.

Además, WebAssembly es un formato independiente de la plataforma, lo que significa que se puede ejecutar en diferentes sistemas operativos y arquitecturas de CPU sin necesidad de realizar modificaciones en el código fuente. Esto lo hace ideal para aplicaciones que requieren un alto rendimiento, como juegos, simulaciones y aplicaciones de edición de imágenes.

Sin embargo, WebAssembly también tiene algunas limitaciones. Los tipoos disponibles son limitados y esto complica la comunicación entre WebAssembly y JavaScript. 

Como se ha mencionado, es priotiario la flexibilidad y la extensibilidad del sistema. Para ello, se implementó un sistema de plugins que permite a los usuarios crear sus propias particulas y añadirlas al sistema. Para permitir esto, se definió una serie de instrucciones en Rust que pueden ser cargadas de un fichero JSON. Dicho fichero no sería creado manualmente, sino que se generaría a partir de un editor visual de bloques. Este editor visual de bloques se implementó en Blockly, una librería de Google que permite crear interfaces gráficas de programación.

Estas implementaciones, en mayor o menor medidas están limitadas por la CPU, al ser tantas partículas que procesar se trata de simplificar una particula para que ocupe menos espacio y por tanto más parte del array pueda ser almacenado en la RAM. Además se trata de usar multithreading para aumentar el rendimiento, pero las CPUs actuales no tienen una cantidad de núcleos inmensas, y aún de tenerlas procesar las partículas sin artefactos visuales sería complejo por lo expuesto en el apartado de Lua. A pesar de esto, existen autómatas celulares que se computan en la GPU, por lo que existe la posibilidad de lograr una simulación superior a la de GPU al menos en lo que a cantidad de partículas simuladas se refiere. Para investigar esto se realizó una implementación en la GPU con Vulkan.