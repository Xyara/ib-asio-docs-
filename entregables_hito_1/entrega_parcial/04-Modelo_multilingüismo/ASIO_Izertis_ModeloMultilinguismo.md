![](./images/logos_feder.png)

# Multilingüismo (y *multiescriptalismo*) en las ontologías ASIO

Introducción 
============

Este informe documenta los casos de uso y contextos que se utilizarán en el proyecto Hércules para poner a prueba modelos multilingües (y de multiescriptalismo).

 FIXME

# Reglas del modelo de multilingüismo

Todas las ontologías que se desarrollen estarán planteadas bajo un modelo de multilingüismo. Algunas de las reglas de este modelo se aplican a los siguientes aspectos:

- URIs
- Etiquetas léxicas
- Propiedades de documentación
- Otros metadatos lingüísticos

que analizaremos con algo más de detalle en las subsecciones siguientes.



URIs
----

Preferencia por la utilización de URIs opacas[^1], especialmente para identificadores. Las URIs opacas permiten separar el identificador de la representación en lenguaje natural del recurso. Esta separación se
considera una mejor práctica en entornos multilingües dado que las representaciones textuales deberían obtenerse a partir de las etiquetas multilingües (`rdfs:label`) en lugar del identificador del recurso.

Un ejemplo concreto de URI opaca es el uso de códigos ISO para crear recursos que tienen que ver con países, lenguas o incluso áreas científicas.

Véamos un ejemplo concreto extraído de uno de los módulos verticales que describiremos en una sección posterior:

```
LET ?regionResource = resource(concat("ES_DIVISION_LEVEL_1_",replace(?regionCode,"-","_")),asioModules)
```

