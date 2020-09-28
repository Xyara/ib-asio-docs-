![](./images/logos_feder.png)

﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿# Despliegue en entorno de desarrollo para la Universidad de Murcia

---

## Entornos 

### Hardware  

&nbsp;

| Nombre           | herc-iz-front-desa.atica.um.es            | herc-iz-back-desa.atica.um.es             | herc-iz-bd-desa.atica.um.es               |
| ---------------- | ----------------------------------------- | ----------------------------------------- | ----------------------------------------- |
| **IP**           | 155.54.239.207                            | 155.54.239.208                            | 155.54.239.209                            |
| **SO**           | CentOS Linux release 7.7.1908             | CentOS Linux release 7.7.1908             | CentOS Linux release 7.7.1908             |
| **MEMORIA**      | 8GB                                       | 16GB                                      | 8GB                                       |
| **PROCESADOR**   | Intel Core i7 9xx (Nehalem Class Core i7) | Intel Core i7 9xx (Nehalem Class Core i7) | Intel Core i7 9xx (Nehalem Class Core i7) |
| **CORES**        | 4                                         | 4                                         | 4                                         |
| **ARQUITECTURA** | 64                                        | 64                                        | 64                                        |

&nbsp;

###Usuario

&nbsp;

Se crea el usuario **herculesizertis** en todos los entornos para realizar tareas de despliegue y gestión.

&nbsp;

##Instalaciones

### Docker

---

&nbsp;

Instalar dependencias   
`
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
`   
&nbsp;

Añadir repositorio   
`
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
`   
&nbsp;

Instalar docker-ce   
`
sudo yum install docker-ce
`   
&nbsp;

Añadir el usuario actual el grupo docker   
`
sudo usermod -aG docker $(whoami)
`   
&nbsp;

Configurar el servicio Docker para comenzar automáticamente en cada reinicio   
`
sudo systemctl enable docker.service
`   
&nbsp;

Arrancar servicio  
`
sudo systemctl start docker.service
`   
&nbsp;

### Crear usuario   

----

&nbsp;

Crear grupo de usuario   
`
sudo groupadd herculesizertis
`   
&nbsp;

Crear  usuario **herculesizertis**  
`
sudo useradd -g herculesizertis  -d /home/herculesizertis -m -p h3rcul3s1z3rt1s herculesizertis`   

&nbsp;

Añadir grupos **herculesizertis**  
`sudo usermod -a -G sistemas herculesizertis`   
`sudo usermod -a -G docker herculesizertis`  

&nbsp;


Cambiar el grupo  
`sudo usermod -a -G sistemas herculesizertis`   
`sudo usermod -a -G docker herculesizertis`  

&nbsp;


Dar los permisos a usuario  
`usermod -a -G wheel herculesizertis`   

&nbsp;


Cambiar de usuario   

`su herculesizertis`  

- Password: h3rcul3s1z3rt1s

&nbsp;

Dar los permisos a usuario  
`usermod -a -G wheel herculesizertis`   

&nbsp;

Cambiar grupo principal

`newgrp docker`

&nbsp;

### Instalar docker-compose   

----

&nbsp;

Actualizar

`
 yum update -y
`   
&nbsp;


Instalar dependencias

`
sudo yum install epel-release
`   
&nbsp;

Instalar Python y gcc

`
 sudo yum install -y python-pip python-devel gcc
`   
&nbsp;

Actualizar python

`
 sudo yum upgrade python*
`   
&nbsp;

Actualizar pip

`
 sudo pip install --upgrade pip
`   
&nbsp;

Instalar docker-compose

`
 sudo pip install docker-compose
`   
&nbsp;

Comprobar instalacion

`
docker-compose version
`   
&nbsp;

##Despliegue  

###Servicios
---

Se determina en la fase inicial del proyecto, desplegar todos los servicios en la maquina herc-iz-bd-desa.atica.um.es, posteriormente según la volumetría de datos y el consumo de maquina, podría estimarse la posibilidad de mover algunos de ellos a otras maquinas.

