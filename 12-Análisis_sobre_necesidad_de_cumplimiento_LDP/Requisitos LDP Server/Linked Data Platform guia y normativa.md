![](./images/logos_feder.png)

# Linked Data Platform



##### ¿Que es?

Conjunto de reglas para operaciones HTTP sobre recursos Web basados en RDF, que proporcionan mecanismos para leer o escribir datos en la Web

#####  Objetivos

1. Usar URIs nombrar inequívocamente un recurso
2. Usar URIs para acceder a cualquier recurso
3. Obtener información útil al acceder al recurso por su URI siguiendo el standard RDF
4. Incluir enlaces a otras URIs, de forma que el usuario pueda acceder a otros recurso
5. El uso de contenedores, permite agrupar recursos relacionados entre ellos
6. Permitir trabajar con grandes recursos, permitiendo fraccionarlo de forma que pueda ser paginado

##### Terminos

- Linked Data Platform Resource (LDPR): Un recurso de acuerdo a las especificaciones de la LPD
  - Linked Data Platform RDF Source (LDP-RS): Un recurso representado por un grafo RDF
  - Linked Data Platform RDF Source (LDP-NR): Un recurso que no es representado por un grafo RDF (binarios, texto...)
- Linked Data Platform Container (LDPC): Un recurso LDP-RS que contiene una colección de documentos vinculados, y obedece a las acciones de creación, modificación, enumeración y borrado requeridas por un cliente
  - Linked Data Platform Basic Container (LDP-BC): Un LDPC que define un simple link a los documentos contenidos en el
  - Linked Data Platform Direct Container (LDP-DC): Un LDPC que define el concepto de miembro de, permitiendo tener mas flexibilidad en la forma de las tuplas de sus miembros, y permitiendo que sus miembros puedan ser recursos y no solo documentos.
  - Linked Data Platform Indirect Container (LDP-IC): Un LDPC similar a un LDP-DC que también es capaz de tener miembros cuyos URI se basan en el contenido de sus documentos contenidos en lugar de los URI asignados a esos documentos.
- Membership: Relación de un contenedor con los documentos que contiene, que pueden ser recursos distintos a sus documentos contenidos 
- Membership triples: Conjunto de tripletas que enumeran los miembros de una LDPC, siguiendo el siguiente patrón:
  - membership-constant-URI	membership-predicate	member-derived-URI
  - member-derived-URI	membership-predicate	membership-constant-URI

- Containment: la relación de vinculación entre un contenedor y sus recursos
- Containment triples: Conjunto de tripletas, mantenidas por el contenedor, de documentos hijos activos, definidas de la forma LDPC URI -> ldp:contains -> document-URI

- Minimal-container triples: La porción de un LDPC, que puede mostrarse con el contenedor vacío, es decir únicamente las tripletas propias del contenedor, no las de pertenencia.
- LDP-server-managed triples: Tripletas para definir relaciones jerárquicas u otras especificaciones que el servidor debe soportar.

##### Requisitos de servidor LDP

- Debe obedecer al menos al protocolo HTTP/1.1
- Debe manejar recursos RDF (LDP-RS) y no RDF (LDP-NR) tales como binarios, texto....
- Las respuestas del servidor LDP deben usar etiquetas de entidad (débiles o fuertes) como valores de encabezado ETag de respuesta, para respuestas que contienen representaciones de recursos o respuestas exitosas a solicitudes HTTP HEAD.
- Los servidores deben anunciar su compatibilidad con LDP exponiendo el encabezado Link con la URI de destino `http://www.w3.org/ns/ldp#Resource` y el tipo de relación de enlace rel="type" para todas las peticiones realizadas sobre un recurso
  - La cabecera Link en el Head, es la forma de anunciar la compatibilidad con LDP sobre un recurso. No se puede sustituir esto por la tripleta (sujeto-URI, rdf:type, ldp:Resource) en un recurso.
  - Esto es valido, tanto para recursos RDF como no RDF, ya que ambos son LDPR
- Deben asignar URIs bases predeterminadas y la resolución de la URI relativa cuando el recurso ya exista, y la URI del recurso creado, en caso de creación.
- Se debe publicar cualquier restricción que un cliente pueda tener al crear o actualizar un recurso, añadiendo un encabezado Link con el apropiado contexto de URI (ej. `http://www.w3.org/ns/ldp#constrainedBy`), y una URI objetivo, con el conjunto de restricciones, como respuesta a cualquier violación de restricción sobre un recurso.

##### Normativa en Métodos HTTP

###### HTTP GET

- Se soporta el método GET para recursos LDPRs
- Debe soportar las cabeceras HTTP en las respuestas definidas por HTTP OPTIONS para el método GET

