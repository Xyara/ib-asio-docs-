# Creación y almacenamiento de RDF's con objetos anidados

# Problema

Para generar un documento RDF necesitamos un identificador único por objeto (URI), este identificador se genera en la factoría de URI's. Dicha factoría necesita como parámetro de entrada un objeto completo incluyendo los posibles objetos anidados. Este requisito nos conduce a un problema de anidamiento múltiple de objetos, lo que nos podría llevar a trabajar con duplicidades y objetos muy pesados con la posterior penalización de rendimiento.

Ejemplo:

```jsx
{
   "operation":"INSERT",
   "data":{
      "id":1,
      "nombre":"Proyecto Hercules",
      "clase":"Proyecto",
      "grupoInvestigacion":{
         "id":"1",
         "nombre":"",
         "universidad":{
            "id":"1",
            "nombre":"Universidad de Murcia"
         }
      },
      "autores":[
         {
            "id":1,
            "nombre":"Alejandro""universidad":{
               "id":"1",
               "nombre":"Universidad de Murcia"
            }
         },
         {
            "id":2,
            "nombre":"Ruben""universidad":{
               "id":"2",
               "nombre":"Universidad de Oviedo"
            }
         }
      ]
   }
}
```

# Posibles soluciones

## Opción 1

Los POJOS llegan por separado, por un lado objetos con propiedades simples y por otro las relaciones entre dichos objetos.

### Objetos planos

Proyecto

```jsx
{
   "operation": "INSERT",
   "data" : {
      "clase": "Proyecto",
      "id": 1,
      "name": "Proyecto Hercules"
  }
}
```

GrupoInvestigacion

```jsx
{
   "operation": "INSERT",
   "data" : {
      "clase": "GrupoInvestigacion",
      "id": 1,
      "name": "Europeo"
   }
}
```

Universidad

```jsx
{
   "operation": "INSERT",
   "data" : {
      "clase": "Universidad",
      "id": 1,
      "name": "Universidad de Murcia"
   }
}
```

Autor

```jsx
{
   "operation": "INSERT",
   "data" : {
      "clase": "Autor",
      "id": 1,
      "name": "Alejandro"
   }
}
```

### Relaciones de objetos

Relaciones para el objeto proyecto.

```jsx
{
   "operation":"INSERT",
   "data":{
      "clase":"Proyecto",
      "id":1,
      "linkedTo":[
         {
            "className":"GrupoInvestigacion",
            "fieldName":"grupoInvestigacion",
            "ids":[
               1
            ]
         },
         {
            "className":"Autor",
            "fieldName":"autores""ids":[
               1,
               2
            ]
         }
      ]
   }
}
```

Relaciones para el objeto autor.

```jsx
{
   "operation":"INSERT",
   "data":{
      "clase":"Autor",
      "id":1,
      "linkedTo":[
         {
            "className":"Universidad",
            "fieldName":"universidad",
            "ids":[
               1
            ]
         }
      ]
   }
}
```

### Pros

Implementación más sencilla frente a las demás opciones.

### Contras

La información no está completa hasta que no termina la importación de los objetos simples y de sus relaciones.

Se necesita de una segunda cola para procesar la información de la relaciones.

## Opción 2

Guardar las relaciones de los objetos a medida que van llegando

### Pros

No hay que esperar a que finalice el proceso de importación para tener la información completa.

No es necesario crear una cola extra.

### Contras

Implementación más compleja.

Procesamiento más lento, sucesivas reiteraciones.

Almacenamiento secundario necesario.

# Opciónes descartadas

- Los datos se envían en cierto orden.
  - Se descarta porque las colas kafka no garantizan el orden de los objetos. Pueden llegar a haber dependencias circulares.
- Neo4j.
  - En importaciones parciales no se tiene un grafo completo. Sin un grafo completo no es posible persistirlo en el triple storage.

# Tabla comparativa

| Solución |    Complejidad     |     Cola extra     |    Rendimiento     | Almacenamiento Secundario | Información consolidada                         |
| -------- | :----------------: | :----------------: | :----------------: | :-----------------------: | ----------------------------------------------- |
| Opción 1 | :heavy_check_mark: |        :x:         | :heavy_check_mark: |    :heavy_check_mark:     | al final de la importación de todos los objetos |
| Opción 2 |        :x:         | :heavy_check_mark: |        :x:         |            :x:            | cuando se tiene toda la información del objeto  |

# Decisión final

**Opción 1**. Aunque tiene el problema de que toda la información no está lista hasta que no se termina el proceso de importación. Dicha importación será un proceso batch en segundo plano que se ejecutará normalmente en un horario donde el uso de la aplicación será mínimo, con lo cual se mitiga considerablemente el hándicap de no poder consultar la información hasta que el proceso de importación finaliza completamente.
