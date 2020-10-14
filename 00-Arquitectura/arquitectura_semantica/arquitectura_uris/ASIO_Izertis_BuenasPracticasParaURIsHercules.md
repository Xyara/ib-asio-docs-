![](./images/logos_feder.png)

# Recomendaciones URIs

- Evitar declarar el nombre del proyecto u organización que genera la URI si no aporta nada al significado de la misma
- Evitar números de versión para identificar conceptos. En caso de identificar entidades que estén sujetas a diferentes versiones, se puede utilizar una URI genérica sin número de versión que identifica la entidad, y desde ella, redirigir a una URI que incluya la última versión. 
- Reusar identificadores existentes. Para los recursos que tienen un identificador único, se puede reusar dicho identificador en el campo {referencia} de la URI
- Evitar el uso de auto-incrementos automáticos al generar URIs únicas
- Evitar el uso de *query-strings* (ejemplo, ?parametro=valor) que se pueden utilizar para buscar valores en una base de datos y a menudo dependen de una implementación concreta.
- Evitar extensiones de ficheros, especialmente las que indican una tecnología concreta como puede ser .jsp). 
- Diseñar las URIs para múltiples formatos. Mediante negociación de contenido, la misma URI genérica puede redirigir a URIs específicas en formatos concretos.
- Enlazar representaciones múltiples. En HTML puede utilizarse un elemento <link> con el atributo rel ó alternate apuntando a otra representación. En RDF, puede utilizarse dct:hasFormat
- Utilizar redirecciones 303 para las URIs que identifican conceptos del mundo real.
- Utilizar servicios dedicados para generar URIs persistentes. Algunos servicios pueden ser: purl.org, w3id.org, identifiers.org, etc.
- Las URIs que definan propiedades deben ser dereferenciables. Al acceder al contenido de las URIs de propiedades, al menos se debería obtener un vocabulario RDFS describiendo dicha propiedad.
- Se recomienda que la representación RDF de los recursos contenga al menos una declaración rdf:type
- Representar relaciones de pertenencia a un contenedor mediante URIs jerárquicas. Por ejemplo, si existe un contenedor para representar una institución que alberga varios grupos de investigación se utilizarán URIs como `http://example.org/institucion/` para representar la institución y: `http://example.org/institucion/grupo1` para representar a un grupo de dicha institución.
- Utilizar una barra de separación al final de las URIs que representan contenedores. Por ejemplo, es preferible `http://example.org/contenedor/` a `http://example.org/contenedor`, especialmente al utilizar URIs relativas. 
- Utilizar fragmentos como identificadores de recursos. Un fragmento en una URI se introduce mediante el símbolo # y se denominan URIs hash[[1\]](#_ftn1). Cuando un cliente solicita una URI con un fragmento, el protocolo http descarta el fragmento y hace la solicitud a la servidor utilizando el resto de la URI. El resultado es que la URI original no puede utilizarse para identificar un documento Web concreto y puede utilizarse para identificar recursos que no correspondan a documentos, como personas o conceptos abstractos. Por ejemplo, la URI: `http://example.org/contenedor#id23` podría utilizarse para identificar el recurso #id23 que podría identificar recursos como personas, objetos, etc. 
- Usar purl para apuntar a direcciones url fijas.

[[1\]](#_ftnref1) [*https://www.w3.org/TR/cooluris/#hashuri*](https://www.w3.org/TR/cooluris/#hashuri)