#import "@preview/subpar:0.1.0"

Una vez entendidos los simuladores de arena y las implementaciones realizadas, se procede a evaluar y compararlas de la siguiente forma:

- Por un lado, una evaluación de rendimiento en cada una de las implementaciones, tanto en CPU como en GPU. 
- Por el otro, una evaluación de usabilidad. Para esta se evaluará la capacidad de los usuarios de expandir el sistema dadas unas instrucciones.

== Comparación de rendimiento <ComparacionRendimiento>

Para asegurar que la comparación sea justa, todas las pruebas se han realizado en el mismo hardware en 2 equipos distintos. Además, para medir el rendimiento se aumentará el número de partículas simuladas por segundo hasta que ninguno de los sistemas pueda ejecutar la simulación en tiempo real, esto es, 60 veces por segundo. La simulación siempre se lleva a cabo en una matriz cuadrada de $N*N$ celdas. El tamaño de la simulación será mostrado en cada gráfica de rendimiento.

Las características de los equipos usados para las pruebas son las siguientes:
#v(10pt)

#set align(center)

#rect()[
#grid(columns: 2, column-gutter: 40pt, inset: 0.5em,
[
  #set align(left)
  Equipo 1:
  - CPU: AMD Ryzen 5 5500
  - GPU: NVIDIA GeForce RTX 4060
  - RAM: 16 GB GDDR4 3200 MHz
  - Sistema operativo: Windows 11
],
[
  #set align(left)
  Equipo 2:
  - CPU: AMD Ryzen 7 2700x
  - GPU: AMD RX 5700XT
  - RAM: 32 GB GDDR4 3200 MHz
  - Sistema operativo: Windows 11
]
)]

#set align(left)
#v(10pt)



Se han realizado las diversas pruebas:

- Comparación entre todos los simuladores con el mismo tipo de partícula.
- Comparación entre los simuladores de CPU con una partícula demandante.

Las gráficas estarán ordenadas de mayor a menor cantidad de partículas simuladas a 60 fotogramas por segundo.

A continuación se muestran los resultados obtenidos en las pruebas de rendimiento con GPU:

#subpar.grid(
  figure(image("../images/compc1.png"), caption: [
    Resultados primer equipo
  ]), <a>,
  figure(image("../images/compc2.png"), caption: [
    Resultados segundo equipo
  ]), <b>,
  gap: 10pt,
  columns: (1fr, 1fr),
  caption: [Resultados de las pruebas de rendimiento con GPU],
  label: <full>,
)

#v(5pt)

Esta solo se usó una partícula de arena, ya que todos los simuladores la implementaban. La implementación de esta es lo más similar posible en todos los simuladores, para que la comparación sea justa. Como puede observarse en la @full, la diferencia entre simular en la GPU y la CPU es considerablemente grande.

A continuación se muestra una segunda prueba, realizada solo entre las implementaciones en CPU. Esto permite observar la diferencia de rendimiento entre los distintos simuladores en CPU mejor que en la gráfica anterior. Además, dado que las implementaciones en CPU tienen más tipos de partículas, se ha optado por usar una partícula compleja común a todas, la particula de `planta`. Esta partícula tiene la peculiaridad de que necesita comprobar el estado de todos sus vecinos para buscar agua que transformar en planta. Esta búsqueda incurre en un coste computacional mayor que el de la arena, que solo necesita comprobar el estado de sus vecinos para caer.

#subpar.grid(
  figure(image("../images/compc3.png"), caption: [
    Resultados primer equipo
  ]), <a2>,
  figure(image("../images/compc4.png"), caption: [
    Resultados segundo equipo
  ]), <b2>,
  gap: 10pt,
  columns: (1fr, 1fr),
  caption: [Resultados de las pruebas de rendimiento con GPU],
  label: <full2>,
)

En esta gráfica puede apreciarse la diferencia en cuanto a rendimiento entre ambas implementaciones, además de la diferencia de rendimiento entre una partícula simple y una compleja respecto a la @full

