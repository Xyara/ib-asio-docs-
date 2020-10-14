![](./resources/logos_feder.png)

# ShEx-Lite — Sistema de Traducción de Shape Expressions a Objetos Planos de Java

## Datos del módulo

**Usuario final:** Desarrollador de Software

**Finalidad:** Traducir automáticamente un conjunto de shape expressions a modelo de dominio de Java.

**Ubicación en la arquitectura:** Sincronización del modelo de dominio de la arquitectura semántica a través de las shapes empleadas en la infraestructura ontológica.

## Resumen

En el marco del proyecto Hércules ASIO existe un modelo ontológico que representa la fuente de verdad del dominio de la investigación en el ámbito universitario español. Esta ontología se desarrolla por medio de un sistema de "Test Driven Development". O lo que es lo mismo, para cada modificación existe una batería de tests que aseguran la integridad de la ontología. Estos tests son Shape Expressions e instancias RDF.

Al mismo tiempo, se desarrolla una aplicación software. Esta aplicación sirve como panel de administración para manejar los datos que siguen el modelo ontológico. Por este motivo, la aplicación software, necesita trabajar sobre un modelo software que represente exactamente lo mismo que el modelo ontológico. 

Para reducir el tiempo de desarrollo y, sobre todo, la sincronización entre ambos modelos se diseña un módulo de software capaz de generar un modelo de software desde un conjunto de Shape Expressions. En el caso del proyecto Hércules ASIO se usa el mismo conjunto de shapes que se emplean para validar la ontología. De esta forma se cierra el círculo y se genera un modelo software que está sincronizado con la ontología.

## Criteria — Qué define el éxito de este módulo?

- [ ]  Que la librería sea capaz de generar un modelo de dominio en Java a partir de un conjunto de Shape Expressions.
- [ ]  Que la librería se pueda integrar con el resto de elementos del sistema ASIO.

## Diseño de la librería

Para el diseño de la librería se hace un proceso de fuera a dentro. Primero veremos los aspectos a más alto nivel y después profundizaremos en cada uno de ellos.

En el siguiente diagrama se puede ver que la librería es un elemento que recibe de entrada unas Shape Expressions y produce código fuente en java. Es este código en Java el modelo de dominio expresado por las Shape Expressions.

![](resources/shex_lite_caja_negra.png)

### Restricciones de diseño

Dentro del apartado Criteria tenemos una restricción en forma de requisito no funcional. Se nos indica que la librería debe de poder integrarse con el resto de elementos del sistema ASIO. Para ello, debemos de tener en cuenta que el resto del sistema ASIO se está desarrollando en Java. Esto nos indica dos cosas.

1. O bien se implementa la librería siguiendo un lenguaje de programación compatible con Java (Java, Scala, Kotlin...).
2. O bien se implementa de forma que pueda ser invocada desde cualquier otro sistema como puede ser una api REST.

**Opción elegida:** Teniendo en cuenta que el resto del sistema está implementado en Java, que la inclusión de una capa de API REST introduciría overhead en cada computo y que no existe ningún requisito para ejecutar la librearía de forma distribuida. Se escoge la opción número 1. Es decir, implementar una librería "tradicional" en algún lenguaje compatible con Java. En concreto se empleará Scala ya que el resto del ecosistema de Shape Expressions está programado en este lenguaje. A demás Scala es plenamente compatible con Java.

### Detalles del diseño

Para realizar el proceso descrito en el esquema anterior debemos de asegurarnos que las Shapes que nos lleguen sean correctas. Y, si no, informar al usuario del error que ha cometido en las Shapes. Ya sea sintáctico o semántico. Para ello es preciso implementar diferentes fases. Desde la entrada del código fuente hasta la salida de los modelos en Java.

![](resources/shex_lite_caja_negra.png)

El esquema anterior muestra las distintas fases de las que constará la librería. Cada una de ellas será implementada de forma independiente. Siguiendo el patrón de diseño "pipes and filters". Sin embargo también se deberá permitir al usuario final invocar un ciclo completo sin tener que pasar por todas y cada una de las fases de forma independiente.

Una documentación mucho más exhaustiva del diseño de esta herramienta puede encontrarse en: [https://github.com/thewilly/shex-lite-book/blob/master/thesis.pdf](https://github.com/thewilly/shex-lite-book/blob/master/thesis.pdf)

## Uso de la librería

Al trabajar en formato librería se espera que esta sea distribuida de alguna forma a las aplicaciones que vayan a invocarla. En ningún caso se espera que su uso sea a través de alguna interfaz como una CLI o alguna consola. Por tanto el usuario final, tras importar la librería, podría usarla de la siguiente forma

```java
// Creating a new ShExC to Java translator.
ShExLTranslator t = new ToJavaShExLTranslator();

// Events will store the list of warnings or errors produced during the compilation.
// Notice, if any error is produced duringthe compilation the outputDir will be empty.
// Else the outputDir will contain all the generated Java files.
List<CompilationEvent> events = t.translate(inputDir, outputDir);
```

Esto representaría el ciclo completo de compilado. Sin embargo si se quisiera acceder a alguna de las acciones que se realizan en un ciclo de compilado se podría hacer a través de la interfaz de software propia de cada acción.

Por ejemplo, si el usuario final quisiera acceder al lenguaje intermedio podría realizarlo a través de 

```scala
/**
  * Gets the Shex Lite Intermediate Language representation for a given AST.
  *
  * @param abstractSyntaxTree for which the SIL will be generated.
  * @return the generated SIL.
  */
def getSIL(abstractSyntaxTree: AbstractSyntaxTree): SIL
```

## Modificación de la librería

La librería se ha desarrollado sobre un sistema de control de versiones que es GitHub. Para asegurar la integridad de todo el código se ha acoplado un sistema de integración continua propietario de GitHub llamado GitHub Actions. Por medio de archivos YAML se pueden configurar para ejecutar una batería de tests cada vez que se realiza una modificación. Estos archivos YAML se encuentran en la carpeta `.github/workflows` de la raíz del repositorio.

Por ejemplo, para la integración continua de Linux la configuración sería:

```yaml
# Job name
    name: Test Linux Platform

    # This jobs runs on linux
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2
      - name: Set up JDK 12
        uses: actions/setup-java@v1
        with:
          java-version: 12
          architecture: x64
      - name: Run tests
        run: sbt ++2.13.1! clean test
```