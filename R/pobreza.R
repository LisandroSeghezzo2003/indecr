.CANASTA_IDS <- c(
  # Nacionales
  cba_nacional       = "444.1_CANASTA_BARIA_0_0_26_47",
  cbt_nacional       = "444.1_CANASTA_BATAL_0_0_20_94",
  # Regionales CBA
  cba_gba            = "444.1_CANASTA_BARIAGBA_0_0_26_47",
  cba_pampeana       = "444.1_CANASTA_BARIAPampeana_0_0_26_47",
  cba_nea            = "444.1_CANASTA_BARIANoreste_0_0_26_47",
  cba_noa            = "444.1_CANASTA_BARIANoroeste_0_0_26_47",
  cba_cuyo           = "444.1_CANASTA_BARIACuyo_0_0_26_47",
  cba_patagonia      = "444.1_CANASTA_BARIAPatagonia_0_0_26_47",
  # Regionales CBT
  cbt_pampeana       = "444.1_CANASTA_batotPampeana_0_0_26_47",
  cbt_nea            = "444.1_CANASTA_batotNoreste_0_0_26_47",
  cbt_noa            = "444.1_CANASTA_batotNoroeste_0_0_26_47",
  cbt_cuyo           = "444.1_CANASTA_batotCuyo_0_0_26_47",
  cbt_patagonia      = "444.1_CANASTA_batotPatagonia_0_0_26_47"
)

#' Obtener datos de canasta basica alimentaria y total
#'
#' Descarga series de la Canasta Basica Alimentaria (CBA) y Canasta Basica
#' Total (CBT) desde la API de Series de Tiempo de datos.gob.ar.
#' Los valores estan expresados en pesos corrientes por adulto equivalente.
#'
#' @param serie Character. Serie a descargar. Una de: `"cba_nacional"`,
#'   `"cbt_nacional"`, `"cba_gba"`, `"cba_pampeana"`, `"cba_nea"`,
#'   `"cba_noa"`, `"cba_cuyo"`, `"cba_patagonia"`, `"cbt_pampeana"`,
#'   `"cbt_nea"`, `"cbt_noa"`, `"cbt_cuyo"`, `"cbt_patagonia"`.
#'   Por defecto `"cbt_nacional"`.
#' @param desde Character o Date. Fecha de inicio en formato `"YYYY-MM-DD"`.
#'   Por defecto `"2017-01-01"`.
#' @param hasta Character o Date. Fecha de fin en formato `"YYYY-MM-DD"`.
#'   Por defecto la fecha actual.
#'
#' @return Un tibble con columnas `fecha`, `serie` y `valor`.
#'   El valor representa pesos corrientes por adulto equivalente por mes.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Canasta basica total nacional
#' get_canasta(desde = "2020-01-01")
#'
#' # Comparar CBA y CBT nacional
#' rbind(
#'   get_canasta(serie = "cba_nacional", desde = "2022-01-01"),
#'   get_canasta(serie = "cbt_nacional", desde = "2022-01-01")
#' )
#'
#' # CBA por region
#' regiones <- c("cba_gba", "cba_pampeana", "cba_noa", "cba_nea",
#'               "cba_cuyo", "cba_patagonia")
#' do.call(rbind, lapply(regiones, get_canasta, desde = "2022-01-01"))
#' }
get_canasta <- function(serie = "cbt_nacional",
                        desde = "2017-01-01",
                        hasta = Sys.Date()) {

  series_validas <- names(.CANASTA_IDS)

  if (!serie %in% series_validas) {
    stop(
      "serie debe ser una de: ", paste(series_validas, collapse = ", "), ".",
      call. = FALSE
    )
  }

  id  <- .CANASTA_IDS[[serie]]
  raw <- .fetch_series(
    ids   = id,
    desde = desde,
    hasta = hasta
  )

  raw$serie    <- serie
  raw$serie_id <- NULL
  tibble::as_tibble(raw[, c("fecha", "serie", "valor")])
}
