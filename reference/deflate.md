# Deflactar una serie nominal a valores reales

Convierte una serie de valores nominales a valores reales usando el IPC
nacional base diciembre 2016. Permite expresar los valores en cualquier
fecha base.

## Usage

``` r
deflate(x, fechas, base = NULL, serie_ipc = "nacional")
```

## Arguments

- x:

  Numeric. Vector de valores nominales a deflactar.

- fechas:

  Date o Character. Vector de fechas correspondientes a cada valor de
  `x`. Deben estar en formato `"YYYY-MM-DD"` o ser objetos Date. Deben
  tener la misma longitud que `x`.

- base:

  Date o Character. Fecha base en la que se expresan los valores reales.
  Por defecto `NULL`, que devuelve valores en terminos del indice
  original (base dic 2016 = 100). Ejemplo: `"2022-01-01"` expresa todos
  los valores en pesos de enero 2022.

- serie_ipc:

  Character. Serie del IPC a usar para deflactar. Por defecto
  `"nacional"`. Ver
  [`get_ipc`](https://LisandroSeghezzo2003.github.io/indecr/reference/get_ipc.md)
  para opciones.

## Value

Un vector numerico de la misma longitud que `x` con los valores
deflactados.

## Examples

``` r
if (FALSE) { # \dontrun{
# Deflactar salarios a pesos de enero 2022
salarios <- get_salarios(desde = "2020-01-01")
salarios$real <- deflate(
  x      = salarios$valor,
  fechas = salarios$fecha,
  base   = "2022-01-01"
)

# Deflactar canasta basica
canasta <- get_canasta(desde = "2020-01-01")
canasta$real <- deflate(canasta$valor, canasta$fecha, base = "2020-01-01")
} # }
```
