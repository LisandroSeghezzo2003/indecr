test_that("deflate devuelve vector numerico de misma longitud", {
  skip_if_offline()
  skip_on_ci()
  sal <- get_salarios(desde = "2022-01-01", hasta = "2022-06-01")
  resultado <- deflate(sal$valor, sal$fecha)
  expect_type(resultado, "double")
  expect_length(resultado, nrow(sal))
})

test_that("deflate con base devuelve valores en pesos de esa fecha", {
  skip_if_offline()
  skip_on_ci()
  sal <- get_salarios(desde = "2022-01-01", hasta = "2022-06-01")
  resultado <- deflate(sal$valor, sal$fecha, base = "2022-01-01")
  # el valor de enero 2022 deflactado a base enero 2022 debe ser igual al nominal
  expect_equal(resultado[1], sal$valor[1], tolerance = 0.01)
})

test_that("deflate rechaza x no numerico", {
  expect_error(
    deflate(c("a", "b"), c("2022-01-01", "2022-02-01")),
    "x debe ser un vector numerico"
  )
})

test_that("deflate rechaza longitudes distintas", {
  expect_error(
    deflate(c(1, 2, 3), c("2022-01-01", "2022-02-01")),
    "misma longitud"
  )
})