###### HTTP POST

- La especificación LDP no requiere el método POST, por lo que es opcional. Si el método es soportado, no hay especificaciones nuevas.
- La creación será soportada por el método POST y PUT, y si existiesen restricciones impuestas al cliente, estas deben anunciarse.

###### HTTP PUT

- La especificación LDP no requiere el método PUT, por lo que es opcional. Si el método es soportado, no hay especificaciones nuevas.
- La creación será soportada por el método POST y PUT, y si existiesen restricciones impuestas al cliente, estas deben anunciarse.
- Si se soporta el método, hay que cambiar el contenido actual por el contenido pasado en el body
- El servidor puede ignorar las propiedades LDP-server-manager, si estas son controladas por el servidor, tales como dcterms:modified o dcterms:creator. Para realizar modificaciones parciales se recomienda el uso del método PATCH en vez de PUT
- Los servidores LDP deberían permitir a los clientes actualizar recursos sin requerir un conocimiento detallado de las restricciones específicas del servidor. Esto es una consecuencia del requisito de permitir la creación y modificación simples de LDPR.
- Si se recibe una solicitud valida, pero esta no puede atenderse por restricciones sobre el cliente, se retornara un código 4XX (típicamente 409 Conflict). El cuerpo del mensaje debe incluir descripción de las propiedades que no se pueden actualizar, no esta definido dicho formato.
- Si se recibe una solicitud con propiedades que el servidor no persistirá, se retornara un código 400, informado de la propiedad en el body
- Los cliente deben usar la cabecera If-Match y HTTP ETags para asegurarse de no modificar un recurso que ha cambiado desde que el cliente obtuvo la información. El servidor puede requerir las cabeceras descritas para evitar colisión. En caso de haber cambiado el recurso se responderá con el código 412 (Condition Failed), en caso de no estar presentes las cabeceras y ser requeridas, se responderá con el código 428 (Precondition required)
- El servidor puede elegir realizar la creación o no con el método PUT.

###### HTTP DELETE

- La especificación LDP indica que es opcional, si es soportado, no hay requisitos especiales.

- La especificación LDP indica que es opcional, si es soportado, hay los siguientes requisitos especiales:
  - Cuando un recurso es borrado de un contenedor, hay que actualizar el contenedor para que deje de referenciar al recurso

###### HTTP HEAD

- El método HEAD debe de ser soportado por el Servidor
- Hay que tener en cuenta que se requieren los mismos Head que para una petición GET.

###### HTTP PATH

- El método PATH es opcional. Si es soportado tiene las siguientes restricciones:
  - Cualquier restricción impuesta por el servidor en la creación o actualización de LDPR debe anunciarse a los clientes.
  - Los servidores que acepten el método PATH, deben la cabecera Accept-Patch, enumerando los tipos de documentos soportados por el servidor.

###### HTTP OPTION

- El método PATH es requerido y tiene las siguientes restricciones:
  - Ante una petición OPTION sobre un recurso, el servidor debe de responder en su Header allow con los métodos que son soportados

##### Normativa en RDF Source

La presente sección recoge la normativa para los recursos no RDF (LDP-NR)

- Siendo los recursos no RDF recursos LDP, se aplica la normativa relativa a ellos
- Los servidores que expongan recursos LDP-NR, pueden advertir de ello, en la cabecera Link de la forma  http://{base_url}/{name_space}/{container}#NonRDFSource con el tipo de relación rel="type", en las peticiones hechas sobre ese recurso

##### Contenedores

Los contenedores agrupan recursos de un mismo contexto y dan solución a los siguientes aspectos:

- Ofrece una URL para realizar un POST para crear un nuevo recurso
- Permite realizar un GET para obtener la lisa de recursos
- Obtener información acerca de los recursos del contenedor
- Asegurar que los datos de un recurso son fácilmente accesibles
- Expresar un order en las entradas del contenedor

El contenido de un contenedor, se expresa como un conjunto de tripletas. Existen tipos específicos de contenedores que permiten a los miembros del contenedor especificar pertenecía al mismo. En este caso suelen seguir el patrón (URI del recurso, ldp:member, URI contenedor)

El borrado de un contenedor implica actualizar los miembros que lo referencien, y probablemente el borrado de los mismos.

###### Contenedor Básico

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

###### Contenedor Directo

Los **contenedores directos** permiten construcciones mas complejas, donde se puede definir condiciones jerárquicas en ambos sentidos,  es decir ldp:membershipResource apuntaría al contenedor padre y ldp:hasMemberRelation a los contenedores/recursos hijos.

