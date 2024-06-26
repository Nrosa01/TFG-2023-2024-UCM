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

#set heading(outlined: false, numbering: none, bookmarked: true)

= Agradecimientos

#include "capitulos/Agradecimientos.typ"

#pagebreak(weak: true)

= Resumen 

#include "capitulos/0.Resumen.typ"

#linebreak()

= Palabras clave 
#v(8pt)

- Simuladores de arena
- Automatas celulares
- Programación paralela
- Multihilo
- GPU
- Lua
- Rust
- WebAssembly
- Blockly
- Compute shader

#pagebreak(weak: true)

= Abstract

#include "capitulos/0.Abstract.typ"

#linebreak()

= Key Words
#v(8pt)

- Sand simulators
- Cellular automata
- Parallel programming
- Multithreading
- GPU
- Lua
- Rust
- WebAssembly
- Blockly
- Compute shader

#pagebreak(weak: true)


#outline(indent: auto)

#outline(
  title: "Índice de Figuras",
  target: figure.where()
)


#pagebreak(weak: true)

#set heading(outlined: true, numbering: "1.")

= Introducción

#include "capitulos/1.Introduccion.typ"

#pagebreak(weak: true)

#counter(heading).update(0)

= Introduction

#include "capitulos/1.Introduction.typ"

#pagebreak(weak: true)

= Autómatas celulares y simuladores de arena

#include "capitulos/2.1.AutomatasCelulares.typ"

#include "capitulos/2.2.SimuladoresDeArena.typ"

#pagebreak(weak: true)

= Programación paralela

#include "capitulos/3.ProgramacionParalela.typ"

#pagebreak(weak: true)

// = Plug-ins y lenguajes de scripting

// #include "capitulos/4.PluginsYScripting.typ"

= Estrategias para definir comportamiento en motores de videojuegos

#include "capitulos/4.PluginsYScriptingV2.typ"

#pagebreak(weak: true)

#pagebreak(weak: true)

= Simuladores de arena en CPU <SimuladorCPU>

#include "capitulos/5.SimuladorCPU.typ"

#pagebreak(weak: true)

= Simulador de arena en GPU <SimuladorGPU>

#include "capitulos/6.SimuladorGPU.typ"

#pagebreak(weak: true)

= Comparación y pruebas

#include "capitulos/ComparacionYPruebas.typ"

#pagebreak(weak: true)

= Conclusiones y trabajo futuro

#include "capitulos/Conclusiones.typ"

#pagebreak(weak: true)

#counter(heading).update(n => n - 1)

= Conclusions and future work

#include "capitulos/Conclusions.typ"

#pagebreak(weak: true)

= Contribuciones

#include "capitulos/Contribuciones.typ"

#pagebreak(weak: true)

#bibliography("bibliography.bib", style: "ieee")
