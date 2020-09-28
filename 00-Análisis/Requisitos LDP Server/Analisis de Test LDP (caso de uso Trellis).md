![](./images/logos_feder.png)

# Errores en test

## Generales

### testContentTypeHeader

**Tipo:** SHOULD

**Requisito:**  LDP servers SHOULD use the Content-Type request header to determine the representation format when the request has an entity body.

**Causa:** Se intenta parserar la cabecera

```
<http://127.0.0.1/basic/d5f316cf-0be9-41b9-ab15-cafda3d7b33b?ext=timemap>; rel="timemap"; from="Fri, 6 Mar 2020 12:32:20 GMT"; until="Fri, 6 Mar 2020 12:32:20 GMT"; type="application/link-format"
```

Usando el método **splitLinks** dentro de la clase, LdpTest.java. Dicho método, separa cabeceras por medio del carácter ",", dado que la fecha contiene coma, corta la cabecera, dejándola en:

```
<http://127.0.0.1/basic/d5f316cf-0be9-41b9-ab15-cafda3d7b33b?ext=timemap>; rel="timemap"; from="Fri
```

A partir de ahí se eleva una excepción al convertirlo a la clase Link

**Solución:** Sustituir dicho método por el siguiente contenido

```java
protected List<String> splitLinks(Header linkHeader) {
		final ArrayList<String> links = new ArrayList<>();
		final String value = linkHeader.getValue();

		// Track the beginning index for the current link-value.
		int beginIndex = 0;

		// Is the current char inside a URI-Reference?
		boolean inUriRef = false;
		int inStringCounter = 0; /* Contenido deñadido: Linea */

		// Split the string on commas, but only if not in a URI-Reference
		// delimited by angle brackets.
		for (int i = 0; i < value.length(); ++i) {
			final char c = value.charAt(i);

			if (c == ',' && !inUriRef && inStringCounter%2==0) { /* Contenido deñadido: && inStringCounter%2==0 */
				// Found a comma not in a URI-Reference. Split the string.
				final String link = value.substring(beginIndex, i).trim();
				links.add(link);

				// Assign the next begin index for the next link.
				beginIndex = i + 1;
			} else if (c == '<') {
				// Angle brackets are not legal characters in a URI, so they can
				// only be used to mark the start and end of a URI-Reference.
				// See http://tools.ietf.org/html/rfc3986#section-2
				inUriRef = true;
			} else if (c == '>') {
				inUriRef = false;
			} else if (c == '"') { /* Contenido deñadido */
				inStringCounter++; /* Contenido deñadido: Linea */
			}
		}

		// There should be one more link in the string.
		final String link = value.substring(beginIndex, value.length()).trim();
		links.add(link);

		return links;
	}
```

**Diagnostico:** Fallo en creación del Test

### testContentTypeHeader

**Tipo:** MAY

**Requisito:**  The representation of a LDPC MAY have an rdf:type of ldp:Container for Linked Data Platform Container. Non-normative note: LDPCs might have additional types, like any LDP-RS.

**Causa:** El test intenta encontrar una cabecera del tipo **ldp:Container**

```
 http://127.0.0.1/basic/ @ldp:contains http://127.0.0.1/basic/84eb315f-cbc4-45f7-ac46-f48c42382fbf;
 http://127.0.0.1/basic/ @rdf:type ldp:Container;
```



Como en este caso se realiza sobre un tipo especifico de contenedor [BasicContainer, DirectContaner, IndirectContaner], para las pruebas BasicContainer, se obtiene la cabecera:

```
 http://127.0.0.1/basic/ @ldp:contains http://127.0.0.1/basic/84eb315f-cbc4-45f7-ac46-f48c42382fbf;
 http://127.0.0.1/basic/ @rdf:type ldp:BasicContainer;
```

**Solución:** 

En este caso hay que interpretar la normativa de la LDP

* Por un lado la normativa que evalúa el test (requisito 5.2.1.2) especifica:

  