El ejemplo ilustra sobre un recurso raiz, `http://example.org/netWorth/nw1` que en este caso modela el balance de un individuo.

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

###### Contenedor Indirecto

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

###### Recuperar propiedades mínimas del contenedor

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

##### [Normativa de contenedores](https://www.w3.org/TR/ldp/#ldpc-general)

###### Normativa General

1. No esta definido como los clientes descubren los contenedores

2. Los contenedores deben de ser conformes a la normativa para los recursos

3. Los clientes deben de inferir la  tripleta <Uri contendor>, rdf:type, ldp:RDFResource, pero no es requerido en la representación

4. La representación del contenedor, puede no usar los tipos rdf:Bag, rdf:Seq o rdf:List

5. El servidor debe indicar que soporta el contenedor en la respuesta, con la cabecera Link , seguida del tipo de contenedor y el predicado ldp:type 

   - ```bash
     #Para Basic container
     Link: <http://www.w3.org/ns/ldp#BasicContaner>; rel="type"
     #Para Direct Container
     Link: <http://www.w3.org/ns/ldp#DirectContainer>; rel="type"
     #Para Indirect Container
     Link: <http://www.w3.org/ns/ldp#IndirectContainer>; rel="type"
     ```

6. Deben respetar todas las cabeceras permitidas para un cliente, que podrán influir en la respuesta

###### Normativa GET

1. Es **obligatorio** soportar el método, y cumplir las normativas generales

###### Normativa POST

Es **opcional** soportar el método, pero en caso de soportase, ha de cumplir la siguiente normativa

1. Cualquier restricción para crear o actualizar, debe de ser advertida por el servidor 
2. Los clientes podrán crea recursos, enviando la entidad en el Body, realizando un POST sobre un contenedor. Si la petición no falla, se responderá con un código 201 con la cabecera Location, indicando la URL del recurso creado. Los clientes no deben esperar ninguna representación del recurso creado en el cuerpo de la respuesta
3. Cuando el POST del recurso sobre un contenedor se realiza con éxito, se debe de añadir una tripleta de continencia en el contenedor con la URI del recurso creado, con el sujeto de la uri del contenedor, el predicado ldp:contains y la URI del objeto creado. Otras tripletas podrían añadirse también. El recurso aparecerá como un recurso mas del contenedor, hasta que este sea borrado.
4. Los contenedores pueden aceptar también recursos no RDF, tales como binarios. La cabecera Accept-POST debe indicar los tipos aceptados por el servidor.
5. Los servidores deben de cumplir con los modelos de interacción de el cliente para la creación de una entidad, en caso de de no cumplir, la petición fallara.
   - Si el HEADER (Link) de la petición sigue el modelo de un LDPR, el recurso se creara como un LDPR  y tendrá sus mismas restricciones
   - Si el HEADER (Link) de la petición sigue el modelo de un LDPC, el recurso se creara como un LDPC  y tendrá sus mismas restricciones
6. El servidor debe aceptar la creación de un recurso RDF (LDP-RS), por medio de un Body en formato text/turtle, cuando en la cabecera Content-type el cliente especifique dicho formato.
7. El servidor debe aceptar la creación de un recurso RDF (LDP-RS), por medio de un Body en formato application/ld+json, cuando en la cabecera Content-type el cliente especifique dicho formato.
8. Los clientes pueden usar Content-Type en la cabecera, para especificar el formato RDF del Body
9. Los servidores deben interpretar la URI nula, en el sujeto de las tripletas, como la URI de la entidad que va a ser insertada. 
10. Los servidores pueden asignar URIs al recurso creado en ausencia de sugerencias del cliente (por medio de la cabecera slug)
11. Los servidores deben de permitir  los clientes, crear nuevos recursos, sin un conocimiento expreso del funcionamiento del servidor, ya que tal como se ha indicado anteriormente, el servidor ha de exponer sus restricciones, si las hubiese.
12. Los servidores pueden permitir a los clientes en operaciones POST, sugerir la URI del recurso, por medio de la cabecera slug, en cualquier caso la decisión final de la URI, será establecida por el servidor.
13. Los servidores no deberan de reutilizar las URIs
14. Después de la creación de un recurso no RDF (LDP-NR) además de el codigo 201 Created y la cabecera Location con la URI del nuevo recurso, el servidor, pude crear un recurso RDF (LDP-RS) con información sobre el recurso creado. En ese caso, debe indicar su localización por medio de la cabecera Link, con el recurso LDP-NR, un valor de el tipo de relacion de describedBy, y la URI del LDP-RS que lo describe.
15. Los servidores deben de incluir la cabecera Accept-Post, listando todos los media types aceptados por el servidor