Una vez realizadas las pruebas de rendimiento, se procede a evaluar la usabilidad de los distintos sistemas.

== Comparación de usabilidad

Para evaluar la usabilidad de los distintos sistemas se ha realizado una encuesta a un grupo de 12 personas. En ella se les ha pedido que realicen una serie de tareas en el simulador de Lua, el de Rust web o ambos. Se descartó el simulador en GPU al resultar complejo de expandir y de ejecutar debido a los requisitos necesarios para su ejecución. La tarea fue la misma para ambos simuladores y el proceso fue grabado para su posterior análisis. Se evalúa tanto el tiempo que tardan en realizar la tarea como la cantidad de errores y confusiones que cometen. El grupo de usuarios seleccionado cubre un perfil amplio de individuos, desde de estudiantes de informática hasta personas sin conocimientos previos en programación. En ambos casos, ninguno de los usuarios había utilizado previamente ninguno de los simuladores ni conocían la existencia de los simuladores de arena.

La tarea pedida consistía en crear 4 particulas: Arena, Agua, Gas y Lava. La arena trata de moverse hacia debajo si hay vacío o agua, en caso de no poder, realiza el mismo intento hacia abajo a la derecha y abajo a la izquierda. Es decir, intenta moverse en las 3 direcciones descritas si hay aire o agua. Solo se mueve una vez en la primera dirección en la que es posible en cada generación. La particula de gas tiene el mismo comportamiento que el de arena pero yendo hacia arriba en vez de hacia abajo. La partícula de agua se comporta igual que la arena, pero si no puede moverse en ninguna de las 3 direcciones descritas, se debe intentar mover también directamente a la derecha y a la izquierda, en ese orden. Por último, la particula de lava es igual a la de arena en su movimiento, pero si toca una partícula de agua la convierte en gas. Este punto es importante, pues es la particula de lava la que detecta si hay agua y no al revés. Esto tiene implicaciones en su implementación mediante bloques. Esta tarea es común a las pruebas de Lua y Blockly.

Para la realización de dicha tarea, se explicó que es un simulador de arena y como usarlo. Para esto, se enseña en tiempo real como crear una partícula básica que va hacia abajo sin comprobar nada, además de mencionar como podría hacer la comprobación de detectar una particula en una dirección. Además, se muestra la solución a los usuarios, sin mostrar el código o los bloques, se les enseña las particulas y su comportamiento de forma visual para que tengan una referencia respecto al objetivo a lograr.

No todas las personas pudieron realizar la prueba de Lua debido a falta de conocimientos o indisposición. Sin embargo otros usuarios que no poseen un perfil técnico accedieron y la realizaron. Para minimizar el sesgo, un grupo de usuarios primero realizó la prueba con Lua y otro con Rust web.

Para la realización de la prueba de Lua, los parámetros registrados son los siguientes:

- Necesitó asistencia en la creación de la lógica: Positivo si el usuario necesitó ayuda activa después de la explicación inicial. Las dudas preguntadas por el usuario no cuentan como necesitar ayuda.
- Usó el método isEmpty: Esta funcion permite comprobar si la particula en una direccion es vacía. Este parámetro es positivo si hizo uso del método sin sugerencia previa.
- Necesitó ayuda para implementar movimiento aleatorio horizontal: Se considera positivo si el usuario necesitó asistencia del probador para añadirle aleatoriedad de movimiento a las partículas
- Necesitó ayuda con errores de ejecución: Se considera positivo si el usuario necesitó asistencia del probador para solucionar la ejecución de una partícula que provocase que el programa crashee.
- Terminó la prueba: Se considera positivo si el usuario terminó la prueba en menos, negativo si por frustración u otras razones no la terminó.

#pagebreak()
Los resultados son los siguientes:

