![](./images/logos_feder.png)

# Memento Guía

#### ¿Que es Memento?

El protocolo Memento es una extensión directa de HTTP que agrega una dimensión de tiempo a la Web, permitiendo obtener la representación de un recurso introduciendo el concepto de negociación por DateTime, que permite especificar el instante temporal en el cual el usuario desea recuperar un dato, y los TimeMap, que  consisten en lista de URIS de recursos que almacenan los distintos estados de un recurso. 

En resumen, Memento ofrece mecanismo para acceder a las distintas versiones de un mismo recurso.

Los componentes u objetivos principales de Memento son:

- Noción de estado de un recurso, según el instante temporal T, representado el estado de un recurso temporal por medio de el esquema de URIs fechadas.
- Ofrece un puente entre el estado presente y los estados anteriores:
  - La existencia de URI-G, que es consciente de los estados anteriores.
  - La posibilidad de negociar la dimensión tiempo y obtener su URI-G
- Ofrece un puente entre el pasado y presente, que consiste en un enlace a un Memento (URI-M), que encapsula que sado tenia el recurso original, en el instante T, hasta el recurso original
- Es posible obtener un TimeMap, que representa todos los estados de un recurso a lo largo del tiempo.

#### Terminología

* **Recurso Original (Original Resource):** Recurso que existe o ha existido, del cual es posible obtener acceso a  alguno de sus estados
* **Memento**: Un memento de un recurso, es el estado del recurso en el instante T.
* **TimeGate:** El timeGate de un Original Resource, es aquel recurso que es capaz se soportar una negociación por tiempo, que dará acceso a alguno de los estados anteriores del recurso.
* **TimeMap**: Un TimeMap de un Original Resource, es un recurso que dispne de una lista de URIs Memento.
* **URI-R**: Uri de un recurso original
* **URI-G**: Uri de un TimeGate
* **URI-M**: Uri de un Memento
* **URI-T**: Uri original de un TimeMap

#### Cabeceras HTTP

La aplicación de memento, concierne a la operaciones GET y HEAD sobre recursos originales, Mementos, TimeGates o TimeMaps identificadas por sus URIs.

Opera a nivel de cabeceras en las peticiones o respuestas HTTP. Añade dos nuevas cabeceras ("Accept-Datetime" y "Memento-Datetime") e introduce 2 valores nuevos en cabeceras existentes ("Vary" y "Link")

##### Formatos de tiempo

