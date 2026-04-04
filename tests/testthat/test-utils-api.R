test_that(".fetch_series rechaza ids vacio", {
  expect_error(.fetch_series(ids = character(0)), "al menos un ID")
})

test_that(".fetch_series rechaza mas de 40 ids", {
  ids_falsos <- paste0("serie_", seq_len(41))
  expect_error(.fetch_series(ids = ids_falsos), "hasta 40 series")
})

test_that(".fetch_series devuelve tibble con columnas correctas", {
  skip_if_offline()
  resultado <- .fetch_series(
    ids   = "148.3_INIVELNAL_DICI_M_26",
    desde = "2022-01-01",
    hasta = "2022-03-01"
  )
  expect_s3_class(resultado, "tbl_df")
  expect_named(resultado, c("fecha", "serie_id", "valor"))
  expect_s3_class(resultado$fecha, "Date")
  expect_equal(nrow(resultado), 3L)
})

test_that(".fetch_series devuelve tibble vacio con warning para rango sin datos", {
  skip_if_offline()
  expect_warning(
    resultado <- .fetch_series(
      ids   = "148.3_INIVELNAL_DICI_M_26",
      desde = "2000-01-01",
      hasta = "2000-06-01"
    ),
    "cero filas"
  )
  expect_equal(nrow(resultado), 0L)
})

test_that(".fetch_ipc_csv devuelve tibble con columnas correctas", {
  skip_if_offline()
  resultado <- .fetch_ipc_csv(columnas = "ipc_nivel_general_gba")
  expect_s3_class(resultado, "tbl_df")
  expect_named(resultado, c("fecha", "serie_id", "valor"))
  expect_s3_class(resultado$fecha, "Date")
  expect_true(nrow(resultado) > 0)
})

test_that(".fetch_ipc_csv rechaza columnas inexistentes", {
  skip_if_offline()
  expect_error(
    .fetch_ipc_csv(columnas = "columna_que_no_existe"),
    "Columnas no encontradas"
  )
})
