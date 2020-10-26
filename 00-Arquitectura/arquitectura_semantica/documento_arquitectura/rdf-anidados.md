# Generación y almacenamiento de documentos RDF's con objetos anidados

# Problema

A la hora de crear documentos RDF con objetos anidados se pueden dar situaciones en las que se están intentando generar documentos RDF con objetos que hacen referencia a otros, los cuales no han sido persitidos aún. Ejemplo, supongamos que intentamos generar el RDF del primero objeto que nos llega de la cola kafka, en este caso un objeto de tipo proyecto:

```jsx
{
   "operation":"INSERT",
   "data":{
      "id":1,
      "nombre":"Proyecto Hercules",
      "@class":"Proyecto",
      "grupoInvestigacion":{
         "id":"1",
         "nombre":"Grupo Europeo",
         "universidad":{
            "id":"1",
            "nombre":"Universidad de Murcia"
         }
      },
      "autores":[
         {
            "id":1,
            "nombre":"Alejandro",
            "universidad":{
               "id":"1",
               "nombre":"Universidad de Murcia"
            }
         },
         {
            "id":2,
            "nombre":"Ruben",
            "universidad":{
               "id":"2",
               "nombre":"Universidad de Oviedo"
            }
         }
      ]
   }
}
```

Puesto que este es el primer objeto a procesar, aún no tenemos la información correspondiente a los objetos `grupoInvestigación`, `universidad` y `autores`, esto provoca que no podamos construir el grafo completo para este objeto proyecto. Las relaciones entre entidades se establecen mediante tripletas, donde los objetos padre he hijo deben de estar creados previamente, y han de referenciarse mediante sus URIs, las cuales son generadas por la factoría de URIs.

Este supuesto se puede dar perfectamente ya que las colas kafka no garantizan el orden de llegada de los objetos.

# Posibles soluciones

## Opción 1

Los POJOS llegan por separado, por un lado objetos con propiedades simples y por otro las relaciones entre dichos objetos.

### Objetos planos

Proyecto

```jsx
{
   "operation": "INSERT",
   "data" : {
      "@class": "Proyecto",
      "id": "1",
      "name": "Proyecto Hercules"
  }
}
```

GrupoInvestigacion

```jsx
{
   "operation": "INSERT",
   "data" : {
      "@class": "GrupoInvestigacion",
      "id": "1",
      "name": "Europeo"
   }
}
```

Universidad

```jsx
{
   "operation": "INSERT",
   "data" : {
      "@class": "Universidad",
      "id": "1",
      "name": "Universidad de Murcia"
   }
}
```

Autor

```jsx
{
   "operation": "INSERT",
   "data" : {
      "@class": "Autor",
      "id": "1",
      "name": "Alejandro"
   }
}
```

### Relaciones de objetos

Relaciones para el objeto proyecto.

```jsx
{
   "operation":"LINKED_INSERT",
   "linkedModel":{
      "@class":"Proyecto",
      "id":"1",
      "linkedTo":[
         {
            "className":"GrupoInvestigacion",
            "fieldName":"grupo",
            "ids":[
               "1"
            ]
         },
         {
            "className":"Autor",
            "fieldName":"autores",
            "ids":[
               "1",
               "2"
            ]
         }
      ]
   }
}
```

Relaciones para el objeto grupoInvestigacion.

```jsx
{
   "operation":"LINKED_INSERT",
   "linkedModel":{
      "@class":"GrupoInvestigacion",
      "id":1,
      "linkedTo":[
         {
            "className":"Universidad",
            "fieldName":"uni",
            "ids":[
               "1"
            ]
         }
      ]
   }
}
```

### Pros

- Implementación más sencilla frente a las demás opciones.

### Contras

- La información no está completa hasta que no se termina la importación de los objetos simples y de sus relaciones.

- Se necesita de una segunda cola para procesar la información de la relaciones.

## Opción 2

Los POJO's llegan sin clasificar, los objetos que se puedan guardar porque no tengan relaciones con otros objetos o aquellos que sí tienen relaciones con otros pero estos ya están guardados en el sistema se procesan directamente el resto se guardan en un almacenamiento externo para su posterior procesamiento al final de la importación.

### Pros

- No hay que esperar a que finalice el proceso de importación para tener información consolidada.

- No es necesario crear una cola extra.

### Contras

- Implementación más compleja.

- Alguna información no está accesible hasta que no se completan todas las relaciones del objeto.

- Procesamiento más lento, sucesivas reiteraciones.

- Almacenamiento secundario necesario para guardar operaciones pendientes.

## Opción 3

Análoga a la anterior opción con la diferencia de que no se espera a que finalice la importación para procesar todas las operaciones pendientes guardadas en el almacenamiento externo sino que a medida que se vayan obteniendo las relaciones pendientes de objetos se van guardando en el sistema.

### Pros

- Toda la información que se guarda está consolidada.

- No es necesario crear una cola extra.

### Contras

- Implementación la más compleja de todas la soluciones propuestas.

- Procesamiento el más lento de todas las soluciones propuestas.

- Almacenamiento secundario necesario para guardar operaciones pendientes.

# Opciónes descartadas

- Los datos se envían en cierto orden.
  - Se descarta porque las colas kafka no garantizan el orden de los objetos. Pueden llegar a haber dependencias circulares.
- Neo4j.
  - En importaciones parciales no se tiene un grafo completo. Sin un grafo completo no es posible persistirlo en el triple storage.

# Tabla comparativa

| Solución |              Complejidad              |     Cola extra     |              Rendimiento              | Almacenamiento Secundario | Información consolidada                                         |
| -------- | :-----------------------------------: | :----------------: | :-----------------------------------: | :-----------------------: | --------------------------------------------------------------- |
| Opción 1 | :heavy_check_mark: :heavy_check_mark: |        :x:         | :heavy_check_mark: :heavy_check_mark: |    :heavy_check_mark:     | Al final de la importación de todos los objetos                 |
| Opción 2 |                  :x:                  | :heavy_check_mark: |                  :x:                  |            :x:            | Parcial hasta que no se completa todo el proceso de importación |
| Opción 3 |                :x: :x:                | :heavy_check_mark: |                :x: :x:                |            :x:            | Total mientras se completa el proceso de importación            |

# Decisión final

**Opción 1**. Aunque tiene el problema de que toda la información no está lista hasta que no se termina el proceso de importación. Dicha importación será un proceso batch en segundo plano que se ejecutará normalmente en un horario donde el uso de la aplicación será mínimo, con lo cual se mitiga considerablemente el hándicap de no poder consultar la información hasta que el proceso de importación finaliza completamente.
