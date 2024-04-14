
En este capítulo, se desea introducir al lector el funcionamiento y programación de GPUs, hablando acerca de su arquitectura, es decir, cómo están fabricadas,su origen y sus usos.

== Introduccion

Las Unidades de Procesamiento Gráfico, comúnmente conocidas como GPUs (por sus siglas en inglés, Graphics Processing Units), son hoy en dia un componente clave de la informática moderna presente en todos los ordenadores, destinado principalmente al procesamiento gráfico.

//no he encontrado info acerca de pixel planes mas allá del libro
El origen del concepto de lo que sería una GPU hoy en día, se remonta a 1980, con un proyecto en el cual con el objetivo de generar imagenes 3D para el estudio de la estructura protéica, en la Universidad de Carolina del Norte (UNC) desarrollaron un sistema llamado Pixel Planes/*@pixel-planes*/, el cual tuvo la innovadora aplicación de asignar un procesador por pixel mostrado,  lo que significaba que muchas partes de las imágenes en la pantalla se generaban simultáneamente, mejorando enormemente la velocidad en la cual se generaban los gráficos.@history_of_gpu Este trabajo continuó hasta 1997 donde se desarrolló la última iteración del proyecto.
/*
#figure(
  image("../images/NEC.jpg", width: 30%),
  caption: [
    NEC µPD7220
  ],
)
*/

En 1982, Nippon Electric Company introdujo el primer controlador gráfico a gran escala, el chipset gráfico  NEC µPD7220, lanzado originalmente para la PC-98. Este controlador introdujo aceleración hardware para dibujar lineas, círculos y otras figuras geométricas en una pantalla de píxeles.

Hasta ese momento, se utilizaban terminales caligráficas para mostrar dibujos e imagenes mediante trazos vectoriales en lugar de píxeles individuales, ya que la mayoría de microcomputadores carecían de la potencia necesaria para hacer uso de pantallas rasterizadas, que utilizan una cuadrícula de píxeles para representar imágenes en pantalla.

#figure(
  image("../images/geforce256.jpg", width: 50%),
  caption: [
    Geforce 256, la primera tarjeta gráfica independiente
  ],
)

El término GPU no se popularizaría hasta el año 1999, donde NVIDIA sacó y comercializó la GeForce 256 @geforce_256 como la primera unidad de procesamiento gráfico completamente integrada que ofrecía transformaciónes de vértices, iluminación, configuración y recorte de triángulos y motores de renderizado en un único procesador de chip integrado.
El chip contaba con numerosas características avanzadas, incluyendo cuatro pipelines de renderizado independientes. Esto permitía que la GPU alcanzara una tasa de relleno (cantidad de píxeles que una GPU escribe sobre la memoria de vídeo para crear el fotograma sobre esta) de 480 Megapíxeles por segundo. La salida de video era VGA. Además, el chip incluía mezcla de alfa por hardware y cumplía con los estándares de televisión de alta definición (HDTV).
Lo que de verdad diferenció a la GeForce 256 de la competencia fue la integración de iluminación que lo diferenció de modelos pasados y de la competencia, que hacían uso de la CPU para ejecutar este tipo de funciones, mejorando el rendimiento y abaratando costes para el consumidor.

== Arquitectura

El propósito principal de una GPU es priorizar el procesamiento rápido de instrucciones simples mediante una estrategia de "divide y vencerás". Esto implica dividir la tarea en componentes más pequeños que pueden ser ejecutados por los numerosos núcleos presentes en una GPU. A diferencia de los núcleos de la CPU, los núcleos de la GPU son más lentos y menos versátiles, con un conjunto de instrucciones más limitado. Sin embargo, la compensación radica en el mayor número de núcleos disponibles para ejecutar instrucciones en paralelo. @gpu_architecture2


#figure(
  image("../images/cpugpu.png", width: 60%),
  caption: [
    Comparativa arquitectura de un chip de CPU y de GPU
  ],
)


Se hará uso de CUDA para explicar el funcionamiento de la ejecución de programas en GPU.@gpu_arquitecture

