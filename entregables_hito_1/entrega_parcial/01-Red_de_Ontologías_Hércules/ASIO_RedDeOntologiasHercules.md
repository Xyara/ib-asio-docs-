![](./images/logos_feder.png)

# 0. About this document

This document reports the current status of the ASIO ontology files and more specifically it describes *grosso modo* three of the files currently available in our repositories, namely:

- [asio-demo.ttl](https://git.izertis.com/universidaddemurcia/semantmurc/asio-docs/blob/master/entregables_hito_1/01-Red_de_Ontolog%C3%ADas_H%C3%A9rcules/asio-demo.owl)
- [asio-mappings.ttl](https://git.izertis.com/universidaddemurcia/semantmurc/asio-docs/blob/master/entregables_hito_1/01-Red_de_Ontologías_Hércules/asio-mappings.ttl)
- [asio-vertical-module-geopolitical.ttl](https://git.izertis.com/universidaddemurcia/semantmurc/asio-docs/blob/master/entregables_hito_1/01-Red_de_Ontologías_Hércules/asio-vertical-module-geopolitical.ttl)

The first one is the ***core*** ontology and the second one corresponds to the class-by-class ***alignements*** towards external vocabularies

In addition to these two files, a number of ***vertical modules*** are going to be released little by little. An early release is the **geopolitical module** (the third file listed above) including so far just the geopolitical entities of Andorra, Spain and Portugal (France is the other country to be taken into account in this vertical module in the next update). At the moment of this writing, three more vertical modules are almost ready to be released, as we will see in the section devoted to these modules.

Keep in mind that both this document and the ontology files are a **work in progress** and the deadline to deliver the 80% of the specification is mid May, so there might still be some inconsistencies, imperfections, potential improvement and relevant addings.



# 1. Introduction

The ASIO ontologies are standardised data schemas (or "vocabularies") designed to address the Research Management of the particular case of the University of Murcia but by applying an encompassing model capable of addressing too other universities both at the national level and at the international level.

In this brief section we are going to explain the large-scale organization of the ASIO ontology, which is split into a central and peripheral components, loosely inspiring ourselves in Fodor (1983). To do so we need to distinguish between two fundamentally different types of information processing (relying upon information architecture and datasets).

On the one hand, there are highly-specialised information-processing tasks, such as identifying and retrieving data from specific environments. Informational-based tasks in these specific environments should be carried out automatically and should involve only a limited type of information. That is why information retrieval tasks having to do with this first type of information are carried out by dedicated parts of the ontology that we call ***modules***. These modules are *domain-specific* –that is, they are responsible only for tasks falling in particular domains (geopolitical, scientific, administrative, staffing, etc.).

On the other hand, there are central informational tasks that involve much more complex and wide-ranging inferences and to which an indefinite amount of background information is potentially relevant. The information processing involved in carrying out these tasks is *domain-general* (conversely to domain-specific) and it concerns our main *university domain* (our ***core***), because we understand *general* here as our general domain.

On the basis of this distinction, we develop an architecture of the ontological organization as involving both very specialized modules (***vertical modules***) and what we call domain-general, non-modular knowledge (***core ontology***). Two properties of modularity in particular, *informational encapsulation* and *domain specificity*, make it possible to tie together questions of functional architecture with those of knowledge content.



# 2. Core ontology

## 2.1. prolegomena

In any informational system, in this case an ontology, there must be non-modular processing –or what we call central processing, to distinguish it from modular processing, which is peripheral (our vertical modules).

To say that a part of the ontology is core (i.e. involves central processing actions) is, essentially, to say that it is not informationally encapsulated (as the vertical modules). In principle, any part of the system is relevant to confirming any other and we do not draw boundaries within it.



## 2.2. the core ontology at a glance

In this draft doccument due to time limitation, we are just going to show the reader the classes through a screenshot from Protégé and a diagram showing some of the classes and properties in use.

These are the full list of classes (available also in the [LODE](https://essepuntato.it/lode/) generated HTML file accompaning this document), with the miniature on the left shwing just the superclasses and the two in the central and right part of the illustration the whole list of classes:



![1st-example](./images/core-deployed.png)



An example loosely coming from one of competence questions shows how some of these classes, through instances are related:



![1st-example](./images/glance1.png)



**DISCLAIMER about the properties**: Properties, from both the object and data type, are still a work in progress and the assignation of domains and ranges are often neglected at this stage of the implementation. Domains and ranges are delicate matter with respect to the ontological commitments of the vocabulary and must be still studied.



## 2.3. imported vocabularies

Two external vocabularies are imported to deal with specific-knowledge domains of relevance for the project:

- [Research object](https://wf4ever.github.io/ro/2016-01-28/)

- [SWEET Ontology Human Technology Readiness](https://esipfed.github.io/stc/sweet_lode/humanTechReadiness.html)

These two vocabularies are used by the ASIO ontology to relate the core ontology and its clases to two  entities that currently are pivotal to university research projects. 

**Research objects** aggregate a number of resources that are used and/or produced in a given scientific research and in the ASIO ontology are linked to the scientific domains described in the eponymous, ad hoc vertical module described later on. The [RO](https://wf4ever.github.io/ro/2016-01-28/) ontology is mapped to the ASIO ontology through the property `asio:hasScientificDomain`.

The **technology readiness levels (TRLs)**, initially developed at NASA during the 1970s and from there included by the European Commission's EU Horizon 2020 program (Mihaly, 2017), are a method for estimating the maturity of technologies during the acquisition phase of a program. They condition therefore any European project proposal and development and are currently a critical factor for research projects. The ASIO ontology takes advantage of this mini-ontology part of the SWEET ontology family by importing it. The SWEET [HTR](https://esipfed.github.io/stc/sweet_lode/humanTechReadiness.html) ontology is mapped to the ASIO ontology through the property `asio:hasTRL`.

We can consider a temporary and sui generis semi-importation the usage of some classes and object properties belonging to the [ORKG ontology](https://gitlab.com/TIBHannover/orkg/orkg-ontology/-/blob/master/orkg-core.ttl) that we included in the core ontology, all of them having to do with research. These entities are included as a first approach in order to enable a collaboration with the people responsible for that vocabulary, with whom we are in contact.



## 2.4. multilingualism in the core ontology

The entire list of classes in the core ontology is enriched multilingually via the data property `rdfs:label` and, besides the two obvious working languages (English, Spanish), three more languages are included: Catalan, French and Portuguese, as corresponding to the three other countries that we take into account in addition to Spain for geographically modelling our domain: Andorra, France and Portugal.

The motivation of this choice is, on the one hand, geopolitical, as Catalan, French and Portuguese are languages in contact with Spanish through land borders (Andorra, France, Portugal) and, on the other hand, practical, as those three languages are more or less mastered by members of the development team, something that ensures a *direct* multilingual treatment. Note that Catalan is also a coofficial language in some Autonomous Communities of Spain.

The Iberian peninsula as a *multilingual* whole, besides English as a *lingua franca* and French as a relevant neighboring language, is taken hence as a *scale model* of the multilingual nature of the European Union, and *exploited* as an intuitive advancement from the ultralocal reality to the global context, something that the British sociologist Roland Robertson coined *glocalization* (Kumaravadivelu, 2008:45).

In that sense, the labels in the Western *killer* *languages*, a concept we take from Anne Pakir (Skutnabb-Kangas, 2000), such as English, French, Portuguese and Spanish, are dealt with specificifying *locales* when necessary and/or applicable (en-GB, en-US, fr-FR, fr-CA, pt-PT, pt-BR, es-ES, es-MX, es-AR, etc).

Let's have a look at one example corresponding to the class **Master's thesis**:

```
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



# 3. Alignements with other vocabularies

In addition to reusing specific classes and properties or importing full external vocabularies of interest, as described above, the ASIO ontology also provides mappings to classes considered equivalent to the ones defined in the specification.

To do so, the second file ([asio-mappings.ttl](https://git.izertis.com/universidaddemurcia/semantmurc/asio-docs/blob/master/entregables_hito_1/01-Red_de_Ontologías_Hércules/asio-mappings.ttl)) gathers together a thorough study of equivalent classes belonging to related vocabularies and maps them to the ASIO vocabulary via the OWL property `owl:equivalentClass`. This property is safer than the *risky* property `owl:sameAs`, which logical implications might wreak havoc because of undesired inheritances and collateral damages.

The same applies to relevant properties belonging to concurrent vocabularies, which are being mapped in this file using `owl:equivalentProperty`.

More details about these alignments, carried out following consolidated recommendations (Vandenbussche et al.: 2014), will be provided in more consolidated documentation to be generated soon, but right now it suffices to access the file using a source code editor and have a look at the large list of equivalences, chiefly focusing on concomitant vocabularies such as CERIF, VIVO or the SPAR family of ontologies but also going beyond these ones.



# 4. Vertical modules

As far as the **vertical modules** are concerned another three final candidates are being implemented so far, in particular:

- geopolitical entities
- administrative entities
- scientific domains
- Spain's university staffing

However, in this first version of the document we describe with some detail just the first and the third vertical modules (*geopolitical entities* and *scientific domains*).

The vertical modules are the ideal playground for testing multilingualism and multiscriptalism.



## 4.1. geopolitical entities

As we mentioned at the beginning of this document, the more advanced vertical module so far, already released in an early version, is the geopolitical one. It covers at the moment the geopolitical subdivisions of:

- Andorra: implementing just the first-level subdivisions (*parròquies*)
- Portugal: implementing both the first (*distritos e regiões*) and the second-level (*municípios*) subdivisions.
- Spain: covering the first (*comunidades autónomas*), the second (*provincias*) and the third-level subdivisions (*municipios*).

At the moment of this writing France and its subdivisions (*régions* and *départements*) are being transformed and is expected to be released in the next weeks, linked to the other datasets.

SKOS-Core was also chosen to model a clearly hierarchical domain and the dataset is massively enriched multilingually and ponderously linked to relevant national and international vocabularies. 

The main goal of this vertical module, which is in a way also transversal, is to geopolitically *locate* agents, organizations and other resources included in the ASIO ontology with an encompassing granularity.



## 4.2. administrative entities

This vertical module is designed to encompass all the relevant entities belonging to Spain's *administración autonómica* related to the geopolitical subdivisions of the previous vertical module, to which they are going to be seamlessly linked.

It is, at the moment of this writing, a work in progress but the implementation so far includes the first-level bodies of *administración autonómica* (*conserjerías*), as available at Spain's administration portal [[1]](https://administracion.gob.es/pagFront/espanaAdmon/directorioOrganigramas/comunidadesAutonomas/comunidadesAutonomas.htm?idCCAA=14), and the second-level [[2]](https://administracion.gob.es/pagFront/espanaAdmon/directorioOrganigramas/fichaUnidadOrganica.htm?idUnidOrganica=123276&origenUO=comunidadesAutonomas&volver=comunidadesAutonomas&idCCAA=14), mainly *direcciones generales* and *consorcios*.

The implementation of this vertical module is also carried out using SKOS-Core.



## 4.3. scientific domains

**Note** that this vertical module is being implemented at the moment and it is not included in this release but, as it is already designed, we include already documentation about it. The transformation of the tabular data will be carried out in the next weeks so to be *plugged in* as vertical module, similarly to the geopoolitical one.

### 4.3.1 prolegomena

The [Spain's Ministry of Science, Innovation and Universities](http://www.ciencia.gob.es/), through its [State Research Agency](http://www.ciencia.gob.es/portal/site/MICINN/menuitem.8d78849a34f1cd28d0c9d910026041a0/?vgnextoid=664cfb7e04195510VgnVCM1000001d04140aRCRD), published a document featuring a number of [**Scientific domains**](http://www.ciencia.gob.es/stfls/MICINN/Ayudas/PE_2013_2016/PE_Promocion_e_Incorporacion_Talento_y_su_Empleabilidad/FICHEROS/SE_Incorporacion/Ayudas_contratos_RYC_2016/Clasificacion_areas_cientificas_2016_AEI.pdf) which are the basis for several ones among the competence questions provided by the University of Murcia in order to model the ontology.

### 4.3.2. modelling & transformation

After a thorough analysis of that document, a clear hierarchical structure of domains and subdomains was identified and it was deemed as seamlessly fitting a thesaurus-like structure and hence suitable to be ontologically transformed using the W3C's standard for controlled vocabularies: [SKOS-Core](https://www.w3.org/TR/swbp-skos-core-spec/).

SKOS-Core is not just the most appropriate solution for such a document featuring a level-structure thesaurus-like fully exploiting its classes `skos:Concept` (for *agglutinating* concepts) and `skos:ConceptScheme` (in order to arrange concepts *knitting* them together into schemes of concepts), but it also provides means to include models densely multilingual, as checkable with some European thesauri such as [GEMET]([ttps://www.eionet.europa.eu/gemet/en/about/](https://www.eionet.europa.eu/gemet/en/about/)) or [EuroVoc](https://data.europa.eu/euodp/en/data/dataset/eurovoc).

### 4.3.3. added value

Hence, besides being able to seamlessly *assimilate* these **Scientific domains** within the ASIO ontology through an *ad hoc*, vertical module, we have improved the Ministry's document in a number of ways:

- processing and transforming it from an only-reading format (PDF), which would be categorised as simply [linked data](https://www.w3.org/DesignIssues/LinkedData.html) of low-quality or 1-star ("Available on the web (whatever format) *but with an open licence, to be Open Data*"), to a high-quality, or [5-star quality](https://www.w3.org/community/webize/2014/01/17/what-is-5-star-linked-data/), linked data format ("non-proprietary format (e.g. CSV instead of excel), open standards from W3C (RDF and SPARQL) to identify things and link your data to other people’s data to provide context").
- exploiting the full possibilities of multiligualism provided by SKOS with the aim of internationalising and localising the dataset, understanding here *internationalising* and *localising* as the processes to design an IT resource as fully adaptable to different languages and regions without later having to reengineering or changing the code. This way, the language labels for the scientific domains, originally just in Spanish, have been adapted to a multilingual context which not only covers English as *lingua franca* but also three languages in contact with Spanish through land borders (Catalan, French and Portuguese) and a number of cooficial regional languages (the aforementioned Catalan but also Basque and Galician) and even some linguistic varieties with a certain recognition at regional level (Aragonese, Asturian, Occitan).

An graphical example of the preprocesse file corresponding to the first-level of the scientific domains can be seen here:

![1st-example](./images/sc-do-1st.png)

where still in a tabular format we can check out a first column with codes that will be used in the opaque URIs of the concepts and the encompassing multilingual labels in Aragonese, Asturian, Catalan, English, Spanish, Extremaduran, Basque, French, Galician, Occitan, Portuguese, phonetic transcription of Spanish according to the Spain locale, phonetic transcription of English according to the British locale and phonetic transcription of English according to the General American locale.

In addition to the ontological possibilities offered by SKOS (which is itself an ad hoc ontology) with respect to the ASIO core ontology, these mentioned multilingual labels provide idoneous raw materials to carry out extensively testing with respect to multilingualism, as detailed in the previous section and in a complementary deliverable (*ModeloMultilinguismo*).



## 4.4. Spain's university staffing

Finally, all the specificities of the teaching-and-research positions in the universities of Spain are dealt with in this vertical module, which is still a **work in progress**.

Following a number of informal interviews with informants directly linked to the domain, we have started to gather together an alluvium of entities:



![1st-example](./images/hr-tea&res-pers.png)

As a **disclaimer** we must warn the reader that these entities are not at all final candidates to populate the vertical module: they are just a starting point in the modelling and just the result of an initial brainstorm carried out in one specific university. They will be contrasted with equivalent entities in the university of Murcia, other universities and, obviously, with reference documents such as the [Ley Orgánica de Universidades](https://www.boe.es/buscar/pdf/2001/BOE-A-2001-24515-consolidado.pdf
) and the [Estatuto Básico del Empleado Público](https://www.boe.es/buscar/act.php?id=BOE-A-2015-11719
).





# 5. References

Fodor, J. A. (1983). *The modularity of mind*. Bradford/MIT Press, Cambride, Mass. 

Kumaravadivelu, B. (2008). *Cultural Globalization and Language Education*. Yale University Press.

Mihaly, Heder (2017). "From NASA to EU: the evolution of the TRL scale in Public Sector Innovation". *The Innovation Journal*. 22: 1–23.

Skutnabb-Kangas, T. (2000). *Linguistic Genocide in Education*. New Jersey: Lawrence Erlbaum Associates Inc.

Vandenbussche, P.; Atemezing, G.; Poveda-Villalón, M.; Vatant, B. (2014). *Pierre-Yves V. et al. / LOV: a gateway to reusable semantic vocabularies on the Web*. (article, IOS Press, 2014), DOI: 8. 437-452. 10.3233/SW-160213, available at [Semantic Web Journal](http://www.semantic-web-journal.net/system/files/swj1127.pdf).



