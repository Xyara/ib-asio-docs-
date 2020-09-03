# Buenas practicas en URIs

## Objetivo

Establecer un conjunto de buenas practicas en el uso y diseño de URIs, tiene como fin establecer un marco para tal propósito,  que ofrezca al proyecto (al menos en lo concerniente a las URIs) estándares que aumenten la calidad, persistencia y claridad de las URIs aplicables en el proceso de creación, mantenimiento y gestión de las URIs.

Por otro lado, es conveniente tener perspectiva de que existirán de facto en el proyecto dos patrones de URIs, las **URIs internas** o privadas, son aquellas dependientes de la localización del recurso y implementación del servidor, en el momento de escribir el documento, Trellis y Wikibase (pero dado el requisito de el proyecto, de poder adaptarnos a cualquier triple store, esto podría cambiar o ser ampliado). El diseño de estas URIs y su comportamiento vendrá determinado en muchos casos por la implementación del servidor linked data (por ejemplo Wikibase sigue un patrón propio, que no sigue las recomendaciones de la LDP) por lo que sobre estas URIs internas en muchas ocasiones, no tendremos los suficientes grados de libertad, por lo que su diseño y comportamiento de las mismas dependerá de la implementación y por lo tanto esta fuera del alcance de este documento. 

Por otro lado las **URIs externas** o públicas, son aquellas que exponen el recurso al exterior, de forma uniforme, de acuerdo a los patrones de diseño recogidos por el documento de Arquitectura de URIs.

Por lo tanto, el conjunto de buenas practicas recogido en este documento,  tiene su aplicación en este conjunto de URIs.

Por motivos de claridad, cabe indicar, que para cada Backend SGI, la Factoría de URIs, es la encargada de realizar y mantener el mapeo entre las URIs externas y las URIs internas.

Para promover la reutilización de tales datos por agentes internos o externos, es conveniente enumerar los principios a alto nivel que un URI debe cumplir, han de ser: 

- **Sencillos:** URIs cortos y nemotécnicos
- **Escalables:** Flexibilidad en diseño y en horizonte temporal, con el fin de dar cabida tanto a los patrones de URIs derivados de los datos actuales, como de aquellos que puedan ser incorporados en un horizonte temporal de décadas.
- **Manejables:** Fáciles de administrar.
- **Persistentes:** Ante operaciones tales como mover el recurso, eliminarlo o modificarlo.

## Buenas practicas

### Buenas practicas generales

1. **Usar URIs HTTP:** Es un estándar de facto, y proporciona muchas ventajas como los enlaces, el almacenamiento en cache, la indexación en motores de búsqueda, etc. Las URIs permiten buscar y desreferenciar recursos. 
2. **Usar URIs persistentes:** Una misma URI siempre ha de referenciar al mismo recurso. Es decir que no contengan elementos que puedan cambiar con el tiempo, como por ejemplo token de sesión o información de estado. Debe haber un equilibrio en hacerlas legibles, e incluir información descriptiva que probablemente cambie con el tiempo.
   - Es necesario establecer una política que permita el acceso a los recursos, aunque estos se hayan movido o hayan cambiado.
   - Usar servicios persistentes (PURL) para hacer las URIs persistente y desacoplarlas de us ubicación real.
   - La elección de un esquema de URIs no garantiza la persistencia de las URIs, sino que esto es mas bien un compromiso del propietario de la URI.
   - La URI debe permanecer constante, pero el contenido podría cambiar.
   - En caso de borrado, usar 410 Gone. en vez de 404 Not Found.

### Buenas practicas para formato de URIs

1. **Usar URIs lo mas cortos posibles**: Siempre y cuando no se pierda el significado semántico del componente del URI (si lo tuviese).
2. **Política de mayúsculas y minúsculas:**
   - No usar políticas mixtas (distintas en distintas partes de la URI)
   - Siempre minúsculas, salvo en el caso de los conceptos, donde se permite primera letra en mayúscula y resto en minúscula
3. **Sin nombre de la organización:**  Evitar el nombre de la organización en el diseño de la URI, ya que este es susceptible de cambiar en el tiempo, y podría afectar al compromiso de persistencia.
4. **Sin número de versión:**  Evitar el número de versión en los conceptos, por que este previsiblemente ira evolucionando, y por lo tanto afecta también al objetivo de persistencia.