***Requisito RF_04_01_02  [(5.2.1.2 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Tripleta rdf:type de ldp:Container***

> *La representación RDF de un contenedor **PUEDE** tener una tripleta del tipo*
>
> <center><strong>Subject URI del Contenedor &rarr; rdf:type &rarr; ldp:Container</strong></center>
>*para los LDP Container.*
> 
>*Los LDP Containers pueden tener cualquier tipo adicional, exactamente igual que los LDP-RS*



Pero existen normativas más concretas que en este caso, que entran en contradicción con la primera y creo que son las que aplican, por ejemplo:

- **Requisito RF_04_01_04  [(5.2.1.4 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Advertir del soporte LDP para los contenedores**

> Los servidores que expongan LDP Containers, **DEBEN** de advertir de ello, exponiendo una cabecera **Link**, especificando en el destino, la URI del tipo de contenedor que el servidor soporta, y un relation type rel="type", en respuesta a todas las peticiones realizas sobre la URI del contenedor. También pueden exponer otras cabeceras Link con el relation type rel="type".
>
> Las URIs validas para distintos tipos de contenedores son
>
> | URI para le Link                               | Tipo de contenedor   |
> | ---------------------------------------------- | -------------------- |
> | **http://www.w3.org/ns/ldp#BasicContaine**     | Contenedor Básico    |
> | **http://www.w3.org/ns/ldp#DirectContainer**   | Contenedor Directo   |
> | **http://www.w3.org/ns/ldp#IndirectContainer** | Contenedor Indirecto |
>
> 

- **Requisito RF_06_01_01  [(5.3.1.1 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): El cliente debe poder inferir la tripleta (Uri Contenedor Básico, rdf:type, ldp:Container .**

> Cada contenedor LDP Direct Container, **DEBE** de estar conforme a los [Requisitos Generales de los Contenedores](#Requisitos Generales sobre Contenedores). El cliente **DEBE**  poder inferir la tripleta (Uri Contenedor Básico, rdf:type, ldp:Container), aunque esta puede no estar presente.

Y por otro lado en los ejemplos de la LPD, se pueden ver cabeceras **type:BasicContainer** identicas a las ofrecidas por Trellis

```http
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

Por lo tanto se estima que la implementación del test no es la mejor posible, y se modifica de la siguiente manera

```java
@Test(
			groups = {MAY},
			description = "The representation of a LDPC MAY have an rdf:type "
					+ "of ldp:Container for Linked Data Platform Container. Non-normative "
					+ "note: LDPCs might have additional types, like any LDP-RS. ")
	@SpecTest(
			specRefUri = LdpTestSuite.SPEC_URI + "#ldpc-typecontainer",
			testMethod = METHOD.AUTOMATED,
			approval = STATUS.WG_APPROVED)
	public void testRdfTypeLdpContainer() {
		String container = getResourceUri();
		Model m = buildBaseRequestSpecification()
				.header(ACCEPT, TEXT_TURTLE)
			.expect()
				.statusCode(isSuccessful())
			.when()
				.get(container).as(Model.class, new RdfObjectMapper(container));
		org.openrdf.model.URI containerType;
        /* Comienzo Boque añadido para determinar el tipo de contenedor */
		if (this instanceof BasicContainerTest) {
			containerType = LDP.BasicContainer;
		} else if (this instanceof DirectContainerTest) {
			containerType = LDP.DirectContainer;
		} else if (this instanceof IndirectContainerTest) {
			containerType = LDP.IndirectContainer;
		} else {
			containerType = LDP.Container;
		}
		/* Fin Boque añadido */
        
        /* Se añade containerType obtenido en sustitucion de LDP.Container que figuraba anteriormente*/
		assertTrue(m.contains(m.getResource(container), RDF.type, m.getResource(containerType.stringValue())),
				"LDPC does not have an rdf:type of ldp:Container");
	}
```

**Diagnostico:** Fallo en implementación del Test

## Basic

### BasicContainerTest.testRestrictUriReUseSlug

**Tipo:** SHOULD

**Requisito:**   LDP servers that allow member creation via POST SHOULD NOT re-use URIs.

**Causa:** Funciona correctamente cuando no se usa la cabecera Slug, pero no cumple el requisito cuando se usa la cabecera Slug. Probablemente esto este en conflicto con el cumplimiento del estandar memento, ya que este prevee distintos estados para una entidad en distintas lineas temporales, y por lo tanto, se debe de permitir la reutilización de URIs.

**Solución:** No se puede solucionar sin re-implementar el servidor LDP, Trellis no lo cumple. **Quizas no se pueda realizar conservando las propiedades del estandar memento.**

**DIAGNOSTICO**: Fallo leve (es un SHOULD)

### BasicContainerTest.testPutRequiresIfMatch (2 veces)

**Tipo:** SHOULD

**Requisito:**  

> ###### Requisito RF_01_03_05 [(4.2.4.5 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Fallos por restricciones en propiedades
>
> Los clientes **PUEDEN** usar la cabecera **If-Match** y la cabecera **ETag** para garantizar que no se actualiza un recurso, que pueda haber cambiado desde que el cliente obtuvo su representación. El servidor **PUEDE** requerir el uso de ambas cabeceras. El servidor LDP **DEBE**  responder con el código 412 (Condition Failed), si falla por causa del ETag, y no existen otros errores. Los servidores que requieran el ETag, y este no este presente, **DEBEN** responder con el código 428 (Precondition Required) si esta es la única razón.

**Causa:** El servidor LDP, no aplica la cabecera If-Match. Probablemente esto este en conflicto con el cumplimiento del estandar memento, ya que este prevee distintos estados para una entidad en distintas lineas temporales, y por lo tanto, carece de sentido en este contexto el uso de la cabecera If-Match.

**Solución:** No se puede solucionar sin re-implementar el servidor LDP, Trellis no lo cumple.  Quizas no se pueda realizar conservando las propiedades del estandar memento.

**DIAGNOSTICO**: Fallo leve (es un SHOULD)

### BasicContainerTest.testPublishConstraintsUnknownProp (2 veces)

**Tipo:** MUST

**Requisito:**  

> ###### Requisito RF_01_01_06 [(4.2.1.6 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Advertir de restricciones
>
> El servidor LDP **DEBE** de publicar cualquier restricción que se pueda aplicar sobre la capacidad de un cliente de crear o actualizar los LDPRs, añadiendo una cabecera Link, con el apropiado contexto de URI en el sujeto (en principio la URL sobre la que se realiza la petición), un link a una relación http://www.w3.org/ns/ldp#constrainedBy como predicado, y como objeto el conjunto de restricciones que se aplican, para todas las respuestas que se generen a partir de peticiones que han fallado, debido a una de esas restricciones. La especificación LDP no define restricciones, por lo que se permiten cualquier tipo de ellas, incluyendo aquellas que se pudiesen definir para un dominio concreto. 

**Causa:** Funcionalmente se comporta correctamente, la entidad **NO** es insertada y retorna un error **4xx**, pero **no sigue el requisito** indicado arriba de advertir de la restricción que pueda ser aplicada.

**Solución:** No se puede solucionar sin re-implementar el servidor LDP, Trellis no lo cumple

**DIAGNOSTICO**: Fallo grave

### BasicContainerTest.testResponsePropertiesNotPersisted (2 veces)

**Tipo:** MAY

**Requisito:**  

> ###### Requisito RF_01_03_04 [(4.2.4.4 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Fallos por restricciones en propiedades
>
> En el caso de que el servidor reciba una solicitud PUT a priori valida, pero que contenga propiedades que el servidor decida no persistir (por ejemplo, contenido desconocido), el servidor **DEBE** de responder con el código apropiado en el rango 4xx. El servidor **PUEDE**  proporcionar una BODY de respuesta, pero este no esta definido por la LDP. Los servidores tal como se advierte en el requisito  [RF_01_01_04](#Requisito RF_01_01_04 [(4.2.1.4 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Advertir de soporte LDP), **DEBERÁN** de exponer las restricciones que puedan ser impuestas.

**Causa:** Funcionalmente se comporta correctamente, la entidad **NO** es insertada y retorna un error **4xx**, pero **no sigue el requisito** indicado arriba de advertir de la restricción que pueda ser aplicada.

**Solución:** No se puede solucionar sin re-implementar el servidor LDP, Trellis no lo cumple

**DIAGNOSTICO**: Fallo leve

### BasicContainerTest.testTypeRdfSource

**Tipo:** SHOULD

**Requisito:**  

> ###### Requisito RF_02_01_02  [(4.3.1.2 LDP)](https://www.w3.org/TR/ldp/#ldprs): Al menos una tripleta del tipo rdf:type 
>
> Las representaciones LDP-RS, **DEBERIAN** de tener al menos una tripleta **rdf:type**, informada explícitamente, esto facilita el trabajo a los clientes que no soportan inferencia.

**Causa:** Otra vez la normativa es confusa, por un lado en el requisito expresado sobre estas líneas, se especifica que cualquier RDFSource debe tener la tripleta rdf:type, RDFSource, pero el test hace la petición sobre el contenedor básico /basic, por lo que debería predominar la normativa sobre contenedores

> ###### Requisito RF_04_01_01  [(5.2.1.1 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Normativa RDF Source
>
> Los contenedores son LDP Sources, por lo tanto debe cumplirse la normativa descrita en esa [sección](#Requisitos Generales sobre RDF Source)
>
> Los clientes deben de poder inferir la tripleta
>
> <center><strong>Subject URI del Contenedor &rarr; rdf:type &rarr; ldp:RDFSource</strong></center>
>pero expresarla explícitamente no esta requerido

En esta especifica que la tripleta se debe de inferir, **pero esta no esta requerida**

Entre las tripletas que se obtienen destaca

```
<http://localhost/basic/>	rdf:type      ldp:BasicContainer ;
```

Como un BasicContainer es una sub-clase de RDFSource, pues en mi opinión, cumple con la normativa más especifica, y por lo tanto, el test debería de no fallar. 

**Solución:** Definir la normativa a aplicar, y en función de eso corregir el test o la implementación del servidor LDP.

**DIAGNOSTICO**: Interpretativa

### BasicContainerTest.testRestrictPutReUseUri

**Tipo:** SHOULD

**Requisito:**  

> ###### Requisito RF_04_03_02  [(5.2.4.2 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): No se deben reusar URIs
>
> Los servidores que admiten PUT para creación de recursos **NO DEBERÍAN** reusar URIs.

**Causa:** En este caso, el servidor esta claramente reusando la URI, por lo que podría interpretarse como un fallo. Probablemente esto este en conflicto con el cumplimiento del estandar memento, ya que este prevee distintos estados para una entidad en distintas lineas temporales, y por lo tanto, se debe de permitir la reutilización de URIs.

**Solución:** No se puede solucionar sin re-implementar el servidor LDP, Trellis no lo cumple. **Quizas no se pueda realizar conservando las propiedades del estandar memento.**

**DIAGNOSTICO**: Fallo leve

### BasicContainerTest.testPutSimpleUpdate

**Tipo:** SHOULD

**Requisito:**  

> ###### Requisito RF_01_03_02  [(4.2.4.2 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Permitir realizar una actualización, sin un conocimiento profundo de las restricciones del Servidor
>
> Los servidores LDP **DEBERÍA** permitir a los clientes actualizar recursos sin requerir un conocimiento detallado de las restricciones específicas del servidor. Esto es una consecuencia del requisito de permitir la creación y modificación simples de LDPR. En caso de existir restricciones es necesario advertirlas [requisito RF_01_01_06](#Requisito RF_01_01_06: Advertir de restricciones), siguiendo lo dispuesto en el [requisito RF_01_03_03](

**Causa:** En este caso, el servidor tiene una restricción sobre el recurso, y esta no esta siendo recibida en la operación GET, por lo que no se puede aplicar a la petición PUT

**Solución:** No se puede solucionar sin re-implementar el servidor LDP, Trellis no lo cumple

**DIAGNOSTICO**: Fallo leve

## Direct

### BasicContainerTest.testRestrictUriReUseSlug

**Tipo:** SHOULD

**Requisito:**   LDP servers that allow member creation via POST SHOULD NOT re-use URIs.

**Causa:** Funciona correctamente cuando no se usa la cabecera Slug, pero no cumple el requisito cuando se usa la cabecera Slug. Probablemente esto este en conflicto con el cumplimiento del estandar memento, ya que este prevee distintos estados para una entidad en distintas lineas temporales, y por lo tanto, se debe de permitir la reutilización de URIs.

**Solución:** No se puede solucionar sin re-implementar el servidor LDP, Trellis no lo cumple. **Quizas no se pueda realizar conservando las propiedades del estandar memento.**

**DIAGNOSTICO**: Fallo leve (es un SHOULD)

### BasicContainerTest.testPutRequiresIfMatch (2 veces)

**Tipo:** SHOULD

**Requisito:**  

> ###### Requisito RF_01_03_05 [(4.2.4.5 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Fallos por restricciones en propiedades
>
> Los clientes **PUEDEN** usar la cabecera **If-Match** y la cabecera **ETag** para garantizar que no se actualiza un recurso, que pueda haber cambiado desde que el cliente obtuvo su representación. El servidor **PUEDE** requerir el uso de ambas cabeceras. El servidor LDP **DEBE**  responder con el código 412 (Condition Failed), si falla por causa del ETag, y no existen otros errores. Los servidores que requieran el ETag, y este no este presente, **DEBEN** responder con el código 428 (Precondition Required) si esta es la única razón.

**Causa:** El servidor LDP, no aplica la cabecera If-Match. Probablemente esto este en conflicto con el cumplimiento del estandar memento, ya que este prevee distintos estados para una entidad en distintas lineas temporales, y por lo tanto, carece de sentido en este contexto el uso de la cabecera If-Match.

**Solución:** No se puede solucionar sin re-implementar el servidor LDP, Trellis no lo cumple.  Quizas no se pueda realizar conservando las propiedades del estandar memento.

**DIAGNOSTICO**: Fallo leve (es un SHOULD)

### BasicContainerTest.testPreferMembershipTriples

**Tipo:** SHOULD

**Requisito:**   LDP servers that allow member creation via POST SHOULD NOT re-use URIs.

**Causa:** Contiene tripletas de membresía, cuando se especifica PREFER_MINIMAL_CONTAINER en la request

**Solución:**  La consecuencia es unidamente que da tripletas de más, por lo tanto causa algo de sobrecarga en el cliente. No se puede solucionar sin re-implementar el servidor LDP, Trellis no lo cumple

**DIAGNOSTICO**: Fallo muy leve (es un SHOULD)

### BasicContainerTest.testPublishConstraintsUnknownProp (2 veces)

**Tipo:** MUST

**Requisito:**  

> ###### Requisito RF_01_01_06 [(4.2.1.6 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Advertir de restricciones
>
> El servidor LDP **DEBE** de publicar cualquier restricción que se pueda aplicar sobre la capacidad de un cliente de crear o actualizar los LDPRs, añadiendo una cabecera Link, con el apropiado contexto de URI en el sujeto (en principio la URL sobre la que se realiza la petición), un link a una relación http://www.w3.org/ns/ldp#constrainedBy como predicado, y como objeto el conjunto de restricciones que se aplican, para todas las respuestas que se generen a partir de peticiones que han fallado, debido a una de esas restricciones. La especificación LDP no define restricciones, por lo que se permiten cualquier tipo de ellas, incluyendo aquellas que se pudiesen definir para un dominio concreto. 

**Causa:** Funcionalmente se comporta correctamente, la entidad **NO** es insertada y retorna un error **4xx**, pero **no sigue el requisito** indicado arriba de advertir de la restricción que pueda ser aplicada.

**Solución:** No se puede solucionar sin re-implementar el servidor LDP, Trellis no lo cumple

**DIAGNOSTICO**: Fallo grave

### BasicContainerTest.testPutSimpleUpdate (2 veces)

**Tipo:** SHOULD

**Requisito:**  

> ###### Requisito RF_01_03_02  [(4.2.4.2 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Permitir realizar una actualización, sin un conocimiento profundo de las restricciones del Servidor
>
> Los servidores LDP **DEBERÍA** permitir a los clientes actualizar recursos sin requerir un conocimiento detallado de las restricciones específicas del servidor. Esto es una consecuencia del requisito de permitir la creación y modificación simples de LDPR. En caso de existir restricciones es necesario advertirlas [requisito RF_01_01_06](#Requisito RF_01_01_06: Advertir de restricciones), siguiendo lo dispuesto en el [requisito RF_01_03_03](

**Causa:** En este caso, el servidor tiene una restricción sobre el recurso, y esta no esta siendo recibida en la operación GET, por lo que no se puede aplicar a la petición PUT

**Solución:** No se puede solucionar sin re-implementar el servidor LDP, Trellis no lo cumple

**DIAGNOSTICO**: Fallo leve

### BasicContainerTest.testResponsePropertiesNotPersisted (2 veces)

**Tipo:** SHOULD

**Requisito:**  

> ###### Requisito RF_01_03_04 [(4.2.4.4 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Fallos por restricciones en propiedades
>
> En el caso de que el servidor reciba una solicitud PUT a priori valida, pero que contenga propiedades que el servidor decida no persistir (por ejemplo, contenido desconocido), el servidor **DEBE** de responder con el código apropiado en el rango 4xx. El servidor **PUEDE**  proporcionar una BODY de respuesta, pero este no esta definido por la LDP. Los servidores tal como se advierte en el requisito  [RF_01_01_04](#Requisito RF_01_01_04 [(4.2.1.4 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Advertir de soporte LDP), **DEBERÁN** de exponer las restricciones que puedan ser impuestas.

**Causa:** Funcionalmente se comporta correctamente, la entidad **NO** es insertada y retorna un error **4xx**, pero **no sigue el requisito** indicado arriba de advertir de la restricción que pueda ser aplicada.

**Solución:** No se puede solucionar sin re-implementar el servidor LDP, Trellis no lo cumple

**DIAGNOSTICO**: Fallo leve

### BasicContainerTest.testTypeRdfSource

**Tipo:** SHOULD

**Requisito:**  

> ###### Requisito RF_02_01_02  [(4.3.1.2 LDP)](https://www.w3.org/TR/ldp/#ldprs): Al menos una tripleta del tipo rdf:type 
>
> Las representaciones LDP-RS, **DEBERIAN** de tener al menos una tripleta **rdf:type**, informada explícitamente, esto facilita el trabajo a los clientes que no soportan inferencia.

**Causa:** Otra vez la normativa es confusa, por un lado en el requisito expresado sobre estas líneas, se especifica que cualquier RDFSource debe tener la tripleta rdf:type, RDFSource, pero el test hace la petición sobre el contenedor básico /basic, por lo que debería predominar la normativa sobre contenedores

> ###### Requisito RF_04_01_01  [(5.2.1.1 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Normativa RDF Source
>
> Los contenedores son LDP Sources, por lo tanto debe cumplirse la normativa descrita en esa [sección](#Requisitos Generales sobre RDF Source)
>
> Los clientes deben de poder inferir la tripleta
>
> <center><strong>Subject URI del Contenedor &rarr; rdf:type &rarr; ldp:RDFSource</strong></center>
>pero expresarla explícitamente no esta requerido

En esta especifica que la tripleta se debe de inferir, **pero esta no esta requerida**

Entre las tripletas que se obtienen destaca

```
<http://localhost/basic/>	rdf:type      ldp:BasicContainer ;
```

Como un BasicContainer es una sub-clase de RDFSource, pues en mi opinión, cumple con la normativa más especifica, y por lo tanto, el test debería de no fallar. 

**Solución:** Definir la normativa a aplicar, y en función de eso corregir el test o la implementación del servidor LDP.

**DIAGNOSTICO**: Interpretativa

### BasicContainerTest.testRestrictPutReUseUri

**Tipo:** SHOULD

**Requisito:**  

> ###### Requisito RF_04_03_02  [(5.2.4.2 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): No se deben reusar URIs
>
> Los servidores que admiten PUT para creación de recursos **NO DEBERÍAN** reusar URIs.

**Causa:** En este caso, el servidor esta claramente reusando la URI, por lo que podría interpretarse como un fallo. Probablemente esto este en conflicto con el cumplimiento del estandar memento, ya que este prevee distintos estados para una entidad en distintas lineas temporales, y por lo tanto, se debe de permitir la reutilización de URIs.

**Solución:** No se puede solucionar sin re-implementar el servidor LDP, Trellis no lo cumple. **Quizas no se pueda realizar conservando las propiedades del estandar memento.**

**DIAGNOSTICO**: Fallo leve

## Indirect

### BasicContainerTest.testRestrictUriReUseSlug 

**Tipo:** SHOULD

**Requisito:**   LDP servers that allow member creation via POST SHOULD NOT re-use URIs.

**Causa:** Funciona correctamente cuando no se usa la cabecera Slug, pero no cumple el requisito cuando se usa la cabecera Slug. Probablemente esto este en conflicto con el cumplimiento del estandar memento, ya que este prevee distintos estados para una entidad en distintas lineas temporales, y por lo tanto, se debe de permitir la reutilización de URIs.

**Solución:** No se puede solucionar sin re-implementar el servidor LDP, Trellis no lo cumple. **Quizas no se pueda realizar conservando las propiedades del estandar memento.**

**DIAGNOSTICO**: Fallo leve (es un SHOULD)

### BasicContainerTest.testPutRequiresIfMatch (2 veces) 

**Tipo:** SHOULD

**Requisito:**  

> ###### Requisito RF_01_03_05 [(4.2.4.5 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Fallos por restricciones en propiedades
>
> Los clientes **PUEDEN** usar la cabecera **If-Match** y la cabecera **ETag** para garantizar que no se actualiza un recurso, que pueda haber cambiado desde que el cliente obtuvo su representación. El servidor **PUEDE** requerir el uso de ambas cabeceras. El servidor LDP **DEBE**  responder con el código 412 (Condition Failed), si falla por causa del ETag, y no existen otros errores. Los servidores que requieran el ETag, y este no este presente, **DEBEN** responder con el código 428 (Precondition Required) si esta es la única razón.

**Causa:** El servidor LDP, no aplica la cabecera If-Match. Probablemente esto este en conflicto con el cumplimiento del estandar memento, ya que este prevee distintos estados para una entidad en distintas lineas temporales, y por lo tanto, carece de sentido en este contexto el uso de la cabecera If-Match.

**Solución:** No se puede solucionar sin re-implementar el servidor LDP, Trellis no lo cumple.  Quizas no se pueda realizar conservando las propiedades del estandar memento.

**DIAGNOSTICO**: Fallo leve (es un SHOULD)

### BasicContainerTest.testPublishConstraintsUnknownProp (2 veces) 

**Tipo:** MUST

**Requisito:**  

> ###### Requisito RF_01_01_06 [(4.2.1.6 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Advertir de restricciones
>
> El servidor LDP **DEBE** de publicar cualquier restricción que se pueda aplicar sobre la capacidad de un cliente de crear o actualizar los LDPRs, añadiendo una cabecera Link, con el apropiado contexto de URI en el sujeto (en principio la URL sobre la que se realiza la petición), un link a una relación http://www.w3.org/ns/ldp#constrainedBy como predicado, y como objeto el conjunto de restricciones que se aplican, para todas las respuestas que se generen a partir de peticiones que han fallado, debido a una de esas restricciones. La especificación LDP no define restricciones, por lo que se permiten cualquier tipo de ellas, incluyendo aquellas que se pudiesen definir para un dominio concreto. 

**Causa:** Funcionalmente se comporta correctamente, la entidad **NO** es insertada y retorna un error **4xx**, pero **no sigue el requisito** indicado arriba de advertir de la restricción que pueda ser aplicada.

**Solución:** No se puede solucionar sin re-implementar el servidor LDP, Trellis no lo cumple

**DIAGNOSTICO**: Fallo grave

### BasicContainerTest.testPutSimpleUpdate (2 veces) 

**Tipo:** SHOULD

**Requisito:**  

> ###### Requisito RF_01_03_02  [(4.2.4.2 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Permitir realizar una actualización, sin un conocimiento profundo de las restricciones del Servidor
>
> Los servidores LDP **DEBERÍA** permitir a los clientes actualizar recursos sin requerir un conocimiento detallado de las restricciones específicas del servidor. Esto es una consecuencia del requisito de permitir la creación y modificación simples de LDPR. En caso de existir restricciones es necesario advertirlas [requisito RF_01_01_06](#Requisito RF_01_01_06: Advertir de restricciones), siguiendo lo dispuesto en el [requisito RF_01_03_03](

**Causa:** En este caso, el servidor tiene una restricción sobre el recurso, y esta no esta siendo recibida en la operación GET, por lo que no se puede aplicar a la petición PUT

**Solución:** No se puede solucionar sin re-implementar el servidor LDP, Trellis no lo cumple

**DIAGNOSTICO**: Fallo leve

### BasicContainerTest.testResponsePropertiesNotPersisted (2 veces) 

**Tipo:** SHOULD

**Requisito:**  

> ###### Requisito RF_01_03_04 [(4.2.4.4 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Fallos por restricciones en propiedades
>
> En el caso de que el servidor reciba una solicitud PUT a priori valida, pero que contenga propiedades que el servidor decida no persistir (por ejemplo, contenido desconocido), el servidor **DEBE** de responder con el código apropiado en el rango 4xx. El servidor **PUEDE**  proporcionar una BODY de respuesta, pero este no esta definido por la LDP. Los servidores tal como se advierte en el requisito  [RF_01_01_04](#Requisito RF_01_01_04 [(4.2.1.4 LDP)](https://www.w3.org/TR/ldp/#ldpr-resource): Advertir de soporte LDP), **DEBERÁN** de exponer las restricciones que puedan ser impuestas.

**Causa:** Funcionalmente se comporta correctamente, la entidad **NO** es insertada y retorna un error **4xx**, pero **no sigue el requisito** indicado arriba de advertir de la restricción que pueda ser aplicada.

**Solución:** No se puede solucionar sin re-implementar el servidor LDP, Trellis no lo cumple

**DIAGNOSTICO**: Fallo leve

### BasicContainerTest.testTypeRdfSource 

**Tipo:** SHOULD

**Requisito:**  

> ###### Requisito RF_02_01_02  [(4.3.1.2 LDP)](https://www.w3.org/TR/ldp/#ldprs): Al menos una tripleta del tipo rdf:type 
>
> Las representaciones LDP-RS, **DEBERIAN** de tener al menos una tripleta **rdf:type**, informada explícitamente, esto facilita el trabajo a los clientes que no soportan inferencia.

**Causa:** Otra vez la normativa es confusa, por un lado en el requisito expresado sobre estas líneas, se especifica que cualquier RDFSource debe tener la tripleta rdf:type, RDFSource, pero el test hace la petición sobre el contenedor básico /basic, por lo que debería predominar la normativa sobre contenedores

> ###### Requisito RF_04_01_01  [(5.2.1.1 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): Normativa RDF Source
>
> Los contenedores son LDP Sources, por lo tanto debe cumplirse la normativa descrita en esa [sección](#Requisitos Generales sobre RDF Source)
>
> Los clientes deben de poder inferir la tripleta
>
> <center><strong>Subject URI del Contenedor &rarr; rdf:type &rarr; ldp:RDFSource</strong></center>
>pero expresarla explícitamente no esta requerido

En esta especifica que la tripleta se debe de inferir, **pero esta no esta requerida**

Entre las tripletas que se obtienen destaca

```
<http://localhost/basic/>	rdf:type      ldp:BasicContainer ;
```

Como un BasicContainer es una sub-clase de RDFSource, pues en mi opinión, cumple con la normativa más especifica, y por lo tanto, el test debería de no fallar. 

**Solución:** Definir la normativa a aplicar, y en función de eso corregir el test o la implementación del servidor LDP.

**DIAGNOSTICO**: Interpretativa

### BasicContainerTest.testRestrictPutReUseUri 

**Tipo:** SHOULD

**Requisito:**  

> ###### Requisito RF_04_03_02  [(5.2.4.2 LDP)](https://www.w3.org/TR/ldp/#ldpc-container): No se deben reusar URIs
>
> Los servidores que admiten PUT para creación de recursos **NO DEBERÍAN** reusar URIs.

**Causa:** En este caso, el servidor esta claramente reusando la URI, por lo que podría interpretarse como un fallo. Probablemente esto este en conflicto con el cumplimiento del estandar memento, ya que este prevee distintos estados para una entidad en distintas lineas temporales, y por lo tanto, se debe de permitir la reutilización de URIs.

**Solución:** No se puede solucionar sin re-implementar el servidor LDP, Trellis no lo cumple. **Quizas no se pueda realizar conservando las propiedades del estandar memento.**

**DIAGNOSTICO**: Fallo leve

## Test

Test para BasicContainer

## Conclusiones

Siempre se repiten los mismos fallos en los test, y estos casi siempre son SHOULD, es decir un deseo, no una obligación de que el servidor actué de una determinada manera.

Solo el test BasicContainerTest.testPublishConstraintsUnknownProp, corresponde a un requerimiento MUST, y cumple la parte más importante, es decir, la acción se realiza correctamente, y el test falla, por que espera una cabecera con la causa, que en el caso concreto de Trellis, no aparece

En ningún caso afecta a requisitos funcionales es decir, la acción se realiza correctamente, pero las cabeceras (en las ocasiones enumeradas) no son tal cual lo indica la LDP.

Creo que como punto de partida, Trellis cumple de forma razonable, los requerimientos de la LDP, si en un futuro, se pensase en mejorar el nivel de cumplimiento, 