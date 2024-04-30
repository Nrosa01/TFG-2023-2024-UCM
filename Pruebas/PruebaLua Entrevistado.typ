#import "setup.typ": *
#show: project

= Creación de 3 parrtículas

== Arena

La particula de arena debe moverse hacia debajo si está vacio o hay agua. En caso contrario, se intenta lo mismo abajo a la derecha, en caso contrario abajo a la izquierda. Extra: En vez de probar siempre abajo derecha, hacer que sea aleatorio.

== Agua

Es muy similar a la arena. Si no hay nada debajo, se mueve hacia abajo. Si no, intenta moverse hacia abajo a la derecha y luego a la izquierda. Si no, intenta moverse hacia la derecha y luego a la izquierda.

== Vapor

Funciona igual que la arena, pero en vez de ir hacia debajo va hacia arriba.

== Lava

Funciona igual que la arena, pero después de moverse comprueba si hay una particula de agua alrededor, si la hay, la convierte en vapor.

