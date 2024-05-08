Una vez concluidas las pruebas, se procedió al análisis de los resultados obtenidos. A diferencia de las pruebas, no se hará una diferenciación entre rendimiento y usabilidad, sino que se decidió evaluar el valor que aporta cada simulador por separado. Finalmente se concluye con una vista global y se proponen mejoras para futuras versiones.

Lo más destacable de las pruebas es la gran diferencia de rendimiento entre los simuladores implementados en CPU y el implementado en GPU. Sin embargo el coste de implementación y extensión es mucho mayor. En este simulador no se pudo probar la usabilidad con usuarios debido a que para ello se requería compilar el proyecto, lo cual requiere ciertas herramientas que muchos usuarios no están dispuestos a instalar. Una implementación en GPU puede resultar ideal cuando se requiere un alto rendimiento pero además el comportamiento que se trata de lograr es altamente específico y de una complejidad moderada. Una implementación de estas características puede resultar útil para la investigación de autómatas celulares en las que se requiera procesar una gran cantidad de partícula simultáneamente para buscar patrones de grandes dimensiones que no podrían ser detectados con una implementación en CPU. Podría resultar interesante la investigación de un sistema que permita generalizar reglas para crear autómatas celulares en la GPU de forma flexible. Esto no ha sido posible con simuladores de arena debido a que en estos, una partícula puede modificar las vecinas, sin embargo, en los autómatas celulares cada celda como mucho puede modificarse a sí misma, lo que podría simplificar la implementación.

La implementación en C++ se realizó como una base para medir las demás. Esta nos ha permitido cuantificar la penalización de rendimiento que incurre la flexiblidad usar un lenguaje interpretado como Lua, aún en su versión JIT, así como usar WebAssembly. El desarrollo de simuladores de arena en C++ incurre en el mismo problema que la GPU, se requiere acceso al código y herramientas de desarrollo para poder extenderlo. 

En cuanto a la implementacion en Lua, sorprende el rendimiento que puede lograr dada la flexibilidad que ofrece. Sin embargo, desarrollar interfaces es más complejo debido a la escasez de librerías para ello. Con suficiente trabajo, esta implementación tiene el potencial de ser la solución más balanceada de idónea para simuladores de arena en CPU. Pues mediante el multihilo el rendimiento logrado resulta ser superior a lo esperado. Si se asume un público objetivo con un perfil más técnico, esta implementación resulta mucho más potente, pues ofrece aún más cotrol que la de Blockly y las pruebas muestran que desarollar partículas programando llega a ser igual de rápido y sencillo que mediante bloques. Para su uso en videojuegos esta opción puede llegar a ser viable con un poco más de trabajo para simular solamente grupos de partículas activas y no la totalidad de las partículas en memoria.

Por último, la implementación en Rust con Blockly destaca por resultar más lenta de lo esperado. La curva de aprendizaje mediante bloques resultó superior a la esperada, sin embargo, pasada esta, los usuarios parecen ser capaces de desarrollar particulas con facilidad sin requerir nociones de programación. Esta implementación resulta ser la más accesible debido a que simplemente requiere de un navegador, software que cualquier dispositivo inteligente actual posee. Debido a su rendimiento, esta implementación no es idónea para explorar simulaciones de una gran complejidad o tamaño. Esto podría paliarse mediante la implementación de multihilo, sin embargo, debido a las reglas de seguridad de memoria de Rust y la poca madurez de multihilo en WebAssembly, esta tarea resulta en una complejidad muy alta, existiendo la posibilidad de que no se pueda lograr. Por lo tanto esta versión resulta ser la más idónea para simulaciones de baja complejidad y tamaño. También puede considerarse como una opción viable para enseñar lógica e introducir, a los simuladores de arena y, con ciertas modificaciones, a los autómatas celulares.

En conclusión, desarrollar simuladores en GPU resulta ser una buena opción cuando se requiere una gran potencia de cómputo cuando el tamaño de la simulación es muy grande. En CPU, una versión nativa en Lua con multihilo ofrece un rendimiento digno que permite explorar diversos tipos de simulaciones con facilidad siempre que no sean excesivamente complejos. Finalmente, una implementación en Rust con Blockly resulta ser la opción más accesible y sencilla, pero con un rendimiento más limitado.



