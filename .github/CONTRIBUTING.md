# Contribuciones a indecr

Este documento describe cómo proponer cambios a indecr.

## Correcciones menores

Podés corregir errores tipográficos, de ortografía o gramaticales en la
documentación directamente desde la interfaz web de GitHub, siempre que
los cambios se hagan en el archivo _fuente_.

Esto generalmente significa que tenés que editar los
[comentarios de roxygen2](https://roxygen2.r-lib.org/articles/roxygen2.html)
en un archivo `.R`, no en uno `.Rd`.
Podés encontrar el archivo `.R` que genera el `.Rd` leyendo el comentario
en la primera línea.

## Cambios más grandes

Si querés hacer un cambio más grande, es buena idea abrir un issue primero
y asegurarte de que alguien del equipo esté de acuerdo en que es necesario.

Si encontraste un bug, por favor abrí un issue que lo ilustre con un
[reprex](https://www.tidyverse.org/help/#reprex) mínimo (esto también
te va a ayudar a escribir un test unitario si es necesario).

### Proceso de pull request

* Hacé un fork del paquete y clonalo en tu computadora. Si no hiciste esto
  antes, recomendamos usar
  `usethis::create_from_github("LisandroSeghezzo2003/indecr", fork = TRUE)`.

* Instalá todas las dependencias de desarrollo con
  `devtools::install_dev_deps()`, y luego asegurate de que el paquete pase
  R CMD check corriendo `devtools::check()`.
  Si R CMD check no pasa limpio, es buena idea pedir ayuda antes de continuar.

* Creá una rama de Git para tu pull request (PR). Recomendamos usar
  `usethis::pr_init("descripcion-breve-del-cambio")`.

* Hacé tus cambios, commiteá en git, y luego creá el PR corriendo
  `usethis::pr_push()` y siguiendo las instrucciones en el navegador.
  El título del PR debe describir brevemente el cambio.
  El cuerpo del PR debe contener `Fixes #numero-de-issue`.

* Para cambios visibles para el usuario, agregá un punto al comienzo de
  `NEWS.md` (justo debajo del primer encabezado). Seguí el estilo descrito
  en <https://style.tidyverse.org/news.html>.

### Estilo de código

* El código nuevo debe seguir la
  [guía de estilo tidyverse](https://style.tidyverse.org).
  Podés usar [Air](https://posit-dev.github.io/air/) para aplicar este
  estilo, pero por favor no reformatees código que no tenga que ver con
  tu PR.

* Usamos [roxygen2](https://cran.r-project.org/package=roxygen2), con
  [sintaxis Markdown](https://cran.r-project.org/web/packages/roxygen2/vignettes/rd-formatting.html),
  para la documentación.

* Usamos [testthat](https://cran.r-project.org/package=testthat) para
  los tests unitarios. Las contribuciones que incluyen casos de prueba
  son más fáciles de aceptar.

## Código de conducta

Por favor tené en cuenta que el proyecto indecr se publica con un
[Código de Conducta para Contribuidores](CODE_OF_CONDUCT.md).
Al contribuir a este proyecto acordás respetar sus términos.
