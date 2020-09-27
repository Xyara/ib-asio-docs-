![](./images/logos_feder.png)

# Requisitos funcionales



## Subsistema de Autentificación



| Código | Requisito                                                    | Prioridad |
| ------ | ------------------------------------------------------------ | --------- |
| RF1.1  | La aplicación ASIO ofrecerá un enlace para acceder a través de el sistema SIR, de forma que al acceder mediante este sistema pueda volver a la aplicación de forma automática. |           |
| RF1.2  | Para que un nuevo usuario, de tipo diferente a profesor PDI, pueda acceder a la parte privada de la aplicación, un usuario administrador deberá dar de alta a este nuevo usuario usando su identificador único, email. |           |
| RF1.3  | Un usuario de tipo profesor PDI podrá registrarse en la aplicación a través de SIR, sin necesidad de estar dado de alta en la aplicación. |           |
| RF1.4  | Un usuario podrá acceder a la aplicación a través del sistema SIR (Servicio de Identidad de RedIRIS). |           |
| RF1.5  | El sistema SIR devolverá algunos datos del usuario a la aplicación, al menos un identificador para identificar el usuario y actualizarlo, en caso necesario, sus datos en el sistema. |           |
| RF1.6  | Al registrarse un usuario, si el sistema SIR devuelve algún dato que permita identificar su rol correspondiente, el sistema le asignará automáticamente ese rol. |           |
|        |                                                              |           |
|        |                                                              |           |
|        |                                                              |           |





## Subsistema de administración de la aplicación y roles



| Código | Requisito                                                    | Prioridad |
| ------ | ------------------------------------------------------------ | --------- |
| RF2.1  | La aplicación constará de una serie de roles predefinidos:<br />- *Gestor ASIO*: Es el administrador del sistema. Podrá administrar roles y modificar la frecuencia de los procesos automáticos de carga de datos. <br />- *Administrador de universidad*: Podrá crear y modificar ontologías relativas a su universidad y les asignará roles, cargar datos relativos a esa universidad y modificar los roles de los datos<br />- *Investigador de universidad*: Podrá ver los datos asignados a su rol, y los datos de usuario para consultas.<br />- *Usuario para consultas de universidad*: Podrá ver datos asignados a este rol.<br />- *Administrador de Ministerio (ministerio, FECYT agencia de ciencia):* Podrá añadir/borrar consultas SparQL personalizadas para los usuarios de Ministerio.<br />- *Usuario de Ministerio (ministerio, FECYT agencia de ciencia):* Podrá ver los datos asignados a su rol y ejecutar consultas SparQL personalizadas.<br />- *Gobierno regional*: Podrá ver los datos asignados a su rol.<br />- *Agencia Española de investigación*: Podrá ver los datos asignados a su rol. |           |
| RF2.2  | Cuando el usuario se registra a través de SIR, si este sistema devuelve su rol y hay una equivalencia con los roles existentes en la aplicación, se le asignará su rol automáticamente. |           |
| RF2.3  | Cuando el usuario se registra a través de SIR, si este sistema devuelve su rol y no hay una equivalencia con los roles existentes en la aplicación, se creará su usuario pero sólo podrá acceder al contenido público del portal. |           |
| RF2.4  | La aplicación SIR dispondrá de una serie de funcionalidades que se podrán realizar en al aplicación. |           |
| RF2.5  | Los usuarios con rol Gestor ASIO podrán asociar funcionalidades a cada rol. |           |
| RF2.6  | Una funcionalidad siempre tendrá un rol asignado, nunca podrá existir una funcionalidad sin rol asignado. |           |
| RF2.7  | Los usuarios con rol gestor ASIO podrán crear roles mediante una pantalla. |           |
| RF2.8  | Los usuarios con rol gestor ASIO podrán modificar roles mediante una pantalla. |           |
| RF2.9  | Los usuarios con rol gestor ASIO podrán borrar roles mediante una pantalla. |           |
| RF2.10 | Los usuarios con rol gestor ASIO podrán modificar el rol de un usuario haciendo una búsqueda previa de ese usuario en la aplicación web. |           |
| RF2.11 | Los usuarios con rol Gestor ASIO podrán configurar en la aplicación web la frecuencia con la que la aplicación lanzará los procesos automáticos para cargar y actualizar los datos. |           |
| RF2.12 | Los roles asignados a funcionalidades por defecto en la aplicación y sus funcionalidades son:<br />  - Gestor ASIO: Gestionar la administración de roles y de la aplicación, asignar roles a funcionalidades y configurar frecuencia de procesos automáticos.<br />- Administrador de Ministerios: Crear, modificar y borrar las consultas SPARQL predefinidas para los usuarios de ministerios.<br />- Administrador de universidad: Cargar, modificar y borrar datos relativos a investigaciones a su universidad y asignar roles a los campos de las ontologías de su universidad. |           |




