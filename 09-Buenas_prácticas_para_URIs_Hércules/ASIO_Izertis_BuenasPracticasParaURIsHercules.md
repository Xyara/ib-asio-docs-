![](./images/logos_feder.png)

| Entregable | Buenas practicas para URIs Hércules                          |
| ---------- | ------------------------------------------------------------ |
| Fecha      | 19/06/2020                                                   |
| Proyecto   | [ASIO](https://www.um.es/web/hercules/proyectos/asio) (Arquitectura Semántica e Infraestructura Ontológica) en el marco de la iniciativa [Hércules](https://www.um.es/web/hercules/) para la Semántica de Datos de Investigación de Universidades que forma parte de [CRUE-TIC](https://tic.crue.org/hercules/) |
| Módulo     | Infraestructura Ontológica                                   |
| Tipo       | Documento                                                    |
| Objetivo   | Establecer un conjunto de buenas practicas en el uso y diseño de URIs, que tiene como fin establecer un marco para tal propósito,  que ofrezca al proyecto (al menos en lo concerniente a las URIs) estándares que aumenten la calidad, persistencia y claridad de las URIs aplicables en el proceso de creación, mantenimiento y gestión de las URIs definidas en el [Esquema de URIs Hércules](https://github.com/HerculesCRUE/ib-asio-docs-/blob/master/08-Esquema_de_URIs_H%C3%A9rcules/ASIO_Izertis_ArquitecturaDeURIs.md). Adicionalmente esta política de URIs se ha plasmado en el [Contrato de persistencia de URIs Hércules](./ASIO_Izertis_Contrato_BuenasPracticasParaURIsHercules.md), en el que las universidades que deseen publicar datos se deben comprometer a mantener las URIs y a actuar de acuerdo a lo definido en dicho contrato si los recursos cambian. |
| Estado     | **100%** El análisis y redacción de buenas prácticas se considera finalizado. |



# Buenas practicas para URIs Hércules

Es conveniente tener perspectiva de que existirán de facto en el proyecto dos patrones de URIs, las **URIs internas** o privadas y las **URIs externas** o públicas. Las URIs internas son aquellas dependientes de la localización del recurso e implementación del servidor. Por otro lado las URIs externas, son aquellas que exponen el recurso al exterior. **El conjunto de buenas practicas recogido en este documento tiene aplicación únicamente las URIs externas**.  En concreto no tienen aplicación en la definición de URIs opacas de Wikibase, definidas en el [Modelo de Multilingüismo](https://github.com/HerculesCRUE/ib-asio-docs-/blob/master/04-Modelo_multiling%C3%BCismo/ASIO_Izertis_ModeloMultilinguismo.md), dado que son URIs internas.

Las URIs internas, en el momento de escribir el documento, están limitadas a las URIs generadas por Trellis y Wikibase. Si bien, dado el requisito adaptación a cualquier *triple store*, esto podría cambiar o ser ampliado. El diseño de estas URIs y su comportamiento vendrá determinado en muchos casos por la implementación del servidor linked data (por ejemplo Wikibase sigue un patrón propio, que no siempre sigue las recomendaciones de la LDP) por lo que sobre estas URIs internas en muchas ocasiones, no tendremos los suficientes grados de libertad, por lo que su diseño y comportamiento de las mismas dependerá de la implementación y por lo tanto esta fuera del alcance de este documento. 

Por otro lado las URIs externas o públicas, son aquellas que exponen el recurso al exterior, de forma uniforme, de acuerdo a los patrones de diseño recogidos por el documento de [Esquema de URIs Hércules](https://github.com/HerculesCRUE/ib-asio-docs-/blob/master/08-Esquema_de_URIs_H%C3%A9rcules/ASIO_Izertis_ArquitecturaDeURIs.md). Por motivos de claridad, cabe indicar, que para cada Backend SGI, la Factoría de URIs, es la encargada de realizar y mantener el mapeo entre las URIs externas y las URIs internas.

Para promover la reutilización por agentes internos o externos, es conveniente enumerar los principios a alto nivel que un URI debe cumplir: 

- **Sencillos:** cortos y nemotécnicos.
- **Manejables:** fáciles de administrar.
- **Persistentes:** ante operaciones tales como mover el recurso, eliminarlo o modificarlo.
- **Escalables:** flexibilidad en diseño y en horizonte temporal, con el fin de dar cabida tanto a los patrones de URIs derivados de los datos actuales, como de aquellos que puedan ser incorporados en un horizonte temporal de décadas.

## Definición de buenas prácticas

La definición de buenas prácticas para URIs públicas de Hércules se ha estructurado en 3 categorías:

- Buenas prácticas generales
- Buenas prácticas para identificación de recursos
- Buenas prácticas en comportamiento del servidor

### Buenas prácticas generales

Las buenas prácticas generales recogen factores globales que son de aplicación a cualquier tipo de URI.

1. **Usar URIs HTTP:** es un estándar de facto, y proporciona muchas ventajas como los enlaces, el almacenamiento en cache, la indexación en motores de búsqueda, etc. Las URIs permiten buscar y des-referenciar recursos. 
2. **Usar URIs lo mas cortos posibles**: siempre y cuando no se pierda el significado semántico del componente del URI (si lo tuviese).
3. **Usar URIs persistentes:** Una misma URI siempre ha de referenciar al mismo recurso. Es importante tener en cuenta además que la elección de un esquema de URIs no garantiza la persistencia de las URIs, sino que esto es un compromiso del propietario de la URI para mantener URIs constantes, aunque el contenido podría cambiar:
   - Establecer una política que permita el acceso a los recursos, aunque estos se hayan movido o hayan cambiado.
   - Usar servicios persistentes (PURL) para hacer las URIs persistente y desacoplarlas de su ubicación real.
   - No incluir elementos dinámicos, como por ejemplo token de sesión, información de estado o *query strings*.
   - Mantener un equilibrio en hacerlas legibles e incluir información descriptiva que probablemente cambie con el tiempo.
   - En caso de borrado, usar *410 Gone* en vez de *404 Not Found*.
4. **Reusar URIs existentes:** siempre que sea posible, es preferible reusar identificadores existentes, en lugar de generar nuevos, dado que, entre otros motivos, la trazabilidad y la persistencia pueden verse afectadas.
5. **Normalización de componentes de la URI**: con el fin de garantizar coherencia en la implementación del esquema, se recomienda aplicar la siguiente normativa para todos los componentes de las URIs, excluyendo la referencia:
   - Han de ser únicos (al menos en su dominio)
   - Han de ser lo mas cortos posibles, conservando su semántica y haciendo que sean representativos e intuitivos 
   - Evitar caracteres propios de el idioma, tales como acentos, o signos de puntuación.
   - Usar el guión medio (-) como separador de palabras.
   - Evitar abreviaturas, salvo que esta sea evidente.
6. **Política de mayúsculas y minúsculas:**
   - No usar políticas mixtas (distintas en distintas partes de la URI).
   - Usar minúsculas, salvo en el caso de los conceptos, donde se permite primera letra en mayúscula y resto en minúscula.

### Buenas practicas para identificación de recursos

Las buenas prácticas en representación de recursos definen las recomendaciones a la hora de identificar recursos concretos, en particular sobre el componente de ***referencia*** (código de identificación del recurso dentro de la URI), el formato y el idioma.

1. **Opacidad en referencias:** las propiedades del recurso enlazado no deben de ser inferibles de su referencia.
2. **Multilingüismo**: proporcionar mecanismos para definir que el mismo recurso tiene representaciones en varios idiomas y añadir metadatos para enlaces con otros idiomas: Enlazar documentos a otros el mismo documento en distintos idiomas, por ejemplo haciendo uso de la etiqueta *link:alternate* en HTML, o *foaf:page* y *rdfs:isDefinedBy* en RDF.
3. **Evitar auto incrementos**: de forma que el identificador sea determinista e idempotente, es decir una misma entidad, deberá asociarse siempre con una misma referencia y URI.
4. **Evitar números de versión:**  evitar el número de versión en los conceptos, por que este previsiblemente ira evolucionando, y por lo tanto afecta también al objetivo de persistencia.
5. **Evitar extensiones de archivo:** no mostrar la tecnología subyacente, en su lugar, para obtener una representación en un formato especifico del recurso, ha de usarse la negociación de contenidos, basada en las preferencias/capacidades del usuario.
   - Establecer formato e idioma por defecto, para los clientes que no lo especifiquen.
   - Permitir la negociación de codificación de caracteres con *Accept-Charset*
   - Debe de proporcionarse mecanismos para proporcionar distintas representaciones del mismo recurso por negociación de contenidos, al menos mediante el uso de algoritmos aplicables al contenido de la cabecera *Accept*.
   - Para clientes que "acepten cualquier tipo de contenido" (*Accept \*/\**) , es preferible usar el formato de contenido más ampliamente usado, preferiblemente mediante los factores de calidad.
   - Enlazar documentos a otros el mismo documento en distintos formatos, por ejemplo haciendo uso de la etiqueta *link:alternate* en HTML, o  foaf:page* y *rdfs:isDefinedBy* en RDF.
   - Proporcionar al menos una representación legible por máquina del recurso identificado por la URI mediante RDF.
6. **Buenas practicas asociadas a LDP y principios FAIR**:
   - Las URIs que definan propiedades deben de ser des-referenciables
   - Usar Vocabulario RDFS para describir propiedades
   - Incluir al menos una declaración *rdf:type* para cada recurso.
   - Definir relaciones de pertenencia a contenedor, por inferencia sobre el esquema de URIs.
   - Usar Barra de separación (/) al final de las URIs para representar contenedores.
   - Usar URI Hash (#) para identificar fragmentos de recursos.

### Buenas practicas en comportamiento del servidor

1. **Redirecciones:** código 3xx y cabecera *Location* con la ubicación del recurso.
   - 301: Movido permanentemente
   - 302: Encontrado
   - 307: Redireccionamiento temporal
2. **Proporcionar información útil a los indexadores:** proporcionar Información útil para agentes de indexación, definiendo política de indexación de sitio y local (por ejemplo, con la cabecera *meta* en HTML)
3. **Proporcionar información útil para cache:**  
   - Definiendo políticas de cache
   - Usando de forma correcta la cabecera *Date*
   - Enviando *Last-Modified* siempre que sea posible
   - Usando la cabecera *Cache-Control*, para establecer el comportamiento de los motores de cache con respecto al recurso
   - Evitando que la generación de contenido dinámico use siempre la fecha actual como fecha de última actualización.
   - Haciendo que las cabeceras de las peticiones GET y HEAD sean idénticas.
4. **Servir información junto al recurso de el tipo de contenido y codificación de caracteres**
   - Usar la cabecera *Content-typ*e para informar del formato del contenido servido
   - Informar del conjunto de caracteres usado al menos de una de las siguientes maneras:
     - Con el parámetro *charset* en la cabecera *Content-type*
     - Con meta-información en el documento servido
   - Permitir al administrador configurar información del conjunto de caracteres.