Los servicios desplegados son:

- **MySQL**
  Nombre Servicio: **mysql_db**
  Alias: **mongo.svc**
  Puertos: **3306**
  Password Root: **1z3rt1s**
  User: **hercules**
  Password: **h3rcul3s**
  Databases: **wikibase, management**
  Dependencias: **-**
- **MongoDB**
  Nombre Servicio: **mongo_db**
  Alias: **mongo.svc**
  Puertos: **27017**
  Dependencias: **-**
- **Elasticsearch**
  Nombre Servicio: **elasticsearch**
  Alias: **elasticsearch.svc**
  Puertos: **9200**
  Dependencias: **-**
- **Wikibase**
  - **wikibase**
    Nombre Servicio: **mysql_db**
    Alias: **wikibase.svc**
    Puertos: **8181**
    MW\_ADMIN\_NAME: **WikibaseAdmin**
    MW\_ADMIN\_PASS: **WikibaseAdminPass**
    MW\_ADMIN\_EMAIL: **druiz@izertis.com**
    MW\_WG_SECRET\_KEY: **h3rcul3s**
    Dependencias: **mysql_db, elasticsearch**
  - **wdqs**
    Nombre Servicio: **wdqs**
    Alias: **wdqs.svc**
    Puertos: **9999**
    Dependencias: **wikibase**
  - **wdqs-proxy**
    Nombre Servicio: **wdqs-proxy**
    Alias: **wdqs-proxy.svc**
    Puertos: **8989**
    Dependencias: **wdqs**
  - **wdqs-updater**
    Nombre Servicio: **wdqs-updater**
    Dependencias: **wdqs, wikibase**
  - **wdqs-updater**
    Nombre Servicio: **wdqs-updater**
    Dependencias: **wdqs, wikibase**
  - **quickstatements**
    Nombre Servicio: **wdqs-proxy**
    Alias: **quickstatements.svc**
    Puertos: **9191**
    Dependencias: **wikibase**
- **Kafka**
  - **zookeeper**
    Nombre Servicio: **zookeeper**
    Puertos: **2181**
    Dependencias: **-**
  - **kafka**
    Nombre Servicio: **wdqs**
    Alias: **wdqs.svc**
    Build: **DockerFile**
    Puertos: **9092**
    Dependencias: **zookeeper**
- **Graylog**
  Nombre Servicio: **graylog**
  Puertos: **9000 (API REST), Syslog TCP/UDP (1514),  GELF TCP/UDP (12201)**
  GRAYLOG\_PASSWORD\_SECRET: **1z3rt1sH3rcul3s?**
  GRAYLOG_ROOT_PASSWORD_SHA2: **d094d2fbb2c507c4ffe3c0073568e83f89c9993af7003efa94d93d77**
  GRAYLOG\_HTTP\_EXTERNAL\_URI: `http://127.0.0.1:9000/`
  Dependencias: **mongo_db, elasticsearch**

#### Despliegue

&nbsp;

**Requisitos**:  

- Docker-compose.yaml (en ruta )
  &nbsp;

