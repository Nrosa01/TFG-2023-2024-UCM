== Introduccion historica

Esta sección describe brevemente la evolucion de las GPU's. No se pretende entrar en detalles, sino mas bien señalar los distintos hitos evolutivos que se dieron durante la creación de este hardware.

La necesidad de presentar gráficos en pantalla ha estado siempre presente, desde proyectos como Sketchpad @SketchPad ,animacion 2D cinematográfica o videojuegos, y con ello la necesidad de que los computadores posean hardware que facilite esta tarea. 

Durante la evolución historica del proceso de desarrollo de este hardware, podemos diferenciar 3 fases principalmente @ComputerOrganizationWilliam @history_of_gpu @GPGP-Architecture:

En la primera fase, que abarca desde principios de los 80s a mediados de los 90s,  la "GPU" constaba de elementos hardware muy especializados y no programables. Cumplian funciones muy específicas de renderizado en pantalla. Por ello, en esta epoca a este tipo de hardware se le denominaba como aceleradores 2D / 3D.

La segunda fase, que duró hasta mediados de los años 2000, abarca el proceso iterativo de la transformacion de una arquitectura fija y muy especifica a una que permitia la programación de shaders dentro del pipeline gráfico, mediante la modificacion de los shaders de vertices y de pixeles. Este hecho es importante, ya que dada la potencia y características de la GPU, que no dejaba de ser hardware destinado al procesamiento gráfico, añadida a la capacidad de personalizar estos shaders, muchos desarrolladores buscaron formas de mapear datos ajenos a los gráficos a texturas y ejecutar operaciones sobre estos datos mediante shaders @LinearAlgebraGPU .El fin de esta era viene marcado por la introducción por parte de NVIDIA de su novedoso lenguaje GPGPU (General-Purpose Graphics Processing Unit), CUDA (compute unified device architecture), capa de software que proporciona acceso directo al conjunto de instrucciones virtuales de la GPU para la ejecución de kernels.

La tercera fase abarca desde el final de la segunda fase hasta la actualidad, y se trata de un proceso de adaptacion de la GPU a tareas no necesariamente relacionadas con el procesamiento gráfico, como puede ser la introducción de compute shaders, shaders que actúan fuera del pipeline gráfico, para evitar que los desarrolladores tengan que aprovechar shaders como el de vertices o de pixeles para realizar operaciones no requeridas para renderizar, o hardware nuevo destinado a tareas de inteligencia artificial como los Tensor Cores, cores incluidos a partir de su serie Volta de GPUs que estan destinados a asistir en el cálculo de operaciones requeridas por procesos de Inteligencia Artificial, como por ejemplo el entrenamiento de redes neuronales .

// Este contexto histórico es importante ya que ayudará a entender la utilidad de conceptos que se presentarán mas tarde como el pipeline grafico, los compute shaders etc. Cada uno de estos avances abría nuevas puertas a los desarrolladores, y la tecnología destinada a las GPU no para de avanzar cada año.


== Arquitectura GPU

Este apartado se centra en explicar las diferencias de arquitectura entre una CPU y una GPU a nivel de hardware, así como en explicar cómo este hardware interactúa con el software destinado a la programación de GPUs.

=== Hardware

La tarea de renderizado requería de un hardware diferente al presente en la CPU debido a la gran cantidad de cálculos matemáticos que requiere. Desde transformaciones geométricas hasta el cálculo de la iluminación y la aplicación de texturas, todas estas tareas se basan en manipulaciones matemáticas haciendo uso de vectores y matrices. Para optimizar el proceso de renderizado, es esencial reducir el tiempo necesario para llevar a cabo estas operaciones @GPGP-Architecture.

Gran parte de estas son divisibles en tareas más pequeñas. Por ejemplo, la multiplicación de matrices se descompone en operaciones vectoriales, donde el resultado de cada elemento de la matriz se calcula mediante la multiplicación y suma de vectores. Esto permitiría, en caso de tener núcleos con capacidad de cómputo suficientes, el cálculo de cada elemento de la matriz por separado. Este enfoque permite una mayor eficiencia en el procesamiento, lo que resulta en una aceleración significativa en la tarea de renderizado.

Por lo tanto, surge la GPU como co-procesador con una arquitectura SIMD (single instruction multiple data) cuya funcion es la de facilitar a la CPU el procesado de tareas relacionadas con lo gráfico, como renderizar imágenes, videos, animaciones etc @ComputerOrganizationPatterson.

Al ser el objetivo de la GPU el procesar tareas de manera paralela, se puede observar una gran diferencia en cuanto a la distribución de espacio físico(recuentode transistores) dentro del chip con respecto a la CPU, que esta diseñada para procesar las instrucciones secuencialmente @ComputerOrganizationWilliam.

#figure(
  image("../images/cpugpu2.png", width: 60%),
  caption: [
    Comparativa arquitectura de un chip de CPU y de GPU @ComputerOrganizationWilliam
  ],
)

Una GPU dedica la mayor cantidad de espacio a alojar núcleos para tener la mayor capacidad de paralelización posible, mientras que la CPU dedica, la mayoria de su espacio en chip a diferentes niveles de caché y circuitos dedicados a la logica de control@ComputerOrganizationWilliam.


