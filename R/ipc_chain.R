# Mapa de region a fila en el Excel del INDEC
.IPC_CHAIN_FILAS <- c(
  gba      = 2,
  pampeana = 52,
  noa      = 100,
  nea      = 148,
  cuyo     = 196,
  patagonia = 244
)

.IPC_CHAIN_URL <- paste0(
  "https://www.indec.gob.ar/ftp/cuadros/economia/",
  "sh_ipc_aperturas.xls"
)

#' Obtener serie historica empalmada del IPC
#'
#' Descarga la serie completa del IPC desde diciembre 2016 hasta la
#' actualidad, empalmada por el INDEC en una base unica. Para el nivel
#' nacional usa la API de Series de Tiempo; para las regiones usa el
#' archivo Excel oficial del INDEC.
#'
#' @param region Character. Region a consultar. Una de: `"nacional"`,
#'   `"gba"`, `"pampeana"`, `"noa"`, `"nea"`, `"cuyo"`, `"patagonia"`.
#'   Por defecto `"nacional"`.
#' @param desde Character o Date. Fecha de inicio. Por defecto
#'   `"2017-01-01"`.
#' @param hasta Character o Date. Fecha de fin. Por defecto la fecha
#'   actual.
#'
#' @return Un tibble con columnas `fecha`, `region` y `valor`.
#'   El indice tiene base diciembre 2016 = 100.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Serie nacional completa
#' ipc_chain()
#'
#' # Serie GBA desde 2020
#' ipc_chain(region = "gba", desde = "2020-01-01")
#'
#' # Comparar todas las regiones
#' regiones <- c("gba", "pampeana", "noa", "nea", "cuyo", "patagonia")
#' do.call(rbind, lapply(regiones, ipc_chain, desde = "2020-01-01"))
#' }
ipc_chain <- function(region = "nacional",
                      desde  = "2017-01-01",
                      hasta  = Sys.Date()) {

  regiones_validas <- c("nacional", names(.IPC_CHAIN_FILAS))

  if (!region %in% regiones_validas) {
    stop(
      "region debe ser una de: ",
      paste(regiones_validas, collapse = ", "), ".",
      call. = FALSE
    )
  }

  # --- nacional: usar API -----------------------------------------------------
  if (region == "nacional") {
    raw <- get_ipc(serie = "nacional", desde = desde, hasta = hasta)
    raw$region   <- "nacional"
    raw$serie    <- NULL
    return(tibble::as_tibble(raw[, c("fecha", "region", "valor")]))
  }

  # --- regiones: usar Excel del INDEC -----------------------------------------
  tmp <- tempfile(fileext = ".xls")

  tryCatch(
    httr2::request(.IPC_CHAIN_URL) |>
      httr2::req_timeout(60) |>
      httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
      httr2::req_perform() |>
      httr2::resp_body_raw() |>
      writeBin(tmp),
    httr2_error = function(e) {
      stop(
        "No se pudo descargar el archivo del INDEC: ",
        conditionMessage(e),
        call. = FALSE
      )
    }
  )

  ipc_raw <- tryCatch(
    suppressWarnings(
      readxl::read_excel(tmp, sheet = "\u00cdndices aperturas", skip = 4)
    ),
    error = function(e) {
      stop(
        "No se pudo leer el archivo Excel del INDEC: ",
        conditionMessage(e),
        call. = FALSE
      )
    }
  )

  # --- extraer fechas ---------------------------------------------------------
  fechas_excel <- as.numeric(names(ipc_raw)[-1])
  fechas       <- as.Date(fechas_excel, origin = "1899-12-30")

  # --- extraer fila de nivel general para la region --------------------------
  fila   <- .IPC_CHAIN_FILAS[[region]]
  valores <- as.numeric(ipc_raw[fila, -1])

  resultado <- tibble::tibble(
    fecha  = fechas,
    region = region,
    valor  = valores
  )

  # --- filtrar rango ----------------------------------------------------------
  resultado <- resultado[
    resultado$fecha >= as.Date(desde) &
      resultado$fecha <= as.Date(hasta), ]

  resultado
}
