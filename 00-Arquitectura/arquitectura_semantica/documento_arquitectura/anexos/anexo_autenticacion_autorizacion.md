# Autenticación y autorización

Servidor de autorización: keycloak

## Keycloak

Keycloak es un servidor de autenticación y autorización opensource que permite single sign-on con gestión de identidad y acceso para aplicacion esy servicios. Entre sus principales características incluye:

* Registro de usuarios
* Login con redes sociales
* Single Sign-On
* Autenticación 2-factor
* Integración con LDAP y Kerberos
* Multitenancy

Kekcloak provée los siguientes endpoints o protocolos:

* OpenID Connect
* SAML 2.0

### Configuración

Será preciso seguir una serie de pasos para llegar a configurar Keycloak para su utilización, para lo cual habrá que acceder a la consola de administración de Keycloak, por ejemplo `http://localhost:8080/auth`, con el usuario administrador que se haya definido.

#### Creación Realm

Un realm gestiona un conjunto de usuarios, credenciales, roles y grupos. Realms están aislados unos de los otros y pueden unicamente manejar y autenticar a los usuarios que conocen. En primer lugar será necesario crar un Realm, para lo cual simplemente habrá que indicarle un nombre.

#### Creación de cliente

Dentro del Realm creado anteriormente, se precisa crear un cliente por cada uno de los servicios que van a utilizar la autenticación.

* Client ID: nombre del cliente
* Client Protocol: indicar `openid-connect`

Una vez creado el cliente se deberá configurar para indicar los siguientes parámetros:

* Access type: indicar `confidential`
* Valid Redirect URIs: se indicará una expresión regular que incluya la URI de vuelta tras el login
* Services Accounts Enabled: `On` 
* Authorization Enabled: `On`

En la pestaña `Credentials` de podrá obtener el client secret.

#### Creación de roles de cliente

En caso necesario se crearán los roles pertinentes, los cuales se asignarán posteriormente a cada usuario.

#### Creación de mappers

Los tokens de acceso de Keycloak son JWT, el cuial incluye una serie de claims que permiten dar autorización al usuario. Mediante los mappers es posible añadir nuevos claimos o incluso renombrar alcuno existente.

Por ejemplo, el campo username es retornado en un claim llamado `preferred_username`. En el caso de Spring Security OAuth2 se espera que el username venga en el claim llamado `user_name`. Para ello se crearía dentro del Client un mapper con los siguiente parámetros:

* Name: nombre del mapper
* Mapper Type: `User property`
* Property: `username`
* Token Claim Name: `user_name`
* Claim JSON Type: `String`
* Add to access token: `On`

#### Creación de usuario

Se creará un usuario con los datos necesarios. Se deberá crear también una contraseña en la pestaña `Credentials`. Los usuarios aplican a todos los clientes del Realm, aunque se podrían asignar roles distintos para cada uno de los clientes, esto se haría en la pestaña `Role Mappings`.

#### Obtención de la configuración para OpenID

Una vez configurado el endopoint, se podrá obtener los datos de configuración para los clientes, para ello existe una URL en la que muestra esta información, por ejemplo si el Realm se llama "dev" sería `http://localhost:8080/auth/realms/dev/.well-known/openid-configuration`

De aquí lo importante son los siguientes parámetros:

* authorization_endpoint: `http://localhost:8080/auth/realms/dev/protocol/openid-connect/auth`
* token_endpoint: `http://localhost:8080/auth/realms/dev/protocol/openid-connect/token`
* jwks_uri: `http://localhost:8080/auth/realms/dev/protocol/openid-connect/certs`

### JWKS

JSON Web Key Set (JWKS) es un conjunto de claves que contienen las claves públicas usadas para verificar los JSON Web Tokens (JWT) creados por un servidor de autorización.

## Trellis

Trellis disponde un sistema de autenticación, ya sea mediante autenticación básica o mediante JWT, pero no realiza redirección hacia login, por lo que se necesita disponer de la autenticación para poder devolver el recurso. El motivo por el que no realiza es redirección es porque Trellis no está concebido como servicio Web para la consulta de la información, si no que al tratarse de un Linked Data Platform (LDP), está pensado para la obtención de los recursos en diferentes formatos, ya sea HTML, Turtle, etc.

### JWT

Para la configuración de Trellis para la utilización de un servicio OpenID Connect, como por ejemplo Keycloak, se precisa indicar en el fichero de configuración los parámetros `auth.jwt.enabled` para habilitar este mecanismo de autenticación y `auth.jwt.jwks` para indicar la URL del servicio JWKS.

```yml
auth:
  jwt:
    enabled: true
    jwks: http://localhost:8080/auth/realms/dev/protocol/openid-connect/certs
```

### Basic auth

En el caso de la autenticación básica, se configurará indicando en el fichero de autenticación los parámetros `auth.basic.enabled` para habilitar este mecanismo de autenticación y `auth.basic.usersFile` para indicar la ubicación del fichero de usuarios.

```yml
auth:
  basic:
    enabled: true
    usersFile: /opt/trellis/etc/users.auth
```

