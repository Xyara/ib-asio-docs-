![](./images/logos_feder.png)

# Elección arquitectura semántica

El presente documento pretende mostrar las alternativas que existen para crear la arquitectura semántica de cara a almacenar los datos correspondientes al proyecto ASIO. Esta arquitectura debería cubrir los siguientes aspectos:

- Facilitar la generación de RDF a partir de POJOs
- Almacenamiento de la información en triple store
- Endpoint SPARQL
- Linked Data Server

Hay que tener en cuenta que uno de los requisitos que se persigue es que la arquitectura sea capaz de abstraer el triple store utilizado para que en momento dado se pueda intercambiar por otro de forma sencilla.

A groso modo, las alternativas que existirían son las siguientes:

- Implementación ad-hoc utilizando diferentes piezas que den lugar a una arquitectura completa y extensible. Para ello se puede hacer uso de diferentes frameworks
- Utilización de un Linked Data Platform, el cual por si mismo aporta todas las piezas ya montadas y listas para su utilización

## Implementación ad-hoc

Con este modelo se pretende ir desarrollando todos los componentes que forman parte de la arquitectura de forma que permitan cumplir con los objetivos propuestos previamente a la par que aportar flexibilidad al Backend SGI para permitir ampliarlo a medida que vaya avanzando el proyecto.

En este sentido, se recomienda la utilización de un framework que ayude a generar la solución final, siendo los más usados:

