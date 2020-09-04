![](C:\Users\druiz\repositorios\UM\asio-docs\hito_2\libreria_descubrimiento\images\logos_feder.png)

| Entregable     | Documentación de la librería de descubrimiento               |
| -------------- | ------------------------------------------------------------ |
| Fecha          | 25/05/2020                                                   |
| Proyecto       | [ASIO](https://www.um.es/web/hercules/proyectos/asio) (Arquitectura Semántica e Infraestructura Ontológica) en el marco de la iniciativa [Hércules](https://www.um.es/web/hercules/) para la Semántica de Datos de Investigación de Universidades que forma parte de [CRUE-TIC](http://www.crue.org/SitePages/ProyectoHercules.aspx) |
| Módulo         | Discovery                                                    |
| Tipo           | Documentación                                                |
| Objetivo       | Librería de descubrimiento para el proyecto Backend SGI (ASIO) |
| Estado         | Completada                                                   |
| Próximos pasos | Implementación                                               |
| Documentación  | [Implementación de librería de descubrimiento](https://github.com/HerculesCRUE/ib-discovery) |

# Librería de descubrimiento

## Objetivo y alcance

La librería de descubrimiento pretende abordar el análisis de requerimientos y posibles implementaciones del módulo de descubrimiento, descrito en el pliego.

El modulo debe implementar tres funcionalidades independientes, todas ellas se abordaran en profundidad en el presente documento:

* Reconciliación de entidades.
* Descubrimiento de enlaces.
* Detección de equivalencias.

## Requisitos

| Requisito                                                    | Descripción                                                  | Pag.  Pliego | Bloque  Funcional |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------ | ----------------- |
| **REQ 8.3** Descubrimiento                                   | Apartado 17.3 del pliego que describe los requisitos relativos al módulo de descubrimiento. | 71           | Descubrimiento    |
| **REQ 8.3.1** Reconciliación de entidades                    | Apartado 17.3.1 del pliego que describe los requisitos relativos a la reconciliación de entidades, dentro del módulo de descubrimiento. | 71           | Descubrimiento    |
| **REQ 8.3.1.1** Detección de entidades duplicadas en el triple store | La ingesta de datos, puede referenciar a instancias ya almacenadas en el triple store, por lo que este módulo tiene que tener la capacidad de detectar y evitar duplicados. | 71           | Descubrimiento    |
| **REQ 8.3.1.2** Detección de entidades duplicadas con umbral de confianza | Este módulo analizara los datos de origen y presentará al usuario entidades ya existentes en el triple store, que podrían tratarse de una misma entidad, con un umbral de confianza. | 71           | Descubrimiento    |
| **REQ 8.3.1.3** Umbral de confianza configurable             | El usuario configurará el umbral de confianza, buscando un equilibrio<br/>entre minimizar la intervención humana y minimizar las entidades duplicadas pero con URI diferente presentes en la Triple Store. | 71           | Descubrimiento    |
| **REQ 8.3.1.4** Detección de equivalencias entre instancias de otros Backend SGI | Este proceso también será aplicable a distintas instancias del Backend SGI, que puedan referenciar a una misma entidad, teniendo como objetivo, descubrir datos nuevos y complementar así los almacenados. | 71           | Descubrimiento    |
| **REQ 8.3.2** Descubrimiento de enlaces                      | Apartado 17.3.2 del pliego que describe los requisitos relativos a el descubrimiento de enlaces, dentro del módulo de descubrimiento. | 72           | Descubrimiento    |
| **REQ 8.3.2.1** Fuentes de descubrimiento de enlaces potenciales | Descubrir enlaces potenciales, dentro del propio Backend SGI, otros Backend SGI y/o otros datasets de la nube LOD. | 72           | Descubrimiento    |
| **REQ 8.3.2.2** Descubrimiento de enlaces                    | Descubrir enlaces entre entidades propias, y las fuentes mencionadas en el punto 8.3.2.1 | 72           | Descubrimiento    |
| **REQ 8.3.2.3** Lista de Datasets                            | Presentar lista de datasets de la nube LOD u otras infraestructuras que en principio podrían enlazar lo datos del Backend SGI. | 72           | Descubrimiento    |
| **REQ 8.3.2.4** Ejemplos concretos de enlaces                | Cada dataset propuesto incluira ejemplos concretos de posibles enlaces | 72           | Descubrimiento    |
| **REQ 8.3.2** Detección de equivalencias                     | Apartado 17.3.3 del pliego que describe los requisitos relativos a la detección de equivalencias, dentro del módulo de descubrimiento | 72           | Descubrimiento    |
| **REQ 8.3.2.1** Razonamiento automático                      | Uso del Razonamiento automático para buscar equivalencias semánticas entre entidades de diferentes Backend SGI | 72           | Descubrimiento    |
| **REQ 8.3.2.2** Adición de equivalencias al Triple Store     | Las equivalencias descubiertas se añadirán como axiomas/triples al Backend SGI en el que se esté trabajando, para que puedan ser explotadas en el futuro. | 72           | Descubrimiento    |

## Módulos

### Reconciliación de entidades

Este modulo, pretende evitar o detectar la creación de distintas URIs para un mismo recurso.

Existen distintos contextos, donde la resolución de este problema, puede ser de especial utilidad, por un lado al insertar una nueva entidad, dentro del sistema, es necesario determinar si esta entidad existe, y en ese caso proceder a la actualización de la entidad existente, en vez de la creación de una entidad nueva. En el contexto de las entidades presentes ya en el triple store, es conveniente realizar también un proceso periódico que evalué si existen duplicados, y en este caso realizar las acciones de fusión entre dichas entidades que puedan ser oportunas. Es deseable un alto grado de automatización en el proceso, pero sin embargo es un proceso sensible, y que podría generar errores. Este aspecto se describirá ampliamente en el apartado [Automatización en la reconciliación de entidades](#Automatización en la reconciliación de entidades).

Podemos entender que dos entidades son en realidad la misma entidad, cuando existe un alto grado de similitud entre los atributos de dicha entidad, por lo tanto, para establecer la similitud entre entidades, es  necesario, establecer previamente la similitud entre atributos.

##### Métricas de similitud para atributos

La similitud entre atributos, en principio, es dependiente del tipo de datos de dicho atributo (cadena de texto, número, booleano, Objeto, etc), es decir, evaluar el grado de similitud entre dos cadenas de caracteres, es un problema diferente a evaluar la similitud entre dos números.

Esto deriva en distintas implementaciones para el calculo de similitud, en función del tipo de datos al que pertenece cierto atributo, sobre el cual queremos determinar el grado de similitud.

###### Atributos de tipo String (cadena de texto)

Estos son el tipo de atributo más común, ya que cualquier otro atributo, puede convertirse en una cadena de texto, por ejemplo el numero 23, puede representarse también como la cadena de texto "23", o cualquier objeto, puede ser representado también como una cadena de texto, por ejemplo en formato JSON o XML.

Esto sin embargo no es recomendable, ya que esta conversión de tipos hace que se pierda la semántica del propio dato, es decir la diferencia entre las cadenas de texto "23" y "73", desde el punto de vista de cadenas de texto es mínima, ya que se ambas contienen el mismo juego de caracteres, (ya que en este caso solo cambia el orden de dichos caracteres), de forma que algoritmos que no sean sensibles al orden, podrían determinar que tienen un alto grado de similitud. Si embargo desde un punto de vista numérico, son valores muy diferentes.

También es probablemente la comparativa mas difícil de implementar, ya que podemos encontrar múltiples variaciones comunes para un mismo texto.

Existen distintos tipos de alteraciones comunes entre distintas cadenas de texto (en ocasiones pueden producirse las tres simultáneamente), que en realidad referencian al mismo concepto, por ejemplo:

* **Cambio de orden en los tokens**: Por ejemplo, un nombre, tal como: "Daniel Ruiz Santamaría", en ocasiones, es representado en distinto orden, por ejemplo: "Ruiz Santamaría Daniel".  Sin embargo el grado de similitud al comparar dichas cadenas de texto, debería de ser alto. 
* **Trucado de caracteres**: En ocasiones, un mismo dato, es representado truncando alguna de sus partes. Por ejemplo la representación de una dirección, podría encontrarse de forma común, de las siguientes formas: "Avenida de España" o "Avda. de España" o "A. de España". Como en el ejemplo anterior, seria deseable que el grado de similitud entre estas cadenas, fuese alto.
* **Cambio de caracteres**: También es frecuente encontrar errores ortográficos o de introducción del dato, en la evolución de los atributos de una entidad, por ejemplo, el nombre "Elena" es frecuente encontrarlo también escrito como "Helena" o "Ester" puede ser escrito frecuentemente como "Esther". También en este caso seria deseable que la métrica de similitud entre las dos cadenas de texto, fuese elevada.

Es conveniente tener en cuenta que las variaciones de texto enunciadas en el punto anterior pueden producirse de forma simultanea, por ejemplo la dirección "Calle Elena de Troya" podría representarse como "Helena de Troya C.", y también en este caso  desearíamos que la métrica para el calculo de el grado de similitud, fuese lo mas alta posible.

También es necesario, simplificar en la medida de lo posible la comparativa, para ello, se realizara una **normalización** de  la cadena de texto siempre antes de evaluar el grado de similitud, para ello:

* No se distinguirá entre mayúsculas y minúsculas: Es decir las cadenas, siempre serán comparadas, en minúsculas.
* Se eliminaran signos de puntuación: Acentos, comas, puntos....
* Se eliminaran espacios: antes del primer carácter y después del ultimo.

Existen multitud de algoritmos de similitud de cadenas de texto, pero hay que tener en cuenta los siguientes aspectos

* Cada algoritmo, esta diseñado para funcionar de una forma más eficiente con algún tipo de las alteraciones enunciadas anteriormente, por lo tanto no funciona de forma tan eficiente con el resto de alteraciones.
* Aunque las métricas de similitud de cada algoritmo, tienen el mismo rango [0,1], estas parecen seguir distribuciones distintas, siendo que:
  * Algunas tienen a una distribución lineal, es decir, se distribuyen uniformemente dentro del rango expuesto, es decir, pequeñas modificaciones en las cadenas de texto, suponen pequeñas alteraciones de la similitud.
  * Algunas tienden a una distribución exponencial, siendo que pequeñas modificaciones, suponen grandes cambios en las métricas.
  * Algunas tienden a distribuciones logarítmicas, es decir, pequeñas modificaciones suponen muy pequeños cambios en el valor de la métrica.

Para evaluar la bondad de los algoritmos, **se han generado conjuntos de datos sintéticos** de 1000 elementos, donde se compara una cadena generada de forma aleatoria original (sin sentido semántico, solo como concatenación de caracteres),  con cadenas que sufren las siguientes modificaciones:

* Cadenas iguales: Como grupo de control, donde el resultado de la métrica de similitud debería de tender a ser 1.

* Cadenas generadas a partir de otras cadenas:
  * Mezclado de palabras: Se generan secuencias de un numero aleatorio de palabras (entre 3 y 6), cambiando  el orden de las estas de forma aleatoria.
  * Cambio de caracteres: Se generan secuencias de un numero aleatorio de palabras (entre 3 y 6), con un numero aleatorio de caracteres (entre 6 y 12) , y se cambian aleatoriamente para cada palabra entre 2 y 1/2 del número de caracteres de la palabra.
  * Truncado de caracteres: Se generan secuencias de un numero aleatorio de palabras (entre 3 y 6), con un numero aleatorio de caracteres (entre 6 y 12) , y se cambian truncan aleatoriamente para cada palabra entre 1 y 1/2 del número de caracteres de la palabra. También aleatoriamente se trunca solo una palabra o en todas las palabras.
  * Todos los cambios: Se generan secuencias donde se aplican todas las modificaciones antes expuestas.
* Cadenas distintas: Como grupo de control, se crean cadenas totalmente aleatorias, donde una cadena no es generada en forma alguna a prtir de la otra cadena.

En cuanto a los resultados se han discretizado en los siguientes valores

* Malo: < 0.25
* Insuficiente: < 0.4
* Medio: < 0.6
* Alto: < 0.8
* Excelente: <= 1

Dada la heterogeneidad de los resultados de los distintos algoritmos, se han implementado los siguientes algoritmos, representados en la siguiente tabla, donde se presenta la precisión media para cada uno de los casos (cadenas iguales, mezcladas, truncadas, con cambios en caracteres, al aplicar todos los cambios de forma simultanea, o cuando las cadenas son distintas):

| Algoritmo                  | Descripción                                                  | Iguales   | Mezcladas | Cambios   | Truncado     | Todas     | Distintas |
| -------------------------- | ------------------------------------------------------------ | --------- | --------- | --------- | ------------ | --------- | --------- |
| Block Distance             | Mide la distancia entre bloques de texto de n caracteres     | Excelente | Excelente | Malo      | Insuficiente | Malo      | Excelente |
| Cosine Distance            | Mide la distancia coseno entre dos vectores de texto         | Excelente | Excelente | Malo      | Insuficiente | Malo      | Excelente |
| Dice Distance              | Determina la distancia entre dos muestras dividiendo el doble de los elementos coincidentes entre las dos muestras entre el numero total de elementos de las dos muestras | Excelente | Excelente | Malo      | Insuficiente | Malo      | Excelente |
| Euclidian Distance         | Se define como la distancia mas corta entre los vectores de los dos textos | Excelente | Excelente | Alto      | Alto         | Medio     | Medio     |
| Jaccard Generalizado       | Se obtiene al dividir la intersección de términos entre la unión de los mismos. | Excelente | Excelente | Malo      | Insuficiente | Malo      | Excelente |
| Jaccard                    | Se obtiene al dividir la intersección de términos entre la unión de los mismos. | Excelente | Excelente | Malo      | Insuficiente | Malo      | Excelente |
| Jaro Winkler               | Esta medida utiliza el número de caracteres que comparten ambas palabras, tomando en cuenta los caracteres que están en la misma posición y los que están transpuestos | Excelente | Excelente | Excelente | Excelente    | Excelente | Medio     |
| Levenshtein                | También conocido como distancia de edición. El resultado de este algoritmo dinámico es el número mínimo de operaciones requeridas para transformar una palabra en otra. | Excelente | Excelente | Alto      | Excelente    | Alto      | Excelente |
| Longest Common Subsequence | Se trata de encontrar una subsecuencia más larga que es común en un conjunto de secuencias (Aunque en la mayor parte solamente se toman dos secuencias) | Excelente | Excelente | Alto      | Excelente    | Excelente | Alto      |
| Longest Common SubString   | Igual que el anterior, pero no importa el orden.             | Excelente | Excelente | Medio     | Excelente    | Alto      | Excelente |
| Overlap Coefficients       | Medida de similitud que mide la superposición de dos conjuntos finitos, como el coeficiente de la intersección de ambos conjuntos, entre el numero mínimo de caracteres de ambas cadenas | Excelente | Excelente | Malo      | Insuficiente | Malo      | Excelente |
| Simon White                | Diseñado originalmente para encontrar secuencias de ADN, coincidentes entre dos muestras. | Excelente | Excelente | Malo      | Insuficiente | Malo      | Excelente |
| Smith Weterman Gotoh       | Este algoritmo, al igual que el de Needleman-Wunch, es para alinear secuencias, con la diferencia de que este algoritmo trata de encontrar el mejor segmento local de uno de los textos en el otro. | Excelente | Excelente | Medio     | Excelente    | Alto      | Excelente |
| Smith Weterman             | Este algoritmo, al igual que el de Needleman-Wunch, es para alinear secuencias, con la diferencia de que este algoritmo trata de encontrar el mejor segmento local de uno de los textos en el otro. | Excelente | Excelente | Alto      | Excelente    | Alto      | Excelente |



Como se puede apreciar en la tabla, los algoritmos que presentan en general mejores resultados (como por ejemplo el algoritmo de Jaro Winkler), tienden a tener problemas al identificar cadenas de caracteres totalmente distintas (en la cual una no deriva de la otra), es decir, pecan de optimistas.

Por otro lado los algoritmos que en general presentan peores resultados, tienden a separa eficientemente las cadenas derivadas, de las no derivadas.

Por otro lado, tal como se comento anteriormente, algunos algoritmos, identifican bien, por ejemplo los cambios de caracteres pero mal los truncados, o viceversa.

Esto hace conveniente la estrategia de evaluar cada cadena de texto con múltiples algoritmos, y desarrollo de un algoritmo de consenso,  para a partir de resultados parciales no demasiado precisos, aumentar la precisión.

**El algoritmo de consenso** implementado , intenta tener en cuenta de alguna forma todos los valores de métricas de similitud proporcionados por todos los algoritmos, pero a su vez, intenta dar mayor peso a los algoritmos optimistas, en caso de que mayoritariamente los algoritmos detecten algún grado de similitud, o a los algoritmos mas pesimistas, en caso de que no se detecte mayoritariamente ningún tipo de similitud. 

La implementación utiliza una lista ordenada, que ordenara las similitudes de mayor a menor en caso de que mayoritariamente (n/2 + 1) se detecte algún tipo de similitud (>= 0. 5), y de menor a mayor en caso contrario.

Para los valores ordenados en la lista, se aplicara siempre un peso de 1/3 del los pesos restantes por aplicar. En la primera iteración (0), el restante es 1, por lo que se aplicara un peso de 1x1/3 al primer elemento de la lista, y se actualizara el resto a 2/3 del resto anterior, es decir 1x2/3. El mismo algoritmo se repetirá hasta los 2 últimos elementos, donde se repartirá el peso sobrante de forma igual entre ambos.

De esta forma peso sumado para todos los elementos siempre sumara 1, por lo que el rango de la métrica ponderada resultante será la misma, es decir [0,1].

Una vez calculado el peso apara cada elemento se aplicara una media ponderada, sobre los elementos de la lista, aplicando dicho peso.

Básicamente una vez ordenada la lista, cada nueva métrica se ponderara de forma decreciente, es decir, tendrá menos peso que la métrica anterior. Esto tiende a acentuar las diferencias, cuando las cadenas de texto son diferentes    

| Iteración | Peso restante | Peso a aplicar = Peso restante * 1/3 |      |
| --------- | ------------- | ------------------------------------ | ---- |
| 0         | 1             |                                      |      |
| 1         | 0.6666        | 0.33333333                           |      |
| 2         | 0.44444444    | 0.22222222                           |      |
| 3         | 0.2962963     | 0.14814815                           |      |
| 4         | 0.19753086    | 0.09876543                           |      |
| 5         | 0.13168724    | 0.06584362                           |      |
| 6         | 0.0877915     | 0.04389575                           |      |
| 7         | 0.05852766    | 0.02926383                           |      |
| 8         | 0.03901844    | 0.01950922                           |      |
| 9         | 0.02601229    | 0.01300615                           |      |
| 10        | 0.01734153    | 0.00867076                           |      |
| 11        | 0.01156102    | 0.00578051                           |      |
| 12        | 0.00770735    | 0.00385367                           |      |
| 13        | 0.00385367    | 0.00385367                           |      |
| 14        | 0.00385367    | 0.00385367                           |      |

###### Atributos de tipo Numérico

Para calcular la similitud entre atributos de tipo numérico, interesa seguir una distribución exponencial inversa

![inverse exponetial](C:\Users\druiz\repositorios\UM\asio-docs\hito_2\libreria_descubrimiento\images\exp_inv.png)

En la grafica se puede apreciar que los mayores valores de la similitud, se producen cuando mas pequeña es la diferencia, y estos valores disminuyen rápidamente de forma exponencial cuando la diferencia crece, es decir, cuando dos números son iguales su similitud es 1.

También interesa relativizar las diferencias, es decir no es lo mismo una diferencia de 1 unidad en una comparativa entre valores bajos (por ejemplo entre 5 y 6), que la misma diferencia (1 unidad) entre números altos, por ejemplo entre 1.000.000 y 1.000.001, ya en el segundo caso, la diferencia relativa es menor. Para ello se aplicara la normalización numérica, que básicamente consiste en dividir ambos números, por el mayor de ellos en valor absoluto.

Además es interesante discretizar las similitudes, ya que una similitudes del 0.99999, aunque numéricamente esta cercana a 1, el uno indica que ambos números son iguales y sin embargo el valor 0.99999,  indica que existe cierta diferencia por cercana que esta sea.

En temimos generales para calcular la similitud entre dos números se aplica la siguiente formula:
$$
similitud = ({1\over 2})^{nMax-nMin}
$$
Donde nMax es el máximo normalizado, es decir el redondeo floor(max/max), es decir 1 y nMin es el mínimo normalizado según la formula floor(min/max), que podrá tomar los siguientes valores discretos [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9 y 1]. Para valores iguales, la similitd sera siempre 1, en otro caso la similitud oscilara en el rango [0,0.5].

###### Atributos de tipo Booleano

Esta similitud es la mas sencilla de implementar, y es en realidad una operación XAND, es decir tiene una similitud 1 cuando ambos atributos son iguales (caso de true y true o false y false), y 0 cuando son distintos (caso de true y false o false y true).

**Atributos de tipo objeto**

Para los atributos de tipo objeto, se pueden aplicar las métricas descritas en la sección [Métricas de similitud en comparación de entidades](#Métricas de similitud en comparación de entidades) descrita en el siguiente punto. En caso de existir objetos anidados, se aplicara lo descrito recursivamente.

##### Métricas de similitud en comparación de entidades

Las métricas de similitud para entidades no son mas que la aplicación de similitud para todos los atributos.

Para ello se seguirá el siguiente algoritmo:

1. Se generara una lista de atributos únicos presentes en la entidad A o en la entidad B
2. Para cada atributo, se obtendrá el tipo, y se calculara la métrica dependiente del tipo, descrita en el punto anterior  ([Métricas de similitud para atributos](#Métricas de similitud para atributos)). 
   1. En caso de no coincidir los tipos, se realizara siempre la comparación en forma de String, ya que este es el tipo mas general posible.
   2. En caso de ser un objeto, se aplicara el algoritmo para la comparación de entidades aquí descrito recursivamente.
3. Se ponderara la métrica obtenida, haciendo simplemente la media aritmética, de forma que el resultado de similitud, siempre estará en el rango [0,1]

##### Integración del proceso dentro de la arquitectura general de la aplicación.

En el siguiente esquema se pueden apreciar a grandes rasgos los bloques funcionales de la librería de descubrimiento, y su integración con el resto de la arquitectura del proyecto ASIO.

![architecture](C:\Users\druiz\repositorios\UM\asio-docs\hito_2\libreria_descubrimiento\images\Reconciliacion de entidades.png)

La solución propuesta, será implementada como una tarea programada. Esta tarea esta compuesta por los siguientes bloques funcionales:

* Pertenecientes a la librería de descubrimiento:
  * **Data Fetcher:** Servicio actúa como un conector para recuperar las tripletas almacenadas en los distintos triples stores. El servicio tiene que tener la capacidad de recuperar los deltas, a partir de un cierto instante de tiempo. Para la entidades recuperadas, se evaluara su similitud con respecto a las entidades de el mismo tipo almacenadas en el triple store, por lo tanto este modulo también tiene que tener la capacidad de recuperar dichas entidades.
  * **Entity comparator:** El servicio implementa la comparación de entidades tal como se indica en [Métricas de similitud en comparación de entidades](#Métricas de similitud en comparación de entidades).
  * **Merge handler:** El servicio evalúa el grado de similitud entre entidades. Si la similitud supera el umbral definido para la fusión automática de entidades, se enviara de forma asíncrona (mensaje en cola kafka), una solitud de mergeo, que será procesada por el servicio Merge Event Processor, de la arquitectura ASIO. En caso de no superar el umbral de mergeo automático, si la similitud es significativa, pero requiere validación (umbral para validación manual), se almacena la similitud, en un registro destinado para tal fin, de forma que en algún momento posterior, un usuario, pueda determinar si realmente se trata de la misma entidad (en ese caso se enviara una solicitud de fusión, tal y como se comenta en el punto anterior), o se desecha la operación de fusión (en ese caso quedara almacenado en la base de datos, dicha decisión con el fin de no volver a solicitar la fusión).  En cuanto al objeto resultante de la fusión, se usarán siempre los datos más actuales de los atributos que se encuentren en ambas entidades, en caso de que algún atributo este presente solo en alguna entidad, se conservara dicho atributo, con el valor de la entidad donde esta presente. El mensaje determinara siempre, la entidad que debe ser actualiza, los atributos y los valores a actulizar y la entidad que debe de ser eliminada.
* Pertenecientes a la arquitectura ASIO
  * **Merge event Processor:** Es el proceso encargado de realizar las operaciones de fusión de entidades (principalmente actualizaciones y borrados), requeridas por el servicio Merge handler o aquellas generadas manualmente por un usuario experto.

##### Automatización en la reconciliación de entidades

### Descubrimiento de enlaces

TODO

### Detección de equivalencias

TODO