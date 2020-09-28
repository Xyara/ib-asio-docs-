# ADR — Modelo de dominio basado en tipos vs modelo de dominio dinámico

- **Estado:** Accepted
- **Deciders:**
- **Fecha:**

## Contexto y definición del problema

En el sistema diseñado inicialmente en la propuesta se plantea que una herramienta genere el modelo de dominio que usará la Arquitectura Semántica. Esta herramienta generaría el modelo de dominio a partir de la infraestructura ontológica. Para ser más concretos a partir de las Shape Expressions.

Así mismo se decidió que se empleara Java como lenguaje de programación para el proyecto. Java es un lenguaje orientado a objetos con lo que se conoce como un ssistema de tipos fuerte. Esto significa que el sistema de tipo "no" puede sufrir cambios en tiempo de ejecución.

Por lo tanto se tiene la disyuntiva de que empleando el lenguaje de programación Java y la propuesta inicial se hace inviable que la Arquitectura Semántica pueda sincronizar su modelo de dominio con la Infraestructura Ontológica en tiempo de ejecución.

Para explorar otras alternativas, esta decisión de arquitectura platea la opción de modificar el modelo de dominio basado en tipos por un modelo de dominio basado en un contenedor dinámico. Muy parecido a los objetos de Python.

## Elementos de la decisión

- Desarrollos ya realizados que se tendrían que modificar.
- Grado de conocimiento de la nueva técnica.
- Estabilidad futura.
- Alternativas.

## Opciones consideradas

1. Modificar la propuesta inicial cambiando el modelo de dominio de la Arquitectura Semántica de un modelo de dominio basado en tipos a uno dinámico basado en contenedores de información y posterior validación.
2. Mantener el sistema actual de tipos estáticos. Limitar las modificaciones posibles. Imponer re-despliegue ante cambios. Y modelar los cambios posibles que sufriría la Arquitectura Semántica, causados a raíz de modificaciones en la Infraestructura Ontológica.

## Decisión escogida

Se escoge la opción número 2. El motivo de esta elección es que tras valorar los *elementos de decisión* se llega a la conclusión de que ni el grado de conocimiento de la técnica es el adecuado, ni el punto de desarrollo en el que se encuentra el proyecto es susceptible de cambios tan grandes, ni se puede asegurar una estabilidad futura del sistema con la alternativa 1.

### Consecuencias positivas

- La planificación en el desarrollo del sistema no se ve modificada.
- El sistema sigue las especificaciones del lenguaje de programación de destino.
- No se modifica la propuesta inicial.

### Consecuencias negativas

- El sistema no es capaz de sincronizar el modelo de dominio de la Arquitectura Semántica con la Infraestructura Ontológica en tiempo de ejecución.

## Pros y contras de cada opción

### Opción 1

- Pro, el sistema podría sincronizar de forma automática y en tiempo de ejecución el modelo de dominio de la AS con la IO.
- Pro, no habría mantenimiento alguno del modelo de dominio pues no habría más que una única clase Java que haría de contenedor para el resto de datos.
- Contra, actualmente ya se han implementado módulos de software que habría que modificar para soportar la nueva técnica.
- Contra, esta técnica es más de lenguajes de programación que no usan un sistema fuertemente tipado, como Python. Incrementaría el tiempo de ejecución y tampoco se tiene experiencia en el uso de esta técnica en Java.
- Contra, no se puede asegurar que el uso de esta técnica en Java no imponga una restricción en el futuro que cause un bloqueo del proyecto.

### Opción 2

- Pro, no se tiene que modificar la planificación actual.
- Pro, no hay que modificar piezas de software ya diseñadas.
- Pro, se respetan las bases de Java. Lenguaje orientado a objetos fuertemente tipado.
- Pro, se conoce el uso de la técnica en el lenguaje ampliamente.
- Contra, no permite la modificación del modelo de dominio en tiempo de ejecución.