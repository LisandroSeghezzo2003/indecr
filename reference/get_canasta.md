# Obtener datos de canasta basica alimentaria y total

Descarga series de la Canasta Basica Alimentaria (CBA) y Canasta Basica
Total (CBT) desde la API de Series de Tiempo de datos.gob.ar. Los
valores estan expresados en pesos corrientes por adulto equivalente.

## Usage

``` r
get_canasta(serie = "cbt_nacional", desde = "2017-01-01", hasta = Sys.Date())
```

## Arguments

- serie:

  Character. Serie a descargar. Una de: `"cba_nacional"`,
  `"cbt_nacional"`, `"cba_gba"`, `"cba_pampeana"`, `"cba_nea"`,
  `"cba_noa"`, `"cba_cuyo"`, `"cba_patagonia"`, `"cbt_pampeana"`,
  `"cbt_nea"`, `"cbt_noa"`, `"cbt_cuyo"`, `"cbt_patagonia"`. Por defecto
  `"cbt_nacional"`.

- desde:

  Character o Date. Fecha de inicio en formato `"YYYY-MM-DD"`. Por
  defecto `"2017-01-01"`.

- hasta:

  Character o Date. Fecha de fin en formato `"YYYY-MM-DD"`. Por defecto
  la fecha actual.

## Value

Un tibble con columnas `fecha`, `serie` y `valor`. El valor representa
pesos corrientes por adulto equivalente por mes.

## Examples

``` r
if (FALSE) { # \dontrun{
# Canasta basica total nacional
get_canasta(desde = "2020-01-01")

# Comparar CBA y CBT nacional
rbind(
  get_canasta(serie = "cba_nacional", desde = "2022-01-01"),
  get_canasta(serie = "cbt_nacional", desde = "2022-01-01")
)

# CBA por region
regiones <- c("cba_gba", "cba_pampeana", "cba_noa", "cba_nea",
              "cba_cuyo", "cba_patagonia")
do.call(rbind, lapply(regiones, get_canasta, desde = "2022-01-01"))
} # }
```
