![](./images/logos_feder.png)

| Entregable     | Esquema de URIs Hércules                                     |
| -------------- | ------------------------------------------------------------ |
| Fecha          | 25/05/2020                                                   |
| Proyecto       | [ASIO](https://www.um.es/web/hercules/proyectos/asio) (Arquitectura Semántica e Infraestructura Ontológica) en el marco de la iniciativa [Hércules](https://www.um.es/web/hercules/) para la Semántica de Datos de Investigación de Universidades que forma parte de [CRUE-TIC](http://www.crue.org/SitePages/ProyectoHercules.aspx) |
| Módulo         | Infraestructura Ontológica                                   |
| Tipo           | Documento                                                    |
| Objetivo       | Este documento recoge la definición del esquema de URIs Hércules siguiendo las recomendaciones de [Buenas prácticas para URIs Hércules](https://github.com/HerculesCRUE/ib-asio-docs-/blob/master/entregables_hito_1/09-Buenas_pr%C3%A1cticas_para_URIs_H%C3%A9rcules/ASIO_Izertis_BuenasPracticasParaURIsHercules.md) y el [Modelo Multilingüismo](https://github.com/HerculesCRUE/ib-asio-docs-/blob/master/entregables_hito_1/04-Modelo_multiling%C3%BCismo/ASIO_Izertis_ModeloMultilinguismo.md). |
| Estado         | **100%** La denifición del esquema de URIs Hércules se considera finalizado. |



# Esquema de URIs Hércules

El servidor de linked data se encargará de **gestionar todas las peticiones** de entrada de los clientes al sistema y redireccionarlas a los elementos que correspondan como puede ser, peticiones al API REST, al servicio de publicación de la Web, al gestor de datos o directamente al Endpoint SPARQL. Estas peticiones se regirán por el esquema de URIs propuesto, por lo que es de vital importancia definir unas pautas correctas y estables desde el comienzo del proyecto.

Este servidor también dispondrá de un sistema de **mapeado entre URIs externas y URIs internas**. Tal y como se indica en el pliego de condiciones, se crearán las siguientes redirecciones:

- **URIs de recursos**: servicio de publicación en la Web con negociación de contenido
- **URIs OWL o SKOS**: servicio de publicación de ontologías
- **URIs SPARQL**: Endpoint SPARQL
- **URIs de documentación**: página Web de documentación
- **Otras peticiones**: error con enlace a documentación

La API REST a su vez consiste en una capa de acceso al modelo de dominio para ofrecer un punto de acceso desde el exterior, siguiendo el modelo LDP ([Linked Data Platform](https://www.w3.org/TR/ldp/)), en el que se generan representaciones RDF para los recursos y se ofrece el **concepto de contenedores de recursos** así como enlaces entre los mismos. La utilización de un API REST permite que el sistema sea independiente del lenguaje de programación con el que esté implementado e incluso la convivencia de servicios desarrollados en diferentes lenguajes.

El Servicio publicación Web ofrece acceso a los recursos semánticos mediante **negociación de contenidos**. Se ofrecerán al menos formatos HTML y las diversas sintaxis RDF como RDF/XML, N3, Turtle, JSON-LD, etc. Además, el servicio de publicación también ofrecerá una página estática con documentación sobre los datos y cómo acceder a ellos.

Todo dato o metadato alojado en el Proyecto Hércules (RDF o  NO-RDF), debe de ser identificado mediante un identificador único, inequívoco, estable, extensible, persistente en el tiempo y ofreciendo garantías de su procedencia, requisitos claves para facilitar su posterior reutilización, basada en  los identificadores de recursos uniformes (URIs).

Para promover la reutilización de tales datos por agentes internos o externos, las URIs deben de ser **sencillos, escalables, manejables y persistentes**, tal y como se establece en el documento de [Buenas prácticas para URIs Hércules](https://github.com/HerculesCRUE/ib-asio-docs-/blob/master/entregables_hito_1/09-Buenas_pr%C3%A1cticas_para_URIs_H%C3%A9rcules/ASIO_Izertis_BuenasPracticasParaURIsHercules.md).

Para la composición de los identificadores de recursos uniformes se usara un esquema consistente, extensible y persistente, que será tratado en este mismo documento.

## Consideraciones de Arquitectura aplicables proyecto ASIO

Motivados por cumplimiento del requisito de *"el sistema debe de soportar la conectividad con distintos triple stores"*, y por sacar partido a las ventajas de ambos, la arquitectura actual del proyecto soporta la interacción con un Servidor Linked Data, que sigue las recomendaciones de la [LDP](https://www.w3.org/TR/ldp/) ([Trellis](https://github.com/trellis-ldp/trellis/wiki)) y otro que no (Wikibase API).



![Arquitectura gestión de eventos](./images/event-management.png)



Derivado de la decisión arquitectónica de soportar distintos triple stores, e incluso distintos modelos de datos (actualmente el modelo de Wikibase y modelo de Trellis), surge la necesidad de conciliar el diseño de URIs que decidamos apropiado para el proyecto, con el modelo de datos de cada uno de los sistemas soportados. Esto a priori, supone que, especialmente en el caso de Wikibase, las URIs, podrían estar sujetas a el modelo de datos de cada uno de los sistemas.

Para evitar el acoplamiento que pudiese derivarse de el uso de una u otra herramienta, y a la vez, mejorar la persistencia de las URIs generadas haciéndolas independientes de la ubicación del recurso, decidimos hacer uso de [PURL](https://es.wikipedia.org/wiki/Localizador_persistente_uniforme_para_recursos) (localizador persistente de recursos), es decir, el sistema será capaz de realizar un **mapeo**, de la **URI externa** o canónica (que seguirá el diseño expuesto en este documento) para un recurso determinado, y las **URIs internas** del recurso, que representan las ubicaciones "reales" de dicho recurso (que vendrá determinada por el modelo de datos y/o la configuración aplicada), es decir resolverá la URL de cada uno de los modelos a partir de la URI canónica, y viceversa, es decir a partir de la ubicación real del recurso, se podrá también obtener la URI canónica. El componente encargado de realizar la transformación de una URI en otra, será la [Factoría de URIs](https://github.com/HerculesCRUE/ib-uris-generator).

Creemos que esta solución aporta la flexibilidad necesaria, para que podamos hacer independiente cualquier diseño esquema de URIs, incluido el que se presenta en este documento, con cualquier ubicación física impuesta por cualquier tipo de herramienta, que a tal efecto podamos usar (actualmente Trellis y/o Wikibase, con posibilidad de ampliación).

Por otro lado, esta solución podría dar soporte también al **multilingüismo**, ya que una misma URI canónica, o variaciones de la misma, podría ser mapeado a a localización de un recurso, en una ubicación e idioma concreto.



![multilanguage](images/multi_languege_map_language.png)



## Diseño de Esquema de URIs Hércules

El diseño de un buen esquema de URIs es fundamental para asegurar la escalabilidad y persistencia de los sistemas de datos enlazados. El presente diseño, esta basado en el propuesto por la [Norma técnica de interoperabilidad (NTI)](https://www.boe.es/diario_boe/txt.php?id=BOE-A-2013-2380) tal como propone el pliego adaptándola eso si, a los requisitos propios del proyecto ASIO. Entendemos que el estándar [European Legislation Identifier (ELI)](https://eur-lex.europa.eu/eli-register/about.html), esta diseñado para un propósito mucho mas concreto (la legislación europea) , y por lo tanto, esencialmente el diseño de URIs propuesto, es menos extrapolable al proyecto ASIO, ya que su diseño, esta fuertemente acoplado al dominio para el que fue creada.

### Requisitos u objetivos

Para garantizar un buen esquema de URIs, el documento de [Buenas prácticas para URIs Hércules](https://github.com/HerculesCRUE/ib-asio-docs-/blob/master/entregables_hito_1/09-Buenas_pr%C3%A1cticas_para_URIs_H%C3%A9rcules/ASIO_Izertis_BuenasPracticasParaURIsHercules.md) establece los criterios a seguir, con respecto al uso de protocolos (HTTP/RDF), consistencia, extensibilidad, persistencia, etc.

**El conjunto de buenas practicas tiene aplicación únicamente las URIs externas, para las cuales se define el esquema de URIs en este documento**. En concreto no tienen aplicación en la definición de URIs opacas de Wikibase, definidas en el [Modelo de Multilingüismo](https://github.com/HerculesCRUE/ib-asio-docs-/blob/master/entregables_hito_1/04-Modelo_multilingüismo/ASIO_Izertis_ModeloMultilinguismo.md), dado que son URIs internas.

### Esquema de URIs

Para cumplir los requisitos enumerados, de la mejor forma posible, se propone el siguiente esquema general de URIs para URIs canónicas, que sigue un modelo semi-opaco. Este modelo aúna las ventajas de opacidad en las ***referencias***, a la vez que permite un equilibrio óptimo en cuanto a legibilidad del resto de componentes, jerarquía explícita y usabilidad.

**http://{dominio}/[{subdominio}]/{tipo}/{concepto}\[/{referencia}\]**

Y  para URIs canónicas para un determinado idioma:

**http://{dominio}/[{subdominio}]/{idioma}/{tipo}/{concepto}\[/{referencia}\]**

Cada elemento del esquema de URIs a partir del elemento idioma (tipo, concepto y referencia) debe mostrarse en el idioma indicado en la URI, si procede (no procederá para el caso de los componentes opacos como la referencia):

* **dominio:** Representa el nivel mayor del espacio de nombres para la resolución del URI, y para aportar información relevante sobre el propietario de la información. (ejemplo http://**hercules.org**)
* **subdominio (si procede):** Aporta información sobre la entidad o departamento dentro de la entidad a la cual pertenece el recurso de información. Representa el nivel menor del espacio nombres para la resolución del URI, y para aportar información relevante sobre el propietario de la información. (ejemplo http://**hercules.org/um**)
* **idioma (solo en el caso de URI canónica por idioma):** codificación de idioma (según la norma internacional ISO 639-1). Dicha selección afectara a el literal de todas los demás componentes (tipo, concepto y referencia) que deben mostrarse, si es posible, según el idioma indicado en la URL. Esto implica un mapeo de cada URI canónica, a varias URIs canónicas  por idioma de forma que sea posible pasar de una a otra forma canónica. Esta transformación se realizara en la [Factoría de URIs](https://github.com/HerculesCRUE/ib-uris-generator).

* **tipo:** Establece el tipo de información que contiene el recurso. Podrá ser uno de los enumerados:

  * **catálogo:**  Un catálogo de datos es una colección de metadatos sobre conjuntos de datos o datasets. Habitualmente estos documentos y recursos de información contendrían datos comunes como condiciones de uso, origen, vocabularios utilizados, etc. 
    * [DCAT](https://www.w3.org/TR/vocab-dcat/) (vocabularios para describir catálogos, datasets, distribuciones)
    * [VoID](https://www.w3.org/TR/void/) (vocabulario para describir conjuntos de datos RDF)
    * [PROV](https://www.w3.org/TR/prov-o/)  (vocabulario para describir licencias y derechos de uso)
  * **def:**  Para vocabulario u ontología utilizada como modelo semántico. Habitualmente esquemas RDF-S u ontologías representadas mediante OWL.

  - **kos:**  Sistema de organización del conocimiento sobre un dominio concreto. Habitualmente taxonomías, diccionarios o tesauros, representados mediante SKOS
  - **recurso:**  Identificación abstracta única y unívoca de un recurso u objeto físico o conceptual. Estos recursos son las representaciones atómicas de los documentos y recursos de información y suelen ser instancias de los conceptos que se definen en los vocabularios.

* **concepto:** Los conceptos son representaciones abstractas que se corresponden con las clases o propiedades de los vocabularios u ontologías utilizados para representar semánticamente los recursos. Además del concepto, se podrá representar una referencia unívoca a instancias concretas.

* **referencia:** Es una instancia, concepto o termino especifico.

### Esquema de URI por tipo de información 

#### URIs para catálogos y conjuntos de datos

Se propone el siguiente esquema de URIs

Canónica:

**http://{dominio}/[{subdominio}]/catalogo/[{dataset}]**

Canónica por idioma:

**http://{dominio}/[{subdominio}]/{idioma}/catalogo/[{dataset}]**

Donde el **dataset** será una referencia única opcional, que identifica si procede el conjunto de datos y el resto de secciones de la URI seguirán lo definido por el esquema general de URIs.

#### URIs para vocabularios (ontologías) 

Se propone el siguiente esquema de URIs

Canónica:

**http://{dominio}/[{subdominio}]/def/[{concepto}]**

Canónica por idioma:

**http://{dominio}/[{subdominio}]/{idioma}/def/[{concepto}]**

Donde todas las secciones de la URI seguirán lo definido por el esquema general de URIs.

#### URIs para esquemas de conceptos (SKOS) 

Se propone el siguiente esquema de URIs

Canónica:

**http://{dominio}/[{subdominio}]/kos/[{concepto}]**

Canónica por idioma:

**http://{dominio}/[{subdominio}]/{idioma}/kos/[{concepto}]**

Donde todas las secciones de la URI seguirán lo definido por el esquema general de URIs.

Todos los conceptos incluidos en el esquema tendrán como base URI la URI generada para el, siguiendo los criterios aquí descritos.

#### URIs para recursos (instancias) 

Estos recursos son las representaciones atómicas de los recursos de información, es decir suelen ser instancias de las clases que se definen en los vocabularios.

Canónica:

**http://{dominio}/[{subdominio}]/recurso/{concepto}/[{referencia}]**

Canónica por idioma:

**http://{dominio}/[{subdominio}]/{idioma}/recurso/{concepto}/[{referencia}]**

Donde todas las secciones de la URI seguirán lo definido por el esquema general de URIs.

## Identificadores (URIs)

La realización de un buen esquema de URIs es una parte fundamental en cualquier solución basada en datos enlazados. Las URIs deben tener un **formato uniforme y estable que sufra las menores variaciones posibles a lo largo de la vida del sistema** para que los diferentes datos puedan enlazarse entre sí, minimizando las situaciones en las que los enlaces no están disponibles (persistencia). 

En el caso del proyecto Hércules, el modelo de dominio es más complejo y requerirá identificar inequívocamente los diferentes tipos de entidades, por ejemplo un subconjunto de ellas pueden ser:

- **Investigadores**: profesores, grupos de investigación, colaboradores externos, etc.
- **Aportaciones**: libros, capítulos de libros, artículos, congresos, tutoriales, etc. 
- **Instituciones**: universidades, centros de investigación, grupos de investigación, etc.
- **Otras entidades**

La resolución del identificador se implementara en la [Factoría de URIs](https://github.com/HerculesCRUE/ib-uris-generator). Para ello se seguirán siempre los siguientes normas generales (ver documento de [Buenas prácticas para URIs Hércules](https://github.com/HerculesCRUE/ib-asio-docs-/blob/master/entregables_hito_1/09-Buenas_pr%C3%A1cticas_para_URIs_H%C3%A9rcules/ASIO_Izertis_BuenasPracticasParaURIsHercules.md)):

1. Las referencias deben de ser opacas.
2. Los identificadores (URIs) deben de ser persistentes.
3. Reusar identificadores (URIs) existentes en caso de que sea posible.
4. Evitar auto incrementos.
5. Evitar *query strings* (parámetros de URI).
6. Evitar extensiones que indiquen la tecnología subyacente.
7. Usar negociación de contenidos

## Grafo de conocimiento RDF

El esquema de URIs y la elección de los patrones descritos permite la definición del grafo RDF, junto con los datos descriptivos que serán servidos en cada petición. Estos datos a su vez deberán estar previamente mapeados con las ontologías.

Como ya se ha mencionado previamente, la negociación de contenidos juega también un papel crucial, así como la creación de un mapa semántico y la internacionalización de los patrones de URIs.

## Referencias

Norma técnica de Interoperatividad (NTI), Agencia Estatal Boletín oficial del estado,  19 febrero de 2013.
https://www.boe.es/diario_boe/txt.php?id=BOE-A-2013-2380

T. Berners-Lee. Universal resource identifiers - axioms of web architecture, 1996.
http://www.w3.org/DesignIssues/Axioms.html

T. Berners-Lee. Cool uris don't change, 1998.
http://www.w3.org/Provider/Style/URI.html

T. Berners-Lee. Linked data - design issues, 2006.
http://www.w3.org/DesignIssues/LinkedData.html

I. Davis and L. Dodds. Linked data patterns, 2010.
http://patterns.dataincubator.org/book/

J. E. Labra Gayo, D. Kontokostas and S. Auer, Semantic Web, vol. 6, no. 4, pp. 319-337, 2015.
http://www.semantic-web-journal.net/system/files/swj495.pdf