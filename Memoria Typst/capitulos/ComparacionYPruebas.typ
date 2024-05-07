Una vez entendidos los automátas celulares y las implementaciones realizadas, se procede a evaluar y compararlas de la siguiente forma:

- Por un lado, una evaluación de rendimiento en cada una de las implementaciones, tanto en CPU como en GPU. 
- Por el otro, una evaluación de usabilidad. Para esta se evaluará la capacidad de los usuarios de expandir el sistema dadas unas instrucciones.

== Comparación de rendimiento

Para asegurar que la comparación sea justa, todas las pruebas se han realizado en el mismo hardware. Además, para medir el rendimiento se aumentará el número de partículas simuladas por segundo hasta que ninguno de los sistemas pueda ejecutar la simulación en tiempo real, esto es, 60 veces por segundo.

Se han realizado las diversas pruebas:

- Comparación entre todos los simuladores con tipo de partícula.
- Comparación entre los simuladores de CPU con distintos tipos de partículas.

En la primera prueba solo se usa una partícula de arena para la comparación debido a que es la única común a todos los simuladores, pues la implementación en GPU no implementa otros tipos de partículas actualmente.

--- Aquí habría que poner las gráficas y tal

== Comparación de usabilidad

Para evaluar la usabilidad de los distintos sistemas se ha realizado una encuesta a un grupo de X personas. En ella se les ha pedido que realicen una serie de tareas en el simulador de Lua, el de Rust web o ambos. La tarea fue la misma para ambos simuladores y el proceso fue grabado. Se evalúa tanto el tiempo que tardan en realizar la tarea como la cantidad de errores y confusiones que cometen. El grupo de usuarios seleccionado cubre un perfil amplio de individuos, desde de estudiantes de informática hasta personas sin conocimientos previos en programación. En ambos casos, ninguno de los usuarios había utilizado previamente ninguno de los simuladores ni conocían la existencia de los simuladores de arena.

Una vez realizadas las pruebas, se clasificaron de acuerdo a una serie de parámetros, la visualización de estdos datos puede verse en la siguiente tabla:

--- Aquí habría que poner la tabla

