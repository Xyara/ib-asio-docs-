![](./images/logos_feder.png)

# Arquitectura de URIs

El servidor de linked data se encargará de **gestionar todas las peticiones** de entrada de los clientes al sistema y redireccionarlas a los elementos que correspondan como puede ser, peticiones al API REST, al servicio de publicación de la Web, al gestor de datos o directamente al Endpoint SPARQL. Estas peticiones se regirán por el esquema de URIs propuesto, por lo que es de vital importancia definir unas pautas correctas y estables desde el comienzo del proyecto.

Este servidor también dispondrá de un sistema de **mapeado entre URIs externas y URIs internas**. Tal y como se indica en el pliego de condiciones, se crearán las siguientes redirecciones:
- **URIs de recursos**: servicio de publicación en la Web con negociación de contenido
- **URIs OWL o SKOS**: servicio de publicación de ontologías 
- **URIs SPARQL**: Endpoint SPARQL
- **URIs de documentación**: página Web de documentación
- **Otras peticiones**: error con enlace a documentación

La API REST a su vez consiste en una capa de acceso al modelo de dominio para ofrecer un punto de acceso desde el exterior, siguiendo el modelo LDP ([Linked Data Platform](https://www.w3.org/TR/ldp/)), en el que se generan representaciones RDF para los recursos y se ofrece el **concepto de contenedores de recursos** así como enlaces entre los mismos. La utilización de un API REST permite que el sistema sea independiente del lenguaje de programación con el que esté implementado e incluso la convivencia de servicios desarrollados en diferentes lenguajes. 

El Servicio publicación Web ofrece acceso a los recursos semánticos mediante **negociación de contenidos**. Se ofrecerán al menos formatos HTML y las diversas sintaxis RDF como RDF/XML, Turtle, JSON-LD, etc.  Además, el servicio de publicación también ofrecerá una página estática con documentación sobre los datos y cómo acceder a ellos. 

El modelo de datos Wikibase dispone además de un mecanismo integrado de multilingüismo, utilizando un patrón de [URIs opacas](http://www.weso.es/MLODPatterns/Opaque_URIs.html), en el que los conceptos y las propiedades usan identificadores numéricos para **evitar asociaciones dependientes de un idioma concreto**, pero facilitando a la vez la utilización de etiquetas multilingües con sugerencias y autocompletado en la librería Javascript.



## Identificadores (URIs)

La realización de un buen esquema de URIs es una parte fundamental en cualquier solución basada en datos enlazados. Las URIs deben tener un **formato uniforme y estable que sufra las menores variaciones posibles a lo largo de la vida del sistema** para que los diferentes datos puedan enlazarse entre sí, minimizando las situaciones en las que los enlaces no están disponibles. 

En el caso del proyecto Hércules, el modelo de dominio es más complejo y requerirá identificar claramente los diferentes tipos de entidades como pueden ser:

- **Investigadores**: profesores, grupos de investigación, colaboradores externos, etc.
- **Aportaciones**: libros, capítulos de libros, artículos, congresos, tutoriales, etc. 
- **Instituciones**: universidades, centros de investigación, grupos de investigación, etc.
- **Otras entidades** (pendiente ontologías)

### Diseño de URIs

**El diseño de un buen esquema de URIs es fundamental** para la estabilidad de los sistemas basados en datos enlazados. Siguiendo la recomendación de [Phil Archer](https://joinup.ec.europa.eu/solution/study-persistent-uris-identification-best-practices-and-recommendations-topic-mss-and-ec/distribution/study-persistent-uris-identification-best-practices-and-recommendations-topic-mss-and-ec) para la Comisión Europea, el modelo a seguir se basa en el siguiente esquema:

**http://{dominio}/{tipo}/{concepto}/{referencia}**

- ***{dominio}*** es una combinación del host y del sector relevante. El sector puede ser un subdominio o el primer componente del path. 
- ***{tipo}*** debería ser un valor entre un conjunto pequeño de valore que declaren el tipo de recurso que se está identificando. Ejemplos típicos pueden ser:
  - 'id' ó 'item' para valores del mundo real
  - 'doc' para documentos
  - 'def' para definiciones de conceptos
  - 'set' para conjuntos de datos

- ***{concepto}*** podría ser una colección, el tipo de objeto del mundo real identificado, el nombre del esquema de conceptos, etc.
- ***{referencia}*** es un ítem, concepto o término específico

Partiendo de dicho esquema, se busca cumplir además las siguientes **buenas prácticas**:

1. Evitar declarar la organización que genera la URI
2. Evitar números de versión para identificar conceptos 
3. Reusar identificadores existentes (campo {referencia})
4. Evitar uso de auto-incrementos, query-strings y extensions
5. Enlazar representaciones múltiples (rel, alternate, dct:hasFormat, etc)
6. Diseñar URIs para múltiples formatos (negociación de contenido)
7. Redirecciones 303 para URIs que identifican conceptos del mundo real
8. Utilizar servicios dedicados para generar URIs persistentes
9. Patrón de URIs opacas (identificadores numéricos)

10. Etiquetado multilingüe (rdfs:label, skos:altLabel, dc:description, etc)

11. Identificadores persistentes FAIR (Purl, w3id, identifiers. org, etc)


Y adicionalmente se seguirán las **buenas prácticas asociadas a LDP y FAIR**:

1. Las URIs que definan propiedades deben ser de-referenciables
2. Vocabulario RDFS para describir propiedades
3. Al menos una declaración rdf:type por cada recurso
4. Relaciones de pertenencia a contenedor mediante URIs jerárquicas
5. Barra de separación al final de las URIs que representan contenedores
6. Utilizar fragmentos como identificadores de recursos (URIs Hash)
7. Referencias, cualificadores y rangos (reificación, modelo evolutivo, etc)



## Grafo de conocimiento RDF

El esquema de URIs y la elección de los patrones descritos permite la definición del grafo RDF, junto con los datos descriptivos que serán servidos en cada petición. Estos datos a su vez deberán estar previamente mapeados con las ontologías.

Como ya se ha mencionado previamente, la negociación de contenidos juega también un papel crucial, así como la creación de un mapa semántico y la internacionalización de los patrones de URIs.

### Definición de conceptos

*(Pendiente de definición de ontologías)*

- **Investigador**:
  - http://w3id.org/hercules/def/Q1650915
  - @en researcher
  - @es invertigador

### Reificación

Wikibase permite la utilización homogénea de un sistema de reificación que permite cualificar las declaraciones. En dicho modelo, todo enunciado puede tener asociadas una serie de declaraciones que permiten cualificar lo que se está afirmando. A modo de ejemplo, la declaración de que Murcia (wd:Q12225) tiene una población (propiedad P1082) de 447182 habitantes puede realizarse de forma directa como:

`wd:Q12225 wdt:P1082 447182 .` 

La declaración anterior se puede tomar como declaración por defecto, sin embargo, si se desea mantener una base de conocimiento fiable que evolucione con el tiempo es necesario añadir **cualificadores** a dicha afirmación. Por ejemplo, se puede indicar que la fuente o referencia a partir de la cual se ha obtenido el valor es el Registro Municipal de España (wd:Q17597568) y que el valor se refiere al año 2018. Esa información se representa como:

`wd:Q12225 p:P1082 [` 

 `wikibase:rank wikibase:PreferredRank ;`

 `ps:P1082 "447182"^^xsd:**decimal** ;`

 `prov:wasDerivedFrom wd:Q17597568 ;`

 `pq:P585 "2018-01-01"^^xsd:**date**`

`] .` 

El modelo de reificación de Wikibase está predefinido en el sistema de forma homogénea y permite realizar consultas enriquecidas y mantener un grafo de conocimiento que evoluciona a lo largo del tiempo. 

La ventaja de dicho sistema es la adaptabilidad a la propia evolución de los datos, al permitir disponer de datos históricos de investigación.



## Referencias

T. Berners-Lee. Universal resource identifiers - axioms of web architecture, 1996.
http://www.w3.org/DesignIssues/Axioms.html

T. Berners-Lee. Cool uris don't change, 1998.
http://www.w3.org/Provider/Style/URI.html

T. Berners-Lee. Linked data - design issues, 2006.
http://www.w3.org/DesignIssues/LinkedData.html

I. Davis and L. Dodds. Linked data patterns, 2010.
http://patterns.dataincubator.org/book/

J. E. Labra Gayo, D. Kontokostas and S. Auer, Semantic Web, vol. 6, no. 4, pp. 319-337, 2015.
http://www.semantic-web-journal.net/system/files/swj495.pdf



