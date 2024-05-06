#import "../utilities/gridfunc.typ": *
#import "../data/gridexamples.typ": *
#import "../data/data.typ": *

En este capítulo se hablará sobre el concepto de automátas celulares, su historia y su relevancia en la ciencia y matemáticas. Además, se presentarán algunos ejemplos de autómatas celulares relevantes en la investigación científica.

Los autómatas celulares @cellular_automata_thomasmli son un modelo matemático discreto que se representa como una matriz n-dimensional de celdas. Este modelo puede ser de cualquier número de dimensiones, aunque los más comunes son los autómatas celulares de una y dos dimensiones. Cada celda en esta matriz puede existir en uno de varios estados posibles, que son finitos en número. Existe un consenso sobre la definición teórica de automátas celulares que los describe como modelos deterministas, sin embargo, en su aplicación práctica, los autómatas celulares pueden ser tanto deterministas como estocásticos. Esto es debido a que la naturaleza de cierto sistemas dependen de variables aleatorias, por lo que resulta más adecuado modelarlos como sistemas estocásticos.

El cambio de estado de una celda se determina en función de los estados de las celdas vecinas y se produce en unidades discretas de tiempo, denominadas generaciones @ca_andrew. En este contexto, el término "vecinos" hace referencia a las celdas que se encuentran adyacentes a una celda específica.

En el caso específico de los autómatas celulares de dos dimensiones, existen dos tipos de vecindades que se utilizan comúnmente: la vecindad de Moore y la vecindad de Neumann @ca_karl_johannes. En la vecindad de Moore, se consideran como vecinos las ocho celdas que rodean a una celda central, incluyendo las celdas diagonales. En la vecindad de Neumann, por otro lado, solo se consideran como vecinos las cuatro celdas que están directamente arriba, abajo, a la izquierda y a la derecha de la celda central.

Finalmente, para definir completamente un autómata celular, se requiere una "regla" que se aplica a cada celda. Esta regla establece cómo cambiará el estado de una celda en la siguiente generación, basándose en los estados actuales de la celda y sus vecinos. Dicho de otro modo, la regla es la que transforma el sistema de celdas de su estado actual al estado siguiente en cada generación.

Para ilustrar mejor el concepto de autómata celular se muestra un ejepmlo a continuación. Este es un automáta celular de 2 dimensiones. Cada celda puede tener dos posible estados: `Apagada` o `Encendida`. La regla de este sistema es que si la celda está `Apagada` entonces pasa a estar `Encendida` en la siguiente iteración y viceversa. En resumen, los estados alternan periódicamente. A continuación se muestra un ejemplo de este sistema con 3 iteraciones:

#grid_example("Ejemplo de autómata celular sencillo", (state_01_ex1, state_02_ex1, state_03_ex1))

Una característica importante de los autómata celulares que los distingue de los simuladores de arena, de los cuales se hablará en la siguiente sección, es su forma de de ser procesados. Esto sistemas no son procesados secuencialmente celda a celda. Se ha de comprender que todas las celdas "se procesan" a la vez. Esto implica que si una celda cambia de estado, las celdas adyacentes a esta celda no verán su estado modificado hasta la siguiente generación.

Muchos automátas celulares pueden representarse como una máquina de Turing. Una máquina de Turing es un modelo matemático de un dispositivo que manipula símbolos en una cinta de acuerdo con una serie de reglas. Aunque las máquinas de Turing son abstractas y teóricas, se consideran un modelo fundamental de la computación y han sido utilizadas para demostrar la existencia de problemas no computables. 

A su vez, la Máquina de Turing puede ser vista como un autómata que ejecuta un procedimiento efectivo formalmente definido. Este procedimiento se lleva a cabo en un espacio de memoria de trabajo que, teóricamente, es ilimitado.

Ahora que se ha establecido el marco teórico de los autómatas celulares, es posible explorar su historia y su relevancia en la ciencia y las matemáticas.

El concepto de autómatas celulares tiene sus raíces en las investigaciones pioneras llevadas a cabo por John von Neumann en la década de 1940. Von Neumann, un matemático húngaro-estadounidense, es ampliamente reconocido por sus contribuciones significativas en una variedad de campos, incluyendo la física cuántica, la economía y la teoría de juegos. Su trabajo en la teoría de autómatas y sistemas auto-replicantes @theory_self_replication fue particularmente revolucionario.

Von Neumann se enfrentó al desafío de diseñar sistemas auto-replicantes, y propuso un diseño basado en la autoconstrucción de robots. Sin embargo, esta idea se encontró con obstáculos debido a la complejidad inherente de proporcionar al robot un conjunto suficientemente amplio de piezas para su replicación. A pesar de estos desafíos, el trabajo de von Neumann en este campo fue fundamental y marcó un punto de inflexión significativo. Su trabajo seminal en este campo fue documentado en un artículo científico de 1948 titulado "The general and logical theory of automata".  

