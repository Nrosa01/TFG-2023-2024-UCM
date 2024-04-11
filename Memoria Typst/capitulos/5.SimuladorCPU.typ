#import "@preview/sourcerer:0.2.1": code
#import "../utilities/gridfunc.typ": *
#import "../data/gridexamples.typ": *

Considerando las opciones para una implementación modular, se decidió empezar creando una estructura que el programa nativo intreprete. Esto es, un simulador basado en un archivo propietario. Las expectativas con esta aproximación era lograr un rendimiento mayor al de un lenguaje de scripting sacrificando algo de flexibilidad. Sin embargo se encontraron varios problemas con esta técnica, por lo que el proyecto se replanteó para poder lograr una implementación que permita definir nuevas partículas con facilidad y sea fácil de distribuir. Esto sucedió dos veces, en cada iteración del simulador ciertas bases se consolidaban de manera que la siguiente implementación no fuera de cero.

A continuación se detalla cada implementación, profundizando en sus rasgos particulares.

== Simulador en C++

El primer simulador fue desarrollado en C++ usando OpenGL y GLFW. La base fundamental de este sistema fue la misma para los siguientes. Se crea un array de partículas, siendo las partículas un struct con la menor cantidad de datos posibles: el tipo, la temperatura, la granularidad, clock y life_time. Estos 5 valores ocupan en total 105 bits en memoria, algo más de 13 bytes. El tipo de la partícula es un número sin signo para identificarla, representa si la partícula es arena, ácido o cualquier otro elemento. La temperatura es un número con signo que literalmente representa su temperatura, ya que al igual que Noita, este sistema se planteó para soportar interacciones químicas. El siguiente elemento, la granularidad, es otro número, esta vez de 1 byte que se inicia de forma aleatoria y modifica ligeramente el color de la partícula. Life_time como su nombre indica es una variable que almacena la duración de la partícula en el sistema en ticks. No todas las particulas usan este valor. Finalmente, clock es un valor interno que alterna cuando la partícula es procesada y permite no procesarla más de una vez en un mismo tick.

Este sistema procesa de arriba abajo y de izquierda a derecha la matriz de particulas, por lo que si una particula se mueve hacia abajo, volverá a ser procesada en las siguiente iteraciones. Alternativamente es posible tener un array separado de booleanos y ponerlo a 0 al final de cada iteración con memset, sin embargo esto resultó ser más lento que la alternativa de usar clock. En esta, el sistema tiene también un clock que alterna cada frame, solo las partícula cuyo clock coincide con el del sistema son procesadas. 

Cada partícula tiene un color asociado, en función del identificdor de la particula, se escribe su color en formato RGBA8 en buffer, este se envía cada frame a la GPU para ser renderizado. Esto es común a todas las implementaciones con ligeras variaciones.

Debido a que esta implementación era un poco explorativa, se implementó en un solo hilo, con todo, esta estaba preparada para funcionar en multihilo.

=== Uso de un formato propieatario

Esta es la base del sistema, pero no se ha hablado que se hace en el procesado de actualizar las partículas. Durante el desarrollo identificamos un patrón común en el movimiento de las partículas: Todas tienen patrones de movimientos similares, muchas de ellas pueden o no atravesar otras. En base a esta información, se abstrajo un modelo sobre el que poder trabajar. Este modelo se materializó en un struct ParticleDefinition.

#code(
  lang: "C++",
```cpp
struct ParticleDefinition
{
	std::string text_id;
	ParticleProject::colour_t particle_color;
	int16_t random_granularity;
	std::vector<ParticleProject::Vector2D> movement_passes;
	Properties properties;
	std::vector<Interaction> interactions;
};
```)

Este struct se guarda en un array en la misma posición que el tipo de particula que representa. Es decir, si una partícula tiene tipo 3, este struct está guardado en la posición 3 del array, de forma que se pueda indexar directamente con el tipo de la partícula. Por lo tanto, estos datos son inmutables y globales a todas las partículas de ese tipo.

