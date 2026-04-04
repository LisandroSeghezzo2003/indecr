# Obtener serie historica empalmada del IPC

Descarga la serie completa del IPC desde diciembre 2016 hasta la
actualidad, empalmada por el INDEC en una base unica. Para el nivel
nacional usa la API de Series de Tiempo; para las regiones usa el
archivo Excel oficial del INDEC.

## Usage

``` r
ipc_chain(region = "nacional", desde = "2017-01-01", hasta = Sys.Date())
```

## Arguments

- region:

  Character. Region a consultar. Una de: `"nacional"`, `"gba"`,
  `"pampeana"`, `"noa"`, `"nea"`, `"cuyo"`, `"patagonia"`. Por defecto
  `"nacional"`.

- desde:

  Character o Date. Fecha de inicio. Por defecto `"2017-01-01"`.

- hasta:

  Character o Date. Fecha de fin. Por defecto la fecha actual.

## Value

Un tibble con columnas `fecha`, `region` y `valor`. El indice tiene base
diciembre 2016 = 100.

## Examples

``` r
if (FALSE) { # \dontrun{
# Serie nacional completa
ipc_chain()

# Serie GBA desde 2020
ipc_chain(region = "gba", desde = "2020-01-01")

# Comparar todas las regiones
regiones <- c("gba", "pampeana", "noa", "nea", "cuyo", "patagonia")
do.call(rbind, lapply(regiones, ipc_chain, desde = "2020-01-01"))
} # }
```