En este ejemplo, perteneciente a uno de los programas de transformación de datos tabulares a RDF, podemos *traducir* que el recurso de una comunidad autónoma cualquiera del Estado se crea a partir del [código ISO](https://www.iso.org/obp/ui/#iso:code:3166:ES) de tales entidades.

Así por ejemplo, en el caso de la Región de Murcia, el recurso se crearía a partir del código composicional **ES-MC**, cuya primera parte, **ES**, indica el país (España) y la segunda, **MC**, la subdivisión administrativa de primer nivel, en el caso español la *comunidad autónoma*: Región de Murcia.

Una vez creado el recurso a partir de ese código ISO, inserto en la URI y opaco respecto al lenguaje natural, ese recurso puede ya recibir un tratamiento multilingüe, sin causar problemas de codificación, por medio de etiquetas `xml:lang` o `skos:prefLabel`:

```
skos:prefLabel "Región de Murcia"@es ;
skos:prefLabel "Região de Múrcia"@pt ;
skos:prefLabel "Region of Murcia"@en ;
skos:prefLabel "Région de Murcie"@fr ;
skos:prefLabel "Regió de Múrcia"@ca ;
skos:prefLabel "Región de Murcia"@gl ;
skos:prefLabel "Murtziako Eskualdea"@eu ;

skos:prefLabel "Мурсийский Регион"@ru ;

skos:prefLabel "Rexón de Murcia"@ast ;

skos:prefLabel "Регион Мурсија"@sr-Cyrl ;
skos:prefLabel "Region Mursija"@sr-Latn ;

skos:prefLabel "re'xjon̪ de 'muɾθja"@es-ES-fonipa ;

skos:prefLabel "ˈriːʤən ɒv ˈmʊərsiə"@en-GB-fonipa ;
skos:prefLabel "ˈriʤən ʌv ˈmɜːrʃ(i)ə"@en-US-fonipa ;
```

que son capas multilingües aplicadas sobre la URI opaca, *conceptualmente* *aséptica*.

Por otro lado, en este listado se puede observar una complejidad incremental en cuanto a los códigos de lengua, de *locale* y de sistema de escritura:

- los siete primeros ejemplos incluyen códigos de lengua de dos letras (`es`, `pt`, `en`, `fr`, `ca`, `gl`, `eu`).
- el octavo con código de dos letras (`ru`) y alfabeto cirílico por defecto (por lo que no es necesario especificar el sistema de escritura).
- el noveno ya con un código de tres letras (`ast`), hecho no trivial, dada la limitación a códigos de lenguas de dos dígitos implantada en algunos sistemas.
- el décimo y el décimo primero cuentan con códigos de lengua de dos letras (`sr`) y especificación del sistema de escritura empleado (`Latn` y `Cyrl`), ya que en la lengua serbia conviven los alfabetos latino y cirílico de manera bastante natural (al contrario que en ruso, por ejemplo).
- el décimo segundo incluyendo código de dos letras de lengua, seguido de código de dos letras de *locale* y seguido de un código de sistema de escritura bastante *sui generis* (`es-ES-fonipa`), en este caso correspondiente a la transcripción fonética, de acuerdo a la variedad del español hablado en españa, según el alfabeto fonético internacional o [IPA](https://www.internationalphoneticassociation.org/content/full-ipa-chart).
- el décimo tercero y el décimo cuarto incluyen el mismo caso de transcripción fonética anterior pero para la lengua inglesa especificando dos *locales* diferentes: inglés británico (`en-GB-fonipa`) e inglés norteamericano (`en-US-fonipa`).

El modelo de multilingüismo propuesto deberá poder lidiar de manera eficiente con todos esos aspectos multilingües, multi*locale*, multi*script* y multi*transliteración*.

Pero además, esta característica de opacidad de las URIs se alinea con el modelo de datos de Wikibase en el cual las entidades, sean clases o propiedades, reciben un código numérico:

```
Q3918 -> University
P31 -> instance-of
```

garantizando también esa opacidad y asepsia de las URIs para luego recibir de manera más eficiente las etiquetas multilingües.



Etiquetas léxicas
-----------------

Si en un principio se pensó utilizar únicamente etiquetas `rdfs:label` para todas las URIs (según el patrón label everything[^2]) y con un valor literal en al menos 2 idiomas: español e inglés (de acuerdo al patrón multilingual labels[^3]) y recurrir a la propiedad de SKOS `skos:altLabel` para identificar alias o nombres alternativos, el uso parcial del modelo 

Sin embargo, las etiquetas léxicas de rdfs (como `rdfs:label`) podrían no ser suficientes en todos los casos hacer una duplicación por medio de las etiquetas léxicas de SKOS (como `skos:prefLabel`) podría resultar útil, sobre todo por ponerla en relación con posibles etiquetas alternativas, explicitadas por medio de `skos:altLabel`  o, incluso, `skos:hiddenLabel` y así mantener una relación léxica de sinonimia más lógica y *modelada*.



Propiedades de documentación
----------------------------

La arquitectura ontólogica, más allá de las etiquetas léxicas propiamente dichas, puede beneficiarse de otras representaciones en lenguaje natural de cada recurso mediante propiedades de documentación pertenecientes a vocabularios como el propio [RDFS](https://www.w3.org/2001/sw/wiki/RDFS), [Dublin Core](https://dublincore.org/) o [SKOS-Core](https://www.w3.org/TR/swbp-skos-core-spec/).

Recurrir a la etiqueta `rdfs:comment` para documentar y explicar las entidades es una buena práctica, así como tambén añadir metadatos a los archivos sobre autoría (`dc:creator`), descripciones (por ejemplo `dc:description`), dataciones, etc. Utilización de otras representaciones en lenguaje natural del recurso mediante las propiedades rdfs:comment, dc:description, etc.

También [SKOS-Core](https://www.w3.org/TR/swbp-skos-core-spec/) ofrece otras interesantes para nuestros intereses, sobre todo aplicables a los esquemas de conceptos que se explotarán en los módulos verticales de la ontología, como `skos:definition` o `skos:notation`.



Otros metadatos lingüísticos
----------------------------

Utilización de metadatos lingüísticos cuando sea necesario (patrón linguistic metadata[^4]). Aunque para muchos recursos, puede ser suficiente disponer de una representación en lenguaje natural ligera con
etiquetas como `rdfs:label`, `rdfs:comment`, etc. En algunos vocabularios puede ser interesante utilizar representaciones lingüísticas más ricas como puede ser el modelo Lemon[^5], que permite representar aspectos léxicos de forma semántica.

Sin embargo, Lemon puede no ser suficiente para representar todo el conocimiento léxico de forma semántica \[2\] y este tipo de representaciones es una línea de investigación activa. A modo de ejemplo, en el proyecto europeo Prét-á-LLOD[^6] se está actualmente trabajando en la creación y representación de datos enlazados multilingües.

A la hora de seleccionar vocabularios para reutilizar, elegir vocabularios multilingües en la medida que sea posible[^7].



*Multiescriptalismo*
====================

Denominamos "multiescriptalismo", adaptando el neologismo en inglés "multiscriptalism" de Coulmas (1996), a la faceta múltiple de las lenguas que tiene que ver no con la lengua propiamente dicha, sino con
el sistema o sistemas de escritura que una lengua puede utilizar, es decir, para referirnos a la diversidad de sistemas de escritura (alfabetos, silabarios, sistemas logográficos, etc.) que se pueden encontrar en las lenguas naturales y en otros tipos de lenguajes, como por ejemplo las notaciones fonéticas.

Aunque las ontologías de ASIO en principio solamente contemplan el español y el inglés como lenguas *de trabajo*, una estructura ontológica rigurosa y bien diseñada siempre debería considerar e incluir un modelo
de *internacionalización* (i18n) preparatorio para todas las localizaciones (l10n) que fueran necesarias.

Tener en mente estas características en las fases fundacionales del proyecto y crear una infraestructura ad hoc de antemano suele ahorrar mucho trabajo futuro, aparte de garantizar una reutilización mucho más
global, que es uno de los leitmoif de la Web Semántica.

En una infraestructura ontológica como ASIO, preparada para el multilingüismo, este aspecto no debería ser desdeñado, por lo que se intentará poner un especial énfasis desde el principio en facilitar la
inclusión de todas las variedades de sistemas de escritura utilizados en lenguas naturales y artificiales que sean relevantes.



Personal
--------

Imaginemos que la Universidad de Murcia contrata a 4 investigadores europeos como profesores:

-   Un griego: Ilias Koubarakis - Ηλίας Κουμπαράκης

-   Un serbio: Aleksandar Karađorđević - Александар Карађорђевић

-   Un búlgaro: Grigor Batinkov - Григор Батинков

-   Un ruso: Ivan Uvarov - Иван Уваров

Todos ellos tienen una carrera académica previa en sus países de origen, donde han participado en proyectos nacionales y han publicado en sus lenguas de origen. Pero obviamente muchas veces, esa trayectoria previa aparece codificada no solamente en su lengua de origen, también en el alfabeto que usa esa lengua.

De acuerdo con la filosofía multilingüe que opera en la Unión Europea, resultaría integrador e interesante disponer de esas referencias en la lengua y alfabeto originales y, también, mantener un mapeo directo de las referencias ya no solo multilingüe propiamente dicho, sino también multiscript.

Veamos algún ejemplo de como las URIs deberían

Para el caso griego,

```
rdfs:label "Ηλίας Κουμπαράκης"@el ;
rdfs:label "Ilias Koubarakis"@el-Latn ;
skos:prefLabel "Ηλίας Κουμπαράκης"@el ;
skos:prefLabel "Ilias Koubarakis"@el-Latn ; si priorizamos por ejemplo
la romanización ELOT[^8].
skos:altLabel "Ilias Koubarakis"@el-Latn ; o como label alternativo en
la romanización ISO[^9].
```



Para el caso búlgaro,

```
rdfs:label "Григор Батинков"@bg ;
rdfs:label "Grigor Batinkov"@bg-Latn ;
skos:prefLabel "Григор Батинков"@bg ;
skos:altLabel "Гришо Батинков"@bg ;
skos:prefLabel "Grigor Batinkov"@bg-Latn ;
```



Para el caso serbio,

```rdfs:label \"Александар Карађорђевић\"\@sr
rdfs:label "Aleksandar Karađorđević"@sr-Latn ;
skos:prefLabel "Александар Карађорђевић"@sr ;
skos:altLabel "Саша Карађорђевић"@sr ;
skos:prefLabel "Aleksandar Karađorđević"@sr-Latn ;
skos:altLabel "Aleksandar Karadjordjević"@sr-Latn ;
```



Para el caso ruso,

```
rdfs:label "Иван Уваров"@ru
rdfs:label "Ivan Uvarov"@ru-Latn
skos:prefLabel "Иван Уваров"@ru
skos:prefLabel "Ivan Uvarov"@ru-Latn
skos:altLabel "Aleksandar Karadjordjević"@ru-Latn
```



Obviamente el contexto del proyecto es Murcia, en España y en Europa occidental, donde el alfabeto latino es el predominante y nos interesa sobre todo garantizar, en principio, únicamente el multilingüismo basado en *Latin-script*. Sin embargo también el *multiescriptalismo* resultaría no solamente un detalle de cortesía para con nuestros nuevos integrantes de la platilla, sino también un perfeccionamiento del modelo de datos subyacente, que internacionalizaríamos tambén a nivel de sistemas de escritura como paso previo a cualquier localización *ad hoc* posterior.



Publicaciones
-------------

Como comentábamos en la sección anterior, con el ejemplo ficticio de nuestras nuevas incorporaciones extranjeras al personal docente, éstas traen consigo un CV investigador en sus países de origen en el cual se incluyen publicaciones científicas en sus lenguas nativas y, por ende, en el alfabeto o sistema de escritura habitual de esas lenguas de origen.

El caso de la obra del autor ruso A. N. Sokolov, *Inner speech and thought*, publicada en su versión en inglés por la editorial Plenum Press/Springer, nos puede servir como ejemplificación. En los *metadatos* de la publicación americana, nos encontramos esta latinización: 

​										Sokolov, A. N. *Vnutrenniaia rech’ i myshlenie*. Moscow, 1968.

que nos dejaría en la inopia incluso utilizando todas las habilidades y trucos explotables en cualquier buscador de internet (mainpage, duckduckgo, google) a la hora de recuperar el título original en alfabeto cirílico.

Un tratamiento cuidadoso y *consciente* del multiescriptalismo como el que mostramos a continuación:

```
#author:
rdfs:label "Александр Николаевич Соколов"@ru
rdfs:label "Aleksandr Nikolaevich Sokolov"@ru-Latn

skos:prefLabel "Александр Николаевич Соколов"@ru
skos:altLabel "Александр Н. Соколов"@ru
skos:altLabel "А. Н. Соколов"@ru
skos:altLabel "А. Соколов"@ru

skos:prefLabel "Aleksandr Nikolaevich Sokolov"@ru-Latn
skos:altLabel "Aleksandr N. Sokolov"@ru-Latn
skos:altLabel "A. N. Sokolov"@ru-Latn
skos:altLabel "A. Sokolov"@ru-Latn

#publication:
rdfs:label "Внутренняя речь и мышление"@ru
rdfs:label "Vnutrenniaia rech' i myshlenie"@ru-Latn

skos:prefLabel "Внутренняя речь и мышление"@ru
skos:prefLabel "Vnutrenniaia rech' i myshlenie"@ru-Latn
```

enriquecería nuestros datasets facilitando una recuperación eficiente y perfeccionada de información sobre investigadores y publicaciones científicas y, en el caso ejemplificador que nos compete, recogería a la perfección la *variación referencial* de la obra, tal como se puede reparar en una búsqueda del autor/obra en cualquier buscador.

Veámoslo ejemplificado de manera práctica por medio de esta ilustración ad hoc que hemos preparado nosotros mismos para la ocasión reuniendo distintas portadas de la obra citada de Sokolov y la ficha de la obra de la Library of the Congress que se incluye en la traducción al inglés:



![Diferentes portadas de la obra de Sokolov](./images/sokolov-full.png)

La portada de la parte superior izquierda, correspondiente a la primera edición en inglés de la obra de Sokolov, de la editorial Plenum, incluye como nombre de autor únicamente la primera inicial y el apellido (A. Sokolov), mientras que la portada de la parte superior central de la imagen incluye ya ambas iniciales y el apellido (A. N. Sokolov). Ambas incluyen el título completo de la obra traducido al inglés (*Inner speech and thought*). 

La imagen de la parte superior derecha, original en ruso, incluye las dos iniciales y el apellido del autor, obviamente en alfabeto cirílico (А. Н. Соколов), y el título original de la obra en el mismo alfabeto (*Внутренняя речь и мышление*).

Finalmente, en la parte inferior de la imagen vemos la ficha bibliográfica de la Library of the Congress incluyendo la transliteración al alfabeto latino de la obra de Sokolov (*Vnutrenniaia rech' i myshlenie*) tal como se incluye en la primera edición de la traducción de la obra por parte de la editorial Plenum.

Como se puede observar, el deficiente tratamiento del multiescriptalismo perjudicaría cualquier recuperación de información: la ficha es completamente *escriptocéntrica* y solo incluye información del autor en alfabeto latino, al menos completa y sin iniciales (Sokolov, Aleksandr Nikolaevich) y la latinización del título original ruso de la obra (*Vnutrenniaia rech' i myshlenie*), con algunos diacríticos que no recogemos en nuestra transcripción y que podrían ser conflictivos en la recuperación.









Los módulos verticales de la ontología ASIO como campo de pruebas
========================================================

En los módulos verticales de la ontología ASIO se incluyen modelizaciones de dominios específicos que quedan fuera del _core_ de la ontología propiamente dicho pero que son complementarios a él y lo enriquecen.

En esta fase inicial de desarrollo de contemplan por el momento tres módulos verticales que exigen tratamiento multiligüe en mayor o menor medida. En concreto y por orden de más a menos en cuanto al multilingüismo éstos son:

- Entidades geopolíticas
- Áreas científicas
- Entidades administrativas

Estos módulos verticales suponen el caldo de cultivo ideal para hacer pruebas de concepto y evaluar limitaciones y alcance del modelo multilingüe del modelo ontológico ya que incluyen frecuentemente entidades susceptibles de ser tratadas en base a diversas lenguas naturales.



## Entidades geopolíticas

El otro módulo vertical ya avanzado en diseño aunque aún no totalmente implementado es el correspondiente al modelo geopolítico. En una primera fase, el módulo se limitará a España y sus niveles administrativos (nación, comunidad autónoma, provincia y municipio) y con futuras implementaciones que incluirán en principio países limítrofes (Andorra, Francia, Portugal) y tal vez alguno más cuyas etiquetas lingüísticas incluyan otros sistemas de escritura dentro de la Unión Europea, como Grecia o Bulgaria, estos últimos con el fin de testear el citado *multiescriptalismo*.

También se eligió SKOS para la modelización de este módulo dado el modelo jerárquico obvio de las entidades geopolíticas.

FIXME

## Áreas científicas

Así, dominios como las [**Áreas científicas**](http://www.ciencia.gob.es/stfls/MICINN/Ayudas/PE_2013_2016/PE_Promocion_e_Incorporacion_Talento_y_su_Empleabilidad/FICHEROS/SE_Incorporacion/Ayudas_contratos_RYC_2016/Clasificacion_areas_cientificas_2016_AEI.pdf) que propone la Agencia Estatal del investigación de los ministerios de ciencia e innovación  y el de universidades, propuesto en el documento de preguntas de competencia suministrado por la Universidad de Murcia. Ese documento, que ofrece una estructura jerárquica clara de dominios y subdominios está siendo modelizado como vocabulario controlado de acuerdo al estándar del W3C [SKOS-Core](https://www.w3.org/TR/swbp-skos-core-spec/), que no solo es la solución más idónea para la estructura por niveles de tipo tesauro, en base a las clases `skos:Concept` (para aglutinar conceptos) y `skos:ConceptScheme` (para ordenar esos conceptos en esquemas de conceptos), sino que también proporciona medios para recoger modelos densamente multilingües, como lo demuestra el hecho de que suele ser la solución empleada en los tesauros multilingües de la Unión Europea, como [GEMET]([ttps://www.eionet.europa.eu/gemet/en/about/](https://www.eionet.europa.eu/gemet/en/about/)) o [EuroVoc](https://data.europa.eu/euodp/en/data/dataset/eurovoc).

De este modo, estas 'Áreas científicas' han sido *mejoradas* respecto a la versión ofrecida por el ministerio en diversos aspectos:

- el primer paso ha sido su procesamiento desde un formato de solo lectura, como es el PDF, que se catalogaría simplemente como [*datos enlazados*](https://www.w3.org/DesignIssues/LinkedData.html) de baja calidad o "1 estrella" ("Available on the web (whatever format) *but with an open licence, to be Open Data*"), a un formato de datos abiertos de máxima calidad o "5 estrellas" ("non-proprietary format (e.g. CSV instead of excel), open standards from W3C (RDF and SPARQL) to identify things and link your data to other people’s data to provide context").

- el segundo paso fue explotar plenamente las posibilidades de multilingüismo de SKOS con el fin de internacionalizar y localizar el *dataset*, entendiendo *internacionalizar* y *localizar* como los procesos de diseñar recursos informáticos de manera tal que puedan adaptarse a diferentes idiomas y regiones sin la necesidad de realizar cambios de ingeniería ni en el código porteriores. De esta forma, las etiquetas lingüísticas de las áreas científicas, en el original únicamente disponibles en español, han sido adaptadas un contexto multilingüe que incluye el inglés como *lingua franca*, dos lenguas en contacto con el español por frontera directa, el portugués y el francés, lenguas cooficiales de España como el catalán, el vasco y el gallego, y otras variedades con cierto reconocimiento a nivel regional, como el occitano, el aragonés o el asturiano, estas últimas con un menor desarrollo.

Además de las posibilidades de explotación ontológica que proporciona SKOS, que no deja de ser una ontología a su vez, con respecto al *core* de ASIO, las etiquetas multilingües suponen una materia prima interesante para llevar a cabo muchas pruebas *lingüísticas*.



## Entidades administrativas

El módulo vertical de las entidades administrativas FIXME y se relaciona directamente con la adscripción de los proyectos dentro de los niveles local, regional, nacional e internacional.

El multilingüismo es relevante en este módulo tanto a nivel nacional, siendo España un país con una realidad multilingüe importante y con lenguas cooficiales en varias comunidades autónomas, como a nivel translacional y europeo.

FIXME



Multilingüismo, *multiescriptalismo* y Wikidata/Wikibase
========================================================

El modelo de datos que subyace a los enlaces de Wikibase se basa en "entidades" que incluyen elementos individuales, etiquetas o identificadores para describirlos y *declaraciones* *semánticas* que atribuyen "propiedades" a cada elemento.

En principio, las etiquetas o identificadores soportan potencialmente el tratamiento multilingüe, aunque queda por analizar si este soporte alcanza plenamente para la renderización de los diferentes sistemas de escritura, cómo lo lleva a cabo y si su procedimiento es realmente conforme a los requisitos de la Web Semántica y los principios de Datos Enlazados.

FIXME



Referencias Web
===========

[^1]: http://www.weso.es/MLODPatterns/Opaque_URIs.html

[^2]: http://www.weso.es/MLODPatterns/Label_everything.html

[^3]: http://www.weso.es/MLODPatterns/Multilingual_labels.html

[^4]: http://www.weso.es/MLODPatterns/Linguistic_metadata.html

[^5]: http://lemon-model.net/lemon#

[^6]: https://www.pret-a-llod.eu/

[^7]: http://www.weso.es/MLODPatterns/Multilingual_vocabularies.html

[^8]: Ελληνικός Οργανισμός Τυποποίησης \[Ellīnikós Organismós Typopoíīsīs, \"Hellenic Organization for Standardization\"\]. ΕΛΟΤ 743

    Typopoíīsīs, \"Hellenic Organization for Standardization\"\]. ΕΛΟΤ
    743, 2η Έκδοση \[ELOT 743, 2ī Ekdosī, \"ELOT 743, 2nd ed.\"\]. ELOT
    (Athens), 2001.

[^9]: United Nations Group of Experts on Geographical Names, Working Group on Romanization Systems (2003). *Report on the Current Status of United Nations Romanization Systems for Geographical Names: Greek*. United Nations, New York.

# Referencias bibliográficas

Coulmas, F. (1996). *The Blackwell Encyclopedia of Writing Systems*. Oxford, U.K.: Blackwell Publishers.

Sokolov, Aleksandr Nikolaevich (1972). *Inner Speech and Thought*. Plenum, New York [traducción al inglés de: Соколов, Александр Николаевич. *Внутренняя речь и мышление*]

United Nations Group of Experts on Geographical Names, Working Group on Romanization Systems (2003). *Report on the Current Status of United Nations Romanization Systems for Geographical Names: Greek*. United Nations, New York.

