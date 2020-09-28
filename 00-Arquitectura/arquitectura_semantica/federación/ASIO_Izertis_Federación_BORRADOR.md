![](./images/logos_feder.png)

| Entregable     | Arquitectura Semántica - Federación de Consultas             |
| -------------- | ------------------------------------------------------------ |
| Fecha          | 16/09/2020                                                   |
| Proyecto       | [ASIO](https://www.um.es/web/hercules/proyectos/asio) (Arquitectura Semántica e Infraestructura Ontológica) en el marco de la iniciativa [Hércules](https://www.um.es/web/hercules/) para la Semántica de Datos de Investigación de Universidades que forma parte de [CRUE-TIC](https://tic.crue.org/hercules/) |
| Módulo         | Arquitectura Semántica                                       |
| Tipo           | Documento                                                    |
| Objetivo       | Este documento recoge el análisis de alternativas para la federación de consultas sobre una arquitectura de nodos distribuidos en la red HERCULES. |
| Estado         | **15%** Borrador provisional.                                |
| Próximos pasos | Decidir arquitectura final y completar diseño.               |

# Federación de consultas

El diseño de la arquitectura de federación de consultas pretende dar respuesta al requisito de respuesta conjunta de la red HERCULES ante una consulta sobre el sistema a nivel global.

A alto nivel, el planteamiento propuesto es la gestión de consultas federadas desde el nodo maestro de la red, delegando de forma paralela la consulta en el resto de nodos de forma paralela:

![](./images/ASIO_Izertis_Federación.png)

## Alternativas descartadas

Este documento asume que dicha federación se realizará a nivel de lectura (consultas), en contrapartida a la sincronización de datos durante la importación (replicación de datos). La sincronización de datos en todos los nodos queda descartada por los siguientes motivos:

- Mayor complejidad del módulo de importación de datos.
- Mayor coste de procesamiento durante la importación.
- Mayor coste de almacenamiento de la información.
- Restricciones de privacidad de datos entre nodos.

## Definición de subsistemas

El módulo de federación de consultas se subdivide a su vez en tres subsistemas clave:

1. **CONSULTA**: encargado de ejecutar la consulta de forma paralela en todos los nodos de la red y optimización del proceso.
2. **IDENTIFICACIÓN**: se apoya en la librería de descubrimiento para poder identificar entidades repetidas o similares.
3. **AGREGACIÓN**: una vez recibidos los resultados e identificadas las similitudes, se encargaría de unificar los datos de entidades equivalentes obtenidas de diferentes nodos.

### Consulta

Dado el volumen de información almacenada sería recomendable disponer de una capa intermedia que permitiese realizar consultas de forma más eficiente, en lugar de realizar la consulta desde el API de SPARQL estándar. 

Se descarta el uso de la federación provista por SPARQL por los siguientes motivos:

- El proceso de consulta federada no es robusto ante fallos de la red de endpoints adscritos.
- El proceso de agregación de datos es muy limitado y queda restringido a las funcionalidades expuestas por el propio lenguaje de consulta.
- La escalabilidad del proceso es limitada para grandes volúmenes de información.
- Se pierde control sobre el proceso y no permite obtener ventajas del modelo de datos común y la librería de descubrimiento.

### Identificación

Este subsistema debería hacer uso de la Librería de descubrimiento, aún pendiente de definir dicha integración.

### Agregación

La versión más sencilla de la federación ofrecería los resultados de forma directa, sin agregar. En caso de duplicados idénticos, se informaría de todos los nodos que disponen de la entidad, sin repetirla. En caso de resultados similares (misma entidad, con diferente contenido) se listarías todas las variantes y su procedencia.

Esta versión simplificada podría ser de interés para poder analizar de forma explícita el contenido ofrecido por cada nodo, si bien sería muy recomendable poder contar con un módulo de unificación (*merge*) de entidades, reutilizado los servicios ya desarrollados en el módulo de importación de datos, en caso de existir.

Las consultas federadas sin agregación también son de utilidad para la Librería de descubrimiento con el objetivo de identificar y definir enlaces entre entidades albergadas en diferentes nodos de la red durante el proceso de importación. 

## Referencias. 

[]

