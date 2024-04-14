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

#pagebreak()

No sé si esta es la mejor forma de crear una tabla de figuras pero es lo que encontré por ahora. Es posible crear una tabla usando una query (figure.where) y dándole el formato que nosotros queramos.

#outline(
  title: "Índice de Figuras",
  target: figure.where()
)

#pagebreak(weak: true)

= Introduction



#pagebreak(weak: true)

= Autómatas Celulares y simuladores de arena

#include "capitulos/2.1.AutomatasCelulares.typ"

#include "capitulos/2.2.SimuladoresDeArena.typ"

#pagebreak(weak: true)

= Programación paralela

#include "capitulos/3.ProgramacionParalela.typ"

#pagebreak(weak: true)

= Plug-ins y lenguajes de scripting

#include "capitulos/4.PluginsYScripting.typ"


= Simulador en CPU

#include "capitulos/5.SimuladorCPU.typ"


= Simulador en GPU




= Comparación y pruebas



= Conclusiones y trabajo futuro



#bibliography("bibliography.yml")
