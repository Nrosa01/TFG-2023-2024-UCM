Este apartado tiene como objetivo explicar qué es Blockly así como su funcionamiento.

Blockly es una biblioteca perteneciente a Google lanzada en 2012 que permite a los desarrolladores la generación automática de código en diferentes lenguajes de programación mediante la creación de bloques personalizados. Fue diseñado inicialmente para generar código en JavaScript, pero debido a su creciente demanda, se ha adaptado para admitir de manera nativa la generación de código en una amplia variedad de lenguajes de programación: JavaScript, Python, PHP, Lua y Dart. 

Esta biblioteca es cada vez más conocida y usada en grandes proyectos. Actualmente se emplea en algunos como ‘App Inventor’ @app_inventor del MIT @MIT, para crear aplicaciones para Android, ‘Blockly Games’ @blockly_games, que es un conjunto de juegos educativos para enseñar conceptos de programación que también pertenece a Google, ‘Scratch’ @scratch, web que permite a jóvenes crear historias digitales, juegos o animaciones o Code.org @code.org para enseñar conceptos de programación básicos. 

//explicar por que se queBlockly es la biblioteca más extendida para este comportamiento ?
//y que fallos me permite revisar el tener acceso al codigo fuente
//tampoco es una biblioteca reciente aunque las carencias en documentacion y demas si que estan ahi

El motivo de la utilización de Blockly como biblioteca para desarrollar el comportamiento deseado fue que es la biblioteca más extendida para realizar este tipo de comportamiento. No existe mucho software que permita generar código personalizado utilizando tus propios bloques. Además, tiene otras ventajas como que es de código abierto, lo que facilitó el desarrollo al permitir consultar el código fuente para revisar fallos o comprender cómo se crean ciertos elementos. Como principal desventaja se encuentra que no cuenta con una documentación del todo completa, además que cada versión renueva muchos elementos por lo que tutoriales, guías o soluciones a problemas pasados cambian completamente de un año a otro.


Blockly opera del lado del cliente y ofrece un editor dentro de la aplicación, permitiendo a los usuarios intercalar bloques que representan instrucciones de programación. Estos bloques se traducen directamente en código según las especificaciones del desarrollador. Para los usuarios, el proceso es simplemente arrastrar y soltar bloques, mientras que Blockly se encarga de generar el código correspondiente. Luego, la aplicación puede ejecutar acciones utilizando el código generado.


A continuación, se detalla tanto la interfaz que se muestra al usuario de la aplicación como el funcionamiento y proceso de creación de bloques y de código a partir de ellos.


Un proyecto de Blockly se tiene la siguiente estructura @blockly-visual:

#figure(
  image("../images/Blockly.jpg", width: 50%),
  caption: [
    estructura básica de Blockly
  ],
)<blockly_structure>

//hacer distincion entre usuario y desarrollador ya que ambos son tecnicamente programadores en este ambito
La figura @blockly_structure muestra la estructura de un proyecto de Blockly. Esta se divide en 2 partes básicas, la toolbox o caja de herramientas y el workspace o espacio de trabajo. La toolbox alberga todos los bloques que haya creado el desarrollador o que haya incluido por defecto. Estos bloques los puede arrastrar al workspace para generar lógica que haya sido definida por el desarrollador. Por defecto, todos los bloques son instanciables las veces que sean necesarias.

Para que el usuario pueda usar un bloque correctamente, son necesarios tres pasos desde el punto de vista del desarrollador @blockly-block-creation:
- Definir cómo es su apariencia visual. Esto puede ser realizado tanto usando código JavaScript como mediante JSON. Es recomendable usar JSON, aunque por características particulares puede ser necesario definirlos mediante JavaScript.
- Especificar el código que será generado una vez haya sido arrastrado el bloque al workspace. Debe haber una definición del código a generar por cada bloque y lenguaje que se quiera soportar.
- Incluirlo en la toolbox para que pueda ser utilizado. Esto puede ser realizado mediante XML O JSON, aunque Google recomienda el uso de JSON.

//esta zona en caso de que esto se quede en "estado del arte" no tendria mucho sentido

La definición de la apariencia y la inclusión en la toolbox son tareas bastante directas. Sin embargo, la generacion de código requiere la presencia de un intérprete que genere código a partir del texto que devuelve la función. En caso de querer generar código para un lenguaje no soportado por defecto, el desarrollador necesitará crear este intérprete.

En el caso de este proyecto, por optimización se decidió que la definición de partículas se diera a traves de JSON, y que ese JSON se parseara a código Rust. Debido a que JSON no requiere especificar la ejecución de nada, solo definir el texto de una manera correcta, esta implementación no resultó compleja.
