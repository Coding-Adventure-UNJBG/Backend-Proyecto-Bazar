const controllers = {}
import model from "../model/ventas.js"

controllers.mostrar = async (req, res) => {
  model.mostrarTodo()
    .then((data) => {
      if (data.length == 0) {
        res.status(404).send({ error: 'No se encontraron resultados' })
      } else {
        res.json(data)
      }
    })
    .catch((err) => {
      res.status(500).send({ error: 'Error interno del servidor al obtener resultados' })
    })
}

controllers.obtenerCorrelativo = async (req, res) => {
  model.obtenerCorrelativo()
    .then((data) => {
      if (data.length == 0) {
        res.status(404).send({ error: 'No se encontraron resultados' })
      }
      else {
        // parseInt(data[0].id, 10) + 1
        console.log(data[0].correlativo)
        res.json(data)
      }
    })
    .catch((error) => {
      // console.log(error)
      res.status(500).send({ error: 'Error interno del servidor al obtener resultados' })
    })
}

controllers.insertar = async (req, res) => {
  let insertDetalle = false
  const datosVenta = req.body
  console.log(datosVenta)
  console.log(datosVenta.detalleVenta)
  await model.insertarVenta(datosVenta)
    .then((response) => {
      console.log("Cantidad de filas insertadas: " + response)
      if (response >= 1) {
        insertDetalle = true
        // res.status(201).send({ message: 'Entrada registrada correctamente' })
      } else {
        res.status(500).send({ error: 'Error al insertar los datos' })
      }
    })
    .catch((err) => {
      res.status(500).send({ error: 'Error interno del servidor al obtener resultados' })
    })

  if (insertDetalle) {
    //Obtenemos el id de la venta
    let id_venta
    await model.obtenerId()
      .then((data) => {
        if (data.length == 0) {
          res.status(404).send({ error: 'No se encontraron resultados' })
        }
        else {
          id_venta = data[0].id
          console.log('Detalle para el id => ', id_venta)
          // res.json(data)
        }
      })
      .catch((error) => {
        res.status(500).send({ error: 'Error interno del servidor al obtener resultados' })
      })

    //Insertamos detalle de venta
    // for (const venta in datosVenta.detalleVenta){
    //   console.log(venta)
    // }
    for (const detalle of datosVenta.detalleVenta){
      let updateStock = false
      console.log(detalle)
      await model.insertarDetalle(id_venta, detalle)
      await model.actualizarStock(detalle)
    }
  }
}

export default controllers