La GPU está optimizada para realizar tareas de manera paralela, mientras que la CPU está diseñada para ejecutar tareas de forma secuencial. Esta diferencia se refleja en la distribución del espacio dentro del chip. En una GPU, la mayor parte del espacio se dedica a tener muchos núcleos pequeños, mientras que en una CPU, la estructura está más orientada hacia una jerarquía de memoria, con múltiples niveles de caché y núcleos más grandes, potentes y capaces, pero limitados en términos de paralelización.

La arquitectura de la GPU se compone de múltiples SM (Streaming Multiprocessors), que son procesadores de propósito general con baja velocidad de reloj y una caché pequeña. La tarea principal de un SM es controlar la ejecución de múltiples bloques de hilos, liberándolos una vez que han terminado y ejecutando nuevos bloques para reemplazar los finalizados. Cada SM está formado por núcleos de ejecución, una jerarquía de memoria que incluye: caché L1, memoria compartida, caché constante y caché de texturas, un programador de tareas y un número considerable de registros.

#figure(
  image("../images/SM.png", width: 50%),
  caption: [
    Streaming Multiprocessor
  ],
)

Desde el punto de vista de software, la ejecución de programas se divide en kernels, grids de bloques, bloques de hilos e hilos.

Se le conoce como kernel a aquellas funciones que están destinadas a ser ejecutadas en la GPU desde la CPU o Host. 
Estas funciones se subdividen en un grid de una, dos o hasta 3 dimensiones de bloques de hilos mediante los que se ejecutará el kernel. El número de bloques totales que se crean viene dictado por el volumen de datos a procesar. Es totalmente necesario que estos bloques de hilos puedan ser ejcutados de manera totalmente independiente y sin dependencias entre ellos, ya que a partir de aquí el programador de tareas es el que decide que y cuando se ejecuta. Los hilos dentro del bloque pueden cooperar compartiendo datos y sincronizando su ejecución para coordinar los accesos a datos, teniendo una memoria compartida a nivel de bloque. El número de hilos dentro de un bloque esta limitado por el tamaño del SM, ya que todos los hilos necesitan residir en el mismo SM para poder compartir recursos de memoria.

#figure(
  image("../images/softwareGPU.png", width: 40%),
  caption: [
    Jerarquía de ejecución
  ],
)

== Usos

La función inicial y principal de las GPU era la de procesar la imagen que iba a ser mostrada al usuario. Para facilitar esto, se crearon los shaders, pequeños programas gráficos destinados a ejecutarse en la GPU como parte de la pipeline principal de renderizado, cuya base es transformar inputs en outputs que finalmente formarán la imagen a mostrar.

//no se si contar esto
El pipeline principal de renderizado esta compuesto de manera general por las siguientes etapas:
El shader de vértices recibe el input directamente de la CPU, y su trabajo principal es calcular cual será la posición final de cada vertice en la escena. Le sigue la etapa de teselación, la cual es  opcional, y cuya labor es la de transformar las superficies formadas por los vértices en primitivas mas pequeñas, aumentando el nivel de detalle de la malla a mostrar. El shader de geometría, también opcional, genera una o más primitivas como output a partir de una primitiva recibida como input. Le siguen las etapas de post-procesado, donde se descarta el area de volúmenes fuera del volumen visible, el ensamblado de primitivas, que ordena la geometría de la escena en una secuencia de primitivas simples (lineas, puntos o triangulos), la rasterización, donde se transforma las primitivas recibidas en fragmentos a traves de los cuales podemos determinar el estado final de cada pixel, y por último el shader de fragmentos, que determina el color final de cada "fragmento" o pixel de la escena. Opcionalmente existen ciertos tests que se ejcutan al terminar el shader de fragmentos.@graphics_pipeline

Durante muchos años, los programadores utilizaban los shaders modificables , es decir, el shader de vertices,de geometría y de fragmentos para realizar ciertas operaciones que no implicaban de manera directa al pipeline gráfico, para así aprovechar la potencia de cómputo que ofrece la GPU. Por este motivo, se introdujeron los compute shaders, shaders que pueden ser ejecutados fuera del pipeline gráfico.@compute_shaders 

La manera de trabajar con ellos funciona de manera similar a lo explicado anteriormente, cada compute shader ejecuta una funcion que se subdivide en work groups de una, dos o tres dimensiones que a su vez contienen un número de hilos que puede estar subdividido también en hasta 3 dimensiones. 
