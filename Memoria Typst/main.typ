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

#outline(indent: auto)

#pagebreak()

#outline(
  title: "Índice de Figuras",
  target: figure.where()
)

#pagebreak(weak: true)

= Introducción

== Motivación

== Objetivos

== Plan de trabajo

= Introduction

== Motivation

== Objectives

== Work plan

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

= CPU y Multithreading

#include "capitulos/3.5.ProgramaciónParalelaCPU.typ"

= Simulador en CPU

#include "capitulos/5.SimuladorCPU.typ"


= Simulador en GPU


= Comparación y pruebas

#include "capitulos/ComparacionYPruebas.typ"

= Conclusiones y trabajo futuro

= Conclusions and future work

= Contribuciones

#include "capitulos/Contribuciones.typ"

#bibliography("bibliography.yml")
