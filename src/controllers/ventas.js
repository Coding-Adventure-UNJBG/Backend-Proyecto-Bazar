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

export default controllers