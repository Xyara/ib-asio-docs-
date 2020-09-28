![](./images/logos_feder.png)

# Análisis sobre uso de Wikibase vs Trellis + Fuseki en proyecto ASIO

- Status: Propuesta
- Date: 2020-03-26

Historia Técnica: Análisis sobre el encaje de Wikibase en la solución ASIO, problemas derivados, y planteamiento de soluciones alternativas.

## Contexto y planteamiento del problema

Hemos podido comprobar en las fases iniciales del proyecto, que el uso de Wikibase, gracias a el conjunto de herramientas de libre uso que ofrece (especialmente aquellas relativas a la interface de usuario), ha supuesto un rápido avance en el proyecto. Wikibase es una solución completa ya que aporta muchos de los componentes necesarios para el proyecto, tales como una API contra la cual es posible interactuar, soporte para el almacenamiento (Triple Store y Base de datos relacional), y especialmente una robusta interface de usuario, que sin duda aporta gran funcionalidad, y permite a los usuarios, visualizar los datos de una forma bastante amigable, y por lo tanto hacer más transparente el avance del proyecto.

Por otro lado, evaluando la herramienta, desde el punto de vista de los requisitos del proyecto ASIO (expresados en el pliego), Wikibase (o el uso de toda la funcionalidad de la herramienta, tal cual fue diseñada) a priori, como se detallara en este mismo documento, platea algunas dudas, probablemente derivadas de su función principal, que no es otra que dar soporte a Wikidata. Se profundizara en ello durante el presente documento.

## Drivers de decisión

- Cumplimiento de las especificaciones del proyecto ASIO, planteadas en el pliego.
- Flexibilidad, y reducción de deuda técnica. 
- Cumplimiento de plazos de entrega

## Opciones consideradas

- Wikibase
- Trellis + Fuseki
- Wikibase (uso por administradores) - Trellis + Fuseki (uso general)

## Requisitos afectados por la decisión presentes en el del pliego

La requisitos enumerados a continuación, podrían sufrir algún tipo de impacto según la decisión arquitectónica elegida. Para facilitar la comprensión de el documento se añade la columna **Bloque Funcional **, que ayudara a determinar el impacto en dicho/s boques funcionales enumerados en el documento



