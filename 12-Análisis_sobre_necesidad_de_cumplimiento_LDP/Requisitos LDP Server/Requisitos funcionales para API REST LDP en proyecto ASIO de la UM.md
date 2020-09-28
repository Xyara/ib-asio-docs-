![](./images/logos_feder.png)

# Requisitos funcionales para API REST LDP en proyecto ASIO de la UM

## Introducción

### Propósito

El presente documento, tiene como propósito detallar los requerimientos funcionales para la implementación de un API REST para recursos RDF y NO-RDF, que cumpla, en la mayor medida posible, los estándares  impuestos por la [Linked Data Platform](https://www.w3.org/TR/ldp/), que define un conjunto de normativas, estándares y buenas practicas sobre recursos Web, algunos basados en RDF, para proporciona runa arquitectura que permita la consulta, creación, modificación y borrado, de datos vinculados en la Web, intentando asimismo, incorporar otros estándares, como es el estándar [Memento](https://tools.ietf.org/pdf/rfc7089.pdf), que establece un protocolo para la gestión del histórico de documentos, permitiendo de esta forma, recuperar cualquier versión anterior.

### Alcance

El presente documento especifica, el su primera versión, los requerimientos funcionales y no funcionales que se deben tener en cuenta, en el diseño e implementación o selección de un API REST LDP, impuestos principalmente por la [Linked Data Platform](https://www.w3.org/TR/ldp/), teniendo en cuenta asimismo el requisito deseable, de tener acceso a cualquier versión histórica de los documentos almacenados en dicho servidor [Memento](./Memento%20Gu%C3%ADa%20y%20Normativa.md).

El presente documento pretende de esta forma servir de base y justificación, para cualquier decisión arquitectónica que a partir de la definición de dichos requisitos pueda derivarse, ya sea la implementación propia de un servidor linked data, ya sea la justificación de un determinado stack tecnológico que cumpla en gran medida los requisitos aquí enumerados.

Por otro lado, se establecerá la base de los criterios de aceptación, que la herramienta una vez implementada (en caso de implementación propia), o integrada (en caso de selección de un herramienta externa), deberá cumplir.

### Terminología LPD

#### Link

Es la relación entre dos recursos, cuando un recurso (Sujeto), se refiere a otro recurso en un contexto (predicado), por medio de su URI (Objeto)

#### Linked Data

Vinculación de conceptos arbitrarios, por medio de RDF, siguiendo los siguientes patrones:

- El uso de URIs, para la identificación un equivoca de una entidad.
- Modelado de atributos, y recuperación de información de dicha entidad, por medio de estándares tales como RDF o SPARQL.
- Incluyen Link a otras entidades, de forma que los datos pueden ser explorados.

#### Cliente

 Aquel programa o usuario final que realiza peticiones usando el protocolo HTTP, para interactuar con los recursos, ya sea en operaciones de lectura o escritura.

#### Servidor

 Aquel programa que realiza acciones sobre los Linked Data al recibir peticiones de los clientes, enviando a los mismos la oportuna respuesta. En este contexto, entenderemos Servidor como aquel que implementara los estándares descritos en el presente documento.

#### LDPR (Linked Data Platform Resource)

 Un recurso, de acuerdo con las especificaciones de la LPD

##### Linked Data Platform RDF Source (LDP-RS)

Un recurso **representable** por un grafo RDF

##### Linked Data Platform Non-RDF Source (LDP-RS)

Un recurso **no representable** por un grafo RDF (ficheros binarios, texto, HTML u otros...)

#### LDPC (Linked Data Platform Container)

Un recurso LDP-RS que contiene una colección de documentos vinculados, y obedece a las acciones de creación, modificación, enumeración y borrado requeridas por un cliente. En este documento se definen tres tipos de contenedores.

##### LDP-BC (Linked Data Platform Basic Container)

Un LDPC que define un simple link a los documentos contenidos en el.

##### LDP-DC (Linked Data Platform Direct Container)

Un LDPC que añade el concepto de pertenecía ([Membership](###Terminología)), que permite más flexibilidad a la forma que toman las tuplas de pertenencia, y permite que los miembros sean cualquier tipo de recurso, no solo documentos.

##### LDP-IC (Linked Data Platform Indirect Container)

Un LDPC similar a LDP-DC, pero a diferencia de este, es capaz de tener miembros cuyas URIs, se basan el el contenido de los documentos contenidos, en lugar de las URIs asignadas a estos documentos.

#### Membership (Pertenencia)

Relación de un contenedor con los documentos que contiene, que pueden ser recursos distintos a sus documentos contenidos

#### Membership Triple (tripletas de pertenencia)

Conjunto de tripletas en formato RDF, cuya finalidad es poder listar los miembros de un LDPC, siguiendo uno de estos patrones:

|              | Sujeto                               | Predicado            | Objeto                               |
| ------------ | ------------------------------------ | -------------------- | ------------------------------------ |
| **Patrón 1** | membership-constant-URI (contenedor) | membership-predicate | member-derived-URI (recurso)         |
| **Patrón 2** | member-derived-URI (recurso)         | membership-predicate | membership-constant-URI (contenedor) |

La diferencia básicamente es el orden del sujeto y objeto, que normalmente viene determinada por la semántica del predicado , por ejemplo el predicado **ldp:member** usara el patrón 1 y **dcterms:isPartOf** usar el patrón 2.

Cada contenedor deberá exponer la propiedades necesarias, para que el cliente pueda determinar inequívocamente, que patrón se esta usando.

#### Membership Predicate (predicado de pertenencia)

Es el predicado usado para definir las tripletas de pertenencia, que como se comenta en el [punto anterior](#Membership Triple (tripletas de pertenencia)), determinara el patrón usado.

#### Containment (contención)

Es la relación que vincula un contenedor con sus recursos, y por lo tanto a su ciclo de vida. El ciclo de vida de un recurso, esta limitado por el ciclo de vida de su contenedor, es decir un recurso contenido, no puede crearse antes de que exista el contenedor que lo contiene.

#### Containment Triples (tripletas de contención)

Todas aquellas tripletas, pertenecientes al LDPC, que permiten listar los LDPR que pertenecen a dicho contenedor. Estas tripletas siguen **siempre** el patrón: 

<center><strong>LDPC URI &rarr; ldp:contains &rarr; document-URI</strong></center>

#### Minimal-container triples (Tripletas mínimas del contenedor)

Son aquellas tripletas del contenedor, que serán retornadas cuando el contenedor esta vacío, es decir, aquellas que no tienen relación con los documentos que este contiene. Actualmente esta definición es equivalente al conjunto total de tripletas, menos las tripletas de contención, menos lso predicados de pertenencia.

### Convenciones usadas en este documento

El namespace para LDP es [http://www.w3.org/ns/ldp#](http://www.w3.org/ns/ldp#).

Todos los ejemplos, se realizaran usando text/turtle para representar RDF.

Comúnmente se usar los siguientes prefijos:

```
@prefix dcterms: <http://purl.org/dc/terms/>.
@prefix foaf:    <http://xmlns.com/foaf/0.1/>.
@prefix rdf:     <http://www.w3.org/1999/02/22-rdf-syntax-ns#>.
@prefix ldp:     <http://www.w3.org/ns/ldp#>.
@prefix xsd:     <http://www.w3.org/2001/XMLSchema#>.
```

## Criterios de aceptación para un servidor LDP

Para establecer los criterios de aceptación, de cualquier software que implemente los requisitos de la LDP descritos en el presente documento, se usara el Test Suit, recomendado por la propia LDP, lo que probablemente nos garantizara, alinearnos correctamente con sus objetivos, proporcionándonos a su vez, un criterio objetivo, en base a su nivel de cumplimiento de la LDP, para la selección de una u otra herramienta, o evaluar si cualquier desarrollo propio, bien incremental sobre dicha herramienta, bien totalmente propio, mantiene su conformidad con las regulación establecida por la LDP.

**Test suit:** https://dvcs.w3.org/hg/ldpwg/raw-file/default/tests/ldp-testsuite.html

En el enlace bajo estas líneas como ejemplo, se puede ver los resultados de aplicar dicho test, sobre la herramienta Trellis y Apache Marmotta, que implementa un servidor LDP, y por lo tanto deberían de estar sujeto a su normativa

Resultados de evaluación de los test con la herramienta Trellis: [resultados](trellis-ldp-testsuite-execution-report.html)

Resultados de evaluación de los test con la herramienta Marmotta: [resultados](marmota-ldp-testsuite-execution-report.html)

Probablemente, tras mapear requisitos, con test, sea necesario incrementar el numero de test, para asegurar la completitud de test sobre los requisitos.

## Conceptos Generales LDP

### Recursos

Los LDPRs son aquellos recursos que se ajustan a los patrones establecidos por la [LDP](https://www.w3.org/TR/ldp/) por lo tanto las operaciones sobre dichos recursos, han de ser implementadas por un servidor LDP.

Las reglas para los recursos de la [LDP](https://www.w3.org/TR/ldp/) intentar dar respuesta a preguntas básicas como:

- ¿Qué representaciones de recursos deben usarse?
- ¿Cómo se maneja la detección de colisión optimista para las actualizaciones?
- ¿Cuáles deberían ser las expectativas del cliente para los cambios en los recursos vinculados, como los cambios de tipo?
- ¿Cómo puede el servidor facilitar al cliente la creación de recursos?
- ¿Cómo puede un recurso de gran tamaño ser paginado?

Adicionalmente a la parte normativa, la  [LDP](https://www.w3.org/TR/ldp/), ofrece una guia de mejores practicas que aborda cuestiones tales como:

- ¿Qué tipos de valores literales deberían usarse?
- ¿Hay algunos vocabularios típicos que deberían reutilizarse?
- ¿Qué pautas existen al interactuar con los LDPR que son comunes pero que no son lo suficientemente universales como para especificar normativamente?

Un servidor LDP debe de ser capaz de manejar dos tipos de recursos: los representables mediante RDF (LDPR-RS) y los que no admiten representación RDF (LDPR-NR), ales como binarios, texto plano, hojas de calculo, HTML ...

![LDP Resources](https://www.w3.org/TR/ldp/images/ldpr1.png)



Es posible que existan LDPR-RS, que contengan metadatos, sobre recursos LDPR-NR.

Para recursos de gran tamaño, la LDP, propone el uso de paginado. 

### Contenedores

Los contenedores agrupan recursos de un mismo contexto y dan solución a los siguientes aspectos:

- Ofrece una URL para realizar un POST para crear un nuevo recurso
- Permite realizar un GET para obtener la lisa de recursos
- Obtener información acerca de los recursos del contenedor
- Asegurar que los datos de un recurso son fácilmente accesibles
- Expresar un orden en las entradas del contenedor

El contenido de un contenedor, se expresa como un conjunto de tripletas. Existen tipos específicos de contenedores que permiten a los miembros del contenedor especificar pertenecía al mismo. En este caso suelen seguir el patrón (URI del recurso, ldp:member, URI contenedor)

El borrado de un contenedor implica actualizar los miembros que lo referencien, y probablemente el borrado de los mismos.

#### Contenedor Básico

 El ejemplo ilustra sobre un contenedor simple con tres recursos, y alguna información propia del contenedor, como su titulo, y el hecho de que es un contenedor

Petición a `http://example.org/c1`

```html
GET /c1/ HTTP/1.1
Host: example.org
Accept: text/turtle <!--Formato aceptado por el cliente--> 
```

Respuesta

```html
<!--Header-->
HTTP/1.1 200 OK <!--Codigo de respuesta-->
Content-Type: text/turtle <!--Formato enviado por el servidor--> 
Date: Thu, 12 Jun 2014 18:26:59 GMT <!--Fecha de respuesta--> 
ETag: "8caab0784220148bfe98b738d5bb6d13" <!--Versión especifica de un recurso-->
Accept-Post: text/turtle, application/ld+json <!--Formatos en que se aceptara un POST-->
Allow: POST,GET,OPTIONS,HEAD,PUT <!--OPERACIONES PERMITIDAS-->
Link: <http://www.w3.org/ns/ldp#BasicContainer>; rel="type", 
      <http://www.w3.org/ns/ldp#Resource>; rel="type" <!--Tipos de recursos en este caso 														contenedores y recursos-->
Transfer-Encoding: chunked <!--Codigifación de transferencia fragmentada-->

<!--Body-->
@prefix dcterms: <http://purl.org/dc/terms/>. <!--Prefijos-->
@prefix ldp: <http://www.w3.org/ns/ldp#>.
	<!--Tripletas de contención (indican miembros del contenedor)-->
<http://example.org/c1/> <!--Sujeto-->
   a ldp:BasicContainer; <!--Predicado, Objeto (es un contenedor basico)-->
   dcterms:title "A very simple container"; <!--Predicado(Titulo), Objeto (A very..)-->
   ldp:contains <r1>, <r2>, <r3>. <!--Predicado(contains), Objetos (r1,r2,r3)-->
```

Un POST de un nuevo recurso añadirá su URL a la lista de recursos contenidos

#### Contenedor Directo

Los **contenedores directos** permiten construcciones mas complejas, donde se puede definir condiciones jerárquicas en ambos sentidos,  es decir ldp:membershipResource apuntaría al contenedor padre y ldp:hasMemberRelation a los contenedores/recursos hijos.

El ejemplo ilustra sobre un recurso raíz, `http://example.org/netWorth/nw1` que en este caso modela el balance de un individuo.

Petición a  `http://example.org/netWorth/nw1/`

```html
GET /netWorth/nw1/ HTTP/1.1 
Host: example.org
Accept: text/turtle
```

Respuesta

```html
HTTP/1.1 200 OK <!--Codigo de respuesta-->
Content-Type: text/turtle <!--Formato enviado por el servidor--> 
Date: Thu, 12 Jun 2014 18:26:59 GMT <!--Fecha de respuesta-->
ETag: "0f6b5bd8dc1f754a1238a53b1da34f6b" <!--Versión especifica de un recurso-->
Link: <http://www.w3.org/ns/ldp#RDFSource>; rel="type", <!--Contenido tipo RDFSource-->
      <http://www.w3.org/ns/ldp#Resource>; rel="type" <!--Contenido tipo Resource-->
Allow: GET,OPTIONS,HEAD,PUT,DELETE  <!--OPERACIONES PERMITIDAS-->
Transfer-Encoding: chunked <!--Codigifación de transferencia fragmentada-->

<!--Body-->
@prefix ldp: <http://www.w3.org/ns/ldp#>. <!--Prefijo ldp-->
@prefix o: <http://example.org/ontology#>. <!--Prefijo Ontologia propia-->

<http://example.org/netWorth/nw1/> <!--Sujeto (el propio contenedor)-->
   a o:NetWorth; <!--es un Networth (Balance)-->
   o:netWorthOf <http://example.org/users/JohnZSmith>; <!--pertenece a Jonh Smith-->
   o:asset  <!--Activos-->
      <assets/a1>, <!--Activo 1-->
      <assets/a2>; <!--Activo 2-->
   o:liability <!--Pasivo-->
      <liabilities/l1>, <!--Pasivo 1-->
      <liabilities/l2>, <!--Pasivo 2-->
      <liabilities/l3>. <!--Pasivo 3-->
```

En el ejemplo se puede observar que todos comparten el mismo sujeto (<`http://example.org/netWorth/nw1/`>) y varios el mismo predicado (o:asset y o:liability). Si hiciéramos un contenedor básico, se duplicaría mucha información.

Accediendo a los assets

Petición a  `http://example.org/netWorth/nw1/assets/`

```html
GET /netWorth/nw1/assets/ HTTP/1.1 
Host: example.org
Accept: text/turtle
```

Respuesta

```html
HTTP/1.1 200 OK <!--Codigo de respuesta-->
Content-Type: text/turtle <!--Formato enviado por el servidor--> 
Date: Thu, 12 Jun 2014 18:26:59 GMT <!--Fecha de respuesta-->
ETag: "6df36eef2631a1795bfe9ab76760ea75" <!--Versión especifica de un recurso-->
Accept-Post: text/turtle, application/ld+json <!--Formatos aceptados por el POST-->
Allow: POST,GET,OPTIONS,HEAD <!--Metodos permitidos-->
Link: <http://www.w3.org/ns/ldp#DirectContainer>; rel="type", <!--DirectContainer-->
      <http://www.w3.org/ns/ldp#Resource>; rel="type" <!--Resource-->
Transfer-Encoding: chunked <!--Codigifación de transferencia fragmentada-->
      
@prefix ldp: <http://www.w3.org/ns/ldp#>. <!--Prefijo ldp-->
@prefix dcterms: <http://purl.org/dc/terms/>. <!--Prefijo dcterms-->
@prefix o: <http://example.org/ontology#>. <!--Prefijo ontologia-->

<http://example.org/netWorth/nw1/assets/><!--Sujeto el contenedor directo-->
   a ldp:DirectContainer; <!--Es un Contenedor directo-->
   dcterms:title "The assets of JohnZSmith"; <!--Titulo-->
   ldp:membershipResource <http://example.org/netWorth/nw1/>; <!--Relacion padre-->
   ldp:hasMemberRelation o:asset; <!--Relacion hijos-->
   ldp:contains <a1>, <a2>. <!-- hijos-->
```

El caso es parecido con los Pasivos

Petición a  `http://example.org/netWorth/nw1/assets/`

```html
GET /netWorth/nw1/liabilities/ HTTP/1.1 
Host: example.org
Accept: text/turtle
```

Respuesta

```html
HTTP/1.1 200 OK <!--Codigo de respuesta-->
Content-Type: text/turtle <!--Formato enviado por el servidor--> 
Date: Thu, 12 Jun 2014 18:26:59 GMT <!--Fecha de respuesta-->
ETag: "6df36eef2631a1795bfe9ab76760ea75" <!--Versión especifica de un recurso-->
Accept-Post: text/turtle, application/ld+json <!--Formatos aceptados por el POST-->
Allow: POST,GET,OPTIONS,HEAD <!--Metodos permitidos-->
Link: <http://www.w3.org/ns/ldp#DirectContainer>; rel="type", <!--DirectContainer-->
      <http://www.w3.org/ns/ldp#Resource>; rel="type" <!--Resource-->
Transfer-Encoding: chunked <!--Codigifación de transferencia fragmentada-->
      
@prefix ldp: <http://www.w3.org/ns/ldp#>. <!--Prefijo ldp-->
@prefix dcterms: <http://purl.org/dc/terms/>. <!--Prefijo dcterms-->
@prefix o: <http://example.org/ontology#>. <!--Prefijo ontologia-->

<http://example.org/netWorth/nw1/liabilities/><!--Sujeto el contenedor directo-->
   a ldp:DirectContainer; <!--Es un Contenedor directo-->
   dcterms:title "The liabilities of JohnZSmith"; <!--Titulo-->
   ldp:membershipResource <http://example.org/netWorth/nw1/>; <!--Relacion padre-->
   ldp:hasMemberRelation o:liability; <!--Relacion hijos-->
   ldp:contains <l1>, <l2>, <l3>. <!-- hijos-->
```

Un POST de uno de los contenedores directos asset/liability sobre el contenedor, deberá crear un nuevo asset, y deberá añadirse a la lista de o:asset en el recurso nw1 y al predicado de ldp:contains

Petición a  `http://example.org/netWorth/nw1/liabilities/`

```html
<!--HEADERS-->
POST /netWorth/nw1/liabilities/ HTTP/1.1
Host: example.org
Accept: text/turtle
Content-Type: text/turtle
Content-Length: 63

<!--BODY-->
@prefix o: <http://example.org/ontology#>.

<> <!--Hace referencia al contenedor invocado-->
   a o:Liability.<!--Definimos el tipo-->
   <!--Aqui irian las propiedades-->
   # plus any other properties that the domain says liabilities have 
```

Respuesta

```html
HTTP/1.1 201 Created <!--Codigo de respuesta-->
Location: http://example.org/netWorth/nw1/liabilities/l4 <!--URL Acceso-->
Date: Thu, 12 Jun 2014 19:56:13 GMT <!--Fecha de respuesta-->
Link: <http://www.w3.org/ns/ldp#DirectContainer>; rel="type", <!--Contenedor-->
      <http://www.w3.org/ns/ldp#Resource>; rel="type" <!--Contenido-->
```

También seria necesario actualizar los contenedores

En el recurso net worth <<`http://example.org/netWorth/nw1/`>> **o:liability**  <liabilities/l4> 

En el contenedor liability <<`http://example.org/netWorth/nw1/liabilities/`>> ldp:contains  <l4> 

#### Contenedor Indirecto

Los **contenedores indirectos** permiten añadirse como una tripleta en un recurso. En este caso con el ejemplo de balance, se añadirá un contenedor indirecto para gestionar los asesores.

Petición GET a `http://example.org/netWorth/nw1/`:

```html
GET /netWorth/nw1/ HTTP/1.1
Host: example.org
Accept: text/turtle
```

Respuesta

```html
HTTP/1.1 200 OK <!--Codigo de respuesta-->
Content-Type: text/turtle <!--Formato enviado por el servidor--> 
Date: Thu, 12 Jun 2014 18:26:59 GMT <!--Fecha de respuesta-->
ETag: "e8d129f45ca31848fb56213844a32b49" <!--Versión especifica de un recurso--
Link: <http://www.w3.org/ns/ldp#DirectContainer>; rel="type", <!--DirectContainer-->
      <http://www.w3.org/ns/ldp#Resource>; rel="type" <!--Resource-->
Allow: GET,OPTIONS,HEAD,PUT,DELETE <!--Metodos permitidos-->
Transfer-Encoding: chunked <!--Codigifación de transferencia fragmentada-->


@prefix ldp: <http://www.w3.org/ns/ldp#>. <!--Prefijo ldp-->
@prefix dcterms: <http://purl.org/dc/terms/>. <!--Prefijo dcterms-->
@prefix foaf: <http://xmlns.com/foaf/0.1/>. <!--Prefijo foaf-->
@prefix o: <http://example.org/ontology#>. <!--Prefijo ontology-->

<http://example.org/netWorth/nw1/> <!--Sujeto el recurso-->
   a o:NetWorth; <!--Es del tipo o:NetWorth-->
   o:netWorthOf <http://example.org/users/JohnZSmith>; <!--Pertenece a JohnZSmith-->
   o:advisor <!--Tiene como asesores-->
   	 <advisors/bob#me>,     # URI of a person <!--URL Acceso bob-->
   	 <advisors/marsha#me>. <!--URL Acceso marsha-->
   	 
<advisors/> <!--Sujeto Advisors-->
   a ldp:IndirectContainer; <!--Es un contenedor indirecto-->
   dcterms:title "The asset advisors of JohnZSmith"; <!--Titulo-->
   ldp:membershipResource <>; <!--Es miembro del recurso padre-->
   ldp:hasMemberRelation o:advisor;  <!--Es miembros hijos a advisors-->
   <!--Esto informa a los clientes que cuando hagan un post a este container, necesitan incuir la tripleta del tipo (<>, foaf:primaryTopic, topic-URI) para informar al servidor que URI usar (topic-URI) en el nuevo membership triple-->
   ldp:insertedContentRelation foaf:primaryTopic; 
   ldp:contains
   	 <advisors/bob>,     # URI of a document a.k.a. an information resource
   	 <advisors/marsha>.  # describing a person
```

Para añadir un nuevo asesor

```html
<!--HEADERS-->
POST /netWorth/nw1/advisors/ HTTP/1.1 <!--Método + URL-->
Host: example.org <!--Host de la URL-->
Accept: text/turtle <!--Formato aceptado en la respuesta-->
Content-Type: text/turtle <!--Formato del body-->
Slug: george <!--URL Propuesta para el recurso a crear-->
Content-Length: 72

<!--Prefijos-->
@prefix foaf: <http://xmlns.com/foaf/0.1/>.
@prefix o: <http://example.org/ontology#>.

<> <!--Sujeto es la URI de la petición-->
   a o:Advisor;	<!--Definicion de tipo-->
   foaf:primaryTopic <#me>. <!--Definicion de topic-URI-->
   # plus any other properties that the domain says advisors have
```

Respuesta

```html
HTTP/1.1 201 Created <!--Codigo de respuesta-->
Location: http://example.org/netWorth/nw1/advisors/george <!--URL Recurso creado-->
Date: Thu, 12 Jun 2014 19:56:13 GMT <!--Fecha creación-->
Link: <http://www.w3.org/ns/ldp#RDFSource>; rel="type", <!--Contiene un RDFSource-->
      <http://www.w3.org/ns/ldp#Resource>; rel="type" <!--Contiene un Recurso-->
```

Si todo fue bien es se crea el recurso en la URI `http://example.org/netWorth/nw1/advisors/george`, y se añaden las siguientes tripletas

En el recurso net worth <<`http://example.org/netWorth/nw1/`>> **o:advisor**  <liabilities/george#me> 

En el contenedor liability <<`http://example.org/netWorth/nw1/advisors/`>> ldp:contains  <george> 

En resumen, en el grafico se muestran los contenedores vistos y sus relaciones con los recursos

![Contenedores y recursos](https://www.w3.org/TR/ldp/images/ldpc-hierarchy.png)

Como resumen, la tabla ilustra las accines segun el tipo de contenedor

| Completed Request                   | Efecto en Membership                                         | Efecto en Containment                                        |
| ----------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Crear recurso en contenedor Básico  | Nueva tripleta: (LDPC, ldp:contains, LDPR)                   | Lo mismo                                                     |
| Crear recurso en contenedor Directo | Nueva tripleta Link LDP-RS se crea en LDPR.  la URI del LDP-RS puede ser la misma que la de el LDP-DC | Nueva tripleta: (LDPC, ldp:contains, LDPR)                   |
| LDPR created in LDP-IC              | Nueva tripleta Link LDP-RS al contenido indicando la URI     | Nueva tripleta: (LDPC, ldp:contains, LDPR)                   |
| Borrar LDPR                         | Las tripletas Membership deben de ser eliminadas             | Las tripletas (LDPC, ldp:contains, LDPR) deben eliminarse    |
| Borrar LDPC                         | Las tripletas y los miembros han de borrarse                 | Las tripletas del tipo  (LDPC, ldp:contains, LDPR) and contained LDPRs deben borrarse |

#### Recuperar propiedades mínimas del contenedor

Hay métodos para recuperar solo la información relativa información relativa al propio contendor, excluyendo la información de los miembros que contiene usando la cabecera Prefer con el valor return=representation

```html
GET /container1/ HTTP/1.1
Host: example.org
Accept: text/turtle
<!--Indica que solo retorne los artibutos del contenedor con la cabecera Prefer: return=representation; -->
Prefer: return=representation; include="http://www.w3.org/ns/ldp#PreferMinimalContainer"
```

```html
HTTP/1.1 200 OK <!--Codigo de respuesta-->
Content-Type: text/turtle <!--Formato enviado por el servidor--> 
ETag: "_87e52ce291112" <!--Versión especifica de un recurso-->
Link: <http://www.w3.org/ns/ldp#DirectContainer>; rel="type", <!--DirectContainer-->
      <http://www.w3.org/ns/ldp#Resource>; rel="type" <!--Resource-->
Accept-Post: text/turtle, application/ld+json <!--Formatos aceptados por el POST-->
Allow: POST,GET,OPTIONS,HEAD <!--Metodos permitidos-->
Preference-Applied: return=representation <!--Prefer aplicada--> 
Transfer-Encoding: chunked <!--Codigifación de transferencia fragmentada-->
<!--Body-->
	<!--Prefijos-->
@prefix dcterms: <http://purl.org/dc/terms/>.
@prefix ldp: <http://www.w3.org/ns/ldp#>.
	<!--Artriubtos-->
<http://example.org/container1/> <!--Sujeto-->
   a ldp:DirectContainer; <!--es un DirectContainer-->
   dcterms:title "A Linked Data Platform Container of Acme Resources"; <!--Titulo-->
   ldp:membershipResource <http://example.org/container1/>; <!--Es miembro de-->
   ldp:hasMemberRelation ldp:member; <!--Tiene relación ser miembro de-->
   ldp:insertedContentRelation ldp:MemberSubject; <!--Relacion con hijos-->
   dcterms:publisher <http://acme.com/>. <!--Atributo publicador-->
```

### Cabeceras HTTP

#### Ejemplos sobre la cabecera Prefer

Sirve para que el cliente indique su preferencia de la porcion de tripletas sobre el recurso que quiere obtener

###### include

Define el contenido que el cliente desearía que se incluyese en la representación

```html
<!--include-parameter = "include" *WSP "=" *WSP ldp-uri-list-->
Prefer: return=representation; include="http://www.w3.org/ns/ldp#PreferMinimalContainer"
```

Donde WSP es el espacio en blanco y ldp-uri-list la lista de URIs (entre comillas) separadas por espacio

###### omit

Define el contenido que el cliente desearía que se omitiese en la representación

```html
<!--omit-parameter = "omit" *WSP "=" *WSP ldp-uri-list-->
Prefer: return=representation; include="http://www.w3.org/ns/ldp#PreferMinimalContainer"
```

Donde WSP es el espacio en blanco y ldp-uri-list la lista de URIs (entre comillas) separadas por espacio

###### Confictos

Cuando el servidor recibe en la cabecera Prefer parámetros conflictivos, no esta definida la actuación, pudiendo rechazar la petición o resolverla según crea conveniente.

La especificación prevé los siguientes URLs para usar con include o omit:

| [Containment triples](https://www.w3.org/TR/ldp/#dfn-containment-triples) | **http://www.w3.org/ns/ldp#PreferContainment**      |
| ------------------------------------------------------------ | --------------------------------------------------- |
| [Membership triples](https://www.w3.org/TR/ldp/#dfn-membership-triples) | **http://www.w3.org/ns/ldp#PreferMembership**       |
|                                                              | **http://www.w3.org/ns/ldp#PreferMinimalContainer** |
| [Minimal-container triples](https://www.w3.org/TR/ldp/#dfn-minimal-container-triples) | o el término equivalente pero en desuso             |
|                                                              | **http://www.w3.org/ns/ldp#PreferEmptyContainer**   |

 

###### Ejemplo

Dado el contenido del siguiente contenedor

```bash
# The following is the representation of
#   http://example.org/netWorth/nw1/assets/

# @base <http://example.org/netWorth/nw1/assets/>.
@prefix dcterms: <http://purl.org/dc/terms/>.
@prefix ldp: <http://www.w3.org/ns/ldp#>.
@prefix o: <http://example.org/ontology#>.

<>
   a ldp:DirectContainer;
   dcterms:title "The assets of JohnZSmith";
   ldp:membershipResource <http://example.org/netWorth/nw1/>;
   ldp:hasMemberRelation o:asset;
   ldp:insertedContentRelation ldp:MemberSubject.

<http://example.org/netWorth/nw1/>
   a o:NetWorth;
   o:asset <a1>, <a3>, <a2>.

<a1>
   a o:Stock;
   o:marketValue 100.00 .
<a2>
   a o:Cash;
   o:marketValue 50.00 .
<a3>
   a o:RealEstateHolding;
   o:marketValue 300000 .
```

Los clientes interesados solo en información del propio contenedor, pueden usar GET` request: `Prefer: return=representation; include="http://www.w3.org/ns/ldp#PreferMinimalContainer"

Request

```
GET /netWorth/nw1/assets/ HTTP/1.1
Host: example.org
Accept: text/turtle
Prefer: return=representation; include="http://www.w3.org/ns/ldp#PreferMinimalContainer"
```

Response 

```
HTTP/1.1 200 OK
Content-Type: text/turtle
ETag: "_87e52ce291112"
Link: <http://www.w3.org/ns/ldp#DirectContainer>; rel="type",
      <http://www.w3.org/ns/ldp#Resource>; rel="type"
Accept-Post: text/turtle, application/ld+json
Allow: POST,GET,OPTIONS,HEAD
Preference-Applied: return=representation
Transfer-Encoding: chunked

@prefix dcterms: <http://purl.org/dc/terms/>.
@prefix ldp: <http://www.w3.org/ns/ldp#>.
@prefix o: <http://example.org/ontology#>.

<http://example.org/netWorth/nw1/assets/>
   a ldp:DirectContainer;
   dcterms:title "The assets of JohnZSmith";
   ldp:membershipResource <http://example.org/netWorth/nw1/>;
   ldp:hasMemberRelation o:asset;
   ldp:insertedContentRelation ldp:MemberSubject.
```

También lo pueden hacer omitiendo contenidos

Request

```
GET /netWorth/nw1/assets/ HTTP/1.1
Host: example.org
Accept: text/turtle
Prefer: return=representation; omit="http://www.w3.org/ns/ldp#PreferMembership http://www.w3.org/ns/ldp#PreferContainment"
```

```
HTTP/1.1 200 OK
Content-Type: text/turtle
ETag: "_87e52ce291112"
Link: <http://www.w3.org/ns/ldp#DirectContainer>; rel="type",
      <http://www.w3.org/ns/ldp#Resource>; rel="type"
Accept-Post: text/turtle, application/ld+json
Allow: POST,GET,OPTIONS,HEAD
Preference-Applied: return=representation 
Transfer-Encoding: chunked

@prefix dcterms: <http://purl.org/dc/terms/>.
@prefix ldp: <http://www.w3.org/ns/ldp#>.
@prefix o: <http://example.org/ontology#>.

<http://example.org/netWorth/nw1/assets/>
   a ldp:DirectContainer;
   dcterms:title "The assets of JohnZSmith";
   ldp:membershipResource <http://example.org/netWorth/nw1/>;
   ldp:hasMemberRelation o:asset;
   ldp:insertedContentRelation ldp:MemberSubject.
```

Si además queremos incluir información de los recursos que contiene podemos realizar un  `GET` request: `Prefer: return=representation; include="http://www.w3.org/ns/ldp#PreferMembership http://www.w3.org/ns/ldp#PreferMinimalContainer"`.

Petición

```
GET /netWorth/nw1/assets/ HTTP/1.1
Host: example.org
Accept: text/turtle
Prefer: return=representation; include="http://www.w3.org/ns/ldp#PreferMembership http://www.w3.org/ns/ldp#PreferMinimalContainer"
```

Respuesta

```
HTTP/1.1 200 OK
Content-Type: text/turtle
ETag: "_87e52ce291112"
Link: <http://www.w3.org/ns/ldp#DirectContainer>; rel="type",
      <http://www.w3.org/ns/ldp#Resource>; rel="type"
Accept-Post: text/turtle, application/ld+json
Allow: POST,GET,OPTIONS,HEAD
Preference-Applied: return=representation
Transfer-Encoding: chunked

@prefix dcterms: <http://purl.org/dc/terms/>.
@prefix ldp: <http://www.w3.org/ns/ldp#>.
@prefix o: <http://example.org/ontology#>.

<http://example.org/netWorth/nw1/assets/>
   a ldp:DirectContainer;
   dcterms:title "The assets of JohnZSmith";
   ldp:membershipResource <http://example.org/netWorth/nw1/>;
   ldp:hasMemberRelation o:asset;
   ldp:insertedContentRelation ldp:MemberSubject.

<http://example.org/netWorth/nw1/>
   a o:NetWorth;
   o:asset <a1>, <a3>, <a2>.
```

### Información relevante de referencias normativas

Algunas normativas fuera del alcance de la LDP, tienen especial relevancia, y es conveniente conocerlas

#### Relativas a la arquitectura de la World Wide Web

- La membresía a un LDPC no es exclusiva; Esto significa que el mismo recurso (LDPR o no) puede ser miembro de más de un LDPC.
- Los servidores LDP no deben reutilizar los URI, independientemente del mecanismo por el cual se crean los miembros (POST, PUT, etc.). Existen ciertos casos específicos en los que un servidor LDPC puede eliminar un recurso y luego reutilizar el URI cuando identifica el mismo recurso, pero solo cuando es consistente con la arquitectura web. Si bien es difícil proporcionar absolutas garantías de no reutilización en todos los escenarios, la reutilización de URI crea ambigüedades para los clientes que es mejor evitar

#### Relativas a HTTP 1.1

- Los servidores LDP pueden admitir representaciones más allá de las necesarias para cumplir con esta especificación. Pueden ser formatos RDF tales como N3, NTriples u otros o No RDF tales como HTML, JSON, etc... La negociación HTTP, es usada para seleccionar el formato.
- Los recursos RDF pueden modificarse usando métodos no descritos en este documento, por ejemplo mediante el uso de SPARQL, siempre y cuando estos métodos no entren en conflicto con las especificaciones de este documento.
- Los documentos borrados deberían según las especificaciones de este documento, retornar un codigo 404 (Not Found) o 410 (Gone), pero el protocolo HTML, prevé otras opciones.
- Los servidores LDP, pueden cambiar el estado de un recurso, especialmente cuando se usan métodos no seguros. Por ejemplo, es aceptable que el servidor elimine triples de otros recursos cuyo sujeto u objeto es el recurso eliminado como resultado de una solicitud HTTP DELETE exitosa. También es aceptable y común que los servidores LDP no hagan esto: el comportamiento del servidor puede variar, por lo que los clientes LDP no pueden depender de él.
- Los servidores LDP pueden implementar PATCH HTTP para permitir modificaciones, especialmente reemplazos parciales, de sus recursos. Este documento o la definición de PATCH no requieren un conjunto mínimo de tripletas a modificar.
- Cuando el encabezado de solicitud d **Content-Type** está ausente de una solicitud, los servidores LDP pueden inferir el tipo de contenido inspeccionando el contenido del cuerpo de la entidad.

#### Relativas a RDF

- El estado de un LDPR permite tripletas con cualquier SUJETO. La URL utilizada para recuperar la representación de un LDPR no necesita ser  OBJETO de ninguna de sus tripletas
- La representación de un LDPC puede incluir un número arbitrario de triples adicionales cuyos SUJETOS son los miembros del contenedor, o que son de las representaciones de los miembros (si tienen representaciones RDF). Esto permite que un servidor LDP proporcione a los clientes información sobre los miembros sin que el cliente tenga que hacer un GET en cada miembro individualmente
- El estado de un LDPR puede tener más de un triple con un predicado rdf: type.

### Consideraciones de seguridad (no normativo)

Siendo LDP una extensión de HTTP, la normativa de seguridad de HTTP, esta vigente, no obligando LDP a realizar ninguna operación que pueda contradecir la seguridad de dicho protocolo. Por ejemplo, al realizar una operación PUT, sin la oportuna autorización, el servidor puede responder 401 (Unauthorized) o 403 (Forbidden) si contradice una determinada política de seguridad

## Requisitos LDP

### Recursos LDP

#### Requisitos Generales sobre Recursos

###### **Requisito RF_01_01_01 ** [(4.2.1.1 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Protocolo HTTP

El servidor LDP **DEBE** cumplir al menos con las especificaciones del [protocolo HTTP/1.1](https://tools.ietf.org/html/rfc7230)

###### Requisito RF_01_01_02 [(4.2.1.2 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Tipos de recursos

El servidor LDP **PUEDE** poder alojar tanto recursos LDP-RS como recursos LDP-NR

###### Requisito RF_01_01_03 [(4.2.1.3 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Entity Tags

El servidor LDP **DEBE** usar entity tags (ya sean fuertes o débiles), y darlos en las cabeceras eTag de las respuestas HTTP que contienen la representación de un recurso o respuestas con éxito al método HEAD. 

###### Requisito RF_01_01_04 [(4.2.1.4 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Advertir de soporte LDP

El servidor LDP que expone recursos LDP, **DEBE** advertir a los clientes que cumple con las especificaciones de la LDP, exponiendo la cabecera Link con la URI Objetivo http://www.w3.org/ns/ldp#Resource y un relation type establecido a "rel=type", en todas las respuestas. 

Notas: 

- Cualquier cliente podrá inferir en tiempo de ejecución que el servidor cumple con las especificaciones de la LDP, para todo tipo de recursos (LDP-RS o LDP-NR), por la presencia de la tripleta antes descrita. 

- No es equivalente la presencia de una tripleta tipo 

  <center><strong>Subject URI &rarr; rdf:type &rarr; ldp:resource</strong></center>

- LDP gestiona los recursos RDF (LDP-RS) y no (LDP-NR), siendo ambos definidos como LDPR, toda la normativa es aplicable a ambos, y por lo tanto no hay ninguna incompatibilidad

###### Requisito RF_01_01_05 [(4.2.1.5 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Tratamiento de URIs

El servidor LDP **DEBE** de  usar la URI base por defecto para la resolución de la URI cuando el recurso ya existe, y la URI del recurso creado, cuando la petición concluye con la creación de un nuevo recurso.

###### Requisito RF_01_01_06 [(4.2.1.6 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Advertir de restricciones

El servidor LDP **DEBE** de publicar cualquier restricción que se pueda aplicar sobre la capacidad de un cliente de crear o actualizar los LDPRs, añadiendo una cabecera Link, con el apropiado contexto de URI en el sujeto (en principio la URL sobre la que se realiza la petición), un link a una relación http://www.w3.org/ns/ldp#constrainedBy como predicado, y como objeto el conjunto de restricciones que se aplican, para todas las respuestas que se generen a partir de peticiones que han fallado, debido a una de esas restricciones. La especificación LDP no define restricciones, por lo que se permiten cualquier tipo de ellas, incluyendo aquellas que se pudiesen definir para un dominio concreto. 

##### Requisitos específicos de operaciones GET HTTP sobre Recursos

###### **Requisito RF_01_02_01** [(4.2.2.1 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Soporte a método GET

El servidor LPD **DEBE** dar soporte al método GET sobre LDPRs

###### **Requisito RF_01_02_01** [(4.2.2.2 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Soporte a cabeceras

El servidor LPD **DEBE** dar soporte a todas las cabeceras descritas el apartado [Requisitos específicos de operaciones OPTION HTTP](#Requisitos específicos de operaciones OPTION HTTP) de la sección de [Recursos](#Recursos) de este mismo documento, en todas las respuestas HTTP sobre cualquier recurso.

##### Requisitos específicos de operaciones POST HTTP sobre Recursos

Según la especificación de la LDP la implementación de este método es opcional. Cuando se implementa este método, no se imponen nuevos requisitos. 

Los servidores pueden crear recursos por medio de una operación [POST sobre un contenedor](Requisitos específicos de operaciones POST HTTP sobre Contenedores) o mediante una operación [PUT sobre un recurso](#Requisitos específicos de operaciones PUT HTTP sobre Recursos) o cualquier otro método permitido para recursos HTTP.

Cualquier restricción impuesta en la creación de un recurso, debe de ser advertida, de la forma que se enuncia en el requisito [RF_01_01_06](#Requisito RF_01_01_06: Advertir de restricciones).

##### Requisitos específicos de operaciones PUT HTTP sobre Recursos

Según la especificación de la LDP la implementación de este método es opcional. Cuando se implementa este método, se imponen nuevos requisitos enumerados a continuación

Cualquier restricción impuesta en la creación de un recurso, debe de ser advertida, de la forma que se enuncia en el requisito [RF_01_01_06](#Requisito RF_01_01_06: Advertir de restricciones).

###### Requisito RF_01_03_01  [(4.2.4.1 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Actualización de entidades

Si una petición HHTP PUT es aceptada sobre un recurso, el servidor **DEBE** de remplazar **completamente** el estado anterior de la entidad, con los datos presentes en el BODY de la petición.

Los servidores deben de ignorar (si las hubiera) las propiedades administradas por el servidor, tales como las [tripletas de contención](#Containment Triples (tripletas de contención)) y las [tripletas de pertenecia](#Membership Triple (tripletas de pertenencia)) y aquellas relativas a la auditoria de datos, tales como **dcterms:modified** y **dcterms:creator**, que deben ser gestionadas exclusivamente por el servidor.

Para realizar modificaciones parciales de los estados de una entidad, estas **siempre** han de realizarse con el método PATCH 

###### Requisito RF_01_03_02  [(4.2.4.2 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Permitir realizar una actualización, sin un conocimiento profundo de las restricciones del Servidor

Los servidores LDP **DEBERÍA** permitir a los clientes actualizar recursos sin requerir un conocimiento detallado de las restricciones específicas del servidor. Esto es una consecuencia del requisito de permitir la creación y modificación simples de LDPR. En caso de existir restricciones es necesario advertirlas [requisito RF_01_01_06](#Requisito RF_01_01_06: Advertir de restricciones), siguiendo lo dispuesto en el [requisito RF_01_03_03](Requisito RF_01_03_03: Fallos en actualizaciones por restricciones en el servidor)

###### Requisito RF_01_03_03 [(4.2.4.3 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Fallos en actualizaciones por restricciones en el servidor

En el caso de que el servidor reciba una solicitud PUT a priori valida, pero esta sea rechazada por que el servidor no permite modificaciones a dicho cliente sobre el recurso, el servidor **DEBE** retornar en su respuesta un código de fallo 4xx (habitualmente 409 Conflict), con un BODY de respuesta que contenga información de que propiedades no han podido persistirse. el BODY de respuesta no esta definido por la LDP. 

Imaginando una secuencia de peticiones GET / PUT, donde el cliente insertaría, exactamente el mismo contenido del recurso, **DEBERÍA** de funcionar siempre que las propiedades administradas por el servidor LDP sean idénticas en la respuesta del GET y la solicitud PUT posterior. 

###### Requisito RF_01_03_04 [(4.2.4.4 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Fallos por restricciones en propiedades

En el caso de que el servidor reciba una solicitud PUT a priori valida, pero que contenga propiedades que el servidor decida no persistir (por ejemplo, contenido desconocido), el servidor **DEBE** de responder con el código apropiado en el rango 4xx. El servidor **PUEDE**  proporcionar una BODY de respuesta, pero este no esta definido por la LDP. Los servidores tal como se advierte en el requisito  [RF_01_01_04](#Requisito RF_01_01_04 [(4.2.1.4 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Advertir de soporte LDP), **DEBERÁN** de exponer las restricciones que puedan ser impuestas.

###### Requisito RF_01_03_05 [(4.2.4.5 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Fallos por restricciones en propiedades

Los clientes **PUEDEN** usar la cabecera **If-Match** y la cabecera **ETag** para garantizar que no se actualiza un recurso, que pueda haber cambiado desde que el cliente obtuvo su representación. El servidor **PUEDE** requerir el uso de ambas cabeceras. El servidor LDP **DEBE**  responder con el código 412 (Condition Failed), si falla por causa del ETag, y no existen otros errores. Los servidores que requieran el ETag, y este no este presente, **DEBEN** responder con el código 428 (Precondition Required) si esta es la única razón.

###### Requisito RF_01_03_06 [(4.2.4.6 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Creación de recursos mediante el método PUT

Los clientes **PUEDEN** elegir permitir o no la creación de nuevos recursos usando el metodo PUT .

##### Requisitos específicos de operaciones DELETE HTTP sobre Recursos

Según la especificación de la LDP la implementación de este método es opcional. Cuando se implementa este método, no existen requisitos nuevos.

Para la operación de borrado sobre un recurso, perteneciente a un contenedor, son aplicables los  [requerimientos para borrado de un recurso que pertenece a un contenedor](Requisitos específicos de operaciones DELETE HTTP sobre Contenedores), disponibles en este documento.

##### Requisitos específicos de operaciones HEAD HTTP sobre Recursos

Hay que tener en cuenta que la especificación LDP, se basan en las cabeceras HTTP, y la especificación del protocolo HTTP, prevé que las cabeceras de las operaciones HEAD, sean las mismas que las de la operación GET, sobre un mismo recurso, por lo tanto la implementación, tendra que tener en cuenta la normativa disponible en las operaciones sobre recursos con métodos [GET](#Requisitos específicos de operaciones GET HTTP sobre Recursos) y [OPTIONS](#Requisitos específicos de operaciones OPTIONS HTTP sobre Recursos), recogidas ambas en este mismo documento.

###### **Requisito RF_01_04_01** [(4.2.6.1 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Soporte a método HEAD

El servidor LPD **DEBE** dar soporte al método HEAD sobre LDPRs

##### Requisitos específicos de operaciones PATCH HTTP sobre Recursos

Según la especificación de la LDP la implementación de este método es opcional. Cuando se implementa este método,existen requisitos nuevos. 

Los servidores tal como se advierte en el requisito  [RF_01_01_04](#Requisito RF_01_01_04 [(4.2.1.4 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Advertir de soporte LDP), **DEBERÁN** de exponer las restricciones que puedan ser impuestas en la creación o actualización de un recurso.

###### **Requisito RF_01_05_01** [(4.2.7.1 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Cabecera Accept-Patch

El servidor LPD que implemente el método PATCH **DEBE** debe incluir la cabecera **Accept-Patch** como respuesta a las peticiones OPTIONS, enumerando los media types soportados por el servidor.

##### Requisitos específicos de operaciones OPTIONS HTTP sobre Recursos

Esta especificación, añade los siguientes requisitos a la especificación del propio protocolo [HTTP](#https://www.w3.org/TR/ldp/#bib-RFC7231) para este método. Otras secciones de esta especificación [Requisitos de operaciones PATCH sobre recursos](#Requisitos específicos de operaciones PATCH HTTP sobre Recursos) y  [Requisitos de Header Accept-Post](#Requisitos sobre el Header Accept-Post de respuesta) añaden requisitos a el método OPTIONS.



###### Requisito RF_01_06_01  [(4.2.7.1 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Soporte al método OPTIONS

El servidor **DEBE** de dar soporte al método OPTIONS

###### Requisito RF_01_06_02  [(4.2.7.2 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Métodos soportados

El servidores **DEBEN** de exponer su soporte a los métodos HTTP para un recuso LDPR, listando dichos métodos,  en la cabecera **Allow**  

#### Requisitos sobre RDF Source

La siguiente sección contiene requisitos para un Linked Data Platform sobre los [RDF Source](#Linked Data Platform RDF Source (LDP-RS))

##### Requisitos Generales sobre RDF Source

###### Requisito RF_02_01_01  [(4.3.1.1 LDP)](https://www.w3.org/TR/ldp/#ldprs): Cumplimiento requisitos sobre recursos

Cada RDF Source, a su vez es un [LDP Resource](#Recursos LDP), por lo que el servidor **DEBE** aplicar toda la normativa vista en el apartado anterior. Los clientes deberán **PODER** inferir tripleta:

 <center><strong>Subject URI del LDP-RS &rarr; rdf:type &rarr; ldp:resource</strong></center>
Pero no es necesario que esta tripleta este presente.

###### Requisito RF_02_01_02  [(4.3.1.2 LDP)](https://www.w3.org/TR/ldp/#ldprs): Al menos una tripleta del tipo rdf:type 

Las representaciones LDP-RS, **DEBERIAN** de tener al menos una tripleta **rdf:type**, informada explícitamente, esto facilita el trabajo a los clientes que no soportan inferencia.

###### Requisito RF_02_01_03  [(4.3.1.3 LDP)](https://www.w3.org/TR/ldp/#ldprs): Un rdf:type del tipo ldp:RDFSource

Las representaciones LDP-RS, **DEBEN** de tener la tripleta 

<center><strong>Subject URI del LDP-RS &rarr; rdf:type &rarr; ldp:RDFSource</strong></center>
para todos los RDFSources

###### Requisito RF_02_01_04  [(4.3.1.4 LDP)](https://www.w3.org/TR/ldp/#ldprs): Ser posible obtener una representación RDF del LDP-RS

El servidor **DEBE** facilitar al cliente una representación RDF de el recurso. la URI de la petición, es habitualmente el sujeto de la mayoría de tripletas  presentes en la respuesta. 

###### Requisito RF_02_01_05  [(4.3.1.5 LDP)](https://www.w3.org/TR/ldp/#ldprs): Reutilización de vocabularios

El servidor **DEBERÍA** de reutilizar vocabularios existentes en vez de crear su propios vocabularios duplicando términos.  Algunos casos específicos se detallaran en otros requisitos.

###### Requisito RF_02_01_06  [(4.3.1.6 LDP)](https://www.w3.org/TR/ldp/#ldprs): Uso de predicados estándar

El servidor **DEBERÍA** de usar predicados estándar, tales como [Dublin Core](https://www.w3.org/TR/ldp/#bib-DC-TERMS), [RDF](https://www.w3.org/TR/ldp/#bib-rdf11-concepts) o [RDF Schema](https://www.w3.org/TR/ldp/#bib-rdf-schema) siempre que sea posible.

###### Requisito RF_02_01_07  [(4.3.1.7 LDP)](https://www.w3.org/TR/ldp/#ldprs): Posibilidad de múltiples predicados rdf:type

En ausencia de un conocimiento concreto sobre el dominio de la aplicación, los clientes LPD **DEBEN** asumir, que cualquier LDP-RS, puede tener múltiples **rdf:type** apuntando a distintos objetos.

###### Requisito RF_02_01_08  [(4.3.1.8 LDP)](https://www.w3.org/TR/ldp/#ldprs):  Posibilidad de cambios en los predicados rdf:type

En ausencia de un conocimiento concreto sobre el dominio de la aplicación, los clientes LPD **DEBEN** asumir, que cualquier LDP-RS, pueden cambiar los objetos asociados al **rdf:type** a lo largo del tiempo.

###### Requisito RF_02_01_09  [(4.3.1.9 LDP)](https://www.w3.org/TR/ldp/#ldprs):  Variabilidad en los predicados

Los clientes LPD **DEBEN** siempre asumir, que un determinado conjunto de predicados para un LDP-RS de un tipo particular, es arbitrariamente abierto, lo que supone que recursos del mismo tipo, pueden no tener exactamente las mismas tripletas y el conjunto de predicados que se utilizan en el estado de cualquier LDP-RS no se limita a ningún conjunto predefinido

###### Requisito RF_02_01_10  [(4.3.1.10 LDP)](https://www.w3.org/TR/ldp/#ldprs):  Contenido RDF definido por la LDP

Los servidores LDP no deben requerir que los clientes LDP implementen inferencia para reconocer el subconjunto de contenido definido por LDP, por lo que el servidor **DEBE** explícitamente representarlo.

###### Requisito RF_02_01_11  [(4.3.1.11 LDP)](https://www.w3.org/TR/ldp/#ldprs):  Actualización de entidades

Los clientes **DEBEN** conservar todas las tripletas recuperadas en una operación GET, si posteriormente quieren realizar una operación PUT, modificando únicamente aquella que el cliente desee. Usar PATCH en vez de PUT, genera menos sobrecarga en el cliente.

###### Requisito RF_02_01_12  [(4.3.1.12 LDP)](https://www.w3.org/TR/ldp/#ldprs):  Sugerencias de los clientes

Los clientes LDP pueden proporcionar sugerencias definidas por LDP que permiten a los servidores optimizar el contenido de las respuestas. La sección [Requisitos sobre el Header Prefer de la petición](#Requisitos sobre el Header Prefer de la petición) establece requisitos al respecto. 

###### Requisito RF_02_01_13  [(4.3.1.13 LDP)](https://www.w3.org/TR/ldp/#ldprs):  Capacidad de procesar respuestas que ignoran las sugerencias de los clientes

Los clientes LDP **DEBEN** de ser capaces de procesar las respuestas del servidor LDP, que ignoran las sugerencias, incluyendo para las sugerencias definidas por la LDP. 

##### Requisitos específicos de operaciones GET HTTP sobre RDF Source

###### Requisito RF_02_02_01  [(4.3.2.1 LDP)](https://www.w3.org/TR/ldp/#ldprs): Respuesta de recursos RDF en formato Turtle

El servidor **DEBE** responder con representación RDF en formato [turtle](https://www.w3.org/TR/ldp/#bib-turtle), cuando la petición la cabecera **Accept** especifica **text/turtle**, a menos que la negociación de contenido HTTP, requiera un formato diferente.

###### Requisito RF_02_02_02  [(4.3.2.2 LDP)](https://www.w3.org/TR/ldp/#ldprs): Respuesta de recursos RDF en formato Turtle sin cabecera Accept

El servidor **PUEDE** responder con representación RDF en formato [turtle](https://www.w3.org/TR/ldp/#bib-turtle), cuando la cabecera **Accept** no esta presente.

###### Requisito RF_02_02_03  [(4.3.2.2 LDP)](https://www.w3.org/TR/ldp/#ldprs): Respuesta de recursos RDF en formato application/ld+json

El servidor **DEBE** responder con representación RDF en formato [JSON-LD](https://www.w3.org/TR/ldp/#bib-JSON-LD), cuando la petición la cabecera **Accept** especifica **application/ld+json**, a menos que la negociación de contenido HTTP, requiera un formato diferente.



#### Requisitos sobre Non-RDF Source

La siguiente sección contiene requisitos para un Linked Data Platform sobre los [NoN-RDF Source](#Linked Data Platform Non-RDF Source (LDP-RS))

##### Requisitos Generales sobre RDF Source

###### Requisito RF_03_01_01  [(4.4.4.1 LDP)](https://www.w3.org/TR/ldp/#ldprs): Cumplimiento requisitos sobre recursos

Cada RDF Source, a su vez es un [LDP Resource](#Recursos LDP), por lo que el servidor **DEBE** aplicar toda la normativa vista en el apartado anterior.

Los LDP Non-RDF Sources pueden no poder expresar su estado por medio de RDF.

###### Requisito RF_03_01_02  [(4.4.4.2 LDP)](https://www.w3.org/TR/ldp/#ldprs): Advertir que el servidor soporta recursos no RDF

Los servidores que expongan recursos No RDF **PUEDEN** advertir de ello, exponiendo la cabecera **Link**, con el objetivo **http://www.w3.org/ns/ldp#NonRDFSource** y un relation type, rel="type", en las respuestas a peticiones HTTP hechas al recurso por medio de su URI

### Contenedores

#### General

Esta sección contiene la normativa definida por la LDP aplicable a los contenedores.

##### Requisitos GENERALES específicos sobre Contenedores de tipo Direct ContainerRequisitos Generales sobre Contenedores

La LDP no define como los clientes descubren los contenedores.



###### Requisito RF_04_01_01  [(5.2.1.1 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Normativa RDF Source

Los contenedores son LDP Sources, por lo tanto debe cumplirse la normativa descrita en esa [sección](#Requisitos Generales sobre RDF Source)

Los clientes deben de poder inferir la tripleta

<center><strong>Subject URI del Contenedor &rarr; rdf:type &rarr; ldp:RDFSource</strong></center>
pero expresarla explícitamente no esta requerido

###### Requisito RF_04_01_02  [(5.2.1.2 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Tripleta rdf:type de ldp:Container

La representación RDF de un contenedor **PUEDE** tener una tripleta del tipo

<center><strong>Subject URI del Contenedor &rarr; rdf:type &rarr; ldp:Container</strong></center>
para los LDP Container.

Los LDP Containers pueden tener cualquier tipo adicional, exactamente igual que los LDP-RS

###### Requisito RF_04_01_03  [(5.2.1.3 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): No usar rdf:Bag, rdf:Seq o rdf:List

La representación RDF de un contenedor  **DEBERIA** no usar los tipos RDF rdf:Bag, rdf:Seq o rdf:List

###### Requisito RF_04_01_04  [(5.2.1.4 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Advertir del soporte LDP para los contenedores

Los servidores que expongan LDP Containers, **DEBEN** de advertir de ello, exponiendo una cabecera **Link**, especificando en el destino, la URI del tipo de contenedor que el servidor soporta, y un relation type rel="type", en respuesta a todas las peticiones realizas sobre la URI del contenedor. También pueden exponer otras cabeceras Link con el relation type rel="type".

Las URIs validas para distintos tipos de contenedores son

| URI para le Link                               | Tipo de contenedor   |
| ---------------------------------------------- | -------------------- |
| **http://www.w3.org/ns/ldp#BasicContaine**     | Contenedor Básico    |
| **http://www.w3.org/ns/ldp#DirectContainer**   | Contenedor Directo   |
| **http://www.w3.org/ns/ldp#IndirectContainer** | Contenedor Indirecto |



###### Requisito RF_04_01_05  [(5.2.1.5 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Respetar sugerencias de cliente

Los servidores LDP **DEBERÍAN** de respetar sobre los contenedores, todas las sugerencias del cliente, por ejemplo, retornar solo un subconjunto de las propiedades, en las que el cliente esta realmente interesado en procesar, reduciendo asi el conjunto de tripletas que serán retornadas, especialmente para contenedores con un alto numero de tripletas.

##### Requisitos específicos de operaciones GET HTTP sobre Contenedores

Tal como se especifico en el apartado de [requisitos sobre operaciones GET sobre recursos](#Requisitos específicos de operaciones GET HTTP sobre Recursos), este método requiere cumplir los [requisitos generales sobre contenedores](#Requisitos Generales sobre Contenedores)

##### Requisitos específicos de operaciones POST HTTP sobre Contenedores

Según la especificación de la LDP la implementación de este método es opcional. Cuando se implementa este método, se imponen nuevos requisitos enumerados a continuación

Cualquier restricción impuesta en la creación de un recurso, debe de ser advertida, de la forma que se enuncia en el requisito [RF_01_01_06](#Requisito RF_01_01_06: Advertir de restricciones).

###### Requisito RF_04_02_01  [(5.2.3.1 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Creación de un nuevo recurso al realizar un POST sobre el contenedor

Los servidores LDP **DEBERÍAN** crear nuevos recursos al enviar una representación de un BODY completo, en la operación POST realizada sobre un contenedor.

Si el recurso se creo correctamente el servidor **DEBE** responder con un codigo 201 (Created), y la cabecera **Location** con la URI del recurso recién creado.

Los clientes no deben de esperar ninguna representación del recurso, en el cuerpo del mensaje

###### Requisito RF_04_02_02  [(5.2.3.2 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Tripleta de contención al crear un recurso

Cuando se realice con éxito, la inserción de un recurso por medio de un POST sobre un contenedor, una nueva tripleta de contención, **DEBE** de ser añadida, donde el sujeto será la URI del contenedor, el predicado **ldp:contains**, y el objeto la URI del documento recién creado, de la forma:

<center><strong>Subject URI del Contenedor &rarr; ldp:contains &rarr; Object URI del documento recién creado</strong></center>
Pueden añadiese otras tripletas si estas fueran necesarias.

 La tripleta permanecerá hasta que el recurso sea borrado.

###### Requisito RF_04_02_03  [(5.2.3.3 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): POST sobre recursos No-RDF

El servidor **PUEDE** aceptar POST de recursos No-RDF, sobre la URI del contenedor, para cualquier tipo de recurso,por ejemplo ficheros ficheros binarios. La normativa relativa al soporte del servidor a distintos media types, puede encontrarse en la sección [Cabecera Accept-Post](#Requisito RF_04_02_13  [(5.2.3.13 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Cabecera Accept-Post en operaciones POST) de este mismo documento.

###### Requisito RF_04_02_04  [(5.2.3.4 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Respeto por el modelo de interacción propuesto por el cliente

El servidor que crea exitosamente un recurso de una representación RDF, según lo expresado por el BODY de la petición, **DEBE** respetar el modelo de interacción con ese recurso (LDPR o LDPC), solicitados por el cliente.

Si el modelo de interacción no pudiese respetarse, deberá fallar la petición. 

- Si las cabeceras de la petición especifican un [Modelo de interación LDPR](#Requisito RF_01_01_04 [(4.2.1.4 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Advertir de soporte LDP), entonces el servidor **DEBE** de tratar las posibles posteriores peticiones sobre ese recurso, siguiendo la normativa aplicable a un recurso LDPR. Cuando el servidor trata al recurso como un recurso LDPR, los clientes solo dependen de la normativa definida para los recursos LDPR, incluso si el contenido contiene una tripleta ldr:type, indicando que el recurso es un LDPC. Si la información del servidor, entra en conflicto con la información del recurso, se impone la información del servidor.
- Si las cabeceras de la petición especifican un [Modelo de interación LDPC](#Requisito RF_04_01_04  [(5.2.1.4 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Advertir del soporte LDP para los contenedores), entonces el servidor **DEBE** de manejar todas las posteriores peticiones sobre el recurso como un LDPC.
- Esta especificación no define el comportamiento para otros casos.

Los clientes deben usar la misma sintaxis, es decir la cabecera Link, con el valor que corresponda para especificar el modelo de interacción deseado, cuando creen un recurso, y los servidores deben de usarlo en sus respuestas.

Una consecuencia de esto es que un LDPC, puede usarse para crear otro LDPC, si el servidor lo admite.

###### Requisito RF_04_02_05  [(5.2.3.5 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Debe de soportarse la cabecera Content-Type con el valor text/turtle

El servidor **DEBE** permitir a los clientes (cuando admita creación por medio de un POST), especificar la cabecera Content-Type con el valor test/turtle, y por lo tanto interpretar el body del recurso, en dicho formato. 

###### Requisito RF_04_02_06  [(5.2.3.6 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Debe de soportarse la cabecera Content-Type

El servidor **DEBERIA** usar la cabecera Content-Type para interpretar el formato del BODY, que contiene la representación del recurso. 

###### Requisito RF_04_02_07  [(5.2.3.7 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Interpretación del valor nulo, en la URI relativa, en el sujeto de las tripletas

El servidor que cree recursos por medio del método POST, **DEBE** interpretar el valor nulo de la URI, en el sujeto de las tripletas de la representación en el BODY del recurso, como una identificación de la entidad que estamos creando. Esto significa que será necesario actualizar dichas tripletas, una vez que el recurso sea creado, y se conozca su URI.

###### Requisito RF_04_02_08  [(5.2.3.8 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Valor para la URI del recurso

El servidor **DEBERÍA** asignar una URI al recurso, basándose en sus propias reglas, en ausencia de sugerencias del cliente.

###### Requisito RF_04_02_09  [(5.2.3.9 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Advertir de las restricciones.

El servidor **PUEDE** permitir a los clientes crear nuevos recursos, sin tener un conocimiento profundo de las restricciones impuestas por la aplicación. Esto es consecuencia de la aplicación de el requisito [Advertir de las restricciones](#Requisito RF_01_01_06 [(4.2.1.6 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Advertir de restricciones) , aplicable a todos los recursos LDPR.

###### Requisito RF_04_02_010  [(5.2.3.10 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Sugerencias sobre la URI del nuevo recurso.

El servidor **PUEDE** permitir a los clientes sugerir una URI para la creación de un nuevo recurso por medio de un POST. Mediante el uso de la cabecera Slug (definida en el protocolo [HTTP](#https://tools.ietf.org/html/rfc5023)). Corresponde al servidor aceptar la sugerencia del cliente, o generar su propia URI.

###### Requisito RF_04_02_011  [(5.2.3.11 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): No reusar URIs.

El servidor **NO DEBERÍA** reusar URIs.

###### Requisito RF_04_02_012  [(5.2.3.12 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Metadatos RDF asociados a recursos No-RDF.

Después de la creación exitosa por medio de una operación POST para un recurso No RDF (codigo 201-Created y la presencia de la cabecera Location indicando la URI del recurso recién creado), los servidores LDP **PUEDEN** crear un recurso RDF asociado LDP-RS, que contenga datos, acerca del recurso No RDF recién creado. Si lo crease, es servidor **DEBE** indicar su localización mediante el uso de la cabecera **Link**, apuntando a la nueva URI del recurso creado.

###### Requisito RF_04_02_13  [(5.2.3.13 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Cabecera Accept-Post en operaciones POST

El servidor **DEBN** responder con la cabecera **Accept-Post** en las respuestas a las peticiones **OPTIONS**, incluyendo todos los media types soportados por la operación POST.

###### Requisito RF_04_02_14  [(5.2.3.13 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Debe de soportarse la cabecera Content-Type con el valor application/ld+json

El servidor **DEBE** permitir a los clientes (cuando admita creación por medio de un POST), especificar la cabecera Content-Type con el valor application/ld+json, y por lo tanto interpretar el body del recurso, en dicho formato. 

##### Requisitos específicos de operaciones PUT HTTP sobre Contenedores

Según la especificación de la LDP la implementación de este método es opcional. Cuando se implementa este método, se imponen nuevos requisitos enumerados a continuación

Cualquier restricción impuesta en la creación de un recurso, debe de ser advertida, de la forma que se enuncia en el requisito [RF_01_01_06](#Requisito RF_01_01_06: Advertir de restricciones).

###### Requisito RF_04_03_01  [(5.2.4.1 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Servidores que no admiten PUT para actualizar tripletas de contención de LDPCs

Los servidores que no admiten PUT para actualizar tripletas de contención de LDPCs **DEBERÁN** responder con el codigo 409 (Conflict)

###### Requisito RF_04_03_02  [(5.2.4.2 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): No se deben reusar URIs

Los servidores que admiten PUT para creación de recursos **NO DEBERÍAN** reusar URIs.

##### Requisitos específicos de operaciones DELETE HTTP sobre Contenedores

Según la especificación de la LDP la implementación de este método es opcional. Cuando se implementa este método, se imponen nuevos requisitos enumerados a continuación

###### Requisito RF_04_04_01  [(5.2.5.1 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Eliminar las tripletas de contención en caso de borrado de un recurso

Cuando un recurso LDPR es borrado, los servidores **DEBEN** borrar también las tripletas de contención que hagan referencia a dicho recurso. 

###### Requisito RF_04_04_02  [(5.2.5.2 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Borrado de recursos RDF relacionados con recursos N-RDF.

Cuando se borra un recurso No RDF, para el cual el servidor creo un recurso RDF, el servidor **DEBE** borrar también el recurso RDF relacionado.

##### Requisitos específicos de operaciones HEAD HTTP sobre Contenedores

Hay que tener en cuenta que la especificación LDP, se basan en las cabeceras HTTP, y la especificación del protocolo HTTP, prevé que las cabeceras de las operaciones HEAD, sean las mismas que las de la operación GET, sobre un mismo recurso, por lo tanto la implementación, tendra que tener en cuenta la normativa disponible en las operaciones sobre recursos con métodos [GET](#Requisitos específicos de operaciones GET HTTP sobre Recursos) y [OPTIONS](#Requisitos específicos de operaciones OPTIONS HTTP sobre Recursos), recogidas ambas en este mismo documento.

##### Requisitos específicos de operaciones PATCH HTTP sobre Contenedores

Según la especificación de la LDP la implementación de este método es opcional. Cuando se implementa este método, se imponen nuevos requisitos enumerados a continuación

Cualquier restricción impuesta en la creación de un recurso, debe de ser advertida, de la forma que se enuncia en el requisito [RF_01_01_06](#Requisito RF_01_01_06: Advertir de restricciones).

###### Requisito RF_04_05_01  [(5.2.7.1 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Recomendación de actualización parcial (PATCH) frene a actualización total (PUT).

Se **RECOMIENDA** a los servidores dar soporte a la actualización parcial como método preferido para hacer actualizaciones, ya que supone un menor cambio de tripletas. 

##### Requisitos específicos de operaciones OPTION HTTP sobre Contenedores

Según la especificación de la LDP la implementación de este método es requerida. Se imponen nuevos requisitos enumerados a continuación

###### Requisito RF_04_06_01  [(5.2.8.1 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Caso especial de recursos no RDF, asociados a recursos RDF.

Cuando exista la necesidad de responder una petición OPTIONS, sobre un recurso No RDF, que tenga asociado un recurso RDF, el servidor debe de responder con una cabecera Link hacia dicho recurso.



#### Requisitos específicos sobre Contenedores de tipo BASIC

Los siguientes requisitos se aplican a los LDP-BC.

##### Requisitos GENERALES específicos sobre Contenedores de tipo BASIC

###### Requisito RF_06_01_01  [(5.3.1.1 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): El cliente debe poder inferir la tripleta (Uri Contenedor Básico, rdf:type, ldp:Container .

Cada contenedor LDP Direct Container, **DEBE** de estar conforme a los [Requisitos Generales de los Contenedores](#Requisitos Generales sobre Contenedores). El cliente **DEBE**  poder inferir la tripleta (Uri Contenedor Básico, rdf:type, ldp:Container), aunque esta puede no estar presente.



#### Requisitos específicos sobre Contenedores de tipo Direct Container

Los siguientes requisitos se aplican a los LDP-DC.

##### Requisitos GENERALES específicos sobre Contenedores de tipo Direct Container

###### Requisito RF_07_01_01  [(5.4.1.1 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): El cliente debe poder inferir la tripleta (Uri Contenedor Básico, rdf:type, ldp:Container .

Cada contenedor LDP Direct Container, **DEBE** de estar conforme a los [Requisitos Generales de los Contenedores](#Requisitos Generales sobre Contenedores). El cliente **DEBE**  poder inferir la tripleta (Uri Contenedor Básico, rdf:type, ldp:Container), aunque esta puede no estar presente.

###### Requisito RF_06_01_02  [(5.4.1.2 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Uso del predicado ldp: member..

Los LDP Direct Containers **DEBERÍAN** usar el predicado **ldp:member** como predicado de membresía, igual que el resto de LDPCs, si no existiese un vocabulario obvio por parte de la aplicación.

El estado del LDPC **DEBE** contener suficiente información, para que los clientes puedan conocer que recursos son sus miembros y las tripletas de membresía seguir un patrón establecido.

El estado de los LDPCs **DEBE** de contener suficiente información, para discernir el predicado de membresía, por un consistente valor del predicado de membresía y mediante la posición de sujetos y objetos, coherente con dicho predicado. Los recursos contenidos, pueden ser cualquier tipo de recurso identificado por su URI, un LDPR u otra cosa.

###### Requisito RF_06_01_03  [(5.4.1.3 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Debe contener exactamente una tripleta con el predicado ldp:membershipResource

Los LDP Direct Containers **DEBEN** tener exactamente una tripleta con el predicado ldp:membershipResource con el objeto la URI del recurso del cual el propio contenedor es descendiente.

###### Requisito RF_06_01_04  [(5.4.1.4 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Debe contener exactamente una tripleta con el predicado ldp:hasMemberRelation o ldp:isMemberOfRelation

Los LDP Direct Containers **DEBEN** tener exactamente una tripleta cuyo sujeto es la URI del propio contenedor ,con el predicado ldp:hasMemberRelation o ldp:isMemberOfRelation que determinara el patrón usado, y el Objeto al que apunta el predicado según el patrón de las [tripletas de pertenencia ](#Membership Triple (tripletas de pertenencia)).

###### Requisito RF_06_01_05  [(5.4.1.4.1 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Los contenedores que usan el Patrón ldp:hasMemberRelation

Los LDP Direct Containers que usan el Patrón ldp:hasMemberRelation **DEBEN** tener exactamente una tripleta del tipo

<center><strong>URI del contenedor &rarr; ldp:hasMemberRelation &rarr; Object URI del recurso dependiente del contenedor</strong></center>
y esta tripleta será el predicado de membresía

###### Requisito RF_06_01_06  [(5.4.1.4.2 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Los contenedores que usan el Patrón ldp:isMemberRelation

Los LDP Direct Containers que usan el Patrón ldp:isMemberRelation **DEBEN** tener exactamente una tripleta del tipo

<center><strong>Object URI del recurso dependiente del contenedor &rarr; ldp:isMemberRelation &rarr; URI del contenedor</strong></center>
y esta tripleta será el predicado de membresía

###### Requisito RF_06_01_07  [(5.4.1.5 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Los contenedores deben comportarse como si usasen las tripletas (LDPC URI,`ldp:insertedContentRelation` , ldp:MemberSubject )

Los LDP Direct Containers **DEBEN** comportarse como si usasen las tripletas (LDPC URI,`ldp:insertedContentRelation` , ldp:MemberSubject ) pero la LDP, no impone requerimientos para que estas se materialicen. El valor de ldp:MemberSubject significa que la member-derived-URI sera la del documento creado.

##### Requisitos específicos para operaciones POST sobre Contenedores de tipo Direct Container

###### Requisito RF_07_01_01  [(5.4.2.1 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Deben de actualizarse las tripletas de membresía al realizar exitosamente una operación POST

Cuando se ha realizado exitosamente una operación POST, sobre un LDPC, y se ha creado un nuevo recurso, se **DEBEN** de actualizar las tripletas de membresía para que reflejen dicha acción.

Las tripletas resultantes **DEBEN** de ser coherentes con cualquier predicado que expongan.

Los predicados de un contenedor directo, **PUEDEN** ser modificados también por otros medios.

##### Requisitos específicos para operaciones DELETE sobre Contenedores de tipo Direct Container

###### Requisito RF_08_01_01  [(5.4.3.1 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Deben de actualizarse las tripletas de membresía, en caso de borrado 

Cuando se ha borra un recurso, **DEBEN** de ser borradas todas las tripletas de membresía de dicho recurso

#### Requisitos específicos sobre Contenedores de tipo Indirect Container

Los siguientes requisitos se aplican a los LDP-IC.

##### Requisitos GENERALES específicos sobre Contenedores de tipo Indirect Container

###### Requisito RF_08_01_01  [(5.5.1.1 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): El cliente debe poder inferir la tripleta (Uri Contenedor Básico, rdf:type, ldp:Container)

Cada contenedor LDP Indirect Container, **DEBE** de estar conforme a los [Requisitos Generales de los Contenedores Directos](#Requisitos GENERALES específicos sobre Contenedores de tipo Direct Container). El cliente **DEBE**  poder inferir la tripleta (Uri Contenedor Indirecto, rdf:type, ldp:Container), aunque esta puede no estar presente.

###### Requisito RF_08_01_02  [(5Debe de existir exactamente una tripleta con el predicado ldp:insertedContentRelation

Cada contenedor LDP Indirect Container, **DEBE** de tener exactamente una tripleta donde la URI del contenedor actúa como sujeto, tiene como predicado ldp:insertedContentRelation y cuyo objeto ICR describe cómo se elige el URI derivado del miembro en la membresía del contenedor. 

El member-derived-URI, se compone bien de una tripleta (S,P,O) en el documento proporcionado por el cliente, bien enviado explícitamente por el cliente como entrada, en la solicitud de creación.

Si el valor del ICR´s es P, entonces el member-derived-URI, es O.

LDP no define el comportamiento cuando mas de una tripleta contiene el predicado P.

Por ejemplo, si el cliente realiza un POST, con contenido RDF, y esto causa que el servidor cree un nuevo recurso RDF, y el contenido de la tripleta es (<>, foaf:primaryTopic, bob#me), el predicado  **foaf:primaryTopic**, esta indicando que member-derived-URI es en este caso **bob#me**

Una consecuencia de esta definición es que la creación indirecta de miembros de contenedor solo está bien definida por LDP cuando el documento suministrado por el cliente como entrada para la solicitud de creación tiene un media type RDF.

##### Requisitos específicos para operaciones POST sobre Contenedores de tipo Indirect Container

###### Requisito RF_08_02_01  [(5.5.2.1 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): El cliente debe poder inferir la tripleta (Uri Contenedor Básico, rdf:type, ldp:Container)

Los LDPC que contengan una tripleta con predicado **ldp:insertContentRelation** y un objeto distinto de **ldp: MemberSubject** y que crean nuevos recursos deben agregar un tripleta al contenedor cuyo Sujeto es el URI del contenedor, cuyo predicado es **ldp:contains** y cuyo objeto es la URI del recurso recién creado (que será diferente a member-derived-URI en este caso).

Esta tripleta ldp:contains puede ser el único enlace desde el contenedor al recurso recién creado en ciertos casos.

### Requisitos sobre Headers HTTP

Esta especificación introduce el nuevo header de respuesta HTTP **Accept-Post** utilizado para especificar los formatos de documentos aceptados por el servidor en las solicitudes HTTP POST.

#### Requisitos sobre el Header Accept-Post de la respuesta

###### Requisito RF_09_01_01  [(7.1.1 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Sintaxis de la cabecera Accept-Post

La sintaxis del **Accept-Post** es

**Accept-Post = "Accept-Post" ":" # media-range**

Donde los media-range,  es la lista de medios (con parámetros opcionales) aceptados separados por coma, exactamente igual que la cabecera HTTP accept (menos el opcional-params)

###### Requisito RF_09_01_02  [(7.1.2 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): debe de retornarse en la petición OPTIONS, para cualquier recurso que admita el método POST

El encabezado Accept-Post, **DEBE** de retornarse en la petición OPTIONS, para cualquier recurso que admita el método POST. La presencia de Accept-POST, indica implícitamente que la operación POST esta permitida sobre el recurso que indica la URI. La presencia de un determinado formato, indica que dicho formato es admitido en la operación POST sobre ese recurso.

#### Requisitos sobre el Header Prefer de la petición

Sirve para que el cliente indique su preferencia de la porción de tripletas sobre el recurso que quiere obtener

###### Requisito RF_09_01_01  [(7.2.2.1 LDP)](https://www.w3.org/TR/ldp/#prefer-parameters): Include

Define el contenido que el cliente desearía que se incluyese en la representación

```html
<!--include-parameter = "include" *WSP "=" *WSP ldp-uri-list-->
Prefer: return=representation; include="http://www.w3.org/ns/ldp#PreferMinimalContainer"
```

Donde WSP es el espacio en blanco y ldp-uri-list la lista de URIs (entre comillas) separadas por espacio

###### Requisito RF_09_01_01  [(7.2.2.2 LDP)](https://www.w3.org/TR/ldp/#prefer-parameters): omit

Define el contenido que el cliente desearía que se omitiese en la representación

```html
<!--omit-parameter = "omit" *WSP "=" *WSP ldp-uri-list-->
Prefer: return=representation; include="http://www.w3.org/ns/ldp#PreferMinimalContainer"
```

Donde WSP es el espacio en blanco y ldp-uri-list la lista de URIs (entre comillas) separadas por espacio

###### Requisito RF_09_01_01  [(7.2.2.3 LDP)](https://www.w3.org/TR/ldp/#prefer-parameters): Conflictos

Cuando el servidor recibe en la cabecera Prefer parámetros conflictivos, no esta definida la actuación, pudiendo rechazar la petición o resolverla según crea conveniente.

###### Requisito RF_09_01_01  [(7.2.2.4 LDP)](https://www.w3.org/TR/ldp/#prefer-parameters): tripletas contempladas por la LDP

La especificación prevé los siguientes URIs para usar con include o omit:

| [Containment triples](https://www.w3.org/TR/ldp/#dfn-containment-triples) | **http://www.w3.org/ns/ldp#PreferContainment**      |
| ------------------------------------------------------------ | --------------------------------------------------- |
| [Membership triples](https://www.w3.org/TR/ldp/#dfn-membership-triples) | **http://www.w3.org/ns/ldp#PreferMembership**       |
|                                                              | **http://www.w3.org/ns/ldp#PreferMinimalContainer** |
| [Minimal-container triples](https://www.w3.org/TR/ldp/#dfn-minimal-container-triples) | o el término equivalente pero en desuso             |
|                                                              | **http://www.w3.org/ns/ldp#PreferEmptyContainer**   |

 

#### Requisitos sobre el Header Link de relación

Sirve para que el cliente indique su preferencia de la porción de tripletas sobre el recurso que quiere obtener

###### Requisito RF_10_01_01  [(8.1 LDP)](https://www.w3.org/TR/ldp/#prefer-parameters): describeBy

La relación A describedby B afirma que el recurso B proporciona una descripción del recurso A. No hay restricciones del formato de A y B