`movement_passes` es un array de un Vector 2D que define el movimiento base de la partícula. La mayoría de partículas van hacia abajo si están libres, luego abajo izquierda y por último abajo derecha. Esto se traduce en: (0, 1), (-1, 1), (1, 1). Además de esto, existe un array de propiedades, entre las cuales se encuentra la densidad. Este valor se usa en el sistema y permite que partícula como la arena se hundan en el agua. Finalmente, hay un array de interacciones. Este es el que guarda la información sobre como se relacionan las partículas, el agua se evapora con la lava, la lava quema la madera, el ácido corroe la mayoría de partículas, etc. 

Sin embargo, en este punto se encuentran varios problemas. Algunos de ellos son solucionables, por ejemplo, no es posible tener un movimiento aleatorio, siempre es determinista. Algunas partículas dependen de poder moverse en una dirección aleatoria en cada iteración. El siguiente problema es el que llevó a la decisión de considerar otra implementación. Esto es, las interacciones. Existen muchas posibles interacciones, agua con agua, agua con fuego, agua con planta, arena con lava, etc. Modelar una estructura de datos que permita definir interacciones de forma escalable resultó ser complejo y muy limitante. Debido a esto, se decidió implementar las interacciones con Lua.

=== Scripting con Lua

Se decidió mantener el código actual y solo delegar las interacciones a Lua, pues se tenía evidencia de como delegar trabajo a Lua no era adecuado para maximizar rendimiento. Se usó LuaBridge para exportar nuestros tipos de C++ a Lua. Ahora, cada ParticleDefinition tiene asociado un script de Lua cargado en memoria que recibe un objeto Api y la posición actual de la particula. Este objeto tiene un método que permite obtener el tipo de una partícula mediante su nombre. Esto permite que el script pueda interactuar con otras partículas sin saber que posición tienen en el array o si existen. 

Dicha técnica otorgó mucha flexibilidad y el sistema seguía siendo sencillo de distribuir. No obstante, el rendimiento fue bastante inferior a lo esperado. Esto no era debido a que Lua fuera lento, el problema de rendimiento venía de la comunicación de Lua y C++. Más tarde se descubrió la librería Sol, que tiene menos overhead que luabridge. Aún con esto, el rendimiento seguía siendo subpar. Cabe mencionar que cuando se menciona Lua, se refiere a LuaJIT.

Nuestras pruebas nos mostraron que LuaJIT, aún siendo mucho más lento que C++, tenía un rendimiento decente. Debido a esto se optó por probar una implementación puramente en Lua.

== Simulador en Lua con LÖVE

Para poder gestionar la entrada de usuario y el renderizado de forma sencilla, se usó el framework LÖVE. Esta decisión resultó ser muy beneficiosa. Además, LÖVE usa exclusivamente LuaJit.

=== Implementación base

La implementación en LÖVE es muy similar a la de C++, pero con muchas mejoras. Se decidió que el update de la partícula sea de implementación libre, es decir, ya no existe una estructura ParticleDefinition de la misma forma que en la implementación anterior. La motivación tras este cambio es, que si las interacciones son flexibles, no tiene sentido restringir el movimiento a una estructura de datos. Esta vez, la estructura solo contiene 3 valores, el nombre de la partícula como string, el color y una función que es toda su interacción. Por otro lado, para definir la partícula, se usa la interfaz de funciones foráneas, FFI de ahora en adelante. Esta permite definir verdaderos structs en C, que son más rápidos de acceder y consumen menos memoria que las tablas de Lua.

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

Para poder aprovechar la caché, se decidió solo tener el tipo y el clock como campos de la partícula. El tipo es un uint8_t, esto permit tener hasta 256 tipos de partículas, lo cual es suficiente además de fácilmente ampliable de ser necesario.

Estos datos están guardados en una tabla global. El update de la partícula consiste en indexar esta tabla, acceder a la función de interación y llamarla pasándole un objeto API. En la implementación anterior, el API era la clase que contenía la simulación y sus métodos. En este caso se mejoró, el API es una vista de la simulación, contiene todas las particulas compartidas mediante un puntero pero solo procesa un rango, además, tiene estado interno. El API contiene la posición actual que se está procesando, por lo que las funciones que la consumen tratan con coordenadas locales. Mover una partícula hacia abajo consiste en algo similar a llamar a api.move(0, -1). Además, como cada partícula puede ser procesada de forma libre, es posible generar números aleatorios para el movimiento.

