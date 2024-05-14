== Simuladores de arena <simuladoresArena>

En este capítulo, se hablará de manera resumida acerca de qué son los simuladores de partículas de manera general así como sus múltiples aplicaciones a diferentes sectores. Mas tarde, se presentan una serie de antecedentes que se han tomado de base para el desarrollo del proyecto.

=== Introducción a la simulacion de partículas

Los simuladores de partículas son una variante de autómatas celulares@cellular_automata_thomasmli, que ha ganado relevancia en sectores como el de los videojuegos debido a su capacidad para representar con precisión interacciones dinámicas presentes en el mundo real."

// al parecer este parrafo esta fatal, define que es un sistema de partículas aqui----


Los simuladores de partículas cumplen las características básicas que permiten considerarlos autómatas celulares, ya que: el "mapa" de la simulación está formado por un conjunto de celdas dentro de un número finito de dimensiones, cada una de estas celdas se encuentra, en cada paso discreto de la simulación, en un estado concreto dentro de un número finito de estados en los que puede encontrarse y el estado de cada celda es determinado mediante interacciones locales, es decir, está determinado por condiciones relacionadas con sus celdas adyacentes.

Estos abarcan una gran diversidad de enfoques destinados a proporcionar diferentes funcionalidades y experiencias dependiendo del enfoque del proyecto. Algunos de los tipos mas reseñables son: 

- Simulador de fluidos @fluid_simulation: enfoque dirigido a la replicación del comportamiento de sustancias como pueden ser el agua y diferentes clases de fluidos, lo que implica la simulación de fenómenos como flujos y olas y de propiedades físico químicas como la viscosidad y densidad del fluido.

- Simulador de efectos @particle_simulation: categoría que apunta a la simulación detallada de efectos de partículas, como pueden ser las chispas, humo, polvo, o cualquier elemento minúsculo que contribuya a la creación y composición de elementos visuales para la generación de ambientes inmersivos.

- Simuladores de arena @sand_simulation: conjunto de simuladores cuyo objetivo es la replicación exacta de interacciones entre elementos físicos como granos de arena u otros materiales granulares. Esto implica la modelización de interacciones entre particulas individuales, como pueden ser colisiones o desplazamientos, buscando recrear interacciones reales de terrenos.


=== Importancia y aplicación en diversos campos

La versatilidad de los simuladores de partículas ha llevado a su aplicación y adopción en una vasta gama de disciplinas mas allá de los videojuegos, debido a la facilidad que ofrecen para trabajar con fenómenos físicos de manera digital.

Algunos de los campos que han hecho uso de simuladores de particulas son:

- Física y ciencia de materiales

Los simuladores de partículas han permitido la experimentación virtual de propiedades físicas de diferentes elementos, como pueden ser la dinámica de partículas en sólidos o la simulación de materiales.

- Ingeniería y construcción: Se emplean simuladores con el objetivo de prever y comprender el funcionamiento de diferentes estructuras y materiales en el ámbito de construcción antes de su edificación, lo que permite predecir elementos básicos como la distribución de fuerzas y tensiones así como el comportamiento ante distintos fenómenos como pueden ser terremotos. El proyecto OpenSees@OpenSees le proporciona esta funcionalidad a ingenieros para comprar la seguridad en el diseño de sus edificaciones.

- Medicina y biología: Los simuladores de partículas en el ámbito de la medicina permite modelar comportamientos biológicos así como, por ejemplo, imitar la interacción y propagación de sustancias en fluidos corporales, ayudando al desarrollo de tratamientos médicos. Por ejemplo, existe el proyecto SimVascular@SimVascular el cual ofrece herramientas para simular y visualizar flujos sanguíneos en modelos de vasos sanguíneos.

=== Simuladores de arena como videojuegos

//Pon un ejemplo de arena cayendo y su comportamiento comparandolo con automatas celulares

Dentro de la industria de los videojuegos, se han utilizado simuladores de arena con diferentes fines, como pueden ser mejorar la calidad visual o aportarle variabilidad al diseño y jugabilidad del propio videojuego.

Este proyecto toma como principal referencia a "Noita", un videojuego indie roguelike que utiliza la simulación de partículas como núcleo principal de su jugabilidad. En "Noita", cada píxel en pantalla representa un material y está simulado siguiendo unas reglas físicas y químicas específicas de ese material. Esto permite que los diferentes materiales sólidos, líquidos y gaseosos se comporten de manera realista de acuerdo a sus propiedades. El jugador tiene la capacidad de provocar reacciones en este entorno, por ejemplo destruyendolo o haciendo que interactúen entre sí.


#figure(
  image("../images/Noita.png", width: 50%),
  caption: [
    Imagen gameplay de Noita
  ],
)

Noita no es el primer videojuego que hace uso de los simuladores de partículas. A continuación, se enumeran algunos de los títulos, tanto videojuegos como sandbox, más notables de simuladores de los cuales el proyecto ha tomado inspiración durante el desarrollo.

- Falling Sand Game @falling_sand_game
Probablemente el primer videojuego comercial de este subgénero. A diferencia de Noita, este videojuego busca proporcionarle al jugador la capacidad de experimentar con diferentes partículas físicas así como fluidos y gases, ofreciendo la posibilidad de ver como interaccionan tanto en un apartado físico como químicas. Este videojuego estableció una base que luego tomaron otros videojuegos más adelante.
- Powder Toy @powder_toy
Actualmente el sandbox basado en partículas más completo y complejo del mercado. Este no solo proporciona interacciones ya existentes en sus predecesores, como Falling Sand Game, sino que añade otros elementos físicos de gran complejidad como pueden ser temperatura, presión, gravedad, fricción, conductividad, densidad, viento etc.
- Sandspiel @sandspiel
Este proyecto utiliza la misma base de sus predecesores, proporcionando al jugador libertad de hacer interaccionar partículas a su gusto. Además, añade elementos presentes en Powder Toy como el viento, aunque la escala de este proyecto es mas limitada que la de proyectos anteriores. De Sandspiel, nace otro proyecto llamado Sandspiel Club @sandspiel_club, el cual utiliza como base Sandspiel, pero, en esta versión, el creador porporciona a cualquier usuario de este proyecto la capacidad de crear partículas propias mediante un sistema de scripting visual haciendo uso de la librería Blockly @blockly de Google. Además, similar a otros títulos menos relevantes como Powder Game (no confundir con Powder Toy), es posible guardar el estado de la simulación y compartirla con otros usuarios. A cambio de esta funcionalidad, en Sandspiel Club no es posible hacer uso del viento, elemento sí presente en Sandspiel.

#text(weight: "bold")[Resumen]

Hasta ahora se han visto las bases de lo que es un automata celular y los usos y extension de uno de sus subgeneros, los simuladores de arena, además de algunos ejemplos de su aplicación dentro del sector de los videojuegos. 

// AÑADIR UNA JUSTIFICACION MAS GRANDE PARA EL PROXIMO CAPITULO ------------

Es intuible el hecho de que la simulación de partículas básicas es un caso de problema 'Embarrassingly parallel', es decir, problema donde la sub-separación de una tarea grande en otras muy pequeñas independientes entre ellas es obvia o directa. Esto, desde el punto de vista de software, permite hacer uso de programación en paralelo para resolver el problema, lo cual abre la posibilidad de utilizar la GPU para procesar la lógica de la simulación.
Por lo que ahora, se introducirá al lector al funcionamiento y programacion de GPUs , hablando acerca de su evolución, arquitectura, y sus usos.

