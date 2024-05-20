En esta sección se hablará sobre qué es la programación paralela, su funcionamiento y usos tanto en CPU como en GPU.

La programación paralela es una técnica de programación que consiste en dividir un problema en tareas más pequeñas y ejecutarlas simultáneamente en múltiples procesadores o núcleos de procesamiento. Esto permite aprovechar el poder de cómputo del hardware y acelerar la ejecución de programas.

Sin embargo, debido a las particularidades de cada tipo de hardware, la forma en que funciona y se aplica varía en función de si se quiere usar la CPU o la GPU.

Cabe destacar que independientemente del hardware utilizado, la paralelización de un problema no incrementa el rendimiento de manera lineal con el número de núcleos utilizados, el incremento de rendimiento tiene un límite.

La ley de Amdahl @ComputerOrganizationPatterson es un principio importante en la programación paralela que establece que el rendimiento máximo que se puede lograr al paralelizar un programa está limitado por la fracción secuencial del código. En otras palabras, aunque se pueda paralelizar una parte del código, siempre habrá una porción que debe ejecutarse de forma secuencial y que limitará el rendimiento general del programa.

La ley de Amdahl se expresa mediante la siguiente fórmula:

#set align(center)


$ "Mejora Total" = 1 / ((1 - P) + (P / N)) $


#set align(left)

Donde:

- `Mejora Total` es la mejora en el rendimiento del programa al paralelizarlo.
- `P` es la fracción del código que se puede paralelizar.
- `N` es el número de núcleos de procesamiento (hilos) disponibles.

Esta fórmula muestra que, a medida que aumenta el número de procesadores o hilos (N), el rendimiento total mejora, pero solo hasta cierto punto. La fracción secuencial del código (1 - P) siempre limitará el rendimiento máximo que se puede lograr.

#text(red)[La intro que he hecho es mejorable, pero es un apaño temporal para no tener directamente un subapartado sin nada de texto. Como ahora este capítulo es de programación paralela y no solo de GPU considero mejor hacerlo así. Podría hacerse un capítulo separado para GPU y CPU pero dado que de CPU se hablará menos creo que es mejor dejarlo aquí complementando al de GPU como se sugirió en las notas. Además de que no he revisado el apartado de GPU, estoy escribiendo mi parte para poder hacer los demás apartados, seguramente nos falte ponernos de acuerdo en este apartado y redactarlo mejor entre los dos, pero en principio la información que tenemos debería ser la adecuada y solo falta presentarla de forma correcta. Por cierto, este mensaje es para Jonathan, esto debería haberse resuelto antes de enviarse a Pedro Pablo]

== Programación paralela en GPU

La GPU (graphics processing unit) es un procesador originalmente diseñado para manejar y acelerar el procesamiento de tareas gráficas, como puede ser el mostrar imágenes o vídeos en pantalla. Para facilitar la aceleración de estas tareas, se crearon los shaders, pequeños programas gráficos destinados a ejecutarse en la GPU como parte del pipeline gráfico. El pipeline gráfico es el conjunto de operaciones secuenciales que finalmente formarán la imagen a mostrar en pantalla. La denominación pipeline hace referencia a que las operaciones que lo componen se ejecutan de manera secuencial y cada operación recibe una entrada de la fase anterior y devuelve una salida que recibirá la siguiente fase como entrada, hasta completar la imagen. @Real-Time-Rendering

El pipeline gráfico comienza con la representación de objetos mediante vértices. Cada vértice contiene información como su posición, normal, color y coordenadas de textura.

Luego, las coordenadas de los vértices se transforman en coordenadas normalizadas mediante matrices de transformación, pasando por etapas de escena, vista y proyección.

Después, se ensamblan los vértices para formar primitivas, se descartan o recortan las que están fuera del campo visual y se mapean a coordenadas de pantalla.

La rasterización determina qué píxeles formarán parte de la imagen final, utilizando un buffer de profundidad para determinar qué fragmentos se dibujan. Se interpola entre los atributos de los vértices para determinar los atributos de cada fragmento y se decide el color de cada píxel, considerando la iluminación, la textura y la transparencia.

Finalmente, los fragmentos dibujados se muestran en la pantalla del dispositivo.

