# Obtener datos del IPC argentino

Descarga series del Índice de Precios al Consumidor (IPC) base diciembre
2016 desde la API de Series de Tiempo de datos.gob.ar.

## Usage

``` r
get_ipc(
  serie = "nacional",
  desde = "2017-01-01",
  hasta = Sys.Date(),
  variacion = "ninguna"
)
```

## Arguments

- serie:

  Character. Serie a descargar. Una de: `"nacional"`, `"gba"`, `"cuyo"`,
  `"pampeana"`, `"noroeste"`, `"noreste"`, `"patagonia"`, `"nucleo"`,
  `"regulados"`, `"estacionales"`. Por defecto `"nacional"`.

- desde:

  Character o Date. Fecha de inicio en formato `"YYYY-MM-DD"`. Por
  defecto `"2017-01-01"`.

- hasta:

  Character o Date. Fecha de fin en formato `"YYYY-MM-DD"`. Por defecto
  la fecha actual.

- variacion:

  Character. Tipo de variacion a calcular sobre el indice. Una de:
  `"ninguna"` (valor del indice), `"mensual"`, `"interanual"`,
  `"acumulada"`. Por defecto `"ninguna"`.

## Value

Un tibble con columnas:

- fecha:

  Date. Primer dia del mes.

- serie:

  Character. Nombre de la serie solicitada.

- valor:

  Numeric. Valor del indice o variacion porcentual.

## Examples

``` r
if (FALSE) { # \dontrun{
# IPC nivel general desde 2020
get_ipc(desde = "2020-01-01")

# Variacion mensual del nucleo
get_ipc(serie = "nucleo", variacion = "mensual")

# Comparar GBA vs Patagonia
rbind(
  get_ipc(serie = "gba"),
  get_ipc(serie = "patagonia")
)
} # }
```
