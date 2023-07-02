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

export default controllers