## Subsistema de administración de contenidos



| Código | Requisito                                                    | Prioridad |
| ------ | ------------------------------------------------------------ | --------- |
| RF3.1  | Se definirá un vocabulario común que pueda ser comprendido tanto por los desarrolladores como los expertos del dominio. |           |
| RF3.2  | Al importar los datos de las ontologías por primera vez se guardarán los datos, pero las siguientes veces se actualizarán esos datos. |           |
| RF3.3  | Los datasets de la Universidad de Murcia se actualizarán por primera vez a través de ficheros XML. |           |
| RF3.4  | Al importar los CVNs por primera vez se guardarán los datos, pero las siguientes veces se actualizarán esos datos. |           |
| RF3.4  | Los datos de las ontologías se actualizarán a través de procesos automáticos. |           |
| RF3.5  | Los datos de los cvn se actualizarán a través de procesos automáticos. |           |
| RF3.6  | Los datos de los CVNs de la Universidad de Murcia se obtendrán a través de servicios implementados con protocolo OAI-PMH. |           |
| RF3.7  | Los procesos automáticos tendrán una frecuencia configurable por el usuario con rol administrador de universidad. |           |
| RF3.8  | Al crear o modificar ontologías, los campos por defecto tendrán visualización publica, es decir, cualquier usuario, tanto registrados como no registrados, podrán ver los datos de esa ontología. |           |
| RF3.9  | Los usuarios con rol administrador de una universidad podrán modificar los roles permitidos para visualizar los campos de una ontología a través de una sección en la aplicación web. |           |
| RF3.10 | La aplicación debe de estar preparada para que cada profesor puede disponer de varios currículums en formato CVN. |           |
| RF3.11 | Se guardarán CVNs de la Universidad de Murcia, pero el diseño de la aplicación se realizará en base a que se puedan guardar CVNs de todas las universidades. |           |
| RF3.12 | Se realizarán actualizaciones increméntales de datos consultando a los distintos SGIs de las universidades que se harán de forma automática. |           |
| RF3.13 | Los datos de entrada al *backend SGI* podrán ser tomados de varias fuentes que pueden estar en formatos diferentes a RDF por lo que el sistema contará con una **librería de importación** de datos que convertirá datos de fuentes heterogéneas en RDF. |           |
| RF3.14 | Se creará un Gestor de Datos que coordinará la actividad de todos los módulos para poder realizar las funciones principales del Backend SGI. |           |
| RF3.15 | El **gestor de datos** será el encargado de subir los datos:<br />       a) Datos no-RDF.<br/>      b) Datos en RDF ya procesados: datos externos o equivalencias semánticas descubiertas. |           |
| RF3.16 | El gestor de datos ejecutará la conversión a RDF cuando lo datos subidos no estén en ese formato. |           |
| RF3.17 | El gestor de datos deberá ejecutar el descubrimiento de enlaces sobre los datos que suba en RDF ya procesados. |           |
| RF3.18 | El gestor de datos deberá publicar los datos.                |           |
| RF3.19 | El gestor de datos deberá recoger los metadatos estructurales sobre el proceso de creación del dataset (Entre otros: Origen, Responsable de creación, y pasos seguidos). |           |
| RF3.20 | El gestor de datos deberá recoger los metadatos definidos en la Especificación ontologías Hércules de la Infraestructura Ontológica. |           |
| RF3.21 | El gestor de datos deberá recoger los metadatos no definidos en la Especificación ontologías Hércules de la Infraestructura Ontológica, por ejemplo metadatos de intereś sólo para la Universidad o metadatos sobre dominios muy concretos. |           |
| RF3.22 | El gestor de datos deberá recogerla licencia sobre los datos, usando el Vocabulario Creative Commons. |           |
| RF3.23 | El gestor de datos deberá validar los datos convertidos a RDF por él mismo. |           |
| RF3.24 | **Generador de URIs:** Existirá un URI Lookup Service (desarrollado en otro proyecto) con interfaz para máquinas (Rest services) para buscar URIs de entidades, a través del contenido de las URIs y a través del contenido de propiedades como rdfs:label o rdfs:comment (Las propiedades a usar serán configurables). |           |
| RF3.25 | Al crear un elemento, se buscará su URI y si no existe, se generará una nueva con el generador de URIs. |           |
| RF3.26 | **Integración cotínua de las ontologías:** las ontologías serán almacenadas en modo texto en el sistema de control de versiones con el fin de que los creadores de ontologías puedan hacer uso de las prácticas habituales en ingeniería del software para gestión de software mediante control de versiones. |           |
| RF3.27 | Estas ontologías, una vez guardadas en el control de versiones, se pasarán a integración contínua para integrarlas en el triple store. |           |
|        |                                                              |           |



