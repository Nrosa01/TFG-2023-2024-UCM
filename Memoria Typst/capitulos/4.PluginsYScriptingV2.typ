#import "@preview/sourcerer:0.2.1": code

A la hora de crear un videojuego, existen varias estrategias a la hora de diseñar la arquitectura de software. Existe la posibilidad de programar el comportamiento del juego de forma directa, sin embargo esto resulta en un sistema difícil de modificar y reutilizar. Debido a esto se han creado motores de videojuegos. Un motor de videojueogs @gregory-2018 es un conjunto de herramientas que permiten a los desarrolladores crear videojuegos de forma más sencilla. Un motor de videojuegos puede o no tener una interfaz visual. Dicho conjunto de herramientas permite crear el "gameplay" o comportamiento del juego.

Un motor de videojuegos puede proveer más o menos elementos reutilizables. Sin embargo, mientras más elementos o comportamientos predefinidos tenga el motor,  más especializado será, lo cual límita su capcidad de extensibilidad. La forma en que se desarrollan los comportamientos del juego con el motor depende de este mismo. Existen diferentes opciones, cada una con sus ventajas y desventajas.

En este capítulo se van a explorar tres posibilidades para desarrollar el sistema de "scripting" de un motor de videojuegos. Estas son: ficheros de definición de datos, librerías dinámicas y lenguajes de scripting.

== Ficheros de definición de datos

Una opción es usar ficheros de definición de datos, archivos que como su nombre indican, solo contienen datos. Suelen ser representados con un formato legible (YAML, JSON...) puesto que están pensados para ser editados por humanos que además, pueden no ser programadores. Al implementar esta opción, los juegos resultantes son "dirigidos por datos" @sharvit-2022, debido a que en lugar de especificar el comportamiento del juego mediante código, se configura mediante estos ficheros. Esto permite separar el trabajo de los programadores de los diseñadores de niveles o de juego. 

Un ejemplo sencillo de esto es un juego bullet hell. En lugar de especificar mediante código cada patrón, velocidad, tiempos, etc. Se puede definir un fichero que el motor carga durante la ejecución del juego y contiene todos los parámetros necesarios para crear las balas. A continuación muestra un ejemplo de un posible fichero de definición de datos para un juego bullet hell.

#code(
  lang: "YAML",
```yaml
define_action:
  name: "shoot"
  behaviour:
    type: "linear"
    speed: 5
    direction: 90
    time: 1

define_action:
  name: "spawnLots"
  behaviour:
    type: "spawn"
    amount: 10
    do_action:
      type: "shoot"
      direccion: random 0 360

level: 
  do_action: "spawnLots"
  wait: 5
  repeat 10:
    do_action: "spawnLots"
    wait: 0.5
```
)

Debido a que el motor debe contener el código necesario para poder interpretar estos ficheros, existe una gran dependencie con el motor y las opciones de extensibilidad sean limitadas. En este tipo de sistemas no es posible crear juegos radicalmente distintos con solo cambiar los datos debido a estas limitaciones.

== Librerías dinámicas

Para superar las restricciones del modelo anterior, es necesario que el motor sea más flexible, es decir, debe poder permitir definir comportamiento permitiendo mayor libertad. Para ello, se pueden usar librerías dinámicas.

Una librería dinámica @linkers_and_loaders es un archivo que contiene código compilado que puede ser cargado y vinculado a un programa en tiempo de ejecución. Esto significa que el programa no necesita incluir este código en su propio archivo binario, sino que puede cargarlo cuando se necesita. Esto permite definir comportamiento con mucha más flexibilidad. Siguen existiendo limitaciones por parte del motor, pues el desarrollador solo puede usar las funciones del motor que exponga mediante su API. A pesar de ello, esta alternativa resulta ser mucho más versátil que la anterior.

El uso de librerías dinámicas no es exclusivo de los motores de videojuegos. Muchos programas de software utilizan este mecanismo para extender su funcionalidad.

Las librería dinámicas no son un formato universal, sino que cada sistema operativo tiene su propio mecanismo para cargar y vincular librerías dinámicas. Por ejemplo, en Windows se utilizan archivos DLL, en Linux se utilizan archivos SO y en macOS se utilizan archivos dylib. Esto significa que las librerías dinámicas no son necesariamente portables entre sistemas operativos, lo que puede ser una limitación en algunos casos. No obstante, existe un consenso al respecto a su funcionalidad. Por ejemplo, los grandes sistemas operativos actuales, Windows, Linux y MacOS, permiten definir callbacks o funciones para que una librería detecte cuando se ha cargado o descargado por el programa principal. Usar una dependencia que solo funcione en un sistema operativo podría dificultar la portabilidad del juego. Para mantener la portabilidad del sistema es importante ser cuidadodoso con las dependencias que se usan.

