Mediados de agosto  2023

Vamos a asumir que la parte inicial de C++ era un proyecto base con los conceptos que más nos interesa implementar para entender como crear este tipo de simulaciones y luego poder investigar tú como hacerlo en GPU y yo como hacerlo en CPU pero ultra flexible

Primero creamos una demo simple con materiales cableados usando OpenGL 3.3 core (glfw) y IMGUI
https://www.glfw.org/

Luego añadí GLM

Septiembre 2023

1-10

Refactorización, antes estaba todo en main. Ahora hay una clase Quad y otra SandSimulation. SandSimulation tiene lógica y render, tiene una instancia de Quad.

Consideramos la idea de meter una cámara y un mundo infinito, pero para nuestra investigación no aporta mucho y decidimos optimizar lo máximo posible un solo chunk.

Tenemos un array de particulas y otro "have been updated" para no actualizar dos veces una partícula. El array "have been updated" es un array de booleanos que reseteamos cada frame con un memset.

10-30

Hablamos sobre introducir un fixed update. Nuestra concepción inicial es que las partículas tuvieran velocidad, ya fuera en float o enteros, si planteamos esto como un sistema físico, aunque sea simple, necesitamos un fixed update par que el sistema sea estable. (explicar esto). Introdujimos que las partículas puedan moverse más de un pixel por update usando un bucle for para comprobar colisiones. Actualmente tenemos un update normal

Octubre 2023

Introdujimos el FixedUpate. Se revertió el parámetro velocidad de las partículas. Hasta ahora solo había arena, se introdujo agua, tierra, piedra y gas que se hace transparente con el tiempo. Se añadió un sistema de densidad. Actualmente tenemos un switch y en función del tipo de partícula llamamos a una función u otra. Las funciones comparten parte del código pero en general son específicas de cada partícula. Cambiamos el array de partículas bidimensional a unidimensional porque hicimos tests y obteníamos mejores resultados con este en ambas mágicas, aunque era una mejora marginal. El sistema de densidad se consolidó, se arreglaron bugs y se generalizó un poco la forma de procesar partículas en funciones comunes, pero aún seguimos llamando a un método distinto por cada partícula.

Al principio teníamos

if(goDown(velocity)) return
if(goDownDensity) return

Igual para el resto de direcciones de la partícula

Debatimos sobre sin mantener todo lo relacionado al movimiento de la partícula en enteros o floats. (dejamos enteros)

Al refactorizat tuvimos

moveDirection(x,y, dirX, dirY, pixelsToMove)

Esto nos permitía generalizar mejor el movimiento de las partículas teniendo en cuenta su empuje. Aunque aún seguimos necesitando tener un método por cada partícula.

Se añadió una partícula de ácido que elimina otras (parece como corrosión)

Agregar particulas era dificil porque agragar una implicaba

- Cambiar el enum material en particle.h
- Cambiar el material-physics en particle.cpp
- Cambiar la clase factoria en particlefactory.cpp
- Agregar un nuevo update en particlesimulation.h y .cpp
- Agregar un nuevo color en common_utils.h
- Agregar los cambios a app.cpp para el selector de material

También nos molestaba que como el orden de actualización siempre era de derecha a izquierda, eso afectaba visualmente a la simulación en ciertas situaciones.

Noviembre 2023

Planteamos un sistema más orientado a datos.

Queríamos que haciendo algo como esto

System.RegisterMaterial("NameString", color, {physics-properties}, {quimic_interactions})

El sistema ya funcione, no hay que cambiar nada de código, añdir una partícula sería solamente añadir datos al sistema.

