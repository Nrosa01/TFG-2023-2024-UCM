#import "../utilities/gridfunc.typ": *
#import "../data/gridexamples.typ": *
#import "../data/data.typ": *

En este capítulo se hablará sobre el concepto de automátas celulares, su historia y su relevancia en la ciencia y matemáticas. Además, se presentarán algunos ejemplos de autómatas celulares relevantes en la investigación científica.

Los autómatas celulares @cellular_automata_thomasmli son un modelo matemático que se representa como una matriz n-dimensional de celdas. Este modelo puede ser de cualquier número de dimensiones, aunque los más comunes son los autómatas celulares de una y dos dimensiones. Cada celda en esta matriz puede existir en uno de varios estados posibles, que son finitos en número.

El cambio de estado de una celda se determina en función de los estados de las celdas vecinas y se produce en unidades discretas de tiempo, denominadas generaciones @ca_andrew. En este contexto, el término "vecinos" hace referencia a las celdas que se encuentran adyacentes a una celda específica.

En el caso específico de los autómatas celulares de dos dimensiones, existen dos tipos de vecindades que se utilizan comúnmente: la vecindad de Moore y la vecindad de Neumann @ca_karl_johannes. En la vecindad de Moore, se consideran como vecinos las ocho celdas que rodean a una celda central, incluyendo las celdas diagonales. En la vecindad de Neumann, por otro lado, solo se consideran como vecinos las cuatro celdas que están directamente arriba, abajo, a la izquierda y a la derecha de la celda central.

Finalmente, para definir completamente un autómata celular, se requiere una "regla" que se aplica a cada celda. Esta regla establece cómo cambiará el estado de una celda en la siguiente generación, basándose en los estados actuales de la celda y sus vecinos. Dicho de otro modo, la regla es la que transforma el sistema de celdas de su estado actual al estado siguiente en cada generación.

Para ilustrar mejor el concepto de autómata celular se muestra un ejepmlo a continuación. Este es un automáta celular de 2 dimensiones. Cada celda puede tener dos posible estados: `Apagada` o `Encendida`. La regla de este sistema es que si la celda está `Apagada` entonces pasa a estar `Encendida` en la siguiente iteración y viceversa. En resumen, los estados alternan periódicamente. A continuación se muestra un ejemplo de este sistema con 3 iteraciones:

#grid_example("Ejemplo de autómata celular sencillo", (state_01_ex1, state_02_ex1, state_03_ex1))

El concepto de autómatas celulares tiene sus raíces en las investigaciones pioneras llevadas a cabo por John von Neumann en la década de 1940. Von Neumann, un matemático húngaro-estadounidense, es ampliamente reconocido por sus contribuciones significativas en una variedad de campos, incluyendo la física cuántica, la economía y la teoría de juegos. Su trabajo en la teoría de autómatas y sistemas auto-replicantes @theory_self_replication fue particularmente revolucionario.

Von Neumann se enfrentó al desafío de diseñar sistemas auto-replicantes, y propuso un diseño basado en la autoconstrucción de robots. Sin embargo, esta idea se encontró con obstáculos debido a la complejidad inherente de proporcionar al robot un conjunto suficientemente amplio de piezas para su replicación. A pesar de estos desafíos, el trabajo de von Neumann en este campo fue fundamental y marcó un punto de inflexión significativo. Su trabajo seminal en este campo fue documentado en un artículo científico de 1948 titulado "The general and logical theory of automata".  

Stanislaw Ulam, un matemático polaco y colega de von Neumann, conocido por su trabajo en la teoría de números y su contribución al diseño de la bomba de hidrógeno, propuso durante este período una solución alternativa al desafío de la auto-replicación. Ulam sugirió la utilización de un sistema discreto para crear un modelo reduccionista de auto-replicación. Su enfoque proporcionó una perspectiva que ayudó a avanzar en el campo de los autómatas celulares.

