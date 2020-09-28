![](./images/logos_feder.png)

# Propuesta de diseño API LDP y EndPoint SPARQL

## Introducción

### Propósito

El presente documento tiene como propósito establecer una arquitectura y una propuesta de solución funcional para un API LDP, que cubra los requisitos para el proyecto, expresados en el documento   [Requisitos funcionales para API REST LDP en proyecto ASIO de la UM](./Requisitos%20funcionales%20para%20API%20REST%20LDP%20en%20proyecto%20ASIO%20de%20la%20UM.md). Según el diseño de la arquitectura general para el proyecto ASIO, el API LPD, y el End Point SPARQL, serán los dos únicos puntos de acceso, al triple store donde se almacenaran los datos, por lo tanto, tanto los servicios y micro servicios relacionados con el proceso de ingesta, como los aplicaciones que hagan un uso de los mismos, tendrán que  usarlos, convirtiéndose asi (tanto el API REST LDP como el Endpoint SPARQL) en un componente vital en la arquitectura, de forma que las restricciones y funcionalidades de los mismos, serán el Core que dirija el diseño de los componentes de la arquitectura completa de las solución.

### Alcance

La solución propuesta tiene que integrarse en los [requisitos](#Requisitos) generales del proyecto ASIO, que a la postre, su complimiento determinara la idoneidad de la solución propuesta.

En el presente documento, se plasmara la solución que en este momento creemos que mejor cumple dichos requisitos, y se argumentara en base al cumplimiento de los mismos.

### Requisitos

#### Cumplimiento LDP

La solución propuesta debe de asegurar el mayor nivel de cumplimiento posible de los requisitos dispuestos por la [Linked Data Platform](https://www.w3.org/TR/ldp/), y descritos en el documento [Requisitos funcionales para API REST LDP en proyecto ASIO de la UM](./Requisitos%20funcionales%20para%20API%20REST%20LDP%20en%20proyecto%20ASIO%20de%20la%20UM.md).

#### Cumplimiento de principios FAIR

La solución propuesta debe de asegurar el mayor nivel de cumplimiento posible de los [principios FAIR](https://www.go-fair.org/fair-principles/) aplicados a la publicación de datos científicos.

#### Autentificación y autorización

Es necesario garantizar la identidad de las personas que desean acceder al sistema (autentificación), y que estas pueden acceder a los recursos para los cuales tienen autorización.

#### Auditoría de datos

Es necesario poder determinar que modificaciones se han realizado sobre los datos, en que momento y por que persona o proceso fueron realizadas.

#### Versionado de entidades

Es necesario mantener los distintos estados a los que esta sujeto una entidad, en distintas líneas temporales, de forma que sea posible acceder a el estado concreto de dicha entidad en un instante especifico del tiempo.

#### Arquitectura de URIs

El servidor LDP, debe soportar la arquitectura de URIs para el proyecto ASIO, descrita en el documento [ASIO_Izertis_ArquitecturaDeURIs](../../08-Esquema_de_URIs_Hércules/ASIO_Izertis_ArquitecturaDeURIs.md).

#### Negociación de contenidos

 El servidor LDP, de ser capaz de soportar la negociación de contenidos, para:

- Recursos RDF: Al menos los impuestos por la LPD, tales como turtle y ld+json.
- Recursos No RDF (binarios): Debe de soportar recursos No RDF, comunes en otros tipos de servidores, tales como imágenes, HTML...

#### Integración con la arquitectura general propuesta para el proyecto ASIO

La solución propuesta debe de integrarse de forma consistente con el resto de las arquitectura del sistema, tanto productores de información (micro servicios creados para el proceso de ingesta de información, y escritura en triple store), como aplicaciones destinadas al consumo de dicha información (lectores).

En la medida de lo posible se valorara positivamente que usen un stack tecnológico compatible, valorándose para ello los siguientes aspectos:

- Interfaces de comunicación compatibles.
- Lenguajes de programación similares, de forma que el mismo grupo que desarrolla un microservicio, potencialmente pueda ajustar el comportamiento de la herramienta.
- En la medida de lo posible licencias GLP, para por un lado tener la posibilidad de hacer los cambios oportunos en la herramienta para cumplir con los requisitos anteriormente descritos, y por otro no estar atados a ningún fabricante concreto.

Es relevante asimismo que la herramienta cumpla adecuadamente su función, con el flujo de información previsto para el proyecto.

#### Integración con distintas sistemas de almacenamiento (RDBMS o Triple Store)

El pliego del proyecto ASIO, especifica que es necesario poder sustituir un sistema de almacenamiento por otro. Esto deberá de ser transparente para el resto de servicios o aplicaciones que interactúen con el sistema de almacenamiento, es decir, el patrón de peticiones de un hipotético cliente, debería de no ser afectado en absoluto. Siendo el único punto de acceso al mismo el API REST LDP o el EndPoint SPARQL, solo este se debería de ver afectado por ello, bien por configuración (deseable), bien por modificación del adaptador de conexión.

### Propuesta servidor LDP

#### Trellis

##### ¿Que es Trellis?

Es un servidor LDP Modular, conforme a los estándar WEB, que soporta el escalado horizontal y redundancia, que ofrece una API Rest según especificaciones de de LDP para interactuar con los datos (métodos de creación, modificación, borrado).

Soporta bases de datos relacionales y triples stores.

Puede recuperarse un dato histórico (versionado y auditoria de cambios) en cualquier instante de tiempo siguiendo las especificaciones de  [Memento specification](https://tools.ietf.org/html/rfc7089). ([ejemplos](https://github.com/trellis-ldp/trellis/wiki/Resource-Versioning))

Proporciona un mecanismo de detección de corrupción de recursos.

Proporciona integración con Kafka, de modo que es fácilmente integrable en un sistema distribuido

##### Análisis de la Herramienta, mediante evaluación de requisitos

###### Cumplimiento LDP

Desde el punto de vista del cumplimento LDP, [Trellis](https://github.com/trellis-ldp/trellis/wiki) en su documentación, asegura un cumplimiento completo de los [requisitos de un servidor LDP](https://www.w3.org/TR/ldp/).

Para evaluar el cumplimiento de dichos requisitos de primera mano, se ha usado el [LDP Test Suit](https://dvcs.w3.org/hg/ldpwg/raw-file/default/tests/ldp-testsuite.html), creado exprofeso por la LDP, para evaluar el nivel de cumplimiento.

Los resultados, y las causas de los *"errores"* en los test, están descritos de forma exhaustiva en el documento [Analisis de Test LDP (caso de uso Trellis).md](./Analisis%20de%20Test%20LDP%20(caso%20de%20uso%20Trellis).md)

**Comentarios sobre resultados de test**

Como resumen del mismo podemos ver los resultados en la tabla bajo estas líneas (por claridad solo se muestran los test fallados distintos).

| Tipo de contenedor | Ejecutados | Fallos MUST | Fallos SHOULD | Fallos MAY |
| ------------------ | ---------- | ----------- | ------------- | ---------- |
| Basic              | 112        | 1           | 5             | 1          |
| Direct             | 112        | 1           | 6             | 1          |
| Indirect           | 112        | 1           | 5             | 1          |

En cuanto a los requisitos MUST, indican obligación, por lo tanto son los mas restrictivos, y en la medida de lo posible,se debería de intentar asegurar el cumplimiento.

Los requisitos SHOULD, expresan un consejo, por lo tanto son menos restrictivos que los requisitos MUST, es decir expresan la forma deseada de actuar, pero no una obligación.

Los requisitos MAY, son los menos restrictivos, y expresan solo un deseo.

Como se aprecia en la tabla, solo existe un requisito obligatorio **MUST**, incumplido, en cualquier caso, funcionalmente el funcionamiento del servidor es correcto (la entidad no es insertada, y el código de error es correcto), pero el test falla por que no aparece la causa en la cabecera Link con una relación http://www.w3.org/ns/ldp#constrainedBy 

El resto de casos son **SHOULD** (consejos).

En estos casos se aprecia un patrón en los test fallados por Trellis:

- **Casos de fallo por reutilización de URIs ** (fallo de 3 test en 4 casos)

  - **testRestrictUriReUseSlug** (SHOULD)
  - **testPutRequiresIfMatch **(SHOULD)
  - **testRestrictPutReUseUri: **(SHOULD)

  En estos casos básicamente el servidor permite la reutilización de URIs. La implementación de este tipo de requisitos entra en conflicto con el requisito para este proyecto de [Versinado de entidades](#Versionado de entidades) implementado por Trellis siguiendo el estándar Memento, especificado en el documento [Memento Guía y Normativa.md](./Memento%20Gu%C3%ADa%20y%20Normativa.md) . En dicho estándar aparece el concepto de estados de entidades en distintas líneas temporales, es decir una misma entidad, no será modificada al recibir una modificación (borrado o actualización), sino que se creara un estado nuevo, el una nueva línea temporal, de forma que sea posible acceder al estado de cualquier entidad, en cualquier instante de tiempo. Esto **Obliga** a la reutilización de URIs, y causa el fallo del test, ya que el servidor interpreta la acción del test (borrado y después creación de la entidad), como distintos estados de la misma entidad. En resumen, **no se puede cumplir la recomendación de la LDP**, sin mermar la capacidad del servidor.

- **Casos de fallo interpretativos sobre la LDP **(fallo de 1 test en 1 casos)

  - **testTypeRdfSource** (MUST)

  En este caso, se puede considerar fallo o no depende de la interpretación que se realice de los requisitos LDP, ya que aplican 2 requisitos, que al menos en lo evaluado por el test son opuestos. En mi pion, aplica el requisito mas especifico, y en ese caso cumpliría el, requisito, y el test no estaría bien implementado. para mas información se recomienda ver la documentación [Analisis de Test LDP (caso de uso Trellis).md](./Analisis%20de%20Test%20LDP%20(caso%20de%20uso%20Trellis).md), en la sección especifica sobre el test testTypeRdfSource.

- **No advertir de las restricciones** (fallo de 3 test en 6 casos)

  - **testPublishConstraintsUnknownProp **(SHOULD y MAY)
  - **testPutSimpleUpdate **(SHOULD y MAY)
  - **testResponsePropertiesNotPersisted** (SHOULD y MAY)

  En este patrón de fallo, el comportamiento funcional del servidor es robusto, es decir actúa de la forma  especificada por la LDP (no creando el recurso, con un codigo de error 4xx).

  No cumple la parte de la normativa **MAY**, que indica que seria bueno dar información de fallo en el cuerpo del mensaje. 

  Podría evaluarse la opción de re-implementar la parte de Trellis, que gestiona este caso, pero probablemente la inversión en tiempo sea mayor al beneficio obtenido, teniendo en cuenta que únicamente afecta a la parte MAY, del requisito, y que funcionalmente el comportamiento es correcto. 

- **Fallo al expresar preferencia de contenido:**

  - **testPreferMembershipTriples** (SHOULD)

  En este caso el test falla por que se expresa la preferencia de obtener solo las tripletas de pertenencia, y se recuperan todas las tripletas. 

  Podría evaluarse la opción de re-implementar la parte de Trellis, que gestiona este caso, pero probablemente la inversión en tiempo sea mayor al beneficio obtenido, teniendo en cuenta que únicamente afecta a la parte SHOULD, del requisito, y que funcionalmente el comportamiento es correcto (solo afecta en algo de sobrecarga en un caso de uso poco probable).

**Conclusiones**

Respecto a recomendar el uso de Trellis, con respecto al requisito de cumplimiento de los requisitos LDP, creemos que su cumplimiento es muy prometedor y suficiente para abordar el proyecto ASIO. Además todas los test realizados se han realizado sobre la versión estándar.  Cabria la posibilidad de re-implementar algunas partes de Trellis, para *"garantizar"* un cumplimento mayor, pero creo que la inversión en tiempo, no seria rentable ya que la versión actual ofrece un alto cumplimiento, y otras funcionalidades interesantes tales como la implementación del estándar memento podrían verse afectadas.

Por otra parte es muy interesante que los resultados de los tes **no se ven afectados** por la elección del sistema de almacenamiento elegido, ya sea en memoria, en una base de datos relacional (se ha probado con POSTGRESQL), o un triple store (se ha probado con TDB y BlazeGraph), lo que permite cambiar el almacenamiento (requisito expresado en el pliego), sin afectar a los clientes que por medio del API LDP, hacen uso de el, ofreciendo en todo momento un comportamiento consistente, independientemente del almacenamiento usado.

###### Cumplimiento de los principios FAIR

Desde el punto de vista del cumplimento de los [principios FAIR](https://www.go-fair.org/fair-principles/) , [Trellis](https://github.com/trellis-ldp/trellis/wiki) no especifica en su documentación ningún nivel de cumplimento, pero algunos cumplimientos pueden ser inferidos mediante el uso de la herramienta.

A continuación, se enumeraran los principios FAIR, y el cumplimiento de ellos (en color rojo), que se puede apreciar, por inferencia sobre el comportamiento de Trellis:

**Encontrables:** Los datos y metadatos pueden ser encontrados por la comunidad después de su publicación, mediante herramientas de búsqueda.

- Asignarles un identificador único y persistente a los datos y los metadatos &rarr;<span style="color:red"> Impuesto por la LDP, y cumplido por Trellis.</span>
- Describir los datos con metadatos de manera prolija &rarr;<span style="color:red"> En cuanto a los datos RDF la Web Semantica, prevé por medio de ontologías la descripción de los datos, por lo tanto, Trellis ofrecera la calidad en la descripción que la ontología permita. En cuanto a los datos No RDF (bianrios), el estandar LDP prevé, y trellis implementa, la posibilidad de relacionar metadatos RDF, con con recursos Web, por lo que no deberia de existir ningún problema.</span>

- Registrar/Indexar los datos y los metadatos en un recurso de búsqueda &rarr;<span style="color:red"> Trellis se apoya en el sistema de almacenamiento (ya sea en memoria, relacional o triplestore), para Registrar/Indexar los datos por lo tanto este requerimiento estará condicionado por el sitema de almacenamiento usado. Trellis aporta flexibilidad para usar distintos tipos de almacenamiento, por lo que selecionar aquel que cumpla mejor este requisito, no debería de ser un impedimento, desde el punto de vista de Trellis</span>.
- En los metadatos se debe especificar el identificador de los datos que se describen &rarr;<span style="color:red"> Los metadatos en Trellis, estan asociados por el identificador del recurso al propio recurso. Tambien la LDP prevé que el uso de metadatos en recursos No RDF (binarios), al aplicar los requisitos LDP, Trellis tambien lo implementa. </span>

**Accesibles:** Los datos y metadatos están accesibles y por ello pueden ser descargados por otros investigadores utilizando sus identificadores.

- Los datos y los metadatos pueden ser recuperados por sus identificadores mediante protocolos estandarizados de comunicación &rarr;<span style="color:red"> Trellis, al ser un API REST implenta todos los estandares porpios de comunicación (protocolos HTTP/1, HTTP/2), por lo que deberia de estar garantizado.</span>

- Los protocolos tienen que ser abiertos, gratuitos e implementados universalmente &rarr;<span style="color:red"> Trellis usa los protocolos HTTP/1, HTTP/2, por lo que cumple la recomendación.</span>

- El protocolo debe de permitir procedimientos para la autentificación y la autorización (por si fuera necesario). &rarr;<span style="color:red"> Trellis usa autentificación basica por medio de JWT, para la autorización se controla el acceso a los recursos por medio de WebAC.</span>

- Los metadatos deben de estar accesibles, incluso cuando los datos ya no estuvieran disponibles. &rarr;<span style="color:red"> Trellis usa el estandar memento, que garantiza que tanto los datos como los metadatos son accesibles en cualquier momento del tiempo, independientemente del estado actual del recurso</span>

**Interoperable:** Tanto los datos como los metadatos deben de estar descritos siguiendo las reglas de la comunidad, utilizando estándares abiertos, para permitir su intercambio y su reutilización.

- Los datos y los metadatos deben de usar un lenguaje formal, accesible, compartible y ampliamente aplicable para representar el conocimiento &rarr;<span style="color:red"> Esa es justa la finalidad del Linked Data, siendo un servidor que implementa lso requerimientos expuestos por la LDP, debería cumplir perfectamente este requerimiento.</span>
- Los datos y los metadatos usan vocabularios que sigan los principios FAIR &rarr;<span style="color:red"> Esto dependera de la calidad de la Ontología. Trellis solo debera cumplir con este principio con los metadatos de auditoria, que en principio, iguen los criterios de la LDP, y por lo tanto cumplen este principio.</span>
- Los datos y los metadatos incluyen referencias cualificadas a otros datos o metadatos&rarr;<span style="color:red"> Esto uno de los principios fundamentales del Linked Data, por lo que aunque depende de la ontología usada, deberia cumplirlo.</span>

**REUSABLE** :** Los datos y los metadatos pueden ser reutilizados por otros investigadores, al quedar clara su procedencia y las condiciones de reutilización..

- Los datos y los metadatos contienen una multitud de atributos precisos y relevantes &rarr;<span style="color:red"> Esto uno de los principios fundamentales del Linked Data, por lo que aunque depende de la ontología usada, deberia cumplirlo.</span>
- Los datos y los metadatos se publican con una licencia clara y accesible sobre su uso y reutilización &rarr;<span style="color:red">Trellis tiene licencia GLP.</span>

- Los datos y los metadatos se asocian con información sobre su procedencia &rarr;<span style="color:red">Trellis añade meta información de auditoria a los datos relativa a su procedencia, para cualquier instante en el tiempo, mediante el uso de memento</span>
- Los datos y los metadatos siguen los estándares relevantes que usa la comunidad del dominio concreto &rarr;<span style="color:red">Depende de la calidad de la Ontologia, en cuanto a lso metadatos creados por trellis automaticamente, siguen el estandar de la LDP.</span>

**Conclusiones**

Debido a que los principios FAIR, tienen muchos puntos en común con el estándar LDP, siendo Trellis un servidor LDP, que cumple en gran medida sus principios, la mayor parte de estos, deberían de cumplirse de facto.

###### Autentificación y Autorización

**Autentificación**

Actualmente Trellis soporta dos tipos de autentificación:

- **Autentificación JWT** 

  La autentificación JWT es un mecanismo de autentificación que consiste en la generación de un token a partir de la información relativa a la información del usuario, cifrada con una clave compartida por Trellis y el servidor que realiza el proceso de autentificación del usuario, y un algoritmo de cifrado común (en este caso Base64-encoded). Este es el método recomendado por Trellis.

  Para realizar el proceso de login es necesario obtener un WebId, de la forma que se indica en [Solid WebID-OIDC specification](https://github.com/solid/webid-oidc-spec#deriving-webid-uri-from-id-token).

  Este proceso para la obtención del token permite delegar a un tercero el proceso de obtención del token que será usado como autentificación por Trellis, por lo tanto es posible integrarlo con cualquier método de autentificación que sea necesario para el proyecto.

  

- **Autentificación básica**

  Este mecanismo permite autenticar mediante nombre de usuario y password. Solo se recomienda para grupos pequeños de usuarios, como por ejemplo usuarios de administración.

**Autorización**

Trellis usa WebAC para autorizar acceso a recursos, definidos por [Solid WebID-OIDC specification](https://github.com/solid/webid-oidc-spec#deriving-webid-uri-from-id-token).

Es posible actualizar la configuración de WebAC en tiempo de ejecución. 

El mecanismo de autorización por medio de WebAC, permite restringir de forma granular, el acceso a un recurso y las acciones permitidas sobre el por ejemplo:

```BASH
@prefix acl: <http://www.w3.org/ns/auth/acl#>.

<#authorization> a acl:Authorization ;
    acl:mode acl:Read, acl:Write ;	# Tipos de accesos permitidos
    acl:accessTo <https://example.org/repository/resource> ; # Recurso
    acl:agent <https://example.org/users/1>, <https://example.org/users/2> . # Usuarios
```

O añadiendo solo permiso de lectura para todos los usuarios

```bash
@prefix acl: <http://www.w3.org/ns/auth/acl#>.
@prefix foaf: <http://xmlns.com/foaf/0.1/> .

<#authorization> a acl:Authorization;
    acl:agentClass foaf:Agent;  # everyone
    acl:mode acl:Read;  # has Read-only access
    acl:accessTo <https://example.org/repository/resource> . # the resource
```

**Conclusiones**

Trellis permite gestionar al **autentificación** mediante JWT, que estando diseñado como un mecanismo de autentificación Stateless, es fácilmente integrable con cualquier sistema de autentificación existente en el proyecto, en este caso el Servicio de Identidad de RedIRIS (SIR), por lo que en este aspecto, no debería de suponer un mayor problema.

En cuanto a la **autorización** Trellis ofrece un control de acceso granular a los recursos, por lo que creemos que cumple con las requerimientos del proyecto en este sentido, es decir, se ciertos recursos pueden ser de acceso publico, para operaciones concretas, por ejemplo, solo para lectura, y algunos recursos, pueden ser de acceso privado, por ejemplo, un recurso puede ser modificado por el investigador que lo creo, y leído solo por el grupo al que pertenece.

###### Auditoría de datos

Trellis mantiene un registro de auditoria de todos los cambios realizados sobre un recurso (creación, actualización o barrado) agregando tripletas que identifican al usuario que realizo el cambio sobre el recurso, y el momento en que se realizo. Estas tripletas no son parte de la representación del recurso pero pueden obtenerse mediante el uso de la cabecera Prefer

```http
Prefer: return=representation; include="http://www.trellisldp.org/ns/trellis#PreferAudit"
```

Estas tripletas son de solo lectura, y no pueden ser modificadas de forma manual

Un ejemplo de tripletas de auditoria podría ser:

```html
@prefix as:  <https://www.w3.org/ns/activitystreams#> .
@prefix rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix xsd:  <http://www.w3.org/2001/XMLSchema#> .
@prefix prov:  <http://www.w3.org/ns/prov#> .
@prefix dc:  <http://purl.org/dc/terms/> .

<!--Tripletas de atributos del recurso-->
<https://example.com/repository/resource>
        dc:title     "Resource"@eng ;
        dc:publisher <https://example.com/repository> .
    
<!--Tripletas de auditoria del recurso-->
<https://example.com/repository/resource>
        prov:wasGeneratedBy  _:b0 . <!--Nodo trellis que realiza el cambio-->

_:b0    rdf:type                prov:Activity ; <!--Tipo-->
        rdf:type                as:Create ; <!--Accion-->
        prov:wasAssociatedWith  <https://example.com/users/1> ; <!--Usuario-->
        prov:atTime             "2017-10-23T19:23:00.512Z"^^xsd:dateTime .  <!--Tiempo-->
            
<https://example.com/repository/resource>
        prov:wasGeneratedBy  _:b1 . <!--Nodo trellis que realiza el cambio-->

_:b1    rdf:type                prov:Activity ; <!--Tipo-->
        rdf:type                as:Update ; <!--Accion-->
        prov:wasAssociatedWith  <https://example.com/users/2> ; <!--Usuario-->
        prov:atTime             "2017-10-23T19:39:54.435Z"^^xsd:dateTime . <!--Tiempo-->

<https://example.com/repository/resource>
        prov:wasGeneratedBy  _:b2 . <!--Nodo trellis que realiza el cambio-->

_:b2    rdf:type                prov:Activity ; <!--Tipo-->
        rdf:type                as:Update ; <!--Accion-->
        prov:wasAssociatedWith  <https://example.com/users/1> ; <!--Usuario-->
        prov:atTime             "2017-10-23T19:48:16.076Z"^^xsd:dateTime . <!--Tiempo-->
```

También es posible realizar la auditoria del dato sobre una versión de un recurso, en un instante determinado del tiempo, mediante la aplicación del estándar memento.

**Conclusiones**

Creemos que Trellis ofrece una auditoria suficiente del dato, pudiendo reconstruir de forma completa el ciclo de vida del dato, incluso de forma mucha mas exhaustiva mediante el uso de memento , es posible realizar una trazabilidad completa del dato en cualquiera de sus versiones anteriores.

###### Versionado de entidades

Trellis mantiene un registro de cada cambio realizado sobre un recurso. Esto se almacena de manera eficiente al modelar un recurso como un flujo de cambios a lo largo del tiempo, lo que significa que se puede recuperar el estado de un recurso en cualquier momento arbitrario.

Esto se gestiona siguiendo el estándar [Memento](https://tools.ietf.org/html/rfc7089), recogido en el documento  [Memento Guía y Normativa.md](./Memento%20Gu%C3%ADa%20y%20Normativa.md)

Por ejemplo, dado un determinado recurso, es posible realizar una negociación del instante de tiempo en el que el cliente desea obtener el recurso, por medio del uso de la cabecera **Accept-Datetime** en la petición. 

```http
Accept-Datetime: Mon, 30 Oct 2017 20:15:00 GMT
```

De esta forma el cliente obtendrá una redirección a la versión más cercana al instante de tiempo demandado en la petición, de la forma

```
https://example.org/repository/resource?version=1508889600734
```

La representación del recurso, tendrá entonces una cabecera **Memento-Datetime**, que indicará de esta manera, que el recurso es una versión (un memento), y el instante de creación 

```HTTP
Memento-Datetime: Wed, 25 Oct 2017 00:00:00 GMT
```

Los mementos (versiones), son inmutables, y guardan el estado exacto de esa versión, en ese momento del tiempo, por lo que no es posible borrarlos o cambiarlos

Cada recurso también puede ofrecer una lista de las versiones disponibles (**TimeMaps**), lo que permite una trazabilidad completa de los cambios de estado de un recurso, aunque como se expreso en el ejemplo anterior, un cliente siempre puede reclamar un instante concreto de tiempo, incluso si ese instante no aparece en la lista de TimeMaps (en ese caso resolverá al recurso más cercano en el tiempo).

La lista de recursos están disponibles con la cabecera Link, de la forma 

```
Link: <timemap-url>; rel="timemap"
```

En Trellis, esta es siempre la URL del recurso seguida de `?ext=timemap`, y se obtendrá es estado de un recurso LDP-RS completo, salvo que este es inmutable (no se permiten POST, PUT, PATCH o DELETE).

Por lo tanto los TimeMaps, describen todos los recursos mementos de un determinado recurso LDP-RS, incluyendo su localización, y la dimensión de tiempo de un recurso.

Un ejemplo de las tripletas obtenidas para un TimeMap de un recurso puede ser el siguiente:

```html
@prefix memento: <http://mementoweb.org/ns#> .
@prefix time: <http://www.w3.org/2006/time#> .

<!--Tripletas de pertenencis de un recurso con sus versiones-->
<resource> a memento:OriginalResource, memento:TimeGate ;
  memento:timegate <resource> ;
  memento:timemap <resource?ext=timemap> ;
  memento:memento <resource?version=1> , <resource?version=2> , <resource?version=3> .

<!--Tripletas que definen el memento-->
<resource?ext=timemap> a memento:TimeMap ;
  time:hasBeginning <http://reference.data.gov.uk/id/gregorian-instant/2004-04-12T13:20:00> ;
  time:hasEnd <http://reference.data.gov.uk/id/gregorian-instant/2012-06-02T11:51:00> .

<!--Tripletas de versiones: Version 1-->
<resource?version=1> a memento:Memento ;
  memento:original <resource> ;
  memento:timegate <resource> ;
  memento:timemap <resource?ext=timemap> ;
  time:hasTime <http://reference.data.gov.uk/id/gregorian-instant/2004-04-12T13:20:00> ;
  memento:mementoDatetime "2004-04-12T13:20:00Z"^^xsd:dateTimeStamp .

<!--Tripletas de versiones: Version 2-->
<resource?version=2> a memento:Memento ;
  memento:original <resource> ;
  memento:timegate <resource> ;
  memento:timemap <resource?ext=timemap> ;
  time:hasTime <http://reference.data.gov.uk/id/gregorian-instant/2007-01-02T17:42:00> ;
  memento:mementoDatetime "2007-01-02T17:42:00Z"^^xsd:dateTimeStamp .

<!--Tripletas de versiones: Version 3-->
<resource?version=3> a memento:Memento ;
  memento:original <resource> ;
  memento:timegate <resource> ;
  memento:timemap <resource?ext=timemap> ;
  time:hasTime <http://reference.data.gov.uk/id/gregorian-instant/2012-06-02T11:51:00> ;
  memento:mementoDatetime "2012-06-02T11:51:00Z"^^xsd:dateTimeStamp .
```

**Conclusiones**

Creemos que Trellis ofrece gestión de versiones robusta, respaldada por el  estándar [Memento](https://tools.ietf.org/html/rfc7089), y por lo tanto, interpretable y ampliamente documentada.

En adicción a la auditoria de datos ofrecida por Trellis, es posible una trazabilidad exhaustiva, tanto del estado del dato, como las acciones realizadas sobre el y los usuarios que las hicieron y por lo tanto cubre ampliamente los requerimientos del proyecto.

###### Arquitectura de URIs

Trellis ofrece una gran flexibilidad a la hora de construir URIs, por lo que sean los que sean los requerimientos del proyecto en lo relativo a la construcción de URIs, Trellis debería de soportarlo.

Para ello Trellis se apoya en los estándares propuestos por la [Linked Data Platform](https://www.w3.org/TR/ldp/), y descritos en el documento [Requisitos funcionales para API REST LDP en proyecto ASIO de la UM](./Requisitos%20funcionales%20para%20API%20REST%20LDP%20en%20proyecto%20ASIO%20de%20la%20UM.md), donde se presenta el concepto de recursos y contenedores.

![recursos y contenedores](https://www.w3.org/TR/ldp/images/ldpc-hierarchy.png)

Para evaluar la idoneidad del la Arquitectura de URIs, sobre la implementación de Trellis, se mapearan los requerimientos o buenas practicas recogidos en el documento [https://www.w3.org/TR/ldp/images/ldpc-hierarchy.png](../../08-Esquema_de_URIs_H%C3%A9rcules/ASIO_Izertis_ArquitecturaDeURIs.md), con las soluciones a los mismos que Trellis puede ofrecer, aunque obviamente, esta construcción, debe de realizarse por los servicios o microservicios dedicados a el proceso de inserción de datos, esta debe de ser soportada por Trellis.

**Diseño de URIs** (se hacen anotaciones en rojo con la aportación o desde el punto de vista la funcionalidad que puede ofrecer Trellis)

Se define como base del diseño de URIs, la siguiente propuesta

**http://{dominio}/{tipo}/{concepto}/{referencia}**

- ***{dominio}*** es una combinación del host y del sector relevante. El sector puede ser un subdominio o el primer componente del path. &rarr;<span style="color:red"> En el caso de trellis, seria la combinación de Host donde Trellis atendera peticiones + la BaseURL definida</span>

- ***{tipo}*** debería ser un valor entre un conjunto pequeño de valore que declaren el tipo de recurso que se está identificando. Ejemplos típicos pueden ser:  &rarr;<span style="color:red"> En el caso de trellis, el tipo se definiria simplemente simplemente un contenedor (probablemente básico). El identificador  del contenedor puede ser sugerido por el uso de la cabecera Slug</span>
  - 'id' ó 'item' para valores del mundo real
  - 'doc' para documentos
  - 'def' para definiciones de conceptos
  - 'set' para conjuntos de datos

- ***{concepto}*** podría ser una colección, el tipo de objeto del mundo real identificado, el nombre del esquema de conceptos, etc. &rarr;<span style="color:red"> En el caso de trellis, el concepto se definiria simplemente simplemente un contenedor, y representaria una clase, por ejemplo investigador (probablemente seria interesante que fuese un contenedor directo ya que estos, tenen referencias hacia el nivel superior o inferior de la jerarquia de contenedores o recursos). El identificador del contenedor puede ser sugerido por el uso de la cabecera Slug</span>

- ***{referencia}*** es un ítem, concepto o término específico &rarr;<span style="color:red"> En el caso de trellis, el concepto se definiria simplemente simplemente un Recurso bien RDF, bien no RDF (binarios), y representaria una instancia de una clase, por ejemplo investigador . El identificador del recurso puede ser sugerido mediante la cabecera Slug, esto permite la creacion de URIs opacas</span>

**Recomendaciones para URIs** (se hacen anotaciones en rojo con la aportación o desde el punto de vista la funcionalidad que puede ofrecer Trellis)

- Evitar declarar el nombre del proyecto u organización que genera la URI si no aporta nada al significado de la misma
- Evitar números de versión para identificar conceptos. En caso de identificar entidades que estén sujetas a diferentes versiones, se puede utilizar una URI genérica sin número de versión que identifica la entidad, y desde ella, redirigir a una URI que incluya la última versión. &rarr;<span style="color:red"> El estándar memento, implementado por Trellis, cubre el control de versiones en distintas líneas temporales sobre una misma entidad, incluyendo borrados, e implementa de la forma descrita el acceso a esas versiones</span> 
- Reusar identificadores existentes. Para los recursos que tienen un identificador único, se puede reusar dicho identificador en el campo {referencia} de la URI. &rarr;<span style="color:red"> El estándar LDP recomienda la no reutilización de URIs, pero obviamente, dento del mismo contexto. En caso de hacer reutilización de identificadores de recursos externos, no habria problema, siempre y cuando estos generasen URIs distintas.  En cualquier caso, el uso del la misma URI, generara una nueva versión del recurso</span> 
- Evitar el uso de auto-incrementos automáticos al generar URIs únicas.  &rarr; <span style="color:red"> Trellis, como generador de URIs, no usa auto-incrementos, en cualquier caso se recomienda generarlo explicitamente mediante la cabecera Slug, siguiendo el criterio que mejor se adapte al proyecto</span> 
- Evitar el uso de *query-strings* (ejemplo, ?parametro=valor) que se pueden utilizar para buscar valores en una base de datos y a menudo dependen de una implementación concreta.   &rarr; <span style="color:red"> Trellis tampoco usa query-strings, los datos son pasados por headers, o en el body de la petición</span>
- Evitar extensiones de ficheros, especialmente las que indican una tecnología concreta como puede ser .jsp).    &rarr; <span style="color:red"> En Trellis los ficheros son recursos LDP (LDP-NR), por lo que siguen las mismas restricciones que el resto de recursos, y pueden ser definidas como URIs opacas mediante el uso de la cabecera Slug</span>
- Diseñar las URIs para múltiples formatos. Mediante negociación de contenido, la misma URI genérica puede redirigir a URIs específicas en formatos concretos.  &rarr; <span style="color:red"> La negociación de contenido, en LDP y Trellis, siempre por cabeceras, content-type y accept</span>
- Enlazar representaciones múltiples. En HTML puede utilizarse un elemento <link> con el atributo rel ó alternate apuntando a otra representación.  &rarr; <span style="color:red"> En LDP se usa la cabecera Link, pero también pueden existir tripletas para enlazar  entidades</span>
- Utilizar redirecciones 303 para las URIs que identifican conceptos del mundo real.  &rarr; <span style="color:red"> La LDP también lo prevé, y por tanto Trellis lo implementa y por lo tanto puede retornar 303, con la cabecera Location, con el recurso relacionado</span>
- Utilizar servicios dedicados para generar URIs persistentes. Algunos servicios pueden ser: purl.org, w3id.org, identifiers.org, etc.
- Las URIs que definan propiedades deben ser dereferenciables. Al acceder al contenido de las URIs de propiedades, al menos se debería obtener un vocabulario RDFS describiendo dicha propiedad. 
- Se recomienda que la representación RDF de los recursos contenga al menos una declaración rdf:type   &rarr; <span style="color:red"> Obligatorio según la LDP, por lo tanto Trellis lo implementa</span>
- Representar relaciones de pertenencia a un contenedor mediante URIs jerárquicas. Por ejemplo, si existe un contenedor para representar una institución que alberga varios grupos de investigación se utilizarán URIs como `http://example.org/institucion/` para representar la institución y: `http://example.org/institucion/grupo1` para representar a un grupo de dicha institución.  &rarr; <span style="color:red"> La jerarquia puede ser facilmente modelado en Trellis mediante el uso de contenedores, creando asi una jerarquia de URIs</span>
- Utilizar una barra de separación al final de las URIs que representan contenedores. Por ejemplo, es preferible `http://example.org/contenedor/` a `http://example.org/contenedor`, especialmente al utilizar URIs relativas. 
- Utilizar fragmentos como identificadores de recursos. Un fragmento en una URI se introduce mediante el símbolo # y se denominan URIs hash[[1\]](#_ftn1). Cuando un cliente solicita una URI con un fragmento, el protocolo http descarta el fragmento y hace la solicitud a la servidor utilizando el resto de la URI. El resultado es que la URI original no puede utilizarse para identificar un documento Web concreto y puede utilizarse para identificar recursos que no correspondan a documentos, como personas o conceptos abstractos. Por ejemplo, la URI: `http://example.org/contenedor#id23` podría utilizarse para identificar el recurso #id23 que podría identificar recursos como personas, objetos, etc. 
- Usar purl para apuntar a direcciones url fijas.

**Conclusiones**

Creemos que Trellis siendo una implementación robusta de los principios de la LDP, ofrece flexibilidad suficiente para adaptarse a cualquier esquema de URIs propuesto para le proyecto.  

###### Negociación de contenidos

Trellis soporta negociación de contenidos, siguiendo los estándares recogidos por el protocolo HTTP, aceptando las cabeceras  Content-Type o Accept.

En cuanto a los recursos RDF, acepta los formatos más estándar y los exigidos por la LDP, tales como `text/turtle` , `application/n-triples`, `application/ld+json` y adicionalmente da soporte a representaciones HTML.

Por otra parte tal como se comento en el apartado Versionado de entidades, puede existir negociación de contenidos en la dimensión temporal

**Conclusiones**

Creemos que Trellis implementando las recomendaciones de la LDP, y añadiendo alguna otra, tal como HTML o n-triples para la negociación de contenido, debería de ser mas que suficiente para el cumplimento de los requisitos del proyecto

###### Integración con la arquitectura general propuesta para el proyecto ASIO

El servidor LDP, en este caso Trellis, esta destinado a ser la parte central de la arquitectura general, ya que tanto los componentes de la arquitectura destinados a gestionar la ingesta de información (backend), como los componentes destinados al consumo (frontend), tendrán como único punto de acceso al sistema de almacenamiento, dicho servidor, pudiéndose únicamente interactuar con los recursos mediante invocaciones al API Rest LDP.

Esto garantizara que cualquier operación realizada sobre los datos, tendrá que realizarse siguiendo las indicaciones de la LDP, siguiendo también los criterios de seguridad ([autentificación y autorización](#Autentificación y Autorización)) definidos para le proyecto, manteniendo el [versionado de entidades](#Versionado de entidades) y la [auditoría de datos](#Auditoría de datos) descritos en este mismo documento

Dado que el resto de aplicaciones tendrán que interactuar con Trellis, es conveniente analizar su interacción o integración mediante los siguientes criterios:

**Interfaces de comunicación**

En este caso Trellis ofrece dos patrones de comunicación:

- Comunicación síncrona
  * Trellis es una API Rest y por lo tanto cumple con los estándares de facto para este tipo de APIs, cumpliendo los protocolos HTTP/1 y HTTP/2.
  * Trellis añade a dichos estándares las recomendaciones de la LDP, como un subconjunto de estos, aplicables a Linked Data.
  * Dado que ambos patrones están ampliamente estandarizados, no debería de suponer ningún problema la interacción con Trellis para la gestión de recursos.
- Comunicación asíncrona
  - Dado que especialmente la parte de la solución encargada de la ingesta (backend), se desarrollara para el proyecto ASIO, mediante arquitectura orientada a microservicios y por lo tanto, potencialmente desacoplada y asíncrona, la propagación de las acciones realizas en Trellis mediante mensajes en una cola **kafka**, hace que la integración con el resto de componentes de la arquitectura sea a priori sencilla.

**Stack tecnológico**

Dado que Trellis esta íntegramente desarrollado un lenguaje que se ejecuta bajo la JVM (en este caso java), puede ser desplegado en un contenedor, muy similar al resto de microservicios, y facilita su modificación (si fuese necesario), por el mismo equipo de desarrollo, que participa en el desarrollo de microservicios que interactúan con el (backend)

Por otro lado el uso de librerías comunes, usadas por Trellis, y los microservicios, tales como [Apache Jena](https://jena.apache.org/) o [RDF4J](https://rdf4j.org/), debería de facilitar la integración de el servidor LDP que gestiona los recursos, y los procesos que demandan la gestión, además de no ser requerido un nuevo conocimiento para realizar alguna modificación en Trellis (si fuese necesario).

**Licencia**

Trellis es licencia GLP, por lo que su código fuente es accesible, y por lo tanto modificable, y su uso es libre.

**Arquitectura**

Trellis ha sido diseñado mediante una arquitectura modular fuertemente desacoplada, lo que permite realizar las modificaciones que fuesen necesarias sin afectar a otras partes de su Core. 

**Volumetría**

Trellis, esta preparado para trabajar con grandes volúmenes de datos, en cualquier caso soporta escalado Horizontal para soportar grandes cantidades de datos, redundancia y altas cargas de servidor.

**Conclusiones**

Por todas las razones expuestas en este apartado, creemos que Trellis, es una herramienta con un encaje mas que aceptable dentro de la arquitectura general del proyecto.

###### Integración con distintas sistemas de almacenamiento (RDBMS o Triple Store)

Trellis prevé la integración con varios sistemas de almacenamiento, bien bases de datos relacionales (RDBMS)  o bien Triplestores.

Se han realizado pruebas con ambos (TDB y BlazeGraph para el caso de Triplestores y Postgresql para el caso de relacionales) y el resultado a sido un comportamiento muy robusto.

Esto cumple con el requerimiento expresado en el pliego, de poder cambiar un tipo de almacenamiento por otro, además siendo su comportamiento consistente, es decir, el patrón de peticiones y respuestas realizadas por distintos clientes, no se ve alterado, pues esto implica que el cambio de un triple store por otro debería de ser transparente para el resto de los componentes de la arquitectura, ya que estos, usaran siempre Trellis, para acceder a los datos.

**Conclusiones**

Por todas las razones expuestas en este apartado, creemos que Trellis, es una herramienta con un encaje mas que aceptable dentro de la arquitectura general del proyecto y cumple con el requisito expresado en el pliego de poder cambiar el sistema de almacenamiento de forma transparente al sistema.

### Propuesta Endpoint SPARQL

En este caso, el Endpoint SPARQL esta muy ligado a el Triplestore elegido, de forma que algunos Triplestores (como el caso de BlazeGraph) ofrecen como parte del mismo su propio Endpoint SPARQL, y otros como TDB2 no.

En el caso de Trellis, este siempre se conectara al Triplestore remoto, no de una forma directa, sino siempre atreves de su Endpoint SPARQL, por lo que siendo [SPARQL](https://www.w3.org/TR/rdf-sparql-query/) un lenguaje común, para realizar consultas, y ofreciendo  todos los EndPoint SPARQL un patrón común para realizar peticiones, desde el punto de vista de Trellis, el TripleStore usado, deberá de ser transparente, siempre que este exponga un EndPoint SPARQL.

#### Apache Jena Fuseki

##### ¿Que es Apache Jena Fuseki?

[Apache Jena Fuseki](https://jena.apache.org/documentation/fuseki2/) es un servidor SPARQL que puede correr como un servicio del sistema operativo, como una aplicación Web y como un servidor independiente. Proporciona un capa de abstracción en el acceso a el sistema de almacenamiento, que por medio de el uso de [Jena text query](https://jena.apache.org/documentation/query/text-query.html) que potencialmente proporciona un protocolo, para la conexión con otro sistema de almacenamiento. Por defecto usa sistema de almacenamiento TDB, que proporciona un sistema robusto y transaccional para el almacenamiento de datos .

En cuanto a la seguridad, esta es proporcionada por Apache Shiro, que permite implementar autentificación y autorización, y que a su vez es fácilmente integrable con la capa de permisos de Apache Jena.

Fuseki proporciona distintas interfaces para realizar consultar SPARQL, tanto de lectura de datos como de actualización:

- Frontal Web
- API Rest

##### Aplicación dentro del proyecto ASIO

Por una parte existe un requerimiento en el pliego de que debe existir un EndPoint SPARQL, disponible para su explotación por los usuarios y este podría cubrirse con el EndPoint desplegado con Fuseki.

Por otra parte, el uso de un EndPoint que implemente el protocolo SPARQL, permite abstraer a el servidor LDP (Trellis), del sistema de almacenamiento usado, que como se a comentado con anterioridad es otro de los requisitos del pliego 



![uso trellis](https://i.ibb.co/ZgC643N/SPARQL-schema.jpg)



Otro aspecto a considerar, son los aspectos de seguridad tales como autorización y autentificación, en principio, ambos podrían cubrirse en el caso de el uso de Fuseki, especialmente en el caso se uso por agentes humanos, en el caso de uso por agentes automáticos (maquinas), debido a que la interacción se realizara siempre mediante el uso de Trellis, y esta seguridad ya esta contemplada en la herramienta, pues probablemente, no sea necesario.

Hay sistemas de almacenamiento (por ejemplo BlazeGraph), que implementan su propio servidor SPARQL, en ese caso, podría evaluarse la posibilidad de usarlo en sustitución de Fuseki, siempre y cuando cumpla con el protocolo SPARQL 1.1, cumpla con los requisitos de seguridad y sea totalmente compatible con el uso de Trellis.

Otro aspecto a considerar, es que el uso o no del frontal propuesto por Fuseki, que en principio es funcional, pero el proyecto ASIO ya que proporciona interfaces graficas para las operaciones más comunes, pero podría requerirse algún otro requerimiento que no este soportado y por lo tanto , tener que crear un nuevo frontal que lo implemente



![frontal Fuseki](https://i.ibb.co/XLXdFW9/forntal-fuseki.png)

**Conclusiones**

Apache Fuseki en principio parece una herramienta bastante flexible (soporta múltiples sistemas de almacenamiento) y madura para soportar los requerimientos del proyecto, y a su vez la integración con otros componentes (se ha probado con éxito con Trellis), debería garantizar el éxito.

En definitiva, proporciona un comportamiento que se ajusta a los estándares definidos para el protocolo SPARQL 1.1, y probablemente cumpla con los requerimientos del proyecto ASIO.

### Pruebas realizadas

#### Trellis

Se ha creado el repositorio [asio_ldp](https://github.com/HerculesCRUE/ib-asio-ldp), con la finalidad de poder alojar en el mismo, los cambios que puedan ser necesarios, sobre el servidor Trellis, usando como base la última versión (0.10).

Se ha desplegado tanto en contenedores Docker, como de forma local, con el mismo resultado (en cuanto a los resultados de la evaluación del Test Suit), por lo tanto, podemos garantizar que el despliegue o la configuración del sistema de almacenamiento no altera el resultado

##### Sistemas de almacenamiento

###### Bases de datos relacionales

**POSTGRESQL**

Se ha desplegado con el siguiente fichero de configuración:

```bash
server:
  applicationConnectors:
    - type: http
      port: 8080
  requestLog:
    appenders:
      - type: file
        currentLogFilename: /opt/trellis/log/access.log
        archive: true
        archivedLogFilenamePattern: /opt/trellis/log/access-%i.log
        archivedFileCount: 5
        maxFileSize: 100K

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

database:                             # Configuracion de BBDD
  driverClass: org.postgresql.Driver
  user: usuario
  password: password
  url: jdbc:postgresql://db/db-name

binaries: /opt/trellis/data/binaries

mementos: /opt/trellis/data/mementos

namespaces: /opt/trellis/data/namespaces.json

# This may refer to a static base URL for resources. If left empty, the
# base URL will reflect the Host header in the request.
baseUrl: #/fuseki/trellis

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

###### TripleStores

**En menoría**

Se ha desplegado con el siguiente fichero de configuración:

```bash
server:
  applicationConnectors:
    - type: http
      port: 8080
  requestLog:
    appenders:
      - type: file
        currentLogFilename: /opt/trellis/log/access.log
        archive: true
        archivedLogFilenamePattern: /opt/trellis/log/access-%i.log
        archivedFileCount: 5
        maxFileSize: 100K

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

binaries: /opt/trellis/data/binaries

mementos: /opt/trellis/data/mementos

namespaces: /opt/trellis/data/namespaces.json

# This may refer to a static base URL for resources. If left empty, the
# base URL will reflect the Host header in the request.
baseUrl: #/fuseki/trellis

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

**TBD integrado**

Se ha desplegado con el siguiente fichero de configuración:

```bash
server:
  applicationConnectors:
    - type: http
      port: 8080
  requestLog:
    appenders:
      - type: file
        currentLogFilename: /opt/trellis/log/access.log
        archive: true
        archivedLogFilenamePattern: /opt/trellis/log/access-%i.log
        archivedFileCount: 5
        maxFileSize: 100K

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

resources: /opt/trellis/data/rdf                   # ruta de TripleStore embebido

binaries: /opt/trellis/data/binaries

mementos: /opt/trellis/data/mementos

namespaces: /opt/trellis/data/namespaces.json

# This may refer to a static base URL for resources. If left empty, the
# base URL will reflect the Host header in the request.
baseUrl: #/fuseki/trellis

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

**En menoría**

Se ha desplegado con el siguiente fichero de configuración:

```bash
server:
  applicationConnectors:
    - type: http
      port: 8080
  requestLog:
    appenders:
      - type: file
        currentLogFilename: /opt/trellis/log/access.log
        archive: true
        archivedLogFilenamePattern: /opt/trellis/log/access-%i.log
        archivedFileCount: 5
        maxFileSize: 100K

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

binaries: /opt/trellis/data/binaries

mementos: /opt/trellis/data/mementos

namespaces: /opt/trellis/data/namespaces.json

# This may refer to a static base URL for resources. If left empty, the
# base URL will reflect the Host header in the request.
baseUrl: #/fuseki/trellis

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

**TBD2 mediante conexión a EndPoint Fuseki**

Se ha desplegado con el siguiente fichero de configuración:

```bash
server:
  applicationConnectors:
    - type: http
      port: 8080
  requestLog:
    appenders:
      - type: file
        currentLogFilename: /opt/trellis/log/access.log
        archive: true
        archivedLogFilenamePattern: /opt/trellis/log/access-%i.log
        archivedFileCount: 5
        maxFileSize: 100K

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

resources: http://blazegraph:9999/blazegraph/sparql # host y path de end point sparql

binaries: /opt/trellis/data/binaries

mementos: /opt/trellis/data/mementos

namespaces: /opt/trellis/data/namespaces.json

# This may refer to a static base URL for resources. If left empty, the
# base URL will reflect the Host header in the request.
baseUrl: #/fuseki/trellis

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

**BlazeGraph mediante conexión a EndPoint propio**

Se ha desplegado con el siguiente fichero de configuración:

```bash
server:
  applicationConnectors:
    - type: http
      port: 8080
  requestLog:
    appenders:
      - type: file
        currentLogFilename: /opt/trellis/log/access.log
        archive: true
        archivedLogFilenamePattern: /opt/trellis/log/access-%i.log
        archivedFileCount: 5
        maxFileSize: 100K

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

resources: http://localhost:3030/trellis/         # host y path de end point sparql

binaries: /opt/trellis/data/binaries

mementos: /opt/trellis/data/mementos

namespaces: /opt/trellis/data/namespaces.json

# This may refer to a static base URL for resources. If left empty, the
# base URL will reflect the Host header in the request.
baseUrl: #/fuseki/trellis

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



##### Resultados

Para evaluar el cumplimiento de dichos requisitos de primera mano, se ha usado el [LDP Test Suit](https://dvcs.w3.org/hg/ldpwg/raw-file/default/tests/ldp-testsuite.html), creado exprofeso por la LDP, para evaluar el nivel de cumplimiento.

Los resultados, y las causas de los *"errores"* en los test, están descritos de forma exhaustiva en el documento [Analisis de Test LDP (caso de uso Trellis).md](./Analisis%20de%20Test%20LDP%20(caso%20de%20uso%20Trellis).md)

