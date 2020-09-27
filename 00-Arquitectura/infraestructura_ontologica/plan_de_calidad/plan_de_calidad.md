![](./resources/logos_feder.png)

Plan de calidad de Infraestructura Ontológica (Borrador) 
========================================================

Proyecto HERCULES -- Universidad de Murcia

Especificación para fase ASIO -- Arquitectura Semántica e
Infraestructura Ontológica

Desarrollado por: WESO-Izertis

Fecha: 14-01-2019

Introducción
------------

En este documento se describirá el Plan de Calidad para la
Infraestructura Ontológica que forma parte de la primera fase del
proyecto HERCULES -- Universidad de Murcia.

Contenidos
----------

Contenido {#contenido .TOC-Heading}
=========

[Introducción 1](#introducción)

[Contenidos 1](#contenidos)

[Desarrollo basado en pruebas para Ontologías
1](#desarrollo-basado-en-pruebas-para-ontologías)

[Librería de Shapes 2](#librería-de-shapes)

[Infraestructura para Shapes 2](#infraestructura-para-shapes)

[Módulos en desarrollo 3](#módulos-en-desarrollo)

[Módulos que se van a desarrollar 5](#módulos-que-se-van-a-desarrollar)

Desarrollo basado en pruebas para Ontologías
--------------------------------------------

La infraestructura ontológica que se desarrolle se realizará teniendo en
cuenta la aplicación de técnicas que han tenido éxito en el ámbito de la
ingeniería del software al desarrollo de ontologías. En concreto se
plantea la creación de una metodología de desarrollo de ontologías en la
línea del Test-Driven-Development que permita disponer de 3 partes:

-   Ontologías

-   Datos de prueba

-   Librería de shapes

En el desarrollo de cada ontología se incorporarán unos datos de prueba
sencillos que permitan identificar elementos del modelo junto con shapes
pre- y post- inferencia que chequearán que los grafos resultantes se
ajusten a las restricciones definidas.

![](resources/esquema.png){width="5.125in" height="2.5759569116360455in"}

Figura 1. Esquema de la infraestructura ontológica

El objetivo es que cuando las ontologías sean editadas y la
actualización sea registrada en el sistema de control de versiones, se
puedan llevar a cabo validaciones de los contenidos de los grafos
resultantes de combinar las ontologías con los datos de prueba contra
las *shapes* identificadas para detectar errores. Estas *shapes* podrán
definirse para los grafos antes de activar la inferencia y para los
grafos resultantes de activar la inferencia, permitiendo validar también
las capacidades del sistema de inferencia.

Cabe destacar que el proyecto *Gene Ontology* ha comenzado a utilizar
esta metodología basada en pruebas mediante Shapes:
<https://github.com/geneontology/go-shapes>.

Actualmente se están desarrollando las herramientas que permitan ofrecer
la infraestructura necesaria para desplegar dichas tecnologías.

Librería de Shapes
------------------

Una componente esencial para la calidad de los datos será la definición
del esquema de entidades mediante Shapes. La librería de Shapes
permitirá sincronizar las clases del modelo de dominio en Java con las
entidades identificadas mediante Shapes. Para llevar a cabo dicha
sincronización será necesario disponer de herramientas que permitan
editar fácilmente las shapes así como aplicar la validación en
diferentes contextos. Algunas de estas herramientas habían sido
desarrolladas por el equipo WESO pero no estaban siendo aplicadas a
entornos de producción por lo que están siendo mejoradas o adaptadas
para que puedan ser utilizadas en este tipo de entornos.

![](resources/sincronizacion.png){width="5.905555555555556in"
height="1.82211176727909in"}

Figura 2. Sincronización de la librería de Shapes y el modelo de dominio

Infraestructura para Shapes
---------------------------

A continuación, se describen los principales repositorios que se están
desarrollando para proporcionar una infraestructura que permita trabajar
con Shape Expressions en los diferentes contextos que se requerirán en
el proyecto.

![](resources/repositorios.png){width="5.905555555555556in"
height="3.886111111111111in"}

Figura 3. Principales repositorios relativos a la gestión de Shapes

### Módulos en desarrollo

Los siguientes módulos ya están siendo desarrollados en el presente
proyecto. Todos los módulos están desarrollados con código abierto en su
correspondiente repositorio github y disponen de licencia de código
abierto.

#### RDFShape-client

Este es el código del cliente que está desplegado en
<http://rdfshape.weso.es>. Permite jugar con RDF, obteniendo información
sobre RDF, realizando consultas SPARQL a datos RDF, validando datos RDF
mediante ShEx y SHACL, etc. Se trata de una aplicación basada en
componentes React.

Repositorio: <https://github.com/weso/rdfshape-client>

#### Wikishape

Este es el código del cliente que está desplegado en
<http://wikishape.weso.es>. Permite obtener información sobre entidades
y propiedades en wikidata. También permite validar entidades mediante
esquemas de entidades realizados en ShEx. Se trata de una aplicación
basada en componentes React.

Repositorio: <https://github.com/weso/wikishape>

#### ShapeComponents

Contiene una serie de componentes React para manipular Shapes.

Repositorio: <https://github.com/weso/shapeComponents>

#### SHaclEX

Define un interfaz común para validar RDF mediante esquemas que pueden
ser ShEx ó SHACL. También contiene código para convertir entre ShEx y
SHACL.

Repositorio: <https://github.com/weso/shaclex>

#### UMLSHaclEX

Permite representar esquemas ShEx y SHACL mediante diagramas UML.

Repositorio: <https://github.com/weso/umlShaclex>

#### RDFShape

Contiene el código que implementa el servidor para las acciones
requeridas por RDFShape-Client y Wikishape. Define un API con métodos
para obtener información sobre datos RDF, realizar consultas SPARQL y
validar mediante ShEx y SHACL. Se trata de una aplicación realizada en
Scala que utiliza el framework http4s (<https://http4s.org/>).

Repositorio: <https://github.com/weso/rdfshape>

#### Utils

Contiene una serie de utilidades comunes en Scala de propósito general
que no dependen de Shapes y que pueden reutilizarse en varios contextos.

Repositorio: <https://github.com/weso/utils>

#### SHACL-s

Contiene una implementación de SHACL en Scala. Esta implementación se
basa en transformar las restricciones de SHACL en una sintaxis abstracta
y utiliza un modelo de interpretación basado en conceptos de
programación puramente funcional.

Repositorio: <https://github.com/weso/shacl-s>

#### ShEx-s

Contiene una implementación de ShEx en Scala. La implementación utiliza
conceptos de programación puramente funcional y se basa en la librería
Cats de Scala.

Repositorio: <https://github.com/weso/shex-s>

#### SRDF 

Define un interfaz genérico para trabajar con RDF. También contiene 2
implementaciones de dicho interfaz, una para la librería Apache Jena y
otra para la librería RDF4j. Dicho interfaz también podrá ser
implementado por otras librerías lo que facilitará la utilización de las
librerías de validación en otros contextos. En concreto, se espera
llevar a cabo una implementación en ScalaJs que permita incluso la
utilización de los validadores en entornos Javascript.

Repositorio: <https://github.com/weso/srdf>

#### ShEx-Author 

Editor visual de Shape Expressions. Se está desarrollando una prueba de
concepto de un editor visual para Shape Expressions que permita la
creación de Shapes por expertos del dominio que prefieran utilizar este
tipo de herramientas antes que un editor de texto más tradicional y que
puede ser preferido por personas más cercana al ámbito informático.

Repositorio: <https://github.com/weso/shex-author>

#### YaShE

Editor de Shape Expressions con sintaxis coloreada, autocompletado,
sugerencias de edición, etc. El código se realizó a partir del editor
SPARQL YasQe (<http://yasqe.yasgui.org/>) que está integrado en el
Wikidata Query Service y en el editor de consultas YasGUI entre otros.
De la misma forma, YaShE está pendiente de que sea integrado en Wikibase
para que pueda utilizarse como editor de los esquemas de entidades.

Repositorio: <https://github.com/weso/YASHE>

### Módulos que se van a desarrollar

A continuación, se indican varios módulos que han sido identificados
como necesarios para el proyecto aunque todavía no han comenzado a
desarrollarse. Se espera comenzar a desarrollar para las siguientes
etapas.

#### ProtegeShEx 

Plugin de Protégé para ShEx. Actualmente se está estudiando la
arquitectura para desarrollar un *plugin* para el editor de ontologías
Protégé (<https://protege.stanford.edu/>) que permita realizar
validaciones de los elementos de la ontología mediante Shape
Expressions. Desde el Centro para la Investigación en Informática
Biomédica de la Universidad de Stanford ya han mostrado su interés en
disponer de dicho *plugin* y se considera que el mismo puede favorecer
la adopción de ShEx por parte de ingenieros ontológicos acostumbrados a
utilizar dicho editor de ontologías.

Repositorio: <https://github.com/weso/protegeShEx>

#### ShExLite

Se prevé implementar un subconjunto de ShEx que permita la creación de
Shapes estructurales más sencillas que las que permite el lenguaje ShEx
y que facilite específicamente la importación de Shapes a partir de
formatos tabulares como hojas de cálculo. Actualmente estamos
colaborando con Dublin Core a través de Tom Baker en la identificación
de dicho subconjunto. Un primer esquema de la gramática puede verse
aquí: <https://dcmi.github.io/dcap/shex_lite/micro-spec.html>

#### ShEx2Code

Se prevé implementar un generador de código a partir de esquemas ShEx.
El sistema generará en principio clases POJO de Java, aunque se tratará
de que pueda generar clases en otros lenguajes.