El mayor problema era plantear el sistema de interacción. Tenemos varios documentos de eso en el repo sobre distintos planteamientos. Generalizamos la función de las partículas, ahora todas las partículas usan la misma función. Una partícula tiene sus propios datos (tipo, tiempo de vida) y otros externos en un mapa asociados al tipo que comparten todas las partículas de dicho tipo y son inmutables. Con esto, ya pudimos usar una sola función para todas las particulas, aunque aún no tenemos un sistema de interacción, por lo que por ejepmplo la partícula de ácido no elimina otras partículas. Además, quitamos el array de "have been updated" y metimos en la partícula un campo "clock". Todas las partículas se actualizan en un frame, cuando una partícula se actualiza, se invierte su clock. Así, si nos la volvemos a encontrar en el mismo frame, sabemos que se ha actualizado y no hay que tocarla. El clock del frame cambia al final para que en el siguiente las partículas se puedan actualizar de nuevo. Esto nos ahorró un memset y memoria.En mi equipo (Ryzen 3550H, 16GB RAM 2400Mhz y GTX 1650 mobile) se llegó a tener 1.44 millones de partículas a 60 fps. Un númeor de particulas superior a eso ya causaba pequeños bajones.

Más tarde implementamos un prototipo del sistema de interacciones, cada tipo de partícula tiene unas condicoines que ejecuta, si se cumple, ejecuta una interacción. Tanto la condición como la interacción son std::functions que están en le registro de partículas (debería hablar en otro momento más en profundidad de que es eso y como va)

Segunda mitad del mes

A partir de aquí nos separamos

Empiezo a testear con Lua en C++, pero no puedo lograr un rendimiento decente. Considero muchas otras posibilidades, como usar DLL, pero llamar a funciones de una DLL tiene un sobrecoste que en nuestro sistema se nota ya que las funciones se llaman millones de veces por segundo. Exitsm es una opción que permite usar "plugins" en webassembly. Esto deberia funcionar mejor que las DLLs, webassembly permite obtener hasta el 90% del rendimiento nativo según benchmarks. Sin embargo en ese tiempo exitism solo estaba en su versión 0.5. Era perfectamente usable pero aún inmaduro, preferí no arriesgarme, además de que compilar wasm en C++ era farragoso, lo probé. Lo ideal habría sido usar Rust, pero usar un lenguaje con el qeu no estamos familiarizado encima compilando a wasm habría dado muchas complicaiones y retrasado mucho el desarrollo. Además, ni siquiera sabíamos si era viable, teníamos que hacer pruebas.

Lua con C++ era lento por un motivo similar al de las DLL, en este caso el overhead del interop. Migré la mayoría del código e Lua manteniendo una parte en C++ para reducir el interop por frame, pero esto solo empeoró todo. 

Consideré también que una interacción en C++ se pueda definir mediante una serie de comandos, pero tener un array de std functions no sería muy bueno además de que incurre en otros problemas. Básicamente para poder tener algo solvene acabaría necesitando un lenguaje de scripting, crear un AST y eso era farragoso. Además de que tampoco garantizaba nada, no sería serializable...

Finalmente decidí por hacer toda la simulación en Luajit. Si no hay nada de overhead, debería ir mejor. No llegará el nivel de C++ pero debería ser decente y esto me permitiría tener toda la flexibilidad que quería. Buscando frameworks simples y libs tipo SDL para Lua, me topé con LOVE2D. Un framework sencillito que era justo lo que queria, me daba un update, métodos para renderizar textura, gestión de Input... Cosas básicas pero que se agradecen. Con eso migré toda la lógica de C++ a Lua. La lógica era un calco exacto. Era menos rápido que C++ pero seguía siendo solvente. En mi equipo, podía tener 400*400 (160000) particulas a 60 fps. Parece poco en comparación a lo que mencioné de tener +1 millón en C++. Pero en este caso son particulas con interacciones, además de que mi objetivo es que esto se ejecute en máximo 300*300, pero quiero exprimir todo el rendimiento posible y que más usuarios puedan ejecutar el software. Mi portátil no es especialmente potente, pero tampoco es gama baja. Sería ideal que equipos menos potentes pudieran ejecutar esta simulación. LOVE tenía una peculiaridad, permite Multihreading creando varias instancias de Lua y tiene un sistema de canales para comunicar estos threads. Fue duró pero migré la simulación a multithread y con eso logré tener 800*800 partículas a 60 fps. Esto ya era mucho más usable, como mínimo cualquier equipo de gama baja o media tendrá al menos dual core, con eso cualquier equipo debria poder ejecutar la simulación a 60 fps en 300*300.