Stanislaw Ulam, un matemático polaco y colega de von Neumann, conocido por su trabajo en la teoría de números y su contribución al diseño de la bomba de hidrógeno, propuso durante este período una solución alternativa al desafío de la auto-replicación. Ulam sugirió la utilización de un sistema discreto para crear un modelo reduccionista de auto-replicación. Su enfoque proporcionó una perspectiva que ayudó a avanzar en el campo de los autómatas celulares.

En 1950, Ulam y von Neumann desarrollaron un método para calcular el movimiento de los líquidos, concebido como un conjunto de unidades discretas cuyo movimiento se determinaba según los comportamientos de las unidades adyacentes. Este enfoque innovador sentó las bases para el nacimiento del primer autómata celular conocido.

Los descubrimientos de von Neumann y Ulam propiciaron que otros matemáticos e investigadoras contribuyeran al desarrollo de los automátas celulares, sin embargo, no fue hasta 1970 que se popularizaron de cara al público general. En este año, Martin Gardner, divulgador de ciencia y matemáticas estadounidense; escribió un artículo @gardner_article en la revista Scientific American sobre un automáta celular específico: El juego de la vida de Conway.

A continuación se mostrarán algunos ejemplos de autómatas celulares relevantes, destacando sus características y aplicaciones en la ciencia y la matemática.

== Ejemplos de autómatas celulares

Los automátas celulares mostrados a continuación siguen un orden específico. Primero se hablará sobre el automáta celular más conocido: `El juego de la vida`. Tras el cual se hablará de la Hormiga de Finalmente se mostrarán otros autómatas celulares relevantes en la investigación científica sin un orden específico.

A continuación se mostrarán diversos ejemplos de automátas celulares, comenzando por el conocido Juego de la Vida de Conway. Posteriormente, se presentarán: los autómatas de Wolfram, la Hormiga de Langton, el autómata de contacto y el autómata de Greenberg-Hastings.

=== Juego de la vida

El Juego de la Vida, propuesto por el matemático John Conway, es un autómata celular bidimensional que se desarrolla en una cuadrícula teóricamente infinita de células, cada una de las cuales puede estar en uno de dos estados: viva o muerta. La evolución del juego está determinada por reglas simples basadas en el número de vecinos vivos alrededor de cada célula. Este modelo ha demostrado ser notable debido a su capacidad para generar patrones complejos y estructuras dinámicas a partir de reglas simples de transición de estados. El Juego de la Vida ha sido ampliamente estudiado en el campo de la teoría de la complejidad y ha sido utilizado como un modelo para explorar la autoorganización y la emergencia de la complejidad en sistemas dinámicos.

#grid_example("Ejemplo del Juego de la Vida", (game_of_life_01, game_of_life_02, game_of_life_03), vinit: 1pt)

Con el tiempo, esos sistema llamaron la atención de un público menos científico debido a su cualidad recreacional, pues no era necesario entender los fundamentos matemáticos de estos para poder disfrutar sus interacciones. De esta forma, y con un enfoque orientado a lo lúdico, es como surgieron los simuladores de arena.

- Autómatas de Wolfram @ca_karl_johannes

Los Autómatas de Wolfram, propuestos por el físico y matemático Stephen Wolfram, son un conjunto de reglas para autómatas celulares unidimensionales de estados binarios. Cada regla define cómo evolucionan las células en función de su estado y el estado de sus vecinos. Cada generación en un automáta de wolfram es una fila más qu ese añade a las anteriores. Numeradas del 0 al 255, estas reglas proporcionan un marco teórico para explorar la complejidad emergente y la computación universal en sistemas celulares simples.


A continuación se muestra la regla 30 @wolfram_30 de Wolfram así como el autómata derivado de ejecutar 15 iteraciones de este:

#align(center + horizon)[Regla 30 de Wolfram]

#grid_example("", (rule30_01, rule30_02, rule30_03, rule30_04, rule30_05, rule30_06, rule30_07, rule30_08), vinit: 0pt)

#grid_example("Ejemplo autómata de Wolfram", (rule30_15gens,), vinit: 0pt)

=== Hormiga de Langton 

La "hormiga de Langton" @ca_karl_johannes, referido en Math World @langtonOnline como una máquina de Turing bidimensional de 4 estados, se describe de manera sencilla de la siguiente manera. Se considera un tablero cuadriculado donde cada casilla puede ser negra o blanca, y también puede contener una hormiga. Esta hormiga tiene cuatro direcciones posibles: norte, este, oeste y sur. Su movimiento sigue reglas simples: gira 90 grados a la derecha cuando está sobre una casilla negra, y 90 grados a la izquierda cuando está sobre una casilla blanca, tras lo cual 'avanza' en dicha dirección. Además, al 'dejar' una casilla, ésta cambia de color. El proceso comienza con una sola hormiga en una casilla blanca. Al principio, su movimiento parece caótico, pero después de un cierto número de pasos, se vuelve predecible, repitiendo un patrón cada cierto tiempo. En este punto, la parte del rastro de la hormiga que está en casillas negras crece de manera periódica, extendiéndose infinitamente por el tablero.