En 1950, Ulam y von Neumann desarrollaron un método para calcular el movimiento de los líquidos, concebido como un conjunto de unidades discretas cuyo movimiento se determinaba según los comportamientos de las unidades adyacentes. Este enfoque innovador sentó las bases para el nacimiento del primer autómata celular conocido.

Los descubrimientos de von Neumann y Ulam propiciaron que otros matemáticos e investigadoras contribuyeran al desarrollo de los automátas celulares, sin embargo, no fue hasta 1970 que se popularizaron de cara al público general. En este año, Martin Gardner, divulgador de ciencia y matemáticas estadounidense; escribió un artículo @gardner_article en la revista Scientific American sobre un automáta celular específico: El juego de la vida de Conway.

A continuación se mostrarán algunos ejemplos de autómatas celulares relevantes, destacando sus características y aplicaciones en la ciencia y la matemática.

== Ejemplos de autómatas celulares

Los automátas celulares mostrados a continuación siguen un orden específico. Primero se expondrá un automáta conocido como `La hormiga de Langton` debido a su sencillez. Posteriormente se hablará sobre el automáta celular más conocido: `El juego de la vida`. Finalmente se mostrarán otros autómatas celulares relevantes en la investigación científica sin un orden específico.

=== Hormiga de Langton 


La "hormiga de Langton" @ca_karl_johannes, referido en Math World @langtonOnline como una máquina de Turing bidimensional de 4 estados, se describe de manera sencilla de la siguiente manera. Se considera un tablero cuadriculado donde cada casilla puede ser negra o blanca, y también puede contener una hormiga. Esta hormiga tiene cuatro direcciones posibles: norte, este, oeste y sur. Su movimiento sigue reglas simples: gira 90 grados a la derecha cuando está sobre una casilla negra, y 90 grados a la izquierda cuando está sobre una casilla blanca, tras lo cual 'avanza' en dicha dirección. Además, al 'dejar' una casilla, ésta cambia de color. El proceso comienza con una sola hormiga en una casilla blanca. Al principio, su movimiento parece caótico, pero después de un cierto número de pasos, se vuelve predecible, repitiendo un patrón cada cierto tiempo. En este punto, la parte del rastro de la hormiga que está en casillas negras crece de manera periódica, extendiéndose infinitamente por el tablero.

La hormiga de Langton también puede ser concebida como un autómata celular con 18 @ca_karl_johannes estados. Esto es debido a que la hormiga en sí no avanza. Siempre que la hormiga está en una celda, dicha celda cambiar de color y la hormiza desaparece. Sin embargo, alguna de las celdas vecinas verá que la celda de al lado contiene a la hormiga orientada a hacia la dirección en la que está dicha celda, por lo que su estado cambiará a tener la hormiga en la próxima iteración. Es decir, si se tienen dos celdas alineadas, una blanca sin hormiga y a su derecha otra celda blanca con una hormiga orientada hacia arriba. Como el estado de una celda en un autómata celular depende de sus vecinos, la celda vacía verá que su vecino contiene la hormiga orientada hacia arriba, y además es blanca. Debido a esto, la hormiga "debería girar hacia la izquierda", que es justo donde está la celda vacía, debido a esto la celda vacía cambiará su estado a seguir siendo blanca pero con la hormiga orientada hacia la izquierda, mientras que la celda con la hormiga cambiará a estar vacía y pasar a ser negra. El ejemplo a continuación ilustra de una forma mucho más clara e intuitiva este concepto.

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

Los automátas celulares han interesado a la comunidad científica y matemática desde su establecimiento por von Neumann. Debido a esto existen diversos autómatas celulares desarrolladores por distintos investigadores. A continuación se muestran una serie de autómatas celulares relevantes.

- Autómata de Contacto @ca_karl_johannes

