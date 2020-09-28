![](./images/logos_feder.png)

| Entregable                       | Especificación de las ontologías Hércules                    |
| -------------------------------- | ------------------------------------------------------------ |
| Fecha                            | 25/05/2020                                                   |
| Proyecto                         | [ASIO](https://www.um.es/web/hercules/proyectos/asio) (Arquitectura Semántica e Infraestructura Ontológica) en el marco de la iniciativa [Hércules](https://www.um.es/web/hercules/) para la Semántica de Datos de Investigación de Universidades que forma parte de [CRUE-TIC](https://tic.crue.org/hercules/) |
| Módulo                           | Infraestructura Ontológica                                   |
| Tipo                             | Entregable complementario a la documentación de la ontología, que se encuentra en la carpeta [Red de ontologías Hércules](../01-Red_de_Ontologías_Hércules). |
| Objetivo                         | Documento donde se explica la aproximación para especificar, personalizando, las partes de la red de ontologías Hércules según los intereses del *stakeholder* en cuestión. |
| Estado                           | **80%**. Se contemplaba un desarrollo de las ontologías del 80% para el hito 1 de proyecto y se considera alcanzado. |
| Próximos pasos                   | Para el hito 2 se contempla continuar el desarrollo del 20% restante de las ontologías por medio del añadido de más módulos verticales que contemplen otras realidades más allá de las preguntas de competencia proporcionadas para el hito 1 y de acuerdo a los datasets proporcionados por la Universidad de Murcia y otros casos que se juzguen idóneos (Universidad de Oviedo u otras). |
| Repositorio de software asociado | El espacio de trabajo de las ontologías Hércules es accesible [aquí](https://github.com/HerculesCRUE/ib-hercules-ontology). |



# Especificación de las ontologías Hércules

## 1. introducción

Este documento describe el modelo propuesto para proceso de especificación/personalización de las ontologías Hércules. Una de las principales preocupaciones a la hora de diseñar ontologías es su ciclo vital, incluyendo modificaciones que adapten el modelo ontológico a nuevas *realidades* del dominio. La modificación o añadido de entidades a una ontología no es algo trivial y debe ser llevado a cabo con un meticuloso análisis previo.

Como veremos más adelante, el modelo propuesto trata de minimizar los cambios del *core* ontológico y de marginar estos al máximo a los módulos verticales.

## 2. módulos verticales y *personalización*

La apuesta por [SKOS](https://www.w3.org/TR/swbp-skos-core-spec/) como solución principal para los módulos verticales, en lugar de centrarnos en otras propuestas menos estandarizadas, como, por ejemplo, el modelo [Lemon](https://lemon-model.net/) que mencionábamos en el documento de la red de ontologías, tiene que ver precisamente con la personalización (*customisation*) de determinadas áreas del dominio formalizado.

El modelo ontológico propuesto trata de limitar por tanto las partes personalizables de la ontología a los módulos verticales de manera que los *stakeholders* puedan adaptar o añadir parte de su *realidad* allí de una manera más sencilla y controlada.

Modificar y mantener una ontología no es algo simple ni trivial y las consecuencias de una modificación pueden afectar dramáticamente al modelo completo, arruinándolo. Por eso se decidió modularizar subdominios como la geopolítica, los recursos humanos, las universidades, los títulos universitarios, etc. por medio de estos módulos verticales.

De esta manera, el core ontológico permanece lo más intacto y seguro posible y únicamente a la merced de los ingenieros de ontologías.

Con un modelo estructurado como el que proporciona SKOS, las inclusiones de nuevos conceptos pueden llevarse a cabo de una manera más segura y controlada, tocando exclusivamente los módulos verticales.

Además, el uso de SKOS podría traer aparejado un editor que facilitaría la tarea a la hora de añadir conceptos o relaciones (mapeos) entre conceptos. El W3C recopila diferentes herramientas de este tipo [aquí](https://www.w3.org/2004/02/skos/wiki/Tools), pero otros editores como [Skosmos](http://skosmos.org/) o [SKOSIĆ](https://bitbucket.org/fundacionctic/skosic/src/default/), ambos de código abierto, también están disponibles y se podrían proponer como solución para la edición de los módulos verticales.

Finalmente, cabe decir que en el diseño de esta modularización se tuvo en cuenta el patrón de diseño [Using SKOS Concept](http://ontologydesignpatterns.org/wiki/Community:Using_SKOS_Concept).

## 3. un ejemplo de especificación: recursos humanos universitarios

En el módulo vertical de *recursos humanos universitarios* se proporcionaban ya algunos ejemplos de especificación de figuras profesorales provenientes de diversas realidades nacionales y regionales. Recuperémoslas de nuevo aquí con fines ilustrativos.

Como sabemos, una cuestión compleja de abordar entre los sistemas universitarios nacionales son los recursos humanos, especialmente aquellos que se corresponden a los puestos académicos. España, por ejemplo, muestra una variada complejidad de posiciones que puede llegar a ser aún mayor cuando penetramos en las realidades autonómicas. Ahí se dan casos sumamente específicos en Andalucía, Cataluña, Galicia o el País Vasco.

A modo de ejemplo, nosotros mismos llevamos a cabo un análisis e implementamos algunos de esos casos específicos relacionándolos por un lado con el módulo vertical de recursos humanos universitarios y también con las comunidades autónomas correspondientes.

Veamos un ejemplo:

```turtle
asioModules:ES_UNIVERSITY_HR_ESLPC
      a       owl:NamedIndividual , asio:Role , skos:Concept ;
      rdfs:label "Profesor catedrático laboral"@es ;
      asio:country euCountry:ESP ;
      asio:geoDivision asioModules:ES_DIVISION_LEVEL_1_ES_CT ;
      asio:hasCode asioModules:ES_UNIVERSITY_HR_CODE_ESLPC ;
      skos:inScheme asioModules:ESUniversityHumanResourcesList ;
      skos:notation "ESLPC" ;
      skos:prefLabel "Profesor catedrático laboral"@es , "Profesor catedrático laboral"@gl , "Profesor catedráticu llaboral"@ast , "Professor catedràtic laboral"@ca .
```

Como podemos ver, la figura de "Professor catedràtic laboral", específicamente catalana, tal como podemos consultar en Carreras i Barnés (2012), se incluye como concepto de SKOS (instancia de la clase `skos:Concept`) y recibe más información relevante que nos indica su especificidad autonómica por medio de enlaces a la comunidad autónoma correspondiente ( `asio:geoDivision asioModules:ES_DIVISION_LEVEL_1_ES_CT ;`) dentro del módulo vertical geopolítico por medio de la propiedad, ésta sí específica de la ontología Hércules, `asio:geodivision`.

De esta manera, dentro de un módulo vertical específico dedicado a los recursos humanos universitarios del sistema universitario español, si una figura universitaria no aparece vinculada a una subdivisión geográfica específica concreta, se entiende por defecto que tal figura es de nivel regional, mientras que si otra figura, como el ejemplo catalán de "Professor catedràtic laboral", sí aparece vinculada a una realidad regional por medio de la propiedad `asio:geodivision`, ésta define su alcance.

Per además, otras realidades nacionales se recogen en módulos verticales específicos con el fin de ilustrar el uso de las propiedades de mapeo de SKOS.

A modo de ejemplo, se incluyen *datasets* equivalentes de los casos de figuras académicas de Portugal y el Reino Unido. Portugal, después de la intervención de la Troika, tiene un modelo muy reducido y eficiente, tal como recoge el [Estatuto da carreira docente universitária](https://fne.pt/uploads/documentos/1433262954_9365_ECDU_versao_consolidada.pdf), y no muestra tanta complejidad como el modelo español.

El modelo del Reino Unido incluido en los módulos verticales es solamente un ejemplo que recoge la [generality of the universities](https://web.archive.org/web/20181010061700/http://www.impacte.eu/system/files/%5Bsite%3Acurrent-group%5D/uk.pdf) y no las figuras de Oxford, por ejemplo, que son muy específicas.

Como ejemplo de especificación de mapeos entre conceptos de los módulos verticales, se incluyeron algunos casos rudimentarios, solo a modo ilustrativo, ya que el conocimiento más específico del dominio sería más propio de los *stakeholders*. Establecer estos mapeos no es una tarea trivial y serían en efecto los expertos de dominio, los candidatos más indóneos para llevar a cabo esta tarea. 

Veamos un ejemplo de mapeo entre una figura española y una figura portuguesa:

```turtle
asioModules:ES_UNIVERSITY_HR_ESPLEM
      a       owl:NamedIndividual , asio:Role , skos:Concept ;
      rdfs:label "Profesor emérito"@es ;
      asio:country euCountry:ESP ;
      asio:hasCode asioModules:ES_UNIVERSITY_HR_CODE_ESPLEM ;
      skos:inScheme asioModules:ESUniversityHumanResourcesList ;
      skos:closeMatch asioModules:PT_UNIVERSITY_HR_PTPEM ;
      skos:notation "ESPLEM" ;
      skos:prefLabel "Profesor emérito"@es , "Profesor emérito"@gl , "Profesor eméritu"@ast , "Irakasle emeritua"@eu , "Professor emèrit"@ca .
```

para la cual se usa la propiedad de SKOS  `skos:closeMatch`, que indica la proximidad conceptual entre profesores eméritos de ambos países. No osamos aventurarnos a un mapeo por medio de la propiedad `skos:exactMatch` sin ser completamente espertos de ambas realidades nacionales.

Otro mapeo similar se puede trazar respecto al código de cada figura:

```turtle
asioModules:ES_UNIVERSITY_HR_CODE_ESPLEM
      a       skos:Concept ;
      rdfs:label "ESPLEM" ;
      asio:codeOf asioModules:ES_UNIVERSITY_HR_ESPLEM ;
      skos:closeMatch asioModules:PT_UNIVERSITY_HR_CODE_PTPEM ;
      skos:inScheme asioModules:ESUniversityHumanResourcesCodesList ;
      skos:prefLabel "ESPLEM" .
```

Finalmente, cabe añadir otro detalle a tener en cuenta respecto a las instancias de estos módulos verticales de recursos humanos. El tipo de estas figuras se establece tanto como instancias de la clase `skos:Concept` como de la clase `asio:Role`. De esta manera se proporciona una suerte de conciliación entre las instancias del core ontológico y las de estos módulos verticales independientes y semi-autónomos (que podrían ser desenchufados y reciclados si fuera necesiario.

Otro tipo de roles también incluídos simultáneamente como instancias de las clases `skos:Concept` y `asio:Role`, son los denominados rangos académicos dentro de una universidad. Se incluyó por el momento una lista limitada con casos como los de *chancellor*, *vice-chancellor*, *dean*, etc. para el caso del Reino Unido y *rector*, *decano*, *director de departamento*, *secretario*, etc. para España.

Estos individuos se incluyen actualmente en los módulos de RRHH pero no se descarta que sean movidos en el futuro a módulos específicos de tipo administrativo.

Finalmente, cabe mencionar también que la propiedad `asio:referenceLaw` se utiliza específicamente para enlazar una figura de RRHH con su correspondiente legislación.

## 4. conclusiones

El documento presenta la solución propuesta de especificación de la ontología por medio de los módulos verticales como detentores de la realidad de los *stakeholders* y proporciona ejemplos de cómo llevar a cabo esa especificación por medio de ejemplos reales ya incluídos en el modelo ontológico.

Las correspondencias entre entidades para facilitar la especificación de las posibles ontologías de stakeholders que cuentan con sus propias ontologías se facilita por medio de los siguientes procedimientos:

- A nivel del core ontológico se proponen e ilustran algunos ejemplos de mapeos entre entidades por medio de la propiedad `owl:equivalentClasse`.
- Con el uso de SKOS en los módulos verticales y sus propiedades `skos:exactMatch`, `skos:closeMatch`, etc. se habilita la posibilidad de mapear las realidades de los diferentes stakeholders.



## 5. referencias

Carreras i Barnés, J. (2012). Avaluació de la qualitat docent i promoció del professorat. Legislació universitària espanyola: modificació de la Llei Orgànica d'Universitats. Professorat contractat permanent (2004-2008). *Temps d’Educació*, 42, p. 201-232. Universitat de Barcelona.

