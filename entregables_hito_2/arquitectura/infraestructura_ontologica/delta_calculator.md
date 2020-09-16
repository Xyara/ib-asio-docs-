# Módulo de calculo de deltas entre modelos de dominio en Java
## Resumen

Este módulo trata de dar solución a saber qué es lo que se ha modificado entre dos versiones del modelo de dominio. Para ello se parte de que un modelo de dominio viene definido como un artefacto java que en su interior contiene una colección de POJOs.

El módulo recibe dos versiones del artefacto, la actual y la que se quiere comparar. Entonces, el módulo genera una salida en la que se indica que modificaciones o diferencias existen entre ambas versiones. Siempre realizando la siguiente fórmula: **"la que se quiere comparar" -  "versión actual"**.

## Diagrama del módulo

![](./resources/delta_calculator_diagram.png)

Como se puede ver en el diagrama anterior el módulo recibe dos artefactos desde los que genera el diff de cambios.

## Algoritmo de cálculo

Para este módulo en concreto la parte más importante a diseñar es precisamente el algoritmo de cálculo del diff. Para ello se propone el siguiente modelizado:

1. Para cada uno de los artefactos de entrada se genera un grafo $(G_1, G_2)$. Ese grafo Tiene nodos que son clases y nodos que son tipo+nombre_propiedad.
2. Se realiza la resta de $G_2 - G_1$. Es decir, se computan las diferencias añadidas en $G_2$.
3. Se genera un log con las diferencias. Dicho log debería de hacer uso de RISC. Ya que todas las operaciones de modificación se pueden componer de añadidos y borrados.

## Datos de entrada

Los datos de entrada serían dos. Por una parte un artefacto y por otra otro. Estos artefactos se espera que sean los que se suban a un repositorio de artefactos desde el plugin de ShEx-Lite.

## Datos de salida

Los datos de salida del módulo se corresponden con el archivo que incluyen las diferencias entre versiones. Este archivo debería de ser un formato abstracto que pueda configurarse como JSON o incluso formato propietario.