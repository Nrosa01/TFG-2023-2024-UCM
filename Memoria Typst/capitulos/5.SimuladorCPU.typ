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

#text(red)[Esto lo cuento aquí porque en Lua y Rust lo hago distinto y no hay ningún libro o consenso al respecto de como hacerlo, es una decisión nuestra por lo cual no quería meterlo en estado del arte. En Lua es igual pero en multihilo, y en Rust el buffer se modifica al modificar una particula porque en esa simulación nos dimos cuenta de que actualizar el buffer cada vez que editas una partícula es más eficiente que hacerlo al final de la generación. ¿Es injusto de cara a la comparación? Quizás, pero que hacemos si no, ¿no lo contamos? Porque la versión de C++  no se ha tocado desde diciembre y por como está implementada sería un poco complicado porque la clase que ejecuta la lógica está totalmente separada de la clase que renderiza. La alternativa sería evitar hablar de este tema directamente o modificar la simulación en C++... Por ahora nos estamos centrando en pulir la memoria y si hay tiempo quizás podemos cambiar la versión de C++ y volver a ejecutar las pruebas de rendimiento.

Por otro lado, en las notas mencionas que no contamos suficiente en este apartado, pero es que no hay más, esta es una implementación simple, cerrada y eficiente que sirvió de base a las demás, pero más allá de que tiene una serie de parámetros que ya se han mencionado no tiene nada más destacable que contar, la chicha está en las otras implementaciones. (que en esas hay mucho más de lo que parece)]


== Simulador en Lua con LÖVE

LÖVE @akinlaja-2013 es un framework de desarrollo de videojuegos en Lua orientado a juegos 2D. Permite dibujar gráficos en pantalla y gestionar la entrada del usuario sin tener que preocuparase de la plataforma en la que se ejecuta. LÖVE usa LuaJIT, por lo que es posible alcanzar un rendimiento muy alto sin sacrificar flexibilidad.

Para mejorar aún más el rendimiento, esta implementación se basa de la librería FFI de LuaJit. Esta permite a Lua interactuar con código de C de forma nativa. Además, al poder declarar structs en C, es posible acceder a los datos de forma más rápida que con las tablas de Lua y consumir menos memoria. En este sistema, una particula es un struct en C que contiene su id y su clock.

Para facilitar la extensión y usabilidad de esta versión, se creó un API que permite definir partículas en Lua de forma externa. Una particula está definida por su nombre, su color y una función a ejecutar. Una vez hecho esto, el usuario solo debe arrastrar su archivo a la ventana de juego para cargar su "mod".

La función que ejecuta cada partícula recibe un solo parámetro: un objeto API. Este define las funciones necesarias para definir las reglas que modelan el comportamiento de una partícula. Además, para facilitar el desarrollo, las direcciones que consume el API son relativas a la posición de la partícula que se está procesando. Obtener el tipo de una partícula a la derecha de la actual es tan sencillo como llamar a `api:get(1, 0)`.

#text(red)[No sé si tenga sentido enumerar aquí las funciones que tiene dicho API... Tenemos un documento PDF con dichas funciones enumeradas, explicadas y hasta con ejemplos, por eso en la memoria anterior se menciona un "PDF anexo"]


Además de esto, el sistema registra automáticamente los tipos de partículas en una tabla global que actúa como un enum. Esto permite que el usuario pueda comprobar con facilidad si un tipo de partícula está definido en el sistema para poder interactuar con este. Por ejemplo, una particula de lava puede comprobar si hay agua debajo de ella y convertirla en roca.

Sin embargo, simular tantas partículas es un proceso costoso. Debido a esto, se optimizó mediante la implementación de multihilo.

=== Multithreading en Lua

#text(red)[Para poder hacer este apartado en condiciones necesito haber hablado antes de las condiciones de carrera en el apartado de CPU.]

Si bien Lua es un lenguaje muy sencillo y ligero, tiene ciertas carencias, una de ellas es el multithreading. Lua no soporta multithreading de forma nativa. La alternativa a esto es instanciar una máquina virtual de Lua para cada hilo, esto es exactamente lo que love.threads hace. LÖVE permite crear hilos en Lua, pero además de esto, permite compartir datos entre hilos mediante `love.bytedata`, una tabla especial que puede ser enviada entre hilos por referencia, en resumen, un recurso compartido. Además de esto, LÖVE provee `canales` de comunicación entre hilos, que permiten enviar mensajes de un hilo a otro y sincronizarlos. Esto permitió enviar trabajo a los hilos bajo demanda.