Un autómata de contacto puede considerarse como uno de los modelos más simples para la propagación de una enfermedad infecciosa. Imagina una cuadrícula cuadrada de celdas. Supongamos que todas las celdas son "blancas" (o "no infectadas") excepto un número finito de celdas "negras" (o "infectadas"). Para una celda dada, definimos los vecinos como las ocho celdas inmediatamente adyacentes y la celda misma. Una versión determinista de un proceso de contacto funciona en pasos discretos de tiempo de la siguiente manera: una celda negra permanece negra, una celda blanca que es vecina de una celda negra se vuelve negra. Este sistema puede denominarse un proceso de contacto determinista. Si comenzamos con una sola celda negra, entonces el número de celdas negras aumenta en 1, 9, 25, etc. La forma general sigue siendo cuadrática. Se usa en la investigación de propagación de fenómenos epidemiológicos.

#grid_example("Ejemplo de autómata de contacto", (state_01_ex2, state_02_ex2, state_03_ex2), vinit: 10pt)

- Autómatas de Wolfram @ca_karl_johannes

Los Autómatas de Wolfram, propuestos por el físico y matemático Stephen Wolfram, son un conjunto de reglas para autómatas celulares unidimensionales de estados binarios. Cada regla define cómo evolucionan las células en función de su estado y el estado de sus vecinos. Cada generación en un automáta de wolfram es una fila más qu ese añade a las anteriores. Numeradas del 0 al 255, estas reglas proporcionan un marco teórico para explorar la complejidad emergente y la computación universal en sistemas celulares simples.


A continuación se muestra la regla 30 @wolfram_30 de Wolfram así como el autómata derivado de ejecutar 15 iteraciones de este:

#align(center + horizon)[Regla 30 de Wolfram]

#grid_example("", (rule30_01, rule30_02, rule30_03, rule30_04, rule30_05, rule30_06, rule30_07, rule30_08), vinit: 0pt)

#grid_example("Ejemplo autómata de Wolfram", (rule30_15gens,), vinit: 0pt)

- Autómata de Greenberg-Hastings @ca_karl_johannes

Los autómatas de Greenberg-Hastings son bidimensionales y están compuestos de células que pueden estar en 3 estados: reposo, excitado y refractario. La evolución de las células se basa en reglas locales que determinan la activación y desactivación de las células en función de su estado actual y el estado de sus vecinos. Debido a esteo este modelo ha sido utilizado para simular patrones de propagación de la actividad eléctrica en tejidos cardiacos. Destacando por su capacidad para modelar fenómenos de propagación y ondas, este autómata sigue reglas específicas para la activación y desactivación de células, lo que lo convierte en una herramienta valiosa en la investigación biomédica.

#text(red)[TODO: Añadir ejemplo de Greenberg-Hastings (no hay ninguno en el libro ni en internet, no esoty muy seguro de como crearlo pero el concepto de este autómata es intereante, ¿Podría dejarlo sin ejeplo o tendría que quitarlo por ser el único sin ejepmlo?).]



- Juego de la vida

El Juego de la Vida, propuesto por el matemático John Conway, es un autómata celular bidimensional que se desarrolla en una cuadrícula infinita de células, cada una de las cuales puede estar en uno de dos estados: viva o muerta. La evolución del juego está determinada por reglas simples basadas en el número de vecinos vivos alrededor de cada célula. Este modelo ha demostrado ser notable debido a su capacidad para generar patrones complejos y estructuras dinámicas a partir de reglas simples de transición de estados. El Juego de la Vida ha sido ampliamente estudiado en el campo de la teoría de la complejidad y ha sido utilizado como un modelo para explorar la autoorganización y la emergencia de la complejidad en sistemas dinámicos.

#grid_example("Ejemplo del Juego de la Vida", (game_of_life_01, game_of_life_02, game_of_life_03), vinit: 1pt)

Con el tiempo, esos sistema llamaron la atención de un público menos científico debido a su cualidad recreacional, pues no era necesario entender los fundamentos matemáticos de estos para poder disfrutar sus interacciones. De esta forma, y con un enfoque orientado a lo lúdico, es como surgieron los simuladores de arena.