El problema que no solucioné este mes, es que el orden de los chunks es importante, además del orden de procesado dentro de los chunks. Es el mismo problema original de que como todo se actualiza siempre de derecha a izquierda, se nota. Además, aunque a estas alturas tengo un sistema modular que permite arrastrar archivos .lua y eso ya carga las nuevas partículas, no es ideal pedir a los usuarios que programen en Lua para moddear el juego. Aunque la comodidad que ofrece el sistema tampoco es mala. Una solución a esto era usar blockly.

Diciembre

En diciembre corregí lo de la simulacion. El orden en que se procesan los chunks alterna cada frame, con eso se logra una simulación más estable. Surgió el problema de sincronización que se arregló introduciendo un doble buffer. Probé a integrar un webview en la ventana de LOve pero lo máximo que logré fue crear una ventana a parte y usar comunicación por sockets, pero no funcionaba del todo bien, por lo que lo descarté. Esto podría haberse hecho modificando Love y compilando una versión personalizada, pero habría sido muy complejo. Se planteó crear una web con el blockly. Así los usuarios podrían crear sus partículas allí y luego meterlas en la app. Eso fue todo este mes. Se explica rápido pero hay muchos detalles interesantes de implementación y fue complejo. También hubo varias refactorizaciones para ir limpiando poco a poco los remanentes de la lógica C++ y adaptar todo a los requisitos actuales del proyecto. La app es multithreading, cuando cargas un plugin, este se manda a todos los threads. El como enviar ciertos datos a los thread fue complejo por las limitaciones de Lua y Love. En el estado actual la app es serializable aunque no está implementado. También realicé diversas optimizaciones específicas de Lua relacionadas con manejo de tablas y upvalues para maximizar el rendimiento. Implementé un sistema simple de tests y un sistema que determina en cuantos chunks dividir el mundo en función de los núcleos de CPU y el tamaño de la simulación. Este sistema garantizar un tamaño mínimo de chunks para que no haya problemas de condición de carrera.

Mi compañero hizo una versión en GPU con compute shaders en Vulkan.

# Apuntes de Trello

[https://www.stephenwolfram.com/publications/cellular-automata-complexity/](https://www.stephenwolfram.com/publications/cellular-automata-complexity/ "smartCard-inline")

[https://natureofcode.com](https://natureofcode.com "smartCard-inline")

Este siguiente es más un artículo, pero de aquí podemos referenciar la técnica de usar un array de booleanos para controlar que una misma partícula no se simule 2 veces por frame. Además da código fuente que igual nos sirve de inspiración, pero en plan inspiración, esto es muy poco eficiente como para copiarlo.

[https://maxbittker.com/making-sandspiel](https://maxbittker.com/making-sandspiel "smartCard-inline")

Cellular Automata: A Discrete Universe ISBN 9810246234

Este libro es de pago, los otros tienen versiones online gratuitas.

Cellular Automata and Discrete Complex Systems: 23rd IFIP WG 1.5 International Workshop, AUTOMATA 2017, Milan, Italy, June 7-9, 2017, Proceedings
[_Volumen 10248 de Lecture Notes in Computer Science_](https://www.google.es/search?hl=es&tbo=p&tbm=bks&q=bibliogroup:%22Lecture+Notes+in+Computer+Science%22&source=gbs_metadata_r&cad=2 "‌")
[_Theoretical Computer Science and General Issues_](https://www.google.es/search?hl=es&tbo=p&tbm=bks&q=bibliogroup:%22Theoretical+Computer+Science+and+General+Issues%22&source=gbs_metadata_r&cad=2 "‌")

Este libro también es de pago pero parece interesante, habla de algunas técnicas de optimización pero leerlo es como tener que pasar por discretas en modo hardcore

Esto es un articulo escrito por uno de los creadores de Noita: https://80.lv/articles/noita-a-game-based-on-falling-sand-simulation/