![](assets/logos_feder.jpg)

| Entregable     | Control de versiones sobre ontologías OWL                    |
| -------------- | ------------------------------------------------------------ |
| Fecha          | 17/06/2020                                                   |
| Proyecto       | [ASIO](https://www.um.es/web/hercules/proyectos/asio) (Arquitectura Semántica e Infraestructura Ontológica) en el marco de la iniciativa [Hércules](https://www.um.es/web/hercules/) para la Semántica de Datos de Investigación de Universidades que forma parte de [CRUE-TIC](https://tic.crue.org/hercules/) |
| Módulo         | Infraestructura Ontológica                                   |
| Tipo           | Especificación técnica de la integración continua |
| Objetivo       | El objetivo de este documento es la especificación técnica del sistema de integración continua que se ejecuta sobre la ontología cada vez que se produce un cambio. |
| Estado         | **100%** Se han analizado y aplicado ya varias soluciones para los problemas que emergen al mantener un control de versiones sobre ontologías OWL. Se han definido 5 niveles de soluciones, de los cuales 3 se encuentran ya en funcionamiento, y cubren la funcionalidad propuesta para este entregable. También se han definido tanto un sistema de integración continua en el que se validan automáticamente los cambios producidos en la ontología a partir de una serie de Shape Expressions, como un sistema de sincronización de cambios de la ontología con un triplestore. Ambos sistemas se encuentran implementados y en funcionamiento. Por último, se detallan las medidas a llevar a cabo para controlar la propagación de cambios de una ontología a otros artefactos dependientes y, en especial, a la arquitectura semántica. |
|Repositorio de Software Asociado|https://github.com/HerculesCRUE/ib-hercules-ontology/  En concreto en la carpeta test/test-launcher se encuentra el código correspondiente a la integración continua. |

# Hercules continuous integration module architecture

## Introduction and Goals
This document includes the architectural documentation for the continuous integration module - from now on called _hercules\_ci_ - between ontology files and the sincronization module, whis is a part of the ontological infrastructure of Project Hércules.

The structure of this document follows the [arc42](https://arc42.org/) template for documentation of software and systems architectures.

### Requirements Overview
The overall goal of _hercules\_ci_ is to check that any change on the ontology does not break the system. If the change is correct the system will allow it, else will inform the user about the changes in the ontology that did not pass the tests.

A more complete analysis of the system's requirements can be found in the __Requirements analysis__ section.

### Quality Goals
In this section we will enumerate the top quality goals for the system's architecture:

| Priority | Goal | Scenario |
| ---- | ----------- | -------- |
| 1 | Consistency | |
| 1 | Flexibility | |
| 1 | Fault Tolerance | |

### Stakeholders
| Role/Name   | Description                   | Expectations              |
| ----------- | ------------------------- | ------------------------- |
| Domain Experts | User that modifies the content of the ontology through the user interface provided by the ontology publication service. | When a change is made through the user interface, the system must ensure that these changes are valid. |
| Ontology Engineer | User that modifies the content of the ontology directly from the version control system. | Once a ontology file is modified, the changes need to be validated by the system. |

## Architecture Constraints
Any requirement that constrains software architects in their freedom of design and implementation decisions or decision about the development process are part of the architecture constraints.

| Contraint | Description                            |
|:---------:|----------------------------------------|
|     C1    | The system must be developed under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html). |
|     C2    | The system must be platform-independent and should run on the major operating systems (Windows™, Linux, and Mac-OS™). |
|     C3    | The system must be runnable from the command line. |
|     C4    | The control versions system used to store the ontologies will be GitHub.  |

## System Scope and Context
One of the problems that you have when editing ontologies is that a change can break the initial scheme that you wanted to design. For this reason, it is necessary to design a continuous integration system for ontologies that allows us to do what is known as test-driven design.

In addition to the hercules project, the GitHub platform is proposed as a version control system, so the continuous integration system will be designed so that it integrates with the tools offered by that platform.

## Solution Strategy
As a solution to the problem mentioned in the previous point, a solution is proposed that involves the use of shape expressions. The ontologies, after all, are rdf data and therefore are subject to being validated through shape expressions. To carry out the validation through shape expression we will use the already implemented shaclex system. And for the realization of the automated test cases, the CI system will be created that includes the creation of dynamic test cases from a single `manifet.json` file, the execution of said tests and the reporting of the results.

## System diagram
The building block view shows the static decomposition of the system into building blocks (modules, components, subsystems, classes, interfaces, packages, libraries, frameworks, layers, partitions, tiers, functions, macros, operations, datas structures, …) as well as their dependencies (relationships, associations, …)

![](assets/hercules-ci-bb.png)

**Ontology Infrastructure Subset:** Shows the integration of the `hercules_ci` system inside the context of the ontology infrastructure.

**Hercules CI:** Shows the different componenets of the `hercules_ci` system, its interactions with other componenets of the same system and the interactions of the system with external entities.

All of those elements are well explained in the following points.

### Hercules CI
The `hercules ci` system interacts with the `manifest.json` file that represents the input. And produces an output that is sent to GitHub. So once we have clear the input and the output we can explore the internal components of the system.

#### Manifest Reader
The first component is the Manifest Reader which task is to parse the manifest file and pass the information to the Test Generator. The `manifest.json` file contains information that describe a test case. For example:

```json
[
 {
    "test_name": "test that a project instance has all needed attributes",
    "ontology": "../../src/asio-core.ttl",
    "data": "../asio-individuals.ttl",
    "schema": "../project.s",
    "in_shape_map": "../project_in.m",
    "out_shape_map": "../project_out.m"
  },
  ...
]
```

Inside each test description we can see that each file needs a: `test_name`, `ontology`, `data`, `schema`, `in_shape_map`, `out_shape_map`. This fields need to meet the following specifications:

* `test_name`: is the name of the test, in case the test fail this name will be in the description of the failed test.
* `ontology`: is the path that points to the ontology to test.
* `data`: is the path that points to the data that will be used to populate the ontology during tests.
* `schema`: is the path to the shape expression to test the data and the ontology.
* `in_shape_map`: is the path to the input shape map, this shape map might contains the exact nodes to test against the schema or an sparql shape expression as a node selector.
* `out_shape_map`: is the path to the output expected shape expression. This is like the expected result in a test case.

#### Test Generator
The test generator gathers all the data parsed by the manifest reader and dynamically generates a test case for each test described in the manifest file. This component is the one that transform paths to probramming objects, therefore transform each test described in the previous step to an object similar to the following one:

```java
package es.weso.asio.ontology.test;

import com.google.gson.annotations.SerializedName;

/**
 * This models a test case, which is composed of a name, the ontology that is
 * being tested, the data to test, the schema against the tests will be thrown,
 * the input shape map, which specifies the nodes that will be tested. And the
 * output expected shape map.
 *
 * @author Pablo Menéndez
 */
public class TestCase {

	// All fields have a companion tag @SerializedName to be able to change it in
	// the near future with no propagation
	// consequences.

	@SerializedName("test_name")
	private final String name;

	@SerializedName("ontology")
	private final String ontologyFilePath;

	@SerializedName("data")
	private final String dataFilePath;

	@SerializedName("schema")
	private final String testSchemaFilePath;

	@SerializedName("in_shape_map")
	private final String testShapeMapFilePath;

	@SerializedName("out_shape_map")
	private final String expectedShapeMapFilePath;

	/**
	 * The default constructor is a basic all-args constructor. All the arguments
	 * that it takes are paths to the different files, except the name that is the
	 * literal string that will be assigned as test name.
	 *
	 * @param name                     of the test case.
	 * @param ontologyFilePath         is the file path to the ontology file used
	 *                                 for testing.
	 * @param dataFilePath             is the file path to the data file used to
	 *                                 mock ontology instances.
	 * @param testSchemaFilePath       is the file path to the schema used to
	 *                                 validate the ontology.
	 * @param testShapeMapFilePath     is the file path to the shape map that
	 *                                 relates each test data node with its
	 *                                 corresponding schema.
	 * @param expectedShapeMapFilePath is the file path to the expected result shape
	 *                                 map.
	 */
	public TestCase(final String name, final String ontologyFilePath, final String dataFilePath,
			final String testSchemaFilePath, final String testShapeMapFilePath, final String expectedShapeMapFilePath) {
		this.name = name;
		this.ontologyFilePath = ontologyFilePath;
		this.dataFilePath = dataFilePath;
		this.testSchemaFilePath = testSchemaFilePath;
		this.testShapeMapFilePath = testShapeMapFilePath;
		this.expectedShapeMapFilePath = expectedShapeMapFilePath;
	}

	/**
	 * Gets name.
	 *
	 * @return name
	 */
	public String getName() {
		return name;
	}

	/**
	 * Gets ontology file path.
	 *
	 * @return ontology file path
	 */
	public String getOntologyFilePath() {
		return ontologyFilePath;
	}

	/**
	 * Gets data file path.
	 *
	 * @return data file path
	 */
	public String getDataFilePath() {
		return dataFilePath;
	}

	/**
	 * Gets test schema file path.
	 *
	 * @return test schema file path
	 */
	public String getTestSchemaFilePath() {
		return testSchemaFilePath;
	}

	/**
	 * Gets test shape map file path.
	 *
	 * @return test shape map file path
	 */
	public String getTestShapeMapFilePath() {
		return testShapeMapFilePath;
	}

	/**
	 * Gets expected shape map file path.
	 *
	 * @return the expected shape map file path
	 */
	public String getExpectedShapeMapFilePath() {
		return expectedShapeMapFilePath;
	}

	@Override
	public String toString() {
		return "TestCase [test_name=" + name + ", ontology=" + ontologyFilePath + ", data=" + dataFilePath + ", schema="
				+ testSchemaFilePath + ", in_shape_map=" + testShapeMapFilePath + ", out_shape_map="
				+ expectedShapeMapFilePath + "]";
	}

}
```

#### Test Executor
This component is the one that executes the different tests generated by the test generator, connects to the SHACLEX Validator module, and collects the result information for logging.

When the test generator sends the collection of generated tests this module calls to the SHACLEX validator to load the corresponding RDF resources and execute the validation throught the given schema. And after the execution collects the results and logs them in to the corresponding GitHub log.

#### SHACLEX Validator
This is not a module itself but rader a dependency. You can see more information about how it works [here](https://github.com/weso/shaclex/).

## GitHub Integration
This system needs to be integrated with GitHub such that each time a change is done in the ontology the corresponding tests are launched. For this porpose we decided to use GitHub actions in order to avoid third dependecies like travis or circle-ci. To configure giuthub actions we use the following configuration:

```yml
# This workflow will build a Java project with Maven
# For more information see: https://help.github.com/actions/language-and-framework-guides/building-and-testing-java-with-maven

# The root name of the workflow. On checks it is printed as <root_name>/<job_name>.
name: Hercules CI

on: [push, pull_request]

jobs:

  # Test the ontology.
  test:

    # The job name.
    name: Test with Shape Expressions

    # This job will run on a linux virtual machine.
    runs-on: ubuntu-latest

    # The steps are, first, checkout, then set java version to 11 and
    # finally move to the tests forder and execute the tests.
    steps:
    - uses: actions/checkout@v2

    # Setting the java version.
    - name: Set up JDK 11
      uses: actions/setup-java@v1
      with:
        java-version: 11

    # Test with maven
    - name: Test with Maven
      run: |
        cd test/test-launcher/
        mvn test
```

As you can see the configuration uses JDK 11 and maven to launch the tests on pushes and pull requests. This configuration can be changed at any time by means of a commit or a pull request. For more information about GitHub Actions GitHub offers an awesome [documentation](https://github.com/features/actions).

## Technologies used
The following technologies have been used in the development of the system.

* **Java:** Java is used as the main programming language of the testing system.
* **Maven:** Is used as a dependency manager and task executor for the testing system.
* **ShEx-S:** Is used through shalcex implementation to test RDF data over shape expressions.

## Requirements analysis
### Functional requirements

| Code        | Description          |
|:-----------:|:---------------------|
| FR1         | The system will generate tests from a test-drescription file called manifest.json. |
| FR2         | The system will execute the generated tests. |
| FR3         | The system will inform about the result of the tests to GitHub. |
| FR4         | The system will be configured to be a GitHub Action. |

### Non-functional requirements
| Code          | Description          |
|:-------------:|:---------------------|
| NFR1      | Security: The system will be completly executed in the GitHub Environment. |
| NFR2 | Compatibility: The system will be at least compatible with versions 8 to 11 of the Java programming language. |
| NFR3 | Mantenibility: The implementation of the system will follow an equivalent PEP8 standard. |
| NFR4 | Modificability: The system will facilitate the modification of the code. |

## Glossary
| Term                              | Definition                        |
|:--------------------------------- | --------------------------------- |
| Version Control System | Software tool that helps a software team with the management of changes to source code. |
