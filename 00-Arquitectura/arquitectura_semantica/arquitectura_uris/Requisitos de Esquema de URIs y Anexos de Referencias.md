

### Requisitos

#### Requisito: 15.1 Especificación formal del esquema de URIs Hércules. 

> El adjudicatario proveerá de una especificación formal, llamada esquema de URIs Hércules, que definirá la sintaxis que deben seguir las URIs de los datos publicados dentro de la iniciativa Hércules. Para crear dicha especificación el adjudicatario se basara en iniciativas como [Norma técnica de interoperabilidad (NTI)](https://www.boe.es/diario_boe/txt.php?id=BOE-A-2013-2380), el estándar [European Legislation Identifier (ELI)](https://eur-lex.europa.eu/eli-register/about.html) y otras normas y estándares que el usuario considere pertinentes, incluyendo elementos específicos del dominio GI *(El Esquema de URIs Hércules definido por el adjudicatario puede estar enteramente basado en la NTI, pero el adjudicatario tendría que justificar, en ese caso, que la NTI captura adecuadamente la gran mayoría de URIs que podrían surgir del dominio GI en diferentes Universidades. Además, la NTI no da una solución al requisito del multilingüismo descrito más adelante)*.

##### Requisito: 15.1.1 Elementos imprescindibles para el esquema de URIs. 

> El esquema de URIs describirá al menos los siguientes elementos
>
> - Recursos Linked Data (Sujetos y predicados)
> - Ontologías, clases y propiedades OWL (y por lo tanto también algunos sujetos, predicados y objetos RDF)
> - Tesauros y conceptos [SKOS](https://www.w3.org/2004/02/skos/) (definición de esquemas de clasificación)
> - Named Graph en Triple Store (grafo en el tripe store o espacio de nombres)
> - Catálogos, datasets, distribuciones [DCAT](https://www.w3.org/TR/vocab-dcat/)
> - Entidades [VoID](https://www.w3.org/TR/void/) (vocabulario para describir datasets)
> - Entidades [PROV](https://www.w3.org/TR/prov-o/)  (vocabulario para describir licencias y derechos de uso)

##### Requisito: 15.1.2 Implementar en SKOS los componentes que definan el Esquema de URIs.

> Los componentes sintácticos que defina el Esquema de URIs se implementarán en SKOS (En el caso de la NTI, estos componentes sintácticos son, por ejemplo, el Sector y el Dominio).

##### Requisito: 15.1.3 Solución al multilingüismo.

> Por último, el Esquema de URIs debe dar una solución al multilingüismo. A pesar de que formalmente las URIs no tienen contenido semántico (son identificadores opacos), son consumidas también por usuarios humanos también, y codificarlas sólo en castellano o en inglés no respondería a la vocación europea del proyecto. Se pueden apuntar algunas soluciones a este problema:
>
> * Usar URIs completamente opacas, sin idioma. Por ejemplo, http:// www.um.es /q34fderf.
> * Usar solo URIs en Inglés (No usar ni castellano ni otra lengua oficial de la Unión Europea). Por ejemplo, http:// www.um.es /researcher/ jfernand.
> * Usar URIs en castellano y la lengua oficial para cada entidad, añadiendo un predicado owl:sameAs entre ambas URIs (Ésta es la solución implementada en las versiones idiomáticas de la DBPedia118). Por ejemplo, `http://www.um.es/investigador/jfernand` y `http://www.univ-paris1.fr/chercheur/jfernand`.

##### Requisito: 15.1.4 Solución escalable y robusta.

> El adjudicatario ideará una solución robusta y escalable a este problema, partiendo de las soluciones mencionadas o cualquier otra solución que considere adecuada, siempre atendiendo a las buenas prácticas Linked Data reconocidas. La solución será incorporada al Esquema de URIs.

#### Requisito: 15.2 Documentación de buenas prácticas sobre URIs. 

> El adjudicatario creará un documento denominado Buenas prácticas para URIs Hércules.
>
> Este documento describirá buenas prácticas a seguir en la creación, mantenimiento y gestión de URIs, ofreciendo una síntesis adaptada al proyecto Hércules de las siguientes fuentes y cualquier otra que el adjudicatario crea conveniente: [The Role of "Good URIs" for Linked Data](https://www.w3.org/TR/ld-bp/#HTTP-URIS), [Cool URIs for the Semantic Web](https://www.w3.org/TR/cooluris/), [Cool URIs don’t change](https://www.w3.org/Provider/Style/URI.html), [Understanding URIs](https://www.w3.org/TR/chips/#uri), [Creating URIs](https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/60975/designing-URI-sets-uk-public-sector.pdf), [Designing URI sets for the public sector](https://www.gov.uk/government/publications/designing-uri-sets-for-the-uk-public-sector), [Study on persistent URIs](http://philarcher.org/diary/2013/uripersistence/), [Towards a NL URI strategy](http://www.pilod.nl/wiki/Bestand:D1-2013-09-19_Towards_a_NL_URI_Strategy.pdf), [URI Design Principles: Creating Persistent URIs for Government Linked Data](https://logd.tw.rpi.edu/instance-hub-uri-design)
>
> Hay que implementar asimismo mecanismos que soporten
>
> - Relacionar de manera independiente el espacio de URIs con la implementación del servidor
> - Redirección cuando un recurso identificado por una URI cambie o desaparezca
> - Mecanismos para el hipotético caso de que una institución no pueda gestionar las URIs por razones no técnicas (desaparición de departamento, falta de fondos...)
>
> Esta política de URIs debe de estar plasmada en un "Contrato", que la universidad se compromete a cumplir. El adjudicatario presentara a la UM, un borrador de dicho contrato (partiendo el ejemplo de la  [W3C URI persistence policy del W3C](https://www.w3.org/Consortium/Persistence)). 

#### Requisito: 15.3 Factoría de URIs. 

> Debe de ser capaz de convertir fuentes de datos no-RDF a RDF. Para ello, es necesario generar URIs nuevas que identifiquen las entidades originales de los datos en el Grafo RDF resultante. La Factoría de URIs deberá ser módulo capaz de generar URIs adecuadas, no existentes en la Triple Store a partir de los datos de origen.
>
> Se generaran las URIs, siguiendo el [esquema de URIs](#Requisito: 15.1 Especificación formal del esquema de URIs Hércules) definido anteriormente, pero deberá ser capaz de trabajar con otros esquemas de URIs definidos por el usuario. De echo el esquema de URIs para el proyecto ASIO, será solo un subconjunto de los esquemas aplicables.

### Requisito 17 Procesamiento de datos

> El Backend SGI debe procesar datos pre-existentes sobre el dominio GI de acuerdo a la siguiente secuencia 
>
> - Conversión a RDF
> - Validación
> - Descubrimiento

#### Requisito 17.1 Conversión

> El Backend SGI debe incluir una función de ingesta de datos distintos formatos  (CSV, JSON, XML, BBDD relacionales y textos, entre otros), y generar datos RDF.

> Al definir las URIs de las entidades, este módulo debe ser capaz de conectarse al módulo Factoría de URIs (Para crear URIs nuevas), y al Módulo de descubrimiento (Para detectar URIs existentes).

#### Requisito 17.2 Validación

> El módulo de validación será capaz de analizar el RDF generado por el módulo de conversión, o por otros medios, de acuerdo a unos criterios pre-establecidos:
>
> - Buenas practicas Linked Data
> - Conformidad con la Especificación de ontologías Hércules de la Infraestructura Ontológica, tanto a nivel de datos como de metadatos.
> - Calidad de los datos
> - Métricas FAIR
>
> El validador se implementara como un servicio Web alojado en las instalaciones de la UM, con las siguientes características:
>
> - Basado en SHACL.
> - Capaz de validar con Shapes autogeneradas o expresamente subidas por el usuario.
> - Tres niveles: Violation, Warning e Info
> - RDF se podrá subir como archivo, por medio de una URI que permita acceder a el  o por una consulta SPARQL que permita extraer el RDF.
> - El validador será una librería con un API.

#### Requisito 17.3 Descubrimiento

##### Requisito 17.3.1 Reconciliación de entidades

> Asegurar que la misma entidad apuntada por distintas entidades, tiene la misma URI y añadir a la misma los cambios necesarios. Presentara al usuario entidades existentes en el triple store que puedan ser la misma, con un umbral de confianza. El usuario podrá configurar el umbral de confianza, de modo que  se minimice la intervención humana y y las entidades duplicadas.

##### Requisito 17.3.2 Reconciliación de enlaces

> El modulo describirá enlaces potenciales entre los datos del Backend SGI y otros Backend SGI, otros datasets de la nube LOD y e mismo Backend SGI. Estos enlaces, tras aprobación del usuario, se insertaran en la triple store, con un Named Graph especifico para enlaces.

> El licitante presentara una lista de datasets de la nube LOP u otras infraestructuras que en principio podrían ser enlazadas.

##### Requisito 17.3.3 Detección de equivalencias

> Este proceso está basado en el uso de razonamiento automático de una manera eficiente para buscar equivalencias semánticas entre entidades de diferentes Backends SGI. Las equivalencias descubiertas se añadirán como axiomas/triples al Backend SGI en el que se esté trabajando, para que puedan ser explotadas en el futuro. 

### Anexos

#### Reglamentos de esquema de URIs a revisar

##### Norma Técnica de Interoperatividad (NTI)

###### Objetivo

Establecer las pautas básicas para la reutilización de documentos elaborados o custodiados por el sector público.    <span style="color:red"><strong>&rarr; Por lo tanto es importante eliminar los aspectos específicos de la administración publica y extraer los  reusables para el esquema de URIs o buenas prácticas </strong></span>

###### Aplicación 

A los recursos de información de carácter publico por parte de cualquier órgano de la Administración publica o entidad de derecho.

###### De aplicación en esquema de URIs Hércules

- Los documentos y recursos de información reutilizables estarán **identificados mediante referencias únicas y unívocas, basadas en identificadores de recursos uniformes**, que componen la base necesaria para habilitar un mecanismo coherente de reutilización de la información a través de Internet. Con el uso de estos identificadores se podrá hacer referencia a los documentos o recursos que representan de forma unívoca, estable, extensible, persistente en el tiempo y ofreciendo garantías de procedencia, requisitos clave para facilitar su posterior reutilización.

* Para la construcción de los identificadores de recursos uniformes se tendrán en cuenta los siguientes requisitos:

  1. Se usarán los protocolos HTTP o HTTPS, con el fin de garantizar el direccionamiento y resolución de cualquier identificador de los recursos en la web.
  2. Dado que pueden existir representaciones distintas asociadas a un mismo recurso de información, un servidor al que se le solicita un identificador de recurso uniforme debería gestionar dicha petición en función de la cabecera HTTP recibida, devolviendo la representación del recurso adecuada a las preferencias del cliente.
  3. Para la composición de los identificadores de recursos uniformes se usará un **esquema consistente, extensible y persistente, preferentemente de acuerdo con el esquema definido en el anexo II**. Las normas de construcción de los mismos **seguirán unos patrones determinados que ofrezcan coherencia en la uniformidad**, los cuales podrán ser ampliados o adaptados en caso de necesidad. **Aquellos Identificadores que sean creados y publicados en algún momento, deberán mantenerse en el tiempo**.
  4. Los identificadores de recursos uniformes seguirán una **estructura de composición comprensible y significativa**. El identificador deberá ofrecer información de manera que pueda ser entendido y fácilmente escrito por personas lo que permitirá disponer de información sobre el propio recurso, así como su procedencia únicamente interpretando el identificador
  5. El identificador de recursos uniforme que identifica cada documento o recurso, en la medida de lo posible, **no revelará información sobre la implementación técnica** de generación del recurso representado.

* Anexo II: Esquema de URI

  * Establece un mecanismo para la identificación de datos que se exponen públicamente, de forma que se pueda hacer referencia a estos de forma única, fiable y persistente en el tiempo.

  * Los requisitos son:

    * Usar el protocolo HTTP
    * Usar una estructura consistente, extensible y persistente.
    * Las URIs seguirán una estructura comprensible y relevante, de forma que el identificador ofrezca información semántica autocontenida que permita inferir información del propio recurso y su procedencia
    * No se debe exponer información de la implementación técnica de los recursos.
    * Las URIs deben de ser persistentes, es decir una vez creada, no debe variar y el contenido siempre a de ser accesible. En caso de que sea necesario cambiar o eliminar un recurso, hay que informar sobre el estado mediante el codigo HTTP 3xx para redirecciones, y HTTP 410 para recursos que han desaparecido permanentemente.

  * Estructura básica:

    * Las URIs tendrán una estructura uniforme que debe ofrecer coherencia al sistema, cubriendo principios básicos en su construcción y conteniendo información intuitiva sobre la procedencia y el tipo de información que identifica.

    * La URI incluirá información básica sobre la procedencia de los datos, es decir sobre la institución que los proporciona (ej. `http://universidadmurcia.org`) 

    * Es posible que en la URI se defina también el idioma (según la norma internacional correspondiente ISO 639-1), dependiendo de las características o tecnologías empleadas.

    * La composición de elementos en el diseño de la URI debería ser

      ​		http://{base}/{carácter}\[/{sector}\]\[/{dominio}\]\[\{concepto}\]\[.{ext}\]

      o usando los identificadores de fragmento <<#>> al final de la dirección:

      ​		http://{base}/{carácter}\[/{sector}\]\[/{dominio}\]\[.{ext}\]\[#{concepto}\]

    * Los elementos que componen la URI son:

      * carácter:

        | Valor     | Información que representa                                   |
        | --------- | ------------------------------------------------------------ |
        | Catalogo. | Documento o recurso de información incluido en el catálogo, con una lista de recursos o entidades de un mismo dominio. Habitualmente estos documentos y recursos de información contendrían datos comunes como condiciones de uso, origen, vocabularios utilizados, etc. También identifica al catálogo en sí. |
        | Def.      | Vocabulario u ontología utilizada como modelo semántico. Habitualmente esquemas RDF-S u ontologías representadas mediante OWL. |
        | Kos.      | Sistema de organización del conocimiento sobre un dominio concreto. Habitualmente taxonomías, diccionarios o tesauros, representados mediante SKOS. |
        | Recurso.  | Identificación abstracta única y unívoca de un recurso u objeto físico o conceptual. Estos recursos son las representaciones atómicas de los documentos y recursos de información y suelen ser instancias de los conceptos que se definen en los vocabularios. **Si se especifica extensión (o formato) en el URI indica que es la representación del recurso**. Pueden existir dos tipos de representaciones de un recurso básicas: un documento legible para humanos –normalmente HTML– o para las máquinas, en cualquiera de los formatos de representación de RDF. **El tipo concreto del documento será especificado mediante extensiones del propio documento**. |

      * Sector: La selección de un sector adecuado, acompañado del dominio específico del origen, le dará a cualquier usuario la confianza de conocer el tipo de información que está manejando y la fuente de la misma. Se seleccionará un identificador del sector (primario), según lo especificado en el anexo IV. Cada documento o recurso de información, vocabulario o esquema de conceptos debe pertenecer a un único sector. Si pertenece a más de uno, se utilizará el más representativo o alguno que se pueda considerar común. <span style="color:red"><strong>&rarr; No veo encaje en el proyecto</strong></span>

      * Dominio o temática de la información: Para identificar los elementos específicos dentro de un sector –recursos de información, vocabularios, esquemas de conceptos, etc.–, se creará una referencia adecuada que represente al dominio o temática de la información tratada.

      * Conceptos específicos: Los últimos elementos de ciertos URI –tras el carácter, sector y nombre del dominio de la información– incluyen a los conceptos e instancias específicas de recursos. Los conceptos son representaciones abstractas que se corresponden con las clases o propiedades de los vocabularios u ontologías utilizados para representar semánticamente los recursos. Además del concepto, se podrá representar una referencia unívoca a instancias concretas. También se podrán representar esquemas de conceptos abstractos, dentro de sistemas de gestión del conocimiento (taxonomías, tesauros, etc.).

      * Formato: Dado que los documentos que representan recursos pueden ser de diversos tipos, éstos se identificarán a través de la extensión del propio fichero, como, por ejemplo, «doc.html», «doc.rdf» o «doc.n3». Para la identificación de los recursos de forma abstracta se omitirá la extensión.  <span style="color:red"><strong>&rarr; ¿No entra en contradicción con "no revelará información sobre la implementación técnica"? </strong></span>

  * Especifico para Linked data:

    * URI para identificar **catálogos** y conjuntos de datos

      * Si solo se dispone de un catalogo, se podrá representar **http://{base}/catalogo**
      * En caso de que se disponga de mas de un catalogo se usar el patrón **http://{base}/catalogo/{sector}**
      * Los conjuntos de datos incluidos en cada catalogo, se identificaran mediante un URI unico para cada conjunto de datos: **http://{base}/catalogo/{dataset}** o en su defecto, utiizando la nomenclatura de identificadores de fragmentos (#): **http://{base}/catalogo#{dataset}**

    * URI para identificar **vocabularios**

      * Cualquier vocabulario u ontología seguirá el esquema: **http://{base}/def/{sector}/{dominio}** donde sector indicará el tema del vocabulario y dominio corresponderá a la referencia asignada al vocabulario, una representación textual breve pero descriptiva.
      * Las clases y propiedades del vocabulario tendrán como base el URI correspondiente al vocabulario donde se definen, compuesto con los identificadores de las clases o propiedades según el esquema: http://{base}/def/{sector}/{dominio}/{propiedad|Clase} o, en su defecto, utilizando la nomenclatura de identificadores de fragmentos (#): http://{base}/def/{sector}/{dominio}#{propiedad|Clase}

    * URI para identificar **esquemas de conceptos**

      * Cualquier sistema de organización del conocimiento –taxonomías, diccionarios, tesauros, etc.– sobre un dominio concreto será identificado mediante un esquema de URI basado en la estructura: http://{base}/kos/{sector}/{dominio}, donde sector indicará el tema del esquema de conceptos y dominio corresponderá a la referencia asignada a dicho esquema de clasificación. Ésta referencia del dominio será una breve representación textual pero descriptiva.
      * Los conceptos incluidos en el esquema tendrán como base el URI correspondiente al esquema donde se definen y tendrán la forma: http://{base}/kos/{sector}/{dominio}/{Concepto}, o en su defecto, utilizando la nomenclatura de identificadores de fragmentos (#): http://{base}/kos/{sector}/{dominio}#{Concepto}

    * URI para identificar a cualquier **instancia física o conceptual**

      * Estos recursos son las representaciones atómicas de los documentos y recursos de información. A su vez suelen ser instancias de las clases que se definen en los vocabularios. Estos recursos se identifican mediante el esquema: http://{base}/recurso/{sector}\[/{dominio}\]/{clase}/{ID} o, en su defecto, utilizando la nomenclatura de identificadores de fragmentos (#): http://{base}/recurso/{sector}\[/{dominio}\]/{clase}#{ID}
      * Donde sector indicará el tema relacionado con el recurso y clase corresponderá al tipo de concepto que describe al recurso. Habitualmente coincide con el identificador de una de las clases que caracteriza al recurso. El ID es un identificador que permite distinguir al recurso entre el resto de las instancias del mismo tipo, dentro del sistema. El dominio, relativo al recurso, podría corresponder al especificado en el propio vocabulario que define las clases de la instancia, es opcional.

    * **Normalización** de los componentes de las URIs

      * Seleccionar identificadores alfanuméricos cortos únicos, que sean representativos, intuitivos y semánticos.
      * Usar siempre minúsculas, salvo en los casos en los que se utilice el nombre de la clase o concepto. Habitualmente, los nombres de las clases se representan con el primer carácter de cada palabra en mayúsculas.
      * Eliminar todos los acentos, diéresis y símbolos de puntuación. 
      * Como excepción puede usarse el guión (–).
      * Evitar en la medida de lo posible la abreviatura de palabras, salvo que la abreviatura sea intuitiva.
      * Los términos que componen los URI deberán ser legibles e interpretables por el mayor número de personas posible.

    * Prácticas relativas a la gestión de **recursos semánticos** a través de URI (RDF)

      * Siempre que sea posible, y existan versiones del recurso en formato legible para personas HTML o similar y RDF, el servidor que gestiona los URI realizará negociación del contenido en función de la cabecera del agente que realiza la petición. En el caso de que el cliente acepte un formato de representación RDF en cualquiera de sus notaciones (p.e., especificando en su cabecera que acepta el tipo MIME application/rdf+xml) se servirá el documento RDF a través del mecanismo de redirecciones alternativas mediante los códigos de estado HTTP 3XX. De la misma forma, si es posible, se servirá la representación en cualquier otro formato preferido por el cliente.
      * En el caso de que no se realice una negociación del contenido desde el servidor y, para favorecer el descubrimiento de contenido RDF desde los documentos HTML relacionados con las descripciones de los recursos, se incluirán enlaces a la representación alternativa en cualquiera de las representaciones en RDF desde los propios documentos HTML de la forma `<link rel="alternate" type="application/rdf+xml" href="documento.rdf">` o similar. En esa sentencia se incluye el tipo de formato MIME del documento (application/rdf+xml, text/n3, etc.)
      * Cuando se establezcan enlaces entre distintos recursos de información, se procurará la generación de enlaces que conecten los recursos bidireccionales para facilitar la navegación sobre los recursos de información en ambos sentidos.

      

##### European Legislation Identifier (ELI)

###### Objetivo

Establecer mecanismos para facilitar el intercambio y la reutilización de recursos legales dentro de la Unión Europea . Establece patrones para crear URIs en el dominio de la legislación, Ontología que describe el dominio de la legislación y genera RDFs de metadatos consumibles por maquinas    <span style="color:red"><strong>&rarr;¿Aplicable?, Quizas solo para extrapolar patrones para la creación de URIs</strong></span>

###### Aplicación 

A todas los departamentos legales dentro de la Unión Europea y a los clientes que las consuman.  <span style="color:red"><strong>&rarr;¿Aplicable?, Quizas solo para extrapolar patrones para la creación de URIs</strong></span> 

###### De aplicación en esquema de URIs Hércules

ELI usa las URIS HTTP. Estas URIs se describen formalmente mediante plantillas interpretables por máquinas (IETF RFC 6570), donde los componentes de dichas URIs, implican semántica. Todos los componentes de las URIs son opcionales, y no tienen un orden predefinido, siguiendo el siguiente patrón

/eli/{jurisdiction}/{agent}/{sub-agent}/{year}/{month}/{day}/{type}/{natural identifier}/{level 1…}/{point in time}/{version}/{language}

La semántica de los componentes es la siguiente:

| Componente        | Nombre             | Comentarios                                                  |
| ----------------- | ------------------ | ------------------------------------------------------------ |
| **Jurisdiction**  | Jurisdiction       | Jurisdicción donde se aplica, bien países ('ES','LU'...), bien instituciones ('EU','WTO'...) |
|                   | Agent              | Estructura jerárquica administrativa, por ejemplo países,  cortes constitucionales, parlamentos.... |
|                   | Subagent           | Estructura jerárquica administrativa perteneciente al agente , por ejemplo el ministerio responsable |
| **Reference**     | Year               | Se permiten varias interpretaciones, por ejemplo fecha de firma, fecha de publicación.... |
|                   | Month              | Mes                                                          |
|                   | Day                | Dia                                                          |
|                   | Type               | Naturaleza del acto (ley, decreto...). La interpretación depende del país |
|                   | Subtype            | Subcategoría del tipo. La interpretación depende del país    |
|                   | Domain             | Usado para clasificar por temas                              |
|                   | Natural identifier | Referencia que lo distingue inequívocamente de ningún otro   |
| **Subdivision**   | Level 1            | Referencia a una subdivisión relativa al tipo (por ejemplo articulo 15) |
|                   | Level 2            | Referencia a una subdivisión relativa al Level 1 (por ejemplo articulo 15.1) |
|                   | Level 3            | Referencia a una subdivisión relativa al Level 2 (por ejemplo articulo 15.1.1) |
|                   | Level n            | Referencia a una subdivisión relativa al Level n-1           |
| **Point in time** | Point in time      | YYYYMMDD. Version del acto, en una fecha dada                |
| **Version**       | Version            | Para distinguir distintas versiones                          |
| **Language**      | Language           | Para establecer el idioma                                    |

#### Reglamentos relativos a buenas practicas en URIs a revisar



| Recomendación                                                | Descripción                                                  | Definida en                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Usar URIS HTTP                                               | Usar URIs según definición en el protocolo HTTP              | [Best Practices for Publishing Linked Data](https://www.w3.org/TR/ld-bp/#HTTP-URIS), [Cool URIs for the Semantic Web](https://www.w3.org/TR/cooluris/) , [Understanding URIs](https://www.w3.org/TR/chips/#uri), [Designing URI sets for the public sector](https://www.gov.uk/government/publications/designing-uri-sets-for-the-uk-public-sector), [Study on persistent URIs](http://philarcher.org/diary/2013/uripersistence/), [Towards a NL URI strategy](http://www.pilod.nl/wiki/Bestand:D1-2013-09-19_Towards_a_NL_URI_Strategy.pdf) |
| Al menos una representación RDF del recurso                  | Proporcionar al menos una representación legible por máquina del recurso identificado por la URI | [Best Practices for Publishing Linked Data](https://www.w3.org/TR/ld-bp/#HTTP-URIS) |
| URIS Persistentes                                            | Persistentes ante operaciones tales como mover el recurso, eliminarlo o modificarlo | [Best Practices for Publishing Linked Data](https://www.w3.org/TR/ld-bp/#HTTP-URIS), [Cool URIs don’t change](https://www.w3.org/Provider/Style/URI.html), [Understanding URIs](https://www.w3.org/TR/chips/#uri), [Designing URI sets for the public sector](https://www.gov.uk/government/publications/designing-uri-sets-for-the-uk-public-sector), [Study on persistent URIs](http://philarcher.org/diary/2013/uripersistence/), [Towards a NL URI strategy](http://www.pilod.nl/wiki/Bestand:D1-2013-09-19_Towards_a_NL_URI_Strategy.pdf) |
| Opacidad en identificadores                                  | Los identificadores no deben de dar información acerca de las propiedades del recurso | [Best Practices for Publishing Linked Data](https://www.w3.org/TR/ld-bp/#HTTP-URIS), [Study on persistent URIs](http://philarcher.org/diary/2013/uripersistence/), [Towards a NL URI strategy](http://www.pilod.nl/wiki/Bestand:D1-2013-09-19_Towards_a_NL_URI_Strategy.pdf) |
| Internalización                                              | El uso de IDN (nombre de dominio internacionalizado) añade 92 símbolos para poder definir URIs en cualquier idioma. | [Best Practices for Publishing Linked Data](https://www.w3.org/TR/ld-bp/#HTTP-URIS) ,[Understanding URIs](https://www.w3.org/TR/chips/#ur), [Study on persistent URIs](http://philarcher.org/diary/2013/uripersistence/) |
| Negociación de idioma                                        | Negociación de lenguaje mediante la cabecera Accept-Language | [Understanding URIs](https://www.w3.org/TR/chips/#uri)       |
| Negociación de contenido                                     | Negociación de contenido para documentos RDF y NO-RDF        | [Cool URIs for the Semantic Web](https://www.w3.org/TR/cooluris/), [Understanding URIs](https://www.w3.org/TR/chips/#uri), [Designing URI sets for the public sector](https://www.gov.uk/government/publications/designing-uri-sets-for-the-uk-public-sector), [Study on persistent URIs](http://philarcher.org/diary/2013/uripersistence/) |
| Respuesta mediante representación del recurso o redirección 3xx | Representación del recurso o Redirección al recurso: Código 3xx y cabecera Location con la ubicación del recurso | [Cool URIs for the Semantic Web](https://www.w3.org/TR/cooluris/), [Understanding URIs](https://www.w3.org/TR/chips/#uri), [Study on persistent URIs](http://philarcher.org/diary/2013/uripersistence/), [Towards a NL URI strategy](http://www.pilod.nl/wiki/Bestand:D1-2013-09-19_Towards_a_NL_URI_Strategy.pdf) |
| La URI debe de ser inequívoca                                | No debe de haber confusión entre identificadores de documentos Web y otros recursos | [Cool URIs for the Semantic Web](https://www.w3.org/TR/cooluris/), [Study on persistent URIs](http://philarcher.org/diary/2013/uripersistence/) |
| **distinguir recursos RDF y NO-RDF: **URI Hash o fragmento (#) | Permite añadir información a la URI, de forma que se pueda redirigir hacia un tipo de documento u otro. Se puede usar la negociación de contenido , y formar el hash hacia el formato deseado. | [Cool URIs for the Semantic Web](https://www.w3.org/TR/cooluris/) |
| **distinguir recursos RDF y NO-RDF: **Código 303 Redirección | Se aplica cuando la representación RDF y HTTP, referencian el mismo recurso. En caso de ser un recurso RDF, se dará un 303, con la redirección al recurso.  Esto elimina la ambigüedad en los códigos de respuesta (200 para recurso Web y 3xx para recursos ). Se puede usar la negociación de contenido , y retornar 3xx redirección hacia el formato deseado. | [Cool URIs for the Semantic Web](https://www.w3.org/TR/cooluris/) |
| Criterios para evaluar calidad de las URIs                   | **Sencillez:** URIs cortos y nemotécnicos.<br>**Escalabilidad**: Pensar en un largo horizonte temporal (horizonte de décadas) al definir las URIs, y no fijarlas a tecnologías concretas.<br/>**Manejabilidad:** Fáciles de administrar | [Cool URIs for the Semantic Web](https://www.w3.org/TR/cooluris/), [Study on persistent URIs](http://philarcher.org/diary/2013/uripersistence/), [Towards a NL URI strategy](http://www.pilod.nl/wiki/Bestand:D1-2013-09-19_Towards_a_NL_URI_Strategy.pdf) |
| Enlaces                                                      | Conviene incrustar en los recursos enlaces a los otros formatos disponibles en el recurso de forma que sea posible acceder de uno a otro | [Cool URIs for the Semantic Web](https://www.w3.org/TR/cooluris/), [Designing URI sets for the public sector](https://www.gov.uk/government/publications/designing-uri-sets-for-the-uk-public-sector), [Study on persistent URIs](http://philarcher.org/diary/2013/uripersistence/), [Towards a NL URI strategy](http://www.pilod.nl/wiki/Bestand:D1-2013-09-19_Towards_a_NL_URI_Strategy.pdf) |
| Redirecciones                                                | Seguir el protocolo estándar HTTP para redirecciones         | [Cool URIs for the Semantic Web](https://www.w3.org/TR/cooluris/), [Understanding URIs](https://www.w3.org/TR/chips/#uri), [Study on persistent URIs](http://philarcher.org/diary/2013/uripersistence/), [Towards a NL URI strategy](http://www.pilod.nl/wiki/Bestand:D1-2013-09-19_Towards_a_NL_URI_Strategy.pdf) |
| Agentes de indexación                                        | Proporcionar Información útil para agentes de indexación     | [Understanding URIs](https://www.w3.org/TR/chips/#uri)       |
| Cache                                                        | Proporcionar Información útil para motores                   | [Understanding URIs](https://www.w3.org/TR/chips/#uri)       |
| Metadatos útiles                                             | Proporcionar metadatos útiles además de la negociación de contenido | [Understanding URIs](https://www.w3.org/TR/chips/#uri), [Study on persistent URIs](http://philarcher.org/diary/2013/uripersistence/) |
| Soluciones predeterminadas  y alternativas                   | Proporcionar soluciones predeterminadas y alternativas, cuando no se puedan cumplir las especificadas por el cliente en la negociación de contenidos | [Understanding URIs](https://www.w3.org/TR/chips/#uri), [Study on persistent URIs](http://philarcher.org/diary/2013/uripersistence/) |



##### Best Practices for Publishing Linked Data [link](https://www.w3.org/TR/ld-bp/#HTTP-URIS)

###### Objetivo

Establecer buenas practicas para publicación de Linked data establecidas por la W3C

###### Aplicación 

Linked Data, Esquema de URIs, Buenas practicas, Factoría de URIs

###### De aplicación en el proyecto ASIO

**Principios de diseño de URI**

Establece una serie de principios generales para destinados a ayudar a definir y administrar las URIs de los recursos:

- **Utilizar los URI HTTP:** Es un estándar de facto, y proporciona muchas ventajas como los enlaces, el almacenamiento en cache, la indexación en motores de búsqueda.... Las URIs permiten buscar y desreferenciar recursos.
- **Proporcionar al menos una representación legible por máquina del recurso identificado por la URI**
- **URIS Persistentes:** Es decir que no contengan elementos que puedan cambiar con el tiempo, como por ejemplo token de sesión o información de estado. Debe haber un equilibrio en hacerlas legibles, e incluir información descriptiva que probablemente cambie con el tiempo.
- **Opacidad:** Las propiedades del recurso referenciado no deben de ser inferibles de su URI

**Políticas de URIs relativas a la persistencia**

- Es necesario establecer una política que permita el acceso a los recursos, aunque estos se hayan movido o hayan cambiado.
- La elección de un esquema de URIs no garantiza la persistencia de las URIs, sino que esto es mas bien un compromiso del propietario de la URI.
- El concepto de [PURL](https://en.wikipedia.org/wiki/Persistent_uniform_resource_locator), permite crear un identificador permanente de recurso que permite redirigir a la  URI final del recurso, esto permite mantener una URI permanente que puede apuntar a un recurso que cambia a lo largo del tiempo  <span style="color:red"><strong>&rarr;En nuestro caso la Factoría de URIs</strong></span>
- El [proyecto PURLs de código abierto](http://purlz.org/)](http://purlz.org/)  ofrece implementaciones de PURL y el proyecto de software [Permanent Identifiers for the Web](http://w3id.org/) ofrece un servicio seguro (HTTPS) para garantizar la seguridad extremo a extremo. Para que un sistema persistente sea operativo tiene que garantizar resolver en tiempo real, la resolución de un recurso y la administración del identificador.

**Identificadores de recursos internacionalizados**

- Se recomienda crear un IRI (espacio de nombres para todos los términos que comparten ontología)
- El uso de IDN (nombre de dominio internacionalizado) añade 92 símbolos para poder definir URIs en cualquier idioma.

##### Cool URIs for the Semantic Web [link](https://www.w3.org/TR/cooluris/)

###### Objetivo

Establecer buenas practicas para publicación de Linked data establecidas por la W3C

###### Aplicación 

Desarrolladores Web o de ontología que tienen que decidir como modelar las URIs para Linked Data, para usar sobre HTTP, Esquema de URIs, Buenas practicas, Factoría de URIs

###### De aplicación en el proyecto ASIO

- **Utilizar los URI HTTP:** Es un estándar de facto, y proporciona muchas ventajas como los enlaces, el almacenamiento en cache, la indexación en motores de búsqueda.... Las URIs permiten buscar y desreferenciar recursos.

- **Negociación de contenido:**

  - Formato: Mediante cabecera HTTP Accept
  - Lenguaje: Mediante cabecera HTTP Accept-Language

- **Dos posibles respuestas:**

  - Representación del recurso 
  - Redirección al recurso: Código 3xx y cabecera Location con la ubicación del recurso 

- **La URI debe de ser inequívoca**: No debe de haber confusión entre identificadores de documentos Web y otros recursos

- **Dos estrategias para distinguir recursos RDF y NO-RDF**

  - **URI Hash o fragmento (#):** Permite añadir información a la URI, de forma que se pueda redirigir hacia un tipo de documento u otro. Se puede usar la negociación de contenido , y formar el hash hacia el formato deseado. 
  - **Código 303 (Redirección) URI a documento genérico:** Se aplica cuando la representación RDF y HTTP, referencian el mismo recurso. En caso de ser un recurso RDF, se dará un 303, con la redirección al recurso.  Esto elimina la ambigüedad en los códigos de respuesta (200 para recurso Web y 3xx para recursos ). Se puede usar la negociación de contenido , y retornar 3xx redirección hacia el formato deseado.
  - **Código 303 (Redirección) URI a diferentes documentos:** Se aplica cuando la representación RDF y HTTP, **no** referencian el mismo recurso. En caso de ser un recurso RDF, se dará un 303, con la redirección al recurso.  Esto elimina la ambigüedad en los códigos de respuesta (200 para recurso Web y 3xx para recursos ). Se puede usar la negociación de contenido , y retornar 3xx redirección hacia el formato deseado.

- **Ventajas/Desventajas entre 303 y Hash**

  - **Hash:**
    - Ventajas
      - Menos peticiones
      - Menos latencia
    - Desventajas
      - Configuración única para todas las representaciones
      - Más sobrecarga (hay que cargar todo el contenido y filtrarlo por su hash)
      - Menos seguridad  (hay que cargar todo el contenido y filtrarlo por su hash)
  - **303:**
    - Ventajas
      - Configuración separada según su representación
      - Seguridad independiente por representación
    - Desventajas
      - más peticiones
      - más latencia

- **Criterios para evaluar calidad de las URIs**

  - **Sencillez:** URIs cortos y nemotécnicos.
  - **Escalabilidad**: Pensar en un largo horizonte temporal (horizonte de décadas) al definir las URIs, y no fijarlas a tecnologías concretas.
  - **Manejabilidad:** Fáciles de administrar

- **Enlaces:** Conviene almacenar en los recursos enlaces a los otros formatos disponibles en el recurso de forma que sea posible acceder de uno a otro:

  ![Los documentos RDF y HTML deben relacionar los URI entre sí.](https://www.w3.org/TR/cooluris/img20081203/links.png)

  - Recursos RDF:  referencias usando la URI id como sujeto, con los predicados **foad:page**  para indicar representación de recurso Web, y **rdfs:isDefinedBy** para representación RDF.

    ```
    <http://www.example.com/id/alice>
        foaf:page <http://www.example.com/people/alice>;
        rdfs:isDefinedBy <http://www.example.com/data/alice>;
    
        a foaf:Person;
        foaf:name "Alice";
        foaf:mbox <mailto:alice@example.com>;
    ```

  - Recursos Web (HTML):  Referencias hacia recurso RDF con link

    ```
    <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
      <head>
        <title>Alice's Homepage</title>
        <link rel="alternate" type="application/rdf+xml"
              title="RDF Representation"
              href="http://www.example.com/data/alice" />
      </head> ...
    ```



##### Cool URIs don’t change [link](https://www.w3.org/Provider/Style/URI.html)

###### Objetivo

Establecer buenas practicas para creación de URIs de aplicación en el sector publico en UK, y aquellos propietarios de datos que quieran reusarlas.

###### Aplicación 

Buenas practicas y factoría de URIS

###### De aplicación en el proyecto ASIO

- A cambiar una URI, no se puede estar seguro de todos los enlaces que la hacían referencia, por lo que no debe cambiar.
- Hay que diseñar URIs mantenibles en espacios temporales muy largos.
- Que la fecha aparezca en la URI, es una buena practica, si pueden existir distintas versiones a lo largo del tiempo.
- Insertar la fecha no procede en los casos en los que se expone únicamente la última versión del documento.
- Excluir todo aquello de carácter temporal en la URI, como: Nombre del autor, asunto, estado, acceso, extensión, mecanismos de software, ubicación, nombre del disco...
- Evitar usar clasificaciones jerárquicas el la composición de las URIs, ya que la jerarquía tendera a romperse con el tiempo.
- Evitar cambiar también el nombre de servidor. 

##### Understanding URIs [link](https://www.w3.org/TR/chips/#uri)

###### Objetivo

Establecer buenas practicas para desarrolladores y Web master en la creación de URIs establecidas por la W3C, y protocolo HTTP

###### Aplicación 

Buenas practicas y factoría de URIS

###### De aplicación en el proyecto ASIO

- Un URI es una referencia a un recurso, que tiene una semántica fija e independiente.
- No poner demasiada semántica en la composición de la URI, si se hace hay más posibilidades de que la semántica cambie a lo largo del tiempo.
- Utilizar URIs lo mas simples posibles:
  - Tan cortos como sea posible
  - Elija política de mayúsculas y minúsculas
    - No políticas mixtas (mayúsculas y minúsculas en distintas partes de la URI).
    - Se sugiere todo minúsculas o primera letra mayúscula y resto minúsculas.
- Permitir gestionar las URIs de una forma flexible
  - Mapeo: Debe poderse reorganizar el sistema de archivos sin modificar la URI, por ejemplo haciendo uso de:
    - Alias.
    - Enlaces simbólicos.
    - Tablas o bases de datos de asignaciones.
- Redirecciones: Permitir el uso de redirecciones estándar:
  - 301: Movido permanentemente
  - 302: Encontrado
  - 307: Redireccionamiento temporal
- URIs independientes:
  - Una misma URI siempre ha de referenciar al mismo recurso
    - No se debe mostrar la tecnología subyacente, en su lugar para obtener una representación en un formato especifico del recurso, ha de usarse la negociación de contenidos.
  - No incluir información de usuario o de sesión
- URIs persistentes:
  - La URI debe permanecer constante, pero el contenido podría cambiar
  - En caso de borrado, usar 410 Gone. en vez de 404 Not Found.
-  Proporcionar información útil a los indexadores
  - Política de indexación
    - Definir política de indexación de sitio
    - Definir política de indexación local (cabecera META).
  - Content-Location (ubicación real actual) valido
  - Content-Md5 para verificación de integridad
-  Proporcionar información útil para cache
  - Usar de forma correcta la cabecera Date
  - Enviar Last-Modified siempre que sea posible
  - Usar la cabecera Cache-Control, para establecer el comportamiento de los motores de cache con respecto al recurso
  - Definir políticas de cache
  - Evitar que la generación de contenido dinámico, use siempre la fecha actual como fecha de última actualización.
  - Las cabeceras de las peticiones GET y HEAD deben de ser idénticas.
- Negociación de contenidos servida por el servidor, basada en las preferencias/capacidades del usuario.
  - Debe de proporcionarse mecanismos para proporcionar distintas representaciones del mismo recurso por negociación de contenidos, al menos mediante el uso de algoritmos aplicables al contenido de la cabecera Accept.
  - Permitir la negociación de codificación de caracteres con Accept-Charset
  - Para clientes que "acepten cualquier tipo de contenido" (Accept \*/\*) , es preferible usar el formato de contenido más ampliamente usado, preferiblemente mediante los factores de calidad.
  - Establecer por defecto Formato e idioma por defecto, para los clientes que no lo especifiquen.
- Negociación lingüística:
  - Permitir al administrador, mecanismos para definir que el mismo recurso tiene representaciones en varios idiomas
  - Uso del encabezado Content-Language para definir el idioma de preferencia el usuario.
- Proporcionar metadatos útiles además de la negociación de contenido.
  - Añadir referencias dentro de los documentos a el mismo documento en otros idiomas
  - la cabecera Link, complementada con los tipos, puede especificar relaciones con otros documentos:
    - Start
    - Next
    - Prev
    - Contents
    - Index
    - ...
- proporcionar soluciones predeterminadas y alternativas
  - Cuando la negociación falla para el formato del contenido o el idioma (por ejemplo cuando hay múltiples opciones) se puede o bien proporcionar una respuesta por defecto o bien retornar un codigo 300 (múltiples opciones)
  - Código 406 (No Aceptable) cuando la negociación de contenido o idioma no encuentre ningún recurso asociado pudiendo agregar al cuerpo del mensaje la lista de recursos disponibles.
  - El administrador puede poder definir una variante del recurso por defecto tanto en formato como en idioma, a servir en caso de que la negociación falle.
- Como norma general debe de ser posible cambiar el cuerpo de los mensajes de error.
- Servir información junto al recurso de el tipo de contenido y codificación de caracteres
  - Usar cabecera Content-type para informar del formato del contenido servido
  - Informar del conjunto de caracteres usado al menos de una de las siguientes maneras:
    - Con el parámetro charset en la cabecera Content-type
    - Con meta-información en el documento servido
  - Permitir al administrados configurar información del conjunto de caracteres.
- Negociación flexible preferible a conocimiento de agentes y no bloqueo de agentes
  - Es preferible permitir al cliente negociar el contenido que puede procesar, mejor que inferirlo por medio de el conocimiento del agente, ya que esto cambia con el tiempo y no es exhaustivo.
  - No bloquear agentes.
- Mejoras:
  - Uso de cabecera Transfer-Encoding para mejorar el rendimiento en dispositivos de bajo ancho de banda
  - Sustituir siempre que sea posible, metadatos en los propios datos por cabeceras HTTP

##### Designing URI sets for the public sector [link](https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/60975/designing-URI-sets-uk-public-sector.pdf)

###### Objetivo

Establecer buenas practicas para creación de URIs establecidas por la W3C

###### Aplicación 

Buenas practicas y factoría de URIS

###### De aplicación en el proyecto ASIO

- Usar protocolo HTTP para resolver las URIs
- Usar una estructura consistente de URIs, que explícitamente indique el tipo de URI.
- Tener en cuenta la reutilización de URIs
- Hacerlas persistentes
- Negociación de contenidos para distintos formatos de recursos.
- Evitar implementación técnica en la URI
- El conjunto de URIs, publicará metadatos de autentificación´n ,autorización y de calidad de datos en un vocabulario común. 
- La estructura de las URIs no contendrá nada que pueda cambiar
- La estructura de la URI, debe de contener información semántica interpretable por humanos. 

##### Study on persistent URIs [link](http://philarcher.org/diary/2013/uripersistence/)

###### Objetivo

Establecer buenas practicas para URIs persistentes de la Unión Europea, identificando problemas de estabilidad, datos multilingües, identificar problemas técnicas y establecer buenas prácticas.

###### Aplicación 

Esquema de URIs, Buenas practicas y factoría de URIS

###### De aplicación en el proyecto ASIO

- Afirmaciones:
  - Establecer y seguir un esquema (ej. http://{dominio}/{tipo}/{concepto}/{referencia}), que sea permanente en el tiempo.
  - Reutilizar identificadores existentes: Si la entidad tiene un identificador,este puede ser usado como identificador de la URI, siempre que no cambie la semántica original
  - Múltiples representaciones con negociación de contenido
  - redirecciones 303 para objetos del mundo real: Para las peticiones  de tipo type=id, redirigir a la representacion del recurso type=doc
  - Use un servicio dedicado, independiente del organizador de datos  

- Negaciones:

  - Evite que la URI muestre propiedad del dato (esto puede cambiar)
  - Evitar números de versión: Las URis deben de ser estables, independientemente de la versión, que cambiara con el tiempo.
  - Evitar incremento automático: Usar autoincremento en el identificador, hace complicada la idemportencia, es decir que un mismo recurso obtenga el mismo identificador en varias peticiones.
  - Evitar query params
  - Evitar extensiones

- Reglas de diseño y gestión de URIs

  - Asignar un propietario común por medio de la raíz de la URI

  - Crear áreas restringidas para secciones distintas 

  - Crear el patrón de forma flexible y abstracta de forma que futuras organizaciones puedan acogerse a el.

  - Seguir recomendaciones de la W3C

  - Las URIs han de seguir las siguientes recomendaciones 

    - Identifican cada recurso
    - Son permanentes y estables.
    -  Son manejables
    - Son únicos
    - Son claros, concisos y cortos
    - Están vinculados entre sí
    - Son fácilmente legibles por humanos
    - Son consistentes en formato y estructura
    - No contienen palabras clave
    - No contienen extensiones de archivos
    - No contenga www
    - Solo minusculas
    - No contiene acentos ni espacios
    - Reemplazar símbolos especiales por guiones o guiones bajos.

    

  ##### Towards a NL URI strategy [link](http://www.pilod.nl/wiki/Bestand:D1-2013-09-19_Towards_a_NL_URI_Strategy.pdf)

  ###### Objetivo

  Establecer buenas practicas para URIs persistentes de los datos públicos Holandeses.

  ###### Aplicación 

  Esquema de URIs, Buenas practicas y factoría de URIS

  ###### De aplicación en el proyecto ASIO

  - Establecer patrones simples pero con la complejidad suficiente para:
    - Garantizar persistencia
    - Esclabilidad
    - Entendibles
    - Confianza
    - Procesables por maquinas usando Linked Data
    - Legibles por humanos
  - Patron
    - http://{domain}/{type}/{concept}/{reference}
      - {domain} = {internet domain} / {path}
        - El dominio, representa el espacio de nombres para la resolución del URI
        - No incluir el nombre de la organización en el dominio, ya que este puede cambiar.
        - Evitar en lo posible el uso de path, por motivos de hacerlas lo mas pequeñas posibles
      -  {tipo}: Indica el tipo de URI
        - id: Identificador de una instancia
        - doc: documentación de el objeto (metadatos)
        - def: definición del termino en la ontología
        - Buenas practicas:
          - Usar 303 para redirigir id-URI a doc-URI
          - Usar URI-Hash para términos del modelo
      -  {concepto}: tipo de concepto (clase)
        - permite hacer que los identificadores de instancia sean únicos para la clase
        - Evitar ser demasiado concisos con las clases, si estas cambiaran con el tiempo
      - {referencia}: identificador de un objeto individual

  ##### URI Design Principles: Creating Persistent URIs for Government Linked Data [link](https://logd.tw.rpi.edu/instance-hub-uri-design)

  ###### Objetivo

  Establecer buenas practicas para esquema de URIs de los datos públicos.

  ###### Aplicación 

  Esquema de URIs y factoría de URIS

  ###### De aplicación en el proyecto ASIO

  - Objetivos:
    - URIs que se puedan alojar fácilmente
    - URIs concisos
    - URIs que abarcan muchos dominios

  - Patrón de diseño

    http://{base}/id/{[category]/[token]}/[token]

    ![patrón](http://logd.tw.rpi.edu/sites/default/files/uri_structure.png)

    - id: para no contaminar el espacio de nombres de la base
    - categoría: tipo de entidad, permiten describir una entidad y ayudar en la navegación. La categoría debe ser corta pero expresiva
    - token: identificador del elemento en si. Identificador único. Puede ser seguido de una categoría y un token

### Dudas

- El pliego menciona que el requisito 15.1 es de obligado cumplimiento para todas las universidades que quieran publicar datos como parte de la iniciativa Hércules. ¿la publicación no se realizara exclusivamente por medio de los importadores, y estos, mediante su interacción con la Factoría de URIS implementaran de facto el cumplimiento del requisito 15.1?. Si existen otras vias ¿Cuales son?¿como y donde aseguraremos el cumplimiento de la normativa de URIS en ese/esos caso/s?

