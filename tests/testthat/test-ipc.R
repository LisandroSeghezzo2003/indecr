test_that("get_ipc devuelve tibble con columnas correctas", {
  skip_if_offline()
  skip_on_ci()
  resultado <- get_ipc(desde = "2022-01-01", hasta = "2022-06-01")
  expect_s3_class(resultado, "tbl_df")
  expect_named(resultado, c("fecha", "serie", "valor"))
  expect_s3_class(resultado$fecha, "Date")
  expect_equal(unique(resultado$serie), "nacional")
  expect_equal(nrow(resultado), 6L)
})

test_that("get_ipc rechaza serie invalida", {
  expect_error(get_ipc(serie = "mesopotamia"), "serie debe ser una de")
})

test_that("get_ipc rechaza variacion invalida", {
  expect_error(get_ipc(variacion = "semanal"), "variacion debe ser una de")
})

test_that("get_ipc funciona para series regionales", {
  skip_if_offline()
  skip_on_ci()
  resultado <- get_ipc(serie = "patagonia", desde = "2022-01-01", hasta = "2022-03-01")
  expect_equal(nrow(resultado), 3L)
  expect_equal(unique(resultado$serie), "patagonia")
})
