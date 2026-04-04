test_that("ipc_chain nacional devuelve tibble con columnas correctas", {
  skip_if_offline()
  skip_on_ci()
  resultado <- ipc_chain(desde = "2022-01-01", hasta = "2022-06-01")
  expect_s3_class(resultado, "tbl_df")
  expect_named(resultado, c("fecha", "region", "valor"))
  expect_s3_class(resultado$fecha, "Date")
  expect_equal(unique(resultado$region), "nacional")
  expect_equal(nrow(resultado), 6L)
})

test_that("ipc_chain regional devuelve datos correctos", {
  skip_if_offline()
  skip_on_ci()
  resultado <- ipc_chain(region = "gba", desde = "2022-01-01", hasta = "2022-06-01")
  expect_equal(nrow(resultado), 6L)
  expect_equal(unique(resultado$region), "gba")
  expect_true(all(!is.na(resultado$valor)))
})

test_that("ipc_chain rechaza region invalida", {
  expect_error(ipc_chain(region = "xxx"), "region debe ser una de")
})

test_that("ipc_chain funciona para todas las regiones", {
  skip_if_offline()
  skip_on_ci()
  for (r in c("gba", "pampeana", "noa", "nea", "cuyo", "patagonia")) {
    resultado <- ipc_chain(region = r, desde = "2022-01-01", hasta = "2022-03-01")
    expect_equal(nrow(resultado), 3L)
    expect_equal(unique(resultado$region), r)
  }
})
