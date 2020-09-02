![](./images/logos_feder.png)

## Apache Jena

Es un Framework de código abierto para la web semántica.
Proporciona una API para leer y escribir grafos RDF.

En esencia Jena almacena la información y ofrece interfaces para realizar cualquier operación CRUD sobre los datos, ofreciendo a su vez, funcionalidad para publicar los datos, y exponerlos mediante su API, o su SPARQL Endpoint


**Características generales:**

- **API RDF:** Proporciona un API para escribir/leer RDFs en la mayoría de formatos estándar (RDF/XML, Turtle….). Las tripletas pueden almacenarse en memoria o en base de datos.
- **ARQ Engine**: Motor que da soporte al lenguaje de queries que soporta SPARQL.
- **TDB Engine**: Motor de almacenamiento de datos (triple store) de alto rendimiento. Despliegue en un único nodo. El triple store puede ser consultado desde línea de comandos o el API de Jena.
- **Apache Jena Fuseki**: Es un servidor de datos RDFL, que soporta queries SPARQL para obtención de datos y Update. Se integra con TDB para proporcionar una capa robusta de persistencia con soporte a transacciones. 
- **Motor de inferencias**: Proporciona motor de inferencias propio y tiene soporte con **[Pellet reasoner](https://en.wikipedia.org/wiki/Web_Ontology_Language)**
- **API OWL**


**Arquitectura:**

![alt Arquitectura Apache Jena](https://jena.apache.org/images/jena-architecture.png "Arquitectura Apache Jena")

**Seguridad**

Apache Jena, gestiona la seguridad mediante [Apache Shiro](http://shiro.apache.org/), que restringe el acceso a los datos por medio de los [Jena Pemissions](https://jena.apache.org/documentation/permissions/)..

La capa de permisos Jena puede configurarse para ofrecer la granularidad deseada, bien a nivel de grafos o tripletas específicos.

**Ventajas aplicables proyecto ASIO**

* Open Source
* Extensa API Java, que permite interactuar de una forma sencilla con todos los componentes de la plataforma, que probablemente sean desarrollados con lenguajes basados en JVM.
* Autentificación y Autorización, con una granularidad en apariencia suficiente para los requisitos del proyecto
* Arquitectura granular, donde muchos módulos pueden ser mapeados con componentes de la arquitectura a desarrollar o formar parte de ella, por ejemplo:
	* Parsers and writers: Probablemente pueda usarse como soporte en  los "importadores".
	* Apache Jena: La librería java puede ser de uso común en todos aquellos módulos que tengan relación con el dominio o el triple store, tales como  el modulo de "Sistema de Gestión",  "Procesador de eventos", y/o los "importadores".
	* Apache Shiro, Jena Permissions
	* Alguna o todas las capas de frontend, podría ser soportada total o parcialmente con Fuseki, tales como Servidor de Linked Data, API REST.
	* TDB como Triple Store
	* La librería Apache Jena, proporciona también abstracciones para el mapeo a RDFs a partir de una clase de dominio o POJO.
 	* Soporte con Shacl, para la validación por medio de Shapes
	* Motores de inferencia nativos
* Es un ecosistema integral, que pretende ser una solución completa y robusta, pero que siendo modular, con interfaces abiertas, cualquier componente puede en principio ser sustituido.



## Virtuoso

Es una plataforma que intenta ofrecer una solución segura y robusta para la creación /gestión de las redes semánticas.

Ofrece una plataforma con:
* Frontal web
* Almacenamiento XML nativo
* Middleware para acceso a datos (XML, SOAP, JDBC...)


![alt Arquitectura Virtuoso](https://miro.medium.com/max/813/1*Kj-7AXQZpYoeGJiovCeP8g.jpeg "Arquitectura Virtuoso")

**Características generales:**

- **Abstracción de datos:** Permite construir grafos de conocimiento sobre APIs expuestas tales como HTTP, ODBC, ADO.NET, OLE DB, XMLA...
- **Granularidad del dato**: Permite la segmentación de datos, según el dominio de negocio, en empresa, departamento, grupo de trabajo, proyecto...
- **Gran rendimiento  escalabilidad**: Por medio de índices y cachés.
- **Incorpora API**: Con soporte a SOAP y Rest.
- **Servidor Web**: Despliega servidor Web, que puede ampliarse mediante paginas escritas con VSP (Virtuoso Web Lenguage), PHP, ASP .NET u otros... , con soporte a protocolos de seguridad tales como WS-Security




**Arquitectura:**


![alt Arquitectura Virtuoso](http://docs.openlinksw.com/virtuoso/conceptarchitecture/images/varch32.jpg "Arquitectura Virtuoso")

Como se puede ver en la imagen la arquitectura tiende a ser monolítica, y al no ser Open Source las interfaces entre componentes, probablemente no sean accesibles, por lo que se dificulta el hecho de extender una cierta funcionalidad de un componente dado.

**Seguridad**

Virtuoso proporciona la [implementación] de una matriz de seguridad para grafos, que se describe en el siguiente [enlace](http://vos.openlinksw.com/owiki/wiki/VOS/VirtRDFGraphsSecurity) de forma similar a como se establecen permisos por tabla en SQL.


**Ventajas aplicables proyecto ASIO**

* Hasta la versión 7 Open Source.
* El conjunto de herramientas integradas, (mapeadores a fuentes de datos, motor de procedimientos almacenados.... ), proporcionan funcionalidades en principio aplicables al proyecto. 
* Solución a alguna de las tareas 
* Proporciona Autentificación y Autorización, con una granularidad en apariencia suficiente para los requisitos del proyecto
* Posee motores de inferencia, que han sido nombrados en el pliego como un requisito, y actualmente no están completamente resueltos en el documento de arquitectura.
* Es un ecosistema integral, que pretende ser una solución completa y robusta.

**Desventajas identificadas en el proyecto ASIO**

* Dejar de ser Open Source a partir de la versión 8. 
* Usar la versión de pago supondría un coste adicional al proyecto. 
* El conjunto de herramientas proporcionado, en principio proporciona un marco de trabajo poco abierto y flexible, lo que dificulta la integración con desarrollos propios de software. 


## Apache Jena vs Virtuoso para proyecto ASIO

En principio, tal como se describe en el pliego, el proyecto tiene como finalidad, ofrecer soporte a las universidades españolas, y quizás europeas para la gestión de la investigación.

Tal como se ha diseñado, existirá un Backend SGI, para cada universidad, comenzado por el piloto sobre la Universidad de Murcia, pero teniendo que ser extensible la solución al conjunto de universidades.

Debido a su diseño más modular y a sus interfaces mas abiertas, se considera que para el presente proyecto, Apache Jena ofrece una solución más flexible, y mas fácil de integrar de acuerdo el diseño de arquitectura propuesto para el proyecto.

La variabilidad en las fuentes y los formatos de datos,  de las posibles universidades, crea cierta incertidumbre en el caso de Virtuoso, ya que probablemente, en caso de no disponer del conector apropiado, será mas difícil integrarlo en el sistema.

Dado que Virtuoso, presenta características mas orientadas a la explotación comercial como un producto industrializado, siendo una herramienta  orientada a la gestión por medio de configuración, con un diseño bastante monolítico y por lo tanto con una capacidad menor de integración con otras piezas de software, consideramos que será más difícil de integrar, y menos reutilizable.

Sin embargo, tanto el API de Apache Jena, que permite operaciones **atómicas** sobre conjuntos individuales de datos, como el diseño orientado a microservicios, con interfaces abiertas que presenta la arquitectura de Apache Jena, nos da la posibilidad de introducir microservicios propios,  que de esa forma interactúen con los componentes estándar, siendo posible de esta forma, ampliar cualquier lógica de negocio que fuese necesaria.

Teniendo licencia de código abierto de Apache, usa como estándar el conjunto de librerías y frameworks que pueden facilitar ciertos procesos de negocio, como es el caso de integración con Apache Shiro para autorización/autentificación, o validación con Shacl para validación.

Otra motivación es la mayor comunidad de usuarios de Apache Jena, hace que la presencia de foros y documentación, pueda facilitar el uso de la herramienta

En definitiva, por flexibilidad y facilidad de integración con otros sistemas, se recomienda el uso de Apache Jena sobre Virtuoso.


## Otros triples Stores


<table class="wikitable sortable jquery-tablesorter">

<thead><tr>
<th class="headerSort" tabindex="0" role="columnheader button" title="Sort ascending">Name</th>
<th class="headerSort" tabindex="0" role="columnheader button" title="Sort ascending">Developed in language</th>
<th class="headerSort" tabindex="0" role="columnheader button" title="Sort ascending">Latest Version</th>
<th class="headerSort" tabindex="0" role="columnheader button" title="Sort ascending">Latest Release Date</th>
<th class="headerSort" tabindex="0" role="columnheader button" title="Sort ascending">Licence
</th></tr></thead><tbody>
<tr>
<td>3store</td>
<td><a href="https://en.wikipedia.org/wiki/C_(programming_language)" title="C (programming language)">C</a></td>
<td>3.0.17<sup id="cite_ref-3" class="reference"><a href="#cite_note-3">[3]</a></sup></td>
<td>2006-07-17</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/GNU_General_Public_License" title="GNU General Public License">GNU GPL</a>
</td></tr>
<tr>
<td>Akutan</td>
<td>Go</td>
<td style="background: #ececec; color: #2C2C2C; font-size: smaller; vertical-align: middle; text-align: center;" class="unknown table-unknown">?</td>
<td style="background: #ececec; color: #2C2C2C; font-size: smaller; vertical-align: middle; text-align: center;" class="unknown table-unknown">?</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/Apache_2_License" class="mw-redirect" title="Apache 2 License">Apache 2</a>
</td></tr>
<tr>
<td><a href="https://en.wikipedia.org/wiki/AllegroGraph" title="AllegroGraph">AllegroGraph</a></td>
<td><a href="https://en.wikipedia.org/wiki/Common_Lisp" title="Common Lisp">Common Lisp</a></td>
<td>6.6.0<sup id="cite_ref-4" class="reference"><a href="#cite_note-4">[4]</a></sup></td>
<td>2019-08-12</td>
<td style="background: #ddf; vertical-align: middle; text-align: center;" class="table-proprietary"><a href="https://en.wikipedia.org/wiki/Proprietary_software" title="Proprietary software">Proprietary</a>
</td></tr>
<tr>
<td>AnzoGraph</td>
<td><a href="https://en.wikipedia.org/wiki/C_(programming_language)" title="C (programming language)">C</a>/<a href="https://en.wikipedia.org/wiki/C%2B%2B" title="C++">C++</a></td>
<td>4.1.0</td>
<td>2019-01-30</td>
<td style="background: #ddf; vertical-align: middle; text-align: center;" class="table-proprietary"><a href="https://en.wikipedia.org/wiki/Proprietary_software" title="Proprietary software">Proprietary</a>
</td></tr>
<tr>
<td><a href="https://en.wikipedia.org/wiki/Apache_Jena" title="Apache Jena">Apache Jena</a></td>
<td>Java</td>
<td>3.12.0<sup id="cite_ref-5" class="reference"><a href="#cite_note-5">[5]</a></sup></td>
<td>2019-05-27</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/Apache_2_License" class="mw-redirect" title="Apache 2 License">Apache 2</a>
</td></tr>
<tr>
<td>Apache Rya</td>
<td>Java</td>
<td>4.0.0<sup id="cite_ref-6" class="reference"><a href="#cite_note-6">[6]</a></sup></td>
<td>2019-07-27</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/Apache_2_License" class="mw-redirect" title="Apache 2 License">Apache 2</a>
</td></tr>
<tr>
<td>ARC2</td>
<td><a href="https://en.wikipedia.org/wiki/PHP" title="PHP">PHP</a></td>
<td>2.4.0<sup id="cite_ref-7" class="reference"><a href="#cite_note-7">[7]</a></sup></td>
<td>2019-01-25</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free">W3C Software License or GPL
</td></tr>
<tr>
<td>Attean</td>
<td><a href="https://en.wikipedia.org/wiki/Perl" title="Perl">Perl</a></td>
<td>0.025<sup id="cite_ref-8" class="reference"><a href="#cite_note-8">[8]</a></sup></td>
<td>2019-10-25</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free">Artistic or GPL-1+
</td></tr>
<tr>
<td><a href="https://en.wikipedia.org/wiki/Blazegraph" title="Blazegraph">Blazegraph</a></td>
<td>Java</td>
<td>2.1.5<sup id="cite_ref-9" class="reference"><a href="#cite_note-9">[9]</a></sup></td>
<td>2019-03-19</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/GNU_General_Public_License" title="GNU General Public License">GNU GPL</a> (v.2)
</td></tr>
<tr>
<td>BrightstarDB</td>
<td>C#</td>
<td>1.14.0-alpha03<sup id="cite_ref-10" class="reference"><a href="#cite_note-10">[10]</a></sup></td>
<td>2019-08-18</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/MIT_License" title="MIT License">MIT</a>
</td></tr>
<tr>
<td>Cayley</td>
<td>Go</td>
<td>0.7.5<sup id="cite_ref-11" class="reference"><a href="#cite_note-11">[11]</a></sup></td>
<td>2018-11-26</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/Apache_2_License" class="mw-redirect" title="Apache 2 License">Apache 2</a>
</td></tr>
<tr>
<td>CM-Well</td>
<td>Scala</td>
<td>1.5.168<sup id="cite_ref-12" class="reference"><a href="#cite_note-12">[12]</a></sup></td>
<td>2019-06-03</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/Apache_2_License" class="mw-redirect" title="Apache 2 License">Apache 2</a>
</td></tr>
<tr>
<td>ClioPatria</td>
<td>SWI-Prolog, C</td>
<td>3.1.1<sup id="cite_ref-13" class="reference"><a href="#cite_note-13">[13]</a></sup></td>
<td>2017-09-06</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/GNU_General_Public_License" title="GNU General Public License">GNU GPL</a> (v.2)
</td></tr>
<tr>
<td><a href="https://en.wikipedia.org/wiki/Datomic" title="Datomic">Datomic</a></td>
<td><a href="https://en.wikipedia.org/wiki/Clojure" title="Clojure">Clojure</a></td>
<td>535-8812<sup id="cite_ref-14" class="reference"><a href="#cite_note-14">[14]</a></sup></td>
<td>2019-10-01</td>
<td style="background: #ddf; vertical-align: middle; text-align: center;" class="table-proprietary"><a href="https://en.wikipedia.org/wiki/Proprietary_software" title="Proprietary software">Proprietary</a>
</td></tr>
<tr>
<td>Dydra</td>
<td>Common Lisp, C++</td>
<td style="background: #ececec; color: #2C2C2C; font-size: smaller; vertical-align: middle; text-align: center;" class="unknown table-unknown">?</td>
<td style="background: #ececec; color: #2C2C2C; font-size: smaller; vertical-align: middle; text-align: center;" class="unknown table-unknown">?</td>
<td style="background: #ddf; vertical-align: middle; text-align: center;" class="table-proprietary"><a href="https://en.wikipedia.org/wiki/Proprietary_software" title="Proprietary software">Proprietary</a>
</td></tr>
<tr>
<td>Enterlab SimpleGraph</td>
<td>Java</td>
<td style="background: #ececec; color: #2C2C2C; font-size: smaller; vertical-align: middle; text-align: center;" class="unknown table-unknown">?</td>
<td style="background: #ececec; color: #2C2C2C; font-size: smaller; vertical-align: middle; text-align: center;" class="unknown table-unknown">?</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/Eclipse_Public_License" title="Eclipse Public License">EPL</a>
</td></tr>
<tr>
<td>gStore</td>
<td>C++</td>
<td>0.7.2<sup id="cite_ref-15" class="reference"><a href="#cite_note-15">[15]</a></sup></td>
<td>2018-11-04</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/BSD_licenses" title="BSD licenses">BSD</a>
</td></tr>
<tr>
<td>GraphDB by <a href="https://en.wikipedia.org/wiki/Ontotext" title="Ontotext">Ontotext</a></td>
<td>Java</td>
<td>8.11<sup id="cite_ref-16" class="reference"><a href="#cite_note-16">[16]</a></sup></td>
<td>2019-08-09</td>
<td style="background: #ddf; vertical-align: middle; text-align: center;" class="table-proprietary"><a href="https://en.wikipedia.org/wiki/Proprietary_software" title="Proprietary software">Proprietary</a>
</td></tr>
<tr>
<td>Halyard</td>
<td>Java</td>
<td>3.0<sup id="cite_ref-17" class="reference"><a href="#cite_note-17">[17]</a></sup></td>
<td>2019-06-02</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/Apache_2_License" class="mw-redirect" title="Apache 2 License">Apache 2</a>
</td></tr>
<tr>
<td><a href="https://en.wikipedia.org/wiki/IBM_DB2" class="mw-redirect" title="IBM DB2">IBM DB2</a></td>
<td>Java, <a href="https://en.wikipedia.org/wiki/SQL" title="SQL">SQL</a></td>
<td>11.5<sup id="cite_ref-18" class="reference"><a href="#cite_note-18">[18]</a></sup></td>
<td style="background: #ececec; color: #2C2C2C; font-size: smaller; vertical-align: middle; text-align: center;" class="unknown table-unknown">?</td>
<td>
</td></tr>
<tr>
<td>KiWi (<a href="https://en.wikipedia.org/wiki/Apache_Marmotta" title="Apache Marmotta">Apache Marmotta</a>)</td>
<td>Java</td>
<td>3.4.0<sup id="cite_ref-19" class="reference"><a href="#cite_note-19">[19]</a></sup></td>
<td>2018-06-12</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/Apache_2_License" class="mw-redirect" title="Apache 2 License">Apache 2</a>
</td></tr>
<tr>
<td><a href="https://en.wikipedia.org/wiki/MarkLogic" title="MarkLogic">MarkLogic</a></td>
<td>C++</td>
<td>10.0-1<sup id="cite_ref-20" class="reference"><a href="#cite_note-20">[20]</a></sup></td>
<td>2019-05</td>
<td style="background: #ddf; vertical-align: middle; text-align: center;" class="table-proprietary"><a href="https://en.wikipedia.org/wiki/Proprietary_software" title="Proprietary software">Proprietary</a>
</td></tr>
<tr>
<td><a href="https://en.wikipedia.org/wiki/Mulgara_(software)" title="Mulgara (software)">Mulgara</a></td>
<td>Java</td>
<td>2.1.13<sup id="cite_ref-21" class="reference"><a href="#cite_note-21">[21]</a></sup></td>
<td>2012-01-10</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/Open_Software_License" title="Open Software License">OSL</a>, moving to <a href="https://en.wikipedia.org/wiki/Apache_2_License" class="mw-redirect" title="Apache 2 License">Apache 2</a>
</td></tr>
<tr>
<td><a href="https://en.wikipedia.org/wiki/Amazon_Neptune" title="Amazon Neptune">Amazon Neptune</a></td>
<td style="background: #ececec; color: #2C2C2C; font-size: smaller; vertical-align: middle; text-align: center;" class="unknown table-unknown">?</td>
<td style="background: #ececec; color: #2C2C2C; font-size: smaller; vertical-align: middle; text-align: center;" class="unknown table-unknown">?</td>
<td style="background: #ececec; color: #2C2C2C; font-size: smaller; vertical-align: middle; text-align: center;" class="unknown table-unknown">?</td>
<td style="background: #ddf; vertical-align: middle; text-align: center;" class="table-proprietary"><a href="https://en.wikipedia.org/wiki/Proprietary_software" title="Proprietary software">Proprietary</a>
</td></tr>
<tr>
<td><a href="https://en.wikipedia.org/wiki/NitrosBase" title="NitrosBase">NitrosBase</a></td>
<td>C++</td>
<td style="background: #ececec; color: #2C2C2C; font-size: smaller; vertical-align: middle; text-align: center;" class="unknown table-unknown">?</td>
<td style="background: #ececec; color: #2C2C2C; font-size: smaller; vertical-align: middle; text-align: center;" class="unknown table-unknown">?</td>
<td style="background: #ddf; vertical-align: middle; text-align: center;" class="table-proprietary"><a href="https://en.wikipedia.org/wiki/Proprietary_software" title="Proprietary software">Proprietary</a>
</td></tr>
<tr>
<td>OntoQuad RDF Server</td>
<td>C++</td>
<td style="background: #ececec; color: #2C2C2C; font-size: smaller; vertical-align: middle; text-align: center;" class="unknown table-unknown">?</td>
<td style="background: #ececec; color: #2C2C2C; font-size: smaller; vertical-align: middle; text-align: center;" class="unknown table-unknown">?</td>
<td>
</td></tr>
<tr>
<td>OpenAnzo</td>
<td>Java</td>
<td>3.2.0<sup id="cite_ref-22" class="reference"><a href="#cite_note-22">[22]</a></sup></td>
<td>2010-03-11</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/Eclipse_Public_License" title="Eclipse Public License">EPL</a>
</td></tr>
<tr>
<td><a href="https://en.wikipedia.org/wiki/Virtuoso_Universal_Server" title="Virtuoso Universal Server">OpenLink Virtuoso</a></td>
<td>C</td>
<td>8.3 (Commercial)&nbsp;; 7.2.5.1 (Open Source)</td>
<td>2018-10-22&nbsp;;  2018-08-15</td>
<td>GPL v2 <i><b>or</b></i> Commercial
</td></tr>
<tr>
<td><a href="https://en.wikipedia.org/wiki/Oracle_Database" title="Oracle Database">Oracle</a></td>
<td>Java, <a href="https://en.wikipedia.org/wiki/PL/SQL" title="PL/SQL">PL/SQL</a>, <a href="https://en.wikipedia.org/wiki/SQL" title="SQL">SQL</a></td>
<td>18c</td>
<td>2018-02-05</td>
<td>
</td></tr>
<tr>
<td>Parliament</td>
<td>Java, C++</td>
<td>2.7.13<sup id="cite_ref-23" class="reference"><a href="#cite_note-23">[23]</a></sup></td>
<td>2019-05-07</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/BSD_licenses" title="BSD licenses">BSD license</a>
</td></tr>
<tr>
<td>Pointrel System</td>
<td>Java, <a href="https://en.wikipedia.org/wiki/Python_(programming_language)" title="Python (programming language)">Python</a></td>
<td>20090201<sup id="cite_ref-24" class="reference"><a href="#cite_note-24">[24]</a></sup></td>
<td>2013-02-21</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/GNU_Lesser_General_Public_License" title="GNU Lesser General Public License">GNU LGPL</a><sup id="cite_ref-25" class="reference"><a href="#cite_note-25">[25]</a></sup>
</td></tr>
<tr>
<td>Profium Sense</td>
<td>Java</td>
<td>7.0</td>
<td>2018-04</td>
<td>
</td></tr>
<tr>
<td>RAP</td>
<td>PHP</td>
<td>0.9.6<sup id="cite_ref-26" class="reference"><a href="#cite_note-26">[26]</a></sup></td>
<td>2008-02-29</td>
<td>
</td></tr>
<tr>
<td>RDF::Core</td>
<td><a href="https://en.wikipedia.org/wiki/Perl" title="Perl">Perl</a></td>
<td>0.5.1<sup id="cite_ref-27" class="reference"><a href="#cite_note-27">[27]</a></sup></td>
<td>2007-02-19</td>
<td>
</td></tr>
<tr>
<td>RDF::Trine</td>
<td><a href="https://en.wikipedia.org/wiki/Perl" title="Perl">Perl</a></td>
<td>1.019<sup id="cite_ref-28" class="reference"><a href="#cite_note-28">[28]</a></sup></td>
<td>2018-01-05</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free">Artistic or GPL-1+
</td></tr>
<tr>
<td>RDF-3X</td>
<td>C++</td>
<td>0.3.8<sup id="cite_ref-29" class="reference"><a href="#cite_note-29">[29]</a></sup></td>
<td>2013-11-22</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free">CC-BY-NC-SA 3.0
</td></tr>
<tr>
<td><a href="https://en.wikipedia.org/wiki/RDF4J" title="RDF4J">Eclipse RDF4J</a></td>
<td>Java</td>
<td>3.0.3<sup id="cite_ref-30" class="reference"><a href="#cite_note-30">[30]</a></sup></td>
<td>2019-11-30</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/BSD_licenses" title="BSD licenses">Eclipse Distribution License (EDL)</a>
</td></tr>
<tr>
<td>RDFBroker</td>
<td>Java</td>
<td style="background: #ececec; color: #2C2C2C; font-size: smaller; vertical-align: middle; text-align: center;" class="unknown table-unknown">?</td>
<td>2009-01-14<sup id="cite_ref-31" class="reference"><a href="#cite_note-31">[31]</a></sup></td>
<td>
</td></tr>
<tr>
<td><a href="https://en.wikipedia.org/wiki/RDFLib" title="RDFLib">RDFLib</a></td>
<td>Python</td>
<td>4.2.2<sup id="cite_ref-32" class="reference"><a href="#cite_note-32">[32]</a></sup></td>
<td>2017-01-29</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/BSD_Licenses" class="mw-redirect" title="BSD Licenses">BSD</a>
</td></tr>
<tr>
<td>RDFox</td>
<td>C++</td>
<td>2.1.1</td>
<td>2019-11-15</td>
<td style="background: #ddf; vertical-align: middle; text-align: center;" class="table-proprietary"><a href="https://en.wikipedia.org/wiki/Proprietary_software" title="Proprietary software">Proprietary</a>
</td></tr>
<tr>
<td><a href="https://en.wikipedia.org/wiki/Redland_RDF_Application_Framework" title="Redland RDF Application Framework">Redland</a></td>
<td>C</td>
<td>1.0.17<sup id="cite_ref-33" class="reference"><a href="#cite_note-33">[33]</a></sup></td>
<td>2014-05-10</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free">Apache or LGPL or GPL<sup id="cite_ref-34" class="reference"><a href="#cite_note-34">[34]</a></sup>
</td></tr>
<tr>
<td>RedStore</td>
<td>C</td>
<td>0.5.4<sup id="cite_ref-35" class="reference"><a href="#cite_note-35">[35]</a></sup></td>
<td>2011-10-27</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/GNU_General_Public_License" title="GNU General Public License">GNU GPL</a>
</td></tr>
<tr>
<td>Semantics Platform</td>
<td><a href="https://en.wikipedia.org/wiki/C_Sharp_(programming_language)" title="C Sharp (programming language)">C#</a></td>
<td>2.0<sup id="cite_ref-36" class="reference"><a href="#cite_note-36">[36]</a></sup></td>
<td>2010-06-17</td>
<td>
</td></tr>
<tr>
<td>SemWeb-DotNet</td>
<td>C#</td>
<td style="background: #ececec; color: #2C2C2C; font-size: smaller; vertical-align: middle; text-align: center;" class="unknown table-unknown">?</td>
<td>2014-08-11<sup id="cite_ref-37" class="reference"><a href="#cite_note-37">[37]</a></sup></td>
<td>
</td></tr>
<tr>
<td>SiDiF - Simple Data Interchange Format - Educational TripleStore</td>
<td>Java</td>
<td>0.0.9<sup id="cite_ref-38" class="reference"><a href="#cite_note-38">[38]</a></sup></td>
<td>2018-01-14</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/Apache_2_License" class="mw-redirect" title="Apache 2 License">Apache 2</a>
</td></tr>
<tr>
<td><a href="https://en.wikipedia.org/wiki/Smart-M3" title="Smart-M3">Smart-M3</a></td>
<td>Python, Java, C, C#</td>
<td>0.5.0<sup id="cite_ref-39" class="reference"><a href="#cite_note-39">[39]</a></sup></td>
<td>2017-01-01</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/BSD_licenses" title="BSD licenses">BSD</a> <sup id="cite_ref-40" class="reference"><a href="#cite_note-40">[40]</a></sup>
</td></tr>
<tr>
<td><a href="https://en.wikipedia.org/wiki/Soprano_(software)" class="mw-redirect" title="Soprano (software)">Soprano</a></td>
<td>C++</td>
<td>2.8.0</td>
<td>2012-06-27</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/GNU_Lesser_General_Public_License" title="GNU Lesser General Public License">GNU LGPL</a> <sup id="cite_ref-41" class="reference"><a href="#cite_note-41">[41]</a></sup>
</td></tr>
<tr>
<td>Stardog</td>
<td>Java</td>
<td>7.0.0<sup id="cite_ref-42" class="reference"><a href="#cite_note-42">[42]</a></sup></td>
<td>2019-08-07</td>
<td style="background: #ddf; vertical-align: middle; text-align: center;" class="table-proprietary"><a href="https://en.wikipedia.org/wiki/Proprietary_software" title="Proprietary software">Proprietary</a>
</td></tr>
<tr>
<td>StrixDB</td>
<td>C++, <a href="https://en.wikipedia.org/wiki/Lua_(programming_language)" title="Lua (programming language)">Lua</a></td>
<td>94_3<sup id="cite_ref-43" class="reference"><a href="#cite_note-43">[43]</a></sup></td>
<td>2013-04-11</td>
<td>
</td></tr>
<tr>
<td>Wukong</td>
<td>C++</td>
<td>0.1.0<sup id="cite_ref-44" class="reference"><a href="#cite_note-44">[44]</a></sup></td>
<td>2017-10-27</td>
<td style="background: #9FF; color: black; vertical-align: middle; text-align: center;" class="free table-free"><a href="https://en.wikipedia.org/wiki/Apache_2_License" class="mw-redirect" title="Apache 2 License">Apache 2</a>
</td></tr></tbody><tfoot></tfoot></table>






