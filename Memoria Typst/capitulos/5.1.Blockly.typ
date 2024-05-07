
Este apartado tiene como objetivo explicar qué es Blockly así como su funcionamiento.

Blockly es una biblioteca perteneciente a Google lanzada en 2012 que permite a los desarrolladores la generación automática de codigo en diferentes lenguajes de programación mediante la creación de bloques personalizados. Fue diseñado inicialmente para generar código en JavaScript, pero debido a su creciente demanda, se ha adaptado para admitir de manera nativa la generación de código en una amplia variedad de lenguajes de programación: JavaScript, Python, PHP, Lua y Dart. 

Esta biblioteca es cada vez más conocida y usada en grandes proyectos. Actualmente se emplea en algunos como ‘App Inventor’ del MIT,para crear aplicaciones para Android, ‘Blockly Games’, que es un conjunto de juegos educativos para enseñar conceptos de programación que también pertenece a Google, ‘Scratch’, web que permite a jóvenes crear historias digitales, juegos o animaciones o Code.org para enseñar conceptos de programación básicos. 

El motivo de la utilización de blockly como biblioteca para desarrollar el comportamiento deseado fue que es la biblioteca mas extendida para realizar este tipo de comportamiento. No existe mucho software que te permita generar codigo personalizado utilizando tus propios bloques. Además, tiene otras ventajas como que es de código abierto, lo que facilitó el desarrollo al permitir consultar el código fuente para revisar fallos o comprender cómo se crean ciertos elementos. Como principal desventaja se encuentra que al ser una biblioteca reciente no cuenta con una documentación del todo completa, además que cada versión renueva muchos elementos por lo que tutoriales, guías o soluciones a problemas pasados cambian completamente de un año a otro.


Blockly opera del lado del cliente y ofrece un editor dentro de la aplicación, permitiendo a los usuarios intercalar bloques que representan instrucciones de programación. Estos bloques se traducen directamente en código según las especificaciones del desarrollador. Para los usuarios, el proceso es simplemente arrastrar y soltar bloques, mientras que Blockly se encarga de generar el código correspondiente. Luego, la aplicación puede ejecutar acciones utilizando el código generado.


A continuación, se detalla tanto la interfaz que se muestra al usuario de la aplicación como el funcionamiento y proceso de creación de bloques y de código a partir de ellos.

Un proyecto de blockly se tiene la siguiente estructura @blockly-visual:

#figure(
  image("../images/Blockly.jpg", width: 50%),
  caption: [
    estructura básica de blockly
  ],
)

Un proyecto de blockly se divide en 2 partes básicas, la toolbox o caja de herramientas y el workspace o espacio de trabajo. La toolbox alberga todos los bloques que haya creado el programador o que haya incluido por defecto. Estos bloques los puede arrastrar al workspace para generar lógica que haya sido definida por el desarrollador. Por defecto, todos los bloques son instanciables las veces que sean necesarias.

Para que el usuario pueda usar un bloque correctamente, son necesarios 3 pasos desde el punto de vista del desarrollador @blockly-block-creation:
- Definir cómo es su apariencia visual. Esto puede ser realizado tanto usando código Javascript como mediante JSON. Es recomendable usar Json, aunque por características particulares puede ser necesario definirlos mediante Javascript.
- Especificar el código que será generado una vez haya sido arrastrado el bloque al workspace. Debe haber una definición del código a generar por cada bloque y lenguaje que se quiera soportar.
- Incluirlo en la toolbox para que pueda ser utilizado. Esto puede ser realizado mediante XML y JSON, aunque Google recomienda el uso de JSON.

Estos tres pasos se ven de la siguiente manera en código. Suponiendo la creación de un simple bloque con un cuadro de texto rellenable por el usuario:

#show raw.where(block: true): box.with(
  fill: luma(240),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)

Apariencia



```Javascript
export const blocks = Blockly.common.createBlockDefinitionsFromJsonArray([{
{
    "type": 'text',
    "message0": "%1",
    "args0": [
        {
            "type": "field_input",
            "name": "FIELDNAME",
            "text": "default text",
            "spellcheck": false
        }
    ],
}
}]);

```
#linebreak()
Generación

```Javascript
import {javascriptGenerator} from 'blockly/javascript';
javascriptGenerator.forBlock = function(block) {
  var text_fieldname = block.getFieldValue('FIELDNAME');
  var code = '"' + text_fieldname + '"';
  return [code, Blockly.JavaScript.ORDER_ATOMIC];
};

```
#linebreak()
Inclusión

```JavaScript
export const toolbox = {
  'kind': 'flyoutToolbox',
  'contents': [
    {
      {
        'kind': 'block',
        'type': 'text'
      }
}]};
```

La definición de la apariencia y la inclusión en la toolbox son tareas bastante directas. Sin embargo, la generacion de código requiere la presencia de un intérprete que genere código a partir del texto que devuelve la función. En caso de querer generar código para un lenguaje no soportado por defecto, el desarrollador necesitará crear este intérprete.

En el caso de este proyecto, por optimización se decidió que la definición de partículas se diera a traves de JSON, y que ese JSON se parseara a código Rust. Debido a que JSON no requiere especificar la ejecución de nada, solo definir el texto de una manera correcta, esta implementación no resultó compleja.


// a partir de aqui hablar de la implementacion particular de blockly en nuestra implementacion, no se como de mucho tendre que hablar, no voy a ponerme a contar todos los bloques , o si

La apariencia de blockly en nuestra aplicación es la siguiente: 

#figure(
  image("../images/InterfazPixelCreator.png", width: 75%),
  caption: [
    interfaz blockly pixel creator
  ],
)

la apariencia visual es igual a la apariencia general presentada anteriormente. Como elementos particulares, se encuentran 3 botones en la zona inferior derecha con el siguiente comportamiento ordenado de arriba a abajo: centrar la pantalla, aumentar el zoom, disminuir el zoom. Además, los bloques al moverlos se colapsan sobre una grilla definida por los puntos visibles en el workspace.

Cada partícula nueva crea un workspace nuevo e independiente del resto. Este workspace es creado con un bloque por defecto que define atributos básicos para la particula como el nombre, el color o el rango de transparencia aleatoria que puede tener cada instancia de partícula creada. Todo bloque que no se encuentre contenido dentro de este bloque no será procesado por el intérprete de JSON.


// iba a explicar como va esto pero cuento con que para este punto se haya explicado como funciona la creacion de particulas ¿?
// #figure(
//   image("../images/CreacionParticulas.png", width: 75%),
//   caption: [
//     workspace creación de partícula
//   ],
// )
