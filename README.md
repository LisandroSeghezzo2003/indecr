
# indecr <img src="man/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R-CMD-check](https://github.com/LisandroSeghezzo2003/indecr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/LisandroSeghezzo2003/indecr/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/LisandroSeghezzo2003/indecr/graph/badge.svg)](https://app.codecov.io/gh/LisandroSeghezzo2003/indecr)
<!-- badges: end -->

`indecr` permite acceder a datos socioeconómicos oficiales de Argentina
directamente desde R: IPC, salarios, tipo de cambio, canasta básica y
series históricas empalmadas.

## Instalación

``` r
# Version de desarrollo
remotes::install_github("LisandroSeghezzo2003/indecr")
```

## Funciones principales

| Función          | Descripción                            |
|------------------|----------------------------------------|
| `get_ipc()`      | IPC nacional y regional, base dic 2016 |
| `get_salarios()` | RIPTE e índices de salarios por sector |
| `get_tc()`       | Tipo de cambio oficial (API BCRA)      |
| `get_canasta()`  | Canasta básica alimentaria y total     |
| `deflate()`      | Convertir series nominales a reales    |
| `ipc_chain()`    | Serie histórica empalmada del IPC      |

## Ejemplos

### IPC con variación interanual

``` r
library(indecr)

get_ipc(variacion = "interanual", desde = "2020-01-01")
```

### Salario real vs nominal

``` r
sal <- get_salarios(desde = "2020-01-01")
sal$real <- deflate(sal$valor, sal$fecha, base = "2024-01-01")
sal
```

### Tipo de cambio oficial

``` r
get_tc(desde = "2023-01-01")
```

### Canasta básica total

``` r
get_canasta(serie = "cbt_nacional", desde = "2022-01-01")
```

### Serie histórica empalmada por región

``` r
ipc_chain(region = "patagonia", desde = "2020-01-01")
```

## Fuentes

- [API Series de
  Tiempo](https://www.argentina.gob.ar/datos-abiertos/api-series-de-tiempo)
  — Gobierno de la Republica Argentina
- [API BCRA](https://www.bcra.gob.ar/apis-banco-central/) — Banco
  Central de la República Argentina
- [Excel
  IPC](https://www.indec.gob.ar/ftp/cuadros/economia/sh_ipc_aperturas.xls)
  — INDEC