El punto más importante de esta simulación es su facilidad de añadir particulas. Como estas son definidas en Lua, es posible cargar un fichero de Lua que contenga la información de una nueva partícula. Se implementó la función de poder arrastrar archivos a la ventana. En caso de ser un archivo de Lua, este es cargado y añadido a la tabla global de partículas. Si la partícula ya existe, se sobreescribe. Este sistema permitió iterar de forma rápida el funcionamiento de las partículas.

A pesar de que todo iba bien, esta implementacion resultó ser más lenta que la realizada en C++ puro, pero más rápida que la realizada en C++ con Lua. La simulación aún tenía ciertas asperezas, entre otras, como siempre se procesan las partículas en el mismo orden, existe cierto sesgo en la simulación. Ambos problemas fueron resueltos mediante la implementación de multithreading. Se espera lograr al menos poder simular 300*300 particulas a 60fps en dispositivos de escritorio de gama baja.

=== Multithreading en Lua

Si bien Lua es un lenguaje muy sencillo y ligero, tiene ciertas carencias, una de ellas es el multithreading. En la versión de C++ no puedo implementarse debido a que la máquina virtual de Lua no puede ser compartida de forma segura entre hilos, de hacerlo, colapsaría. La alternativa a esto es instanciar una máquina virtual de Lua para cada hilo, esto es exacamente lo que love.threads hace. LÖVE permite crear hilos en Lua, pero además de esto, permite compartir datos entre hilos mediante `love.bytedata`. Además de esto, love proveee canales de comunicación entre hilos, que permiten enviar mensajes de un hilo a otro y sincronizarlos. Esto permitió enviar trabajo a los hilos bajo demanda.

Pese a que LÖVE facilita crear y comunicar hilos y la implementación sea sencilla, existen problemas notorios. Antes de poder explicarlos, es necesario mostrar como se implementó el multihilo en esta simulación. La forma más sencilla de actualizar la simulación, es que cada hilo actualicé un trocito o chunk en un patrón de ajedrez.

#grid_example("Patrón de ajedrez", (luaimpl_ex1,))

Primero se procesan los chunks azules, luego los negros, luego los blancos y por último los rojos. Es decir, se alternan filas y columnas. Esto permite que las partículas no sobreescriban otras que estén siendo procesadas. Por lo tanto, hay 4 pases de actualización. La divisón de la simulación en grid se realiza automáticamente el base al número de cores del sistema y al tamaño de la simulación. Un chunk debe ser como mínimo de 16 \* 16 pixeles. Esto permite que una partícula pueda interactuar con partículas que no estén inmediatamente cerca sin que acceda a al chunk que está siendo procesado por otro hilo.

Este sistema permite procesar chunks de particula de manera simultánea, aprovechando los recursos de la CPU y mejorando el rendimiento de la simulación. Sin embargo, existe un grave problema que está ligado al orden de actualización de simulación y el mencionado sesgo que esto conlleva. 

Para ilustrar el problema, se mostrarán 3 ticks de una simulacón pequeña que solo se divide en 4 chunks. En este ejemplo no hay simulación en paralelo al ser de una escala tan pequeña, pero se puede ver como el orden de actualización afecta a la simulación. El orden de procesado global y dentro de cada chunk es, de derecha a izquierda y abajo a arriba. Para este ejemplo primero se procesa el chunk superior derecho, luego inferior izquierdo, luego superior izquierdo y por último inferior derecho. Este orden es distinto al dado anteriormente, pero este problema sucede independientemente del orden en función del movimiento de las partículas. La partícula mostrada solo tiene un comportamiento, moverse hacia abajo si no hay otra partícula.


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

El tercer tick ya deja ver el problema. Si la simulación fuera single thread,  el estado de la simulación sería el siguiente:

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

El problema radica en el orden de actualización tanto de las partículas como de los chunks. Como se procesa primero el bloque superior, la partícula detecta que hay una debajo y no se mueve. En un solo hilo, como la actualización es de abajo hacia arriba, esto no ocurre. Este problema está presente siempre independientemente del orden de actualización elegido. Este problema sucede incluso si se cambia el orden de actualización de las partículas en cada iteración.

== Simulador en Rust con Macroquad