## Subsistema de consulta de datos



| Código | Requisito                                                    | Prioridad |
| ------ | ------------------------------------------------------------ | --------- |
| RF4.1  | La aplicación tendrá una parte pública, los usuarios públicos y todos los usuarios registrados podrán ver estos contenidos públicos. |           |
| RF4.2  | La aplicación dispondrá de una pantalla de consultas SPARQL que será visible de forma pública y permitirá escribir en texto libre. |           |
| RF4.3  | En la pantalla de consultas SPARQL se propondrán unas consultas predefinidas en función del rol de los usuarios. |           |
| RF4.4  | Las consultas predefinidas para los usuarios de ministerios se podrán añadir/borrar mediante una pantalla y un usuario con un rol predeterminado. |           |
| RF4.5  | Se facilitará la edición de las consultas predefinidas en la pantalla de consulta SPARQL |           |
| RF4.6  | Se harán sugerencias en la pantalla de consulta SPARQL como pueden ser autocomplete de variables, de entidades almacenadas, de prefijos y vocabularios. |           |
| RF4.7  | La pantalla de consultas SPARQL mostrará los datos en distintos formatos como timeline, mapa, y gráficos estadísticos. |           |
| RF4.8  | La pantalla de consultas SPARQL constará de un asistente de consultas SPARQL. |           |
| RF4.9  | Una vez realizada la consulta en la pantalla de consultas SPARQL, se mostrarán los datos visibles para el usuario en función de rol o de si son públicos. |           |
| RF4.10 | El resultado de las consultas predefinidas se mostrará en un formato adecuado para estas. |           |
| RF4.11 | El resultado de las consultas se podrá descargar en ficheros de distintos formatos (por ejemplo CSV y Json). |           |
| RF4.12 | A través del resultado de las consultas se podrá acceder a la versión HTML de los elementos mostrados en ella. |           |
| RF4.13 | La aplicación web será capaz de mostrar los metadatos de los datasets a los que se accederá navegando a través de las consultas. |           |
| RF4.14 | Si se accede a un elemento, a través de una consulta o de su URL asociada, se mostrarán su información de forma similar a cómo se muestran los datos en wikidata: https://www.wikidata.org/wiki/Q378619 |           |
| RF4.15 | En la pantalla de consultas SPARQL, un usuario podrá ver el resultado de las consultas de agregación de los campos que no son visibles para él, por ejemplo, una suma, pero no podrá ver estos datos en detalle. |           |
| RF4.16 | Un usuario sólo podrá ver o descargar los datos para los cuales tenga permisos. |           |
| RF4.17 | Los usuarios de una universidad, sólo podrán acceder a los datos de esa universidad para los cuales tengan permisos. |           |
| RF4.18 | Se podrán descargar los datasets de todas las ontologías de la aplicación a través de la página web. |           |
| RF4.19 | Se dispondrá de un servicio donde las máquinas puedan hacer consultas mediante GET/POST, con negociación de contenido: En el caso de que una máquina haga un GET con cabeceras Accept de HTML, esa consulta aparecerá ejecutada en el formulario web y con resultado. Por ejemplo: https://query.wikidata.org/#SELECT%20%2a%0AWHERE%20%7B%0A%20%3Fs%20%3Fp%20%3Fo%0A%7D%0ALIMIT%ste |           |
| RF4.20 | El servicio para que las máquinas realicen consultas describirá el endpoint de la manera más rica posible, utilizando vocabularios como VoID y SPARQL Service Description, para que el endpoint sea lo más “descubrible” posible (Aranda 2013). |           |
| RF4.21 | Páginas web de documentación: La aplicación web tendrá la opción de ver estadísticas generales sobre los datos. |           |
| RF4.22 | Páginas web de documentación: La aplicación web tendrá la opción de mostrar para cada Named Graph, una renderización de sus metadatos: DCAT, VoID,PROV, y cualquier otro metadato destacable. |           |
| RF4.23 | Páginas web de documentación: La aplicación web tendrá enlaces a repositorios GitHub (Plataforma Backend SGI, módulos, Test suites, Datasets, especificaciones). |           |
| RF4.24 | Páginas web de documentación :La aplicación web tendrá enlaces a validadores y a resultados de validación: validación de datos y validación de principios FAIR (Infraestructura Ontológica). |           |
| RF4.25 | Páginas web de documentación: La aplicación web tendrá una lista de los backends SGI en activo |           |
| RF4.26 | Páginas web de documentación: Se podrán consultar los datos de contacto en la aplicación web. |           |
| RF4.27 | Páginas web de documentación: La aplicación web mostrará la información del contrato de URIs. |           |
| RF4.28 | Páginas web de documentación: La aplicación web mostrará información sobre el proyecto Hércules y sus objetivos. |           |
| RF4.29 | Cualquier usuario podrá acceder a la información mostrada en las páginas web de documentación. |           |
|        |                                                              |           |





