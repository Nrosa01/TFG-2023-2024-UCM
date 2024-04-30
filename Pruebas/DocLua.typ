#import "@preview/sourcerer:0.2.1": code

#import "setup.typ": *

#show: project

= Definición de una partícula

Basta con copiar el código inferior. Puedes sustituir "MiParticle" por el nombre de tu particula, es importante que esté entre comillas. Puedes cambiar los números de r, g, b y a para cambiar el color de la partícula. Por último, puedes añadir el comportamiento de la partícula entre las llaves. Para ello, es necesario programar en Lua. Se proporcionarán una serie de comandos para simplificar esta tarea.

#code(
  lang: "Lua",
```lua
addParticle(
    "MyParticle",                           -- Particle Name
    { r = 255, g = 255, b = 255, a = 255 }, -- Color
    function(api)                           -- Behaviour

    end
)
```
)

= Programar en Lua

A continuación se detallan las bases de programar en Lua mediante un ejemplo de código que será explicado por el entrevistador tras la finalización de la lectura de este documento.

#code(
  lang: "Lua",
```lua
local myVariable = 0 -- Variable definition
local myBool = true  -- Boolean definition
local randomInterval = math.random(0, 10) -- Random number between 0 and 10, both inclusded
local particleType = ParticleType.SAND -- Id of the sand particle, error if there is no particle with that name. Aunuqe el nombre de la particula tenga minusculas, el id siempre se escribe en mayusculas. Por ejepmlo, si mi particula se llama MyParticle el id será ParticleType.MY_PARTICLE
-- Siempre existe una particula que representa la ausencia de particula, esta se llama EMPTY

-- Array
local myArray = {1, 2, 3, 4, 5}

-- If statement
if myVariable == 0 then
    myVariable = 1
end

-- If else statement
if myVariable == 0 then
    myVariable = 1
elseif myVariable == 1 then
    myVariable = 2
else
    myVariable = 0
end    

-- Logical operators
---------------
--- == => Equal
--- ~= => Not equal
--- <  => Less than
--- >  => Greater than
--- <= => Less than or equal

-- Loops
while myBool do
  -- Do something
end

-- For loop
for i = 0, 10 do
  -- Do something
end

-- Iterating over an array
-- The following code prints the index and value of each element in the array
for index, value in ipairs(myArray) do
  print("Index: " .. index .. " Value: " .. value)
end
```
)

= Funciones para programar partículas

Estas funciones se usan de la forma `api:funcion()`. A continuación se detallan las funciones que se pueden usar para programar partículas.

#code(
  lang: "Lua",
```lua
get_neighbours() -- Devuelve un array de direcciones. Las direcciones son un objeto con componente X e Y, se usa así.

-- Se usa para recorrer los vecinos de una partícula
for _, direction in ipairs(api:get_neighbours()) do
    if api:getParticleType(direction.x, direction.y) == ParticleType.TYPE then
        -- Haz algo
    end
end

-- Cambia la partícula en la posición x, y por la partícula con el id id. La posición x e y son relativas a la partícula actual, por lo que si se pasa x = 0 y y = 0, se cambiará la partícula actual, o por ejemplo si se pasa x = 1 y y = 0, se cambiará la partícula a la derecha de la actual. Esto aplica para todas las funciones que requieran x e y. Posición x positiva es derecha, posición y positiva es arriba. Posición x negativa es izquierda, posición y negativa es abajo.
setNewParticleById(x, y, id) 

-- Ejemplo de uso
setNewParticleById(0, 0, ParticleType.WATER) -- Cambia la partícula actual por agua (asumimos que existe una particula que se llama WATER)

swap(x, y) -- Intercambia la partícula actual con la partícula en la posición x, y
isEmpty(x, y) -- Devuelve true si la posición x, y está vacía
getParticleType(x, y) -- Devuelve el id de la partícula en la posición x, y
check_neighbour_multiple(x, y, id_array) -- Devuelve true si la posición x, y tiene una partícula con el id id
```
)

= Ejemplo de Particula Completa

Esta particula va ahcia abajo si tiene una partícula vacía o de aire debajo.
#set text(8pt)

#code(
  lang: "Lua",
```lua
addParticle(
    "GoDown",                                   -- Text id
    { r = 255, g = 0, b = 255, a = 255 },     -- Color
    function(api)
        local dirY = -1
        local id_array = { ParticleType.EMPTY, ParticleType.AIR }

        if api:check_neighbour_multi(0, dirY, id_array) then
            api:swap(0, dirY)
        end
    end
)
```
)