### Buenas practicas para Identificadores

1. **Opacidad en identificadores:** Las propiedades del recurso referenciado no deben de ser inferibles de su URI
2. **No se debe mostrar la tecnología subyacente: ** en su lugar para obtener una representación en un formato especifico del recurso, ha de usarse la negociación de contenidos.
3. **Reusar identificadores existentes: ** Siempre que sea posible, es preferible reusar identificadores existentes, que generar nuevos, entre otros motivos, la trazabilidad y la persistencia, pueden verse afectadas.

### Buenas practicas en representación del recurso

1. **Negociación de contenido:** Negociación de contenidos servida por el servidor, basada en las preferencias/capacidades del usuario.
   - Debe de proporcionarse mecanismos para proporcionar distintas representaciones del mismo recurso por negociación de contenidos, al menos mediante el uso de algoritmos aplicables al contenido de la cabecera Accept.
   - Permitir la negociación de codificación de caracteres con Accept-Charset
   - Para clientes que "acepten cualquier tipo de contenido" (Accept \*/\*) , es preferible usar el formato de contenido más ampliamente usado, preferiblemente mediante los factores de calidad.
   - Establecer por defecto Formato e idioma por defecto, para los clientes que no lo especifiquen.
2. **Añadir metadatos para enlaces con otros formatos :** Enlazar documentos a otros el mismo documento en distintos formatos o idiomas , por ejemplo haciendo uso de la etiqueta link alternate en HTML, o  foad:page y  rdfs:isDefinedBy en RDF, etc.
3. **Al menos una representación RDF del recurso: ** Proporcionar al menos una representación legible por máquina del recurso identificado por la URI.

### Buenas practicas relativas al multilingüismo

1. **Cabecera Content-Language:** Uso del encabezado Content-Language para definir el idioma de preferencia el usuario.
2. **Política de recursos para el multilingüismo:**  Permitir al administrador, mecanismos para definir que el mismo recurso tiene representaciones en varios idiomas.
3. **Añadir metadatos para enlaces con otros idiomas:** Enlazar documentos a otros el mismo documento y formatos a otros idiomas , por ejemplo haciendo uso de la etiqueta link alternate en HTML, o  foad:page y  rdfs:isDefinedBy en RDF, etc.

### Buenas practicas en comportamiento del servidor

1. **Redirecciones:** Código 3xx y cabecera Location con la ubicación del recurso.
   - 301: Movido permanentemente
   - 302: Encontrado
   - 307: Redireccionamiento temporal
2. **Proporcionar información útil a los indexadores:**   Proporcionar Información útil para agentes de indexación, definiendo política de indexación de sitio y local (por ejemplo con la cabecera META en HTML)
3. **Proporcionar información útil para cache:**  
   - Usando de forma correcta la cabecera Date
   - Enviando Last-Modified siempre que sea posible
   - Usando la cabecera Cache-Control, para establecer el comportamiento de los motores de cache con respecto al recurso
   - Definiendo políticas de cache
   - Evitar que la generación de contenido dinámico, use siempre la fecha actual como fecha de última actualización.
   - Haciendo las cabeceras de las peticiones GET y HEAD deben de ser idénticas.
4. **Servir información junto al recurso de el tipo de contenido y codificación de caracteres**
   - Usar cabecera Content-type para informar del formato del contenido servido
   - Informar del conjunto de caracteres usado al menos de una de las siguientes maneras:
     - Con el parámetro charset en la cabecera Content-type
     - Con meta-información en el documento servido
   - Permitir al administrados configurar información del conjunto de caracteres.

### Buenas practicas asociadas a LDP y principios FAIR

1. **Des-referenciables:** Las URIs que definan propiedades deben de ser des-referenciables
2. **Vocabulario RDFS: ** Para describir propiedades
3. **rdf:type:** Al menos una declaración rdf:type para cada recurso.
4. **Pertenencia jerárquica:** relaciones de pertenencia a contenedor, por inferencia sobre el esquema de URIs.
5. **Barra de separación (/):** al final de las URIs para representar contenedores
6. **Uso de fragmentos:** Uso de URI Hash (#) como identificadores de recursos