A pesar de su versatilidad, el uso de librerías dinámicas tiene ciertos problemas. Como se ha dicho, una librería dinamica contiene código compilado, esto implica que durante el desarrollo del juego, cada vez que se modifique el código de la librería, es necesario recompilarla y recargarla en el motor. Esto puede resultar en un proceso tedioso y lento que afecte de forma significativa al flujo de trabajo. Para evitar este problema, se pueden usar lenguajes de scripting.

== Lenguajes de scripting

Un lenguaje de scripting @barron-2000 es un lenguaje de programación que se utiliza para controlar la ejecución de un programa o para extender su funcionalidad. A diferencia de los lenguajes de programación tradicionales, los lenguajes de scripting suelen ser interpretados en lugar de compilados.  

Un lenguaje de programación compilado es aquel que se transforma en código máquina mediante un proceso conocido como compilación, antes de su ejecución. Durante la ejecución, el sistema operativo carga este código máquina en la memoria y lo ejecuta directamente.

Por otro lado, un lenguaje de programación interpretado no se traduce previamente a código máquina. En su lugar, se traduce y ejecuta simultáneamente durante el tiempo de ejecución por un programa llamado intérprete. Este proceso de traducción incurre en un sobrecoste que hace que los lenguajes interpretados sean más lentos que los compilados. 

Sin embargo, los lenguajes de scripting suelen ser más fáciles de aprender y de utilizar que los lenguajes de programación tradicionales. Esto se debe a que los lenguajes de scripting suelen tener una sintaxis más sencilla y menos reglas que los lenguajes de programación compilados. Suelen ser lenguajes que gestionan la memoria automáticamente, es decir, no es necesario liberar la memoria que se ha reservado, lo que facilita la programación.

Uno de los lenguajes de scripting más usados para modificar e incluso desarrollar videojuegos es Lua @ierusalimschy-2006. Lua es un lenguaje de scripting de alto nivel, multi-paradigma, ligero y eficiente, diseñado principalmente para la incorporación en aplicaciones. Fue creado en 1993 por Roberto Ierusalimschy, Luiz Henrique de Figueiredo y Waldemar Celes, miembros del Grupo de Tecnología en Computación Gráfica (Tecgraf) de la Pontificia Universidad Católica de Río de Janeiro, Brasil.

Lua es conocido por su simplicidad, eficiencia y flexibilidad. Su diseño se centra en la economía de recursos, tanto en términos de memoria como de velocidad de ejecución. Existe una única estructura de datos, la tabla, que se utiliza para representar tanto arrays como diccionarios. Además, para poder "heredar" funciones de una tabla, Lua define el concepto de metatabla. En Lua, cada tabla puede tener asociada una metatabla. Cuando el desarrollador llama a una función y esta no está definida en la tabla, Lua busca en la metatabla de la tabla para ver si la función está definida ahí. Esto es comparable a los prototipos en JavaScript.

Una de las características más destacadas de Lua es su capacidad para ser embebido en aplicaciones @ltd-2023. Esto se debe a su diseño como un lenguaje de scripting, que permite que el código Lua sea llamado desde un programa en C, C++ u otros lenguajes de programación. Esta característica ha llevado a que Lua sea ampliamente utilizado en la industria de los videojuegos, donde se utiliza para controlar la lógica del juego y las interacciones del usuario. Existen motores como Defold que integran Lua como lenguaje de scripting o el popular juego Roblox, que permite a los usuarios crear sus propios juegos utilizando una version modificada de Lua llamada Luau.

Como se ha mencionado, los lenguajes de scripting son interpretados. Sin embargo, existe una técnica llamada compilación Just-In-Time (JIT) que permite compilar el código de un lenguaje de scripting en código máquina durante la ejecución. Esto permite que el código sea ejecutado de forma más rápida, ya que no es necesario interpretarlo en tiempo real. LuaJIT @ltd-2023 es una implementación de Lua que utiliza esta técnica y que ha demostrado ser muy eficiente en términos de velocidad de ejecución.

Sin embargo, cabe destacar que en los lenguajes JIT, puede llegar a ser importante saber ciertos detalles de su funcionamiento interno para poder aprovechar su potencial. Como se mencionó anteriormente, la única estructura de datos en Lua es la tabla, no existen tipos salvo los primitivos (números, booleanos y cadenas de texto). Esto significa que algunas optimizaciones dependen del uso que el desarrollador haga del lenguaje. Por ejemplo, si una función recibe dos parámetros y esos dos parámetros siempre son números, LuaJIT puede optimizar la función en base a heurísticas @de-figueiredo-2008 @ltd-2023. Sin embargo, si durante la ejecución se llama a la función con otro tipo de dato, LuaJIT desactivará la optimización y la función se ejecutará de forma más lenta. Este tipo de optimizaciones son comunes en los lenguajes JIT, por lo que es importante tener en cuenta cómo funcionan para poder aprovechar su potencial.


== Blockly

#include "5.1.Blockly.typ"