#figure(image("../images/pruebaUsuarioLua.png", width: 50%), caption: [
    Resultados de las pruebas con usuarios para la prueba de Lua
  ])

Todos los usuarios fueron capaces de crear las partículas deseadas de una manera rápida, aunque no de la más efectiva en la mayoría de casos. Prácticamente ningún usuario hizo uso de la función 'isEmpty' sin sugerencia previa del supervisor, la mayoría aprovechaba para reutilizar la lógica creada en la partícula de arena, lo que provocaba que usasen la función 'check_neighbour_multiple' de una forma incorrecta, ya que lo empleaban para hacer comprobaciones con un solo tipo de partícula. 
Todos los usuarios tuvieron errores de ejecución. Las causas más comunes son: falta de escribir 'api:' para llamar a funciones de programación de partículas, errores de escritura a la hora de hacer uso de estas mismas funciones, y olvidos de hacer uso de 'end' para cerrar claúsulas condicionales 'if'. La mayoría de participantes pudieron implementar aleatoriedad en el movimiento de manera satisfactoria sin ayuda del probador.

De estos 5 usuarios, 3 realizaron esta prueba antes que la de Blockly. Estos usuarios entendieron más rápido el sistema de bloques y el como se debía realizar la comprobación de partículas vecinas.

Como particularidad, uno de estos usuarios, a la hora de implementar aleatoriedad, buscó hacer uso de una funcionalidad 'randomTransformation(horizontalReflection)' inexistente en esta simulación. No se detectó ningún sesgo de este tipo por parte de los participantes que realizaron la prueba de Lua y después la de Blockly.

Respecto la prueba de Blockly, los parámetros registrados son los siguientes:

- Necesitó ayuda: Positivo si el usuario necesitó ayuda activa después de la explicación inicial. Las dudas preguntadas por el usuario no cuentan como necesitar ayuda.
- Usó el array: Se refiere a si el usuario uso la funcionalidad de array del bloque de partícula. Este bloque es el primero que se explica y se destaca su función de poder representar varias partículas, además de mostrar un ejemplo de esto. Este parámetro es positivo ei el usuario usó el array en alguna ocasión.
- Usó el foreach: Se refiere a si el usuario uso la funcionalidad de foreach del bloque de partícula. Este bloque se considera el más complejo de entender debido a que las direcciones que están dentro de este son modificadas. Este bloque es necesario para realizar la última tarea. Este parámetro es positivo si el usuario usó el foreach en alguna ocasión sin ayuda.
- Usó una transformación horizontal: Todas las partículas que se pedían tenían la peculiaridad de tener que comprobar ambas direcciones horizontales. Este parámetro es positivo si el usuario usó una transformación horizontal en alguna ocasión sin ayuda. Se espera que ningún usuario use este bloque debido a que no es necesario y no se pide, pero usarlo sería ideal.
- Usó el bloque touching: Este bloque permite resolver el último comportamiento de una forma alternativa. Si el usuario propone o decide usar este bloque, se considera positivo.
- Terminó la prueba: Se considera positivo si el usuario terminó la prueba en menos, negativo si por frustración u otras razones no la terminó.

Los resultados son los siguientes:

#figure(image("../images/pruebaUsuario.png", width: 50%), caption: [
    Resultados de las pruebas con usuarios
  ])

Además de estos datos cuantitativos, se han recogido datos cualitativos. Estos datos se han recogido durante la prueba mediante anotaciones de los supervisores. Los resultados de estas anotaciones son los siguientes:

La mayoría de usuarios presentan problemas al inicio para usar el bloque que representa una partícula, pues a pesar de la explicación y el ejemplo mostrado, la mayoría olvida el funcionamiento de este bloque. Salvo una excepción, todos los usuarios tuvieron problemas para entender el bloque foreach, siendo el bloque que más ayuda necesitó. Por otro lado, se observó que tras una única explicación, los usuarios pueden navegar la interfaz con facilidad y no presentan problemas para añadir, eliminar partículas, poner la simulación en pausa y en general, usar los controles básicos del simulador. Sin embargo, a pesar de que entendían los elementos de la interfaz y su función, hubo uno que causó cierta fricción cognitiva: El botón de añadir partícula. Los usuarios lo pulsaban y procedían a editar bloques en el espacio actual, que no había cambiado, pues los usuarios parecían asumir que añadir una nueva particula la selecciona automáticamente.

