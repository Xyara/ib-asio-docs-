

| Entregable     | Red de ontologías Hércules                                   |
| -------------- | ------------------------------------------------------------ |
| Fecha          | 25/05/2020                                                   |
| Proyecto       | [ASIO](https://www.um.es/web/hercules/proyectos/asio) (Arquitectura Semántica e Infraestructura Ontológica) en el marco de la iniciativa [Hércules](https://www.um.es/web/hercules/) para la Semántica de Datos de Investigación de Universidades que forma parte de [CRUE-TIC](http://www.crue.org/SitePages/ProyectoHercules.aspx) |
| Módulo         | Infraestructura Ontológica                                   |
| Tipo           | Archivo README; la documentación se encuentra en el archivo "ASIO_Izertis_ConversionDeRecursosAOWL.md" en la carpeta superior. |
| Objetivo       | Pequeño documento de README explicando el contenido de la carpeta. |
| Estado         | **100%**. El número de módulos verticales presentados en este hito 1 ha sido satisfecho. |
| Próximos pasos | Con el fin de desarrollar futuros módulos verticales a entregar en el hito 2 se analizará la idoneidad de las herramientas listadas en el entregable. |

# README

En esta carpeta se recoge un número de archivos en formato `.xls` que funcionan como input de los programas en formato `.tabels`, desarrollados para convertir esos datos tabulares a formato RDF.

Cabe decir que el input original de esos ficheros `xls` en ningún caso fue tabular en origen, procedía en la mayor de los casos de PDFs o de tablas en `HTML`, por lo que muchas veces se tuvo que llevar a cabo un preprocesado utilizando importadores de datos de programas de hojas de cálculos diversos (Excel, Numbers, LibreOffice) o en casos complejos [Open Refine](https://openrefine.org/).

Cada programa `tabels` está escrito para recorrer las columnas y las filas de los archivos `xls`, recoger esos datos tabulares y crear recursos en RDF que integrarán las tripletas del fichero de salida, que se encuentra alojado en los módulos verticales de la ontología.

En la mayoría de casos, esas tripletas siguen el modelo de [SKOS-Core](https://www.w3.org/2004/02/skos/core), ya que los datos de partida muestran una estructura jerárquica de tipo tesauro, como es el caso de las divisiones políticas, las áreas científicas/temáticas o, incluso, las subdivisiones de las universidades.

Además, se ha llevado a cabo un esfuerzo de traducción/localización de las etiquetas (*labels*) para explotar en profundidad las posibilidades de etiquetado multilingüe que proporciona SKOS.

La sintaxis de un programa tabels procede de la siguiente manera:

1. Se establece una 'identificación' de la fila de cabecera de cada columna. Por ejemplo, para las subdivisiones de Andorra:

```turtle
FOR ?rowId IN rows FILTER get-row(?rowId)
    MATCH [?regionCode,?region,?ISOCode,?FIPSCode,?en,?es,?fr,?pt,?oc,?CPCode,?HASCCode,?DEANDCode,?ipaca] IN horizontal 
```

donde cada segmento iniciado por ? define lo que hay en la columna en cuestión. Por ejemplo, "?regionCode" encabeza el listado de códigos ISO de las subdivisiones de primer nivel de Andorra, mientras que "?region" las etiquetas por defecto, en este caso en lengua catalana, la oficial en Andorra, de cada subdivisión.

2. Se proporciona una 'definición' de recursos. Por ejemplo:

LET ?regionResource = resource(concat("AD_DIVISION_LEVEL_1_",replace(?regionCode,"-","_")),asioModules)

```turtle
LET ?regionResource = resource(concat("AD_DIVISION_LEVEL_1_",replace(?regionCode,"-","_")),asioModules)
```

El recurso de cada subdivisión se crear a partir del 'regionCode' y recibe una URI "AD_DIVISION_LEVEL_1_" que se completa con ese código, a la cual se le asignan las etiquetas multilingües.

Más adelante se van definiendo los CONSTRUCTS específicos de cada dataset, que van estableciendo las tripletas, por poner solo un breve ejemplo:



```turtle
CONSTRUCT {
  ?regionResource a skos:Concept;
                  rdfs:label ?region ;
                  skos:prefLabel ?region ; 
                  skos:prefLabel ?caLabel ;
                  skos:prefLabel ?enLabel ;
                  skos:prefLabel ?esLabel ;
                  skos:prefLabel ?frLabel ;
                  skos:prefLabel ?ptLabel ;
                  skos:prefLabel ?ocLabel ;
                  skos:prefLabel ?ipacaLabel ;
                  ontolex:phoneticRep ?ipacaLabel ;
                  skos:inScheme asioModules:ADParishList;
                  asio:hasCode ?regionCodeResource ;
                  asio:hasCode ?regionFIPSCodeResource ;
                  asio:hasCode ?regionHASCCodeResource ;
                  asio:hasCode ?regionCPCodeResource ;
                  asio:hasCode ?regionDEANDCodeResource ;
                  skos:notation ?regionCode ;
                  skos:broader ?ISOResource .
}
```



El recurso región se define como un `skos:Concept` que tiene varias etiquetas preferentes (`skos:prefLabel`), una notación (`skos:notation`) o una propiedad conceptual (`skos:broader`) que nos indica que esta región concreta de Andorra tiene un nivel conceptual superior que es el propio país Andorra. Además, hay otros enlaces a otras tripletas ya fuera de SKOS, como por ejemplo `asio:hasCode`, que establece los distintos códigos definidos para esa región de Andorra.

Otros CONSTRUCTS adscriben los conceptos generados a esquemas de conceptos (`skos:conceptScheme`) especificados dentro de los módulos verticales de las ontologías.

El resto de programas incluídos en esta carpeta siguen el mismo modelo de definición de datos tabulares y programas de procesamiento.