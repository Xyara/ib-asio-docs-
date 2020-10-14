![](./images/logos_feder.png)



| Entregable     |      Documento de Análisis ASIO                                 |
| -------------- | ------------------------------------------------------------ |
| Fecha          | 25/05/2020                                                   |
| Proyecto       | [ASIO](https://www.um.es/web/hercules/proyectos/asio) (Arquitectura Semántica e Infraestructura Ontológica) en el marco de la iniciativa [Hércules](https://www.um.es/web/hercules/) para la Semántica de Datos de Investigación de Universidades que forma parte de [CRUE-TIC](https://tic.crue.org/hercules/) |
| Módulo         | Análisis                                                     |
| Tipo           | Documento                                                    |
| Objetivo       | Documento que contiene el análisis                           |
| Estado         | 100% para el hito 1                                          |
| Próximos pasos | Actualizar de forma acorde al avance del proyecto.           |


# Documento de Análisis ASIO



# Índice

[Introducción](#introducción)

[Propósito del proyecto](#propósito-del-proyecto)

[Alcance](#alcance)

[Objetivos](#objetivos)

[Skateholders](#skateholders)

[Casos de uso](./Documents/Casos%20de%20uso.md)

[Requisitos no funcionales](./Documents/Requisitos%20no%20funcionales.md)

[Requisitos funcionales](./Documents/Requisitos%20funcionales.md)

[Diseño de pantallas](../Diseño de pantallas/Diseño%20de%20pantallas.md)

[Términos de ASIO](./Documents/Términos.md)



## Introducción

El presente documento corresponde al Análisis de Requisitos para la Red de Ontologías Hércules (ROH) de acuerdo al pliego de condiciones del proyecto: Servicio de I+D consistente en el desarrollo de soluciones innovadoras para la Universidad de Murcia en relación al reto de Arquitectura semántica e Infraestructura ontológica.  

En dicho pliego se indica: "El adjudicatario hará un análisis sobre el dominio GI, extrayendo los requisitos para crear la ROH. Estos requisitos se reflejarán en el documento Análisis de Requisitos. Este análisis será lo más exhaustivo posible, intentando capturar el dominio con la granularidad adecuada, ya que sentará la base de los demás desarrollos." 



### Propósito del proyecto

El propósito del proyecto es definir una Red de Ontologías Hércules para la Gestión de la Investigación en el caso particular de la Universidad de Murcia que también pueda ser extrapolable a otras universidades españolas e internacionales. 

La iniciativa Hércules es parte de la Comisión Sectorial de Tecnologías de la Información y las
Comunicaciones de la Conferencia de Rectores de las Universidades Españolas (CRUE-TIC). Su objetivo
es crear un Sistema de Gestión de Investigación (SGI) basado en datos abiertos semánticos que ofrezca
una visión global de los datos de investigación del Sistema Universitario Español (SUE), para mejorar la
gestión, el análisis y las posibles sinergias entre universidades y el gran público.



### Alcance

Tal y como se indica en el pliego de condiciones, la Red de Ontologías Hércules captura el dominio de Gestión de la Investigación por lo que las ontologías definirán fundamentalmente los aspectos relevantes en este ámbito. En el apartado "Resumen" del pliego de condiciones se enumeran los principales aspectos que deberán ser modelados:

\-   Investigadores y producción científica individual: identidad del investigador, publicaciones, participación en proyectos de investigación, docencia, estancias en centros de investigación, y redes sociales de investigadores, entre otros.

\-   Proyectos de investigación: entidad financiadora, presupuesto, y participantes, entre otros.

\-   Financiación: fuentes (gobiernos, ministerios, entidades supranacionales, etc.), convocatorias, y proyectos, entre otros.

\-   Modalidades de ingresos y gastos en proyectos de investigación.

\-   Recursos humanos: contratos, candidatos, y financiación de investigadores, entre otros.

\-   Resultados científicos: artículos científicos y ponencias en congresos, software, patentes, y artículos de divulgación científica, entre otros.

\-   Áreas de conocimiento.

\-   Grupos de investigación e instituciones.

\-   Indicadores de investigación: métricas de producción científica, y recursos humanos, entre otros.

\-   Metadatos sobre la Gestión de Investigación



En la figura *Ilustración 1 - Principales elementos del dominio GI* se representa un diagrama de los principales elementos identificados en el dominio. Se representa al investigador como elemento central del dominio, a partir del cual se relacionan el resto de elementos. De esta forma, son los investigadores los que perteneces grupos de investigación, genera resultados científicos, participan en proyectos de investigación, producen resultados científicos, etc. 



![Ilustración 1 - Principales elementos del dominio GI](./images/Ilustración1-Principales-elementos-del-dominio-GI.jpg)                               

Ilustración 1 - Principales elementos del dominio GI



Es importante tener en cuenta que el ámbito del proyecto **abarca únicamente la realización de un**
**piloto en la Universidad de Murcia (UM)**, para constatar que el prototipo desarrollado funciona y cumple
los objetivos propuestos. Quedará fuera del ámbito del mismo, la implantación y migración tanto en la
UM como en el del resto de universidades interesadas.



### Objetivos

Actualmente existen en España 79 Universidades distribuidas por todo el territorio nacional, y cada
una de ellas cuenta con un sistema de gestión propio. Esto significa que cada Universidad tiene definidos
unos procedimientos de gestión particulares, con unos modelos y esquemas de datos definidos según sus
criterios. Como resultado de esta situación la explotación combinada de datos por parte de terceros
presenta los problemas tradicionales de interoperabilidad de fuentes de información heterogénea, no
basada en especificaciones semánticas y formales de los esquemas de datos y conocimiento. A modo de
ejemplo:

- Análisis sesgado de las necesidades de información.

- Ausencia de ciertos datos de especial interés.

- Aplicación de clasificaciones incompatibles de los datos.

- Representación de entidades a distinto nivel de granularidad.

- Dificultad para discernir si los datos procedentes de distintas fuentes tienen el mismo
  significado.

  

Además de la docencia, las universidades participan activamente en los programas de investigación. La
gestión de dicha participación es llevada a cabo por estos sistemas de gestión propios que son dispares y
no están normalizados, y que dan soporte, entre otros, a los procesos de:

- Preparación y seguimiento de proyectos.
- Gestión de resultados de proyectos de I+D+i.
- Gestión económica y administrativa integrada. Contabilidad analítica.



Esta situación general y, en concreto, en lo que respecta a los sistemas de gestión de la investigación, provoca grandes ineficiencias en la gestión de la información y el conocimiento del sistema de investigación de las universidades españolas. Ello conlleva costes adicionales derivados de la realización de tareas de explotación con conjuntos parciales de los datos en cada universidad, que luego es necesario homogeneizar.

Esto provoca la aparición del proyecto Hércules, que dará solución a la necesidad de un nuevo sistema de gestión de investigación universitaria, que disponga de capacidades semánticas y que sea homogéneo para todas las universidades (o para un gran número de ellas) para poder conseguir los siguientes beneficios:

- Realizar explotación conjunta de información.
- Unificar los criterios para la obtención de información, ofreciendo mayores garantías de una
  adecuada interpretación de la información y, con ello, la exactitud de los indicadores obtenidos.
- Poder establecer sinergias y colaboraciones entre universidades y grupos de investigación.
- Incrementar la transparencia.
- Facilitar la transferencia tecnológica y la colaboración universidad-empresa.
- Facilitar el conocimiento de la producción científica, para el resto de investigadores y para la
  sociedad en general.
- Facilitar la integración del Currículum Vitae Normalizado (CVN). Mayor facilidad para la
  movilidad del Personal Docente Investigador (PDI) entre las universidades españolas.
- Proporcionar con mayor facilidad al usuario, al contribuyente y a la sociedad datos estadísticos
  que puedan ser relevantes desde el punto de la transparencia en el ejercicio del servicio público.
- Y, en definitiva, permitir la explotación conjunta de información de investigación de todas las
  universidades, permitiendo con ello una total transparencia en la gestión universitaria.



## Skateholders



| Rol                                           | Expectativas                                                 |
| --------------------------------------------- | ------------------------------------------------------------ |
| Gestor  investigación – Universidad de Murcia | Disponer  de una mejor documentación del sistema universitario |
| Investigador  – Universidad de Murcia         | Conocer  flujos de trabajo de investigación ya establecidos. Poder identificar  conceptos comunes o relacionados en el ámbito de la investigación |
| Experto de  dominio                           | Disponer  de una herramienta fácil para representar su conocimiento en el dominio que  evite la pérdida semántica |
| Desarrolladores                               | Disponer  de un conjunto de ontologías que puedan adaptarse fácilmente al código de la  aplicación de gestión de la investigación |
| Investigador  – otra Universidad              | Conocer y  poder comparar las idiosincrasias del sistema de gestión de investigación de  la Universidad de Murcia para poder compararlo con el suyo y poder mapear  ambos sistemas en caso de que disponga de otra infraestructura ontológica. |
| Órganos de gobierno                           | Órganos de gobierno como ministerios, para los que Hércules puede aportar información útil. |
| Otros organismos interesados                  | Organismos, como fundaciones o empresas públicas, interesadas en la información que pueda aportar el proyecto o su utilidad. |