```yaml
# Wikibase with Query Service
#
# This docker-compose example can be used to pull the images from docker hub.
#
# Examples:
#
# Access Wikibase via "http://localhost:8181"
#   (or "http://$(docker-machine ip):8181" if using docker-machine)
#
# Access Query Service via "http://localhost:8282"
#   (or "http://$(docker-machine ip):8282" if using docker-machine)
version: '3'

services:
  mysql_db:
    image: mysql:5.7
    restart: unless-stopped
    volumes:
      - mysql-data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: "1z3rt1s"
      MYSQL_USER: "hercules"
      MYSQL_PASSWORD: "h3rcul3s"
      MYSQL_DATABASE: "wikibase"
    ports:
      # <Port exposed> : < MySQL Port running inside container>
      - '3306:3306'
    expose:
      # Opens port 3306 on the container
      - '3306'
    entrypoint:
      sh -c "
        echo 'CREATE DATABASE IF NOT EXISTS management;' > /docker-entrypoint-initdb.d/init.sql;
        /usr/local/bin/docker-entrypoint.sh --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci"
    networks:
      default:
        aliases:
          - mysql.svc
  mongo_db:
    image: mongo:latest
    restart: unless-stopped
    volumes:
      - mongo-data:/data/db
      - mongo-config:/data/configdb
    ports:
      # <Port exposed> : < MySQL Port running inside container>
      - '27017:27017'
    networks:
      default:
        aliases:
          - mongo.svc
  elasticsearch:
    image: wikibase/elasticsearch:5.6.14-extra
    restart: unless-stopped
    volumes:
      - elasticsearch-data:/usr/share/elasticsearch/data
    environment:
      'http.host': '0.0.0.0'
      'transport.host': 'localhost'
      'network.host': '0.0.0.0'
      'discovery.type': 'single-node'
      ES_JAVA_OPTS: "-Xms512m -Xmx512m"
    ports:
    - 9200:9200
    ulimits:
      memlock:
        soft: -1
        hard: -1
    networks:
      default:
        aliases:
          - elasticsearch.svc
  # wikibase
  wikibase: # Wikibase
    image: wikibase/wikibase:1.33-bundle
    links:
      - mysql_db
    ports:
      # CONFIG - Change the 8181 here to expose Wikibase & MediaWiki on a different port
      - "8181:80"
    expose:
      - 8181
    volumes:
      - mediawiki-images-data:/var/www/html/images
      - quickstatements-data:/quickstatements/data
    depends_on:
      - mysql_db
      - elasticsearch
    restart: unless-stopped
    networks:
      default:
        aliases:
          - wikibase.svc
          # CONFIG - Add your real wikibase hostname here, for example wikibase-registry.wmflabs.org
    environment:
      - DB_SERVER=mysql.svc:3306
      - MW_ELASTIC_HOST=elasticsearch.svc
      - MW_ELASTIC_PORT=9200
      # CONFIG - Change the default values below
      - MW_ADMIN_NAME=WikibaseAdmin
      - MW_ADMIN_PASS=WikibaseAdminPass
      - MW_ADMIN_EMAIL=admin@example.com
      - MW_WG_SECRET_KEY=secretkey
      # CONFIG - Change the default values below (should match mysql values in this file)
      - DB_USER=hercules
      - DB_PASS=h3rcul3s
      - DB_NAME=wikibase
      - QS_PUBLIC_SCHEME_HOST_AND_PORT=http://localhost:9191
  wdqs: # wikibase
    image: wikibase/wdqs:0.3.10
    restart: unless-stopped
    volumes:
      - query-service-data:/wdqs/data
    command: /runBlazegraph.sh
    environment:
      - WIKIBASE_HOST=wikibase.svc
      - WDQS_HOST=wdqs.svc
      - WDQS_PORT=9999
    expose:
      - 9999
    networks:
      default:
        aliases:
          - wdqs.svc
  wdqs-proxy: # Proxy to put infront of the wdqs image enforcing READONLY requests query timeouts
    image: wikibase/wdqs-proxy
    restart: unless-stopped
    environment:
      - PROXY_PASS_HOST=wdqs.svc:9999
    ports:
      - "8989:80"
    depends_on:
      - wdqs
    networks:
      default:
        aliases:
          - wdqs-proxy.svc
  wdqs-updater:
    image: wikibase/wdqs:0.3.10
    restart: unless-stopped
    command: /runUpdate.sh
    depends_on:
      - wdqs
      - wikibase
    networks:
      default:
        aliases:
          - wdqs-updater.svc
    environment:
      - WIKIBASE_HOST=wikibase.svc
      - WDQS_HOST=wdqs.svc
      - WDQS_PORT=9999
  quickstatements:
    image: wikibase/quickstatements:latest
    ports:
      - "9191:80"
    depends_on:
      - wikibase
    volumes:
      - quickstatements-data:/quickstatements/data
    networks:
      default:
        aliases:
          - quickstatements.svc
    environment:
      - QS_PUBLIC_SCHEME_HOST_AND_PORT=http://localhost:9191
      - WB_PUBLIC_SCHEME_HOST_AND_PORT=http://localhost:8181
      - WIKIBASE_SCHEME_AND_HOST=http://wikibase.svc
      - WB_PROPERTY_NAMESPACE=122
      - "WB_PROPERTY_PREFIX=Property:"
      - WB_ITEM_NAMESPACE=120
      - "WB_ITEM_PREFIX=Item:"
  # kafka
  zookeeper:
    image: bitnami/zookeeper:3.5.6
    ports:
      - 2181:2181
    volumes:
      - zookeeper_data:/bitnami
    environment:
      - ALLOW_ANONYMOUS_LOGIN=yes
  kafka:
    image: bitnami/kafka:2.4.0
    ports:
      - 9092:9092
      - 29092:29092
    volumes:
      - kafka_data:/bitnami
    environment:
      - KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper:2181
      - ALLOW_PLAINTEXT_LISTENER=yes
      - KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
      - KAFKA_CFG_LISTENERS=PLAINTEXT://:9092,PLAINTEXT_HOST://:29092
      - KAFKA_CFG_ADVERTISED_LISTENERS=PLAINTEXT://kafka:9092,PLAINTEXT_HOST://155.54.239.209:29092
     #  - KAFKA_CREATE_TOPICS: input-data:1:1,general-data:1:1,success-data:1:1,management-system-data:1:1
    depends_on:
      - zookeeper
  # graylog
  graylog:
    image: graylog/graylog:3.1
    environment:
      GRAYLOG_PASSWORD_SECRET: 1z3rt1sH3rcul3s?
      GRAYLOG_ROOT_PASSWORD_SHA2: d094d2fbb2c507c4ffe3c0073568e83f89c9993af7003efa94d93d77
      GRAYLOG_HTTP_EXTERNAL_URI: http://127.0.0.1:9000/
    links:
      - mongo_db:mongo
      - elasticsearch
    depends_on:
      - mongo_db
      - elasticsearch
    ports:
      # Graylog web interface and REST API
      - 9000:9000
      # Syslog TCP
      - 1514:1514
      # Syslog UDP
      - 1514:1514/udp
      # GELF TCP
      - 12201:12201
      # GELF UDP
      - 12201:12201/udp
volumes:
  mysql-data:
  mongo-data:
  mongo-config:
  elasticsearch-data:
  mediawiki-images-data:
  quickstatements-data:
  query-service-data:
  zookeeper_data:
  kafka_data:

```