Aunque la funcionalidad inicial de la GPU se limitaba al apartado gráfico, los fabricantes de este tipo de chips se dieron cuenta de que los desarrolladores buscaban formas de mapear datos no relacionados con imágenes a texturas, para así ejecutar operaciones sobre estos datos mediante shaders @LinearAlgebraGPU. Esto significaba que se podía aprovechar las características de este hardware para la resolución de tareas que no tengan que ver con imágenes, por lo que extendieron su uso más allá de la generación de gráficos.

Una de estas extensiones fue la creación de "compute shaders" @compute_shaders que son programas diseñados para ejecutarse en la GPU, pero, a diferencia de los shaders, no están directamente relacionados con el proceso de renderizado de imágenes, por lo que se ejecutan fuera del pipeline gráfico. Los "compute shaders" se emplean para realizar cálculos destinados a propósitos que se benefician de la ejecución masivamente paralela ofrecida por la GPU. Son ideales para tareas como simulaciones físicas, procesamiento de datos masivos o aprendizaje automático.


=== Arquitectura GPU

Para lograr el procesamiento de shaders de la manera más eficiente, la GPU se diseñó con una arquitectura hardware y software que permite la paralelización de cálculos en el procesamiento de vértices y píxeles independientes entre sí.

Este apartado se centra en explicar las diferencias de arquitectura entre una CPU y una GPU a nivel de hardware, así como en explicar cómo este hardware interactúa con el software destinado a la programación de GPUs.

==== Hardware

La tarea de renderizado requería de un hardware diferente al presente en la CPU debido a la gran cantidad de cálculos matemáticos que requiere. Desde transformaciones geométricas hasta el cálculo de la iluminación y la aplicación de texturas, todas estas tareas se basan en manipulaciones matemáticas haciendo uso de vectores y matrices. Para optimizar el proceso de renderizado, es esencial reducir el tiempo necesario para llevar a cabo estas operaciones @GPGP-Architecture.

Por lo tanto, surge la GPU como co-procesador con una arquitectura SIMD (single instruction multiple data) cuya función es la de facilitar a la CPU el procesado de tareas relacionadas con lo gráfico, como renderizar imágenes, vídeos, animaciones, etc @ComputerOrganizationPatterson.

Al ser el objetivo de la GPU el procesar tareas de manera paralela, se puede observar una gran diferencia en cuanto a la distribución de espacio físico (recuento de transistores) dentro del chip con respecto a la CPU, que esta diseñada para procesar las instrucciones secuencialmente @ComputerOrganizationWilliam.

#figure(
  image("../images/cpugpu2.png", width: 60%),
  caption: [
    Comparativa arquitectura de un chip de CPU y de GPU @ComputerOrganizationWilliam
  ],
)

Una GPU dedica la mayor cantidad de espacio a alojar núcleos para tener la mayor capacidad de paralelización posible, mientras que la CPU dedica, la mayoria de su espacio en chip a diferentes niveles de caché y circuitos dedicados a la logica de control @ComputerOrganizationWilliam.

La CPU necesita estos niveles de caché para intentar minimizar al máximo los accesos a memoria principal, los cuales ralentizan mucho la ejecución. De igual manera, al estar diseñados los núcleos CPU para ser capaces de ejecutar cualquier tipo de instruccion, requieren lógica de control para gestionar los flujos de datos, controlar el flujo de instrucciones, entre otras funciones.

Sin embargo, la GPU al estar dedicada principalmente a operaciones matemáticas y por lo tanto tener un set de instrucciones mucho más reducido en comparación con la CPU, puede prescindir de dedicarle espacio a la logica de control. Al acceder a memoria, a pesar de que los cores tengan registros para guardar datos, la capacidad de estos es muy limitada, por lo que es común que se acceda a la VRAM (Video RAM). La GPU consigue camuflar los tiempos de latencia manejando la ejecucion de hilos sobre los datos. Cuando un hilo esta realizando acceso a datos, otro hilo está ejecutandose @ComputerOrganizationWilliam.

