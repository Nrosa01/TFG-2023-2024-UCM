El desarrollo de software puede llegar a ser complejo. Mientras más funcionalidad se requiere más complejo es mantener el código. Debido a esto, los ingenieros de software han desarrollado una serie de técnicas y metodologías para facilitar el desarrollo de software. Un problema habitual, es querer usar cierta funcionalidad en diferentes programas. Podría implementarse en cada uno de estos, pero en dicho caso se está duplicando código. Además de que hay que mantener la misma funcionalidad en diferentes lugares. Para paliar este problema existen las librerías dinámicas y estáticas @linkers_and_loaders. Una librería dinámica no forma parte del programa en sí, es un archivo separado del ejecutable principal. En cambio, una librería estática es parte del ejecutable. Esto tiene varias implicaciones, de las cuales una es particularmente interesante: Se puede cambiar una librería dinámica por otra, actualizando así el programa sin tener que compilarlo entero.

Esta particularidad da lugar a la posibilidad de crear plugins @plugin_architecture. Sin embargo, un plugin no tiene por qué ser una librería dinámica. Un plugin es cualquier componente de software que permita añadir funcionalidad a un programa sin tener que modificar el código fuente del programa.

#text(red)[Esto ahora es mi propia observación, así que no sé, no puedo citar nada aquí:]

Tras investigar distintos mecanismos para extender un programa, se he llegado a la conclusión de que hay 3 posibilidades principales. Cada una con sus ventajas y desventajas: 

== Extensión mediante librería dinámica

== Extensión mediante un archivo propieatiario

== Extensión mediante un lenguaje de scripting