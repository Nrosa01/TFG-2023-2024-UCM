== Simuladores de arena
=== Introducción a la simulacion de partículas

Los simuladores de partículas son un subgénero destacado tanto en el sector de los videojuegos como en el de los automatas celulares @ca_wiki, haciendose uso de ellos para herramientas y experiencias capaces de representar interacciones dinámicas en sistemas complejos.

En primer instancia, creo que es importante destacar las características que hacen a los simuladores de partículas ser considerados automatas celulares. Más tarde indagaremos en cómo cumplen esta serie de condiciones, ahora nos centraremos en qué cumplen.
- El "mapa" de la simulación está formado por un conjunto de celdas dentro de un número finito de dimensiones.
- Cada una de estas celdas se encuentra, en cada paso discreto de la simulación, en un estado concreto dentro de un número finito de estados en los que puede encontrarse.
- El estado de cada celda es determinado mediante interacciones locales, es decir, está determinado por condiciones relacionadas con sus celdas adyacentes. Estas condiciones variarán de simulación a simulación.

Una vez introducidos puntos clave acerca de la simulación de partículas, podemos pasar a hablar acerca de temas como los tipos de simulaciones que existen, sus condiciones de implementación específicas, o su aplicación a diversos dominios y áreas de estudio.

=== Tipos de simuladores

Los simuladores de partículas abarcan una gran diversidad de enfoques destinados a proporcionar diferentes funcionalidades y experiencias dependiendo del enfoque del proyecto. Algunos de los tipos mas reseñables son:


- Simulador de fluidos @fluid_simulation: Enfoque dirigido a la replicación del comportamiento de sustancias como pueden ser el agua y diferentes clases de fluidos, lo que implica la simulación de fenómenos como flujos y olas y de propiedades físico químicas como la viscosidad y densidad del fluido.

- Simulador de efectos @particle_simulation: Categoría que apunta a la simulación detallada de efectos de partículas,como pueden ser las chispas, humo, polvo, o cualquier elemento minúsculo que contribuya a la creación y composición de elementos visuales para la generación de ambientes inmersivos.

- Simuladores de arena @sand_simulation: Conjunto de simuladores cuyo objetivo es la replicación exacta de interacciones entre elementos físicos como granos de arena u otros materiales granulares. Esto implica la modelización de interacciones entre particulas individuales, como pueden ser colisiones o desplazamientos, buscando recrear interacciones reales de terrenos.

Nuestro proyecto busca englobar estas 3 categorías principales en distinta extensión, ya que la base mas sólida del proyecto se basa en, principalmente, los simuladores de arena, añadiendo elementos de otras categorías para crear una experiencia lo más completa posible.

=== Metodologías y algoritmos de simulación

Aquí iba a hablar de condiciones básicas y comunes de simuladores de arena, como el comportamiento de particulas de arena, agua etc, basicamente un remix del video inicial en el que nos basamos, no se si eso deberia estar mas abajo una vez empecemos a hablar de nuestro juego por lo que lo dejo por aquí.

=== Importancia y aplicación en diversos campos

La versatilidad de los simuladores de partículas ha llevado a su aplicación y adopción en una vasta gama de disciplinas mas allá de los videojuegos, debido a la facilitación que ofrecen de trabajar con fenómenos físicos de manera digital.

Algunos --- aunque no todos --- de los campos que han hecho uso de simuladores de particulas, así como una pequeña explicación acerca de su aplicación son:

+ Física y ciencia de materiales 
  - Los simuladores de partículas han permitido la experimentación virtual de propiedades físicas de diferentes elementos, como pueden ser la dinámica de partículas en sólidos o la simulación de materiales.

+ Ingeniería y construcción
  - Se emplean simuladores con el objetivo de prever y comprender el funcionamiento de diferentes estructuras y materiales en el ámbito de construcción antes de su edificación, lo que permite predecir elementos básicos como la distribución de fuerzas y tensiones así como el comportamiento ante distintos fenómenos como pueden ser terremotos

+ Medicina y biología
  - Los simuladores de partículas en el ámbito de la medicina permite modelar comportamientos biológicos así como, por ejemplo, imitar la interacción y propagación de sustancias en fluidos corporales, ayudando al desarrollo de tratamientos médicos.

=== Simuladores de arena como videojuegos

Dentro de la industria de los videojuegos, se han utilizado simuladores de partículas con diferentes fines, como pueden ser: proporcionarle libertad al jugador, mejorar la calidad visual o aportarle variabilidad al diseño y jugabilidad del propio videojuego.

Este proyecto tiene como principal referente Noita@noita, el cual usa la simulación de partículas como núcleo principal de jugabilidad, dandole al jugador sensación de libertad y proporcionándole una magnitud de jugabilidad emergente comparable a muy pocos títulos existentes en el mercado.

Por supuesto, Noita no es el primer videojuego que hace uso de los simuladores de partículas para proporcionar una experiencia de juego diferente. A continuación, voy a enumerar algunos de los títulos más notables de simuladores de los cuales hemos tomado inspiración durante el desarrollo.

+ Falling Sand Game @falling_sand_game
  - Probablemente el primer videojuego comercial de este amplio subgénero. A diferencia de Noita, este videojuego busca proporcionarle al jugador la capacidad de experimentar con diferentes partículas físicas así como fluidos y gases, ofreciendo la posibilidad de ver como interaccionan tanto en un apartado físico como químicas. Este videojuego establecería una base que luego tomarían videojuegos más adelante.
+ Powder Toy @powder_toy
  - Actualmente el sandbox basado en partículas más completo y complejo del mercado. Este no solo proporciona interacciones ya existentes en sus predecesores, como Falling Sand Game, sino que añade otros elementos físicos de gran complejidad como pueden ser: temperatura, presión, gravedad, fricción, conductividad, densidad, viento etc.
+ Sandspiel @sandspiel
  + Sandspiel
    - Este proyecto utiliza la misma base de sus sucesores, proporcionando al jugador libertad de hacer interaccionar partículas a su gusto. Además, añade elementos presentes en Powder Toy como el viento, aunque la escala de este proyecto es mas limitada que la de proyectos anteriores. 
  + Sandpiel Club @sandspiel_club
    - Este proyecto utiliza como base Sandspiel, pero, en esta versión, el creador porporciona a cualquier usuario de este proyecto la capacidad de crear partículas propias mediante un sistema de scripting visual haciendo uso de la librería blockly @blockly de Google. Además, similar a otros títulos menos relevantes como Powder Game (No confundir con Powder Toy), es posible guardar el estado de la simulación y compartirla con otros usuarios. A cambio de esta funcionalidad, en Sandspiel Club no es posible hacer uso del viento, elemento sí presente en Sandspiel.