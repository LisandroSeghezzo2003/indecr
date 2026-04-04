test_that("get_canasta devuelve tibble con columnas correctas", {
  skip_if_offline()
  skip_on_ci()
  resultado <- get_canasta(desde = "2022-01-01", hasta = "2022-06-01")
  expect_s3_class(resultado, "tbl_df")
  expect_named(resultado, c("fecha", "serie", "valor"))
  expect_s3_class(resultado$fecha, "Date")
  expect_equal(unique(resultado$serie), "cbt_nacional")
  expect_equal(nrow(resultado), 6L)
})

test_that("get_canasta rechaza serie invalida", {
  expect_error(get_canasta(serie = "xxx"), "serie debe ser una de")
})

test_that("get_canasta funciona para series regionales", {
  skip_if_offline()
  skip_on_ci()
  for (s in c("cba_gba", "cba_pampeana", "cbt_cuyo", "cbt_patagonia")) {
    resultado <- get_canasta(serie = s, desde = "2022-01-01", hasta = "2022-03-01")
    expect_equal(nrow(resultado), 3L)
    expect_equal(unique(resultado$serie), s)
  }
})