- Eclipse RDF4J: [https://RDF4J.org/](https://RDF4J.org/)
- Apache Jena: [https://jena.apache.org/](https://jena.apache.org/)

Para la elección de los frameworks se ha tenido en cuenta los siguientes factores claves:

- Disponibilidad de documentación
- Ampliamente acogido por la comunidad
- Posibilidad de integración con diferentes triple stores
- Posibilidad de generar un modelo RDF a partir de POJOs
- Posibilidad de generar RDF en diferentes formatos (turtle, xml-ld, json-ld, ...)

### Apache Jena

Apache Jena es un framework Java Open source para el desarrollo y construcción de aplicaciones Linked Data y web semántica. 

La arquitectura de Apache Jena se basa en diferentes elementos que todos juntos permiten procesar e interactuar con datos RDF.

![Arquitectura Apache Jena](https://jena.apache.org/images/jena-architecture.png)

Las características más destacables de Jena son las siguienes

- RDF API: Es el core de Jena, permitiendo la generación de modelos RDF 
- Ejecución de consultas SPARQL 
- TDB como triple store por defecto, pero con posibilidad de crear adaptadores para otros almacenamientos
- Exportación / importación de datos en RDF/XML, turtle, n-triples y RDFa
- Inferencia, mediante motor de reglas y otros algoritmos

#### Importación de datos

Para la importación de datos se deberán transformar los datos desde un POJO a formato RDF. Jenra en el API RDF provee de mecanismos para facilitar esta transformación. Para ello se debe crear un modelo al que posteriormente se le van añadiendo propiedades. Por ejemplo:

```java
// create an empty model
Model model = ModelFactory.createDefaultModel();

// create the resource
Resource johnSmith = model.createResource("http://example.org/JohnSmith");

// add the property
johnSmith.addProperty(VCARD.FN, "John Smith");
```

En este caso se crea un modelo para un nuevo elemento de tipo "http://example.org/JohnSmith", al cual se le añade como propiedad el nombre "John Smith".

También sería posible cargar los datos desde un fichero o un input stream en formato RDF:

```java
String inputFileName  = "vc-db-1.rdf";

// create an empty model
Model model = ModelFactory.createDefaultModel();

InputStream in = FileManager.get().open( inputFileName );
if (in == null) {
    throw new IllegalArgumentException( "File: " + inputFileName + " not found");
}

// read the RDF/XML file
model.read(in, "");
```

Sería posible exportar los datos al formato adecuado mediante el siguente código:

```java
// write it to standard out
model.write(System.out, "TURTLE");
```

#### Triple stores

Jena utiliza como triple store por defecto TDB. Para ello disponede los conectores oportunos para facilitar la utlización de este sistema. Por ejemplo

```java
String directory = "MyDatabases/DB1";
Dataset dataset = TDBFactory.createDataset(directory);
```

Un ejemplo de almacenamiento de información vía SPARQL:

```java
public static void main(String...argv) {
    String directory = "MyDatabases/DB1";
    Dataset dataset = TDBFactory.createDataset(directory);

    // Start WRITE transaction.
    // It's possible to read from the dataset inside the write transaction.

    // An application can have other Datasets, in the same JVM,
    // tied to the same TDB database performing read
    // transactions concurrently. If another write transaction
    // starts, the call of dataset.begin(WRITE) blocks until
    // existing writer finishes.
    
    // A WRITE transaction is
    // dataset.begin(ReadWrite.READ);
    // try {
    // ...
    // ... dataset.abort() or dataset.commit()
    // } finally { dataset.end();}
    //

    Txn.executeWrite(dataset, ()->{
        // Do a SPARQL Update.
        String sparqlUpdateString = StrUtils.strjoinNL
            ("PREFIX . <http://example/>"
            ,"INSERT { :s :p ?now } WHERE { BIND(now() AS ?now) }"
            );

        execUpdate(sparqlUpdateString, dataset);
    });
}

public static void execUpdate(String sparqlUpdateString, Dataset dataset) {
    UpdateRequest request = UpdateFactory.create(sparqlUpdateString);
    UpdateProcessor proc = UpdateExecutionFactory.create(request, dataset);
    proc.execute();
}
```

También sería posible utilizar otros Triple Store vía endpoint SPARQL gracias a `RDFConnection`. Por ejemplo:

```java
RDFConnectionRemoteBuilder builder = RDFConnectionRemote.create()
        .httpClient(httpClient)
        .destination(endpoint)
        // Query only.
        .queryEndpoint("sparql")
        .updateEndpoint("sparql");

Query query = QueryFactory.create("SELECT * { ?s ?p ?o } LIMIT 100");

// Whether the connection can be reused depends on the details of the implementation.
// See example 5.
try (RDFConnection conn = builder.build()) {
    conn.queryResultSet(query, ResultSetFormatter::out);
}
```

En el caso de BlazeGraph:

```java
String APIUrl = "http://192.168.222.1:9999/bigdata/sparql";
RDFConnection conn = RDFConnectionFactory.connect(APIUrl,APIUrl,APIUrl);
```

También existen providers para los TripleStores más utilizados como Virtuoso [http://vos.openlinksw.com/owiki/wiki/VOS/VirtJenaProvider](http://vos.openlinksw.com/owiki/wiki/VOS/VirtJenaProvider)

### Eclipse RDF4J

Eclipse RDF4J es un framework open source para el almacenamiento, consulta y análisis de datos RDF.

![Arquitectura RDF4J](https://rdf4j.org/images/rdf4j-architecture.svg)

En cuanto a arquitectura, al igual que Jena, se basa en una arquitectura modular que hace que se puedan ir tomando aquellas partes (APIs) que sean precisa para la aplicación.

Una de las ventajas que aporta RDF4J, es la gran documentación con la que cuenta así como una gran comunidad y proyectos desarrollados con la misma.

Las características principales son

- Rio (RDF I/O): Parser/writer API
- Model API: permite la generación de modelos a partir de los datos
- Ejecución de consultas SPARQL 
- Sesame como triple store por defecto, pero con posibilidad de crear adaptadores para otros almacenamientos
- Exportación / importación de datos RDF en numerosos formatos
- Inferencia y validación, mediante motor de reglas y otros algoritmos
- Extensiones: Full-Text Search, GeoSPARQL, FedX: Queries federadas

#### Importación de datos

La importación de datos comparte varios conceptos con Jena, ya que se basa en la confección de un modelo. Para ello se utiliza el API RIO (RDF Input/Output), la cual contiene parseadores para y writers para numerosos formatos de salida:

- RDF/XML
- Turtle
- N-Triples
- TriG
- TriX
- JSON-LD
- RDF/JSON
- N-Quads
- Binary

En cuanto a la confección de un modelo, como ejemplo podemos modelar lo siguiente: 

![Modelado de ejemplo](./images/rdf-graph-2.png)

Donde se dice que "Picasso" es de tipo "Artist" y que además tiene como nombre "Pablo" (siguiendo el vocabulario FOAF).

Llevado a RDF4J, tendría el siguiente aspecto:

```java
// We use a ValueFactory to create the building blocks of our RDF statements:
// IRIs, blank nodes and literals.
ValueFactory vf = SimpleValueFactory.getInstance();

// We want to reuse this namespace when creating several building blocks.
String ex = "http://example.org/";

// Create IRIs for the resources we want to add.
IRI picasso = vf.createIRI(ex, "Picasso");
IRI artist = vf.createIRI(ex, "Artist");

// Create a new, empty Model object.
Model model = new TreeModel();

// add our first statement: Picasso is an Artist
model.add(picasso, RDF.TYPE, artist);

// second statement: Picasso's first name is "Pablo".
model.add(picasso, FOAF.FIRST_NAME, vf.createLiteral("Pablo"));
```

Sería posible leer datos de un fichero en formato RDF (en cualquiera de los admitidos por RDF4J), por ejemplo en TURTLE:

```java
String filename = "example-data-artists.ttl";

// read the file 'example-data-artists.ttl' as an InputStream.
InputStream input = Example08ReadTurtle.class.getResourceAsStream("/" + filename);

// Rio also accepts a java.io.Reader as input for the parser.
Model model = Rio.parse(input, "", RDFFormat.TURTLE);
```

Así como exportar los datos en RDF:

```java
// Instead of simply printing the statements to the screen, we use a Rio writer to
// write the model in Turtle syntax:
Rio.write(model, System.out, RDFFormat.TURTLE);
```

#### Triple stores

RDF4J provee un conjunto de APIs que se abstraen del vendedor para el almacenamiento, razonamiento y recuperación de RDF y OWL. Las principales soluciones que implementan las APIs RDF4J son:

* **Core databases**: Este tipo de bases de datos están orientadas a dataset de tamaños medio y mediano, recomendándose otro tipo de bases de datos para proyectos más grandes. Incluye bases de datos desarrolladas por RDF4J como son 
  * **Memory Store**: base de datos RDF transaccional en memoria con persistencia a disco opcional. 
  * **Native Store**: base de datos RDF transaccional usando persistencia en disco. Se trata de una solución más escalable que la opción en memoria. Orientada para datasets de 100 millones de triples.
  * **Elasticsearch Store**: se trata de una base de datos RDF experimental que utiliza Elasticsearch como almacenamiento
* **Ontotext GraphDB**: se trata de uno de los triplestores lider del mercado construido sobre los estándares de OWL. Es capaz de manejar grandes cargas y consultas pesadas así como inferencia en tiempo real. Desde la versión 8 es completamente compatible con RDF4J.
* **Halyard**: triplestore implementado sobre Apache HBase
* **Stardog**: almacenamiento rápido, ligero y Java puro para RDF
* **Amazon Neptune**: Triple store gestionado en la nube de Amazon AWS
* **Systap Blazegraph**
* **MarkLogic RDF4J API**
* Strabon
* **Openlink Virtuoso RDF4J Provider**: proveedor para permitir a RDF4J modificar, consultar y razonar con Virtuoso

Ejemplo de persistencia de RDF en triplestore:

```java
// First load our RDF file as a Model.
String filename = "example-data-artists.ttl";
InputStream input = Example13AddRDFToDatabase.class.getResourceAsStream("/" + filename);
Model model = Rio.parse(input, "", RDFFormat.TURTLE);

// Create a new Repository. Here, we choose a database implementation
// that simply stores everything in main memory. Obviously, for most real-life applications, you will
// want a different database implementation, that can handle large amounts of data without running
// out of memory and keeps data safely on disk.
// See http://docs.rdf4j.org/programming/#_the_repository_api for more extensive examples on
// how to create and maintain different types of databases.
Repository db = new SailRepository(new MemoryStore());
db.initialize();

// Open a connection to the database
try (RepositoryConnection conn = db.getConnection()) {
  // add the model
  conn.add(model);

  // let's check that our data is actually in the database
  try (RepositoryResult<Statement> result = conn.getStatements(null, null, null);) {
    while (result.hasNext()) {
      Statement st = result.next();
      LOG.info("db contains: {}", st);
    }
  }
} finally {
  // before our program exits, make sure the database is properly shut down.
  db.shutDown();
}
```

Por ejemplo una consulta SPARQL contra un repositorio en memoria:

```java
// Create a new Repository.
Repository db = new SailRepository(new MemoryStore());
db.initialize();

// Open a connection to the database
try (RepositoryConnection conn = db.getConnection()) {
  String filename = "example-data-artists.ttl";
  try (InputStream input =
      Example15SimpleSPARQLQuery.class.getResourceAsStream("/" + filename)) {
    // add the RDF data from the inputstream directly to our database
    conn.add(input, "", RDFFormat.TURTLE );
  }

  // We do a simple SPARQL SELECT-query that retrieves all resources of type `ex:Artist`,
  // and their first names.
  String queryString = "PREFIX ex: <http://example.org/> \n";
  queryString += "PREFIX foaf: <" + FOAF.NAMESPACE + "> \n";
  queryString += "SELECT ?s ?n \n";
  queryString += "WHERE { \n";
  queryString += "    ?s a ex:Artist; \n";
  queryString += "       foaf:firstName ?n .";
  queryString += "}";

  TupleQuery query = conn.prepareTupleQuery(queryString);

  // A QueryResult is also an AutoCloseable resource, so make sure it gets closed when done.
  try (TupleQueryResult result = query.evaluate()) {
    // we just iterate over all solutions in the result...
    while (result.hasNext()) {
      BindingSet solution = result.next();
      // ... and print out the value of the variable binding for ?s and ?n
      LOG.info("?s = {}", solution.getValue("s"));
      LOG.info("?n = {}", solution.getValue("n"));
    }
  }
} finally {
  // Before our program exits, make sure the database is properly shut down.
  db.shutDown();
}
```

### Comparativa Jena vs RDF4J

Una vez visto tanto Jena como RDF4J, es hora de realizar una comparativa entre ambos. En ambos casos se trata de productos con características similares pero con ligeras diferencias:

|                     | Jena | RDF4J |
| ------------------- | :--: | :---: |
| Disponibilidad de documentación | :heavy_check_mark: | :heavy_check_mark: |
| Ampliamente acogido por la comunidad | :heavy_check_mark: | :heavy_check_mark: |
| Posibilidad de generar un modelo RDF a partir de POJOs | :heavy_check_mark: | :heavy_check_mark: |
| Posibilidad de generar RDF en diferentes formatos (turtle, xml-ld, json-ld, ...) | :heavy_check_mark: | :heavy_check_mark: |
| Soporte a la generación de RDF en más formatos | :x: | :heavy_check_mark: |
| Posibilidad de integración con diferentes triple stores | :heavy_check_mark: | :heavy_check_mark: |
| Conexión mediante endpoint SPARQL | :heavy_check_mark: | :heavy_check_mark: |
| Conectores ya desarrollados para los principales triple stores \* | :x: | :heavy_check_mark: |
| API Linked Data | :x: | :x: |
| Endpoint SPARQL | :x: | :x: |

\* Referente a los conectores con diferentes triple stores, se detallará en la sección [Conectores con tiple stores](#conectores-con-triple-stores)

#### Conectores con tiple stores

En la tabla comparativa se hace referencia a que RDF4J dispone de conectores ya desarrollados con triple stores. Realmente RDF4J dispone de unas APIs que implementan por defecto varios triplestores, como son los siguientes:

* Core databases 
  * Memory Store
  * Native Store
  * Elasticsearch Store
* Ontotext GraphDB
* Halyard
* Stardog
* Amazon Neptune
* Systap Blazegraph
* MarkLogic RDF4J API
* Strabon
* Openlink Virtuoso RDF4J Provider

Mediante la utilización del API de SAIL, es posible conectarse a los stores mediante los conectores que proveen de forma nativa estos fabricantes. En otros casos es posible utilizar un conector SPARQL siempre que se disponga deuna implementación compatible con la especificación [SPARQL 1.1](https://www.w3.org/TR/sparql11-protocol/), para lo cual RDF4J también ofrece compatibilidad con [SPARQL 1.1 Graph Store HTTP Protocol](https://www.w3.org/TR/sparql11-http-rdf-update/).

Más información:

* https://rdf4j.org/documentation/reference/sail/
* https://rdf4j.org/documentation/reference/rest-api/
* https://rdf4j.org/documentation/programming/repository/
* http://graphdb.ontotext.com/documentation/free/architecture-components.html#architecture-components-rdf4j

En el caso de Jena, la opción siempre sería ir mediante un endpoint SPARQL, lo cual no hace que no sea posible la conexión, incluso algunos de los fabricantes ofrecen compatibilidad, pero la forma de trabajar puede hacer un poco más limitada esta conectividad. Este es el caso por ejemplo de GraphDB en el que se  indica que es compatible con Jena 2.7, mediante la utlización de un adaptador, en este caso lo que está haciendo es generar una implementación de `Dataset` envolviendo un repositorio SAIL de RDF4J.

* http://graphdb.ontotext.com/documentation/free/using-graphdb-with-jena.html

#### Cumplimiento LDP

En el caso de una solución ad-hoc, será preciso implementar las APIs que cumplan con los requisitos de LDP. En este sentido, conllevaría una enorme dificultar realizar esta implementación debida a la complejidad de este tipos de APIs.

#### Conclusión

Viendo los resultados anteriores, aunque ambos podrían utilizarse para el mismo cometido, parece que RDF4J aporta más valor al soportar más formatos RDF y al tener mayor compatibilidad con diferentes triplestores. No obstante, en cuanto a la compatibilidad con los diferentes triplestores, al poder utilizar un envoltorio de SAIL con Apache Jena, sería posible añadir compatibilidad con todos aquellos triplestores compatibles con RDF4J.

## Linked data platform (LDP)

Una plataforma Linked Data es aquella que abarca desde el almacenamiento de los datos en triple store (u otro sistema) a la exposición de APIs siguiendo los estándares LDP y endpont SPARQL. En este caso se ha valorado la utilización de [Trellis](https://github.com/trellis-ldp/trellis/wiki)

### Trellis

#### General

Es un servidor LDP Modular que soporta el escalado horizontal y redundancia.

Soporta bases de datos relacionales y triples stores.

##### Objetivo

Ofrecer API Rest según especificaciones de de LDP para interactuar con los datos (métodos de creación, modificación, borrado).

Puede recuperarse un dato histórico (versionado y auditoria de cambios) en cualquier instante de tiempo siguiendo las especificaciones de  [Memento specification](https://tools.ietf.org/html/rfc7089 "Title"). ([ejemplos](https://github.com/trellis-ldp/trellis/wiki/Resource-Versioning "Title"))

Proporciona un mecanismo de detección de corrupción de recursos.

Proporciona integración con Kafka, de modo que es fácilmente integrable en un sistema distribuido

**Autentificación y Autorización **

Permite controlar la [autentificación](https://github.com/trellis-ldp/trellis/wiki/Authentication) por JWT o acceder públicamente, controlado ambos accesos por configuración en tiempo de ejecución

Después de la autentificación se asigna un WebID. El modulo de WebAC regula la [autorización](https://github.com/trellis-ldp/trellis/wiki/Authorization) para acceso a el recurso para cada WebID, por medio de el uso de RDFs para definir e acceso.

```
@prefix acl: <http://www.w3.org/ns/auth/acl#>.

<#authorization> a acl:Authorization ;
    acl:mode acl:Read, acl:Write ;
    acl:accessTo <https://example.org/repository/resource> ;
    acl:agent <https://example.org/users/1>, <https://example.org/users/2> .
```

##### Uso

Puede instalarse en maquinas Linux / Windows o mediante Docker. En este último, Trellis poseé imágenes Docker tanto para la versión triplestore como para la versión base de datos. Por ejemplo, para la instalación de un entorno Docker se podría utilizar mediante compose o swarm el siguiente yaml:

```yml
version: "3"
services:
  trellis:
    image: trellisldp/trellis-ext-db:latest
    environment:
      TRELLIS_DB_USERNAME: changeme
      TRELLIS_DB_PASSWORD: changeme
      TRELLIS_DB_URL: jdbc:postgresql://db/db-name
    ports:
      - 80:8080
    depends_on:
      - db
    volumes:
      - /local/trellis/data:/opt/trellis/data
      - /local/trellis/log:/opt/trellis/log
      # Please see note below about the ./etc directory
      # - /local/trellis/etc:/opt/trellis/etc
  db:
    image: postgres
    environment:
      POSTGRES_DB: db-name
      POSTGRES_PASSWORD: changeme
      POSTGRES_USER: changeme
      PGDATA: /var/lib/postgresql/data/pgdata/mydata
    volumes:
      - /local/postgresql/data/folder:/var/lib/postgresql/data/pgdata/mydata
```

Levantando en este caso tanto trellis con la capa de persistencia en base de datos como una base de datos relacional tipo Postgres.

#### Cumplimiento LDP

Según el W3C, TrellisLDP dispone de un cumplimiento completo de [LDP 1.0](https://www.w3.org/TR/ldp/) desde 2018.

Más información:

- [https://www.w3.org/wiki/LDP_Implementations#TrellisLDP_.28Server.29](https://www.w3.org/wiki/LDP_Implementations#TrellisLDP_.28Server.29)

Por otro lado se evalúa el cumplimento de Trellis sobre la LDP, con la [Suit de Test](https://dvcs.w3.org/hg/ldpwg/raw-file/default/tests/ldp-testsuite.html) que propone la LDP, obteniendo los resultados recogidos en el [Analisis de Test LDP (caso de uso Trellis)](https://git.izertis.com/universidaddemurcia/semantmurc/asio-docs/blob/master/arquitectura_semantica/analisis_funcional/Requisitos LDP Server/Analisis de Test LDP (caso de uso Trellis).md)

Los resultados obtenidos se pueden resumir en la siguiente tabla

|                   |           | MUST | SHOULD | MAY  | Total |
| ----------------- | --------- | ---- | ------ | ---- | ----- |
| BasicContaier     | Correctos | 41   | 12     | 4    | 57    |
|                   | Fallos    | 4    | 6      | 1    | 11    |
| DirectContainer   | Correctos | 45   | 13     | 4    | 62    |
|                   | Fallos    | 4    | 7      | 1    | 12    |
| IndirectContainer | Correctos | 40   | 12     | 4    | 56    |
|                   | Fallos    | 4    | 6      | 1    | 11    |

Además, se determina que test fallidos, en la mayor parte de los casos, bien la normativa es interpretativa, es decir, según la interpretación que se de a la misma puede cumplir o no cumplir, o en otros casos, el incumplimiento, sucede en la parte menos trascendental de la normativa.

#### Integraciones

Se integra con una base de datos relacional o con triple stores (BlazeGraph y TDB con Apache Fuseki). También publica notificaciones al añadir, modificar o eliminar un recurso conforme a [Activity Stream 2.0 specification](https://www.w3.org/TR/activitystreams-core/)

#### Guía de configuración

La aplicación Web Dropwizard.io permite manejar un amplio conjunto de opciones de configuración que pueden definirse también por un fichero en la ruta `/opt/trellis/etc/config.yml`.

#### Arquitectura

![arquitectura](https://github.com/trellis-ldp/trellis-deployment/raw/master/docs/TrellisLDPDiagram.png)

Los métodos get y replace son idempotentes y aplicables a un único recurso. Los métodos no idempotentes POST y PATCH, se descomponen en get y replace, que son idempotentes.

La arquitectura de Trellis, permite tratar el recurso como una clave opaca, independiente de su jerarquía, de forma que se permita el  escalado horizontal.

##### Consistencia

Dado que es un sistema distribuido, que potencialmente accede a distintas fuentes, ofrece consistencia eventual.

##### Recursión

No hay soporte para la recursión, por lo tanto los PUT y DELETE recursivos no son posibles. Por ejemplo para crear /foo/bar/baz, es necesario crear todos los contenedores.

Del mismo modo al borrar un raiz (foo), no borramos la jerarquía, por lo que debemos borrarlo explícitamente.

##### Asincronía

Todas las operaciones se realizan de forma asíncrona, lo que implica que pueden no ser visibles por los clientes inmediatamente

##### Extensión de funcionalidades

Trellis viene empaquetado listo para su utilización con los componentes estándar o extenderse con Maven, proporcionando para ello una librería que contiene todas las interfaces necesarias para crear extensiones.

```xml
<dependency>
    <groupId>org.trellisldp</groupId>
    <artifactId>trellis-api</artifactId>
    <version>0.10.0</version>
</dependency>
```

Trellis también provee de todas sus libererías subidas a repositorios Maven con lo cual sería muy sencillo utlizarlas para componer un empaquetado "custom". Esto facilitaría también el intercambio de ciertas piezas como puede ser la capa de persistencia para permitir así cumplir con el requisito de que la plataforma sea capaz de soportar el intercambio de triplestore, lo cual se explicará en la sección siguiente.

##### Intercambio de las capas de persistencia

Como se ha comentado en secciones anteriores, Trellis por defecto soporta la persistencia en triplestore y en base de datos relacional, siendo posibles en este último tanto Postgres como MySQL. Para este cometido Trellis provee de dos distribucions empaquetadas por defecto, tanto para instalación manual como en formato Docker.

En el caso de la implementación triplestore, es capaz de soportar mediante configuración los siguientes Triplestores:

- En memoria
- TDB
- Otros externos mediante endpoint SPARQL (se ha probado con éxito la integración con Blazegraph y TDB externo con Apache Fuseki)

###### Generación de nuevos adaptadores

Trellis está diseñado para que sea posible generar un nuevo adaptador de la capa de persistencia. Para ello dispone de 2 interfaces que es preciso implementar:

- `org.trellisldp.api.ResourceService`
- `org.trellisldp.api.AuditService`

Los métodos que es necesario implementar son los siguiente:

```java
CompletableFuture<Resource> get(IRI identifier);

CompletableFuture<Void> create(IRI identifier, IRI interactionModel, Dataset dataset, IRI container, Binary binary);

CompletableFuture<Void> replace(IRI identifier, IRI interactionModel, Dataset dataset, IRI container, Binary binary);

CompletableFuture<Void> delete(IRI identifier, IRI container);
```

En este sentido, Trellis en su capa de persistencia utiliza Apache Jena, lo cual facilita la conexión con otros Triplestores, pudiendo aplicar aquí lo visto en la sección referente las [conclusiones sobre conectores](#conectores-con-tiple-stores) en la comparativa entre RDF4J y Jena.

Para generar la aplicación con esta nueva capa de persistencia, sería necesario generar un nuevo artefacto incluyendo esta librería en lugar de alguna de las que provee por defecto Trellis.

Esto mismo aplicaría también para el caso de querer modificar otra parte de la aplicación que sea preciso adaptara los requisitos del proyecto Hércules.

#### Prueba de Concepto

Se realizan dos pruebas de concepto:

##### Trellis sobre BBDD Relacional (postgresql)

- Arquitectura:

  - Servidor postgres:9.4
  - trellisldp/trellis-ext-db:latest

- docker-compose:

  ```yml
  version: "3"
  services:
    trellis:
      image: trellisldp/trellis-ext-db:latest
      environment:
        TRELLIS_DB_USERNAME: hercules
        TRELLIS_DB_PASSWORD: h3rcul3s
        TRELLIS_DB_URL: jdbc:postgresql://db/hercules-db
      ports:
        - 80:8080
      depends_on:
        - db
      volumes:
        - /local/trellis/data:/opt/trellis/data
        - /local/trellis/log:/opt/trellis/log
        # Please see note below about the ./etc directory
        # - /local/trellis/etc:/opt/trellis/etc
    db:
      image: postgres:9.4
      environment:
        POSTGRES_DB: hercules-db
        POSTGRES_PASSWORD: h3rcul3s
        POSTGRES_USER: hercules
        PGDATA: /var/lib/postgresql/data
      ports:
        - 5432:5432
      volumes:
        - postgres:/var/lib/postgresql/data
  volumes:
    postgres: 
  ```

##### Trellis sobre Triple Store (BlazeGraph)

- Arquitectura:

  - nawer/blazegraph:2.1.5
  - trellisldp/trellis:latest

- docker-compose:

  ```yml
  version: "3.1"
  services:
    trellis:
      image: trellisldp/trellis:latest
      environment:
        JAVA_OPTS: "-Xms250m -Xmx1024m"
      ports:
        - 8080:8080
      depends_on:
        - db
      volumes:
        #  file-based resources (e.g. binaries and mementos), application logs and configuration files
        - ./trellis/data:/opt/trellis/data
        - ./trellis/log:/opt/trellis/log
        # Please see note below about the ./etc directory
        - ./trellis/config:/opt/trellis/etc
    db:
      # Blazegraph Triplestore
      # Endpoint at http://db:9999/blazegraph/namespace/kb/sparql
      # Docs at https://github.com/nawerprod/blazegraph
      image: nawer/blazegraph:2.1.5
      environment:
        JAVA_XMS: 512m
        JAVA_XMX: 1g
      volumes:
        - ./blazegraph/data:/var/lib/blazegraph
      ports:
        - "9999:9999"
  ```

- fichero de configuración trellis **config.yml** en ruta **./trellis/config**

  ```yml
  binaries: /opt/trellis/data/binaries
  
  mementos: /opt/trellis/data/mementos
  
  namespaces: /opt/trellis/data/namespaces.json
  
  # This may refer to a static base URL for resources. If left empty, the
  # base URL will reflect the Host header in the request.
  baseUrl:
  
  # This configuration will enable a WebSub "hub" header.
  hubUrl:
  
  auth:
      adminUsers: []
      webac:
          enabled: true
      jwt:
          enabled: false
          key: changeme
      basic:
          enabled: true
          usersFile: /opt/trellis/etc/users.auth
  
  cors:
      enabled: true
      allowOrigin:
          - "*"
      maxAge: 180
  
  cache:
      maxAge: 86400
      mustRevalidate: true
  
  notifications:
      enabled: false
      type: JMS
      topicName: "trellis"
      connectionString: "tcp://localhost:61616"
  
  # JSON-LD configuration
  jsonld:
      cacheSize: 10
      cacheExpireHours: 24
      contextWhitelist: []
      contextDomainWhitelist: []
  ```

##### Prueba de concepto

###### BlazeGraph

Es el triple store seleccionado para la realizar la PoC. Merece especial atención por las siguientes características:

- Expone un endpoint Sparql (http://localhost:9999/blazegraph/#query), en apariencia, bastante completo

  ![image-20200226104816659](https://i.ibb.co/WH1KMYP/blazegraph-endpoint.png)

  - Ejemplo de query de obtención de datos 

    ```sql
    SELECT ?subject ?predicate ?object
    WHERE {<http://www.hercules.fake/data/Researcher/1> ?predicate ?object} 
    LIMIT 100
    ```

  - Ejemplo de query de inserción en formato RDF/XML

    ```xml
    <?xml version="1.0"?>
    <rdf:RDF
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
    xmlns:cd="http://www.hercules.fake/data/Researcher#"> 
    <rdf:Description
     rdf:about="http://www.hercules.fake/data/Researcher/1">
      <cd:name>Daniel Ruiz Santamaría</cd:name>
      <cd:country>Spain</cd:country>
      <cd:company>Izertis</cd:company>
      <cd:rol>Software Architech</cd:rol>
      <cd:year>2019</cd:year>
    </rdf:Description>
    <rdf:Description
     rdf:about="http://www.hercules.fake/data/Researcher/2">
      <cd:name>Rubén Gavilán Fernandez</cd:name>
      <cd:country>Spain</cd:country>
      <cd:company>Izertis</cd:company>
      <cd:rol>Software Architech</cd:rol>
      <cd:year>2019</cd:year>
    </rdf:Description>
    </rdf:RDF>  
    ```
  
- Despliega un [NanoSparqlServer](https://github.com/blazegraph/database/wiki/NanoSparqlServer), (http://localhost:9999/bigdata/sparql) para actuar como API Rest LDP. ¿Puede realizar una función similar a Trellis?

- Alto rendimiento, soporta 50 Billones de nodos en una sola nodo

- Usado en producción en clientes Fortune 500 como Autodesk, EMC y otros

##### Trellis sobre Triple Store (TDB con Apache Fuseki) y conexión a Apache Kafka

- Arquitectura:

  - nawer/blazegraph:2.1.5
  - trellisldp/jpms.app.triplestore.5:0.7.0
  - zookeeper:3.5 (3 nodos)
  - trellisldp/kafka:1.1.0
  - trellisldp/jetty-fuseki:3.7.0

- docker-compose:

  ```yml
  version: "3"
  
  services:
    zoo1:
      image: zookeeper:3.5
      container_name: zoo1
      restart: always
      hostname: zoo1
      ports:
         - "2181:2181"
         - "8500:8090"
      environment:
          ZOO_MY_ID: 1
          ZOO_SERVERS: server.1=zoo1:2888:3888;2181 server.2=zoo2:2888:3888;2182 server.3=zoo3:2888:3888;2183
  
    zoo2:
      image: zookeeper:3.5
      restart: always
      hostname: zoo2
      ports:
         - "2182:2181"
      environment:
          ZOO_MY_ID: 2
          ZOO_SERVERS: server.1=zoo1:2888:3888;2181 server.2=zoo2:2888:3888;2182 server.3=zoo3:2888:3888;2183
  
    zoo3:
      image: zookeeper:3.5
      restart: always
      hostname: zoo3
      ports:
         - "2183:2181"
      environment:
          ZOO_MY_ID: 3
          ZOO_SERVERS: server.1=zoo1:2888:3888;2181 server.2=zoo2:2888:3888;2182 server.3=zoo3:2888:3888;2183
  
    kafka:
      image: trellisldp/kafka:1.1.0
      ports:
          - "9094:9094"
          - "1099:1099"
      environment:
        HOSTNAME_COMMAND: "ifconfig|grep inet|head -1|sed 's/\\:/ /'|awk '{print $$3}'"
        KAFKA_ZOOKEEPER_CONNECT: zoo1:2181
        KAFKA_ADVERTISED_LISTENERS: INSIDE://:9092,OUTSIDE://_{HOSTNAME_COMMAND}:9094
        KAFKA_LISTENERS: INSIDE://:9092,OUTSIDE://:9094
        KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: INSIDE:PLAINTEXT,OUTSIDE:PLAINTEXT
        KAFKA_INTER_BROKER_LISTENER_NAME: INSIDE
       # KAFKA_JMX_OPTS: "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=127.0.0.1 -Dcom.sun.management.jmxremote.rmi.port=1099"
       # JMX_PORT: 1099
        KAFKA_MESSAGE_MAX_BYTES: 5000000
      volumes:
        - kafka-data-volume:/kafka
  
    trellis:
      image: trellisldp/jpms.app.triplestore.5:0.7.0
      container_name: trellis
      restart: always
      ports:
        - "8080:8080"
        - "8445:8445"
        - "8502:8081"
      depends_on:
        - jetty-fuseki
      volumes:
        - trellis-binary-volume:/mnt/binaries
        - ./etc/config.yml:/opt/trellis/etc/config.yml
        - ./etc/namespaces.json:/opt/trellis/etc/namespaces.json
        - ./etc/users.auth:/opt/trellis/etc/users.auth
  
    jetty-fuseki:
      image: trellisldp/jetty-fuseki:3.7.0
      container_name: fuseki
      restart: always
      environment:
          JAVA_OPTIONS: -Xmx8G -Xss8M
      ports:
        - "3030:8080"
      volumes:
        - triplestore-data-volume:/etc/fuseki/databases/trellis_data
        - triplestore-backup-volume:/etc/fuseki/backups
        - ./fuseki-conf/trellis.ttl:/etc/fuseki/configuration/trellis.ttl
        - ./fuseki-conf/shiro.ini:/etc/fuseki/shiro.ini
        - ./fuseki-conf/log4j.properties:/etc/fuseki/log4j.properties
  
  volumes:
    trellis-binary-volume:
    kafka-data-volume:
    triplestore-data-volume:
    triplestore-backup-volume:
  
  ```

- fichero de configuración trellis **config.yml** en ruta **./etc/**

  ```yml
  server:
    applicationConnectors:
      - type: http
        port: 8080
      - type: h2c
        port: 8445
    requestLog:
      appenders:
        - type: file
          currentLogFilename: /opt/trellis/log/access.log
          archive: true
          archivedLogFilenamePattern: /opt/trellis/log/access-%i.log
          archivedFileCount: 5
          maxFileSize: 2m
  
  logging:
    level: WARN
    appenders:
      - type: console
      - type: file
        currentLogFilename: /opt/trellis/log/trellis.log
        archive: true
        archivedLogFilenamePattern: /opt/trellis/log/trellis-%i.log
        archivedFileCount: 5
        maxFileSize: 2m
    loggers:
      org.trellisldp: DEBUG
      io.dropwizard: DEBUG
  
  binaries: /mnt/binaries
  
  resources: http://fuseki:8080/fuseki/trellis
  
  # FILESYSTEM
  #resources: /var/lib/trellis/resources
  
  # JETTY LOCALHOST
  #resources: http://dockerhost:8900/fuseki/trellis
  
  mementos: /var/lib/trellis/mementos
  
  #baseUrl: https://localhost:8445/
  
  namespaces: /opt/trellis/etc/namespaces.json
  
  auth:
      webac:
          enabled: true
      anon:
          enabled: true
      jwt:
          enabled: true
          base64Encoded: false
          key: secret
      basic:
          enabled: false
          usersFile: /opt/trellis/etc/users.auth
  
  cors:
      enabled: true
      allowOrigin:
          - "*"
      maxAge: 180
  
  notifications:
      max.request.size: 5000000
      enabled: true
      type: kafka
      topicName: "trellis"
      connectionString: "kafka:9094"
  
  # JSON-LD configuration
  jsonld:
      cacheSize: 10
      cacheExpireHours: 24
      contextWhitelist: []
      contextDomainWhitelist: []
  
  assets:
      template: org/trellisldp/rdfa/resource-table.mustache
      js:
          - "https://unpkg.com/vanilla-datatables@latest/dist/vanilla-dataTables.min.js"
          - "http://localhost:8080/table.js"
      css:
          - "http://localhost:8080/trellis.css"
  
  ```

##### Prueba de concepto

###### Fuseki

Es un servidor SPARQL, que puede proporcionar capa de seguridad por medio de Apache Shiro. Implementa el protocola SPARQL 1.1 para consultar y actualizar datos de el triple store

Integra TDB, como Triple Store, proporcionando una capa transaccional de persistencia robusta. Además, si fuese necesario puede proporcionar una capa SPARQL para cualquier triple store, seria un componente reutilizable.

- Expone un endpoint Sparql (http://localhost:3030/fuseki), en apariencia, bastante completo

  ![image-20200226104816659](https://i.ibb.co/WH1KMYP/blazegraph-endpoint.png)

  - Además es posible atacar su API directamente:

    - Petición

    ```http
    POST /fuseki/trellis/query?query=PREFIX+un%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2007%2Font%2Funit%23%3E%0APREFIX+uni%3A+%3Chttp%3A%2F%2Fpurl.org%2Fweso%2Funi%2Funi.html%23%3E%0Aprefix+univ%3A%3Chttp%3A%2F%2Fpeople.brunel.ac.uk%2F~csstnns%2Funiversity.owl%23%3E%0Aprefix+sp%3A%3Chttp%3A%2F%2Fwww.meta-qsar.org%2Fontologies%2Fsport.owl%23%3E%0Aprefix+rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0A%0ASELECT+%3Fsubject+%3Fpredicate+%3Fobject%0A%09WHERE+%7B%0A+%09%09+%3Fsubject+%3Fpredicate+%3Fobject%0A%09%7D HTTP/1.1
    Host: localhost:3030
    Accept: application/sparql-results+json,*/*;q=0.9
    ```

    - Respuesta

    ```
    {
      "head": {
        "vars": [
          "subject",
          "predicate",
          "object"
        ]
      },
      "results": {
        "bindings": [
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/ldp#BasicContainer"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/"
            },
            "predicate": {
              "type": "uri",
              "value": "http://purl.org/dc/terms/modified"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:09:51.660696Z"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/#auth"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/auth/acl#mode"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/auth/acl#Read"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/#auth"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/auth/acl#mode"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/auth/acl#Write"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/#auth"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/auth/acl#mode"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/auth/acl#Control"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/#auth"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/auth/acl#agentClass"
            },
            "object": {
              "type": "uri",
              "value": "http://xmlns.com/foaf/0.1/Agent"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/#auth"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/auth/acl#accessTo"
            },
            "object": {
              "type": "uri",
              "value": "trellis:data/"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/ldp#BasicContainer"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic"
            },
            "predicate": {
              "type": "uri",
              "value": "http://purl.org/dc/terms/modified"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:13:18.561635Z"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic"
            },
            "predicate": {
              "type": "uri",
              "value": "http://purl.org/dc/terms/isPartOf"
            },
            "object": {
              "type": "uri",
              "value": "trellis:data/"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic"
            },
            "predicate": {
              "type": "uri",
              "value": "http://purl.org/dc/terms/title"
            },
            "object": {
              "type": "literal",
              "value": "Another Basic Container"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasGeneratedBy"
            },
            "object": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1dfb55ec42-066e-4f52-b301-53e0f53f732a"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1dfb55ec42-066e-4f52-b301-53e0f53f732a"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#Activity"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1dfb55ec42-066e-4f52-b301-53e0f53f732a"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "https://www.w3.org/ns/activitystreams#Create"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1dfb55ec42-066e-4f52-b301-53e0f53f732a"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasAssociatedWith"
            },
            "object": {
              "type": "uri",
              "value": "http://www.trellisldp.org/ns/trellis#AnonymousAgent"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1dfb55ec42-066e-4f52-b301-53e0f53f732a"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#atTime"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:09:51.615106Z"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/de0d6c74-be44-465f-9938-0722edc2d36f"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/ldp#Resource"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/de0d6c74-be44-465f-9938-0722edc2d36f"
            },
            "predicate": {
              "type": "uri",
              "value": "http://purl.org/dc/terms/modified"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:10:28.694309Z"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/de0d6c74-be44-465f-9938-0722edc2d36f"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasGeneratedBy"
            },
            "object": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d36a7cfea-8eaa-4fbb-8ed9-a8232b5da2a4"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/de0d6c74-be44-465f-9938-0722edc2d36f"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasGeneratedBy"
            },
            "object": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1db06783d2-d181-48ca-b66e-539392cfe8a7"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/de0d6c74-be44-465f-9938-0722edc2d36f"
            },
            "predicate": {
              "type": "uri",
              "value": "http://purl.org/dc/terms/type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.trellisldp.org/ns/trellis#DeletedResource"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d36a7cfea-8eaa-4fbb-8ed9-a8232b5da2a4"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#Activity"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d36a7cfea-8eaa-4fbb-8ed9-a8232b5da2a4"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "https://www.w3.org/ns/activitystreams#Create"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d36a7cfea-8eaa-4fbb-8ed9-a8232b5da2a4"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasAssociatedWith"
            },
            "object": {
              "type": "uri",
              "value": "http://www.trellisldp.org/ns/trellis#AnonymousAgent"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d36a7cfea-8eaa-4fbb-8ed9-a8232b5da2a4"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#atTime"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:10:28.556225Z"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1db06783d2-d181-48ca-b66e-539392cfe8a7"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#Activity"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1db06783d2-d181-48ca-b66e-539392cfe8a7"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "https://www.w3.org/ns/activitystreams#Delete"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1db06783d2-d181-48ca-b66e-539392cfe8a7"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasAssociatedWith"
            },
            "object": {
              "type": "uri",
              "value": "http://www.trellisldp.org/ns/trellis#AnonymousAgent"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1db06783d2-d181-48ca-b66e-539392cfe8a7"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#atTime"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:10:28.693291Z"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/72f24f5a-91a1-4bb9-a8da-f618688f2648"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/ldp#RDFSource"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/72f24f5a-91a1-4bb9-a8da-f618688f2648"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://example.com/ns#Bug"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/72f24f5a-91a1-4bb9-a8da-f618688f2648"
            },
            "predicate": {
              "type": "uri",
              "value": "http://purl.org/dc/terms/modified"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:10:30.863477Z"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/72f24f5a-91a1-4bb9-a8da-f618688f2648"
            },
            "predicate": {
              "type": "uri",
              "value": "http://purl.org/dc/terms/isPartOf"
            },
            "object": {
              "type": "uri",
              "value": "trellis:data/basic"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/72f24f5a-91a1-4bb9-a8da-f618688f2648"
            },
            "predicate": {
              "type": "uri",
              "value": "http://purl.org/dc/terms/title"
            },
            "object": {
              "type": "literal",
              "value": "Another bug to test."
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/72f24f5a-91a1-4bb9-a8da-f618688f2648"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasGeneratedBy"
            },
            "object": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d763decdd-58fd-444e-8b3b-de5575cf925e"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/72f24f5a-91a1-4bb9-a8da-f618688f2648"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasGeneratedBy"
            },
            "object": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d8cc3c959-16dd-4ee0-941b-e7c54c18fb3f"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/72f24f5a-91a1-4bb9-a8da-f618688f2648"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasGeneratedBy"
            },
            "object": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1da4bb9c23-c342-4006-a932-27c2cfbaea2d"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/72f24f5a-91a1-4bb9-a8da-f618688f2648"
            },
            "predicate": {
              "type": "uri",
              "value": "http://example.com/ns#severity"
            },
            "object": {
              "type": "literal",
              "value": "High"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/72f24f5a-91a1-4bb9-a8da-f618688f2648"
            },
            "predicate": {
              "type": "uri",
              "value": "http://purl.org/dc/terms/description"
            },
            "object": {
              "type": "literal",
              "value": "Issues that need to be fixed."
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d763decdd-58fd-444e-8b3b-de5575cf925e"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#Activity"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d763decdd-58fd-444e-8b3b-de5575cf925e"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "https://www.w3.org/ns/activitystreams#Create"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d763decdd-58fd-444e-8b3b-de5575cf925e"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasAssociatedWith"
            },
            "object": {
              "type": "uri",
              "value": "http://www.trellisldp.org/ns/trellis#AnonymousAgent"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d763decdd-58fd-444e-8b3b-de5575cf925e"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#atTime"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:10:30.569222Z"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d8cc3c959-16dd-4ee0-941b-e7c54c18fb3f"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#Activity"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d8cc3c959-16dd-4ee0-941b-e7c54c18fb3f"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "https://www.w3.org/ns/activitystreams#Delete"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d8cc3c959-16dd-4ee0-941b-e7c54c18fb3f"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasAssociatedWith"
            },
            "object": {
              "type": "uri",
              "value": "http://www.trellisldp.org/ns/trellis#AnonymousAgent"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d8cc3c959-16dd-4ee0-941b-e7c54c18fb3f"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#atTime"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:10:30.671473Z"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1da4bb9c23-c342-4006-a932-27c2cfbaea2d"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#Activity"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1da4bb9c23-c342-4006-a932-27c2cfbaea2d"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "https://www.w3.org/ns/activitystreams#Create"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1da4bb9c23-c342-4006-a932-27c2cfbaea2d"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasAssociatedWith"
            },
            "object": {
              "type": "uri",
              "value": "http://www.trellisldp.org/ns/trellis#AnonymousAgent"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1da4bb9c23-c342-4006-a932-27c2cfbaea2d"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#atTime"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:10:30.861691Z"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/2923dcfc-bab9-4f29-93ad-05b3ed2ceac5"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/ldp#Resource"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/2923dcfc-bab9-4f29-93ad-05b3ed2ceac5"
            },
            "predicate": {
              "type": "uri",
              "value": "http://purl.org/dc/terms/modified"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:12:56.947562Z"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/2923dcfc-bab9-4f29-93ad-05b3ed2ceac5"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasGeneratedBy"
            },
            "object": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d726a5cee-343a-4ebe-b75d-52cd7c2769a1"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/2923dcfc-bab9-4f29-93ad-05b3ed2ceac5"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasGeneratedBy"
            },
            "object": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1dd42c55a4-d185-4cdf-a44c-e7029323b9cd"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/2923dcfc-bab9-4f29-93ad-05b3ed2ceac5"
            },
            "predicate": {
              "type": "uri",
              "value": "http://purl.org/dc/terms/type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.trellisldp.org/ns/trellis#DeletedResource"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d726a5cee-343a-4ebe-b75d-52cd7c2769a1"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#Activity"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d726a5cee-343a-4ebe-b75d-52cd7c2769a1"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "https://www.w3.org/ns/activitystreams#Create"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d726a5cee-343a-4ebe-b75d-52cd7c2769a1"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasAssociatedWith"
            },
            "object": {
              "type": "uri",
              "value": "http://www.trellisldp.org/ns/trellis#AnonymousAgent"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d726a5cee-343a-4ebe-b75d-52cd7c2769a1"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#atTime"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:12:56.597678Z"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1dd42c55a4-d185-4cdf-a44c-e7029323b9cd"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#Activity"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1dd42c55a4-d185-4cdf-a44c-e7029323b9cd"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "https://www.w3.org/ns/activitystreams#Delete"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1dd42c55a4-d185-4cdf-a44c-e7029323b9cd"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasAssociatedWith"
            },
            "object": {
              "type": "uri",
              "value": "http://www.trellisldp.org/ns/trellis#AnonymousAgent"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1dd42c55a4-d185-4cdf-a44c-e7029323b9cd"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#atTime"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:12:56.947237Z"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/66717854-4149-4202-9bef-6383980e0ce8"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/ldp#RDFSource"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/66717854-4149-4202-9bef-6383980e0ce8"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://example.com/ns#Bug"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/66717854-4149-4202-9bef-6383980e0ce8"
            },
            "predicate": {
              "type": "uri",
              "value": "http://purl.org/dc/terms/modified"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:13:07.232997Z"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/66717854-4149-4202-9bef-6383980e0ce8"
            },
            "predicate": {
              "type": "uri",
              "value": "http://purl.org/dc/terms/isPartOf"
            },
            "object": {
              "type": "uri",
              "value": "trellis:data/basic"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/66717854-4149-4202-9bef-6383980e0ce8"
            },
            "predicate": {
              "type": "uri",
              "value": "http://purl.org/dc/terms/title"
            },
            "object": {
              "type": "literal",
              "value": "Another bug to test."
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/66717854-4149-4202-9bef-6383980e0ce8"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasGeneratedBy"
            },
            "object": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d24bc20de-7f77-4acd-82f2-68ad00abece0"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/66717854-4149-4202-9bef-6383980e0ce8"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasGeneratedBy"
            },
            "object": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d9d10a0c3-00c7-4c0f-9d8d-c3418bd9c06f"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/66717854-4149-4202-9bef-6383980e0ce8"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasGeneratedBy"
            },
            "object": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1dc4f2de56-dc3f-46e3-b027-30a8e8b458ff"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/66717854-4149-4202-9bef-6383980e0ce8"
            },
            "predicate": {
              "type": "uri",
              "value": "http://example.com/ns#severity"
            },
            "object": {
              "type": "literal",
              "value": "High"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/66717854-4149-4202-9bef-6383980e0ce8"
            },
            "predicate": {
              "type": "uri",
              "value": "http://purl.org/dc/terms/description"
            },
            "object": {
              "type": "literal",
              "value": "Issues that need to be fixed."
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d24bc20de-7f77-4acd-82f2-68ad00abece0"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#Activity"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d24bc20de-7f77-4acd-82f2-68ad00abece0"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "https://www.w3.org/ns/activitystreams#Create"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d24bc20de-7f77-4acd-82f2-68ad00abece0"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasAssociatedWith"
            },
            "object": {
              "type": "uri",
              "value": "http://www.trellisldp.org/ns/trellis#AnonymousAgent"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d24bc20de-7f77-4acd-82f2-68ad00abece0"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#atTime"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:13:07.014343Z"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d9d10a0c3-00c7-4c0f-9d8d-c3418bd9c06f"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#Activity"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d9d10a0c3-00c7-4c0f-9d8d-c3418bd9c06f"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "https://www.w3.org/ns/activitystreams#Delete"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d9d10a0c3-00c7-4c0f-9d8d-c3418bd9c06f"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasAssociatedWith"
            },
            "object": {
              "type": "uri",
              "value": "http://www.trellisldp.org/ns/trellis#AnonymousAgent"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d9d10a0c3-00c7-4c0f-9d8d-c3418bd9c06f"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#atTime"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:13:07.139548Z"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1dc4f2de56-dc3f-46e3-b027-30a8e8b458ff"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#Activity"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1dc4f2de56-dc3f-46e3-b027-30a8e8b458ff"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "https://www.w3.org/ns/activitystreams#Create"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1dc4f2de56-dc3f-46e3-b027-30a8e8b458ff"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasAssociatedWith"
            },
            "object": {
              "type": "uri",
              "value": "http://www.trellisldp.org/ns/trellis#AnonymousAgent"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1dc4f2de56-dc3f-46e3-b027-30a8e8b458ff"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#atTime"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:13:07.229718Z"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/62b10f4d-8fb9-4816-b767-9a2235f15ce7"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/ldp#Resource"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/62b10f4d-8fb9-4816-b767-9a2235f15ce7"
            },
            "predicate": {
              "type": "uri",
              "value": "http://purl.org/dc/terms/modified"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:13:16.655819Z"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/62b10f4d-8fb9-4816-b767-9a2235f15ce7"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasGeneratedBy"
            },
            "object": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d3dab139f-bef7-4f52-b10d-b2fc43f29261"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/62b10f4d-8fb9-4816-b767-9a2235f15ce7"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasGeneratedBy"
            },
            "object": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d7249295f-6225-490e-afe4-4aba5087db06"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/62b10f4d-8fb9-4816-b767-9a2235f15ce7"
            },
            "predicate": {
              "type": "uri",
              "value": "http://purl.org/dc/terms/type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.trellisldp.org/ns/trellis#DeletedResource"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d3dab139f-bef7-4f52-b10d-b2fc43f29261"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#Activity"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d3dab139f-bef7-4f52-b10d-b2fc43f29261"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "https://www.w3.org/ns/activitystreams#Create"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d3dab139f-bef7-4f52-b10d-b2fc43f29261"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasAssociatedWith"
            },
            "object": {
              "type": "uri",
              "value": "http://www.trellisldp.org/ns/trellis#AnonymousAgent"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d3dab139f-bef7-4f52-b10d-b2fc43f29261"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#atTime"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:13:16.478981Z"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d7249295f-6225-490e-afe4-4aba5087db06"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#Activity"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d7249295f-6225-490e-afe4-4aba5087db06"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "https://www.w3.org/ns/activitystreams#Delete"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d7249295f-6225-490e-afe4-4aba5087db06"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasAssociatedWith"
            },
            "object": {
              "type": "uri",
              "value": "http://www.trellisldp.org/ns/trellis#AnonymousAgent"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d7249295f-6225-490e-afe4-4aba5087db06"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#atTime"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:13:16.655469Z"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/7f2ade30-1c6c-41f8-842b-8f6221802cab"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/ldp#RDFSource"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/7f2ade30-1c6c-41f8-842b-8f6221802cab"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://example.com/ns#Bug"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/7f2ade30-1c6c-41f8-842b-8f6221802cab"
            },
            "predicate": {
              "type": "uri",
              "value": "http://purl.org/dc/terms/modified"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:13:18.561635Z"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/7f2ade30-1c6c-41f8-842b-8f6221802cab"
            },
            "predicate": {
              "type": "uri",
              "value": "http://purl.org/dc/terms/isPartOf"
            },
            "object": {
              "type": "uri",
              "value": "trellis:data/basic"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/7f2ade30-1c6c-41f8-842b-8f6221802cab"
            },
            "predicate": {
              "type": "uri",
              "value": "http://purl.org/dc/terms/title"
            },
            "object": {
              "type": "literal",
              "value": "Another bug to test."
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/7f2ade30-1c6c-41f8-842b-8f6221802cab"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasGeneratedBy"
            },
            "object": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d58a65ddf-48d3-490d-98b5-edcca9d48e9a"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/7f2ade30-1c6c-41f8-842b-8f6221802cab"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasGeneratedBy"
            },
            "object": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d2b241dd5-d710-4579-9213-7089a36288c0"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/7f2ade30-1c6c-41f8-842b-8f6221802cab"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasGeneratedBy"
            },
            "object": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d8346c9f3-7e02-43ef-8d6b-f508b52bd17e"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/7f2ade30-1c6c-41f8-842b-8f6221802cab"
            },
            "predicate": {
              "type": "uri",
              "value": "http://example.com/ns#severity"
            },
            "object": {
              "type": "literal",
              "value": "High"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:data/basic/7f2ade30-1c6c-41f8-842b-8f6221802cab"
            },
            "predicate": {
              "type": "uri",
              "value": "http://purl.org/dc/terms/description"
            },
            "object": {
              "type": "literal",
              "value": "Issues that need to be fixed."
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d58a65ddf-48d3-490d-98b5-edcca9d48e9a"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#Activity"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d58a65ddf-48d3-490d-98b5-edcca9d48e9a"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "https://www.w3.org/ns/activitystreams#Create"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d58a65ddf-48d3-490d-98b5-edcca9d48e9a"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasAssociatedWith"
            },
            "object": {
              "type": "uri",
              "value": "http://www.trellisldp.org/ns/trellis#AnonymousAgent"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d58a65ddf-48d3-490d-98b5-edcca9d48e9a"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#atTime"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:13:18.269274Z"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d2b241dd5-d710-4579-9213-7089a36288c0"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#Activity"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d2b241dd5-d710-4579-9213-7089a36288c0"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "https://www.w3.org/ns/activitystreams#Delete"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d2b241dd5-d710-4579-9213-7089a36288c0"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasAssociatedWith"
            },
            "object": {
              "type": "uri",
              "value": "http://www.trellisldp.org/ns/trellis#AnonymousAgent"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d2b241dd5-d710-4579-9213-7089a36288c0"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#atTime"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:13:18.367935Z"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d8346c9f3-7e02-43ef-8d6b-f508b52bd17e"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#Activity"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d8346c9f3-7e02-43ef-8d6b-f508b52bd17e"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
            },
            "object": {
              "type": "uri",
              "value": "https://www.w3.org/ns/activitystreams#Create"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d8346c9f3-7e02-43ef-8d6b-f508b52bd17e"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#wasAssociatedWith"
            },
            "object": {
              "type": "uri",
              "value": "http://www.trellisldp.org/ns/trellis#AnonymousAgent"
            }
          },
          {
            "subject": {
              "type": "uri",
              "value": "trellis:bnode/1ce4fc42-ef3d-4842-8a3f-37e9d1901d1d8346c9f3-7e02-43ef-8d6b-f508b52bd17e"
            },
            "predicate": {
              "type": "uri",
              "value": "http://www.w3.org/ns/prov#atTime"
            },
            "object": {
              "type": "literal",
              "datatype": "http://www.w3.org/2001/XMLSchema#dateTime",
              "value": "2020-03-10T12:13:18.555521Z"
            }
          }
        ]
      }
    }
    ```

  - O mediante su interface grafica:

    ![fuseki](https://i.ibb.co/Z1HJZ5Y/fuseki.png)


#### Trellis

Se realizan pruebas mínimas como la creación de contenedores y recursos. La documentación de Trellis parece no estar actualizada (no funciona), y por lo tanto, se realizan las pruebas, siguiendo las especificaciones de la [LDP](https://www.w3.org/TR/ldp-primer/). No todas las operaciones funcionan correctamente, por ejemplo, es necesario sustituir las operaciones POST, indicadas en la LDP, por operaciones PUT

- Creación de del contenedor researcher (PUT)

```
PUT /researcher/ HTTP/1.1
Host: localhost:8080/researcher
Content-Type: text/turtle
Link: <http://www.w3.org/ns/ldp/BasicContainer>; rel="type"

@prefix ldp: <http://www.w3.org/ns/ldp#> .
@prefix dcterms: <http://purl.org/dc/terms/> .
 
<> a ldp:Container, ldp:BasicContainer;
   dcterms:title "Researcher" ; 
   dcterms:description "This container will contain Researchers" . 
```

* Visualización del nuevo contenedor, sobre ruta raíz 

  * Petición

    ```
    GET / HTTP/1.1
    Host: localhost:8080
    Host: localhost:8080/researcher
    ```

  * Respuesta

    ```
    @prefix ldp:  <http://www.w3.org/ns/ldp#> .
    @prefix dcterms:  <http://purl.org/dc/terms/> .
    @prefix foaf:  <http://xmlns.com/foaf/0.1/> .
    
    <http://localhost:8080/>
            <http://www.w3.org/1999/02/22-rdf-syntax-ns#type>  ldp:BasicContainer ;
            ldp:contains  <http://localhost:8080/researcher> .
    ```

- Visualización del nuevo contenedor, sobre ruta **/researcher**, donde podemos ver los atributos del contenedor
  - Petición

    ```
    GET /researcher HTTP/1.1
    Host: localhost:8080
    Host: localhost:8080/researcher
    Content-Type: text/turtle
    Link: <http://www.w3.org/ns/ldp/BasicContainer>; rel="type"
    ```

  - Respuesta

    ```
    @prefix ldp:  <http://www.w3.org/ns/ldp#> .
    @prefix dcterms:  <http://purl.org/dc/terms/> .
    @prefix foaf:  <http://xmlns.com/foaf/0.1/> .
    
    <http://localhost:8080/researcher>
            dcterms:description  "This container will contain Researchers" ;
            dcterms:title        "Researcher" ;
            <http://www.w3.org/1999/02/22-rdf-syntax-ns#type>  ldp:RDFSource .
    ```

- Crear un nuevo recurso dentro del contenedor
  - Petición

    ```
    PUT /researcher? HTTP/1.1
    Host: localhost:8080
    Host: localhost:8080/researcher
    Link: <http://www.w3.org/ns/ldp#Resource>; rel = "type" 
    Slug: r2
    Content-Type: text/turtle
    
    @prefix dc: <http://purl.org/dc/terms/> .
    @prefix foaf: <http://xmlns.com/foaf/0.1/> .
    
    <> a foaf:account;
        foaf:primaryTopic <#r2> ;
        dc:title 'Data of researcher 2' .
    
    <#r2> a foaf:Person;
        foaf:name 'Researcher 2'  ;
        foaf:title 'Doctor 2'  ;
        foaf:age 40  .
    ```

- Visualización del nuevo recurso, sobre ruta **/researcher/#2**, donde podemos ver los atributos del recurso

  - Petición

    ```
    GET /researcher HTTP/1.1
    Host: localhost:8080
    Host: localhost:8080/researcher
    Content-Type: text/turtle
    Link: <http://www.w3.org/ns/ldp/BasicContainer>; rel="type"
    Slug: r2
    ```

  - Respuesta

    ```
    @prefix ldp:  <http://www.w3.org/ns/ldp#> .
    @prefix dcterms:  <http://purl.org/dc/terms/> .
    @prefix foaf:  <http://xmlns.com/foaf/0.1/> .
    
    <http://localhost:8080/researcher>
            <http://www.w3.org/1999/02/22-rdf-syntax-ns#type>  foaf:account ;
            foaf:primaryTopic  <http://localhost:8080/researcher#r2> ;
            dcterms:title      "Data of researcher 2" .
    
    <http://localhost:8080/researcher#r2>
            <http://www.w3.org/1999/02/22-rdf-syntax-ns#type>  foaf:Person ;
            foaf:age    40 ;
            foaf:name   "Researcher 2" ;
            foaf:title  "Doctor 2" .
    
    <http://localhost:8080/researcher>
            <http://www.w3.org/1999/02/22-rdf-syntax-ns#type>  ldp:RDFSource .
    ```



##### Comentarios sobre la prueba de concepto

###### Ventajas

Trellis conceptualmente, tiene un enfoque muy atractivo por los siguientes motivos:

- Por un lado, facilita la integración de múltiples bases de datos ya sean relacionales ya sean triples stores
- Por otro lado facilita una capa de autenticación / autorización mediante el uso de OAuth y tokens JWT, pudiendo definir permisos mediante el módulo WebAC
- Además es fácilmente integrable con sistemas distribuidos o microservicios debido a su integración  con kafka, publicando en los topics establecidos el resultado de cualquier interacción con su API.
- Su API sigue el standard  expuesto por la [LDP](https://www.w3.org/TR/ldp-primer/)
- Recuperable cualquier versión de un contenedor o recurso por medio del uso de memento

###### Desventajas

Se trata de una herramienta con muchas posibilidades pero también dispone de algún pero:

- Apenas existe documentación al respecto, y la que hay no esta actualizada.
- La propia versión del proyecto (0.10.0), habla de su estado de inmadurez relativa.
- No se encuentran ejemplos de uso, por lo que se infiere que la permeabilidad en proyectos reales es muy baja.

#### Adaptación de Trellis

Tras la primera prueba de concepto se analiza cómo de factible es modificar Trellis. Las opción más directa a priori pasaría por modificar directamente el código de Trellis pero esto tendría las siguientes desventajas:

- Compilación del producto completo cuando solamente se pretenden modificar ciertos módulos
- Dificultad en las actualizaciones de versión de Trellis ya que habría que hacer un merge con los cambios subidos al respositorio de Trellis
- Necesidad de entender exactamente cómo está montado Trellis
- Utilización de las herramientas de desarrollo de Trellis (gradle, etc.)

Dado que trellis dispone de una arquitecura modular, y teniendo en cuenta que todas librerias (módulos) están disponibles a través de repositorios Maven, la mejor opción sería aprovechar estos artefactos que ya están previamente compilados, añadiendo nuevos artefactos con la lógica de la aplicación que se quiere añadir / adaptar.

Trellis está compuesto de varios módulos que se ensamblan en una única aplicación. Para hacer este ensamblado se ha generado un proyecto que contiene como dependencia todas aquellas librerías que contiene trellis además de las nuevas que se añadan:

- trellis-triplestore
- trellis-constraint-rules
- trellis-io-jena
- trellis-api
- trellis-http
- trellis-app
- trellis-cache
- trellis-dropwizard
- trellis-vocabulary
- trellis-file
- trellis-namespaces
- trellis-audit
- trellis-event-jackson
- trellis-webac
- trellis-jms
- trellis-rdfa
- trellis-kafka
- trellis-auth-oauth
- trellis-auth-basic

En caso que se quiera modificar una de ellas, como por ejemplo la capa de persistencia, sería necesario sustituir la librería `trellis-triplestore` por una nueva personalizada.

Para generar el empaquetado con todas estas librerías se utiliza el [framework dropwizard](https://www.dropwizard.io/), el cual permite además de realizar el empaquetado, gestionar la [configuración de la aplicación](#configuracion), mediante un fichero yml. 

Una aplicación Dropwizard dispone de su propia subclase de `io.dropwizard.Configuration` la cual dispone de los parámetros específicos del entorno.  Trellis dispone de la implementación base `org.trellisldp.dropwizard.config.TrellisConfiguration` la cual será preciso extender.  

Será preciso también crear una clase que extendienda la clase es.um.asio.ldp.app.TrellisApplication, la cual a su vez extiende `io.dropwizard.Application<T>`, la cual tiene estará parametrizada con la clase de configuración indicada anteriormente. Esta será la clase que contenta el método `main` de la aplicación y por tanto la que hay que ejecutar para arrancar el servicio.

##### Comentarios sobre la adaptación

Trellis al disponer de una arquitectura modular permite de una forma bastante sencilla generar un nuevo empaquetado modificando o añadiendo módulos de la aplicación. Esto es una gran ventaja que aporta de cara a poder adaptarlo a las necesidades del proyecto Hércules.

#### Conclusión

Trellis, según el [ldp-testsuite](https://w3c.github.io/ldp-testsuite/), parece cumplir razonablemente bien, con los estandares dispuestos por la LDP. 

Es cierto que en caso de necesitar llegar a un grado de cumplimiento completo del estándar LDP, es probable que necesitemos realzar algunas modificaciones sobre el Core de Trellis, pero siendo un proyecto de código abierto, pues esto seria posible.

Por otra parte, también implementa el estándar Memento, lo que nos permitiría cumplir con el requisito de   almacenamiento y acceso cualquier versión de un documento en el tiempo.

Parece integrable con cualquier tipo de almacenamiento tanto relacional como triple store, cumpliendo en ambos casos, los estándares de la LDP.

Por otro lado es fácilmente integrable en una arquitectura de micro servicios por medio de su integración con Kafka.

También a priori parece encajar bien el modulo de autentificación y autorización dispuesto, a falta de tener una definición mas exhaustiva de los requisitos que esta a de cumplir.

Todo ello, hace de la herramienta Trellis, una herramienta con un gran encaje en el proyecto.

## Testing de cumplimiento LDP

Independientemente del enfoque que se utilice finalmente, es preciso verificar que la solución adoptada cumple con el [estándar LDP del W3C](https://www.w3.org/TR/ldp/). En el caso de Trellis, según el W3C se indica que está [conforme con LDP 1.0 desde 2018](https://www.w3.org/wiki/LDP_Implementations#TrellisLDP_.28Server.29), con lo que se podría garantizar este cumplimiento.

Para testear el cumplimiento de la especificación, W3C dispone de una herramienta denominada [ldp-testsuite](https://w3c.github.io/ldp-testsuite/), la cual es capaz de generar un reporte indicando el nivel conseguido, así como aquellos puntos que no se cumplen.

## Conclusión

Tras analizar tanto una solución ad-hoc y una solución tipo LDP, se observa que ambas por si mismo no son una solución completa. 

El implementar un API conforme a los criterios de LDP conllevaría un gran esfuerzo para conseguir un cumplimiento mínimo de los requisitos establecidos por la especificación, por lo que en este caso se aconseja la utilización de Trellis para este cometido ya que está certificado por el W3C en el cumplimiento de la especificación.

No obstante lo anterior, Trellis por si solo tiene ciertas carencias que será necesario suplir mediante implementaciones ad-hoc:

- Implementación de la capa de persistencia que permita intercambiar diferentes triplestores
- Generación de RDF a partir de los POJOs
- Otras adaptaciones que sea preciso llevar a cabo

Para los 2 primeros puntos, se aconseja la utilización de un framework tipo RDF4J o Apache Jena que permita conseguirlos con mayor facilidad.