Dos usuarios realizaron esta prueba antes que la de Lua. Estos usuarios tuvieron los problemas comunes que el resto de usuarios (no cerrar claúsulas if con un end, no usar 'api:'), sin embargo estos dos usuarios sí usaron el método 'isEmpty' sin sugerencia previa. Ambos pudieron realizar la tarea con mayor soltura que los usuarios que realizaron la prueba de Lua antes.

Una vez concluidas las pruebas, se procedió al análisis de los resultados obtenidos. A diferencia de las pruebas, no se hará una diferenciación entre rendimiento y usabilidad, sino que se decidió evaluar el valor que aporta cada simulador por separado. Finalmente se concluye con una vista global y se proponen mejoras para futuras versiones.

Lo más destacable de las pruebas es la gran diferencia de rendimiento entre los simuladores implementados en CPU y el implementado en GPU. Sin embargo el coste de implementación y extensión es mucho mayor. En este simulador no se pudo probar la usabilidad con usuarios debido a que para ello se requería compilar el proyecto, lo cual requiere ciertas herramientas que muchos usuarios no están dispuestos a instalar. Una implementación en GPU puede resultar ideal cuando se requiere un alto rendimiento pero además el comportamiento que se trata de lograr es altamente específico y de una complejidad moderada. Una implementación de estas características puede resultar útil para la investigación de autómatas celulares en las que se requiera procesar una gran cantidad de partícula simultáneamente para buscar patrones de grandes dimensiones que no podrían ser detectados con una implementación en CPU. Podría resultar interesante la investigación de un sistema que permita generalizar reglas para crear autómatas celulares en la GPU de forma flexible. Esto no ha sido posible con simuladores de arena debido a que en estos, una partícula puede modificar las vecinas, sin embargo, en los autómatas celulares cada celda como mucho puede modificarse a sí misma, lo que podría simplificar la implementación.

La implementación en C++ se realizó como una base para medir las demás. Esta permitió cuantificar la penalización de rendimiento que incurre la flexiblidad usar un lenguaje interpretado como Lua, aún en su versión JIT, así como usar WebAssembly. El desarrollo de simuladores de arena en C++ incurre en el mismo problema que la GPU, se requiere acceso al código y herramientas de desarrollo para poder extenderlo. 

En cuanto a la implementacion en Lua, sorprende el rendimiento que puede lograr dada la flexibilidad que ofrece. Sin embargo, desarrollar interfaces es más complejo debido a la escasez de librerías para ello. Con suficiente trabajo, esta implementación tiene el potencial de ser la solución más balanceada de idónea para simuladores de arena en CPU, pues mediante el multihilo el rendimiento logrado resulta ser superior a lo esperado. 

Por último, la implementación en Rust con Blockly destaca por resultar más lenta de lo esperado. La curva de aprendizaje mediante bloques resultó superior a la esperada, sin embargo, pasada esta, los usuarios parecen ser capaces de desarrollar particulas con facilidad sin requerir nociones de programación. Esta implementación resulta ser la más accesible debido a que simplemente requiere de un navegador, software que cualquier dispositivo inteligente actual posee. Debido a su rendimiento, esta implementación no es idónea para explorar simulaciones de una gran complejidad o tamaño. Esto podría paliarse mediante la implementación de multihilo, sin embargo, debido a las reglas de seguridad de memoria de Rust y la poca madurez de multihilo en WebAssembly, esta tarea resulta en una complejidad muy alta, existiendo la posibilidad de que no se pueda lograr. 