La implementación del multihilo dio lugar a problemas que no se tenían antes: escritura simultánea y condiciones de carrera. Esto supuso un desafío que fue resuelto implementando la actualización por bloques. En lugar de simular todas las particulas posible a la vez, se ejecutarían subregiones específicas de la simulación en 4 lotes. Se dividió la matriz en un "patron de ajedrez" @gdcNoita. Esto consiste en procesar primero las columnas y filas pares, luego columnas pares y filas impares... Y así hasta completar las 4 combinaciones posibles. Esto nos permite dividir la actualización de la simulación en 4 "pases", donde en cada uno de estos pases se procesan varias partículas a la vez. La figura @luacores muestra como serían estos pases.

#grid_example("Patrón de ajedrez de actualización", (luaimpl_ex1, luaimpl_ex4, luaimpl_ex2, luaimpl_ex3), vinit: 0pt, ref: "luacores") 

Cada uno de los cuadrados de la imagen representa una "submatriz" de partículas, esto se denomina un "chunk". El sistema dividirá la matriz en chunks siguiendo el siguiente criterio: El tamaño mínimo de una chunk es de 16 píxeles, el número de chunks debe ser igual o superior al cuadrado de hilos disponibles. Estos requisitos garantizan que se puedan utilizar todos los hilos a la vez. El requisito de tamaño es para evitar que una partícula trate de modificar a otra lejana que esté siendo procesada por otro hilo.

El orden en que se procesan las regiones coincide con el mostrado en la @luacores. Primero filas y columnas pares, a continuación, filas impares y columnas impares, tras esto, filas pares y columnas impares y finalmente filas impares y columnas pares.

Sin embargo, esto da lugar a problemas. Surgen artefactos visuales cuando una partícula se mueve fuera de la región que se estaba procesando. A continuación se muestra un ejemplo de este problema. Cada imagen es una generación de la simulación.

#v(5pt)

#grid_example_from("Problema de multithreading", (grid(
  columns: 2,
  rect(fill: green, inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_1)],
  rect(fill: purple, inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_1)],
  rect(fill: blue, inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_1)],
  rect(fill: red, inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_2)],
),grid(
  columns: 2,
  rect(fill: green, inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_1)],
  rect(fill: purple, inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_3)],
  rect(fill: blue, inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_1)],
  rect(fill: red, inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_5)],
),grid(
  columns: 2,
  rect(fill: green, inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_1)],
  rect(fill: purple, inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_4)],
  rect(fill: blue, inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_1)],
  rect(fill: red, inset: 2pt, outset: 0pt)[#draw_grid_simple(luaimpl_problem1_1_5)],
)), ref: "luaproblemcores")

En la @luaproblemcores se muestran tres generaciones procesando con el sistema multithread descrito. Se ilumina el borde de cara región para mayor claridad. Cada subregión procesa las particulas de arriba a abajo y de izquierda a derecha. El comportamiento de la partícula es el siguiente: Si el vecino superior es vacío, se "mueve" hacia arriba. En tercera generación se puede observar como las partículas se separan. Al haberse procesado primero la región roja, la partícula no puede moverse porque en la región morada había una partícula encima. Acto seguido, la partícula morada se mueve hacia arriba. En ejecución este efecto es notorio y afecta al comportamiento esperado de la simulación. Cambiar el orden en que se actualizan las partículaas resolvería el problema para partículas que se muevan en una dirección determinada, pero el problema siempre se presentará en una dirección.

Para evitar este problema se requirió modificar la actualización de la simulación. En primer lugar, se introdujo y doble buffer, esto permite que el procesamiento de las partículas sea consistente por lo mencionado en la @simuladoresArena. Con todo, esto no es suficinete y existen casos específicos en los que el problema persiste. Por ello, además de añadir doble buffer, el orden en que se actualizan las particulas cambia en un ciclo de 2 fotogramas. Primero se actualiza la matriz de derecha a izquierda y de arriba a abajo, y luego de izquierda a derecha y de abajo a arriba. Esto se debe a que si siempre se actualizan las partículas de izquierda a derecha o viceversa, el sistema presentará un sesgo en la dirección en la que se actualizan las partículas que provoca que el resultado tras varias iteraciones no sea el esperado. Debido a que este efecto se debe a una acumulación de resultados a lo largo de distintas generaciones, se omitirá una explicación detallada. La @luasesgo muestra la diferencia entre actualizar las partículas variando o no el orden de actualización.

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

Con estas mejoras el sistema funciona correctamente en casi todos los casos, pero aún existen casos muy específicos resultados de procesar chunks en un patrón de ajedrez. La solución para esto fue variar el orden de actualización de dichos "chunks" o trozos. En cada generación se invierte el orden de actualización de los chunks de una manera simlar a la que se invierte del orden de actualización de las partículas dentro de dichos chunks. Esto permite que el sistema sea más estable y no presente sesgos en la dirección en la que se actualizan las partículas.

Finalmente, para gestionar el procesamiento de los chunks se implementó la técnica del `work stealing`. El hilo principal va asignando chunks a los hilos libros hasta que todos han sido procesados, lo cual deja a los hilos esperando para la siguiente generación.

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