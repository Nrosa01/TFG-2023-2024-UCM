#import "@preview/sourcerer:0.2.1": code

El desarrollo de software puede llegar a ser complejo. Mientras más funcionalidad se requiere más complejo es mantener el código. Debido a esto, los ingenieros de software han desarrollado una serie de técnicas y metodologías para facilitar el desarrollo de software. Un problema habitual, es querer usar cierta funcionalidad en diferentes programas. Podría implementarse en cada uno de estos, pero en dicho caso se está duplicando código. Además de que hay que mantener la misma funcionalidad en diferentes lugares. Para paliar este problema existen las librerías dinámicas y estáticas @linkers_and_loaders. Una librería dinámica no forma parte del programa en sí, es un archivo separado del ejecutable principal. En cambio, una librería estática es parte del ejecutable. Esto tiene varias implicaciones, de las cuales una es particularmente interesante: Se puede cambiar una librería dinámica por otra, actualizando así el programa sin tener que compilarlo entero.

Esta particularidad da lugar a la posibilidad de crear plugins @plugin_architecture. Sin embargo, un plugin no tiene por qué ser una librería dinámica. Un plugin es cualquier componente de software que permita añadir funcionalidad a un programa sin tener que modificar el código fuente del programa.

Tras investigar distintos mecanismos para extender un programa, se llegó a la conclusión de que hay 3 posibilidades principales. Cada una con sus ventajas y desventajas: 

== Extensión mediante librería dinámica

Extender un programa mediante librerías dinámicas es algo habitual. Las librerías dinámicas tienen dos ussos fundamentales. Por un lado, permiten utilizar código común en diferentes programas. Por otro lado, permiten extender un programa sin tener que modificar el código fuente del programa. Además de esta modularidad, también simplifica el desarrollo, pues al separar el código en módulos, solo es necesario compilar aquellos que se han modificado. Un ejemplo claro son las 'assemblies' en .NET. @csharpassembly. Por último, una ventaja utilizada en el mundo de los videojuegos es que las DLLs en el caso de windows, además de código, permiten guardar recursos como texturas, modelos 3D, sonidos, etc. @resource_only_dll. Esto permite, por ejemplo, compartir mods de un juego en un solo archivo. 

Sin embargo, las librerías dinámicas tienen algunos problema o inconveniencias a tener en cuenta. Por un lado, la compatibilidad entre plataformas. Cada sistema operativo gestiona las librerías dinámicas de una forma disinta @linkers_and_loaders, en Windows se usan DLLs, en distribuciones Linux se usan SOs, en MacOS se usan dylibs. Por otro lado, la compatibilidad entre versiones. Existen también problemas de seguridad, pues una librería dinámica puede ser modificada por un atacante para lograr la ejecución de código malicioso cierto grado de acceso al sistema.

Por último, un gran problema es la compatibilidad entre distintos lenguajes o versiones del mismo lenguaje @understanding_abi. Podemos tener un programa principal que carga una DLL y llama a una función de esta. Si el programa y la DLL están compilados con la misma versión de g++, funcionará, sin embargo, si compilamos la DLL o el programa con clang o msvc podría no funcionar correctamente. Existe una solución para esto que es común a la mayoría de lenguajes, y es la creación de una interfaz en C. El problema de esto es que que al trabajar con el ABI de C no es posible acceder a ciertas características del lenguaje en el que se está trabajando, o en ciertos casos es incluso necesario modificar tu propio programa para que sea compaible @reprc. En el caso de querer usar tipos del lenguaje, es necesario pasar un puntero opaco void\* y castearlo, según el lenguaje esto podría suponer un overhead.

== Extensión mediante un archivo propietiario

Esta opción consiste en usar una especie de archivo de configuración definida por el desarrollador. El programa leerá este archivo y realizará ciertas acciones. Esto es independiente de la plataforma, no conlleva riesgos de seguridad\* y no depende del ABI de ningún lenguaje. Además, al ser un fichero de texto, no es necesario compilarlo. Sin embargo, esta opción es mucho más limitada, pues solo podrá extenderse cierta funcionalidad del programa de forma limitada. Esto puede ser útil para tareas específicas, por ejemplo un sistema danmaku:

#code(
  lang: "Danmaku",
```rust
fire circle-blue <0,-5>
  repeat-every 8
    randomize-x -6 6
        fire-particle
            cartesian-velocity
                randomize-time 0 4
                    periodize 4
                        lerpfromtoback 0.5 1.5 2.5 3.5
                            <0,0.4>
                            <0,0.7>
```
)


El usuario que consuma esta API está limitado al formato y funciones que el desarrollador ha dado. Además, en sistemas más complejos como el de este ejemplo, esta solución puede ser más difícil de implementar de manera eficiente. Este método de extensión va más alla de un simple archivo de configuración para un sistema con unos parámetros fijos. Esta clase de sistemas puede permitir elegir cierta combinación de parámetros en cierto orden. Este sistema es similar al siguiente que veremos.

== Extensión mediante un lenguaje de scripting

