# IDs internos de las series IPC base diciembre 2016
# Series disponibles via API (nacionales)
.IPC_API_IDS <- c(
  nacional     = "148.3_INIVELNAL_DICI_M_26",
  nucleo       = "148.3_INUCLEONAL_DICI_M_19",
  regulados    = "148.3_IREGULANAL_DICI_M_22",
  estacionales = "148.3_IESTACINAL_DICI_M_26"
)

# Series disponibles via CSV (regionales — IDs son nombres de columna del CSV)
.IPC_CSV_COLS <- c(
  gba       = "ipc_nivel_general_gba",
  pampeana  = "ipc_nivel_general_pampeana",
  nea       = "ipc_nivel_general_nea",
  noa       = "ipc_nivel_general_noa",
  cuyo      = "ipc_nivel_general_cuyo",
  patagonia = "ipc_nivel_general_patagonia"
)
#' Obtener datos del IPC argentino
#'
#' Descarga series del \enc{Índice}{Indice} de Precios al Consumidor (IPC)
#' base diciembre 2016 desde la API de Series de Tiempo de datos.gob.ar.
#'
#' @param serie Character. Serie a descargar. Una de: `"nacional"`,
#'   `"gba"`, `"cuyo"`, `"pampeana"`, `"noroeste"`, `"noreste"`,
#'   `"patagonia"`, `"nucleo"`, `"regulados"`, `"estacionales"`.
#'   Por defecto `"nacional"`.
#' @param desde Character o Date. Fecha de inicio en formato `"YYYY-MM-DD"`.
#'   Por defecto `"2017-01-01"`.
#' @param hasta Character o Date. Fecha de fin en formato `"YYYY-MM-DD"`.
#'   Por defecto la fecha actual.
#' @param variacion Character. Tipo de variacion a calcular sobre el indice.
#'   Una de: `"ninguna"` (valor del indice), `"mensual"`, `"interanual"`,
#'   `"acumulada"`. Por defecto `"ninguna"`.
#'
#' @return Un tibble con columnas:
#'   \describe{
#'     \item{fecha}{Date. Primer dia del mes.}
#'     \item{serie}{Character. Nombre de la serie solicitada.}
#'     \item{valor}{Numeric. Valor del indice o variacion porcentual.}
#'   }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # IPC nivel general desde 2020
#' get_ipc(desde = "2020-01-01")
#'
#' # Variacion mensual del nucleo
#' get_ipc(serie = "nucleo", variacion = "mensual")
#'
#' # Comparar GBA vs Patagonia
#' rbind(
#'   get_ipc(serie = "gba"),
#'   get_ipc(serie = "patagonia")
#' )
#' }
get_ipc <- function(serie     = "nacional",
                    desde     = "2017-01-01",
                    hasta     = Sys.Date(),
                    variacion = "ninguna") {

  series_validas    <- c(names(.IPC_API_IDS), names(.IPC_CSV_COLS))
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

  # --- fuente API -------------------------------------------------------------
  if (serie %in% names(.IPC_API_IDS)) {

    rep_mode <- switch(variacion,
                       ninguna    = "value",
                       mensual    = "percent_change",
                       interanual = "percent_change_a_year_ago",
                       acumulada  = "percent_change_since_beginning_of_year"
    )

    id  <- .IPC_API_IDS[[serie]]
    raw <- .fetch_series(
      ids   = paste0(id, ":", rep_mode),
      desde = desde,
      hasta = hasta
    )

    # --- fuente CSV -------------------------------------------------------------
  } else {

    col <- .IPC_CSV_COLS[[serie]]
    raw <- .fetch_ipc_csv(columnas = col)

    # filtrar rango de fechas
    raw <- raw[raw$fecha >= as.Date(desde) & raw$fecha <= as.Date(hasta), ]

    # calcular variacion si se pidio
    if (variacion != "ninguna") {
      raw <- raw[order(raw$fecha), ]
      raw$valor <- switch(variacion,
                          mensual    = c(NA, diff(raw$valor) / utils::head(raw$valor, -1) * 100),
                          interanual = c(rep(NA, 12), diff(raw$valor, lag = 12) /
                                           utils::head(raw$valor, -12) * 100),
                          acumulada  = {
                            raw$anio <- as.integer(format(raw$fecha, "%Y"))
                            ene <- tapply(raw$valor, raw$anio, utils::head, 1)
                            val_ene <- ene[as.character(raw$anio)]
                            (raw$valor / as.numeric(val_ene) - 1) * 100
                          }
      )
    }
  }

  raw$serie    <- serie
  raw$serie_id <- NULL
  tibble::as_tibble(raw[, c("fecha", "serie", "valor")])
}