La CPU necesita estos niveles de caché para intentar minimizar al máximo los accesos a memoria principal, los cuales ralentizan mucho la ejecución. De igual manera, al estar diseñados los núcleos CPU para ser capaces de ejecutar cualquier tipo de instruccion, requieren lógica de control para gestionar los flujos de datos, controlar el flujo de instrucciones, entre otras funciones.

Sin embargo, la GPU al estar dedicada principalmente a operaciones matemáticas y por lo tanto tener un set de instrucciones mucho mas reducido en comparación con la CPU, puede prescindir de dedicarle espacio a la logica de control. Al acceder a memoria, a pesar de que los cores tengan registros para guardar datos, la capacidad de estos es muy limitada, por lo que es común que se acceda a la VRAM (Video RAM). La GPU consigue camuflar los tiempos de latencia manejando la ejecucion de hilos sobre los datos. Cuando un hilo esta realizando acceso a datos, otro hilo esta ejecutandose @ComputerOrganizationWilliam.

La gran cantidad de cores presentes en una GPU, están agrupados en estructuras de hardware llamados SM (Streaming Multiprocessors) en Nvidia y CP (Compute Units) en AMD. Además de núcleos de procesamiento, estas agrupaciones incluyen normalmente una jerarquia básica de memoria con una cache L1, una memoria compartida entre núcleos, una caché de texturas, un programador de tareas y registros para almacenar datos. Su tarea principal es ejecutar programas SIMT (single-instruction multiple-thread) correspondientes a un kernel, asi como manejar los hilos de ejecución, liberándolos una vez que han terminado y ejecutando nuevos hilos para reemplazar los finalizados. @GPGP-Architecture

#figure(
  image("../images/SM2.png", width: 50%),
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
Al código destinado a ser procesado por la GPU se le llama kernel. El código que constituye un kernel tendrá la menor cantidad de codigo condicional posibles preferiblemente estar formado por una secuencia de instrucciones definida. A cada instancia de ejecución del kernel se le conoce como hilo. El desarrollador define cual es el numero de hilos sobre los que quiere ejecutar el kernel, idealmente maximizando la paralelización de los calculos. Estos hilos pueden ser agrupados uniformemente en bloques, y a su vez estos bloques son agrupados en un grid de bloques. El número de bloques totales que se crean viene dictado por el volumen de datos a procesar. Tanto los bloques como los grids pueden tener de 1 a 3 dimensiones, y no necesariamente tienen que coincidir.

#figure(
  image("../images/softwareGPU.png", width: 40%),
  caption: [
    Jerarquía de ejecución @gpu_arquitecture
  ],
)


A la hora de ejecutar el kernel, el scheduler global crea warps, sub-bloques de un cierto numero de hilos consecutivos sobre los que se llevara a cabo la ejecucion, que luegos serán programados para ejecutar por el scheduler de cada SM.
Es totalmente imprescindible que estos bloques de hilos puedan ser ejcutados de manera totalmente independiente y sin dependencias entre ellos, ya que a partir de aquí el programador de tareas es el que decide que y cuando se ejecuta. Los hilos dentro del bloque pueden cooperar compartiendo datos y sincronizando su ejecución para coordinar los accesos a datos mediante esperas, mediante una memoria compartida a nivel de bloque. El número de hilos dentro de un bloque esta limitado por el tamaño del SM, ya que todos los hilos dentro de un bloque necesitan residir en el mismo SM para poder compartir recursos de memoria.


== Pipeline gráfico y shaders

La función inicial y principal de las GPU era la de procesar la imagen que iba a ser mostrada al usuario. Para facilitar esto, se crearon los shaders, pequeños programas gráficos destinados a ejecutarse en la GPU como parte del pipeline principal de renderizado, cuya base es transformar inputs en outputs que finalmente formarán la imagen a mostrar @Real-Time-Rendering.

El pipeline gráfico comienza con la representación de objetos mediante vértices. Cada vértice contiene información como su posición, normal, color y coordenadas de textura.

Luego, las coordenadas de los vértices se transforman en coordenadas normalizadas mediante matrices de transformación, pasando por etapas de escena, vista y proyección.

Después, se ensamblan los vértices para formar primitivas, se descartan o recortan las que están fuera del campo visual y se mapean a coordenadas de pantalla.

La rasterización determina qué píxeles formarán parte de la imagen final, utilizando un buffer de profundidad para determinar qué fragmentos se dibujan. Se interpola entre los atributos de los vértices para determinar los atributos de cada fragmento y se decide el color de cada píxel, considerando la iluminación, la textura y la transparencia.

Finalmente, los fragmentos dibujados se muestran en la pantalla del dispositivo.

Fuera de este pipeline gráfico, existen los compute shaders@compute_shaders, que son programas diseñados para ejecutarse en la GPU pero que no están directamente relacionados con el proceso de renderizado de imágenes. En lugar de eso, los compute shaders se utilizan para realizar cálculos para otros propósitos que se benefician de la ejecución paralelizable que ofrece la GPU, lo que los hace ideales para tareas como simulaciones físicas, procesamiento de datos masivos o aprendizaje automático.

Su modo de ejecución es el mismo que el mencionado anteriormente usando CUDA, los compute shaders operan en grupos de hilos, lo que permite que múltiples instancias del shader se ejecuten simultáneamente tomando diferentes datos como input.




