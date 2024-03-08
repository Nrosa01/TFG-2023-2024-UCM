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

=== Autómatas celulares notables

- Juego de la vida

- Autómata de Contacto@ca_karl_johannes

- Autómatas de Wolfram@ca_karl_johannes

- Autómata de Greenberg-Hastings@ca_karl_johannes

- Autómata de Langton@ca_karl_johannes

=== Aplicaciones e impacto