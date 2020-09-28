![](./images/logos_feder.png)

| Entregable                       | Red de ontologías Hércules                                   |
| -------------------------------- | ------------------------------------------------------------ |
| Fecha                            | 25/05/2020                                                   |
| Proyecto                         | [ASIO](https://www.um.es/web/hercules/proyectos/asio) (Arquitectura Semántica e Infraestructura Ontológica) en el marco de la iniciativa [Hércules](https://www.um.es/web/hercules/) para la Semántica de Datos de Investigación de Universidades que forma parte de [CRUE-TIC](https://tic.crue.org/hercules/) |
| Módulo                           | Infraestructura Ontológica                                   |
| Tipo                             | Documento                                                    |
| Objetivo                         | Este documento recoge en inglés la especificación de las ontologías Hércules. |
| Estado                           | **80%**. El estado del documento se ajusta al 80% comprometido para el hito 1 del proyecto. |
| Próximos pasos                   | La ontología va a ir evolucionando aún a lo largo de lo que resta del proyecto con el objetivo de ajustarse al 20% restante y este documento será asimismo documentación de partida en esa evolución. Este 20% restante se deducirá del par de preguntas de competencia no respondidas completamente (fraude, ética), de la información de los datasets proporcionados por la Universidad de Murcia que no haya sido recogida en las preguntas de competencia y de nuevos subdominios que se crean necesarios a partir de la interacción con la Universidad de Murcia. |
| Repositorio de software asociado | The current working space for the ASIO ontologies can be accessed [here](https://github.com/HerculesCRUE/ib-hercules-ontology). |



# Ontology specification

## 0. About this document

This document reports the current status of the ASIO ontology files and more specifically it describes *grosso modo* the nine files currently available in our repositories, namely:

1. [asio-core.ttl](../01-Red_de_Ontologías_Hércules/asio-core.ttl)
2. [asio-mappings.ttl](../01-Red_de_Ontologías_Hércules/asio-mappings.ttl)
3. [asio-module-geopol.ttl](../01-Red_de_Ontologías_Hércules/asio-module-geopol.ttl)
4. [asio-module-scientificdomains.ttl](../01-Red_de_Ontologías_Hércules/asio-module-scientificdomains.ttl)
5. [asio-module-subjectareas.ttl](../01-Red_de_Ontologías_Hércules/asio-module-subjectareas.ttl)
6. [asio-module-universities.ttl](../01-Red_de_Ontologías_Hércules/asio-module-universities.ttl)
7. [asio-module-universityhr-es](../01-Red_de_Ontologías_Hércules/asio-module-universityhr-es.ttl)
8. [asio-module-universityhr-pt](../01-Red_de_Ontologías_Hércules/asio-module-universityhr-pt.ttl)
9. [asio-module-universityhr-uk](../01-Red_de_Ontologías_Hércules/asio-module-universityhr-uk.ttl)

The first one is the ***core*** ontology and the second one corresponds to the class-by-class ***alignements*** towards both external vocabularies and also between individuals within the vertical modules.

In addition to these two files, a number of ***vertical modules*** have being released at the moment of this writing. The earliest release was the **geopolitical module** (the third file listed above) including so far the full list of world's countries, the geopolitical entities of Andorra, Spain and Portugal (France is the other country to be taken into account in this vertical module in the next update).

Two other vertical modules, related within each other, are the **scientific domains** and the **subject areas**, 4th and 5th respectively. Both are controlled vocabularies including scientific domains and fields used in different requirements by the core ontology.

The sixth vertical module, **universities**, includes the full list of universities from Spain as well as a limited sample of university subdivisions (centres, campus, faculties, etc.) corresponding to the Murcia, Oviedo, Santiago de Compostela and Basque country universities.

Finally, the 7th, 8th and 9th files corresponds to **human resources** belonging to the university systems of Spain, Portugal and the United Kingdom.

In addition to that, the last section of this document includes an annex with a number of competence questions which can be solved with the ontology. The answers to those questions includes direct links to discussion issues and SPARQL queries for each one of them.

The current working space for the ASIO ontologies can be accessed [here](https://github.com/HerculesCRUE/ib-hercules-ontology).


## 1. Introduction

The ASIO ontologies are standardised data schemas (or "vocabularies") designed to address the Research Management of the [CRUE](https://tic.crue.org/hercules/)'s Spanish University System (Sistema Universitario Español) through the particular case of the University of Murcia but always applying an encompassing model capable of addressing the rest of universities of the CRUE and even more belonging to the European level.

In this brief section we are going to explain the large-scale organization of the ASIO ontology, which is split into a central and peripheral components, loosely inspiring ourselves in Fodor (1983). To do so we need to distinguish between two fundamentally different types of information processing (relying upon information architecture and datasets).

On the one hand, there are highly-specialised information-processing tasks, such as identifying and retrieving data from specific environments. Informational-based tasks in these specific environments should be carried out automatically and should involve only a limited type of information. That is why information retrieval tasks having to do with this first type of information are carried out by dedicated parts of the ontology that we call ***modules***. These modules are *domain-specific* –that is, they are responsible only for tasks falling in particular domains (geopolitical, scientific, administrative, staffing, etc.).

On the other hand, there are central informational tasks that involve much more complex and wide-ranging inferences and to which an indefinite amount of background information is potentially relevant. The information processing involved in carrying out these tasks is *domain-general* (conversely to domain-specific) and it concerns our main *university domain* (our ***core***), because we understand *general* here as our general domain.

On the basis of this distinction, we develop an architecture of the ontological organization as involving both very specialized modules (***vertical modules***) and what we call domain-general, non-modular knowledge (***core ontology***). Two properties of modularity in particular, *informational encapsulation* and *domain specificity*, make it possible to tie together questions of functional architecture with those of knowledge content.



## 2. Core ontology

### 2.1. prolegomena

In any informational system, in this case an ontology, there must be non-modular processing –or what we call central processing, to distinguish it from modular processing, which is peripheral (our vertical modules).

To say that a part of the ontology is core (i.e. involves central processing actions) is, essentially, to say that it is not informationally encapsulated (as the vertical modules). In principle, any part of the system is relevant to confirming any other and we do not draw boundaries within it.



### 2.2. the core ontology at a glance

In this section, we are going to show the reader the classes through a screenshot from Protégé and some diagrams showing some of the classes and properties in use in a number of examples.

These are the full list of classes (available also in the [LODE](https://essepuntato.it/lode/) generated HTML file accompaning this document), with the miniature on the left shwing just the superclasses and the two in the central and right part of the illustration the whole list of classes:



![1st-example](./images/core-deployed.png)

The first column in the left, shows the first-level classes, under *owl:Thing*, without specifying subclasses. The central column shows the subclasses of the upper-level part of the first column, and, finally, the column in the right deploys the subclasses of the lower-levelclasses part of the first column.
This figure illustrates hence in a non-orthodox way the entire list of classes included in the ASIO ontology, however, as the number is quite extensive, in this document we are going to showcase just some *theme* examples by providing classes, instances and properties in specific contexts.

For instance, the participation in a project by a consortium of a company and a research group belonging to a university can be grasped by the following figure:

![1st-example](./images/project-participation.png)

where the specific case of the Hércules project is illustrated and both participants, a company such as Izertis and a research group from the University of Oviedo, WESO, are highlited.

As far as the different profiles and roles of a person are concerned, the next figure illustrates how a single person can play different roles:

![1st-example](./images/roles.png)

Person Daniel can seamlessly have a twofold role: a teaching role and a researching one, which can co-exist for that given individual. Besides that, thanks to the class *asio:Profile*, not featured in the diagram, a given person can combine and/split her different profiles according to a given context (class *asio:Context*).

Several other parts of the core ontology could be illustrated here by means of figures but, as we already include an extensive annex with competences questions answered through SPARQL queries, we are not going to be exhaustive here.

As a final *graphical* example we are going to elaborate how the core ontology deals with a Patent shows the classes (Patent, Person, Organization), object and data properties involved in the modelling:



![1st-example](./images/patent.png)


In this example, an instance of the class *asio:Patent*, the "SELF-GENERATING AUTOMATIC CODE GENERATOR", is linked to some people:

* its inventor, Nelson H. Lin
* its primary examiner, Jean-Pierre Peguy (a key person in any patent assessment)
* Jean-Pierre Peguy's assistant, (another key person in any patent assessment)

and also to a patent assignee, in this case the company Robocoder Corporation.
On the other hand, any patent has always a patent number, a patent application number, a date, a nationality, etc.

As we already aforementioned, we are currently studying the segmentation of the core ontology into horizontal modules and it is precisely the part involving patents a clear candidate to integrate an *ad hoc* horizontal module, given its autonomous nature. Other theme areas show as well some topic independence, and in future releases of the core, these areas will be *severed* and separate.



### 2.3. imported vocabularies

Two external vocabularies are imported to deal with specific-knowledge domains of relevance for the project:

- [Research object](https://wf4ever.github.io/ro/2016-01-28/)

- [SWEET Ontology Human Technology Readiness](https://esipfed.github.io/stc/sweet_lode/humanTechReadiness.html)

These two vocabularies are used by the ASIO ontology to relate the core ontology and its clases to two  entities that currently are pivotal to university research projects. 

**Research objects** aggregate a number of resources that are used and/or produced in a given scientific research and in the ASIO ontology are linked to the scientific domains described in the eponymous, ad hoc vertical module described later on. The [RO](https://wf4ever.github.io/ro/2016-01-28/) ontology is mapped to the ASIO ontology through the property `asio:hasScientificDomain`.

The **technology readiness levels (TRLs)**, initially developed at NASA during the 1970s and from there included by the European Commission's EU Horizon 2020 program (Mihaly, 2017), are a method for estimating the maturity of technologies during the acquisition phase of a program. They condition therefore any European project proposal and development and are currently a critical factor for research projects. The ASIO ontology takes advantage of this mini-ontology part of the SWEET ontology family by importing it. The SWEET [HTR](https://esipfed.github.io/stc/sweet_lode/humanTechReadiness.html) ontology is mapped to the ASIO ontology through the property `asio:hasTRL`.

We can consider a temporary and sui generis semi-importation the usage of some classes and object properties belonging to the [ORKG ontology](https://gitlab.com/TIBHannover/orkg/orkg-ontology/-/blob/master/orkg-core.ttl) that we included in the core ontology, all of them having to do with research. These entities are included as a first approach in order to enable a collaboration with the people responsible for that vocabulary, with whom we are in contact.



### 2.4. multilingualism in the core ontology

The entire list of classes in the core ontology is enriched multilingually via the data property `rdfs:label` and, besides the two obvious working languages (English, Spanish), three more languages are included: Catalan, French and Portuguese, as corresponding to the three other countries that we take into account in addition to Spain for geographically modelling our domain: Andorra, France and Portugal.

The motivation of this choice is, on the one hand, geopolitical, as Catalan, French and Portuguese are languages in contact with Spanish through land borders (Andorra, France, Portugal) and, on the other hand, practical, as those three languages are more or less mastered by members of the development team, something that ensures a *direct* multilingual treatment. Note that Catalan is also a coofficial language in some Autonomous Communities of Spain.

The Iberian peninsula as a *multilingual* whole, besides English as a *lingua franca* and French as a relevant neighboring language, is taken hence as a *scale model* of the multilingual nature of the European Union, and *exploited* as an intuitive advancement from the ultralocal reality to the global context, something that the British sociologist Roland Robertson coined *glocalization* (Kumaravadivelu, 2008:45).

In that sense, the labels in the Western *killer* *languages*, a concept we take from Anne Pakir (Skutnabb-Kangas, 2000), such as English, French, Portuguese and Spanish, are dealt with specificifying *locales* when necessary and/or applicable (en-GB, en-US, fr-FR, fr-CA, pt-PT, pt-BR, es-ES, es-MX, es-AR, etc).

Let's have a look at one example corresponding to the class **Master's thesis**:

```turtle
###  http://www.asio.es/asioontologies/asio#MastersThesis
asio:MastersThesis rdf:type owl:Class ;
                   rdfs:subClassOf asio:Thesis ;
                   owl:disjointWith asio:PhDThesis ;
                   rdfs:comment "A thesis reporting a research project undertaken as part of an undergraduate course of education to receive a master's degree."@en ;
                   rdfs:label "Dissertação de mestrado"@pt-PT ,
                              "Dissertação de mestrado"@pt-BR ,
                              "Tese de mestrado"@pt-AO ,
                              "Master's thesis"@en ,
                              "Mémoire de maîtrise"@fr-FR ,
                              "Mémoire de maîtrise"@fr-BE ,
                              "Mémoire de maîtrise"@fr-CH ,
                              "Mémoire de maîtrise"@fr-CA ,
                              "Trabajo de fin de máster"@es-ES ,
                              "Tesis de fin de máster"@es-PY ,
                              "Tesis de maestría"@es-MX ,
                              "Tesis de maestría"@es-AR ,
                              "Tesis de maestría"@es-CO ,
                              "Tesis de maestría"@es-CU ,
                              "Tesis de magíster"@es-CL ,
                              "Treball de fi de màster"@ca-ES ,
                              "Treball de fi de màster"@ca-AD .
```

As we can see in the code snippet, for the case of this class, the Portuguese language does not show differences bewteen the Portugal and the Brasil locales (both use *dissertação de mestrado*) but its Angolan locale does distinguish itself (*Tese de mestrado*). In the case of the francophone locales for France, Belgium, Switzerland and Canada (Québec), they all match the *Mémoire de maîtrise* denomination. The same applies to the Anglo-Saxon world, for which we don't specify locale.

In Spanish though the situation varies and we specify the Spain locale, *Trabajo de fin de máste*r, with a sad linguistic calque from English (*máster*), from the locales for Mexico, Argentina, Colombia or Cuba, more genuine linguistically speaking (*maestría*), or the case of Chile (*magíster*), more latinazing.

Obviously, the granularity of detail regarding ***i18n*** and ***L10n*** applied to the core ontology in this release is still far from being concluded and at the time of this writing more candidate labels (preferent and alternative) and locales are being analysed and are expected to be included in the May release of the ontology.



## 3. Alignements with other vocabularies

In addition to reusing specific classes and properties or importing full external vocabularies of interest, as described above, the ASIO ontology also provides mappings to classes considered equivalent to the ones defined in the specification.

To do so, the second file ([asio-mappings.ttl](asio-mappings.ttl)) gathers together a thorough study of equivalent classes belonging to related vocabularies and maps them to the ASIO vocabulary via the OWL property `owl:equivalentClass`. This property is safer than the *risky* property `owl:sameAs`, which logical implications might wreak havoc because of undesired inheritances and collateral damages.

The same applies to relevant properties belonging to concurrent vocabularies, which are being mapped in this file using `owl:equivalentProperty`.

More details about these alignments, carried out following consolidated recommendations (Vandenbussche et al.: 2014), will be provided in more consolidated documentation to be generated soon, but right now it suffices to access the file using a source code editor and have a look at the large list of equivalences, chiefly focusing on concomitant vocabularies such as CERIF, VIVO or the SPAR family of ontologies but also going beyond these ones.

In addition to these external mappings, the file also contains some *inner* ones. An example of this would be the human resources from some university national systems included in the corresponding vertical modules. The mappings are still state-of-the-art ones as studying and comparing the academic reality of new countries demands a thorough analysis that was not within the reach of this first milestone of the project. However, mappings between academic positions from Spain and Portugal are provided and also matching positions available in the VIVO ontology. As exact matches for these positions are difficult to provide, even among similar countries such as Spain and Portugal, most of the samples exploit the SKOS property `skos:closeMatch`.



## 4. Vertical modules

As far as the **vertical modules** are concerned another five final candidates are being implemented so far, in particular:

- geopolitical entities
- administrative entities
- scientific domains
- subject areas
- Spanish universities
- human resources from some national university systems (Spain, Portugal and others)

An extra vertical module, called *Spain's university staffing*, is currently located within the core ontology as instances of the class `asio:Role`, but it is currently being migrated as an independent vertical module, so other equivalent university staffing from other countries can be plugged in an easier way by replicating the provided framework and populating it with the reality of, for instance, Portugal's university staffing or France's.

On the other hand, the vertical modules are the ideal playground for testing multilingualism and multiscriptalism, as, just as an example, the geopolitical module is fully multilingual (as well as *mutilocale* and *multiscriptalist*).



### 4.1. geopolitical entities

As we mentioned at the beginning of this document, the more advanced vertical module so far, already released in an early version, is the geopolitical one. It currently covers the full list of countries and the geopolitical subdivisions of:

- Andorra: implementing just the first-level subdivisions (*parròquies*)
- Portugal: implementing both the first (*distritos e regiões*) and the second-level (*municípios*) subdivisions.
- Spain: covering the first (*comunidades autónomas*) and the second (*provincias*). The third-level subdivisions (*municipios*) are already implemented and ready to be plugged in but have not being added yet.

At the moment of this writing France and its subdivisions (*régions* and *départements*) are being transformed and is expected to be released in the next weeks, linked to the other datasets.

SKOS-Core was also chosen to model a clearly hierarchical domain and the dataset is massively enriched multilingually and ponderously linked to relevant national and international vocabularies. 

The main goal of this vertical module, which is in a way also transversal, is to geopolitically *locate* agents, organizations and other resources included in the ASIO ontology with an encompassing granularity.



### 4.2. scientific domains

**Note** that this vertical module is being implemented at the moment and it is not included in this release but, as it is already designed, we include already documentation about it. The transformation of the tabular data will be carried out in the next weeks so to be *plugged in* as vertical module, similarly to the geopoolitical one.

#### 4.2.1 prolegomena

The [Spain's Ministry of Science, Innovation and Universities](http://www.ciencia.gob.es/), through its [State Research Agency](http://www.ciencia.gob.es/portal/site/MICINN/menuitem.8d78849a34f1cd28d0c9d910026041a0/?vgnextoid=664cfb7e04195510VgnVCM1000001d04140aRCRD), published a document featuring a number of [**Scientific domains**](http://www.ciencia.gob.es/stfls/MICINN/Ayudas/PE_2013_2016/PE_Promocion_e_Incorporacion_Talento_y_su_Empleabilidad/FICHEROS/SE_Incorporacion/Ayudas_contratos_RYC_2016/Clasificacion_areas_cientificas_2016_AEI.pdf) which are the basis for several ones among the competence questions provided by the University of Murcia in order to model the ontology.

#### 4.2.2. modelling & transformation

After a thorough analysis of that document, a clear hierarchical structure of domains and subdomains was identified and it was deemed as seamlessly fitting a thesaurus-like structure and hence suitable to be ontologically transformed using the W3C's standard for controlled vocabularies: [SKOS-Core](https://www.w3.org/TR/swbp-skos-core-spec/).

SKOS-Core is not just the most appropriate solution for such a document featuring a level-structure thesaurus-like fully exploiting its classes `skos:Concept` (for *agglutinating* concepts) and `skos:ConceptScheme` (in order to arrange concepts *knitting* them together into schemes of concepts), but it also provides means to include models densely multilingual, as checkable with some European thesauri such as [GEMET]([https://www.eionet.europa.eu/gemet/en/about/](https://www.eionet.europa.eu/gemet/en/about/)) or [EuroVoc](https://data.europa.eu/euodp/en/data/dataset/eurovoc).

#### 4.2.3. added value

Hence, besides being able to seamlessly *assimilate* these **Scientific domains** within the ASIO ontology through an *ad hoc*, vertical module, we have improved the Ministry's document in a number of ways:

- processing and transforming it from an only-reading format (PDF), which would be categorised as simply [linked data](https://www.w3.org/DesignIssues/LinkedData.html) of low-quality or 1-star ("Available on the web (whatever format) *but with an open licence, to be Open Data*"), to a high-quality, or [5-star quality](https://www.w3.org/community/webize/2014/01/17/what-is-5-star-linked-data/), linked data format ("non-proprietary format (e.g. CSV instead of excel), open standards from W3C (RDF and SPARQL) to identify things and link your data to other people’s data to provide context").
- exploiting the full possibilities of multiligualism provided by SKOS with the aim of internationalising and localising the dataset, understanding here *internationalising* and *localising* as the processes to design an IT resource as fully adaptable to different languages and regions without later having to reengineering or changing the code. This way, the language labels for the scientific domains, originally just in Spanish, have been adapted to a multilingual context which not only covers English as *lingua franca* but also three languages in contact with Spanish through land borders (Catalan, French and Portuguese) and a number of cooficial regional languages (the aforementioned Catalan but also Basque and Galician) and even some linguistic varieties with a certain recognition at regional level (Aragonese, Asturian, Occitan).

An graphical example of the preprocesse file corresponding to the first-level of the scientific domains can be seen here:

![1st-example](./images/sc-do-1st.png)

where still in a tabular format we can check out a first column with codes that will be used in the opaque URIs of the concepts and the encompassing multilingual labels in Aragonese, Asturian, Catalan, English, Spanish, Extremaduran, Basque, French, Galician, Occitan, Portuguese, phonetic transcription of Spanish according to the Spain locale, phonetic transcription of English according to the British locale and phonetic transcription of English according to the General American locale.

In addition to the ontological possibilities offered by SKOS (which is itself an ad hoc ontology) with respect to the ASIO core ontology, these mentioned multilingual labels provide idoneous raw materials to carry out extensively testing with respect to multilingualism, as detailed in the previous section and in a complementary deliverable (*ModeloMultilinguismo*).

### 4.3 subject areas
The same exploitation have been used to created the related vertical module Subject areas, from the same [State Research Agency](http://www.ciencia.gob.es/portal/site/MICINN/menuitem.8d78849a34f1cd28d0c9d910026041a0/?vgnextoid=664cfb7e04195510VgnVCM1000001d04140aRCRD), which is used for slightly different cases with the core ontology, but which was modelled equally following the schema provided by SKOS.


### 4.4. Spanish universities

Another vertical module includes the entire list of the universities of Spain, for which some rich data was retrieved from the [RUCT](https://www.educacion.gob.es/ruct/consultacentros.action?actual=centros) portal.
Initially also modelled using SKOS, it included encompassing *metadata* about each institution, such as specific codes for each centre, multilingual labels when applicable and other information.
It also includes a limited sample of subdivisions (schools, faculties, centres) from the universities of Murcia, Oviedo, Santiago de Compostela and the Basque Country, and it receives as well special care regarding multilingualism, official codes from the Ministry, etc.



### 4.5. human resources from national university systems

A very complex issue to address among national university systems is human resources, specially those belonging to academia. Spain, for instance, shows a wide variety of positions that can be even wider when considering also some peculiarities at regional level. There are very specific cases in Andalusia, Catalonia or the Basque country.

Those Spanish regional peculiarities are specified in this vertical module by means of the property `asio:geodivision`, which maps the resource to our geopolitical vertical module. This way, when no specific geodivision of a country is attached to an academic position, its generaility at the national level is understood. However, when a position is specific to some Autonomous Community of Spain, property `asio:geodivision` specifies it.

Let's have a look at an example: 

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

As we can see, the position "Professor catedràtic laboral" is specified for just Catalonia, as Carreras i Barnés (2012) told us and in the vertical module it comes pointed out through the code line `asio:geoDivision asioModules:ES_DIVISION_LEVEL_1_ES_CT ;`, linking directly to the Autonomous Community of Catalonia in our geopolitical vertical module.

Similar examples, such as the Basque positions *Ivef* and *Nautical* *professors* are delimited in the same way.

On the other hand, equivalent datasets are provided for the case of academic positions in Portugal and the United Kingdom. Portugal has dramatically streamlined the variety of university positions in a very efficient way, as its [Estatuto da carreira docente universitária](https://fne.pt/uploads/documentos/1433262954_9365_ECDU_versao_consolidada.pdf) explains and no complex diversity as the Spanish one is found there.

As far as the UK dataset is concerned, it is limited to the [generality of the universities](https://web.archive.org/web/20181010061700/http://www.impacte.eu/system/files/%5Bsite%3Acurrent-group%5D/uk.pdf) and does not include the Oxford positions, sometimes very specific.

Some rudimentary mappings are provided between academic positions belonging to different countries  to test the model and illustrate the procedure to do so. Obviously, establishing these mappings is not a trivial task, and experts in human resources familiar with the diverses university systems would be the best candidates for that. However, 

An example of a mapping inclusion between a Spanish position and a Portuguese is the following:

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

where the SKOS property `skos:closeMatch` indicates the conceptual proximity of *professors emeriti* from Spain and Portugal. We did not dare to use `skos:exactMatch` without being HR experts.

A similar mapping is provided as far as the code is concerned:

```turtle
asioModules:ES_UNIVERSITY_HR_CODE_ESPLEM
      a       skos:Concept ;
      rdfs:label "ESPLEM" ;
      asio:codeOf asioModules:ES_UNIVERSITY_HR_ESPLEM ;
      skos:closeMatch asioModules:PT_UNIVERSITY_HR_CODE_PTPEM ;
      skos:inScheme asioModules:ESUniversityHumanResourcesCodesList ;
      skos:prefLabel "ESPLEM" .
```

A final note must be added regarding these HRs vertical modules. The type of each of these positions is established as instances of the class `skos:Concept` but also as instances of the class `asio:Role`. This way a conciliation between core instances and an independent, semi-autonomous ontological vertical module (which can be easily unplugged and recycled if necessary) is obtained. Although not used, we took into account the ontology design pattern [AcademicRoles](http://ontologydesignpatterns.org/wiki/Community:AcademicRoles).

Another kind of roles is also included as instances of `skos:Concept` and `asio:Role`, the so-called **administrative ranks** within a university. These are a short and limited list such as *chancellor*, *vice-chancellor*, *dean*, etc. for the UK or *rector*, *decano*, *director de departamento*, *secretario*, etc. for Spain. These individuals are currently included in the HR vertical module or moved in the future into another one more specific dealing with administrative ranks, bearing in mind that Roles, Profiles and Contexts are an area of the core ontology encompassing and well developed.

Finally, it is worth mentioning that there is a property `asio:referenceLaw` specifically used to link a HR position with its corresponding law.



### 4.6. other vertical modules being currently implemented

At the moment of this writing, we are studying the inclusion of more vertical modules. One candidate for milestone 2 could be *Spanish administrative entities*.
This would be implemented to encompass all the relevant entities belonging to Spain's *administración autonómica* related to the geopolitical subdivisions of the previous vertical module, to which they are going to be seamlessly linked.
The implementation of this vertical module will be also carried out using SKOS-Core as it shows a clear hierarchical structure and it will include the first-level bodies of *administración autonómica* (*conserjerías*), as available at Spain's administration portal [[1]](https://administracion.gob.es/pagFront/espanaAdmon/directorioOrganigramas/comunidadesAutonomas/comunidadesAutonomas.htm?idCCAA=14), and the second-level [[2]](https://administracion.gob.es/pagFront/espanaAdmon/directorioOrganigramas/fichaUnidadOrganica.htm?idUnidOrganica=123276&origenUO=comunidadesAutonomas&volver=comunidadesAutonomas&idCCAA=14), mainly *direcciones generales* and *consorcios*.

### 4.7. vertical modules and customization

The bet on SKOS as main solution for these vertical modules (instead of focusing on other models less *accepted* standard-wise, as the aforementioned Lemon) has to do with customization.

The ontological model proposed here leaves all the customizable parts of the ontology specifically within these vertical modules so stakeholders can adapt or add part of their *reality* in an easier way.

Modifying and maintaining an ontology is not something simple or trivial, the consequences of a modification can dramatically affect the whole model ruining it. That is why in this proposal those ad-hoc modifications are limited to these vertical modules, so the core ontology remains always intact or at the mercy of just ontology engineers.

With a structured model such as the one provided by SKOS, the inclusions of new concepts can be carried out in a more safe way and using a SKOS editor can be easily made by stakeholders.

Finally, it is worth mentioning that a design pattern taken into account in this modularisation was [Using SKOS Concept](http://ontologydesignpatterns.org/wiki/Community:Using_SKOS_Concept).



## 5. References

Carreras i Barnés, J. (2012). Avaluació de la qualitat docent i promoció del professorat. Legislació universitària espanyola: modificació de la Llei Orgànica d'Universitats. Professorat contractat permanent (2004-2008). *Temps d’Educació*, 42, p. 201-232. Universitat de Barcelona.

Fodor, J. A. (1983). *The modularity of mind*. Bradford/MIT Press, Cambride, Mass. 

Kumaravadivelu, B. (2008). *Cultural Globalization and Language Education*. Yale University Press.

Mihaly, Heder (2017). "From NASA to EU: the evolution of the TRL scale in Public Sector Innovation". *The Innovation Journal*. 22: 1–23.

Skutnabb-Kangas, T. (2000). *Linguistic Genocide in Education*. New Jersey: Lawrence Erlbaum Associates Inc.

Vandenbussche, P.; Atemezing, G.; Poveda-Villalón, M.; Vatant, B. (2014). *Pierre-Yves V. et al. / LOV: a gateway to reusable semantic vocabularies on the Web*. (article, IOS Press, 2014), DOI: 8. 437-452. 10.3233/SW-160213, available at [Semantic Web Journal](http://www.semantic-web-journal.net/system/files/swj1127.pdf).





## Annex: competence questions and the ontology

This annex provides a list of the competence questions provided by the University of Murcia and the current responses for them by the ASIO ontology.
For each one it is included links to the issue where it was discussed and solved the answer and also to query (sometimes multiple ones) to finally solved the competence question.

### General questions

| Competence question                                          | Comment                                                      |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| CQ01. Como usuario requiero obtener un listado de los centros/estructuras de investigación que trabajan en un área/disciplina específica. | [issue](https://github.com/weso/hercules-ontology/issues/9), [query1](https://tinyurl.com/ycalwrym) & [query2](https://tinyurl.com/yanx4dhq) |
| CQ02. Como usuario requiero obtener un listado de los investigadores de un centro/estructura de investigación de un área/disciplina específica. Este listado podrá filtrarse según el tipo de investigador ya sea docente, personal investigador en formación, etc. | [issue](https://github.com/weso/hercules-ontology/issues/11) & [query](https://tinyurl.com/yal7vbhs) |
| CQ03. Como usuario requiero obtener el Top 10 (o el número que se considere relevante pues será parametrizable) de los investigadores de un centro/estructura de investigación ordenados por el número de citas, número de publicaciones, h-index, etc. en un área/disciplina específica. [*As a user I would like to obtain the Top 10 (or any relevant number, as this would be a parameter) research centers/strutures who have quality seals associated, such as the Severo Ochoa seal*.] | [issue](https://github.com/weso/hercules-ontology/issues/10), [query1](https://tinyurl.com/y7z7dkvx) & [query2](https://tinyurl.com/y7t2gq79) |
| CQ04. Como usuario requiero obtener el Top 10 (o el número que se considere relevante pues será parametrizable) de centros/estructuras de investigación que posean sellos de calidad asociados, por ejemplo: el sello Severo Ochoa. | [issue](https://github.com/weso/hercules-ontology/issues/16), [query1](https://tinyurl.com/st6zmg7) & [query2](https://tinyurl.com/t872gck) |
| CQ05. Como usuario requiero obtener un listado de los centros/estructuras de investigación que hayan realizado proyectos H2020 y/o proyectos del Plan Estatal. | [issue](https://github.com/weso/hercules-ontology/issues/12) & [query](https://tinyurl.com/ybslb9ks) |
| CQ06. Como usuario requiero obtener un listado de la producción científica en un determinado rango de fechas de un centro/estructura de investigación en un área/disciplina. Para cada resultado se incluirán algunos metadatos importantes de la producción como, por ejemplo, DOI, año de publicación, etc. | [issue](https://github.com/weso/hercules-ontology/issues/17) & [query](https://tinyurl.com/y7bb7g54) |
| CQ07. Como usuario requiero obtener una visualización en la que se recoja la distribución de la producción científica española, por ejemplo, de artículos publicados en revistas, según las comunidades autónomas en un rango de años. | [issue](https://github.com/weso/hercules-ontology/issues/13) & [query](https://tinyurl.com/y9frkekn) |
| CQ08. Como usuario requiero comparar comunidades autónomas, universidades, grupos de investigación, etc. en determinados tópicos para identificar cuál es el más competitivo y por qué. | [issue](https://github.com/weso/hercules-ontology/issues/18) & [query](https://tinyurl.com/y9t5oc7a) |
| CQ09. Como usuario requiero obtener un listado de patentes, diseños industriales, etc. de un centro/estructura de investigación en un área/disciplina. | [issue](https://github.com/weso/hercules-ontology/issues/14) & [query](https://tinyurl.com/sph76pz) |
| CQ10. Como investigador y personal no investigador de la universidad requiero obtener un listado de los proyectos adjudicados/desarrollados, de un centro/estructura de investigación, de un área/disciplina, en un determinado año de búsqueda en los que se tenga acceso al detalle de al menos:<br/>○	Nombre del proyecto<br/>○	Palabras claves<br/>○	Tipo de participación: coordinador o participante<br/>○	Tipo de proyecto: competitivo o no competitivo<br/>○	Tipo de financiamiento: público o privado.<br/>○	Tipo de convocatoria: nacional, H2020, etc.<br/>○	Número y listado de personas involucradas en el proyecto<br/>○	Nombre(s) del investigador(s) principal<br/>○	Entregables/memoria del proyecto<br/>○	Producción científica relacionada con el proyecto<br/>○	Entidades colaboradoras/participantes<br/>○	Cuantía<br/>○	etc. | [issue](https://github.com/weso/hercules-ontology/issues/19) & [query](https://tinyurl.com/y8n6upzz) |
| CQ11. Como usuario académico no investigador necesito conocer el tamaño, experiencia y envejecimiento de un área de investigación a escala de universidad, regional, nacional. | [issue](https://github.com/weso/hercules-ontology/issues/15) & [query](https://tinyurl.com/y7wqbxf5) |
| CQ12. Como usuario necesito conocer el porcentaje de participación de un centro/estructura de investigación en proyectos nacionales o europeos. | [issue](https://github.com/weso/hercules-ontology/issues/20) & [query](https://tinyurl.com/y7wassnx) |
| CQ13. Como investigador, personal no investigador de la universidad requiero insertar/modificar los datos relacionados con los proyectos de investigación, incluyendo los entregables que se hayan generado en la fase de propuesta. El usuario tendrá acceso a esta información según el nivel de acceso que se le haya proporcionado previamente según su rol, según niveles de confidencialidad de ser el caso. Entre los datos que se proporcionarán por cada proyecto se tendrá al menos:<br/>○	Nombre del proyecto<br/>○	Palabras claves<br/>○	Tipo de participación de la entidad: coordinador o participante<br/>○	Tipo de proyecto: competitivo o no competitivo<br/>○	Tipo de financiamiento: público o privado<br/>○	Tipo de convocatoria: nacional, H2020, etc.<br/>○	Número y listado de personas involucradas en el proyecto<br/>○	Nombre(s) del investigador(s) principal<br/>○	Entregables/memoria del proyecto<br/>○	Producción científica relacionada con el proyecto<br/>○	Entidades colaboradoras/participantes<br/>○	Cuantía<br/>○	Etc. | [issue](https://github.com/weso/hercules-ontology/issues/21) & [query](https://tinyurl.com/ya6rsov2) |
| CQ14. Como usuario necesito una visualización [filtering] que me permita explorar la información de cada proyecto según los filtros que haya elegido, por ejemplo, por años, por tipo de convocatoria, por cuantía mayor a determinado valor, según un área/disciplina, según la ubicación geográfica, etc. | [issue](https://github.com/weso/hercules-ontology/issues/22), [query1](https://tinyurl.com/y75cshha), [query2](https://tinyurl.com/ya8xu9at) & [query3](https://tinyurl.com/y7hjghso) |
| CQ15. Identificar proyectos con temática y objetivos científicos similares. En este caso, el usuario podrá acceder a visualizaciones comparativas de la información de proyectos similares. | [issue](https://github.com/weso/hercules-ontology/issues/30) & [query](https://tinyurl.com/y6vvpxnc) |
| CQ16. Como usuario necesito una visualización que me permita analizar la evolución de un investigador, conjunto de investigadores o líneas de investigación a través de los resultados de los proyectos realizados. Se podrá hacer una selección de los proyectos a incluir. El usuario podrá acceder a visualizaciones comparativas de la información de investigadores, conjuntos de investigadores o líneas de investigación seleccionados. | [issue](https://github.com/weso/hercules-ontology/issues/23) & [query](https://tinyurl.com/y7qlopbe) |
| CQ17. Como usuario necesito obtener el listado de indicadores con su respectivo valor y unidad de medida (porcentaje, número, etc.) calculados en un periodo de tiempo, ya sea para toda la universidad o para cada centro/estructura de investigación de cada universidad. | [issue](https://github.com/weso/hercules-ontology/issues/32) & [query](https://tinyurl.com/y9nc3kvu) |
| CQ18. Como usuario necesito una visualización de la evolución de indicadores según la línea del tiempo (años, trimestres, etc.) | [issue](https://github.com/weso/hercules-ontology/issues/24) & [query](https://tinyurl.com/y7dpqwg9) |
| CQ19. Como usuario necesito acceder a una predicción de la evolución de indicadores a partir de la serie temporal de sus valores y de las variables existentes en el sistema que se consideren relacionadas, lo cual se podrá parametrizar. | [issue](https://github.com/weso/hercules-ontology/issues/34) & [query](https://tinyurl.com/y7dpqwg9) |
| CQ20. Como usuario necesito detectar tendencias en áreas y líneas investigación a partir de los datos disponibles en Hércules. | [issue](https://github.com/weso/hercules-ontology/issues/25), [query1](https://tinyurl.com/y8hw5ka4) & [query2](https://tinyurl.com/yc6u4kk4) |
| CQ21. Como usuario necesito cuantificar la contribución de cada investigador, línea de investigación, área de conocimiento, centro de investigación, comunidad autónoma, etc. a cada indicador. | [issue](https://github.com/weso/hercules-ontology/issues/35), [query1](https://tinyurl.com/y95snqlg) & [query2](https://tinyurl.com/yd99gxvz) |
| CQ22. Como usuario tengo interés en hacer clusters de líneas y áreas de investigación, investigadores, grupos, centros de investigación, comunidades autónomas, etc. usando como criterio de clasificación uno o varios indicadores de productividad a elegir por el usuario. | [issue](https://github.com/weso/hercules-ontology/issues/26) & [query](https://tinyurl.com/y7ghls52) |
| CQ23. Como usuario investigador y gestor, estoy interesado en conocer qué líneas y áreas de investigación, investigadores, grupos, centros de investigación, comunidades autónomas, etc. presentan desviaciones significativas con respecto a la media de los indicadores de productividad científica. | [issue](https://github.com/weso/hercules-ontology/issues/37) & [query](https://tinyurl.com/y84a6hqp) |
| CQ24. Como decisor tengo interés en conocer el perfil y evolución de la relación de investigación y transferencia de una empresa con un conjunto de centros de investigación en un período de tiempo. | [issue](https://github.com/weso/hercules-ontology/issues/27) & [query](https://tinyurl.com/ybnexbv6) |
| CQ25. Obtener el listado de los trabajos que he dirigido/codirigido ya sean de grado (TFG), máster (TFM), o tesis doctorales. | [issue](https://github.com/weso/hercules-ontology/issues/40), [query1](https://tinyurl.com/y9ao7oh2) & [query2](https://tinyurl.com/y8gxakof) |
| CQ26. Obtener el listado de congresos/workshops y eventos de divulgación científica en los que haya participado indicando el rol que he tenido: organizador, expositor, etc. | [issue](https://github.com/weso/hercules-ontology/issues/28) & [query](https://tinyurl.com/y792383w) |
| CQ27. Obtener el listado de patentes, diseños industriales, etc. que haya registrado como titular o cotitular X o Y persona, Z o K institución. | [issue](https://github.com/weso/hercules-ontology/issues/41), [query1](https://tinyurl.com/y8mut4kf) & [query2](https://tinyurl.com/y7qwh437) |
| CQ28. Obtener el listado de proyectos en los que he participado incluyendo el rol que he desempeñado, por ejemplo, investigador principal. | [issue](https://github.com/weso/hercules-ontology/issues/29) & [query](https://tinyurl.com/y7d5mhn9) |
| CQ29. Obtener el listado de mi producción científica.        | [issue](https://github.com/weso/hercules-ontology/issues/43) & [query](https://tinyurl.com/ybpzquc3) |
| CQ30. Obtener el listado de startup o spin-off que he fundado o de las que he sido socio. | [issue](https://github.com/weso/hercules-ontology/issues/31) & [query](https://tinyurl.com/y7wvwx3n) |
| CQ31. Obtener los indicadores de mi producción científica como, por ejemplo, total de citas, h-index, etc. | [issue](https://github.com/weso/hercules-ontology/issues/45), [query1](https://tinyurl.com/y8hrhopa), [query2](https://tinyurl.com/yadob8vv) & [query3](https://tinyurl.com/yd4yb4xv) |
| CQ32. Visualizar mi trayectoria según la línea del tiempo y parametrizable de acuerdo criterios como, por ejemplo, proyectos, tesis dirigidas/codirigidas, etc. | [issue](https://github.com/weso/hercules-ontology/issues/33) & [query1](https://tinyurl.com/y9egttvw), [query2](https://tinyurl.com/y9tjyb2p) |
| CQ33. Saber si soy apto para solicitar una evaluación relativa al nuevo sexenio de transferencia del conocimiento e innovación  o alguna de las evaluaciones que realiza la ANECA. | [issue](https://github.com/weso/hercules-ontology/issues/48) & [query](https://tinyurl.com/yb3wuzek) |
| CQ34. Introducir ofertas tecnológicas dirigidas a empresas, para lo cual tendré que describir la oferta, asociarle un nivel de madurez (TRL) y asociar evidencias que soporten el nivel de madurez asignado. | [issue](https://github.com/weso/hercules-ontology/issues/36) & [query](https://tinyurl.com/ybqcsynr) |



### Questions involving governmental bodies (ministerial and regional)

| Competence question                                          | Comment                                                      |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| CQ35. Puedo ver el avance justificación técnica y económica de proyectos nacionales/regionales en colaboración entre universidades (agregado y detallado por categoría de gasto)? | [issue](https://github.com/weso/hercules-ontology/issues/49) & [query](https://tinyurl.com/y7h6gmfd) |
| CQ36. Estadísticas: ¿Puedo hacer un ranking de universidades que más fondos han obtenido por temática a nivel nacional o regional? | [issue](https://github.com/weso/hercules-ontology/issues/38) & [query](https://tinyurl.com/ycdodoph) |
| CQ37. Estadísticas: ¿Puedo cuantificar las colaboraciones entre universidades del país o una región? | [issue](https://github.com/weso/hercules-ontology/issues/50) & [query](https://tinyurl.com/yb47ltuq) |
| CQ38. Estadísticas: Puedo ver las publicaciones de un investigador postdoctoral en todas las Universidades de la red. | [issue](https://github.com/weso/hercules-ontology/issues/39) & [query](https://tinyurl.com/y95hnf8g) |
| CQ39. Estadísticas: Financiación atraída en unos años por todos los investigadores del área de conocimiento X. | [issue](https://github.com/weso/hercules-ontology/issues/51) & [query](https://tinyurl.com/ybawax8p) |
| CQ40. Estadísticas: Publicaciones de Universidades andaluzas en colaboración con investigadores fuera de la UE en revistas académicas de impacto. | [issue](https://github.com/weso/hercules-ontology/issues/42) & [query](https://tinyurl.com/y7u55ldf) |
| CQ41. Control de fraude: identificar sinergias entre proyectos financiados a nivel europeo, nacional y/o regional financiados por diferentes entidades. | [issue](https://github.com/weso/hercules-ontology/issues/52) & [query](https://tinyurl.com/y8smzpsv) |

### High-level user's queries

| Competence question                                          | Comment                                                      |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| CQ42. Puedo ver quien tiene ERCs, Marie Curie, etc. ¿De mi centro y otros centros en una temática concreta? | [issue](https://github.com/weso/hercules-ontology/issues/44) & [query](https://tinyurl.com/ybrud663) |
| CQ43. ¿Puedo identificar qué universidades de la red cuentan con la distinción de excelencia Severo Ochoa, María de Maeztu o las equivalentes a nivel regional y por temática? | [issue](https://github.com/weso/hercules-ontology/issues/53) & [query](https://tinyurl.com/ydcnhg5a) |
| CQ44. Estadísticas: ¿Se pueden cuantificar los proyectos en convocatorias competitivas de un grupo de investigación en un rango de años con grupos de investigación de otras Universidades? | [issue](https://github.com/weso/hercules-ontology/issues/46) & [query](https://tinyurl.com/y85sbk8g) |
| CQ45. Investigadores que dirigen tesis en programas de doctorado diferentes a los de su Universidad, y cuántas de esas tesis dirigidas han obtenido mención cum laude. | [issue](https://github.com/weso/hercules-ontology/issues/54) & [query](https://tinyurl.com/yb9uztal) |



### User's queries

| Competence question                                          | Comment                                                      |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| CQ46. Estado del arte: ¿puedo ver los resultados de proyectos por temática concreta de proyectos desarrollados en la red, diferenciando a nivel regional, nacional, europeo? | [issue](https://github.com/weso/hercules-ontology/issues/47) & [query](https://tinyurl.com/ybp5zr73) |
| CQ47. Búsqueda de socios: ¿puedo ver los consorcios de proyectos de otras universidades por proyecto y temática? | [issue](https://github.com/weso/hercules-ontology/issues/55) & [query](https://tinyurl.com/y82v4z4t) |

