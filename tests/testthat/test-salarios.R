test_that("get_salarios devuelve tibble con columnas correctas", {
  skip_if_offline()
  skip_on_ci()
  resultado <- get_salarios(desde = "2022-01-01", hasta = "2022-06-01")
  expect_s3_class(resultado, "tbl_df")
  expect_named(resultado, c("fecha", "serie", "valor"))
  expect_equal(unique(resultado$serie), "ripte")
  expect_equal(nrow(resultado), 6L)
})

test_that("get_salarios rechaza serie invalida", {
  expect_error(get_salarios(serie = "informal"), "serie debe ser una de")
})

test_that("get_salarios rechaza variacion invalida", {
  expect_error(get_salarios(variacion = "semanal"), "variacion debe ser una de")
})

test_that("get_salarios funciona para todos los sectores", {
  skip_if_offline()
  skip_on_ci()
  for (s in c("ripte", "privado_registrado", "privado_no_registrado", "publico")) {
    resultado <- get_salarios(serie = s, desde = "2022-01-01", hasta = "2022-03-01")
    expect_equal(unique(resultado$serie), s)
  }
})
