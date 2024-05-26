== Motivación

Los simuladores de arena fueron un subgénero emergente durante la década de los noventa, y continuaron siendo populares hasta principios de los años 2000. Durante ese tiempo, surgieron muchos programas y juegos que permitían a la gente interactuar con mundos virtuales llenos de partículas simuladas. Esto atrajo tanto a amantes de la simulación como a desarrolladores de videojuegos. Sin embargo, tras un período de relativa tranquilidad, estamos presenciando un nuevo auge del género de la mano de videojuegos como Noita o simuladores sandbox como Sandspiel.

Este proyecto nace del deseo de sumergirnos en el mundo de los simuladores de arena. Queremos explorar sus diferentes aspectos y características así como entender mejor las ventajas y desventajas de diferentes enfoques de desarrollo de cara al usuario, para así poder contribuir a su evolución y expansión, ya que consideremos que es un subgénero que puede dar muy buenas experiencias de juego y de uso. 

En resumen, queremos entender y ayudar a mejorar los simuladores de arena  para hacerlos más útiles y efectivos para los usuarios.


== Objetivos <Objetivos>

El principal objetivo de este TFG es estudiar el comportamiento y aprendizaje de usuarios haciendo uso de diferentes implementaciones de simuladores de arena. 

Se valorará la funcionalidad de cada implementación haciendo uso de los siguientes parámetros:

- Comparación de rendimiento: se compararán bajo las mismas condiciones, tanto a nivel de hardware como en uso de partículas midiendo el rendimiento final conseguido. Este rendimiento se comparará haciendo uso de razón nº partículas / frames por segundo conseguidos. Idealmente se averiguará la mayor cantidad de partículas que cada simulador puede soportar manteniendo 60 fps.

- Comparación de usabilidad: se estudiará el comportamiento de un grupo de usuarios para valorar la facilidad de uso y de entendimiento de sistemas de ampliación de los sistemas que permitan expansión por parte del usuario. Se valorará la rapidez para realizar un set de tareas asi como los posibles desentendimientos que puedan tener a la hora de usar el sistema.

Con estos análisis, se pretende explorar las características que contribuyen a una experiencia de usuario óptima en un simulador de arena, tanto en términos de facilidad de uso como de rendimiento esperado por parte del sistema. Al comprender mejor estas características, se podrán identificar áreas de mejora y desarrollar recomendaciones para optimizar la experiencia general del usuario con los simuladores de arena.

Nuestro objetivo es encontrar un balance entre rendimiento y facilidad de extensión que proporcione tanto un entorno lúdico a usuarios casuales como una base sólida de desarrollo para desarrolladores interesados en los simuladores de arena. 

== Plan de trabajo

La metodología de trabajo a usar será una variante de scrum ajustada a nuestras necesidades. Se elaborará un tablero de tareas en el que se reflejarán las tareas a realizar, el estado de cada tarea y el tiempo estimado para su realización. No habrá reuniones diarias pero se fijarán tareas a realizar cada semana, así como reuniones semanales para revisar el estado del proyecto y ajustar el tablero de tareas en consecuencia.

Por otro lado, se planean reuniones cada dos semanas con el tutor para revisar el estado del proyecto y recibir feedback sobre el trabajo realizado, así como orientación al respecto de las tareas a realizar en el futuro.

Respecto al trabajo, lo primero será realizar una investigación preliminar sobre los conceptos fundamentales de los autómatas celulares y los simuladores de arena, así como de sistemas ya existentes para entender cómo se han abordado problemas en el pasado. Se espera que esta investigación dure aproximadamente dos meses.

Tras esto se planea la realización de 4 implementaciones: 

- Simulación nativa base: Esta será la simulación usada de base para comparar las demás. Debe ser eficiente y sentar las bases de como se realiza el procesado de partículas. Esta implementación será difícil de ampliar debido a esto. Se espera realizar esta implementación en C o C++ debido a la familiaridad con el lenguaje. Se espera que esta implementación sea realizada entre un mes y un mes y medio.

- Simulación en GPU: Esta implementación se realizará en un lenguaje de programación que permita la ejecución de código en GPU, como CUDA u OpenCL. El objetivo de esta implementación es explorar la viabilidad de realizar la simulación de partículas en GPU, así como comparar el rendimiento con las demás implementaciones. Se espera que esta implementación también sea difícil de ampliar. Se espera realizar esta implementación en un mes.

- Simulación nativa ampliada con un lenguaje de script: Será necesario investigar y elegir un lenguaje de script que permita la ampliación de la simulación base de manera sencilla manteniendo el mayor rendimiento posible. Se espera realizar esta implementación entre uno y dos meses.

- Simulación accesible mediante lenguaje de programación visual: Se investigarán librerías y frameworks que permitan definir código o datos mediante programación visual. Se espera que esta implementación sea la más sencilla de ampliar y la más accesible para usuarios no técnicos. Se investigará la posibilidad de ejecutar esta simulación en la web para mayor accesibilidad. Se espera realizar esta implementación entre uno y dos meses.

Se considera la posibilidad de que se realicen más simuladores si la investigación da a conocer una posibilidad alternativa que aporte valor a la comparativa.

Tras realizar las distintas implementaciones, se realizarán pruebas de usuario para comparar los resultados obtenidos por cada una de ellas. Se analizarán los datos obtenidos y se compararán los resultados para extraer conclusiones sobre las ventajas y desventajas de cada implementación. Se espera realizar estas pruebas en un periodo de dos a tres semanas.

