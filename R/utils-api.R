.fetch_series <- function(ids,
                          desde    = NULL,
                          hasta    = NULL,
                          collapse = "month") {

  # --- validaciones básicas ---------------------------------------------------
  if (length(ids) == 0) stop("Deb\u00e9s proveer al menos un ID de serie.", call. = FALSE)
  if (length(ids) > 40) stop("La API acepta hasta 40 series por llamada.", call. = FALSE)

  # --- construir URL ----------------------------------------------------------
  base_url <- "https://apis.datos.gob.ar/series/api/series"

  params <- list(
    ids      = paste(ids, collapse = ","),
    format   = "json",
    collapse = collapse,
    limit    = 1000
  )

  if (!is.null(desde)) params$start_date <- format(as.Date(desde), "%Y-%m-%d")
  if (!is.null(hasta)) params$end_date   <- format(as.Date(hasta),  "%Y-%m-%d")

  url <- httr2::request(base_url) |>
    httr2::req_url_query(!!!params) |>
    httr2::req_user_agent("indecr R package (https://github.com/TU_USUARIO/indecr)") |>
    httr2::req_timeout(30) |>
    httr2::req_retry(max_tries = 3, backoff = ~ 2)

  # --- ejecutar y manejar errores ---------------------------------------------
  resp <- tryCatch(
    httr2::req_perform(url),
    httr2_error = function(e) {
      stop(
        "Error al conectar con la API de datos.gob.ar: ", conditionMessage(e),
        call. = FALSE
      )
    }
  )

  if (httr2::resp_status(resp) != 200) {
    stop(
      "La API respondio con status ", httr2::resp_status(resp), ". ",
      "Verificá los IDs de series o intentá más tarde.",
      call. = FALSE
    )
  }

  # --- parsear respuesta ------------------------------------------------------
  raw <- httr2::resp_body_json(resp, simplifyVector = FALSE)

  if (length(raw$data) == 0) {
    warning("La API devolvio cero filas. Revisá los IDs o el rango de fechas.",
            call. = FALSE)
    return(
      tibble::tibble(fecha = as.Date(character()), serie_id = character(), valor = numeric())
    )
  }

  # La API devuelve: [[fecha, val1, val2, ...], ...]
  # Los headers estan en raw$meta[[i]]$field$id
  # DESPUES
  series_ids <- vapply(
    raw$meta,
    function(m) if (!is.null(m$field$id)) m$field$id else NA_character_,
    character(1)
  )
  series_ids <- series_ids[!is.na(series_ids)]

  # Convertir lista de listas a data.frame largo
  filas <- lapply(raw$data, function(row) {
    fecha <- as.Date(row[[1]])
    vals  <- as.numeric(unlist(row[seq_along(series_ids) + 1]))  # NA si viene NULL
    data.frame(
      fecha    = rep(fecha, length(vals)),
      serie_id = series_ids,
      valor    = vals,
      stringsAsFactors = FALSE
    )
  })

  resultado <- do.call(rbind, filas)
  tibble::as_tibble(resultado)
}
.fetch_ipc_csv <- function(columnas = NULL) {

  csv_url <- paste0(
    "https://infra.datos.gob.ar/catalog/sspm/dataset/145/",
    "distribution/145.9/download/",
    "indice-precios-al-consumidor-apertura-por-categorias-",
    "base-diciembre-2016-mensual.csv"
  )

  raw <- tryCatch(
    read.csv(csv_url, stringsAsFactors = FALSE),
    error = function(e) {
      stop(
        "No se pudo descargar el CSV del IPC regional: ",
        conditionMessage(e),
        call. = FALSE
      )
    }
  )

  raw$indice_tiempo <- as.Date(raw$indice_tiempo)

  if (!is.null(columnas)) {
    cols_invalidas <- setdiff(columnas, names(raw))
    if (length(cols_invalidas) > 0) {
      stop(
        "Columnas no encontradas en el CSV: ",
        paste(cols_invalidas, collapse = ", "),
        call. = FALSE
      )
    }
    raw <- raw[, c("indice_tiempo", columnas), drop = FALSE]
  }

  # Pasar a formato largo (igual que .fetch_series)
  result <- do.call(rbind, lapply(
    setdiff(names(raw), "indice_tiempo"),
    function(col) {
      data.frame(
        fecha    = raw$indice_tiempo,
        serie_id = col,
        valor    = raw[[col]],
        stringsAsFactors = FALSE
      )
    }
  ))

  tibble::as_tibble(result)
}