La gran cantidad de cores presentes en una GPU, están agrupados en estructuras de hardware llamados SM (Streaming Multiprocessors) en NVIDIA y CP (Compute Units) en AMD. NVIDIA y AMD son dos de los principales fabricantes de tarjetas gráficas, cada uno con su propia arquitectura y tecnologías específicas. Además de núcleos de procesamiento, estas agrupaciones incluyen normalmente una jerarquía básica de memoria con una cache L1, una memoria compartida entre núcleos, una caché de texturas, un programador de tareas y registros para almacenar datos. Su tarea principal es ejecutar programas SIMT (single-instruction multiple-thread) correspondientes a un kernel, asi como manejar los hilos de ejecución, liberándolos una vez que han terminado y ejecutando nuevos hilos para reemplazar los finalizados. @GPGP-Architecture

#figure(
  image("../images/SM2.png", width: 60%),
  caption: [
    Streaming Multiprocessor @ComputerOrganizationWilliam
  ],
)

==== Software 

Debido a que la implementacion de CUDA fue un punto de inflexión en el desarrollo de GPUs y asentó las bases de lo que hoy es la computación de propósito general en unidades de procesamiento gráfico, se explicará cómo se enlaza el software al hardware ya explicado haciendo uso de CUDA. Todos los conceptos son extrapolables a otras APIs de desarrollo como pueden ser SYCL o OpenMP.

Un programa CUDA puede ser dividido en 3 secciones @ComputerOrganizationWilliam:
- Código destino a procesarse en el Host (CPU).
- Código destinado a ser procesado en el Dispositivo (GPU).
- Código que maneja la transferencia de datos entre el Host y el dispositivo. 

El código destinado a ser procesado por la GPU se conoce como kernel. Un kernel está diseñado para contener la menor cantidad de código condicional posible. Esto se debe a que la GPU está optimizada para ejecutar un mismo conjunto de instrucciones en múltiples datos de manera simultánea. Cuando hay muchas ramificaciones condicionales (como if-else), puede haber una divergencia en la ejecución de los hilos, lo que disminuye la eficiencia del paralelismo y puede resultar en un rendimiento inferior.

A cada instancia de ejecución del kernel se le conoce como hilo. El desarrollador define cual es el número de hilos sobre los que quiere ejecutar el kernel, idealmente maximizando la paralelización de los cálculos. Estos hilos pueden ser agrupados uniformemente en bloques, y a su vez estos bloques son agrupados en un grid de bloques. El número de bloques totales que se crean viene dictado por el volumen de datos a procesar. Tanto los bloques como los grids pueden tener de 1 a 3 dimensiones, y no necesariamente tienen que coincidir.

#figure(
  image("../images/softwareGPU.png", width: 40%),
  caption: [
    Jerarquía de ejecución @gpu_arquitecture
  ],
)

El "scheduler global" en una GPU tiene la función principal de coordinar y programar las unidades de procesamiento disponibles para ejecutar tareas en paralelo.
A la hora de ejecutar el kernel, este scheduler crea warps, sub-bloques de un cierto número de hilos consecutivos sobre los que se llevara a cabo la ejecución, que luego serán programados para ejecutar por el scheduler de cada SM. 
Es totalmente imprescindible que estos bloques de hilos puedan ser ejecutados de manera totalmente independiente y sin dependencias entre ellos, ya que a partir de aquí el programador de tareas es el que decide que y cuando se ejecuta. Los hilos dentro del bloque pueden cooperar compartiendo datos y sincronizando su ejecución para coordinar los accesos a datos mediante esperas, mediante una memoria compartida a nivel de bloque. El número de hilos dentro de un bloque esta limitado por el tamaño del SM, ya que todos los hilos dentro de un bloque necesitan residir en el mismo SM para poder compartir recursos de memoria.

== Programación paralela en CPU

La CPU (central processing unit) es el procesador principal de un ordenador y se encarga de ejecutar las instrucciones de los programas. A diferencia de la GPU, la CPU está diseñada para ejecutar instrucciones secuencialmente, es decir, una instrucción tras otra. Sin embargo, la CPU también puede ejecutar tareas en paralelo, pero de una manera diferente a la GPU.

