# Diseño de Benchmark

## Requisitos

### Requisito: 16.1 Crear Benchmark para evaluar Triples Stores. 

> El adjudicatario creará un Benchmark para evaluar las Triple Stores candidatas y así facilitar a los técnicos de la UM la elección de la Triple Store adecuada. El Benchmark consistirá en una serie de criterios con un peso específico, y el resultado será una media ponderada de la puntuación obtenida en cada criterio. El adjudicatario creará el Benchmark y proveerá un primer resultado proponiendo un ranking de Triple Stores, pero los criterios, pesos específicos y las puntuaciones dadas a cada Triple Store podrán ser modificadas por la UM y el Benchmark ejecutado de nuevo.

### Requisito: 16.2 Crear Memoria Científico Técnica

> - Tipo de licenciamiento del software. 
> - Acceso programático mediante Eclipse RDF4J144142. 
> - Acceso programático mediante otros métodos (Por ejemplo API REST). 
> - Dependencias (Por ejemplo muchas Triple Stores dependen de Java). 
> - Rendimiento. En este apartado el adjudicatario ejecutará un Benchmark específico orientado a evaluar el rendimiento, como pueden ser [SP2B](http://dbis.informatik.uni-freiburg.de/forschung/projekte/SP2B/), [LUBM](http://swat.cse.lehigh.edu/projects/lubm/), [BSBM](http://wifo5-03.informatik.uni-mannheim.de/bizer/berlinsparqlbenchmark/), [DBPSB](http://aksw.org/Projects/DBPSB.html), o los incluidos en el proyecto [HOBBIT](https://project-hobbit.eu/). Adicionalmente, los Datasets de Referencia Hércules (Ver Sección Dinámica de Desarrollo) también se usarán para medir el rendimiento de las Triple Stores
> - Clustering y alta disponibilidad.
> - Transacciones. 
> - Documentación adecuada. 
> - Facilidad de uso y administración. 
> - Existencia de una comunidad amplia de usuarios, incluyendo usos en producción. 
> - Cumplimiento de estándares W3C: 
>   - Linked Data Platform. 
>   - Todas las recomendaciones que forman SPARQL 1.1. 
> -  Capacidad de razonamiento automático sobre datos RDF. 
> - Soporte de SHACL u otras funcionalidades de tipo Closed World Assumption para analizar RDF.
> - Búsquedas por texto con servicios como Apache SOLR y Apache Lucene. 
> - Funciones de reconciliación de entidades como NER (Named Entity Recognition). 
> - Funciones para datos de tipo Property Graph (Por ejemplo implementando [Apache Tinkerpop](http://tinkerpop.apache.org/)). 
> - Funciones de ingesta de datos no-RDF. Entre otros: JSON, CSV, XML, conexión a BBDD relacionales mediante [grafos virtuales](https://www.stardog.com/blog/stardog--mongodb/), textos.

### Análisis de requisitos

En principio, en los requerimientos podemos encontrar métricas a priori automatizables como por ejemplo las relativas al rendimiento, ya sea en operaciones de lectura o escritura, o casos de uso de conjuntas mas complejas sobre un determinado conjunto de datos y otras de mas difícil automatización, y que probablemente puedan ser de igual o mayor importancia para el proyecto, tales como el tipo de licencia, las relativas a resiliencia, etc.



## Benchmarks de referencia

Todos los Benchmarks desarrollados tienen interactúan en su evaluación del Triple Store.

En principio tratan de medir aspectos tales como:

- Estrategias de optimización.
- Estimación de generalidad.
- Escenarios del mundo real.



### SP2B

Benchmark para estimar optimación, generalidad y beneficios en el mundo real realizado por la Universidad de Friburgo. Genera un conjunto de datos, con documentos arbitrariamente grandes con el formato de la biblioteca [DBLP](https://dblp.uni-trier.de/) (Base de datos en formato triple store sobre ciencias de la computación), y realiza consultas sobre ellos para medir el rendimiento.

El generador de datos usa como modelo la base de datos [DBLP](https://dblp.uni-trier.de/), ya que tiene muchas características de los datos en el mundo real, como por ejemplo el carácter social,  e imita las correlaciones que existen en ella sobre entidades, tales como artículos, autores...., para crear los datos se analizan las frecuencias e interacciones de las entidades,  de forma que el resultado es los mas fiel posible.

El proyecto consta de:

- Generador de datos (escrito en C), imitando los datos de la librería DBLP ([código fuente](http://dbis.informatik.uni-freiburg.de/index.php?project=SP2B/download.php)).
- 17 consultas sobre los datos de referencia, variando operadores, patrones de acceso a datos, complejidad, tamaño de respuestas... ([queries SPARQL](http://dbis.informatik.uni-freiburg.de/index.php?project=SP2B/queries.php))
- Resultados en distintos Triple Stores y propuesta de métricas ([memoria técnica](https://arxiv.org/pdf/0806.4627.pdf)).

El proyecto parece lo suficientemente maduro para tomarlo como modelo, y realizar nosotros nuestro propio Benchmark. 

| PROS                                                         | CONTRAS                                                      |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Muy enfocado en generación de datos de acuerdo al modelo, por lo que las métricas tambien estaran ajustadas al modelo | Escrito en C                                                 |
| Documentación de todas las fases (generación de datos, queries SPARQL y memoria) | Para adaptarlo a  conjunto de datos se la UM, habría que generar datos ajustando las frecuencias de las entidades |
| Benchmark a priori bastante genérico, maduro y bien documentado | Orientado e lectura, sin métricas para escritura             |
|                                                              | No simula acceso concurrente                                 |

### LUBM

Benchmark para facilitar la evaluación de los repositorios de la Web Semántica, de manera estándar y sistemática, mediante consultas sobre un gran conjunto de datos, desarrollado por la Universidad de Lehigh. Genera un conjunto de datos sintéticos, personalizables y repetibles sobre el dominio del ámbito universitario.

El proyecto consta de:

- Ontología: Se usa la ontología Univ-Bench.

- Generador de datos (UBA), escrito en JAVA,siguiendo la ontología Univ-Bench ([código fuente](http://swat.cse.lehigh.edu/projects/lubm/uba1.7.zip)).
- 14 consultas sobre los datos de referencia, variando operadores, patrones de acceso a datos, complejidad, tamaño de respuestas... ([queries SPARQL](http://swat.cse.lehigh.edu/projects/lubm/queries-sparql.txt))
- TEST (UBT): Modulo de test sobre la carga de datos, queries SPARQL, 
- Resultados en distintos Triple Stores y propuesta de métricas ([memoria técnica](http://swat.cse.lehigh.edu/pubs/guo03a.pdf)).

El proyecto se usa como referencia en otros Benchmarks por ejemplo SP2B, aunque según la SP2B, LUBN no es adecuado para un Benchmark general, ya que fue diseñado principalmente para evaluar el razonamiento y mecanismos de inferencia y no cubre operadores OPTIONAL y UNION y a priori esta orientado a el razonamiento.

| PROS                                                         | CONTRAS                                          |
| ------------------------------------------------------------ | ------------------------------------------------ |
| Documentación de todas las fases (generación de datos, queries SPARQL y memoria) | Queries enfocadas a inferencia                   |
| Benchmark a priori bastante genérico, maduro y bien documentado | No soporta operadores OPTION y UNION             |
|                                                              | Orientado e lectura, sin métricas para escritura |
|                                                              | No simula acceso concurrente                     |

### BSBM

Benchmark para facilitar la evaluación de los repositorios de la Web Semántica, siempre que expongan EndPoint SPARQL, ya sean bases de datos relacionales o triples stores. El modelo de datos se basa en comercio electrónico donde tenemos entidades para productos, proveedores y clientes, que publican comentarios sobre los productos. El patrón de consultas, cubre casos de uso de un cliente que busca un determinado producto.

El proyecto consta de:

- Generador de datos , escrito en JAVA (http://wifo5-03.informatik.uni-mannheim.de/bizer/berlinsparqlbenchmark/spec/BenchmarkRules/index.html#datagenerator).
- Queries para tres casos de uso:
  - **Caso de uso de exploración:** 12 Queries de solo lectura.
  - **Caso de uso de exploración y actualización:** Incorpora a el caso de uso de exploración, queries de actualización.
  - **Caso de uso de Business Intelligence:** Consultas mas complejas orientadas a Business Intelligence (8 queries), que incluyen agrupados, y queries de actualización.
- TEST: Modulo de test sobre la carga de datos, queries SPARQL, 
- Resultados en distintos Triple Stores y propuesta de métricas ([memoria técnica1, memoria técnica2](http://wifo5-03.informatik.uni-mannheim.de/bizer/pub/BizerSchulz-BerlinSPARQLBenchmark.pdf)).

El proyecto parece muy completo, ya que por un lado realiza análisis sobre bases de datos relacionales y triples stores, y por otro, cubre operaciones tanto de lectura simple, como de lectura compleja (Business Intelligence), como de actualización, simulando además concurrencia. En líneas generales cubre muchos escenarios, aunque el modelo de datos que usa sea quizás el menos académico.

| PROS                                                         | CONTRAS                           |
| ------------------------------------------------------------ | --------------------------------- |
| Documentación de todas las fases (generación de datos, queries SPARQL y memoria) | Dominio poco parecido al de la UM |
| Benchmark a priori bastante genérico, maduro y bien documentado | Documentación algo mas dispersa   |
| Simula acceso concurrente                                    |                                   |

### DBPSB

Benchmark usa la Base de Datos de conocimiento de la Wikipedia para realizar consultas sobre registros, agrupamiento. La aportación es de DBPSB, es que realiza las consultas contra datos reales.

El proyecto consta de:

- Generador de datos: realiza importación de datos reales de Wikipedia (**los enlaces no funcionan**) a un triple store, permite:
  - Establecer el tamaño de los datos
  - Establecer el tipo de selección sobre los datos (RandomInstance o RandomTriple)
  - Establecer el fichero de salida
  - Establecer dirección de EndPoint SPARQL para insertar datos.
  - Realizar importación.
- Consultas: Permite definir Queries que se ejecutaran.
- Scripts específicos para cargar datos en Virtuoso, TDB, Sesame ... 

El proyecto esta muy orientado a extraer los datos de Wikibase, no estoy seguro hasta que punto , su modelo de datos es generalizable, y por lo tanto es el mejor para realizar metricas

| PROS                     | CONTRAS                                                      |
| ------------------------ | ------------------------------------------------------------ |
| Conjunto de datos reales | Modelo de datos de Wikibase, probablemente no es el más generalizable |
|                          | Documentación escasa                                         |
|                          | Scripts específicos para importaciones especificas, lo que a priori limita el numero de Triple Stores a evaluar |



### HOBBIT

Hobbit pretende poner en contacto empresas que deseen implementar una solución de almacenamiento de linked data con proveedores de servicios de almacenamiento en triple store de forma que el propio cliente facilite el conjunto de datos y los KPIs relevantes de forma que Hobbit pueda abrir convocatorias abiertas a la participación, y de esa forma los propios proveedores den respuesta a las inquietudes del cliente.

| PROS              | CONTRAS                                                      |
| ----------------- | ------------------------------------------------------------ |
| Menor complejidad | Sin control en los Benchmark, cada cambio en los mismos, supondrá una nueva convocatoria |
|                   | Plazos muy dilatados                                         |
|                   | Creo que no es lo esperado en el pliego                      |



## Conclusiones

Todos (o casi todos) los Benchmark evaluados, siguen de una forma u otra los siguientes pasos:

### Generador de datos

 Este punto es critico, y por lo tanto va a condicionar los dos siguientes. 

Por otro lado, creo que la mayoría del tiempo invertido en la implementación de Benchmarks (si se implementase), podría terminar invirtiéndose en la generación de datos para evaluar.

Se pueden realizar varias estrategias:

- Usar datos lo mas **no propios del proyecto Hércules** de la forma más genérica posible: De esta forma, será sencillo obtener un volumen suficiente para evaluar los datos, simplemente usando los dataset SP2B, LUBN o BSBM y por lo tanto el tiempo de desarrollo del Benchmark se reduciría bastante, es decir, no habría que destinar tiempo a generar datos, ni a construir las queries para medir el rendimiento, por lo tanto solo habría que dedicar tiempo a los conectores con el EndPoint SPARQL, que como es genérico, pues  a priori no supondría un gran esfuerzo.
- Usar datos **propios del proyecto Hércules:** Esto añade bastante complejidad ya que por una parte habría que modelar el dominio Hércules (del cual aun no tenemos una Ontología completa), y por otra generar datos sintéticos suficientes para generar la volumetría necesaria para que el comportamiento del Triple Store pueda verse afectado. Además probablemente habría que estudiar la frecuencia de entidades y relaciones para que los datos sintéticos generados, sigan una frecuencia similar.

### Consultas EndPoint SPARQL

Como se comenta en el punto anterior, las consultas dependerán en gran medida del modelo que sigan el conjunto de datos escogidos, por lo que la decisión de usar datos Hércules o no, condicionara mucho las consuntas. Por otro lado es oportuno decidir la política que seguirán dichas consultas teniendo en cuenta los siguientes aspectos:

- Que operadores se evalúan.
- Que tipo de consultas se realizan
  - Lectura
  - Actualización
- Complejidad de las consultas
- Concurrencia de las consultas

### Resultados

Como resultado de las consultas SPARQL sobre los distintos sistemas de almacenamiento se obtendrán idealmente métricas relativas a:

- **Tiempo:** Tiempo necesario para resolver una distinta consulta, con distintos volúmenes de datos, y distintos niveles de concurrencia por sistema de almacenamiento.

- **Integridad:** 
  - Número de respuestas obtenidas
  - Integridad de respuestas obtenidas

### Conclusiones Generales

Después de examinar todos los Benchmarks de referencia indicados en el pliego, se recomienda seguir el patrón Benchmark BSBM, creo que es el mas completo de todos, ya que recoge aspectos como la concurrencia, y distintos niveles de consultas para distintos casos de uso.

Por otro lado, en lo relativo a tiempos de desarrollo, hacer uso de el generador de datos, de BSBM, para datos de comercio electrónico, agilizaría mucho de cara a la entrega de Benchmark para el Hito 1, y además en este momento, no existe una Ontología completa y madura para generar un conjunto completo de datos sintéticos, de cara al Hito 2, tal como indica el pliego (han de incorporarse en algún momento datos relevantes del proyecto Hércules), podríamos crear un generador de datos sintéticos para  datos propios del proyecto Hércules, y hacer un conjunto de queries con casos de uso relevantes para ellos.

## Referencias

- SP2B, [Albert-Ludwigs-Universität Freiburg](http://www.uni-freiburg.de/), Databases and Information Systems

  http://dbis.informatik.uni-freiburg.de/forschung/projekte/SP2B/

- LUBM, [Jeff Heflin](mailto:jeh3@lehigh.edu), SWAT Projects - the Lehigh University Benchmark (LUBM)s

  http://swat.cse.lehigh.edu/projects/lubm/

- BSBM, Christian Bizer, Andreas Schultz, Berlin SPARQL Benchmark (BSBM)

  http://wifo5-03.informatik.uni-mannheim.de/bizer/berlinsparqlbenchmark/

- HOBBIT

  https://project-hobbit.eu/