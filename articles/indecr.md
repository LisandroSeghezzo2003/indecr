# Introducción a indecr

## Introducción

`indecr` permite acceder a datos socioeconómicos oficiales de Argentina
directamente desde R, sin descargar archivos ni conocer los endpoints de
cada API. Todas las funciones devuelven tibbles listos para analizar con
tidyverse.

Las fuentes son:

- **API Series de Tiempo** (Ministerio de Economía) — IPC, salarios,
  canasta básica. Licencia CC-BY 4.0, sin token.
- **API BCRA** — tipo de cambio oficial. Sin token.
- **Excel INDEC** — serie histórica empalmada del IPC por región.

------------------------------------------------------------------------

## IPC

``` r
library(indecr)

# Nivel general nacional — devuelve el índice (base dic 2016 = 100)
get_ipc(desde = "2022-01-01")
```

``` r
# Variación mensual
get_ipc(variacion = "mensual", desde = "2022-01-01")

# Variación interanual
get_ipc(variacion = "interanual", desde = "2022-01-01")

# Acumulada en el año
get_ipc(variacion = "acumulada", desde = "2022-01-01")
```

``` r
# Núcleo (sin estacionales ni regulados)
get_ipc(serie = "nucleo", variacion = "interanual", desde = "2022-01-01")

# Regulados
get_ipc(serie = "regulados", variacion = "interanual", desde = "2022-01-01")
```

``` r
# Por región
get_ipc(serie = "patagonia", desde = "2022-01-01")
get_ipc(serie = "gba",       desde = "2022-01-01")
```

------------------------------------------------------------------------

## Serie histórica empalmada

[`ipc_chain()`](https://LisandroSeghezzo2003.github.io/indecr/reference/ipc_chain.md)
usa el archivo oficial del INDEC que ya incorpora el empalme entre la
base diciembre 2016 y la base diciembre 2022. Es la función recomendada
para análisis históricos largos.

``` r
# Nacional desde el inicio de la serie
ipc_chain()

# Por región
ipc_chain(region = "gba",      desde = "2019-01-01")
ipc_chain(region = "pampeana", desde = "2019-01-01")

# Comparar todas las regiones
regiones <- c("gba", "pampeana", "noa", "nea", "cuyo", "patagonia")
serie_regional <- do.call(rbind, lapply(
  regiones,
  ipc_chain,
  desde = "2020-01-01"
))
```

------------------------------------------------------------------------

## Salarios

``` r
# RIPTE — Remuneración Imponible Promedio Trabajadores Estables
get_salarios(desde = "2020-01-01")

# Índice de salarios sector privado registrado
get_salarios(serie = "privado_registrado", desde = "2020-01-01")

# Variación interanual sector público
get_salarios(serie = "publico", variacion = "interanual", desde = "2021-01-01")
```

------------------------------------------------------------------------

## Deflactar series nominales

[`deflate()`](https://LisandroSeghezzo2003.github.io/indecr/reference/deflate.md)
convierte cualquier vector de valores nominales a valores reales usando
el IPC como deflactor. El parámetro `base` define en qué pesos se
expresan los valores resultantes.

``` r
sal <- get_salarios(desde = "2020-01-01")

# Expresar en pesos de enero 2024
sal$real <- deflate(sal$valor, sal$fecha, base = "2024-01-01")
sal
```

Si no se especifica `base`, los valores se expresan en términos del
índice original (base dic 2016 = 100):

``` r
sal$real_indice <- deflate(sal$valor, sal$fecha)
```

------------------------------------------------------------------------

## Tipo de cambio

``` r
# Dólar oficial desde 2023
get_tc(desde = "2023-01-01")

# Otras divisas
get_tc(moneda = "EUR", desde = "2023-01-01")
get_tc(moneda = "BRL", desde = "2023-01-01")

# Ver todas las divisas disponibles
get_divisas()
```

------------------------------------------------------------------------

## Canasta básica

``` r
# Canasta básica total nacional (pesos corrientes por adulto equivalente)
get_canasta(desde = "2022-01-01")

# Canasta básica alimentaria
get_canasta(serie = "cba_nacional", desde = "2022-01-01")

# Por región
get_canasta(serie = "cba_gba",      desde = "2022-01-01")
get_canasta(serie = "cbt_patagonia", desde = "2022-01-01")
```

------------------------------------------------------------------------

## Caso de uso: poder adquisitivo del RIPTE

Cuántas canastas básicas totales cubre el RIPTE cada mes:

``` r
# Traer datos
ripte   <- get_salarios(serie = "ripte",        desde = "2020-01-01")
canasta <- get_canasta(serie  = "cbt_nacional",  desde = "2020-01-01")

# Deflactar RIPTE a pesos del último mes disponible
ripte$real <- deflate(ripte$valor, ripte$fecha, base = max(ripte$fecha))

# Unir por fecha
datos <- merge(
  ripte[,   c("fecha", "real")],
  canasta[, c("fecha", "valor")],
  by = "fecha"
)
names(datos) <- c("fecha", "ripte_real", "cbt")

# Cobertura: cuántas CBT cubre el RIPTE
datos$cobertura_cbt <- datos$ripte_real / datos$cbt
datos
```