El token JWT debe disponer de un claim denominado `webid` de acuerdo a la especificación [Solid WebID-OIDC](https://github.com/solid/webid-oidc-spec#deriving-webid-uri-from-id-token). Por ejemplo:

```json
{
    "webid": "http://example.com/username"
}
```

Alternativamente se puede utilizar una combinación de los claims `sub` (subject) e `iss` (issuer). Por ejemplo:

```json
{
    "sub": "username",
    "iss": "http://example.com/"
}
```

#### Fichero de usuarios

El fichero de usuarios contendrá los siguientes datos:

* username: nombre del usuario
* password: contraseña
* webid: WebID del usuario el cual debe ser una URL que identifique únicamente al usuario, por ejemplo `http://example.com/username`

El formato del fichero será el siguiente:

```
username : password : webid
```

Por ejemplo:

```
admin : admin : http://example.com/admin
```

### WebAC

Trellis permite realizar la autorización mediante [WebAC](https://www.w3.org/wiki/WebAccessControl) a nivel de recurso. Los permisos en WebAC se almacenan en formato Linked Data, por defecto Turtle, y utiliza la ontología http://www.w3.org/ns/auth/acl.

Por ejemplo

```turtle
# Contents of https://alice.databox.me/docs/file1.acl
@prefix  acl:  <http://www.w3.org/ns/auth/acl#>  .

<#authorization1>
    a             acl:Authorization;
    acl:agent     <https://alice.databox.me/profile/card#me>;  # Alice's WebID
    acl:accessTo  <https://alice.databox.me/docs/file1>;
    acl:mode      acl:Read, 
                  acl:Write, 
                  acl:Control.
```

Trellis permite asignar una WebACL por defecto, mediante la definición de la variable `trellis.webac.default-acl-location`, la cual se puede configurar como parámetro de JDK (-Dtrellis.webac.default-acl-location=....) o mediante una variable de entorno con este nombre.

Cuando se cambie una ACL es preciso reiniciar el servicio para que tome los nuevos valores.

Más información: 

* https://github.com/trellis-ldp/trellis/wiki/Authorization
* https://github.com/trellis-ldp/trellis/wiki/Authentication

## Wikibase

Wikibase por defecto toma los usuarios de forma local. Existe una extensión de Mediawiki que permite integrar un servicio OpenID Connect. 

* https://www.mediawiki.org/wiki/Extension:OpenID_Connect
* https://www.mediawiki.org/wiki/Extension:PluggableAuth

También será necesario instalar con composer 

    composer require jumbojett/openid-connect-php

Configurar en LocalSettings.php

### Configuración Keycloak

Como ejemplo de integración de un servicio OpenID Connect, se verá cómo se realiza con [Keycloak](https://www.keycloak.org/).

1. Creación de Realm, por ejemplo con nombre `myrealm`
2. Creación de client, por ejemplo con nombre `mediawiki`
  1. Se deberá indicar en el parámetro `Valid Redirect URIs` una expresión regular que incluya la URI de redireción válida para la instancia de Wikibase, por ejemplo `*`
  2. Marcar el parámetro `Access Type` como `confidential`, para que requiera una secret para poder interactuar con el servidor de autenticación, este secret se obtendrá de la pestaña `Credentials`, la cual aparecerá tras guardar los cambios.
3. Crear un usuario

A continuación, se añadirá la siguiente configuración en el fichero `LocalSettings.php` de Mediawiki:

```php
$wgOpenIDConnect_Config['http://localhost:8080/auth/realms/myrealm/'] = [
	'clientID' => 'mediawiki',
	'clientsecret' => '<client secret>'
];
```

Donde se indicarán:

* URL del Realm
* Client ID
* Client secret

### Usuarios y roles

Al integrar Wikibase con el servidor de autenticación externo, no es capaz de recoger los roles que se definan en este último. Debido a esto, tras el cambio de método de autenticación, no será posible acceder con los usuarios locales y por tanto todos los usuarios que se loguen serán usuarios estándar.

Para poder asignar roles, es preciso que al menos uno de los usuarios sea administrador, para ello, una vez logado el usuario la primera vez se creará automáticamente el usuario en wikibase, debiendo asignar los roles por base de datos. Wikibase dispone de varias tablas en este sentido:

- user
- user_groups

En primer lugar será necesario localizar el usuario en la tabla `user`, ejecutando la siguiente consulta:

```sql
SELECT * FROM my_wiki.user;
```

Una vez localizado y obtenido su `user_id` habrá que irse a la tabla `user_gropus` y asignarle los permisos. Lo más sencillo es utilizar los permisos que tiene el usuario administrador (normalmente `WikibaseAdmin` con id 1) y asignárselos al nuevo usuario mediante la ejecución de la siguiente consulta (teniendo en cuenta que el usuario destino tenga como id el valor 2):

```sql
UPDATE `my_wiki`.`user_groups` SET `ug_user`='2' WHERE `ug_user`='1';
```

A partir de este momento, el usuario seleccionado pasará a ser administrador de Wikibase.
