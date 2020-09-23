![](./images/logos_feder.png)

# Diseño de pantallas



**Índice**

[1. INTRODUCCIÓN](#introducción)

[2. Diseño de pantallas](#diseño-de-pantallas)

​	[2.1. Gestión de usuarios y roles](#gestión-de-usuarios-y-roles)

​		[2.1.1. Edición de perfil](#edición-de-perfil)

​		[2.1.2. Pantalla de gestión de roles](#pantalla-de-gestión-de-roles)

​		[2.1.3. Edición de perfil y sus roles por el usuario administrador](#edición-de-perfil-y-sus-roles-por-el-usuario-administrador)

​		[2.1.4. Gestión de ASIO](#gestión-de-asio)

​	[2.2. Administración ontologías y datos de las ontologías](#administración-ontologías-y-datos-de-las-ontologías)

​		[2.2.1. Cargar datos](#cargar-datos)

​		[2.2.2. Modificar ontologías y sus roles](#modificar-ontologías-y-sus-roles)

​	[2.3. Consulta de datos](#consulta-de-datos)

​		[2.3.1. Pantalla genérica de consulta de datos](#pantalla-genérica-de-consulta-de-datos)



Introducción
============

El sistema Frontend de la aplicación se encargará de interactuar con los usuarios que intenten acceder al sistema, ya sean personas o máquinas. Se permitirá tanto la consulta de datos como la introducción de nuevos datos en el sistema mediante esta vía.



![diagrama estructura del proyecto - front](./images/diagrama-estructura-del-proyecto-front.jpg)



***Este documento se centra en el diseño de las pantallas para que los usuarios de tipo personas intenten acceder al sistema***, que se utilizarán como *BackOffice* de la solución, es decir para la gestión de la propia aplicación.

Diseño de pantallas
===================

En esta sección se muestran mocks de pantallas realizados con Balsamiq.



Gestión de usuarios y roles
---------------------------



### Edición de perfil

Cualquier usuario podrá editar su propio perfil.

![](./images/mocks/usuario-edita-su-perfil.png)



### Pantalla de gestión de roles

El usuario Gestor Asio podrá añadir, borrar y editar roles en la aplicación.

![Administrador gestiona roles](./images/mocks/administrar-roles.png)



### Edición de perfil y sus roles por el usuario administrador

Un usuario administrador podrá editar el perfil y roles de un usuario.

En primer lugar, debe buscar el usuario.

![Administrador buscar usuarios](./images/mocks/buscar-usuario.png)



A partir de esta pantalla de búsqueda podrá editarlo.

![Administrador edita usuario](./images/mocks/administrador-edita-perfil.png)



### Gestión de ASIO

Los usuarios con rol Gestor ASIO podrán modificar la frecuencia de carga
de datos automática de la aplicación:

![Administrador gestiona la aplicación](./images/mocks/administrador-gestiona-app.png)



Administración ontologías y datos de las ontologías
---------------------------------------------------

### Cargar datos

Los usuarios con rol administrador de la universidad, podrán cargar ontologías y sus datos a través de la aplicación web. Para esto dispondrán de una pantalla en la podrán seleccionar un fichero con formato CSV, XML o Json, que podrá ser de un tamaño máximo. *Los campos de las ontologías importadas tendrán visualización pública por defecto.*

![Administrador universidad carga datos](./images/mocks/cargar-datos.png)

### Modificar ontologías y sus roles

Los usuarios con rol administrador de la universidad, podrán modificar ontologías y sus roles para su universidad a través de la aplicación web, para eso podrán buscar las ontologías a través de un buscador simple, y a continuación modificarlas en una pantalla después de seleccionar la ontología deseada.

![Buscar ontologías](./images/mocks/modificar-ontologías.png)

![Modificar ontologías](./images/mocks/modificar-ontologias-2.png)



Consulta de datos
-----------------

### Pantalla genérica de consulta de datos

Para consultar datos, los usuarios podrán acceder a una pantalla donde se permitirá hacer consultar en [SPARQL](https://es.wikipedia.org/wiki/SPARQL).

![Pantalla SPARQL](./images/mocks/consulta.png)



En esta pantalla habrá la opción de seleccionar una consulta de datos predeterminada y de modificarla.

![Pantalla de consultas](./images/mocks/consulta-predeterminada.png)



Al pulsar sobre el dato que interese cuando se muestran los datos obtenidos de la consulta, se mostrará otra pantalla con el detalle, similar a las pantallas de Wikidata. Desde esta otra pantalla podremos acceder al detalle de cada uno de los datos que se muestran si es necesario.

![Detalle consulta](./images/mocks/detalle-consulta.png)


