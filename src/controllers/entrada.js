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
    model.insertarCompra(req.body)
    .then((response) => {
        console.log("Cantidad de filas insertadas: " + response)
        if (response >= 1) {
            res.status(201).send({ message: 'Entrada registrada correctamente' })
        } else {
            res.status(500).send({ error: 'Error al insertar los datos' })
        }
    })
    .catch((err) => {
        res.status(500).send({ error: 'Error interno del servidor al obtener resultados' })
    })
}

controllers.comprobarComprobante = async (req, res) => {
    model.comprobarComprobante(req.query)
    .then((data) => {
        if (data.length >= 1) {
            res.status(200).send({ error: 'El comprobante ya se encuentra registrado' })
        } else {
            res.status(200).send({ message: 'Comprobante no registrado' })
        }
    })
    .catch((error) => {
        res.status(500).send({ error: 'Error interno del servidor al obtener resultados' })
    })
}

controllers.mostrarDetalles = async (req, res) => {
  model.mostrarDetalle(req.query.id_compra)
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

controllers.insertarDetalle = async(req, res) => {
  model.insertarDetalleCompra(req.body)
    .then((response) => {
      console.log("Cantidad de filas insertadas: " + response)
      if (response >= 1) {
        res.status(201).send({ message: 'Producto agregado correctamente' })
      } else {
        res.status(500).send({ error: 'Error al agregar el producto' })
      }
    })
    .catch((err) => {
      res.status(500).send({ error: 'Error interno del servidor al obtener resultados' })
    })
}

controllers.borrarEntrada = async(req, res) => {
  model.borrarEntrada(req.body)
  .then((response) => {
    if (response) {
      res.json({ message: 'Registros borrados correctamente'})
    } else{
      res.status(404).send({ error: 'No se encontraron registros para borrar'})
    }
  })
  .catch((err) => {
    res.status(500).send({ error: 'Ocurrio un error al borrar los registros'})
  })
}



export default controllers