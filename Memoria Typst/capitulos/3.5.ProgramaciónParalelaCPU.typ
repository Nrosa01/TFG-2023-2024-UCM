Para poder ejecutar los programas se requiere de una estructura que pueda procesar un conjunto de instrucciones dados, esta estructura es la Unidad Central de Procesamiento (CPU, por sus siglas en inglés). La CPU es el componente principal de un ordenador y otros dispositivos programables, que interpreta y ejecuta instrucciones contenidas en los programas informáticos. La CPU lleva a cabo la mayoría de los cálculos que permiten a un sistema operativo y sus aplicaciones funcionar. La CPU no es una pieza única, sino que está compuesta por una series núcleos que a su vez están compuestos por otras partes @ComputerOrganizationPatterson. Cada CPU es distinta pero todas presentan al menos los siguientes componentes en la estructura de su núcleo: la Unidad de Control (UC), la Unidad Aritmético Lógica (ALU), varios registros, la Unidad de Punto Flotante (FPU), una memoria de muy rápido acceso llamada caché y un conjunto de buses que conectan estos componentes.

La UC supervisa y coordina las operaciones de la CPU. Controla la secuencia de ejecución de las instrucciones y dirige el flujo de datos entre la CPU y otras partes del sistema. La ALU realiza operaciones aritméticas y lógicas en los datos, como sumas, restas, multiplicaciones, divisiones y operaciones booleanas con la restricción de estar limitada a números enteros. Los registros son pequeñas áreas de almacenamiento de alta velocidad que se utilizan para almacenar datos temporales y direcciones de memoria, estos forman parte del ensamblado principal de la CPU. La FPU es una unidad especializada que realiza operaciones en números de punto flotante, como sumas, restas, multiplicaciones y divisiones. La caché es una memoria de muy rápido acceso que almacena copias de datos, tienen más almacenamiento que los registros pero son más lentas en comparación al estar en una parte más externa del ensamblaje principal. Los buses son caminos de comunicación que permiten que los datos se muevan entre los componentes de la CPU y otros dispositivos del sistema.

#grid(columns: 2,
  ..(figure(
  image("../images/cpuinternal.png", width: 100%),
  caption: [
    Estructura del núcleo de una CPU
  ],
),
figure(
  image("../images/cpuinternal2.png", width: 75%),
  caption: [
    Estructura general de una CPU
  ],
)
)
)


Un núcleo de CPU es una unidad de procesamiento que puede ejecutar instrucciones de programa usando los componentes mencinoados. En los sistemas modernos, una CPU puede tener múltiples núcleos, lo que permite que se ejecuten múltiples instrucciones simultáneamente.

Los hilos, o threads @ComputerOrganizationPatterson, son una forma de dividir un programa en dos o más tareas paralelas. Cada hilo en un programa ejecuta su propio flujo de control. En un sistema con un solo núcleo,, donde el sistema operativo alterna rápidamente entre ejecutar hilos de diferentes programas.

Es posible aprovechar aún más el rendimiento mediante una tecnología llamada Hyperthreading. Esta, es una tecnología desarrollada por Intel que permite a un solo núcleo de CPU simular dos núcleos lógicos. Como se ha visto, un núcleo tiene distintos componentes, simular dos núcleos lógicos permite usar más de un componente al mismo tiempo. Por ejemplo, si una parte del programa está haciendo una operación con números enteros (usando la ALU), es posible que otra parte de este use la FPU simultáneamente para hacer operaciones con números de punto flotante. De esta forma se aprovechan mejor los recursos de la CPU y se obtiene más rendimiento.

Cada hilo posee su propia región de memoria en el stack, o pila. La pila es una estructura de datos que sigue el principio de "último en entrar, primero en salir" (LIFO, por sus siglas en inglés). Se utiliza para almacenar variables locales y para rastrear el progreso en la ejecución del hilo, como las llamadas a funciones. No obstante, todos los hilos en un proceso comparten el mismo espacio de memoria del heap. El heap es una región de memoria utilizada para el almacenamiento dinámico de datos, es decir, para variables globales y datos asignados dinámicamente durante la ejecución del programa.

La programación paralela es una técnica que se utiliza para mejorar el rendimiento de los programas al permitir que se ejecuten múltiples tareas simultáneamente. Esta técnica se refiere a la capacidad de un programa para ejecutar tareas de manera simultánea en diferentes núcleos o procesadores.

No obstante, la programación paralela presenta desafíos únicos. Entre estos se incluyen problemas de sincronización, donde diferentes hilos intentan acceder o modificar los mismos datos al mismo tiempo. También se pueden presentar problemas de bloqueo o 'deadlocks', donde dos o más hilos se bloquean mutuamente al esperar que el otro libere un recurso.

Sin embargo, dichos problemas tienen soluciones y permiten lograr un incremento de velocidad considerable. Esto será relevante para el siguiente apartado, donde se explicarán las distintas implementeciones de simuladore de arena realizadas en CPU. Posteriormente, se compararán con las implementaciones realizadas en GPU en términos de rendimiento y usabilidad.