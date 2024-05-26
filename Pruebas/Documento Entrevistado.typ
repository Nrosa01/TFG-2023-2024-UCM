#import "setup.typ": *
#show: project

= Creación de 3 partículas

== Arena

La partícula de arena se desplaza hacia abajo si el espacio está vacío o si hay agua. En caso contrario, intenta moverse hacia la derecha y luego hacia abajo; si no es posible, intenta moverse hacia la izquierda y luego hacia abajo. Adicionalmente, para mayor dinamismo, en lugar de probar siempre hacia abajo a la derecha, se sugiere hacerlo de manera aleatoria entre derecha e izquierda.

== Vapor

El vapor se comporta como la arena en su movimiento, pero en lugar de descender, asciende hacia arriba. Es posible usar el comportamiento de la arena como base.

== Agua

Similar a la arena, la partícula de agua se desplaza hacia abajo si no hay obstrucción. Si encuentra alguna, intenta moverse hacia abajo a la derecha y luego a la izquierda. Si no es posible, busca moverse primero hacia la derecha y luego hacia la izquierda.

== Lava

Al igual que la arena, la lava se desplaza en dirección descendente. Sin embargo, después de moverse, verifica si hay alguna partícula de agua adyacente; si la encuentra, la convierte en vapor.

Es decir, por un lado está el movimiento, que es igual que la arena, comprobando solo con el vacío sin el agua. Después de esto, se verifica si hay agua adyacente y, en caso afirmativo, se ha de convertir en vapor
