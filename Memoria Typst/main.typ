#import "template.typ": *

// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "TFG Noita",
  authors: (
    "Nicolás Rosa Caballero",
    "Jonathan Andrade Gordillo",
  ),
  // Insert your abstract after the colon, wrapped in brackets.
  // Example: `abstract: [This is my abstract...]`
  abstract: lorem(59),
  date: "February 26, 2024",
)

#outline(indent: auto)

No sé si esta es la mejor forma de crear una tabla de figuras pero es lo que encontré por ahora. Es posible crear una tabla usando una query (figure.where) y dándole el formato que nosotros queramos.

#outline(
  title: "Figuras",
  target: figure.where()
)

#pagebreak(weak: true)

= Introduction

#lorem(800)

#pagebreak(weak: true)

= Autómatas Celulares y simuladores de arena

#include "capitulos/2.1.AutomatasCelulares.typ"

#include "capitulos/2.2.SimuladoresDeArena.typ"

#pagebreak(weak: true)

= Programación paralela

#lorem(800)

#pagebreak(weak: true)

= Plug-ins y lenguaje de script

#lorem(800)

#pagebreak(weak: true)

= Simulador en CPU

#lorem(800)

#pagebreak(weak: true)

= Simulador en GPU

#lorem(800)

#pagebreak(weak: true)

= Comparación y pruebas

#lorem(800)

#pagebreak(weak: true)

= Conclusiones y trabajo futuro

#lorem(800)

#pagebreak(weak: true)

#bibliography("bibliography.yml")