Hay un punto intermedio entre ambas opciones. El uso de DLLs brinda una flexibilidad notable, pero su portabilidad hacia otras plataformas puede ser problemática. Por otro lado, un archivo de configuración es más limitado, requiriendo que el desarrollador implemente un parseador (si utiliza un formato propio) y luego genere las funciones adecuadas. Dar el paso hacia un lenguaje de scripting va un poco más allá. Aquí, el programador se libera de la necesidad de crear un parseador, ya que el intérprete del lenguaje asume esta tarea. Este intérprete puede interactuar con el programa principal a través de una API, permitiendo al programador aprovechar todas las funciones que el lenguaje de scripting ofrece. Además, al igual que los archivos de configuración, este método es multiplataforma, ya que los intérpretes suelen estar disponibles en distintos sistemas operativos. No obstante, toda esta flexibilidad conlleva problemas de seguridad. Además, los lenguajes interpretados suelen ser más lentos que los compilados, lo cual debe tenerse en cuenta especialmente si se prioriza el rendimiento o si el código del lenguaje de scripting se encuentra en un camino crítico de ejecución (hotpath). Se debe tener en cuenta también el overhead por transferir datos de un lenguaje a otro, en el caso de Lua esto implica modificar constantemente un stack. Para demostrar esto, a continuación se muestra una pequeña prueba comparando la ejecución de código en C++ desde una DLL y desde un script en LuaJit usando Sol2 como bridge. Las pruebas se ejecutan en release.

Entorno común:

#text(red)[Por ahora pongo esto aquí, pero no sé si debería poner el resultado y poner esta explicación y código como un fichero anexo. Tengo muchos más benchmarks, este es simplemente el más significativo.]

Se define una estructura de la siguiente forma:

#code(
  lang: "C++",
```cpp
struct ship {
	int life = 100;

	bool hurt(int by) {
		life -= by;
		return life < 1;
	}
};
```
)

Para el test de lua se creará obtendrá una función de lua que usará nuestro struct de C++ y se llamará desde C++ 10000*10000 veces. Para exponer la función a Lua se usará la api c_call de sol2. Esta es menos legible que el api común de sol2, pero es más rápida.\*

#text(red)[Además de que la doc de sol2 menciona que esta forma es más aunque sea más lenta, hice pruebas, no las puse porque no creo que sean importantes. Pero por poder podría hasta explicar porque esto es más rápido que lo otro, pero creo que se sale del ámbito de este TFG.]

#code(
  lang: "C++",
```cpp
	sol::state lua;
	lua.open_libraries(sol::lib::base);
	lua.set("shiphurt", sol::c_call<decltype(&ship::hurt), &ship::hurt>);
```
)

Finalmente, antes de ejecutar la prueba, se creará una instancia de ship con 2000000 de vida y se pasará a Lua. Además, se creará una función en la tabla global y la guardaremos en C++ en un std:function.

#code(
  lang: "C++",
```cpp
ship s;
s.life = 2000000;

lua.set("ship", &s);

const auto& code = R"(
	_G.testfunc = function(amount) shiphurt(ship, amount)  end
)";

lua.script(code); // Ejecutar el código de Lua

sol::function func = lua["testfunc"]; // Guardar la función de lua en C++
```)

Finalmente, se ejecutará la función de Lua 10000*10000 veces.

#code(
  lang: "C++",
```cpp
auto start = std::chrono::high_resolution_clock::now();

const int size = 10000;
const int amount = 20;

sol::function func = lua["testfunc"];
for (int i = 0; i < size * size; i++)
{
	func(amount);
}

std::cout << "ship life is: " << s.life << std::endl;

auto end = std::chrono::high_resolution_clock::now();
auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start);

std::cout << "Time taken: " << duration.count() << " miliseconds" << std::endl;
```)

El output obtenido:

```
ship life is: -1998000000
Time taken: 4959 miliseconds
```

En C++ la configuración es similar, pero se usa Dylib @Dylibcpp para cargar la librería dinámica y obtener la función.

#code(
  lang: "C++",
```cpp
	dylib lib("CDll", dylib::extension);
	auto func = lib.get_function<bool(ship&, int)>("testfunc");
	
  [...]

	for (int i = 0; i < size * size; i++)
	{
		func(s, amount);
	}
```)

El output obtenido:

```
ship life is: -1998000000
Time taken: 167 miliseconds
```

#text(red)[Tengo otro test pero a la inversa, una sola llamada a lua o a la dll, y es lua/dll la que realiza un montón de iteraciones, esa prueba la hice para ver mejor el overhead, porque no es lo mismo llamar 100000000 a Lua que llamar una vez y que Lua haga 100000000 operaciones. Al fin y al cabo te ahorras 1000000 \* 3 modificaiones del stack (una para poner la función al top, otra para poner el parámetro y otra para el de retorno, que aunuqe no se use se pone en el stack). Y esto funciona así porque también hice este test sin usar Sol como librería, lo hice también usando lua a pelo modificando el stack, pero la diferencia era inexistente así que para el ejemplo usé Sol que es más legible.]

#text(red)[Este texto a continuación puede ser redundante, pero es como estoy enfocando el TFG ahora, una comparación entre implementar el sistema de partículas de Noita en CPU y GPU. ¿Quié tiene que ver el sistema de scripting en esto? Que Noita usa Lua pero como configurador para varitas y pequeños comportamientos (la simulación es en C++ y no se puede tocar hasta donde sé, pero creo que algú mod lo hace), por lo tanto este sistema debe ser tanto eficinete como modeable, en el TFG intentar´eexplicarlo mejor para que sea coherente porque es la única forma de enfocarlo que se me ocurre.]

Esto demuestra la diferencia que puede llegar a haber entre ambas aproximaciones a un sistema modular que aproveche la CPU. Como el objetivo es recrear el sistema de partículas de Noita explorando todas las posibilidades de la CPU, se implementarán los sistemas de extensión mediante librerías dinámicas y lenguajes de scripting. Tras esto, se valorán ambas opciones, comparándolas con su alternativa en GPU para así poder determinar cuál es la mejor opción para este caso en concreto.

#text(red)[Quizás pienses que he hablado poco de Lua, y es cierto, me estoy reservando el resto de destalles de Lua para la parte de implementación en CPU en Lua.]