&nbsp;


**Despliegue**:

&nbsp;

1.- copiar todos los ficheros en el usuario herculesizertis carpeta deploy

2.- Ejecutar los comandos para desplegar:

&nbsp;

Ejecutar docker-compose en segundo plano

`docker-compose up -d`

&nbsp;

Ver los logs

`docker-compose logs -f -t`

&nbsp;

Ver contenedores

`docker-compose ps`

&nbsp;

Deneter docker-compose

`docker-compose down`

&nbsp;

Deneter docker-compose

`docker-compose down`

&nbsp;

Deneter docker-compose y borrar volumenes

`docker-compose down -v`

&nbsp;

Borrar todo

`docker-compose rm`

&nbsp;


###Micro-servicios
---

Las imágenes de los micro servicios se encuentran en el repositorio ACR de Azure.

Es necesario logarse para poder acceder a las imágenes. Los datos relativos a el login se pueden encontrar en [sysPass](https://sysp.izertis.com/index.php?r=login)

Existe el fichero acr_pass.txt en la ruta /deploy del usuario HerculesIzertis para facilitar el proceso de login usando el comando

```
cat acr_pass.txt | docker login --username umansioacr --password-stdin umansioacr.azurecr.io
```

Se determina desplegar todos los servicios en la maquina herc-iz-back-desa.atica.um.es.

Los servicios desplegados son:

- **input-processor** (servicio)
  Nombre Servicio: **input-processor**

  Función: Micro servicio que recibe los datos, da formato canónico, y los propaga por medio de una cola kafka hacia el microservicio wikibase-event-processor

  Puertos: **9321**
  APP_KAFKA_INPUT_TOPIC_NAME: **input-data**
  APP_KAFKA_GENERAL_TOPIC_NAME: **general-data**
  APP_KAFKA_CREATE_TOPICS: **true**
  SPRING_KAFKA_BOOTSTRAP_SERVERS: **herc-iz-bd-desa.atica.um.es:29092**

  SPRING_KAFKA_CONSUMER_BOOTSTRAP_SERVERS: **herc-iz-bd-desa.atica.um.es:29092**
  SPRING_KAFKA_CONSUMER_GROUP_ID:  **input-processor**

  SPRING_PROFILES_ACTIVE: **des**

  Dependencias: **wikibase-event-processor**

- **wikibase-event-processor **(servicio)
  Nombre Servicio: **wikibase-event-processor**

  Función: Micro servicio que recibe los datos, desde la cola kafka, lanzados por el microservicio input-processor y los lanza síncronamente hacía el microservicio wikibase-storage-adapter para su almacenamiento en wikibase va API Rest.

  Puertos: **9323**
  APP_KAFKA_MANAGEMENT_TOPIC_NAME: **management-data**
  APP_KAFKA_CREATE_TOPICS: **true**
  SPRING_KAFKA_BOOTSTRAP_SERVERS: **true**
  SPRING_KAFKA_BOOTSTRAP_SERVERS: **herc-iz-bd-desa.atica.um.es:29092**

  SPRING_KAFKA_CONSUMER_BOOTSTRAP_SERVERS: **herc-iz-bd-desa.atica.um.es:29092**
  SPRING_KAFKA_CONSUMER_GROUP_ID: **wikibase-event-processor**
  APP_MICROSERVICES_WIKIBASE_STORAGE_ADAPTER_BASE_URL: `http://wikibase-storage-adapter:8084`

  SPRING_PROFILES_ACTIVE: **des**

  Dependencias: **wikibase-storage-adapter**

- **wikibase-storage-adapter** (servicio)
  Nombre Servicio: **management-system**

  Función: Guardar los datos procedentes de el servicio wikibase-event-processor, en wikibase.

  Puertos: **8084 **APP_KAFKA_SUCCESS_TOPIC_NAME: "success-data"
  APP_KAFKA_CREATE_TOPICS: **true**
  SPRING_KAFKA_BOOTSTRAP_SERVERS: **herc-iz-bd-desa.atica.um.es:29092**
  APP_SWAGGER_ENABLED: **true**
  APP_DATA_PATH: **""**
  APP_DATA_INITIAL: **true**
  APP_WIKIBASE_API_URL: `http://herc-iz-bd-desa.atica.um.es:8181/api.php`
  APP_WIKIBASE_API_USERNAME: **WikibaseAdmin**
  APP_WIKIBASE_API_PASSWORD: **WikibaseAdminPass**
  APP_WIKIBASE_QUERY_DEFAULT_LANGUAGE: **es**
  APP_WIKIBASE_SITE_URI: `http://herc-iz-bd-desa.atica.um.es:8181/entity/`
  SPRING_PROFILES_ACTIVE: **des**
  GRAYLOG_HOST: "herc-iz-bd-desa.atica.um.es"

  Dependencias: **wikibase**

- **management-system** (servicio)
  Nombre Servicio: **management-system**
  Puertos: **8080 **

  Función: Microservicio encargado de centralizar la gestión del sistema

  APP_KAFKA_GENERAL_TOPIC_NAME: **general-data**
  APP_KAFKA_MANAGEMENT_TOPIC_NAME: **management-system-data**
  APP_KAFKA_CREATE_TOPICS: **true**
  SPRING_KAFKA_BOOTSTRAP_SERVERS: **herc-iz-bd-desa.atica.um.es:29092**
  SPRING_KAFKA_CONSUMER_BOOTSTRAP_SERVERS: **herc-iz-bd-desa.atica.um.es:29092**
  SPRING_KAFKA_CONSUMER_GROUP_ID: **management-system**
  APP_SWAGGER_ENABLED: **true**
  SPRING_PROFILES_ACTIVE: **des**
  GRAYLOG_HOST: "herc-iz-bd-desa.atica.um.es"

  Dependencias: **-**

  

- **simulator-importer** (batch job)
  Nombre Servicio: **simulator-importer**
  Puertos: **8080 **

  Función: Job java lanzado periódicamente para leer de un fichero desde una determinada ruta, y lanzar los datos leídos hacia el microservicio input-processor por medio de una cola kafka. Puede ser lanzado con 3 Job distintos:

  `- academicInstitutionJob`: job encargado de simular datos de tipo "Academic institution"

  - Datos Inciales:

    - Nombre csv: **academic_institution_initial.csv**
    - Dockerfile: **DockerfileACIN**
    - Nombre imagen docker: **simulator-importer-academic-init:1.0**

  - Datos completos:

    - Nombre csv: **academic_institution.csv**

    - Dockerfile: **DockerfileACIN**
    - Nombre imagen docker: **simulator-importer-academic:1.0**

  `- researcherJob`: job encargado de simular datos de tipo "Researcher"

  - Datos Inciales:

    - Nombre csv: **researcher_initial.csv**
    - Dockerfile: **DockerfileREIN**
    - Nombre imagen docker: **simulator-importer-researcher-title-init:1.0**

  - Datos completos:

    - Nombre csv: **researcher.csv**

    - Dockerfile: **DockerfileRENIN**
    - Nombre imagen docker: **simulator-importer-researcher-title:1.0**

    

  `- titleDegreeJob`: job encargado de simular datos de tipo "Title - Degree" 

  - Datos Inciales:

    - Nombre csv: **title_degree_initial.csv**
    - Dockerfile: **DockerfileTDIN**
    - Nombre imagen docker: **simulator-importer-researcher-title-init:1.0**

  - Datos completos:

    - Nombre csv: **title_degree.csv**

    - Dockerfile: **DockerfileTDNIN**
    - Nombre imagen docker: **simulator-importer-researcher-title:1.0**

  

  Se crean 6 imagenes docker a partir de 6 Dockerfile, 2 por cada tipo de Job, una para los datos iniciales (simplificados a una sola propiedad y sin dependencias entre ellos, y otro para datos completos)

  El contenido de los DockerFile:

  - DockerfileACIN

    ````dockerfile
    ARG job_name
    
    FROM umansioacr.azurecr.io/input/simulator-importer
    ENV APP_PERSISTENCE_DATASOURCE_USERNAME hercules
    ENV APP_PERSISTENCE_DATASOURCE_PASSWORD h3rcul3s
    ENV APP_PERSISTENCE_DATASOURCE_URL jdbc:mysql://herc-iz-bd-desa.atica.um.es:3306/asio_jobs?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8
    ENV APP_KAFKA_INPUT_TOPIC_NAME input-data
    ENV APP_KAFKA_CREATE_TOPICS true
    ENV SPRING_KAFKA_BOOTSTRAP_SERVERS herc-iz-bd-desa.atica.um.es:29092
    ENV APP_DATA_PATH "/data"
    ENV APP_DATA_INITIAL true
    ENV SPRING_BATCH_INITIALIZE_SCHEMA always
    ADD data /data
    ENTRYPOINT ["java", "-jar", "-Dspring.batch.job.names=academicInstitutionJob","/opt/app/app.jar"]
    
    ````

  - DockerfileACNIN

  ```dockerfile
  ARG job_name
  
  FROM umansioacr.azurecr.io/input/simulator-importer
  ENV APP_PERSISTENCE_DATASOURCE_USERNAME hercules
  ENV APP_PERSISTENCE_DATASOURCE_PASSWORD h3rcul3s
  ENV APP_PERSISTENCE_DATASOURCE_URL jdbc:mysql://herc-iz-bd-desa.atica.um.es:3306/asio_jobs?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8
  ENV APP_KAFKA_INPUT_TOPIC_NAME input-data
  ENV APP_KAFKA_CREATE_TOPICS true
  ENV SPRING_KAFKA_BOOTSTRAP_SERVERS herc-iz-bd-desa.atica.um.es:29092
  ENV APP_DATA_PATH "/data"
  ENV APP_DATA_INITIAL false
  ENV SPRING_BATCH_INITIALIZE_SCHEMA always
  ADD data /data
  ENTRYPOINT ["java", "-jar", "-Dspring.batch.job.names=academicInstitutionJob","/opt/app/app.jar"]
  ```

  

  - DockerfileREIN

    ```dockerfile
    ARG job_name
    
    FROM umansioacr.azurecr.io/input/simulator-importer
    ENV APP_PERSISTENCE_DATASOURCE_USERNAME hercules
    ENV APP_PERSISTENCE_DATASOURCE_PASSWORD h3rcul3s
    ENV APP_PERSISTENCE_DATASOURCE_URL jdbc:mysql://herc-iz-bd-desa.atica.um.es:3306/asio_jobs?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8
    ENV APP_KAFKA_INPUT_TOPIC_NAME input-data
    ENV APP_KAFKA_CREATE_TOPICS true
    ENV SPRING_KAFKA_BOOTSTRAP_SERVERS herc-iz-bd-desa.atica.um.es:29092
    ENV APP_DATA_PATH "/data"
    ENV APP_DATA_INITIAL true
    ENV SPRING_BATCH_INITIALIZE_SCHEMA always
    ADD data /data
    ENTRYPOINT ["java", "-jar", "-Dspring.batch.job.names=researcherJob","/opt/app/app.jar"]
    ```

    

  - DockerfileRENIN

    ```dockerfile
    ARG job_name
    
    FROM umansioacr.azurecr.io/input/simulator-importer
    ENV APP_PERSISTENCE_DATASOURCE_USERNAME hercules
    ENV APP_PERSISTENCE_DATASOURCE_PASSWORD h3rcul3s
    ENV APP_PERSISTENCE_DATASOURCE_URL jdbc:mysql://herc-iz-bd-desa.atica.um.es:3306/asio_jobs?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8
    ENV APP_KAFKA_INPUT_TOPIC_NAME input-data
    ENV APP_KAFKA_CREATE_TOPICS true
    ENV SPRING_KAFKA_BOOTSTRAP_SERVERS herc-iz-bd-desa.atica.um.es:29092
    ENV APP_DATA_PATH "/data"
    ENV APP_DATA_INITIAL false
    ENV SPRING_BATCH_INITIALIZE_SCHEMA always
    ADD data /data
    ENTRYPOINT ["java", "-jar", "-Dspring.batch.job.names=researcherJob","/opt/app/app.jar"]
    ```

  - DockerfileTDIN

    ```
    ARG job_name
    
    FROM umansioacr.azurecr.io/input/simulator-importer
    ENV APP_PERSISTENCE_DATASOURCE_USERNAME hercules
    ENV APP_PERSISTENCE_DATASOURCE_PASSWORD h3rcul3s
    ENV APP_PERSISTENCE_DATASOURCE_URL jdbc:mysql://herc-iz-bd-desa.atica.um.es:3306/asio_jobs?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8
    ENV APP_KAFKA_INPUT_TOPIC_NAME input-data
    ENV APP_KAFKA_CREATE_TOPICS true
    ENV SPRING_KAFKA_BOOTSTRAP_SERVERS herc-iz-bd-desa.atica.um.es:29092
    ENV APP_DATA_PATH "/data"
    ENV APP_DATA_INITIAL true
    ENV SPRING_BATCH_INITIALIZE_SCHEMA always
    ADD data /data
    ENTRYPOINT ["java", "-jar", "-Dspring.batch.job.names=titleDegreeJob","/opt/app/app.jar"]
    ```

    

  - DockerfileTDNIN

  ```
  ARG job_name
  
  FROM umansioacr.azurecr.io/input/simulator-importer
  ENV APP_PERSISTENCE_DATASOURCE_USERNAME hercules
  ENV APP_PERSISTENCE_DATASOURCE_PASSWORD h3rcul3s
  ENV APP_PERSISTENCE_DATASOURCE_URL jdbc:mysql://herc-iz-bd-desa.atica.um.es:3306/asio_jobs?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8
  ENV APP_KAFKA_INPUT_TOPIC_NAME input-data
  ENV APP_KAFKA_CREATE_TOPICS true
  ENV SPRING_KAFKA_BOOTSTRAP_SERVERS herc-iz-bd-desa.atica.um.es:29092
  ENV APP_DATA_PATH "/data"
  ENV APP_DATA_INITIAL false
  ENV SPRING_BATCH_INITIALIZE_SCHEMA always
  ADD data /data
  ENTRYPOINT ["java", "-jar", "-Dspring.batch.job.names=titleDegreeJob","/opt/app/app.jar"]
  ```

  Se crean 3 Scripts (uno por proceso) en la ruta deploy/scripts, para invocar el lanzamiento por cron

  - launch_academic.sh

  ```bash
  #!/bin/bash
  docker container prune --filter "until=1h" -f
  docker run simulator-importer-academic-init:1.0
  ```

  - launch_title_degree.sh

  ```bash
  #!/bin/bash
  docker container prune --filter "until=1h" -f
  docker run simulator-importer-researcher-title-init:1.0
  ```

  * launch_researcher.sh

  ```bash
  #!/bin/bash
  docker container prune --filter "until=1h" -f
  docker run simulator-importer-researcher-init:1.0
  ```

  Se configura en cron para lanzar los jobs cada 5 min

  ```crontab
  0,5,10,15,20,25,30,35,40,45,50,55 * * * * /home/herculesizertis/deploy/scripts/launch_academic.sh
  1,6,11,16,21,26,31,36,41,46,51,56 * * * * /home/herculesizertis/deploy/scripts/launch_title_degree.sh
  2,7,12,17,22,27,32,37,42,47,52,57 * * * * /home/herculesizertis/deploy/scripts/launch_researcher.sh
  ```

  

#### Anexo

Para todas las conexiones realizadas con 

##### Conexión a wikibase desde fuera la red privada

###### Windows

Para conectar con la instancia de wikibase en el puerto 8181, es necesario establecer un tunel ssh de la siguiente forma:

1. Establecer conexión VPN con UM usando credenciales

   

   ![vpn](./images/vpn.png)

   

2. Establecer túnel SSH con putty

   - Crear sesión con Putty

     

     ![sesion](https://i.ibb.co/qMFrwVv/sesion.png)

   - Añadir en la sesión la public key facilitada por la UM para el acceso

     ![public-key](https://i.ibb.co/GdTdDKD/public-key.png)

   - Crear tunel. En **Source Port** ponemos el puerto que vamos a utilizar para el túnel (por ejemplo el 8081), **destination** lo dejamos en blanco y en las opciones de abajo lo ponemos en **Dynamic** y en **AUTO**. Y luego seleccionamos ADD (para añadir la configuración)

     ![tunel](https://www.redeszone.net/app/uploads-redeszone.net/manual_tunel_ssh_2.png)

     

   - Conectarnos al servidor ssh

   

   ![abrir sesión](https://i.ibb.co/YBsspGH/abrir-Sesion.png)

   

   - Configurar navegador (firefox)

     - Opciones, Avanzado, Red 

       ![img](https://www.redeszone.net/content/uploads/manual_tunel_ssh_5.png)

     - Configurar el proxy. **Configuración Manual del Proxy**, **Servidor SOCKS: 127.0.0.1** y el **puerto 8081** (el que pusimos anteriormente), elegimos **SOCKS v5** (comprobado que funciona).

       ![img](https://www.redeszone.net/content/uploads/manual_tunel_ssh_6.png)

     - Comprobar

       ![image-20200224095112601](.\images\image-20200224095112601.png)

     