| Requisito                                                    | Descripción                                                  | Pag.  Pliego | Bloque  Funcional                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------ | ----------------------------------------- |
| **REQ 5.1.8** Gestión de  dataset                            | Permisos,   carga masiva, borrado, metadatos, etc. De este requisito se infiere la   necesidad proporcionar permisos de acceso a datos, de manera granular, y por   lo el cumplimiento del requisito de [Autorización y autentificación](#RANGE!Autentificación y autorización) | 65           | Seguridad                                 |
| **REQ 5.1.9** Gestión de  usuarios, permisos y acceso de datos | Gestión de usuarios,  permisos y acceso de datos.            | 65           | Seguridad                                 |
| **REQ 5.2.1** SPARQL endpoint                                | Para que humanos y máquinas exploten la información almacenada. REQ 10.2 | 66           | Seguridad                                 |
| **REQ 7** Almacenamiento en  Triple Store                    |                                                              | 67           | Triple Store                              |
| **REQ 7.1** Conexión con el  Triple Store                    | El adjudicatario creará el código necesario  para la conexión del Backend SGI con la Triple Store, siempre teniendo en  cuenta que el Backend SGI tiene que ser lo más  independiente posible de la Triple Store de modo  que si otra Universidad decide usar otra Triple Store, puede hacerlo con la  menor fricción posible. | 67           | Triple Store                              |
| **REQ 7.2** Benchmark para  evaluar Triple Store candidatas  | El adjudicatario creará un Benchmark para evaluar las Triple Stores candidatas  y así facilitar a los técnicos de la UM la elección  de la Triple Store adecuada. El Benchmark  consistirá en una serie de criterios con un peso específico, y el resultado  será una media ponderada de la puntuación obtenida en cada criterio. El  adjudicatario creará el Benchmark y proveerá un primer resultado proponiendo  un ranking de Triple Stores, pero los criterios, pesos específicos y las puntuaciones  dadas a cada Triple Store podrán ser modificadas por la UM y el Benchmark  ejecutado de nuevo. | 67           | Triple Store                              |
| **REQ 7.3** Memoria  Científico-Técnica sobre la elección del Triple Store | La empresa deberá especificar los siguientes  extremos en la Memoria Científico-Técnica: Licencia, Acceso programático  mediante Eclipse RDF4J, API REST, Dependencias, Rendimiento, Clustering y  alta disponibilidad, Transacciones, Documentación adecuada, Facilidad de uso  y administración, Existencia de una comunidad amplia de usuarios,  Cumplimiento de estándares W3C (LDP, SPARQL 1.1), razonamiento automático,  Soporte de SHACL u otras funcionalidades de tipo Closed World Assumption para  analizar RDF, Búsquedas por texto con servicios como Apache SOLR y Apache  Lucene, Funciones de reconciliación de entidades como NER, Funciones para  datos de tipo Property Graph, Funciones de ingesta de datos no-RDF | 67           | Triple Store                              |
| **REQ 7.4** Benchmark  específico para evaluar rendimiento del Triple Store | En este apartado el adjudicatario ejecutará un  Benchmark específico orientado a evaluar el rendimiento, como pueden ser SP2B, LUBM, BSBM, DBPSB, o los incluidos en el  proyecto HOBBIT.  Adicionalmente, los Datasets de Referencia Hércules (Ver Sección Dinámica de  Desarrollo) también se usarán para medir el rendimiento de las Triple Stores | 67           | Triple Store                              |
| **REQ 7.5** Asesoramiento en  la instalación de un clúster HA | Para asegurar un up-time del 99%-100%.                       | 67           | Triple Store                              |
| **REQ 7.6** Método para  limitar el volumen de datos:        | Que sirve la Triple Store evitando peticiones  masivas que dejen inactivo el sistema. | 67           | Triple Store                              |
| **REQ 7.7** Estudio de  soluciones sobre escalabilidad y eficiencia en consultas | Estudio en profundidad de las soluciones que  se barajan a este problema en la literatura científica actual. | 67           | Triple Store                              |
| **REQ 7.8** Implementación de  sistema para consultas federadas | Una vez consensuada la estrategia con UM.                    | 67           | Triple Store                              |
| **REQ 8.2** Validación                                       |                                                              | 70           |                                           |
| **REQ 8.2.1** Cumplimiento de  buenas prácticas Linked Data: | Buenas prácticas Linked Data (Heath 2011 ,  Dodds 2012). Por ejemplo, que todas las entidades tengan predicados rdf:type  y rdfs:label, predicados rdfs:isDefinedBy, que no haya nodos anónimos, etc.. | 70           | API Linked Data                           |
| **REQ 9** Gestión de datos                                   |                                                              |              |                                           |
| **REQ 9.1.8** Sistema de  permisos de acceso al Triple Store | Esto implica que el gestor es el encargado de  comunicarse con la Triple Store, y por lo tanto debe incluir un sistema de permisos con diferentes niveles de  acceso a los datos. | 72,73        | Seguridad / API Linked Data / Tripe Store |
| **REQ 9.2.1**  Cliente de la API Rest                        | Es un cliente de la API Rest                                 | 72,73        | API Linked Dat                            |
| **REQ 9.2.4** Panel ETL                                      | Panel de ejecución de pipelines  ETL.                        | 72,73        | API Linked Dat                            |
| **REQ 9.2.5** Usuarios, acceso  y seguridad                  | La interface Web, que a su vez es un cliente  de la API REST, presenta como mínimo, las siguientes funcionalidades | 72-73        | Seguridad / Interface Gráfica             |
| **REQ 10** Publicación de  datos                             |                                                              |              |                                           |
| **REQ 10.1** Servidor Linked  Data                           | Servidor Linked Data                                         | 74           | API Linked Data                           |
| **REQ 10.1.1** Resolución  directa de URIs                   | Obtener datos o metadatos almacenados en el  Triple Store. De sólo lectura. | 74           | API Linked Data                           |
| **REQ 10.1.10** Redirección de  peticiones HTTP del exterior | A los servicios correspondientes.                            | 74           | API Linked Data                           |
| **REQ 10.1.2** Respuesta a  peticiones HTTP GET:             | Devolviendo los datos del Triple Store.                      | 74           | API Linked Data                           |
| **REQ 10.1.3** Negociación de  contenido                     | Negociación de contenido con gran  granularidad: Por ejemplo será capaz de gestionar una petición con la  cabecera “Accept: text/rdf+n3;q=0.5”, es decir con un valor “q” para un  formato concreto. | 74-76        | API Linked Data                           |
| **REQ 10.1.4** Mapa relación  de URIs                        | Mapa configurable que relacione URIs públicas  con URIs internas. | 74           | API Linked Data                           |
| **REQ 10.1.5** Renderización  en HTML                        | Para aplicar estilos aunque tenga uno por  defecto.          | 74           | Interface Gráfica                         |
| **REQ 10.1.6** JSON-LD para  datos anotados mediante Schema  | Al renderizar los datos RDF en  HTML, si éstos incluyen datos anotados mediante Schema, se incluirán en la  página Web resultante mediante el uso de JSON-LD, facilitando así la  indexación estructurada por los buscadores que soportan Schema | 74-76        | API Linked Data                           |
| **REQ 10.1.7** Consulta SPARQL  configurable desde la interfaz | La consulta SPARQL que se ejecuta para obtener  los datos de la Triple Store (Normalmente “DESCRIBE <URI>”) ha de ser configurable. Por lo tanto, para el caso de  usuarios humanos (Renderización en HTML) cada consulta SPARQL ha de llevar un  apariencia HTML asociada. | 74-76        | EndPoint SPARQL / Interface Gráfica       |
| **REQ 10.1.8** HTTP Range 14                                 | Análisis sobre qué estrategia seguir de las  descritas en el Documento W3C Cool URIs for the Semantic Web, Hash URIs o  Slash URIs, y para qué recursos. Implementación de la misma. | 74           | API Linked Data                           |
| **REQ 10.1.9** Análisis de  cumplimiento LDP                 | Adopción de dicho estándar por parte de la  comunidad, utilidad, beneficios a largo plazo, y dificultad de  implementación, entre otros. | 74           | API Linked Data                           |
| **REQ 10.1.9** Análisis de  cumplimiento LDP                 | El adjudicatario creará un análisis sobre  hasta qué punto el Servidor Linked Data tiene que cumplir la recomendación  Linked Data Platform del W3C y para qué recursos, teniendo en cuenta la  adopción de dicho estándar por parte de la comunidad, utilidad, beneficios a  largo plazo, y dificultad de implementación, entre otros. La decisión que  tomen los técnicos de la UM basándose en ese análisis se verá reflejada en el  diseño e implementación del Servidor Linked Data. Este análisis también se  tendrá en cuenta en el Benchmark de Triple Stores, determinando el peso del  criterio Linked Data Platform del mismo. | 74-76        | API Linked Data                           |
| **REQ 10.2.1** Ejecución de  consultas SPARQL                | Obtener datos o metadatos almacenados en el  Triple Store. De sólo lectura. | 75           | EndPoint SPARQL                           |
| **REQ 10.2.2** Interfaz  gráfico                             | Basado en Wikidata para obtener datos o  metadatos almacenados en el Triple Store. De sólo lectura | 75           | EndPoint SPARQL / Interface Gráfica       |
| **REQ 10.2.3** Interfaz para  máquinas                       | Obtener datos o metadatos almacenados en el  Triple Store. De sólo lectura | 75           | EndPoint SPARQL / API Linked Data         |
| **REQ 10.4.3** Pruebas  cabeceras HTTP                       | Negociación de contenidos, LDP                               | 74-76        | API Linked Data                           |



## Soluciones propuestas

Leyenda de ajuste a requisitos:

**ALTA:** Ajuste óptimo a los requisitos del proyecto

**SUFICIETE:** Ajuste suficiente a los requisitos actuales del proyecto, pero creemos que no es la solución óptima (por criterios como perdida de flexibilidad, acoplamiento o deuda técnica...).

**BAJO:** Ajuste a algunos de los requisitos actuales del proyecto, poniendo en riesgo otros de los requisitos, bien del mismo bloque funcional bien de otros.

**INSUFICIENTE:** No cumplimiento de requisitos actuales del proyecto.

### Opción 1: Wikibase

#### Descripción de la Arquitectura

En el siguiente esquema, podemos apreciar la [arquitectura de Wikibase](https://addshore.com/2018/12/wikidata-architecture-overview-diagrams/)

![Wikibase Architecture](https://upload.wikimedia.org/wikipedia/commons/thumb/2/2e/Wikidata_Architecture_Overview_-_High_Level.svg/800px-Wikidata_Architecture_Overview_-_High_Level.svg.png) 



En el esquema se aprecia un gran bloque funcional (en azul) que es el Core de la solución, y por lo tanto soporta la mayor parte de la carga funcional soportada por Wikibase, sobre dicho Core es posible añadir ciertas extensiones, que modifican o añaden funcionalidad a la solución.

Podemos dividir la solución en los siguientes bloques funcionales, fuertemente interconectados

![wikidata](https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/Wikidata_Architecture_Overview_-_Data_getting_into_Wikidata.svg/800px-Wikidata_Architecture_Overview_-_Data_getting_into_Wikidata.svg.png)

- **Wikidata UI**: Interface de usuario. Front-end para interactuar con entidades, administración, Servicio de consulta SPARQL....
- **Wikidata API:** Api Rest que permite a usuarios o maquinas realizar peticiones HTTP para interactuar con entidades/propiedades almacenadas en Wikibase. Admite únicamente formatos JSON (principal) o XML. La estructura de datos soportada es la definida por el [Wikibase/DataModel](https://www.mediawiki.org/wiki/Wikibase/DataModel).
- **Wikidata Storage:** Gestiona la capa de persistencia. Para ello usa principalmente MySQL para almacenar los datos en formato entidad-relación, Blaze Graph como Triple Store, y Elasticsearch para soportar el descubrimiento de entidades en la interface grafica.
- **Extensiones:** Existen extensiones desarrolladas por Wikibase o por la comunidad de desarrolladores para extender la funcionalidad de Wikibase.

### Opción 2: Trellis (API LPD)+ Fuseki (EndPoint SPARQL) + Triplestore

#### Descripción de la Arquitectura

##### Trellis

Es un servidor LDP Modular, conforme a los estándar WEB, que soporta el escalado horizontal y redundancia, que ofrece una API Rest según especificaciones de de LDP (cumplimiento completo) para interactuar con los datos (métodos de creación, modificación, borrado).

Soporta bases de datos relacionales y triples stores.

Puede recuperarse un dato histórico (versionado y auditoria de cambios) en cualquier instante de tiempo siguiendo las especificaciones de  [Memento specification](https://tools.ietf.org/html/rfc7089). ([ejemplos](https://github.com/trellis-ldp/trellis/wiki/Resource-Versioning))

Proporciona un mecanismo de detección de corrupción de recursos.

Proporciona integración con Kafka, de modo que es fácilmente integrable en un sistema distribuido

![Trellis](https://github.com/trellis-ldp/trellis-deployment/raw/master/docs/TrellisLDPDiagram.png)

Desde el punto de dista de diseño, Trellis esta disponible de forma modular, es decir, se pueden usar los módulos que mejor cumplan los requisitos del proyecto, y realizar las modificaciones que requiera el proyecto sobre aquellos que fuese necesario. 

Trellis ofrece una API LDP con un comportamiento estable desde el punto de vista del cliente independientemente del sistema de almacenamiento usado, es decir, la interacción con el cliente no se ve afectada, por lo que el cambio de diversos triple store, es siempre transparente para el cliente.  

El documento [**Propuesta de diseño API LDP y EndPoint SPARQL**](../../../00-Analisis/Propuesta%20de%20dise%C3%B1o%20API%20LDP%20y%20EndPoint%20SPARQL.md) proporciona una descripción detallada de los requisitos necesarios para el proyecto ASIO, y las consideraciones de este equipo de trabajo sobre el cumplimiento que ofrece la herramienta de dichos requisitos.

##### Apache Jena Fuseki

[Apache Jena Fuseki](https://jena.apache.org/documentation/fuseki2/) es un servidor SPARQL que puede correr como un servicio del sistema operativo, como una aplicación Web y como un servidor independiente. Proporciona un capa de abstracción en el acceso a el sistema de almacenamiento, que por medio de el uso de [Jena text query](https://jena.apache.org/documentation/query/text-query.html) que potencialmente proporciona un protocolo, para la conexión con cualquier sistema de almacenamiento, lo que permitirá desacoplar totalmente, el EndPoint SPARQL proporcionado por Fuseki, del sistema de almacenamiento elegido. Por defecto usa sistema de almacenamiento TDB, que proporciona un sistema robusto y transaccional para el almacenamiento de datos .

En cuanto a la seguridad, esta es proporcionada por Apache Shiro, que permite implementar autentificación y autorización, y que a su vez es fácilmente integrable con la capa de permisos de Apache Jena.

Fuseki proporciona distintas interfaces para realizar consultar SPARQL, tanto de lectura de datos como de actualización:

- Frontal Web
- API Rest

##### Arquitectura de solución Trellis + Fuseki dentro del proyecto ASIO

El hecho de que Trellis sea un Servidor LDP con un cumplimiento completo del protocolo, y que pueda conectarse a cualquier triple store por medio de un EndPoint SPARQL 1.1 (funcionalidad proporcionada por Fuseki), hace que esta solución sea extremadamente flexible, pudiendo potencialmente sustituir en un futuro cualquiera de sus componentes (si se detectasen impedimentos que lo aconsejasen), de forma casi transparente para el resto de componentes (ya sean herramientas de terceros o desarrollos propios), no siendo necesario ningún cambio en los mismos, o en todo caso realizando cambios menores (siempre dependerá del nivel de cumplimiento de protocolos LDP SPQARL/1.1 de las herramientas elegidas).



![Arquitectura Trellis + Fuseki](https://i.ibb.co/ZgC643N/SPARQL-schema.jpg)

### Opción 3: Opción 1 (Administradores o/y parte pública) + Opción 2 (uso general).

Básicamente esta opción propone la elección de las dos opciones anteriores en paralelo, apoyándonos en que el diseño de la arquitectura para el proyecto ASIO lo permite. Esto permitirá que una decisión arquitectónica, que en estos momentos pueda parecer acertada, pero de la cual en un futuro, pudiesen aparecer nuevos impedimentos, pueda ser revertida, además de permitir usar las bondades de cada una de las opciones, sin renunciar a ninguna.

## Análisis por de opciones por bloque funcional

En los siguientes puntos, se tratara de establecer el nivel de cumplimiento de requisitos (especialmente de las opciones 1 y 2, ya que la 3 es una combinación de ambas).

### Análisis por requisitos de Seguridad

Los requisitos [5.18](#REQ 5.18 Gestión de dataset (página 65 del pliego)), [5.19](#REQ 5.19 Gestión de usuarios, permisos y acceso de datos (página 65 del pliego)), [9.1.8 , 9.2.5](REQ 9 Gestión de datos (página 72,73 del pliego)) enumeran las necesidades de autentificación y autorización con la granularidad necesaria para acceso a los recursos.

#### Autentificación

##### Opción 1: Wikibase

Según la [documentación](https://www.wikibase-solutions.com/developer-logs/oauth) disponible, [WSOAuth](https://www.mediawiki.org/wiki/Extension:WSOAuth/For_developers) permite que Wikibase delegue la autentificación a cualquier proveedor OAuth, permitiendo mediante el uso de PluggableAuth, un inicio seguro de sesión para el usuario, desde una ubicación central mediante un inicio de sesión único. 

En este aspecto, mediante el uso del plugin,  Wikibase podría ser una opción viable.

Estimación de ajuste a requisitos: **ALTA**

##### Opción 2: Trellis + Fuseki

Actualmente Trellis soporta dos tipos de autentificación:

- **Autentificación JWT** 

  La autentificación JWT es un mecanismo de autentificación que consiste en la generación de un token a partir de la información relativa a la información del usuario, cifrada con una clave compartida por Trellis y el servidor que realiza el proceso de autentificación del usuario, y un algoritmo de cifrado común (en este caso Base64-encoded). Este es el método recomendado por Trellis.

  Para realizar el proceso de login es necesario obtener un WebId, de la forma que se indica en [Solid WebID-OIDC specification](https://github.com/solid/webid-oidc-spec#deriving-webid-uri-from-id-token).

  Este proceso para la obtención del token permite delegar a un tercero el proceso de obtención del token que será usado como autentificación por Trellis, por lo tanto es posible integrarlo con cualquier método de autentificación que sea necesario para el proyecto.

- **Autentificación básica**

  Este mecanismo permite autenticar mediante nombre de usuario y password. Solo se recomienda para grupos pequeños de usuarios, como por ejemplo usuarios de administración.

Estimación de ajuste a requisitos: **ALTA**

#### Autorización

##### Opción 1: Wikibase

No hemos encontrado ningún tipo de documentación relevante, que indique que por si misma, o mediante el uso de algún plugin, Wikibase pueda proporcionar algún mecanismo de autentificación, con la granularidad suficiente para cubrir los requisitos del proyecto.

Es cierto que se puede establecer algunos aspectos de autorización a **nivel global** sobre la plataforma, tales como lectura, edición, creación, borrado de entidades y algunas autorizaciones administrativas, tales como dar de alta nuevos usuarios, bloquearlos, etc... , un ejemplo de ello lo podemos ver en el siguiente [enlace](https://heardlibrary.github.io/digital-scholarship/host/wikidata/bot/), pero por la documentación leída, parece ser que, sin modificar su Core,  **no es posible gestionar una autorización a nivel de recurso, o de conjunto de recursos, para usuarios concretos o grupos de usuarios**.

Es posible que esto se deba a que Wikibase, es un proyecto diseñado para dar soporte a Wikidata, y que siendo este un proyecto colaborativo, no presente un marco rígido respecto a los aspectos propios de la autentificación.

Estimación de ajuste a requisitos: **INSUFICIENTE**

##### Opción 2: Trellis + Fuseki

Trellis usa WebAC para autorizar acceso a recursos, definidos por el estándar [Solid WebID-OIDC specification](https://github.com/solid/webid-oidc-spec#deriving-webid-uri-from-id-token), que permite incluso en tiempo de ejecución, restringir de forma granular, el acceso a un recurso y las acciones permitidas sobre el, por lo tanto creemos que ofrece una granularidad suficiente en los aspectos relativos a autorización para dar soporte al proyecto. 

Estimación de ajuste a requisitos: **ALTA**

### Análisis por requisitos API Linked Data

Los requisitos [5.2.2](#REQ 5.2.2 Servidor Linked Data (página 66 del pliego)), [10.1 (10.1.1, 10.1.2, 10.1.3, 10.1.4 10.1.5 10.1.6 10.1.7 10.1.8 10.1.9, 10.1.10) ](#REQ 10.1 Servidor Linked Data (página 74 del pliego)), [7  (7.8)](REQ 7 Validación (página 70 del pliego)) y [10.1.9 y 10.4.3](#REQ 10 Publicación de datos (página 74-76 del pliego)) enumeran desde distintos puntos de vista,  los requisitos para el uso de un Servidor de Linked Data, que cumpla con las especificaciones de la [LDP](https://www.w3.org/TR/ldp/).

La  [LDP](https://www.w3.org/TR/ldp/) proporciona un conjunto de reglas a implementar en un Servidor Linked Data (por medio de el uso de cabeceras y conceptos específicos tales como la definición de recursos RDF y NoRDF y el uso de contenedores) ampliando el protocolo HTTP, de forma que cualquier potencial cliente, pueda conociendo dichos principios, interactuar de forma casi trasparente con cualquier servidor que los implemente.

##### Opción 1: Wikibase

La [Wikibase API](https://www.mediawiki.org/wiki/Wikibase/API/es) (el api desplegada por Wikibase), no parece que pretenda ser un un API que cumpla con los requerimientos anunciados por la LDP, ya que ni siquiera aparece en las [implementaciones LDP](https://www.w3.org/wiki/LDP_Implementations) enunciada por la W3.org

Creemos que el motivo es que el API, esta fuertemente acoplada al [Modelo de Datos](https://www.mediawiki.org/wiki/Wikibase/DataModel)  de Wikibase para el que fue creada, por lo que pensamos que a priori, no seria sencillo añadir un Servidor LDP estándar, para sustituir o complementar el API desplegada por Wikibase.  

Desde el punto de vista de la arquitectura completa de la solución, el hecho de no cumplir con el estándar enunciado por la LDP, y estar tan fuertemente acopado al [Modelo de Datos](https://www.mediawiki.org/wiki/Wikibase/DataModel) de Wikibase, hace que cualquier componente que interactúe con ella (especialmente el procesador de eventos o la factoría de URIs en la parte de Back-end o el servicio de publicación Web en la parte Front-End)  tendrán un fuerte acoplamiento con esta.

Estimación de ajuste a requisitos: **INSUFICIENTE**

##### Opción 2: Trellis + Fuseki

Desde el punto de vista del cumplimento LDP, [Trellis](https://github.com/trellis-ldp/trellis/wiki) en su documentación, asegura un cumplimiento completo de los [requisitos de un servidor LDP](https://www.w3.org/TR/ldp/).

Para evaluar el cumplimiento de dichos requisitos de primera mano, se ha usado el [LDP Test Suit](https://dvcs.w3.org/hg/ldpwg/raw-file/default/tests/ldp-testsuite.html), creado exprofeso por la LDP, para evaluar el nivel de cumplimiento.

Los resultados, y las causas de los *"errores"* en los test, están descritos de forma exhaustiva en el documento [Analisis de Test LDP (caso de uso Trellis).md](./Analisis%20de%20Test%20LDP%20(caso%20de%20uso%20Trellis).md)

Por otra parte nos parece muy interesante que el comportamiento del API, es en todo momento muy consistente sea cual sea el sistema de almacenamiento elegido (al menos en los probados) ya sea relacional (PostgreSQL) , en memoria o triple store (TDB o Blaze Graph), demostrándose este hecho en los resultados de los test, ya que estos **no se ven afectados** . Este hecho que permite garantizar mucha flexibilidad a la hora de cambiar el sistema de almacenamiento (requisito expresado en el pliego), sin afectar a los clientes.

Estimación de ajuste a requisitos: **ALTO**

### Análisis por requisitos End Point SPARQL

Los requisitos [5.19](#REQ 5.19 SPARQL  endpoint (página 65 del pliego)),[10.2 (10.2.1, 10.2.2, 10.2.3)](#REQ REQ 10.2 SPARQL endpoint (página 75 del pliego)) y [10.1.7 ](#REQ 10.1 Servidor Linked Data (página 74 del pliego)) enumeran desde distintos puntos de vista, los requisitos para el uso de un EndPoint SPARQL.

##### Opción 1: Wikibase

En principio cumple con los requisitos enunciados anteriormente relativos a un endpoint SPARQL.

Wikibase usa el EndPoint SPARQL expuesto por BlazeGraph, para ofrecer una interface gráfica llamada **Servicio de consulta**, que hace uso de dicho EndPoint, con una funcionalidad muy atractiva, ya por un lado ofrece autocompletado de variables y por otro, permite representación de resultados en múltiples formatos tales como Tabulares, Timelines, Geo-posicionados ....

Sin embargo la dependencia con BlazeGraph para ofrecer ese servicio (y en definitiva para almacenar el triple store), hace que sea imposible cumplir el requisito de **Independencia de Triple Store**.

Estimación de ajuste a requisitos: **SUFICIENTE**

##### Opción 2: Trellis + Fuseki

[Apache Jena Fuseki](https://jena.apache.org/documentation/fuseki2/) es un servidor SPARQL que proporciona un capa de abstracción en el acceso a el sistema de almacenamiento, que por medio de el uso de [Jena text query](https://jena.apache.org/documentation/query/text-query.html)  lo que potencialmente hace que sea posible la conexión con cualquier otro sistema de almacenamiento ofreciendo sobre el un servidor SPARQL/1.1

En cuanto a la seguridad, esta es proporcionada por Apache Shiro, que permite implementar autentificación y autorización, y que a su vez es fácilmente integrable con la capa de permisos de Apache Jena.

Fuseki proporciona distintas interfaces para realizar consultar SPARQL, tanto de lectura de datos como de actualización:

- Frontal Web
- API Rest

Estimación de ajuste a requisitos: **ALTO**

### Análisis por requisitos de Triple Store

Los requisitos[7 (7.1, 7.2, 7.3, 7.4, 7.5, 7.6, 7.7)](#REQ REQ 10.2 SPARQL endpoint (página 75 del pliego)) y [9.1.8 ](#REQ 9 Gestión de datos (página 72,73 del pliego))) enumeran desde distintos puntos de vista, los requisitos para el uso de triple store.

#### Opción 1: Wikibase

Como ya se enuncio en el punto anterior, Wikibase, usa como triple Store BlazeGraph, además construye su propio Servicio de consulta, sobre el Endpoint SPARQL desplegado por BlazeGraph, por lo tanto, usar esa funcionalidad,  fuerza la elección del Triple Store a solo BlazeGraph.

Dado el aparente acoplamiento de Wikibase con BlazeGraph, estos requisitos, los requisitos relativos a la elección del triple store ,no pueden ser soportados, ya que al imponer BlazeGraph, careceríamos de ningún grado de libertad el la elección de ningún otro triple store, y por lo tanto, carecerá de sentido evaluar uno u otro.

Estimación de ajuste a requisitos: **BAJO**

#### Opción 2: Fuseki + Trellis

El uso de un EndPoint que implemente el protocolo SPARQL, permite abstraer a el servidor LDP (Trellis), del sistema de almacenamiento usado, recayendo asi la flexibilidad de elección de uno u otro triple store en Fuseki.

Apache Fuseki en principio parece una herramienta bastante flexible, al ser capaz de soportar conectores para múltiples Triple Stores y obedecer el protocolo SPAPQL/1.1, que permite su sencilla integración con un servidor LDP (en este caso Trellis)

En definitiva, proporciona un comportamiento que se ajusta a los estándares definidos para el protocolo SPARQL 1.1, y probablemente cumpla con los requerimientos del proyecto ASIO.

Por otro lado también Trellis, aparte de los conectores incluidos en la herramienta, nos permite implementar aquellos que pudiesen ser necesarios, por también nos ofrece flexibilidad a la hora se seleccionar un triple store u otro.

Estimación de ajuste a requisitos: **ALTO**

### Análisis por requisitos de Interface Gráfica

Los requisitos[10 (10.1.5, 10.1.7, 10.2.2),9.2.5](#REQ REQ 10.2 SPARQL endpoint (página 75 del pliego)) y [9.1.8 ](#REQ 9 Gestión de datos (página 72,73 del pliego))) enumeran desde distintos puntos de vista, los requisitos para la Interface Gráfica.

#### Opción 1: Wikibase

Wikibase ofrece una interface gráfica solida y madura, puesta en producción con éxito en el proyecto Wikidata, que además, ofrece cierto grado de personalización, que permitiría probablemente adaptarla a las distintas universidades, o perfiles de cliente que pudiesen ser necesarias para el proyecto ASIO.

La interface de usuario de Wikibase ofrece también soporte, tanto a la edición de entidades, ofreciendo por ejemplo ayuda en la búsqueda, como en soporte el EndPoint SPARQL, ofreciendo una funcionalidad muy atractiva, ya por un lado ofrece autocompletado de variables y por otro, permite representación de resultados en múltiples formatos tales como Tabulares, Timelines, Geo-posicionados ....

Estimación de ajuste a requisitos: **ALTO**

#### Opción 2: Fuseki + Trellis

Trellis ofrece una interface de usuario manifiestamente inmadura, con una funcionalidad muy reducida. Obviamente no es un componente Core de la solución, y quizás en futuras versiones, esto pueda ser un importante área de mejora.

Fuseki sin embargo ofrece una interface de usuario, que si cubriría con los requerimientos expresados en el pliego para la misma, sin embargo, no alcanza el nivel de conseguido por el servicio de consultas de Wikibase.

Probablemente , especialmente en el caso de Trellis, sea necesario implementar soluciones Font-end propias, bien encontrar herramientas que alcancen el nivel deseado. 

Estimación de ajuste a requisitos: **INSUFICIENTE**

## Pros y contras de las Opciones

### Opción 1

#### Pros

- Cumplimiento alto en requisitos de la interface gráfica.
- Cumplimiento suficiente en requisitos EndPoint SPARQL.

#### Contras

* Cumplimiento insuficiente en requisitos de seguridad.
* Cumplimiento insuficiente en requisitos de Servidor Linked Data.
* Cumplimiento insuficiente en requisitos de Triple Store.

### Opción 2

#### Pros

* Cumplimiento alto en requisitos de seguridad.
* Cumplimiento alto en requisitos de Servidor Linked Data.
* Cumplimiento alto en requisitos EndPoint SPARQL.
* Cumplimiento alto en requisitos de Triple Store.

#### Contras

- Cumplimiento insuficiente en requisitos de la interface gráfica.

### Opción 3

#### Pros

* Cumplimiento alto en requisitos de seguridad.
* Cumplimiento alto en requisitos de Servidor Linked Data.
* Cumplimiento alto en requisitos EndPoint SPARQL.
* Cumplimiento alto en requisitos de Triple Store.
* Cumplimiento alto en requisitos de la interface gráfica (para parte pública o administradores).

#### Contras

- Aumento de complejidad

## Resultado de la decisión

Actualmente creemos que de las opciones enumeradas, la mejor opción en estos momentos, es la **Opción 3**, es decir, usar ambas soluciones, apoyándonos en la flexibilidad del diseño de la arquitectura, ya que esto supondría únicamente, mantener 2 Storage Adapters, cada uno de ellos, acoplado a una de las soluciones, no afectando en absoluto al el resto de la arquitectura. Por un lado la solución Trellis + Fuseki, se muestra más robusta y encaja mejor con los requerimientos del proyecto para todos los bloques funcionales relativos a la seguridad, API linked Data, EndPoint SPARQL y Triple Store, es decir los bloques centrales de la solución, pero Wikibase es una mejor solución en el bloque funcional relativo a la interface Gráfica. 

De hecho se valora la opción de Wikibase para un perfil de usuario de administración o back office y para el uso datos públicos  y Trellis + Fuseki para uso general.

### Consecuencias positivas

- Usar ambas soluciones, permitirá obtener los beneficios de ambas:
  - Para Wikibase: Cumplimiento de requisito para la interfaz grafica
  - Para Trellis + Fuseki: Cumplimiento de requisitos de Seguridad, API linked Data, EndPoint SPARQL y Triple Store
- Permitirá evaluar ambos, en un sistema completo y complejo, y su interacción con el resto de componentes de la arquitectura

### Consecuencias Negativas

- Añade complejidad al proyecto, al tener que mantener 2 versiones radicalmente distintas, de los componentes de la arquitectura que interactúan con ellos, en este caso, del Storage Adapter.

## Consideraciones a futuro

La elección de mantener ambas arquitecturas para fines distintos (Wikibase para la parte publica y/o administración) y Trellis + Fuseki para la parte general, nos permite, como se ha comentado anteriormente, complementar las ventajas de ambas soluciones, y reevaluar su encaje futuro en el proyecto una vez implementada de forma completa la solución con un conjunto de datos reales. 

Hemos buscado en la elección la flexibilidad necesaria para que en próximos pasos, podamos añadir o sustituir los componentes que creamos puedan tener un encaje interesante para el proyecto, como por ejemplo distintos triple stores ([TDB](https://jena.apache.org/documentation/tdb/), [Amazon Neptune](https://aws.amazon.com/es/neptune/), [StarDog](https://www.stardog.com/), [BlazeGraph](https://blazegraph.com/)...) o incluso podría se interesante la inclusión de bases de datos orientadas a grafos ([Neo4j]([https://neo4j.com/download-neo4j-now/?utm_source=google&utm_medium=ppc&utm_campaign=*EU%20-%20Search%20-%20Branded&utm_adgroup=*EU%20-%20Search%20-%20Branded%20-%20Neo4j%20-%20Exact&utm_term=neo4j&gclid=Cj0KCQjwsYb0BRCOARIsAHbLPhHX0Gd7zsyKDDE_XMkbATcudWgxT_NZ6js9R_5Jh8s0Z_zoVYU0_wwaAgQYEALw_wcB](https://neo4j.com/download-neo4j-now/?utm_source=google&utm_medium=ppc&utm_campaign=*EU - Search - Branded&utm_adgroup=*EU - Search - Branded - Neo4j - Exact&utm_term=neo4j&gclid=Cj0KCQjwsYb0BRCOARIsAHbLPhHX0Gd7zsyKDDE_XMkbATcudWgxT_NZ6js9R_5Jh8s0Z_zoVYU0_wwaAgQYEALw_wcB))). 

En definitiva, esta decisión, solo pretende una base solida, sobre la que poder integrar tanto los componentes propios ya en desarrollo, como aquellos que durante las siguientes fases del proyecto, consideremos que puedan ofrecer una importante aportación.  

## Links

- [Analisis de Test LDP (caso de uso Trellis)](./Analisis%20de%20Test%20LDP%20(caso%20de%20uso%20Trellis).md)
- [Propuesta de diseño API LDP y EndPoint SPARQL](.\00-Arquitectura\arquitectura_semantica\analisis_funcional\Requisitos LDP Server\Propuesta de diseño API LDP y EndPoint SPARQL.md)
- [Requisitos funcionales para API REST LDP en proyecto ASIO de la UM](./Requisitos%20funcionales%20para%20API%20REST%20LDP%20en%20proyecto%20ASIO%20de%20la%20UM.md)