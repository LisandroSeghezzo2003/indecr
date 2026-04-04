test_that("get_tc devuelve tibble con columnas correctas", {
  skip_if_offline()
  resultado <- get_tc(desde = "2024-01-02", hasta = "2024-01-05")
  expect_s3_class(resultado, "tbl_df")
  expect_named(resultado, c("fecha", "moneda", "valor"))
  expect_s3_class(resultado$fecha, "Date")
  expect_equal(unique(resultado$moneda), "USD")
})

test_that("get_tc rechaza moneda invalida", {
  skip_if_offline()
  expect_error(get_tc(moneda = "XXX"), "Moneda no encontrada")
})

test_that("get_divisas devuelve tibble con codigos", {
  skip_if_offline()
  resultado <- get_divisas()
  expect_s3_class(resultado, "tbl_df")
  expect_named(resultado, c("codigo", "descripcion"))
  expect_true("USD" %in% resultado$codigo)
  expect_true("EUR" %in% resultado$codigo)
})