Se expresan en formato BNF, de acuerdo con el formato  [RFC1123](https://tools.ietf.org/pdf/rfc1123.pdf), 

representado como una fecha GMT en el siguiente formato

```
accept-dt-value = rfc1123-date
rfc1123-dadate1 = 2DIGIT SP month SP 4DIGIT
 					; day month year (e.g., 20 Mate = wkday "," SP date1 SP time SP "GMT"
time = 2DIGIT ":" 2DIGIT ":" 2DIGIT
 					; 00:00:00 - 23:59:59 (e.g., 14:33:22)
wkday = "Mon" | "Tue" | "Wed" | "Thu" | "Fri" | "Sat" | "Sun"
month = "Jan" | "Feb" | "Mar" | "Apr" | "May" | "Jun" |
	    "Jul" | "Aug" | "Sep" | "Oct" | "Nov" | "Dec"
```



##### Accept-Datetime

Accept-Datetime, expresa el deseo de un cliente de acceder a un estado pasado del recurso evaluaado contra un TimeGate

Ejemplo en petición

```
Accept-Datetime: Thu, 31 May 2007 20:35:00 GMT
```

##### Memento-Datetime

Memento-Datetime, expresa la respuesta del servidor, indicando que estado anterior (datetime) del recurso se retorna.

La URI del recurso original, del que estamos retornando un estado anterior, es retornada con la cabecera Link de type="original"

Ejemplo en respuesta

```
Memento-Datetime: Wed, 30 May 2007 18:47:52 GMT
```

##### Vary

Generalmente se usa la cabecera "Vary" en las respuestas HTTP para indicar la dimensión, en la cual, la negociación de contenidos es posible. Memento la usa  en las respuestas, con el valor "accept-datetime", para expresar que la negociación en la dimensión de tiempo es posible.

Ejemplo en respuesta

```
Vary: accept-datetime
```

Ejemplo en respuesta, con negociación de tiempo, y de media type

```
Vary: accept-datetime, accept
```

##### Link

Memento usa la cabecera Link con los tipos "original", "timegate", "timemap" y "memento" para avisar de de los distintos tipos de acceso a un recurso. En adición a estos, pueden ser usados los tipos "first", "last", "prev", "next", "predecessor-version" y "successor-version"

###### Link type original

Se usa para apuntar desde un TimeGate o un Memento, a su recurso original asociado.

Las respuestas a métodos GET/HEAD sobre un TimeGate o Memento, deben incluir exactamente una cabecera **Link**, del tipo **"original"**

###### Link type timegate

Se usa para apuntar desde un Recurso a su Timegate o Memento asociado.

Si hay un TimeGate o un Memento asociado a un recurso, entonces las respuestas HTTP a peticiones GET/HEAD, deben incluir las cabecera **Link**, del tipo **"timegate"**, por cada uno de las timegates asociados a un recurso, cada uno con la URI que apunte al recurso, en ese instante temporal.

###### Link type timemap

Se usa para apuntar desde un Timegate o Memento asociado a un recurso a el TimeMap de dicho recurso.

En un enlace tipo timemap el atributo type debe de ser usado para transmitir el tipo MIME. los atributos "from" y "until" pueden usarse para expresar el intervalo de tiempo que queremos que comprenda el listado TimeMap.

Se pueden expresar distintos Timemap, cada uno con su URI, con distintas serializaciones.

###### Link type memento

Se usa para apuntar desde un Timegate, un Memento, o un recurso original al memento del recurso original.

E un enlace tipo memento debe de incluirse el tipo "datetime", que coincidirá con el atributo "Memento-Datetime", de el memento del Link, que es el header Memento-Datetime, cuando el memento es desreferenciado.

EL link puede incluir el atributo "licence", que asocia el MEmento con la licencia. Este debe de ser una URI

##### Negociación de Datetime (ejemplo)

```bash

# 1. El usuario realiza una operacion GET/HEAD para acceder a un estado anterior de un 
#    recurso por medio de la URI del recurso, usando la cabecera Accept-Datetime, con el 
#    valor T (expresado con el formato de tiempo expresado en este documento). El
#    servidor retornara el mas cercano según la politica de implementación en el servidor

1: UA ---  HTTP HEAD/GET; Accept-Datetime: T ----------------> URI-R 

# 2. La respuesta del servidor, sobre la URI del recurso, incluye una cabecera Link, con 
#    un tipo de relación timegate, que apunta a un timegate concreto de ese recurso

2: UA <-- HTTP 200; Link: URI-G ----------------------------- URI-R 

# 3. El usuario realiza una operacion GET/HEAD para acceder al URI-G y la cabecera 
#    Accept-Datetimedel recurso retornada por el servidor en el paso anterior

3: UA ---  HTTP HEAD/GET; Accept-Datetime: T ----------------> URI-G 

# 4. La respuesta del servidor incluye la cabecera "Location", con la URI-M del memento,
#    del recurso original, para el T negociado.
#    Tambien incluye en la cabecera Link la relación a la URI del recurso original y su 
#	 timemap 

4: UA <-- HTTP 302; Location: URI-M; Vary; Link: URI-R,URI-T ------------> URI-G 

# 5. El usurio realiza una petición contra el URI-M, retornado en el paso anterior 

5: UA ---  HTTP GET URI-M; Accept-Datetime: T ---------------> URI-M 

# 5. La respuesta del servidor incluye un Memento-Datetime, del memento recuperado
#	 Tambien incluye cabeceras Link para el recurso (URI-R), el Timemap (URI-T) y el
#    TimeGate (URI-T) del recurso original. El estado del recurso retornado, es el que 
#    indica la cabecera "Memento-Datetime"

6: UA <-- HTTP 200; Memento-Datetime: T; Link: URI-R,URI-T,URI-G ------------------------------------- URI-M
```

Es posible que el formato del cuerpo de la respuesta haya cambiado con el tiempo, por eso es importante informar al cliente de el media type relativo al recurso e incluso aplicar el media type al algoritmo de selección del memento mas próximo, de forma que se aproxime lo mas posible en el tiempo, y coincida en el tipo MIME.

##### TimeMaps (ejemplo)



```bash
# 1. El usuario realiza una operacion GET/HEAD para acceder a un 
#    recurso por medio de la URI del recurso, sin asar si así se desea la cabecera 
#    Accept-Datetime

1: UA --- HTTP HEAD/GET ------------------------------------> URI-R

# 2. Independientemente del "Accept-Datetime" (si se uso), que se solicitase en el paso 1, el servidor respondera con una cabecera Link, con el tipo de relación "timegate", apuntando al TimeGate para el recurso solicitado

2: UA <-- HTTP 200; Link: URI-G ----------------------------- URI-R 

# 3. El usuario realiza una operacion GET/HEAD para acceder al URI-G y usando o no la cabecera Accept-Datetime del recurso retornada por el servidor en el paso anterior

3: UA --- HTTP HEAD/GET ------------------------------------> URI-G

# 4. La respuesta del servidor (independientemente de la cabecera Accept-Datetime), respondera con una cabecera Link, del tipo: "timemap", que apunta al TimeMap
4: UA <-- HTTP 302; Location: URI-M; Vary; 
				Link:URI-R,URI-T ------------------------------------------> URI-G


# 5. El usurio realiza una petición para obtener el TimeMap contra el URI-T, retornado en el paso anterior 

5: UA --- HTTP GET URI-T -----------------------------------> URI-T

# 5. La respuesta del servidor incluye en su body, la lista de todos los mementos para un determinado recurso, y sus fechas de inserción.

6: UA <-- HTTP 200 ------------------------------------------ URI-T
```

##### Negociación de Datetime: Interacciones HTTP. Patrones de implementación

###### **Patrón 1:** 

El Recurso Original actúa como su propio TimeGate, lo que significa de la URI-R y URI-G coincidirá. El código de respuesta pude seguir el patrón 200 o 302 (dependiendo del patrón de negociación y la presencia o ausencia de URI-M´s distintos a el URI-R del recurso original). 

Se resumen varios casos en la tabla bajo estas líneas mapeando respuestas con los sub-patrones descritos después

| Patrón     | Recurso Original | TimeGate | Memento | Código de Retorno |
| ---------- | ---------------- | -------- | ------- | ----------------- |
| Patrón 1.1 | URI-R            | URI-R    | URI-M   | 302               |
| Patrón 1.2 | URI-R            | URI-R    | URI-M   | 200               |
| Patrón 1.3 | URI-R            | URI-R    | URI-R   | 200               |

- **Patrón 1.1:** URI-R=URI-G; 302-Style Negotiation; Distinct URI-M

  En este caso se retorna un código 302, y una cabecera Location hacia el URI-M

  Se debe usar de la siguiente manera:

  - La cabecera "Vary" es necesaria y debe incluir el valor "accept-datetime"
  - La respuesta **no debe** incluir la cabecera "Memento-Datetime"
  - Se debe proporcionar el encabezado "Link", y debe incluir al menos un Relation Type = "original", hacia el URI-R
  - 

  Para todos los patrones descritos, el cliente realizara la siguiente petición:

  ```
  HEAD / HTTP/1.1
   Host: a.example.org
   Accept-Datetime: Tue, 20 Mar 2001 20:35:00 GMT
   Connection: close
  ```

  

  Ejemplo de respuesta del Servidor para URI-R=URI-G en el patrón 1.1

  ```bash
  HTTP/1.1 302 Found
   Date: Thu, 21 Jan 2010 00:06:50 GMT
   Server: Apache
   Vary: accept-datetime #Esta cabecera ha de estar presente
   Location:
   http://a.example.org/?version=20010320133610 # URI-M del memento para el recurso
   Link: <http://a.example.org/>; rel="original timegate" # URI-M del recurso original
   Content-Length: 0
   Content-Type: text/plain; charset=UTF-8
   Connection: close
  
  ```

  Petición del cliente para obtener el seleccionado Memento

  ```
  GET /?version=20010320133610 HTTP/1.1
   Host: a.example.org
   Accept-Datetime: Tue, 20 Mar 2001 20:35:00 GMT
   Connection: close
  
  ```

  Respuesta del servidor con el memento seleccionado, solo se muestran las cabeceras, pero se obtendría también el body del recurso

  ```bash
  HTTP/1.1 200 OK # Código 200
  # No esta presente la cabecera Vary
   Date: Thu, 21 Jan 2010 00:06:51 GMT
   Server: Apache-Coyote/1.1
   Memento-Datetime: Tue, 20 Mar 2001 13:36:10 GMT # Debe incluirse la cabecera Memento-Datetime
   # Debe aparecer la cabecera Link, y debe incluir al menos un link de el tipo original de relación que tiene el URI-R, con el memento retornado
   Link: <http://a.example.org/>; rel="original timegate",
   <http://a.example.org/?version=all&style=timemap>
   ; rel="timemap"; type="application/link-format"
   ; from="Tue, 15 Sep 2000 11:28:26 GMT"
   ; until="Wed, 20 Jan 2010 09:34:33 GMT"
   Content-Length: 23364
   Content-Type: text/html;charset=utf-8
   Connection: close
  
  ```

  

* **Patrón 1.2:** URI-R=URI-G; 200-Style Negotiation; Distinct URI-M

  En este caso se retorna un código 200, y una cabecera Content-Location hacia el URI-M

  Se debe usar de la siguiente manera:

  - La cabecera "Vary" es necesaria y debe incluir el valor "accept-datetime"
  - La respuesta **debe** incluir la cabecera "Memento-Datetime"
  - Se debe proporcionar el encabezado "Link", y debe incluir al menos un Relation Type = "original", hacia el URI-R

  

  Ejemplo de respuesta del Servidor para URI-R=URI-G en el patrón 1.1

  ```bash
  HTTP/1.1 302 Found
   Date: Thu, 21 Jan 2010 00:06:50 GMT
   Server: Apache
   Vary: accept-datetime #Esta cabecera ha de estar presente
   Content-Location:
   http://a.example.org/?version=20010320133610 # URI-M del memento para el recurso
   Memento-Datetime: Tue, 20 Mar 2001 13:36:10 GMT  #Esta cabecera ha de estar presente
   Link: <http://a.example.org/>; rel="original timegate",
    # Debe aparecer la cabecera Link, y debe incluir al menos un link de el tipo original de relación que tiene el URI-R, con el memento retornado
   	 <http://a.example.org/?version=20000915112826>
       ; rel="memento first"; datetime="Tue, 15 Sep 2000 11:28:26 GMT",
       <http://a.example.org/?version=20100120093433>
       ; rel="memento last"; datetime="Wed, 20 Jan 2010 09:34:33 GMT",
       <http://a.example.org/?version=all&style=timemap>
       ; rel="timemap"; type="application/link-format"
   Content-Length: 23364
   Content-Type: text/html;charset=utf-8
   Connection: close
  ```

  **Las siguientes peticiones son iguales al caso anterior**

  Petición del cliente para obtener el seleccionado Memento 

  ```
  GET /?version=20010320133610 HTTP/1.1
   Host: a.example.org
   Accept-Datetime: Tue, 20 Mar 2001 20:35:00 GMT
   Connection: close
  
  ```

  Respuesta del servidor con el memento seleccionado, solo se muestran las cabeceras, pero se obtendría también el body del recurso

  ```bash
  HTTP/1.1 200 OK # Código 200
  # No esta presente la cabecera Vary
   Date: Thu, 21 Jan 2010 00:06:51 GMT
   Server: Apache-Coyote/1.1
   Memento-Datetime: Tue, 20 Mar 2001 13:36:10 GMT # Debe incluirse la cabecera Memento-Datetime
   # Debe aparecer la cabecera Link, y debe incluir al menos un link de el tipo original de relación que tiene el URI-R, con el memento retornado
   Link: <http://a.example.org/>; rel="original timegate",
   <http://a.example.org/?version=all&style=timemap>
   ; rel="timemap"; type="application/link-format"
   ; from="Tue, 15 Sep 2000 11:28:26 GMT"
   ; until="Wed, 20 Jan 2010 09:34:33 GMT"
   Content-Length: 23364
   Content-Type: text/html;charset=utf-8
   Connection: close
  
  ```

  **Patrón 1.3:** URI-R=URI-G=URI-M; 200-Style Negotiation; No Distinct URI-M

  En este caso se retorna un código 200, y **no contiene** la cabecera Content-Location ni Location hacia el URI-M (La URI en este caso es la misma que URI-R y URI-G por lo que no es necesario)

  Se debe usar de la siguiente manera:

  - La cabecera "Vary" es necesaria y debe incluir el valor "accept-datetime"
  - La respuesta **debe** incluir la cabecera "Memento-Datetime"
  - Se debe proporcionar el encabezado "Link", y debe incluir al menos un Relation Type = "original", hacia el URI-R

  

  Ejemplo de respuesta del Servidor para URI-R=URI-G en el patrón 1.1

  ```bash
  HTTP/1.1 200 OK
   Date: Thu, 21 Jan 2010 00:06:50 GMT
   Server: Apache
   Vary: accept-datetime # Tiene que estar presente
   Memento-Datetime: Tue, 20 Mar 2001 13:36:10 GMT # Tiene que estar presente
   # Link hacia el time map y time gate
   Link: <http://a.example.org/>; rel="original timegate",
   <http://a.example.org/?version=all&style=timemap>
   ; rel="timemap"; type="application/link-format"
   Content-Length: 23364
   Content-Type: text/html;charset=utf-8
   Connection: close
  ```

  **Las siguientes peticiones son iguales al caso anterior**

  Petición del cliente para obtener el seleccionado Memento 

  ```
  GET /?version=20010320133610 HTTP/1.1
   Host: a.example.org
   Accept-Datetime: Tue, 20 Mar 2001 20:35:00 GMT
   Connection: close
  
  ```

  Respuesta del servidor con el memento seleccionado, solo se muestran las cabeceras, pero se obtendría también el body del recurso

  ```bash
  HTTP/1.1 200 OK # Código 200
  # No esta presente la cabecera Vary
   Date: Thu, 21 Jan 2010 00:06:51 GMT
   Server: Apache-Coyote/1.1
   Memento-Datetime: Tue, 20 Mar 2001 13:36:10 GMT # Debe incluirse la cabecera Memento-Datetime
   # Debe aparecer la cabecera Link, y debe incluir al menos un link de el tipo original de relación que tiene el URI-R, con el memento retornado
   Link: <http://a.example.org/>; rel="original timegate",
   <http://a.example.org/?version=all&style=timemap>
   ; rel="timemap"; type="application/link-format"
   ; from="Tue, 15 Sep 2000 11:28:26 GMT"
   ; until="Wed, 20 Jan 2010 09:34:33 GMT"
   Content-Length: 23364
   Content-Type: text/html;charset=utf-8
   Connection: close
  
  ```

  

###### Patrón 2:

 Un recurso remoto, actúa como un TimeGate para un Recurso Original. En esta implementación el recurso original no comparte URI con el TimeGate. Se suele usar cuando los servidores guardan versiones en sistemas diferentes, de la ubicación de los recursos originales.

Se resumen varios casos en la tabla bajo estas líneas mapeando respuestas con los sub-patrones descritos después

| Patrón     | Recurso Original | TimeGate | Memento | Código de Retorno |
| ---------- | ---------------- | -------- | ------- | ----------------- |
| Patrón 2.1 | URI-R            | URI-G    | URI-M   | 302               |
| Patrón 2.2 | URI-R            | URI-G    | URI-M   | 200               |
| Patrón 2.3 | URI-R            | URI-G    | URI-R   | 200               |

Se usan las siguientes cabeceras en las respuestas URI-R

* Cabecera **Vary** no debe estar presente
* La respuesta no contiene  la cabecera **"Memento-datetime"**
* La respuesta debe contener  la cabecera **"Link"** , pero no debe incluir un enlace a el tipo de relación "original". Si se determino un TimeGate para el Recurso Original, entonces deberá incluirse un link, con el tipo de relación "timegate" del TimeGate asociado. Si se determino un TimeMap para el Recurso Original, entonces deberá incluirse un link, con el tipo de relación "timegate" del URI-T asociado. Pueden existir múltiples Links tipo "timegate" o "timemap" si existen.

Para todos los patrones descritos, el cliente realizara la siguiente petición, para obtener el URI-G:

```
HTTP/1.1 200 OK
 Date: Thu, 21 Jan 2010 00:02:12 GMT
 Server: Apache
 Link: <http://arxiv.example.net/timegate/http://a.example.org/>
 ; rel="timegate"
 Content-Length: 255
 Connection: close
 Content-Type: text/html; charset=iso-8859-1
```

Una vez que el cliente obtiene al URI-G, puede comenzar la negociación con el TimeGate.

```
HEAD /timegate/http://a.example.org/ HTTP/1.1
 Host: arxiv.example.net
 Accept-Datetime: Tue, 20 Mar 2001 20:35:00 GMT
 Connection: close
```

**Patrón 2.1:** URI-R<>URI-G; 302-Style Negotiation; Distinct URI-M

En este caso se retorna un código 302, y una cabecera Location hacia el URI-M

Se debe usar de la siguiente manera:

- La cabecera "Vary" es necesaria y debe incluir el valor "accept-datetime"
- La respuesta **no debe** incluir la cabecera "Memento-Datetime"
- Se debe proporcionar el encabezado "Link", y debe incluir al menos un Relation Type = "original", hacia el URI-R



Ejemplo de respuesta del Servidor 

```bash
HTTP/1.1 302 Found
 Date: Thu, 21 Jan 2010 00:02:14 GMT
 Server: Apache
 Vary: accept-datetime # Requerido
 Location:# Localización del Memento
 http://arxiv.example.net/web/20010321203610/http://a.example.org/
 Link: <http://a.example.org/>; rel="original", # Link del Original Resource, con un timestamp recomendado para "from" y "until"
 <http://arxiv.example.net/timemap/http://a.example.org/>
 ; rel="timemap"; type="application/link-format"
 ; from="Tue, 15 Sep 2000 11:28:26 GMT"
 ; until="Wed, 20 Jan 2010 09:34:33 GMT"
 Content-Length: 0
 Content-Type: text

```

Petición del cliente para obtener el seleccionado Memento

```
GET /web/20010321203610/http://a.example.org/ HTTP/1.1
 Host: arxiv.example.net/
 Accept-Datetime: Tue, 20 Mar 2001 20:35:00 GMT
 Connection: close

```

Respuesta del servidor con el memento seleccionado, solo se muestran las cabeceras, pero se obtendría también el body del recurso, con las siguientes caracteristica

- No esta presente la cabecera "Vary"
- Esta presente la cabecera "Memento-Datetime"
- Aparece la cabecera Link, que contiene al menos un link al recurso original

```bash
HTTP/1.1 200 OK
 Date: Thu, 21 Jan 2010 00:02:15 GMT
 Server: Apache-Coyote/1.1
 Memento-Datetime: Wed, 21 Mar 2001 20:36:10 GMT
 Link: <http://a.example.org/>; rel="original",
 <http://arxiv.example.net/timemap/http://a.example.org/>
 ; rel="timemap"; type="application/link-format",
 <http://arxiv.example.net/timegate/http://a.example.org/>
 ; rel="timegate"
 Content-Length: 25532
 Content-Type: text/html;charset=utf-8
 Connection: close

```



**Patrón 2.2:** URI-R<>URI-G; 200-Style Negotiation; Distinct URI-M

En este caso se retorna un código 200, y una cabecera Location hacia cada URI-M

Se debe usar de la siguiente manera:

- La cabecera "Vary" es necesaria y debe incluir el valor "accept-datetime"
- La respuesta **debe** incluir la cabecera "Memento-Datetime"
- Se debe proporcionar el encabezado "Link", y debe incluir al menos un Relation Type = "original", hacia el URI-R



Ejemplo de respuesta del Servidor 

```bash
HTTP/1.1 200 OK
 Date: Thu, 21 Jan 2010 00:09:40 GMT
 Server: Apache-Coyote/1.1
 Vary: accept-datetime
 Content-Location: # Localizacion del memento
 http://arxiv.example.net/web/20010321203610/http://a.example.org/
 Memento-Datetime: Wed, 21 Mar 2001 20:36:10 GMT
 Link: <http://a.example.org/>; rel="original", # Link al recurso original
 <http://arxiv.example.net/timemap/http://a.example.org/>
 ; rel="timemap"; type="application/link-format", # Link al timemap
 <http://arxiv.example.net/timegate/http://a.example.org/>
 ; rel="timegate" # Link al timegate
 Content-Length: 25532
 Content-Type: text/html;charset=utf-8
 Connection: close


```

Petición del cliente para obtener el seleccionado Memento

```
GET /web/20010321203610/http://a.example.org/ HTTP/1.1
 Host: arxiv.example.net/
 Accept-Datetime: Tue, 20 Mar 2001 20:35:00 GMT
 Connection: close

```

La respuesta del servidor con el memento seleccionado es idéntica al caso anterior.

**Patrón 2.3:** URI-R<>URI-G; 200-Style Negotiation; No Distinct URI-M

En este caso se retorna un código 200, pero al ser identica la URI-M no necesita cabeceras "Content-Location" ni "Location"

Se debe usar de la siguiente manera:

- La cabecera "Vary" es necesaria y debe incluir el valor "accept-datetime"
- La respuesta **debe** incluir la cabecera "Memento-Datetime"
- Se debe proporcionar el encabezado "Link", y debe incluir al menos un Relation Type = "original", hacia el URI-R



Ejemplo de respuesta del Servidor 

```bash
HTTP/1.1 200 OK
 Date: Thu, 21 Jan 2010 00:09:40 GMT
 Server: Apache-Coyote/1.1
 Vary: accept-datetime
 Memento-Datetime: Wed, 21 Mar 2001 20:36:10 GMT
 Link: <http://a.example.org/>; rel="original",
 <http://arxiv.example.net/timemap/http://a.example.org/>
 ; rel="timemap"; type="application/link-format",
 <http://arxiv.example.net/timegate/http://a.example.org/>
 ; rel="timegate"
 Content-Length: 25532
 Content-Type: text/html;charset=utf-8
 Connection: close

```

Petición del cliente para obtener el seleccionado Memento

```
GET /web/20010321203610/http://a.example.org/ HTTP/1.1
 Host: arxiv.example.net/
 Accept-Datetime: Tue, 20 Mar 2001 20:35:00 GMT
 Connection: close

```

La respuesta del servidor con el memento seleccionado es idéntica al caso anterior.

###### Patrón 3:

Un Recurso Original, actúa como un recurso fijo. Este patrón no supone negociación de datetime con TimeGate. Puede usarse con recursos que no cambian de estado, o que no cambian mas allá de cierto punto de su existencia. Esto significa que URI-R y URI-M coinciden desde el principio, o desde algún punto de su existencia.

Se resumen varios casos en la tabla bajo estas líneas mapeando respuestas con los sub-patrones descritos después

| Patrón   | Recurso Original | TimeGate | Memento | Código de Retorno |
| -------- | ---------------- | -------- | ------- | ----------------- |
| Patrón 3 | URI-R            | -        | URI-R   | -                 |

Se usan las siguientes cabeceras en las respuestas URI-R

* Cabecera **Vary** **no** debe estar presente
* La respuesta no contiene  la cabecera **"Memento-datetime"**
* La respuesta debe contener  la cabecera **"Link"** , debe incluir un enlace a el tipo de relación "original". 

Para todos los patrones descritos, el cliente realizara la siguiente petición, para obtener el URI-G:

```
HTTP/1.1 200 OK
 Date: Thu, 21 Jan 2010 00:09:40 GMT
 Server: Apache-Coyote/1.1
 Memento-Datetime: Fri, 20 Mar 2009 11:00:00 GMT
 Link: <http://a.example.org/>; rel="original"
 Content-Length: 875
 Content-Type: text/html;charset=utf-8
 Connection: close
```



###### Patrón 4:

Mementos sin TimeGate. Esto ocurre cuando el servidor almacena mementos, pero no expone TimeGate para ellos. Esto puede ocurrir cuando los mementos son resultado de un snapshot de los datos de un servidor. Como resultado, solo hay un memento por cada recurso del servidor, haciendo el TimeGate innecesario.

Se resumen varios casos en la tabla bajo estas líneas mapeando respuestas con los sub-patrones descritos después

| Patrón   | Recurso Original | TimeGate | Memento | Código de Retorno |
| -------- | ---------------- | -------- | ------- | ----------------- |
| Patrón 4 | URI-R            | -        | URI-M   | -                 |

Se usan las siguientes cabeceras en las respuestas URI-R

* Cabecera **Vary** **no** debe estar presente
* La respuesta no contiene  la cabecera **"Memento-datetime"**
* La respuesta debe contener  la cabecera **"Link"** , debe incluir un enlace a el tipo de relación "original". 

Para todos los patrones descritos, el cliente realizara la siguiente petición, para obtener el URI-G:

```bash
HTTP/1.1 200 OK
 Date: Thu, 21 Jan 2010 00:09:40 GMT
 Server: Apache-Coyote/1.1
 Memento-Datetime: Wed, 21 Mar 2001 20:36:10 GMT
 Link: <http://a.example.org/>; rel="original",
 <http://arxiv.example.net/web/20010321203610/http://a.example.org/>
 ; rel="first last memento" # La convinacion de first last memento, indican que solo hay un memento para el recurso
 ; datetime="Wed, 21 Mar 2001 20:36:10 GMT"
 Content-Length: 25532
 Content-Type: text/html;charset=utf-8
 Connection: close

```



###### Casos especiales:

* **El recurso original no tiene Link "timegate" por alguna de las siguientes causas:** 

  * El recurso original no soporta el Framework memento
  *  El recurso original ya no existe, por lo tanto el servidor desconoce sus estados anteriores
  * El servidor donde se aloja el recurso no es accesible

  En todos los casos el cliente deberá de determinar un TimeGate apropiado para el recurso

* **El servidor existe, pero el Recurso Original no:** 

  Existen casos en los que el servidor sabe que el recurso existía, pero  no pude obtener la representación actual. En ese caso , el servidor pude si dispone de ello, retornar un Link con la representación anterior a la que si tenga acceso.

  ```bash
  HTTP/1.1 404 Not Found # Codigo 400, no encontrado
   Date: Thu, 21 Jan 2010 00:02:12 GMT
   Server: Apache
   Link:# Link a la versión anterior a la que si tiene acceso
   <http://arxiv.example.net/timegate/http://a.example.org/pic>
   ; rel="timegate"
   Content-Length: 255
   Content-Type:  text/html; charset=iso-8909-1
   Connection: close
  
  ```

* **Problemas con Accept-Datetime:** 

  Existen alguno de los siguientes problemas:

  - Si se pide una Fecha en la cabecera Accept-Datetime, menor que el recurso mas antiguo o mayor que el mas reciente. En ese caso se debe retornar el primer o ultimo documento según proceda.
  - El formato de fecha no es correcto segun lo expuesto, en ese caso, se retornara un código 400, Bad Request
  - Si no se incluye la cabecera Accept-Datetime, se debe de retornar el documento mas reciente

- **Memento con un código de Respuesta 3xx :** 

  En algunos casos la respuesta puede ofrecer una redirección del Memento para obtener el recurso. Corresponde al cliente, realizarla o no

- **Recursos excluidos de la negociación de contenidos:** 

  Algunos recursos deben de ser excluidos de la negociación de Datetime, por ejemplo ficheros Javascript de una pagina Web. En estos casos se usara la cabecera Link  con la URI de destino http://mementoweb.org/terms/donotnegotiate.

  ```
  HTTP/1.1 200 OK
   Date: Thu, 21 Jan 2010 00:09:40 GMT
   Server: Apache-Coyote/1.1
   Link: <http://mementoweb.org/terms/donotnegotiate>; rel="type"
   Content-Length: 238
   Content-Type: application/javascript; charset=UTF-8
   Connection: close
  
  ```

##### TimeMaps: Contenido y serialización

Los TimeMaps representan una lista de todos los Mementos, disponibles para un recurso. El Body retornado debe de ser:

- Puede retornar una lista de URI-R de un recurso original del que trata el TimeMap
- Puede retornar una lista del Memento (URI-M) y su DateTime, del que el servidor tiene constancia, preferiblemente en un documento o en varios por medio de Links con Relation type = "timemap"
- Debe retornar una lista de URI-G de todos los TimeGates de un recurso original que conoce el servidor
- Debe, para autocontenidos, listar todos los URI-T del mismo TimeMap
- Debe escribir sin ambigüedad los recursos originales, TimeGates, Mementos o TimeMaps

El Body puede serializarse de distintas formas, pero el formato link-value debe de soportarse. En esta serialización, el body debe serializase de la misma forma que una cabecera Link, y además cumplir con las restricciones impuestas en esta sección. El media type de la entidad debe de ser application/link-format. Debe de seguir la siguiente normativa:

- El IRI de contexto, debe de ser un parámetro de anclaje, cuando se especifica.
- El IRI de contexto, con el tipo de relacion "self", es la propia URI-T, del TimeMap, es decir la URI del recurso desde el cual se solicito el TimeMap

- El IRI de contexto de todos los demás enlaces es el URI-R del recurso original, que se proporciona como el IRI de destino del enlace con un tipo de relación "original".

Ejemplo: Para recuperar un TimeMap, el cliente solicita una serialización link-value

Petición de un TimeMap

```
GET /timemap/http://a.example.org/ HTTP/1.1
 Host: arxiv.example.net
 Accept: application/link-format;q=1.0
 Connection: close
```

Respuesta (si existe el TimeMap del recurso)

```html
<!--HEADERS-->
HTTP/1.1 200 OK
 Date: Thu, 21 Jan 2010 00:06:50 GMT
 Server: Apache
 Content-Length: 4883
 Content-Type: application/link-format
 Connection: close

<!--SERIALIZED BODY-->
 <http://a.example.org>;rel="original", <!--RECURSO ORIGINAL-->
 <http://arxiv.example.net/timemap/http://a.example.org>
 ; rel="self";type="application/link-format"
 ; from="Tue, 20 Jun 2000 18:02:59 GMT" <!--RANGO FROM UNTIL-->
 ; until="Wed, 09 Apr 2008 20:30:51 GMT",
 <http://arxiv.example.net/timegate/http://a.example.org> <!--TimeGate-->
 ; rel="timegate",
 <!--Lista de Mementos-->    
 <http://arxiv.example.net/web/20000620180259/http://a.example.org> 
 ; rel="first memento";datetime="Tue, 20 Jun 2000 18:02:59 GMT"
 ; license="http://creativecommons.org/publicdomain/zero/1.0/",
 <http://arxiv.example.net/web/20091027204954/http://a.example.org>
 ; rel="last memento";datetime="Tue, 27 Oct 2009 20:49:54 GMT"
 ; license="http://creativecommons.org/publicdomain/zero/1.0/",
 <http://arxiv.example.net/web/20000621011731/http://a.example.org>
 ; rel="memento";datetime="Wed, 21 Jun 2000 01:17:31 GMT"
 ; license="http://creativecommons.org/publicdomain/zero/1.0/",
 <http://arxiv.example.net/web/20000621044156/http://a.example.org>
 ; rel="memento";datetime="Wed, 21 Jun 2000 04:41:56 GMT"
 ; license="http://creativecommons.org/publicdomain/zero/1.0/",
 ...

```

**Casos Especiales**

- **Indexando y paginando TimeMaps**

  Existen casos en que un TimeMap apunta a uno o mas TimeMaps:

  - **Index TimeMap:** Un TimeMap puede apuntar a otros TimeMaps en vez de a mementos. Suele suceder cuando los mementos son repartidos en varios archivos que comparten un front-end.

    ```html
    <http://a.example.org>;rel="original",
     <http://arxiv.example.net/timegate/http://a.example.org>
     ; rel="timegate",
     <http://arxiv.example.net/timemap/http://a.example.org>
     ; rel="self";type="application/link-format",
     <!--Time Maps-->
     <http://arxiv1.example.net/timemap/http://a.example.org>
     ; rel="timemap";type="application/link-format"
     ; from="Wed, 21 Jun 2000 04:41:56 GMT"
     ; until="Wed, 09 Apr 2008 20:30:51 GMT",
     <http://arxiv2.example.net/timemap/http://a.example.org>
     ; rel="timemap";type="application/link-format"
     ; from="Thu, 10 Apr 2008 20:30:51 GMT"
     ; until="Tue, 27 Oct 2009 20:49:54 GMT",
     <http://arxiv3.example.net/timemap/http://a.example.org>
     ; rel="timemap";type="application/link-format"
     ; from="Thu, 29 Oct 2009 20:30:51 GMT"
    
    ```

    

  -  PagingTimeMap:** Un numero elevado de mementos, puede requerir introducir multiples TimeMaps que puedan ser paginados.

    ```html
    <http://a.example.org>;rel="original",
     <http://arxiv.example.net/timegate/http://a.example.org>
     ; rel="timegate",
     <http://arxiv.example.net/timemap/1/http://a.example.org>
     ; rel="self";type="application/link-format"
     ; from="Tue, 20 Jun 2000 18:02:59 GMT"
     ; until="Wed, 09 Apr 2008 20:30:51 GMT",
     <!--Time Maps-->
     <http://arxiv.example.net/timemap/2/http://a.example.org>
     ; rel="timemap";type="application/link-format"
     ; from="Thu, 10 Apr 2008 20:30:51 GMT"
     ; until="Tue, 27 Oct 2009 20:49:54 GMT",
     <http://arxiv.example.net/timemap/3/http://a.example.org>
     ; rel="timemap";type="application/link-format"
     ; from="Thu, 29 Oct 2009 20:30:51 GMT"
     ; until="Fri, 31 Aug 2012 12:22:34 GMT"
     <http://arxiv.example.net/web/20000620180259/http://a.example.org>
     ; rel="memento";datetime="Tue, 20 Jun 2000 18:02:59 GMT",
     <http://arxiv.example.net/web/20000621011731/http://a.example.org>
     ; rel="memento";datetime="Wed, 21 Jun 2000 01:17:31 GMT",
     <http://arxiv.example.net/web/20000621044156/http://a.example.org>
     ; rel="memento";datetime="Wed, 21 Jun 2000 04:41:56 GMT",
     ...
    ```

- **Mementos para TimeMaps**

  Un TimeMap puede actuar como un recurso original para el que existen TimeGates y Mementos, por lo tanto le corresponde al mismo TimeMap, incluir "timegate" para lincar con el TimeGate a través del la propia versión del TimeMap que esta disponible. En estos casos URI-T=URI-R=URI-G 

#### Consideraciones de seguridad

Avisar de "timegate" en la cabecera Link, cuando se produce un código 401 o 403 es Opcional, y por lo tanto depende de la implementación del servidor. Hay casos en los que se protege la versión actual, y se permite acceder a versiones anteriores del documento por medio de la cabecera Link.



#### Referencias

[Memento specification]: https://tools.ietf.org/pdf/rfc7089.pdf	"Los Alamos National Laboratory"








