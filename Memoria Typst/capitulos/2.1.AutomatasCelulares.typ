#import "../utilities/gridfunc.typ": *
#import "../data/gridexamples.typ": *

/* TODO: Añadir citas, reescribir párrafo mejor en base a las citas. */

John von Neumann, matemático húngaroestadounidense, investigaba el problema de sistemas auto replicantes en la década de 1940. Su diseño se basaba en la idea de un robot que construye a otro. Esto le resultaba complejo debido a la dificultad de tener que proveer a dicho robot de un gran conjunto de piezas que pudiera usar para replicarse. Tras la publicación de un papel científico en 1948 titulado "The general and logical theory of automata", un colega suyo, Stanislaw Ulam, matemático polaco; sugirió usar un sistema discreto para crear un modelo reduccionista de auto replicación.

Más tarde, en 1950, Ulam y von Neumann crearon un método para calcular el movimiento de los líquidos. El concepto impulsor de dicho método consistía en considerar un líquido como un grupo de unidades discretas y calcular el movimiento de ellas basándose en los comportamientos de sus vecinas. Así nació el primer autómata celular /* (no he encontrado otro anterior...) */

Los descubrimientos de von Neumann y Ulam propiciaron que otros matemáticos e investigadoras contribuyeran al desarrollo de los automátas celulares, sin embargo, no fue hasta 1970 que se popularizaron de cara al público general. En este año, Martin Gardner, divulgador de ciencia y matemáticas estadounidense; escribió un artículo @gardner_article en la revista Scientific American sobre un automáta celular específico: El juego de la vida de Conway.

/* Este párrafo necesita más trabajo */

Los autómatas celulares @ca_wiki son un modelo matemático que consiste en una matriz n-dimensional de celdas. Cada celda puede estar en un estado de un conjunto de estados finitos. Estos estados cambian en función de los estados de sus celdas vecinas cada unidad discreta de tiempo llamada generación @ca_andrew. Cada celda tiene 8 vecinos, laterales y esquinas inclusive. Al procesar un automáta celular, una celda y sus vecinos se consideran como una sola, esto es llamado 'vencidad de Moore'@moore_neighborhood. Si solo se consideran los vecinos sin las esquinas entonces es llamado 'vencidad de Neumann'@neumann_neighborhood. Por último, para definir un autómata celular necesitamos una 'regla' que aplicar a cada celda, esta transformará el sistema de celdas en el siguiente estado en cada generación.

A continuación se mostrará un ejemplo de automáta celular para comprender mejor su concepto y propiedades. Este sistema consiste en una matriz bidimensional infinita cuyas celdas pueden tener cuatro estados posibles que serán llamados `agua`, `lava`, `roca` y `vacío`. Se presupone un sistema de coordenadas (X,Y). La coordenada X representa la posición horizontal de la celda de izquiera a derecha. La coordenada Y representa la posición vertical de la celda de abajo a arriba. Para simplificar la explicación de este sistema se definirá la operación mover. Se entiende como moverse a la transformación matemática por el cual se toman dos coordenadas, `inicio` y `final`, en la que la que el estado de la celda final se sobreescribe con el de la celda inicio. La celda inicio pasa a tener como estado `vacío`. (no sé si debería escribir esto en notación matemática, tampoco estoy muy seguro de como sería dicha notación). Una celda en estado agua puede moverse hacia debajo si la celda inferior contiene estado `vacío`. Si la celda inferior contiene el estado `lava`, la celda inferio pasará a ser estado `roca` y la celda actual pasará de estado `agua` a `vacío`. Una celda en estado `roca` no sufre alteraciones de ningún tipo. Una celda en estado `lava` se comporta similar a una celda con estado `agua`. Puede moverse hacia abajo si la celda inferior está vacía y se transforma en roca si la celda inferior es `agua`. Para representar el estado de forma visual, se asigna el color rojo a la celda en estado lava, azul al estado agua, negro al estado roca y blanco al estado vacío:

/*
0 => Aire
1 => Agua
2 => Lava
3 => Roca
*/

/* Function from utilities/gridfunc, data from data/gridexamples */
#grid_example("Ejemplo de autómata celular", (state_01_ex1, state_02_ex1))

