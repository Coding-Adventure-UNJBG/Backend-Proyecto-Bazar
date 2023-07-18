const controllers = {}
import model from "../model/entrada.js"

controllers.obtenerId = async (req, res) => {
  model.obtenerId()
    .then((data) => {
      if (data.length == 0) {
        res.status(404).send({ error: 'No se encontraron resultados' })
      }
      else {
        res.json(data)
      }
    })
    .catch((error) => {
      // console.log(error)
      res.status(500).send({ error: 'Error interno del servidor al obtener resultados' })
    })
}

controllers.insertar = async (req, res) => {
  let updateStock = false
  let updatePrice = false
  await model.insertarCompra(req.body)
    .then((response) => {
      console.log("Cantidad de filas insertadas: " + response)
      if (response >= 1) {
        updateStock = true
        // res.status(201).send({ message: 'Entrada registrada correctamente' })
      } else {
        res.status(500).send({ error: 'Error al insertar los datos' })
      }
    })
    .catch((err) => {
      res.status(500).send({ error: 'Error interno del servidor al obtener resultados' })
    })

  if (updateStock) {
    await model.actualizarStock(req.body)
      .then((result) => {
        let info = result.info.split(" ")
        if (result.rowsAffected > 0 || info[2] >= 1) {
          updatePrice = true
          // res.json({ message: 'Stock actualizado correctamente' })
        } else {
          res.status(404).send({ error: 'No se encontró ningún registro para actualizar' })
        }
      })
      .catch((err) => {
        // console.log(error)
        res.status(500).send({ error: 'Error interno del servidor al obtener resultados' })
      })
  } 

  if (updatePrice) {
    await model.actualizarPrecio(req.body)
      .then((response) => {
        console.log("Cantidad de filas insertadas: " + response)
        if (response >= 0) {
          res.status(201).send({ message: 'Entrada registrada correctamente' })
        } else {
          res.status(500).send({ error: 'Error al insertar los datos' })
        }
      })
      .catch((err) => {
        res.status(500).send({ error: 'Error interno del servidor al obtener resultados' })
      })
  }
}



controllers.borrarEntrada = async (req, res) => {
  model.borrarEntrada(req.body)
    .then((response) => {
      if (response) {
        res.json({ message: 'Registros borrados correctamente' })
      } else {
        res.status(404).send({ error: 'No se encontraron registros para borrar' })
      }
    })
    .catch((err) => {
      res.status(500).send({ error: 'Ocurrio un error al borrar los registros' })
    })
}



export default controllers