###### Normativa PUT

Es **opcional** soportar el método, pero en caso de soportase, ha de cumplir la siguiente normativa

1. Cualquier restricción para crear o actualizar, debe de ser advertida por el servidor 
2. Los servidores LDP no deben permitir que las operaciones PUT actualicen las tripletas contains del contenedor. Si fuese requerido por el cliente, deberá de retornar el código (409 Conflict)
3. Los servidores que admitan PUT para crear un recurso, no deben de reusar las URIs

###### Normativa DELETE

Es **opcional** soportar el método, pero en caso de soportase, ha de cumplir la siguiente normativa

1. Cuando un recurso es borrado, el servidor debe borrar también todas las tripletas contains.

2. Cuando un recurso es borrado y este tiene asociado otro recurso LDP-RS, el servidor también el recurso asociado.

###### Normativa HEAD

Es **obligatorio**. El servidor debe responder con todas las cabeceras que aparecerían en una operación GET pero sin el BODY, por lo tanto todas la normativa aplicable a las cabeceras del método GET son aplicables. 

###### Normativa PATH

Es **opcional** soportar el método, pero en caso de soportase, ha de cumplir la siguiente normativa. 

1. Cualquier restricción para crear o actualizar, debe de ser advertida por el servidor
2. Es recomendable el soporte al método PATH, cuando se soporta el método PUT, ya que optimiza el rendimiento, al actualizar solo las tripletas necesarias

###### Normativa OPTIONS

Es **obligatorio**. El servidor debe atender la siguiente normativa cuando se realice una petición OPTIONS sobre un contenedor:

1. Cuando se responde al método sobre un recurso no RDF (LDP-NR) que tiene asociado un recurso RDF (LDP-RS), el servidor LDP debe responder con la misma cabecera Link que en el caso de creación, es decir con el recurso LDP-NR, un valor de el tipo de relación de describedBy, y la URI del LDP-RS que lo describe.

##### [Normativa de BasicContainer](https://www.w3.org/TR/ldp/#ldpr-gen-linktypehdr)

Esta sección recoge la normativa aplicable para un BasicContainer

###### General