En el autómata celular de la hormiga de Langton, se tienen 10 estados posibles. Estos se derivan de 2 colores de celda (blanco y negro), y la presencia de la hormiga. Cuando la hormiga está ausente, se consideran los 2 estados de color. Cuando la hormiga está presente, se consideran 4 direcciones posibles (norte, este, oeste y sur) para cada color de celda. Por lo tanto, se tienen 2 estados (colores) cuando la hormiga está ausente, y 2 (colores) \* 4 (direcciones) = 8 estados cuando la hormiga está presente. En total, se tienen 2 + 8 = 10 estados.

Cabe destacar que la hormiga no se mueve en sí misma, sino que cambia el estado de las celdas en las que se encuentra. Cuando la hormiga está en una celda, esa celda cambia de color y la hormiga desaparece. Sin embargo, una de las celdas adyacentes notará que la celda vecina tenía una hormiga orientada en su dirección, lo que provocará que su estado cambie para incluir la hormiga en la siguiente iteración.

Para una mejor comprensión, se pueden considerar dos celdas adyacentes: una celda blanca sin hormiga y, a su derecha, otra celda blanca con una hormiga orientada hacia arriba. En un autómata celular, el estado de una celda es dependiente de sus vecinos. En este escenario, la celda vacía detecta que su celda vecina contiene una hormiga orientada hacia arriba y es de color blanco. De acuerdo con las reglas de la hormiga de Langton, la hormiga debería girar a la izquierda, que es la ubicación de la celda vacía. Como resultado, el estado de la celda vacía cambiará a ser blanca pero ahora con una hormiga orientada hacia la izquierda. Simultáneamente, la celda que originalmente contenía la hormiga cambiará su estado a estar vacía y se tornará de color negro.á negra.

#grid_example("Ejemplo simple de la hormiga de Langton", (langton_ant_01, langton_ant_02, langton_ant_03, langton_ant_04, langton_ant_05, langton_ant_06), vinit: 1pt)

A partir de las 10000 generaciones aproximadamente, la hormiga de Langton muestra un comportamiento periódico que se repite en un ciclo de 104 generaciones. Este es el resultado en la generación 11000:

// #grid_example("Ejemplo completo de la hormiga de Langton", (langton_ant_final,), vinit: 1pt)

#align(center + horizon)[
  #grid(
    fill: (x, y) => rgb(
      if angton.at(x + y * 80) == 0 { white }
      else { black }
    ),
    stroke: rgb(100, 100, 100) + 0.03em,
    columns: (3.25pt,) * 80,
    rows: (3.25pt,) * 80,
    align: center + horizon,
  )
]


A continuación se verá el autómata celular más conocido y estudiado: El juego de la vida de Conway.


- Autómata de Contacto @ca_karl_johannes

Un autómata de contacto puede considerarse como uno de los modelos más simples para la propagación de una enfermedad infecciosa. Este autómata está compuesto por 2 estados: `celda infectada` (negra) y `celda no infectada` (blanca). Las reglas son las siguiente: Una celda infectada nunca cambia, una celda no infectada se vuelve una celda infectada si cualquiera de las 8 celdas adyacente es una infectada. La forma general sigue siendo cuadrática. Existe una versión no determinista en la que la una celda no infectada se infecta pero con una probabilidad p. Este modelo es muy útil en la investigación de la propagación de enfermedades infecciosas, ya que en una situación real existen variables aleatorias como se mencionó anteriormente.

#grid_example("Ejemplo de autómata de contacto determinista", (state_01_contact_automata, state_02_contact_automata, state_03_contact_automata), vinit: 10pt)

=== Autómata de Greenberg-Hastings

Los autómatas de Greenberg-Hastings @ca_karl_johannes son modelos bidimensionales compuestos por células que pueden estar en uno de tres estados: reposo, excitado y refractario. Estos autómatas son particularmente útiles para simular patrones de propagación de la actividad eléctrica en tejidos cardiacos, así como otros fenómenos de propagación y ondas.

La evolución de las células en un autómata de Greenberg-Hastings se rige por reglas locales que determinan la activación y desactivación de las células en función de su estado actual y el estado de sus vecinos. Estas reglas son las siguientes:

- Reposo: Una célula en estado de reposo se mantendrá en reposo a menos que al - menos uno de sus vecinos esté en estado excitado. En ese caso, la célula pasará al estado excitado en el siguiente paso de tiempo.

- Excitado: Una célula en estado excitado se moverá al estado refractario en el siguiente paso de tiempo, independientemente del estado de sus vecinos.

- Refractario: Una célula en estado refractario se moverá al estado de reposo en el siguiente paso de tiempo, independientemente del estado de sus vecinos.

Estas reglas simples permiten la propagación de la excitación a través del autómata, creando patrones de propagación que pueden ser analizados y estudiados. Esto hace que los autómatas de Greenberg-Hastings sean una herramienta valiosa en la investigación biomédica, especialmente en el estudio de la actividad eléctrica del corazón y otros tejidos que exhiben comportamientos similares.

