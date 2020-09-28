![](./images/logos_feder.png)



Implementación del protocolo OIA PMH
====================================



[**Servicio ListIdentifiers** ](#servicio-listidentifiers)

[**Servicio GetRecord** ](#servicio-getrecord)

[**Más información sobre el protocolo**](#más-información-sobre-el-protocolo)



**Servicio ListIdentifiers**
------------------------------------------

<http://www.openarchives.org/OAI/openarchivesprotocol.html#ListIdentifiers>



Parámetros:

-   *from*, argumento opcional con formato UTC datetime. Indica la fecha
    desde la que debe mandar los datos. Si no existe, se enviarán todos
    los datos modificados hasta la fecha until, o la actual.

-   *until,* argumento opcional con formato UTC datetime. Indica la
    fecha hasta la que debe mandar los datos. Si no existe, se tomará
    como fecha la fecha actual.



Este servicio va a devolver la lista de los identificadores de CVN que
se han creado, modificado o añadido entre la fecha *from* y la fecha
*until.*



El servicio devolverá los siguientes errores, además de los errores http
comunes, si es necesario:

-   **badArgument** -- Si se envían mal los parámetros o falta alguno.

-   **badResumptionToken** -- Si el valor de resumptionToken es inválido
    o a expirado

-   **noRecordsMatch**- Si no hay resultados.



### Respuesta correcta:

Enviará un XML con la siguiente estructura donde:

-   **responseDate**: Es la fecha de la respuesta, deberá coincidir con
    el parámetro *from*.

-   **ListIdentifiers**: Contiene el listado de identificadores que se
    han modificado entre las fechas enviadas por parámetro.

    -   **header**: Identifica cada item. El atributo status=\"deleted"
        indicará si ese ítem ha sido borrado.

        -   **identifier**: El identificador único, con este podremos
            llamar a GetRecord.

        -   **datestamp**: La fecha de modificación del ítem.





\<?xml version=\"1.0\" encoding=\"UTF-8\"?\>

\<OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/"

xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd" >

\<responseDate\>2002-06-01T19:30:00Z\</responseDate\>

\<request verb=\"ListIdentifiers\" from=\"1998-01-15\"\> \</request\>

\<ListIdentifiers\>

\<header\>

\<identifier\>1\</identifier\>

\<datestamp\>2020-04-23\</datestamp\>

\</header\>

\<header\>

\<identifier\>2\</identifier\>

\<datestamp\>2020-04-23\</datestamp\>

\</header\>

\<header\>

\<identifier\>3\</identifier\>

\<datestamp\>2020-04-23\</datestamp\>

\</header\>

\<header status=\"deleted\"\>

\<identifier\>4\</identifier\>

\<datestamp\>2020-04-23\</datestamp\>

\</header\>

\<header\>

\<identifier\>5\</identifier\>

\<datestamp\>2020-04-23\</datestamp\>

\</header\>

\</ListIdentifiers\>

\</OAI-PMH\>



### Respuesta indicando error:



\<?xml version=\"1.0\" encoding=\"UTF-8\"?\>

\<OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/"

xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"

xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/" >

\<responseDate\>2002-02-08T14:27:19Z\</responseDate\>

\<request verb=\"ListIdentifiers\" from=\"2001-01-01\" until=\"2001-01-01\"\>

\</]request\>

\<error code=\"noRecordsMatch\"/\>

\</OAI-PMH\>

**Servicio GetRecord**
------------------------------------

<http://www.openarchives.org/OAI/openarchivesprotocol.html#GetRecord>



Parámetros:

-   *identifier*, identificador del ítem que queremos obtener.



Este servicio va a devolver el CVN que corresponde con el identificador
enviado como parámetro.



El servicio devolverá los siguientes errores, además de los errores http
comunes, si es necesario:

-   **badArgument** -- Si se envían mal los parámetros o falta alguno.

-   **idDoesNotExist** - Si no existe un CVN con ese identificador.



### Respuesta correcta:

Enviará un XML con la siguiente estructura donde:

-   **responseDate**: Es la fecha de la respuesta, deberá coincidir con
    el parámetro *from*.

-   **GetRecord**: Contiene la información.

    -   **header**: El atributo status=\"deleted" indicará si ese ítem
        ha sido borrado, en este caso no se recibirá metadata.

        -   **identifier**: El identificador único, con este podremos
            llamar a GetRecord.

        -   **datestamp**: La fecha de modificación del ítem.

    -   Metadata

        -   CVN: Contiene el CVN.





\<?xml version=\"1.0\" encoding=\"UTF-8\"?\>

\<OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/"

xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"

xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd" >

\<responseDate\>2002-02-08T08:55:46Z\</responseDate\>

\<request verb=\"GetRecord\" identifier=\"1\"\>\</request\>

\<GetRecord\>

\<record\>

\<header\>

\<identifier\>1</identifier\>

\<datestamp\>2001-12-14\</datestamp\>

\<setSpec\>cs\</setSpec\>

\<setSpec\>math\</setSpec\>

\</header\>

\<metadata\>

\<CVN xmlns="http://codes.cvn.fecyt.es/beans" >

\<CvnItemBean\>

\<Code\>060.030.010.000\</Code\>

\<CvnDateDayMonthYear\>

\<Code\>060.030.010.130\</Code\>

\<Value\>1999-01-01T00:00:00.000+01:00\</Value\>

\</CvnDateDayMonthYear\>

\<CvnDouble\>

\<Code\>060.030.010.120\</Code\>

\<Value\>12020.24\</Value\>

\</CvnDouble\>

\<CvnDuration\>

\<Code\>060.030.010.140\</Code\>

\<Value\>P1Y0M1DT0H0M0S\</Value\>

\</CvnDuration\>

\<CvnEntityBean\>

\<Code\>060.030.010.080\</Code\>

\<Name\>FUNDACION SENECA\</Name\>

\</CvnEntityBean\>

\<CvnString\>

\<Code\>060.030.010.010\</Code\>

\<Value\>AYUDAS A GRUPOS CONSOLIDADOS\</Value\>

\</CvnString\>

\<CvnString\>

\<Code\>060.030.010.020\</Code\>

\<Value\>724\</Value\>

\</CvnString\>

\<CvnString\>

\<Code\>060.030.010.030\</Code\>

\<Value\>ES62\</Value\>

\</CvnString\>

\<CvnString\>

\<Code\>060.030.010.150\</Code\>

\<Value\>MURCIA\</Value\>

\</CvnString\>

\<CvnString\>

\<Code\>060.030.010.060\</Code\>

\<Value\>OTHERS\</Value\>

\</CvnString\>

\<CvnString\>

\<Code\>060.030.010.070\</Code\>

\<Value\>AYUDAS A GRUPOS CONSOLIDADOS Y DE ALTO RENDIMIENTO
CIENTIFIO\</Value\>

\</CvnString\>

\<CvnString\>

\<Code\>060.030.010.100\</Code\>

\<Value\>070\</Value\>

\</CvnString\>

\</CvnItemBean\>

\</CVN\>

\</metadata\>

\</record\>

\</GetRecord\>

\</OAI-PMH\>



### Respuesta indicando error:

\<?xml version=\"1.0\" encoding=\"UTF-8\"?\>

\<OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/"

xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"

xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd" >

\<responseDate\>2002-02-08T08:55:46Z\</responseDate\>

\<request verb=\"GetRecord\" identifier=\"1"\> \</request\>

\<error code=\"idDoesNotExist\"\>No matching identifier in
arXiv\</error\>

\</OAI-PMH\>





**Más información sobre el protocolo**
-----------------------------------------------------

-   Open Archives Initiative - Protocol for Metadata Harvesting - v.2.0.
    (s. f.). Recuperado 5 de mayo de 2020, de
    <http://www.openarchives.org/OAI/openarchivesprotocol.html>