Los contenedores básicos deben cumplir la [Normativa de contenedores](#Normativa de contenedores). Los clientes deben de poder inferir la tripleta (sujeto -> LDP Basic Container, predicado -> rdf:type, Objeto -> ldp:Container), pero no es necesario expresarla explícitamente

##### [Normativa de DirectContainer](https://www.w3.org/TR/ldp/#ldpr-gen-linktypehdr)

Esta sección recoge la normativa aplicable para un DirectContainer

###### General

1. Los contenedores básicos deben cumplir la [Normativa de contenedores](#Normativa de contenedores). Los clientes deben de poder inferir la tripleta (sujeto -> LDP Basic Container, predicado -> rdf:type, Objeto -> ldp:Container), pero no es necesario expresarla explícitamente.
2. Los contenedores directos deben usar el predicado ldp:member si no hay un vocabulario obvio de la ontología para usar en su sustitución. El contenedor directo debe contener información de los recursos que posee, en forma de membresías que siguen un patrón constante. Los miembros pueden ser Recursos RDF o no.
3. Cada contenedor directo debe de contener una tripleta, donde la URI del contenedor es sujeto, el predicado ldp:membershipResource, y como objeto la URI, del padre del contenedor.

4. Cada contenedor directo debe de contener una tripleta, donde la URI del contenedor es sujeto, el predicado ldp:hasMemberRelation (si sigue el patrón [membership-constant-URI , membership-predicate , member-derived-URI ]) o ldp:isMemberOfRelation (si sigue el patrón [ member-derived-URI , membership-predicate , membership-constant-URI ]), y como objeto la URI, del tipo de los objetos hijos.
5. Los contenedores directos LDP deben comportarse como si tuvieran uns tripleta  (LDPC URI, ldp: insertContentRelation, ldp: MemberSubject), pero no se impone la creación de dicha tripleta.

###### POST

1. Cuando tiene éxito un POST, sobre un contenedor para insertar un recurso, se deben actualizar las tripletas que hagan referencia a los recursos que posee el contenedor.

###### DELETE

1. Cuando se borra un recurso hay que actualizar las tripletas de pertenencia

##### [Normativa de Indirect Container](https://www.w3.org/TR/ldp/#ldpr-gen-linktypehdr)

Esta sección recoge la normativa aplicable para un IndirectContainer

###### General

1. Los contenedores Indirectos deben cumplir la [Normativa de contenedores Directos](#Normativa de Direct Container). Los clientes deben de poder inferir la tripleta (sujeto -> LDP Basic Container, predicado -> rdf:type, Objeto -> ldp:Container), pero no es necesario expresarla explícitamente.

2. Los contenedores indirectos deben de tener exactamente una tripleta donde el sujeto es la URI del propio contenedor, el predicado es ldp:insertedContentRelation, y cuyo objeto ICR describe cómo se elige el member-derived-URI en la membresía del contenedor.

   ```
   ldp:insertedContentRelation foaf:primaryTopic; 
   ```

   El member-derived-URI se toma de un triple (S, P, O) en el documento proporcionado por el cliente como entrada para la solicitud de creación; si el valor de ICR es P, entonces el URI derivado del miembro es O.

   Por ejemplo si el cliente realiza un POST con contenido RDF, a un contenedor, esto causa que se cree el recurso LDP-RS, y que contenga la tripleta (<>, foaf: primaryTopic, bob#me) donde  foaf: primaryTopic indica que la  member-derived-URI es bob#me. Esto implica que solo esta bien definido si el media type es RDF

###### POST

1. Los LDPCs en los que la tripleta ldp:insertedContentRelation tengan un objeto distinto a ldp:MemberSubject, al crear un nuevo recurso, deben añadir al predicado ldp:contains la URI del objeto creado (que es diferente al member-derived-URI en este caso [sin el #me])

###### DELETE

1. Cuando se borra un recurso hay que actualizar las tripletas de pertenencia



#### [Información de normativa general (No LDP)](https://www.w3.org/TR/ldp/#ldpr-gen-linktypehdr) , (información no normativa)

- ser miembro de un LDPC no es exclusivo, por lo que un mismo recurso puede ser miembro de varios LDPCs
- No se puede en ningún caso reutilizar URIS

##### HTTP 1.1

1. Los Servidores LDPS pueden soportar mas representaciones de las requeridas en este documento, como por ejemplo para recursos RDF N3, NTriples ... o para no RDF HTML, JSON....
2. Los recursos pueden crearse por otros métodos, por ejemplo por el endpoint SPARQL, siempre y cuando no entren en conflicto con las restricciones descritas.
3. Después de eliminar un recurso con el método DELETE, el acceso a dicho recurso con la misma URI, deberá de retornar el código 404 (Not Found) o 410 (Gone)
4. Es aceptable borrar tripletas, cuando se borra otro recurso y este aparece como sujeto u objeto, en algún otro recurso, pero también es aceptable (y es lo común) , que los servidores no hagan eso.
5. Puede implementarse el método PATH para modificación parcial, sin restricción mínima de tripletas a modificar, pero no es obligatorio
6. Cuando no aparece la cabecera Content-Type, el servidor pude inferirlo de el contenido.

##### RDF

1. Los recursos LDPR pueden tener tripletas con cualquier sujeto. La URL usada para recuperar los datos, no necesita ser sujeto de ninguna de esas tripletas.

2. Las tripletas de un contendor, pueden tener cualquier número de tripletas donde el sujeto es un recurso de dicho contenedor. Esto permite al servidor dar información de los miembros sin tener que realizar un GET sobre cada uno de ellos.

3. Un recurso puede tener mas de una tripleta, con el predicado rdf:type

   

#### [Cabeceras HTTP](https://www.w3.org/TR/ldp/#ldpr-gen-linktypehdr) 

##### Accept-Post

Sirve para especificar los formatos de documentos que el servidor acepta en el método POST

La sintaxis es

```
Accept-Post = "Accept-Post" ":" # media-range
```

Donde los media-range,  es la lista de medios (con parámetros opcionales) aceptados separados por coma, exactamente igual que la cabecera HTTP accept (menos el opcional-params)

El encabezado Accept-Post, debe de retornarse en la petición OPTIONS, para cualquier recurso que admita el método POST. La presencia de Accept-POST, indica implícitamente que la operación POST esta permitida sobre el recurso que indica la URI. La presencia de un determinado formato, indica que dicho formato es admitido en la operación POST sobre ese recurso.

##### Prefer

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

##### Link

Sirve para establecer las relaciones de dos recursos en la Web

###### describedby

La relación A describedby B afirma que el recurso B proporciona una descripción del recurso A. No hay restricciones del formato de A y B

#### Consideraciones de seguridad (no normativo)

Siendo LDP una extensión de HTTP, la normativa de seguridad de HTTP, esta vigente, no obligando LDP a realizar ninguna operación que pueda contradecir la seguridad de dicho protocolo. Por ejemplo, al realizar una operación PUT, sin la oportuna autorización, el servidor puede responder 401 (Unauthorized) o 403 (Forbidden) si contradice una determinada política de seguridad