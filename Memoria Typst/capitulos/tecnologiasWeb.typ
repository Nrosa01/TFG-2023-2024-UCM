Existe una gran diversidad de tecnologías webss para desarrollar y alojar sitios webs. En este capítulo se verán tecnologías específicas relacionadas al desarrollo de sitios web.

Para poder crear una web, es necesario conocer su funcionamiento. Una página web se compone de 3 elementos principales: HTML, CSS Y código JavaScript @baxley-2002. Mediante HTML se define la estructura de la página y sus contenidos. CSS es un lenguaje de estilos que permite definir la apariencia de la web. Por último, JavaScript es un lenguaje de programación que permite añadir interactividad a la web.

Aunque existen diferentes herramientas para crear webs, frameworks y librerías, al final los archivos que generan son estos 3 mencionados.

== Frameworks de desarrollo

Para diseñar un sitio web lo ideal es primero maquetar y conceptualizar. Existen herramientas especializadas para esto como Figma @staiano-2023 u otras más generales como Canva @k-2020. Este proceso es importante, pues ponerse a programar sin una idea clara puede dar lugar a problemas durante el desarrollo. Posteriormente a este proceso se debe pensar en el diseño de la web para finalmente, poder implementarlo en código.

Los sitios webs a menudo presentan contenido interactivo que provoca que la página cambie de acorde a las acciones del usuario. Por ejemplo, un botón contador, cada vez que el usuario clicke este botón, cambiará un texto en la web que indica cuantas veces se ha pulsado. Tradicionalmente esto implica usar JavaScript para definir la función a ejecutar cuando el usuario pulsa el botón y actualizar el texto de la web manualmente.

Sin embargo, este proceso tan manual es tedioso y su coste de implementación aumenta con la complejidad de la web. Por ejemplo, tener una lista de objetos que representar y poder reordenar. Tener que manipular los elementos de la web para sincronizar la vista con los datos resulta complejo.

Para solucionar este y otros problemas, se han creado frameworks de desarrollo web. Existen muchos frameworks, pero los más populares son React, Angular y Vue. Cada uno de estos tiene sus particularidades, pero existen ciertos conceptos comunes entre ellos. El más importantes es la `reactividad` @macrae-2018.

Cada framework implementa reactividad de un modo ligeramente diferente, pero el concepto es el mismo, usar variables JavaScript en el código HTML. El framework se encarga de detectar los cambios en estas variables y actualizar la vista automáticamente. Por ejemplo, si se tiene una lista de objetos y se añade un nuevo objeto a la lista, el framework se encargará de añadir un nuevo elemento a la vista.

A pesar de que los framework de desarrollo aportan muchas ventajas, tienen también inconvenientes. El primero es que la mayoría requiere de un `bundler` @macrae-2018, esto es un programa que se encarga de unir todos los archivos de la web en uno solo. Esto puede ser un problema si se quiere hacer una web sencilla, pues añade complejidad innecesaria. Los bundler requieren archivos de configuración y un proceso de `build` para poder generar la web. Otro problema que puede surgir es el rendimiento, esto se da en mayor o menor medida en todos los frameworks, esto se debe a que los frameworks añaden una capa de abstracción que puede ralentizar la web. Al no tener tanto control sobre como se actualiza la vista, el framework puede hacer más operaciones de las necesarias.

== Hosting y CI

Una vez que se tiene la web, es necesario alojarla en un servidor para que pueda ser accesible desde cualquier parte del mundo. Existen muchos servicios de hosting, pero los más populares son Netlify y Vercel. Sin embargo, estos servicios son de pago.

Para poder alojar webs de forma gratuita, la opción más popular es GitHub Pages. GitHub Pages es un servicio de GitHub que permite alojar webs estáticas de forma gratuita. Para poder alojar una web en GitHub Pages @uzayr-2022, es necesario subir los archivos de la web a un repositorio de GitHub y activar GitHub Pages en la configuración del repositorio.

Como se vio antes, usar un framework suele implicar un proceso de build para poder generar la página final. Tener que hacer una build cada vez que se quiera subir una página a GitHub Pages u otro servicio resulta molesto. Para solucionar este problema, existen soluciones de integración continua (CI) específicas para webs. Los más populares son GitHub Actions y Netlify CI. Estos servicios permiten automatizar el proceso de build y subida de la web a GitHub Pages.

En el caso de GitHub, GitHub Actions permite definir la acción de compilación que se ejecutará en los servidores de GitHub y se desplegará en GitHub Pages. Este proceso puede configurarse para que se realize automáticamente en cada subida de código (push) al respositorio. De esta forma, los desarrolladores no tienen que preocuparse de hacer la build manualmente.
