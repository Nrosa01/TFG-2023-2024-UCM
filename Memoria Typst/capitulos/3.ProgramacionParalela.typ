

La GPU (graphics processing unit) es un procesador originalmente diseñado para manejar y acelerar el procesamiento de tareas gráficas, como puede ser el mostrar imágenes o videos en pantalla. Para facilitar la aceleración de estas tareas, se crearon los shaders, pequeños programas gráficos destinados a ejecutarse en la GPU como parte del pipeline gráfico. El pipeline gráfico es el conjunto de operaciones secuenciales que finalmente formarán la imagen a mostrar en pantalla. La denominación pipeline hace referencia a que las operaciones que lo componen se ejecutan de manera secuencial y cada operación recibe una entrada de la fase anterior y devuelve una salida que recibirá la siguiente fase como entrada, hasta completar la imagen. @Real-Time-Rendering

El pipeline gráfico comienza con la representación de objetos mediante vértices. Cada vértice contiene información como su posición, normal, color y coordenadas de textura.

Luego, las coordenadas de los vértices se transforman en coordenadas normalizadas mediante matrices de transformación, pasando por etapas de escena, vista y proyección.

Después, se ensamblan los vértices para formar primitivas, se descartan o recortan las que están fuera del campo visual y se mapean a coordenadas de pantalla.

La rasterización determina qué píxeles formarán parte de la imagen final, utilizando un buffer de profundidad para determinar qué fragmentos se dibujan. Se interpola entre los atributos de los vértices para determinar los atributos de cada fragmento y se decide el color de cada píxel, considerando la iluminación, la textura y la transparencia.

Finalmente, los fragmentos dibujados se muestran en la pantalla del dispositivo.

Aunque la funcionalidad inicial de la GPU se limitaba al apartado gráfico, los fabricantes de este tipo de chips se dieron cuenta de que los desarrolladores buscaban formas de mapear datos no relacionados con imágenes a texturas, para así ejecutar operaciones sobre estos datos mediante shaders @LinearAlgebraGPU. Esto significaba que se podía aprovechar las características de este hardware para la resolución de tareas que no tengan que ver con imágenes, por lo que extendieron su uso mas allá de la generación de gráficos.

Una de estas extensiones fue la creación de "compute shaders" @compute_shaders que son programas diseñados para ejecutarse en la GPU, pero, a diferencia de los shaders, no están directamente relacionados con el proceso de renderizado de imágenes, por lo que se ejecutan fuera del pipeline gráfico. Los "compute shaders" se emplean para realizar cálculos destinados a propósitos que se benefician de la ejecución masivamente paralela ofrecida por la GPU. Son ideales para tareas como simulaciones físicas, procesamiento de datos masivos o aprendizaje automático.


== Arquitectura GPU

Para lograr el procesamiento de shaders de la manera más eficiente, la GPU se diseñó con una arquitectura hardware y software que permite la paralelización de cálculos en el procesamiento de vértices y píxeles independientes entre sí.

Este apartado se centra en explicar las diferencias de arquitectura entre una CPU y una GPU a nivel de hardware, así como en explicar cómo este hardware interactúa con el software destinado a la programación de GPUs.

=== Hardware

La tarea de renderizado requería de un hardware diferente al presente en la CPU debido a la gran cantidad de cálculos matemáticos que requiere. Desde transformaciones geométricas hasta el cálculo de la iluminación y la aplicación de texturas, todas estas tareas se basan en manipulaciones matemáticas haciendo uso de vectores y matrices. Para optimizar el proceso de renderizado, es esencial reducir el tiempo necesario para llevar a cabo estas operaciones @GPGP-Architecture.

Por lo tanto, surge la GPU como co-procesador con una arquitectura SIMD (single instruction multiple data) cuya función es la de facilitar a la CPU el procesado de tareas relacionadas con lo gráfico, como renderizar imágenes, videos, animaciones, etc.@ComputerOrganizationPatterson.

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
  image("../images/SM2.png", width: 75%),
  caption: [
    Streaming Multiprocessor @ComputerOrganizationWilliam
  ],
)

=== Software 

Debido a que la implementacion de CUDA fue un punto de inflexión en el desarrollo de GPUs y asentó las bases de lo que hoy es la computación de propósito general en unidades de procesamiento gráfico, se explicará cómo se enlaza el software al hardware ya explicado haciendo uso de CUDA. Todos los conceptos son extrapolables a otras APIs de desarrollo como pueden ser SYCL o OpenMP.

Un programa CUDA puede ser dividido en 3 secciones @ComputerOrganizationWilliam:
- Código destino a procesarse en el Host (CPU).
- Codigo destinado a ser procesado en el Dispositivo (GPU).
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

