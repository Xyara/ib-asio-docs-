![](./images/logos_feder.png)

# Despliegue en entorno de desarrollo para la Universidad de Murcia

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

   

   ![vpn](data:image/png;base64,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)

   

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

       ![image-20200224095112601](C:\Users\druiz\AppData\Roaming\Typora\typora-user-images\image-20200224095112601.png)

     

