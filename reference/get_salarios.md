# Obtener indices de salarios argentinos

Descarga series de salarios desde la API de Series de Tiempo de
datos.gob.ar. Incluye el RIPTE y los indices de salarios por sector.

## Usage

``` r
get_salarios(
  serie = "ripte",
  desde = "2017-01-01",
  hasta = Sys.Date(),
  variacion = "ninguna"
)
```

## Arguments

- serie:

  Character. Serie a descargar. Una de: `"ripte"`,
  `"privado_registrado"`, `"privado_no_registrado"`, `"publico"`. Por
  defecto `"ripte"`.

- desde:

  Character o Date. Fecha de inicio en formato `"YYYY-MM-DD"`. Por
  defecto `"2017-01-01"`.

- hasta:

  Character o Date. Fecha de fin en formato `"YYYY-MM-DD"`. Por defecto
  la fecha actual.

- variacion:

  Character. Tipo de variacion. Una de: `"ninguna"`, `"mensual"`,
  `"interanual"`, `"acumulada"`. Por defecto `"ninguna"`.

## Value

Un tibble con columnas `fecha`, `serie` y `valor`.

## Examples

``` r
if (FALSE) { # \dontrun{
# RIPTE desde 2020
get_salarios(desde = "2020-01-01")

# Variacion interanual salario privado registrado
get_salarios(serie = "privado_registrado", variacion = "interanual")
} # }
```
