== Autómatas Celulares

=== Introducción y definición

Introducidos por John von Neumann@neumann en 2023, los autómatas celulares@ca_wiki son un modelo matemático que consiste en una matriz n-dimensional de celdas. Cada celda puede estar en un estado de un conjunto de estados finitos. Estos estados cambian en función de los estados de sus celdas vecinas cada unidad discreta de tiempo llamada generación@ca_andrew. Cada celda tiene 8 vecinos, esto incluye laterales y esquinas. Al procesar un automátata celular, una celda y sus vecinos se consideran como una sola, esto es llamado 'vencidad de Moore'@moore_neighborhood. Si solo se consideran los vecinos sin las esquinas entonces es llamado 'vencidad de Neumann'@neumann_neighborhood. Por último, para definir un autómata celular necesitamos una 'regla' que aplicar a cada celda, esta transformará el sistema de celdas en el siguiente estado en cada generación. 

=== Ejemplo de autómata celular

Un ejemplo de autómata celular sería el siguiente:

- Matriz bidimensional infinita

Matriz bidimensional

- Estado

  - Viva
  - Muerta

- Reglas

    + Si una celda está viva y tiene 2 o 3 vecinos vivos, entonces sigue viva, en otro caso muere.

    + Si una celda está muerta y tiene 3 vecinos vivos, entonces nace, en otro caso sigue muerta.

A continuación mostraré un ejemplo de este sistema mediante una generación a partir de un estado inicial. Para este ejemplo asumiremos una vista parcial de la matriz infinita. Esta tendrá tamaño 5x6. Se asume que las celdas fuera de la matriz son muertas.

#let initial_state = (0, 1, 1, 0, 1, 0,
              0, 0, 1, 0, 0, 0,
              0, 1, 1, 0, 1, 0,
              1, 0, 0, 0, 1, 0,
              0, 1, 1, 0, 1, 0)

#let final_state = (0, 1, 1, 1, 0, 0,
                    0, 0, 0, 0, 0, 0,
                    0, 1, 1, 0, 0, 0,
                    1, 0, 0, 0, 1, 1,
                    0, 1, 0, 1, 0, 0)


#align(center + horizon)[
  #stack(
    dir: ltr,
    spacing: 20pt,
  
    grid(
      columns: 6, 
      gutter: 5pt, 
      ..initial_state.map(str => 
          rect(
            stroke: 1pt, 
            width: 10pt, 
            height: 10pt, 
            fill: if str == 1 {black} else {white}))),
    $-->$,
    grid(
      columns: 6, 
      gutter: 5pt, 
      ..final_state.map(str => 
          rect(
            stroke: 1pt, 
            width: 10pt, 
            height: 10pt, 
            fill: if str == 1 {black} else {white}))))

    #show figure.caption: emph

    #figure("",caption: [Ejemplo de autómata celular])
]



Este sistema en particular, es conocido como 'Juego de la vida'@ca_andrew, y fue propuesto por John Conway@conway en 1970.

=== Autómatas celulares notables y su impacto

- Juego de la vida

El Juego de la Vida, propuesto por el matemático John Conway, es un autómata celular bidimensional que se desarrolla en una cuadrícula infinita de células, cada una de las cuales puede estar en uno de dos estados: viva o muerta. La evolución del juego está determinada por reglas simples basadas en el número de vecinos vivos alrededor de cada célula. Este modelo ha demostrado ser notable debido a su capacidad para generar patrones complejos y estructuras dinámicas a partir de reglas simples de transición de estados. El Juego de la Vida ha sido ampliamente estudiado en el campo de la teoría de la complejidad y ha sido utilizado como un modelo para explorar la autoorganización y la emergencia de la complejidad en sistemas dinámicos.

- Autómata de Contacto@ca_karl_johannes

Un autómata de contacto puede considerarse como uno de los modelos más simples para la propagación de una enfermedad infecciosa. Imagina una cuadrícula cuadrada de celdas. Supongamos que todas las celdas son "blancas" (o "no infectadas") excepto un número finito de celdas "negras" (o "infectadas"). Para una celda dada, definimos los vecinos como las ocho celdas inmediatamente adyacentes y la celda misma. Una versión determinista de un proceso de contacto funciona en pasos discretos de tiempo de la siguiente manera: una celda negra permanece negra, una celda blanca que es vecina de una celda negra se vuelve negra. Este sistema puede denominarse un proceso de contacto determinista. Si comenzamos con una sola celda negra, entonces el número de celdas negras aumenta en 1, 9, 25, etc. La forma general sigue siendo cuadrática. Se usa en la investigación de propagación de fenómenos epidemiológicos.

- Autómatas de Wolfram@ca_karl_johannes

Los Autómatas de Wolfram, propuestos por el físico y matemático Stephen Wolfram, son un conjunto de reglas para autómatas celulares unidimensionales. Cada regla define cómo evolucionan las células en función de su estado y el estado de sus vecinos. Numeradas del 0 al 255, estas reglas proporcionan un marco teórico para explorar la complejidad emergente y la computación universal en sistemas celulares simples.

- Autómata de Greenberg-Hastings@ca_karl_johannes

El Autómata de Greenberg-Hastings es un modelo de autómata celular que ha sido utilizado para simular patrones de propagación de la actividad eléctrica en tejidos cardiacos. Destacando por su capacidad para modelar fenómenos de propagación y ondas, este autómata sigue reglas específicas para la activación y desactivación de células, lo que lo convierte en una herramienta valiosa en la investigación biomédica.

- Autómata de Langton@ca_karl_johannes

El Autómata de Langton, propuesto por Christopher Langton, es un autómata celular bidimensional que se caracteriza por su simplicidad y la complejidad emergente de sus patrones. Se basa en reglas locales sencillas, donde cada célula evoluciona en función de su estado actual y el número de vecinos en cada paso. A pesar de su simplicidad, el Autómata de Langton puede generar patrones dinámicos y estructuras complejas, lo que lo convierte en un modelo intrigante en el estudio de la autoorganización en sistemas complejos.