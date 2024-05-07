#import "template.typ": *

// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Exploración y análisis de rendimiento y extensibilidad de diferentes implementaciones de simuladores de partículas",
  titleEng: "Exploration and analysis of performance and extensibility of different implementations of particle simulators.",
  authors: (
    "Nicolás Rosa Caballero",
    "Jonathan Andrade Gordillo",
  ),
  course: "Trabajo de Fin de Grado ",
  degree: "Grado en Desarrollo de Videojuegos",
  directors: (
    "Pedro Pablo Gómez Martin ",
  ),
  // Insert your abstract after the colon, wrapped in brackets.
  // Example: `abstract: [This is my abstract...]`
  abstract: lorem(59),
  date: "7 de mayo de 2024",
)

#pagebreak(weak: true)

= Agradecimientos

#pagebreak(weak: true)

= Resumen 

= palabras clave 

#pagebreak(weak: true)

= Abstract

= Key Words

#pagebreak(weak: true)

#outline(
  title: "Índice de Figuras",
  target: figure.where()
)

#outline(indent: auto)

#pagebreak(weak: true)

= Introducción

#include "capitulos/1.Introduccion.typ"

#pagebreak(weak: true)

= Introduction

#include "capitulos/1.Introduction.typ"

#pagebreak(weak: true)

= Autómatas Celulares y simuladores de arena

#include "capitulos/2.1.AutomatasCelulares.typ"

#pagebreak(weak: true)

#include "capitulos/2.2.SimuladoresDeArena.typ"

#pagebreak(weak: true)

= Programación paralela

#include "capitulos/3.ProgramacionParalela.typ"

#pagebreak(weak: true)

= Plug-ins y lenguajes de scripting

#include "capitulos/4.PluginsYScripting.typ"

#pagebreak(weak: true)

= CPU y Multithreading

#include "capitulos/3.5.ProgramaciónParalelaCPU.typ"

#pagebreak(weak: true)

= Simulador en CPU

#include "capitulos/5.SimuladorCPU.typ"

#pagebreak(weak: true)

= Blockly

#include "capitulos/5.1.Blockly.typ"

#pagebreak(weak: true)

= Simulador en GPU

#include "capitulos/6.SimuladorGPU.typ"

#pagebreak(weak: true)

= Comparación y pruebas

#include "capitulos/ComparacionYPruebas.typ"

#pagebreak(weak: true)

= Conclusiones y trabajo futuro

#pagebreak(weak: true)

= Conclusions and future work

#pagebreak(weak: true)

= Contribuciones

#include "capitulos/Contribuciones.typ"

#pagebreak(weak: true)

#bibliography("bibliography.yml")