## Requisitos de datos



| Código | Requisito                                                    | Prioridad |
| ------ | ------------------------------------------------------------ | --------- |
| RF5.1  | Los datos dispondrán de un identificador único y persistente |           |
| RF5.2  | Los datos deben ser descritos con metadatos descriptivos     |           |
| RF5.3  | Los metadatos incluyen clara y explícitamente el identificador de los datos que describen. |           |
| RF5.4  | Los metadatos serán accesibles incluso cuando los datos ya no se encuentren disponibles |           |
| RF5.5  | Los metadatos serán accesibles incluso cuando los datos ya no se encuentren disponibles |           |
| RF5.6  | Los (Meta) datos usan un lenguaje formal, accesible, compartido y ampliamente aplicable para la representación del conocimiento. |           |
| RF5.7  | Los (Meta) datos usan vocabularios que siguen los principios FAIR |           |
| RF5.8  | Los (Meta) datos incluyen referencias calificadas a otros (Meta) datos. |           |
| RF5.9  | Los (meta) datos se publican con una licencia de uso de datos clara y accesible. |           |
| RF5.10 | Los (Meta) datos están asociados con información detallada sobre procedencia. |           |
| RF5.11 | Los (Meta) datos cumplen con los estándares de la comunidad relevantes para el dominio. |           |
| RF5.12 | Las URIs de la ontología deberán respetar el Esquema de URIs Hércules definido en Arquitectura Semántica de Datos del SUE. |           |
|        |                                                              |           |

