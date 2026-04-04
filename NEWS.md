# indecr 0.0.0.9000

## Nuevas funciones

* `get_ipc()` — descarga el IPC nacional y regional desde la API de
  Series de Tiempo (base diciembre 2016). Soporta variación mensual,
  interanual y acumulada.

* `ipc_chain()` — serie histórica empalmada del IPC por región, usando
  el archivo oficial del INDEC. Cubre desde diciembre 2016 hasta la
  actualidad.

* `get_salarios()` — índices de salarios por sector (RIPTE, privado
  registrado, privado no registrado, público).

* `get_tc()` — cotizaciones de divisas desde la API de Estadísticas
  Cambiarias del BCRA.

* `get_divisas()` — lista de divisas disponibles en la API del BCRA.

* `get_canasta()` — Canasta Básica Alimentaria (CBA) y Canasta Básica
  Total (CBT) nacional y por región.

* `deflate()` — convierte series nominales a valores reales usando el
  IPC como deflactor.

## Fuentes

- [API Series de Tiempo](https://www.argentina.gob.ar/datos-abiertos/api-series-de-tiempo) —
  Gobierno de la Republica Argentina
- [API BCRA](https://www.bcra.gob.ar/apis-banco-central/) —
  Banco Central de la República Argentina
- [Excel IPC](https://www.indec.gob.ar/ftp/cuadros/economia/sh_ipc_aperturas.xls) —
  INDEC
