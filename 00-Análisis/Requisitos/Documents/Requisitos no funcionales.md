![](./images/logos_feder.png)

# Requisitos no funcionales



##  Requisitos de Apariencia y estilo

| Código | Requisito                                                    | Prioridad |
| ------ | ------------------------------------------------------------ | --------- |
| RNF1.1 | Se usará el logo y la tipografía de Hercules para crear un diseño a partir de estos datos. |           |
| RNF1.2 | El interfaz del software debe encajar con el aspecto y grado de accesibilidad y usabilidad del resto de herramientas software desplegadas en el framework de la Universidad de Murcia. |           |
|        |                                                              |           |
|        |                                                              |           |



## Requisitos Capacidad de Uso y Humanidad

| Código | Requisito                                                    | Prioridad |
| ------ | ------------------------------------------------------------ | --------- |
| RNF2.1 | El interfaz de usuario del sistema gestor de datos será lo más usable y ligero posible. |           |
| RNF2.2 | El interfaz de usuario estará orientado a que los expertos del dominio GI puedan realizar la gestión y publicación de datos. |           |
|        |                                                              |           |
|        |                                                              |           |



## Requisitos de Desempeño

## 

| Código | Requisito                                                    | Prioridad |
| ------ | ------------------------------------------------------------ | --------- |
| RNF3.1 | Estabilidad: el desarrollo debe mantenerse estable ante un incremento en el número de usuarios simultáneos |           |
| RNF3.2 | Escalabilidad de los datos: el sistema debe garantizar que los datos a manejar pueden alcanzar volúmenes importantes y deben ser soportados por la arquitectura prevista. |           |
|        |                                                              |           |
|        |                                                              |           |





## Requisitos Operacionales y Ambientales

## 

| Código | Requisito                                                    | Prioridad |
| ------ | ------------------------------------------------------------ | --------- |
| RNF4.1 | El protocolo a usar será abierto.                            |           |
| RNF4.2 | El software debe ser compatible con el framework y stack tecnológico de la Universidad de Murcia. |           |
| RNF4.3 | Se creará un modelo de dominio del Sistema siguiendo el enfoque *Domain Driven Design* para modelar las entidades. |           |
| RNF4.4 | Se dispondrá de un Triple-store para almacenar y consultar la información de forma semántica. |           |
| RNF4.5 | El gestor de datos es el encargado de comunicarse con la Triple Store. |           |
|        |                                                              |           |





## Requisitos de Preservación y Soporte

## 

| Código  | Requisito                                                    | Prioridad |
| ------- | ------------------------------------------------------------ | --------- |
| RNF5.1  | El software estará preparado para su recuperación ante fallos de conexión. |           |
| RNF5.2  | El software estará codificado de manera limpia y clara para garantizar su comprensibilidad. |           |
| RNF5.3  | Se dotará al producto de la documentación necesaria para facilitar el mantenimiento y actualización. |           |
| RNF5.4  | El software debe estar preparado para incorporar nuevas fuentes de datos no contempladas en este punto. |           |
| RNF5.5  | La incorporación de nuevos módulos que permitan la comunicación con otros sistemas debe ser sencilla |           |
| RNF5.6  | Las páginas web de documentación se intentarán generar de la forma más automática posible. |           |
| RNF5.7  | Se crearán un Test Suite que consistirá en una serie de peticiones HTTP a ejecutar contra el sistema con una casuística lo más diversa y exhaustiva posible. |           |
| RNF5.8  | Se crearán y realizarán pruebas de carga(benchmarks)  como peticiones simúltaneas, consultas complejas, etc. |           |
| RNF5.9  | Se intentarán comprobar los requisitos del sistema en los test. |           |
| RNF5.10 | Los test se realizarán con los datos de Datasets de referencia Hércules. |           |
| RNF5.11 | El Test suite ha de ser fácil de modificar y configurar, para que los técnicos de la UM puedan ejecutarlo, añadir tests nuevos o modificar tests existentes con datos y configuraciones nuevas |           |
| RNF5.12 | El Test Suite constará de documentación para facilitar su extensión y modificación. |           |
| RNF5.13 | Se pueden usar como referencia para algunos test *Linked Data Platform Test Suite*:<br />- https://github.com/w3c/ldp-testsuite<br />- https://github.com/opendata-euskadi/LinkedDataTestSuite |           |
|         |                                                              |           |
|         |                                                              |           |
|         |                                                              |           |





## Requisitos de Seguridad

## 

| Código | Requisito                                                    | Prioridad |
| ------ | ------------------------------------------------------------ | --------- |
| RNF6.1 | El software debe garantizar el acceso al sistema de las personas autorizadas en cada parte. |           |
| RNF6.2 | El protocolo permitirá autenticación y autorización.         |           |
| RNF6.3 | Las páginas web de documentación, serán públicas.            |           |
| RNF6.4 | El acceso a los datos del triple-store  estará restringido. y solamente se podrá realizar a través del componente  gestor de datos, el cual contiene una gestión de usuarios y control de acceso |           |
| RNF6.5 | El acceso a los datos del triple-store   solamente se podrá realizar a través del componente  gestor de datos, el cual contiene una gestión de usuarios y control de acceso |           |
| RNF6.6 | El gestor de datos debe incluir un sistema de permisos con diferentes niveles de acceso a los datos. |           |
| RNF6.7 | Logging: el software ofrecerá  herramientas para detectar anomalías en el funcionamiento del sistema |           |



## Requisitos Culturales y Políticos



| Código | Requisito | Prioridad |
| ------ | --------- | --------- |
|        |           |           |
|        |           |           |
|        |           |           |
|        |           |           |



## Requisitos Legales

## 

| Código | Requisito | Prioridad |
| ------ | --------- | --------- |
|        |           |           |
|        |           |           |
|        |           |           |
|        |           |           |