La programación paralela en CPU se basa en la creación de hilos de ejecución, que son unidades de procesamiento independientes que pueden ejecutar tareas simultáneamente. Debido a que los hilos pueden compartir memoria, es posible tanto resolver varios problemas a la vez como dividir un problema en tareas más pequeñas y ejecutarlas en paralelo.

Este acceso compartido a memoria incurre en una serie de problemas que se deben tener en cuenta a la hora de programar en paralelo en CPU. Los problemas mostrados a continuación no siguen un orden de importancia, ya que todos ellos son igual de importantes: Condiciones de carrera, interbloqueos y problemas de inanición.

Las condiciones de carrera se dan cuando dos o más hilos intentan acceder y modificar el mismo recurso al mismo tiempo. Esto puede llevar a resultados inesperados y errores en el programa. Para evitar condiciones de carrera, se desarrollaron lo que se conoce como mecanismos de sincronización, como los semáforos o los mutex.

Un mutex es un recurso compartido entre hilos que permite controlar el acceso a una sección crítica del código. Cuando un hilo adquiere un mutex, ningún otro hilo puede acceder a la sección crítica (usualmente un recurso compartido) hasta que el primer hilo libere el mutex. Esto evita que se produzcan condiciones de carrera y garantiza que solo un hilo pueda acceder a la sección crítica en un momento dado.

Los interbloqueos y problemas de inanición son problemas resultantes del uso incorrecto de los mecanismos de sincronización. Un interbloqueo ocurre cuando dos o más hilos se bloquean mutuamente, es decir, cada hilo espera a que otro hilo libere un recurso que necesita, lo que resulta en que ninguno de los hilos pueda avanzar. La inanición, por otro lado, ocurre cuando un hilo es incapaz de avanzar debido a que otros hilos tienen prioridad sobre él, lo que resulta en que el hilo "hambriento" no pueda completar su tarea al no recibir acceso a los recursos necesarios.

Existe una alternativa para evitar estos problemas relacionados con los mecanismos de sincronización: `canales`. Los canales son estructuras de datos que permiten la comunicación entre hilos de manera segura y eficiente. Cada hilo puede enviar y recibir mensajes a través de un canal, lo que evita la necesidad de utilizar mecanismos de sincronización y reduce la posibilidad de condiciones de carrera.

El uso de canales posibilita un tipo de balance de trabajo entre hilos llamado `work stealing` @workStealing. En este modelo, los hilos ejecutan tareas, al terminar, envía un mensaje a otro hilo para que le envíe una tarea. De esta forma, los hilos que terminan antes pueden ayudar a los que todavía tienen tareas pendientes, evitando la inanición y mejorando el rendimiento del programa.

#text(red)[No estoy seguro de si he explicado el work stealing de la forma más correcta, pero es la forma en la que se ha implementado en nuestro caso. Cuando programé el multithread en Lua ni siquiera sabía que estaba usando un patrón llamando work stealing, me di cuenta más tarde al investigar sobre el tema. En mi caso mi motivación para implementar este sistema no es la inanición, era que crear 8-16 threads 60 veces por segundo era costoso, por lo que esta era la form más sencilla de crear los threads una vez y reutilizarlos. No estoy muy seguro de esta última parte, quizás pueda mencionarlo como una técnica similar al work stealing que no es "puramente" work stealing. Y es algo particular de nuestra implementación, no he visto que implementarlo de esta forma sea algo común o al menos algo que esté documentado. De todas formas voy a dejarlo aquí en estado del arte porque sino sé que luego habrá una nota diciendo que ya debería haber sido explicado antes... Y no me gusta tener que explicarlo aquí porque luego al explicar el simulador solo referencio esta parte y ale, cuadno este sistema es una parte importante de nuestra contribución y ponerlo aquí me parece que lo desmerece.]

#text(red)[No estoy seguro de si debería añadir algo más aquí.No he querido ir a cosas más técnicas como que problemas de sincronización de caché y demás ya que los lenguajes de alto nivel se encargan de estas cosas y no es algo que nos afectara en el desarrollo del proyecto (a diferencia de los 3 problemas expuestos que sí los padecimos). En este apartado solo he mencionado las cosas relevantes de procesamiento paralelo en CPU que nos afectaron en el desarrollo del proyecto. (por eso menciono los canales y el work stealing)]