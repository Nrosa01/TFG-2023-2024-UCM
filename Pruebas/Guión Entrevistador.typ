#import "setup.typ": *
#show: project

= Entrevistador

- Explicar simulador: Usando lenguaje natural, estando presenta o compartiendo pantalla, ejecutar el simulador, explicar qu es y sus controles. 

Chuleta: Un simulador de arena es un programa que simula el comportamiento de distintas partículas en un entorno virtual. En este caso, el simulador de arena que vamos a usar simula el comportamiento de cuatro partículas: arena, agua, vapor y lava. Cada partícula tiene un comportamiento distinto y se mueve de manera diferente en el entorno.

- Explicación de la extensión: En Lua, usar el documento de Lua, leerlo con el usuario y explicarle que es Lua, su sintaxis y como crear particula con el API. Una vez se llegue al final del documento, se debe mostrar en tiempo real al usuario como crear una particula que se mueva hacia abajo sin comprobar nada. En el caso de Blockly, se han de explicar los bloques, resaltando el primero (particula) y el bloque foreach. El resto de bloques pueden tener una explicación menos profunda. Se debe mostrar también al usuario el botón de ayuda para consultar la documentación de los bloques. Finalmente, igual que en Lua, mostrar como crear una particula que simplemente se mueva hacia abajo sin comprobar nada.

- Mostrar solución: Mostrar las 4 particula que se van a proponerr si mostrar el código o los bloques, solo mostrar el resultado visual. Tras esto, se explicará el comportamiento de cada particula y se proporcionará un documento al usuario para que pueda consultar la descripción de la tarea.

En el caso de Lua se entregará un fichero .zip que contiene un acceso directo al juego, que estará en un directorio al mismo nivel del acceso directo. Además, habrá 4 archivo lua: sand.lua, water.lua, steam.lua y lava.lua. Estos archivos contendrán la plantilla de creación de partículas explicada en el documento de Lua. Estas partículas no tienen ningún comportamiento ni tinen el nombre puesto, el usuario debe hacerlo. Sin embargo el color de cada particula sí está puesto.

En el caso de Blockly, se proporcionará la URL al entorno de pruebas, que por defecto solo tiene la partícula del vacío. El usuario debe crear las nuevas particulas con los botones y renombrarlas.