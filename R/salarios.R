.SALARIOS_IDS <- c(
  ripte             = "158.1_REPTE_0_0_5",
  privado_registrado   = "149.1_SOR_PRIADO_OCTU_0_25",
  privado_no_registrado = "149.1_SOR_PRIADO_OCTU_0_28",
  publico           = "149.1_SOR_PUBICO_OCTU_0_14"
)

#' Obtener indices de salarios argentinos
#'
#' Descarga series de salarios desde la API de Series de Tiempo de
#' datos.gob.ar. Incluye el RIPTE y los indices de salarios por sector.
#'
#' @param serie Character. Serie a descargar. Una de: `"ripte"`,
#'   `"privado_registrado"`, `"privado_no_registrado"`, `"publico"`.
#'   Por defecto `"ripte"`.
#' @param desde Character o Date. Fecha de inicio en formato `"YYYY-MM-DD"`.
#'   Por defecto `"2017-01-01"`.
#' @param hasta Character o Date. Fecha de fin en formato `"YYYY-MM-DD"`.
#'   Por defecto la fecha actual.
#' @param variacion Character. Tipo de variacion. Una de: `"ninguna"`,
#'   `"mensual"`, `"interanual"`, `"acumulada"`. Por defecto `"ninguna"`.
#'
#' @return Un tibble con columnas `fecha`, `serie` y `valor`.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # RIPTE desde 2020
#' get_salarios(desde = "2020-01-01")
#'
#' # Variacion interanual salario privado registrado
#' get_salarios(serie = "privado_registrado", variacion = "interanual")
#' }
get_salarios <- function(serie     = "ripte",
                         desde     = "2017-01-01",
                         hasta     = Sys.Date(),
                         variacion = "ninguna") {

  series_validas      <- names(.SALARIOS_IDS)
  variaciones_validas <- c("ninguna", "mensual", "interanual", "acumulada")

  if (!serie %in% series_validas) {
    stop(
      "serie debe ser una de: ", paste(series_validas, collapse = ", "), ".",
      call. = FALSE
    )
  }
  if (!variacion %in% variaciones_validas) {
    stop(
      "variacion debe ser una de: ",
      paste(variaciones_validas, collapse = ", "), ".",
      call. = FALSE
    )
  }

  rep_mode <- switch(variacion,
                     ninguna    = "value",
                     mensual    = "percent_change",
                     interanual = "percent_change_a_year_ago",
                     acumulada  = "percent_change_since_beginning_of_year"
  )

  id  <- .SALARIOS_IDS[[serie]]
  raw <- .fetch_series(
    ids   = paste0(id, ":", rep_mode),
    desde = desde,
    hasta = hasta
  )

  raw$serie    <- serie
  raw$serie_id <- NULL
  tibble::as_tibble(raw[, c("fecha", "serie", "valor")])
}
