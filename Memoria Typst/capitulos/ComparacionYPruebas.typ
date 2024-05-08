#import "@preview/subpar:0.1.0"

Una vez entendidos los automátas celulares y las implementaciones realizadas, se procede a evaluar y compararlas de la siguiente forma:

- Por un lado, una evaluación de rendimiento en cada una de las implementaciones, tanto en CPU como en GPU. 
- Por el otro, una evaluación de usabilidad. Para esta se evaluará la capacidad de los usuarios de expandir el sistema dadas unas instrucciones.

== Comparación de rendimiento

Para asegurar que la comparación sea justa, todas las pruebas se han realizado en el mismo hardware en 2 equipos distintos. Además, para medir el rendimiento se aumentará el número de partículas simuladas por segundo hasta que ninguno de los sistemas pueda ejecutar la simulación en tiempo real, esto es, 60 veces por segundo.

Las características de los equipos son las siguientes:
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
  - CPU: Intel Core i7-10750H
  - GPU: NVIDIA GeForce RTX 2060
  - RAM: 16 GB
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
  v(5pt),
  columns: (1fr, 1fr),
  caption: [Resultados de las pruebas de rendimiento con GPU],
  label: <full>,
)

#v(5pt)

Esta solo se usó una partícula de arena, ya que todos los simuladores la implementaban. La implementación de esta es lo más similar posible en todos los simuladores, para que la comparación sea justa. Como puede observarse en la @full, la diferencia entre simular en la GPU y la CPU es considerablemente grande.

A continuación se muestra una segunda prueba, realizada solo entre las implementaciones en CPU. Esto permite observar la diferencia de rendimiento entre los distintos simuladores en CPU mejor que en la gráfica anterior. Además, dado que las implementaciones en CPU tienen más partículas, se ha optado por usar una partícula. Esta partícula tiene la peculiaridad de que necesita comprobar el estado de todos sus vecinos para buscar agua que transformar en planta. Esta búsqueda incurre en un coste computacional mayor que el de la arena, que solo necesita comprobar el estado de sus vecinos para caer.

#subpar.grid(
  figure(image("../images/compc3.png"), caption: [
    Resultados primer equipo
  ]), <a2>,
  figure(image("../images/compc3.png"), caption: [
    Resultados segundo equipo
  ]), <b2>,
  v(5pt),
  columns: (1fr, 1fr),
  caption: [Resultados de las pruebas de rendimiento con GPU],
  label: <full2>,
)

En esta gráfica puede apreciarse la diferencia en cuanto a rendimiento entre ambas implementaciones, además de la diferencia de rendimiento entre una partícula simple y una compleja respecto a la @full

== Comparación de usabilidad

Para evaluar la usabilidad de los distintos sistemas se ha realizado una encuesta a un grupo de X personas. En ella se les ha pedido que realicen una serie de tareas en el simulador de Lua, el de Rust web o ambos. La tarea fue la misma para ambos simuladores y el proceso fue grabado. Se evalúa tanto el tiempo que tardan en realizar la tarea como la cantidad de errores y confusiones que cometen. El grupo de usuarios seleccionado cubre un perfil amplio de individuos, desde de estudiantes de informática hasta personas sin conocimientos previos en programación. En ambos casos, ninguno de los usuarios había utilizado previamente ninguno de los simuladores ni conocían la existencia de los simuladores de arena.

Una vez realizadas las pruebas, se clasificaron de acuerdo a una serie de parámetros, la visualización de estdos datos puede verse en la siguiente tabla:

--- Aquí habría que poner la tabla