Los automátas celulares han interesado a la comunidad científica y matemática desde su establecimiento por von Neumann. Debido a esto existen diversos autómatas celulares desarrolladores por distintos investigadores. A continuación se muestran una serie de autómatas celulares relevantes.

- Autómata de Contacto @ca_karl_johannes

Un autómata de contacto puede considerarse como uno de los modelos más simples para la propagación de una enfermedad infecciosa. Imagina una cuadrícula cuadrada de celdas. Supongamos que todas las celdas son "blancas" (o "no infectadas") excepto un número finito de celdas "negras" (o "infectadas"). Para una celda dada, definimos los vecinos como las ocho celdas inmediatamente adyacentes y la celda misma. Una versión determinista de un proceso de contacto funciona en pasos discretos de tiempo de la siguiente manera: una celda negra permanece negra, una celda blanca que es vecina de una celda negra se vuelve negra. Este sistema puede denominarse un proceso de contacto determinista. Si comenzamos con una sola celda negra, entonces el número de celdas negras aumenta en 1, 9, 25, etc. La forma general sigue siendo cuadrática. Se usa en la investigación de propagación de fenómenos epidemiológicos.

#grid_example("Ejemplo de autómata de contacto", (state_01_ex2, state_02_ex2, state_03_ex2))

- Autómatas de Wolfram @ca_karl_johannes

Los Autómatas de Wolfram, propuestos por el físico y matemático Stephen Wolfram, son un conjunto de reglas para autómatas celulares unidimensionales de estados binarios. Cada regla define cómo evolucionan las células en función de su estado y el estado de sus vecinos. Cada generación en un automáta de wolfram es una fila más qu ese añade a las anteriores. Numeradas del 0 al 255, estas reglas proporcionan un marco teórico para explorar la complejidad emergente y la computación universal en sistemas celulares simples.

#pagebreak()

A continuación se muestra la regla 30 @wolfram_30 de Wolfram así como el autómata derivado de ejecutar 15 iteraciones de este:

#align(center + horizon)[Regla 30 de Wolfram]

#grid_example("", (rule30_01, rule30_02, rule30_03, rule30_04, rule30_05, rule30_06, rule30_07, rule30_08), vinit: 0pt)

#grid_example("Ejemplo autómata de Wolfram", (rule30_15gens,), vinit: 0pt)

- Autómata de Greenberg-Hastings @ca_karl_johannes

El Autómata de Greenberg-Hastings es un modelo de autómata celular que ha sido utilizado para simular patrones de propagación de la actividad eléctrica en tejidos cardiacos. Destacando por su capacidad para modelar fenómenos de propagación y ondas, este autómata sigue reglas específicas para la activación y desactivación de células, lo que lo convierte en una herramienta valiosa en la investigación biomédica.

- Autómata de Langton @ca_karl_johannes

El Autómata de Langton, propuesto por Christopher Langton, es un autómata celular bidimensional que se caracteriza por su simplicidad y la complejidad emergente de sus patrones. Se basa en reglas locales sencillas, donde cada célula evoluciona en función de su estado actual y el número de vecinos en cada paso. A pesar de su simplicidad, el Autómata de Langton puede generar patrones dinámicos y estructuras complejas, lo que lo convierte en un modelo intrigante en el estudio de la autoorganización en sistemas complejos.

- Juego de la vida

El Juego de la Vida, propuesto por el matemático John Conway, es un autómata celular bidimensional que se desarrolla en una cuadrícula infinita de células, cada una de las cuales puede estar en uno de dos estados: viva o muerta. La evolución del juego está determinada por reglas simples basadas en el número de vecinos vivos alrededor de cada célula. Este modelo ha demostrado ser notable debido a su capacidad para generar patrones complejos y estructuras dinámicas a partir de reglas simples de transición de estados. El Juego de la Vida ha sido ampliamente estudiado en el campo de la teoría de la complejidad y ha sido utilizado como un modelo para explorar la autoorganización y la emergencia de la complejidad en sistemas dinámicos.


Con el tiempo, esos sistema llamaron la atención de un público menos científico debido a su cualidad recreacional, pues no era necesario entender los fundamentos matemáticos de estos para poder disfrutar sus interacciones. De esta forma, y con un enfoque orientado a lo lúdico, es como surgieron los simuladores de arena.