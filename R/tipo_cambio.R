#' Obtener cotizaciones del tipo de cambio oficial
#'
#' Descarga cotizaciones de divisas desde la API de Estadisticas Cambiarias
#' del Banco Central de la Republica Argentina (BCRA).
#'
#' @param moneda Character. Codigo de moneda ISO 4217. Por defecto `"USD"`.
#'   Otros valores comunes: `"EUR"`, `"BRL"`, `"JPY"`. Ver
#'   \code{\link{get_divisas}} para la lista completa.
#' @param desde Character o Date. Fecha de inicio en formato `"YYYY-MM-DD"`.
#'   Por defecto `"2020-01-01"`.
#' @param hasta Character o Date. Fecha de fin en formato `"YYYY-MM-DD"`.
#'   Por defecto la fecha actual.
#'
#' @return Un tibble con columnas:
#'   \describe{
#'     \item{fecha}{Date. Fecha de la cotizacion.}
#'     \item{moneda}{Character. Codigo ISO de la moneda.}
#'     \item{valor}{Numeric. Tipo de cotizacion en pesos argentinos.}
#'   }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Dolar oficial desde 2023
#' get_tc(desde = "2023-01-01")
#'
#' # Euro
#' get_tc(moneda = "EUR", desde = "2023-01-01")
#'
#' # Comparar USD y BRL
#' rbind(
#'   get_tc(moneda = "USD", desde = "2023-01-01"),
#'   get_tc(moneda = "BRL", desde = "2023-01-01")
#' )
#' }
get_tc <- function(moneda = "USD",
                   desde  = "2020-01-01",
                   hasta  = Sys.Date()) {

  base_url <- paste0(
    "https://api.bcra.gob.ar/estadisticascambiarias/v1.0/Cotizaciones/",
    toupper(moneda)
  )

  resp <- tryCatch(
    httr2::request(base_url) |>
      httr2::req_url_query(
        fechadesde = format(as.Date(desde), "%Y-%m-%d"),
        fechahasta = format(as.Date(hasta),  "%Y-%m-%d")
      ) |>
      httr2::req_user_agent(
        "indecr R package (https://github.com/TU_USUARIO/indecr)"
      ) |>
      httr2::req_timeout(30) |>
      httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
      httr2::req_perform() |>
      httr2::resp_body_json(),
    httr2_http_400 = function(e) {
      stop(
        "Moneda no encontrada: '", moneda, "'. ",
        "Usa get_divisas() para ver los codigos disponibles.",
        call. = FALSE
      )
    },
    httr2_error = function(e) {
      stop(
        "Error al conectar con la API del BCRA: ",
        conditionMessage(e),
        call. = FALSE
      )
    }
  )

  if (length(resp$results) == 0) {
    warning(
      "La API del BCRA no devolvio datos para el rango solicitado.",
      call. = FALSE
    )
    return(
      tibble::tibble(
        fecha  = as.Date(character()),
        moneda = character(),
        valor  = numeric()
      )
    )
  }

  # parsear resultados
  filas <- lapply(resp$results, function(r) {
    data.frame(
      fecha  = as.Date(r$fecha),
      moneda = moneda,
      valor  = r$detalle[[1]]$tipoCotizacion,
      stringsAsFactors = FALSE
    )
  })

  resultado <- do.call(rbind, filas)
  resultado <- resultado[order(resultado$fecha), ]
  tibble::as_tibble(resultado)
}

#' Listar divisas disponibles en la API del BCRA
#'
#' @return Un tibble con columnas `codigo` y `descripcion`.
#' @export
#'
#' @examples
#' \dontrun{
#' get_divisas()
#' }
get_divisas <- function() {
  resp <- tryCatch(
    httr2::request(
      "https://api.bcra.gob.ar/estadisticascambiarias/v1.0/Maestros/Divisas"
    ) |>
      httr2::req_timeout(30) |>
      httr2::req_perform() |>
      httr2::resp_body_json(),
    httr2_error = function(e) {
      stop(
        "Error al conectar con la API del BCRA: ",
        conditionMessage(e),
        call. = FALSE
      )
    }
  )

  filas <- lapply(resp$results, function(d) {
    data.frame(
      codigo      = d$codigo,
      descripcion = d$denominacion,
      stringsAsFactors = FALSE
    )
  })

  tibble::as_tibble(do.call(rbind, filas))
}
