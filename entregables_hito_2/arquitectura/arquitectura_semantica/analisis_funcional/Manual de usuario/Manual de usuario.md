

![](./images/logos_feder.png)

# Manual de usuario



| Entregable     | Manual de usuario                                            |
| -------------- | ------------------------------------------------------------ |
| Fecha          | 25/05/2020                                                   |
| Proyecto       | [ASIO](https://www.um.es/web/hercules/proyectos/asio) (Arquitectura Semántica e Infraestructura Ontológica) en el marco de la iniciativa [Hércules](https://www.um.es/web/hercules/) para la Semántica de Datos de Investigación de Universidades que forma parte de [CRUE-TIC](http://www.crue.org/SitePages/ProyectoHercules.aspx) |
| Módulo         | Manual de usuario                                            |
| Tipo           | Documento                                                    |
| Objetivo       | Documento con un manual de usuario que busca brindar asistencia a los sujetos que usan el sistema. |
| Estado         | 100% para el hito 1                                          |
| Próximos pasos | Ampliar de forma acorde al avance del proyecto.              |



# ÍNDICE

[1. INTRODUCCIÓN](#introducción)

[2. Importadores](#importadores)

​	[2.1. Importador de Datasets](#importador-de-datasets)

​	[2.2. Importador de CVNs](#importador-de-CVNs)

[2. Trellis](#trellis)

[2. Wikibase](#wikibase)





Introducción
============

Ahora mismo la aplicación ASIO no dispone de aplicación web propia, en su lugar dispone de las herramientras Trellis y Wikibase. Por esta razón, para ejecutar los procesos de importación, se deberán lanzar procesos job del proyecto [dataset-importer](https://github.com/HerculesCRUE/ib-dataset-importer) en el servidor. Estos servicios, inicializan la lectura de XML con los datasets o las llamadas a los servicios CVNs, y automáticamente, se van ejecutando los distintos procesos de la aplicación hasta guardarlos en Wikibase y Trellis.



![arquitectura](./images/arquitectura-preliminar.jpg)



A Trellis se importan todos los datos importados, tanto de los datasets como de los CVNs. Además de esto, se han creado unos [POJOs](../Pojos Hito 1/pojos.md) que se guardan tanto con Trellis como con Wikibase. Estos POJOs nos dan la respuesta a la pregunta de competencia "**Como investigador y personal no investigador de la universidad requiero obtener un listado de los proyectos adjudicados/desarrollados de un centro/estructura de investigación**"



![arquitectura](./images/pojos.png)





Importadores
===================

Se dispone de dos importadores diferentes, unos para jobs y otro para CVNs. Para ambos hay que lanzar un proceso, diferente para cada uno, desde el servidor, en el lugar en el que se encuentre el fichero .jar del proyecto dataset-importer. Para más información, mirar el documento [README.md](https://github.com/HerculesCRUE/ib-dataset-importer/blob/master/README.md) del proyecto.



Al lanzar cualquiera de los dos procesos, se inicializa la importación tanto en Trellis como en Wikibase, ambos procesos pueden llevar algo de tiempo por lo que los resultados de la importación pueden tardar en verse en ambos.



Importador de Datasets
---------------------------

El importador de Datasets, importa los datos a partir de los ficheros XML proporcionados por la UM. El proceso que hay que lanzar para iniciar el procesado de estos ficheros es: 

```
java -jar -Dspring.batch.job.names=importDataSetJob {jar-name}.jar
```



## Importador de CVNs

El importador de CVNs, importa los datos a partir de los servicios mockeados proporcionados por la UM. El proceso que hay que lanzar para iniciar el procesado de estos ficheros es: 

```
java -jar -Dspring.batch.job.names=importCvnJob {jar-name}.jar
```



# Trellis

Para acceder a la máquina de Trellis se necesita usuario y contraseña de la UM y se accede a través de la URL:

http://herc-iz-front-desa.atica.um.es/







Al acceder a Trellis se nos muestra una pantalla con el listado de datos que tenemos en el Triplestore, como se puede ver en la siguiente imagen:

![arquitectura](./images/listado-trellis.png)



Al pulsar sobre cualquiera de las entradas, se muestra el detalle:

![arquitectura](./images/detalle-trellis.png)



# Wikibase

A través de la plataforma de Wikibase podemos acceder también a los datos importados:
http://herc-iz-front-desa.atica.um.es:8181/



Desde la opción de "Cambios Recientes" se pueden consultar los últimos cambios en los datos y acceder a ellos.

![arquitectura](./images/cambios-wikibase.png)



Se pueden ver los detalles pulsando sobre estos datos, o sobre los resultados de una consulta SparQL.

![arquitectura](./images/detalles-wikibase.png)



A través de las consultas SparQL también se podrán obtener los datos que nos interesen.

![arquitectura](./images/consulta-wikibase.png)



### Ejemplos de consultas de Wikibase:

```
#Proyectos y su grupo de investigación
SELECT ?nombreProyecto ?descripcionGrupoInvestigacion
WHERE
{
   ?proyecto wdt:P3 "http://hercules.org/um/es-ES/rec/Proyecto/".
   OPTIONAL { ?proyecto wdt:P13/wdt:P4 ?descripcionGrupoInvestigacion }
   ?proyecto wdt:P11 ?nombreProyecto.
}
```

```
#Proyectos con y sin grupo de investigacion
SELECT ?proyectoLabel ?grupoInvestigacionLabel
WHERE
{
   ?proyecto wdt:P3 "http://hercules.org/um/es-ES/rec/Proyecto/".
   OPTIONAL { ?proyecto wdt:P13 ?grupoInvestigacion }
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE]". }
}
```

```
#Número de proyectos por grupo de investigacion (incluye desconocidos)
#defaultView:BubbleChart
SELECT ?grupoInvestigacion (COUNT(?proyecto) AS ?count)
WHERE
{
   ?proyecto wdt:P3 "http://hercules.org/um/es-ES/rec/Proyecto/";
   OPTIONAL { ?proyecto wdt:P13/wdt:P4 ?grupoInvestigacion }.
   BIND(IF(BOUND(?grupoInvestigacion),?grupoInvestigacion,"Desconocido") AS ?grupoInvestigacion).
}
GROUP BY ?grupoInvestigacion
```

```
#Proyectos con grupo de investigacion
SELECT ?proyectoLabel ?grupoInvestigacionLabel
WHERE
{
   ?proyecto wdt:P3 "http://hercules.org/um/es-ES/rec/Proyecto/".
   ?proyecto wdt:P13 ?grupoInvestigacion
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE]". }
}
```





Para más información sobre como manejar Wikibase se puede consultar la guía de [Wikidata](https://www.wikidata.org/wiki/Help:Contents).