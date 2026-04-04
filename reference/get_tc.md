# Obtener cotizaciones del tipo de cambio oficial

Descarga cotizaciones de divisas desde la API de Estadisticas Cambiarias
del Banco Central de la Republica Argentina (BCRA).

## Usage

``` r
get_tc(moneda = "USD", desde = "2020-01-01", hasta = Sys.Date())
```

## Arguments

- moneda:

  Character. Codigo de moneda ISO 4217. Por defecto `"USD"`. Otros
  valores comunes: `"EUR"`, `"BRL"`, `"JPY"`. Ver
  [`get_divisas`](https://LisandroSeghezzo2003.github.io/indecr/reference/get_divisas.md)
  para la lista completa.

- desde:

  Character o Date. Fecha de inicio en formato `"YYYY-MM-DD"`. Por
  defecto `"2020-01-01"`.

- hasta:

  Character o Date. Fecha de fin en formato `"YYYY-MM-DD"`. Por defecto
  la fecha actual.

## Value

Un tibble con columnas:

- fecha:

  Date. Fecha de la cotizacion.

- moneda:

  Character. Codigo ISO de la moneda.

- valor:

  Numeric. Tipo de cotizacion en pesos argentinos.

## Examples

``` r
if (FALSE) { # \dontrun{
# Dolar oficial desde 2023
get_tc(desde = "2023-01-01")

# Euro
get_tc(moneda = "EUR", desde = "2023-01-01")

# Comparar USD y BRL
rbind(
  get_tc(moneda = "USD", desde = "2023-01-01"),
  get_tc(moneda = "BRL", desde = "2023-01-01")
)
} # }
```
