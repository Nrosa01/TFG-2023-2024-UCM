La implementación realizada en Lua resulta ser muy versátil dado su rendimiento y facilidad de uso considerando un perfil técnico. Para su uso en videojuegos esta opción puede llegar a ser viable con un poco más de trabajo para simular solamente grupos de partículas activas y no la totalidad de las partículas en memoria.

La simulación web es idónea para simulaciones de un tamaño reducido. Debido a su interfaz amigable esta implementación puede ser usada para enseñar conceptos básicos de programación y simulación, así como de introducción a los simuladores de arenas y autómatas celulares.

Desarrollar simuladores en GPU resulta ser una buena opción cuando se requiere una gran potencia de cómputo o cuando el tamaño de la simulación es muy grande, pero implementar nuevos comportamientos es complicado.

Como trabajo a futuro existen diversas tareas y ampliaciones. En primer lugar, en la simulación web se podría añadir cálculo vectorial, esto permitiría realizar operaciones con partículas que estén alejadas y no solo con las vecinas inmediatas. También sería interesante replicar la simulación web con código nativo para lograr un rendimiento mayor. Además, esto permitiría explorar la posibilidad de generar código GLSL de la interfaz de bloques para poder ejecutar la simulación en GPU. Realizar esto implicaría crear una interfaz de programación visual similar a Blockly de cero.

La simulación web podría ser modificada para que su procesamiendo sea similar al de un autómata celular como en la implementación realizada en Lua, esto permitiría crear el juego de la vida, ya que en el estado actual no es posible.

La implementación de Lua podría ser mejorada añadiendo más datos para las particulas, ya que actualmente solo tienen `clock` e `id`. De realizarse esta ampliación, sería posible crear la ya mencionada interfaz de programación visual nativa para poder generar código Lua.

