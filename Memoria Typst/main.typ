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

= Introduction

= Autómatas Celulares y simuladores de arena

#include "capitulos/2.1.AutomatasCelulares.typ"

= Programación paralela

= Plug-ins y lenguaje de script

= Simulador en CPU

= Simulador en GPU

= Comparación y pruebas

= Conclusiones y trabajo futuro

#bibliography("bibliography.yml")
