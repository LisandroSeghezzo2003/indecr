#' Deflactar una serie nominal a valores reales
#'
#' Convierte una serie de valores nominales a valores reales usando el IPC
#' nacional base diciembre 2016. Permite expresar los valores en cualquier
#' fecha base.
#'
#' @param x Numeric. Vector de valores nominales a deflactar.
#' @param fechas Date o Character. Vector de fechas correspondientes a
#'   cada valor de `x`. Deben estar en formato `"YYYY-MM-DD"` o ser
#'   objetos Date. Deben tener la misma longitud que `x`.
#' @param base Date o Character. Fecha base en la que se expresan los
#'   valores reales. Por defecto `NULL`, que devuelve valores en terminos
#'   del indice original (base dic 2016 = 100). Ejemplo: `"2022-01-01"`
#'   expresa todos los valores en pesos de enero 2022.
#' @param serie_ipc Character. Serie del IPC a usar para deflactar.
#'   Por defecto `"nacional"`. Ver \code{\link{get_ipc}} para opciones.
#'
#' @return Un vector numerico de la misma longitud que `x` con los valores
#'   deflactados.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Deflactar salarios a pesos de enero 2022
#' salarios <- get_salarios(desde = "2020-01-01")
#' salarios$real <- deflate(
#'   x      = salarios$valor,
#'   fechas = salarios$fecha,
#'   base   = "2022-01-01"
#' )
#'
#' # Deflactar canasta basica
#' canasta <- get_canasta(desde = "2020-01-01")
#' canasta$real <- deflate(canasta$valor, canasta$fecha, base = "2020-01-01")
#' }
deflate <- function(x,
                    fechas,
                    base       = NULL,
                    serie_ipc  = "nacional") {

  # --- validaciones -----------------------------------------------------------
  if (!is.numeric(x)) stop("x debe ser un vector numerico.", call. = FALSE)
  fechas <- tryCatch(
    as.Date(fechas),
    error = function(e) stop("fechas debe ser convertible a Date.", call. = FALSE)
  )
  if (length(x) != length(fechas)) {
    stop("x y fechas deben tener la misma longitud.", call. = FALSE)
  }
  if (any(is.na(fechas))) stop("fechas no puede contener NA.", call. = FALSE)

  # --- traer IPC para el rango necesario --------------------------------------
  desde_ipc <- format(min(fechas), "%Y-%m-%d")
  hasta_ipc <- format(max(fechas), "%Y-%m-%d")

  # si hay base, puede que necesitemos IPC para esa fecha tambien
  if (!is.null(base)) {
    base <- as.Date(base)
    desde_ipc <- format(min(min(fechas), base), "%Y-%m-%d")
    hasta_ipc <- format(max(max(fechas), base), "%Y-%m-%d")
  }

  ipc <- get_ipc(serie = serie_ipc, desde = desde_ipc, hasta = hasta_ipc)

  # --- verificar que tenemos IPC para todas las fechas de x ------------------
  fechas_mes <- as.Date(format(fechas, "%Y-%m-01"))
  faltantes  <- setdiff(
    as.character(fechas_mes),
    as.character(ipc$fecha)
  )
  if (length(faltantes) > 0) {
    stop(
      "No hay datos de IPC para las siguientes fechas: ",
      paste(faltantes, collapse = ", "), ".",
      call. = FALSE
    )
  }

  # --- construir vector de IPC alineado con x ---------------------------------
  ipc_lookup        <- ipc$valor
  names(ipc_lookup) <- as.character(ipc$fecha)
  ipc_x             <- as.numeric(ipc_lookup[as.character(fechas_mes)])

  # --- deflactar --------------------------------------------------------------
  if (is.null(base)) {
    # devolver en terminos del indice original (base dic 2016 = 100)
    resultado <- x / ipc_x * 100
  } else {
    # expresar en pesos de la fecha base
    base_mes <- as.Date(format(base, "%Y-%m-01"))
    if (!as.character(base_mes) %in% names(ipc_lookup)) {
      stop(
        "No hay datos de IPC para la fecha base: ", base_mes, ".",
        call. = FALSE
      )
    }
    ipc_base  <- as.numeric(ipc_lookup[as.character(base_mes)])
    resultado <- x / ipc_x * ipc_base
  }

  resultado
}
