const controllers = {};
import model from '../model/proveedor.js';

controllers.mostrar = async (req, res) => {
    if (req.query.nombre) { //mostrar resultado por nombre o ruc
        let nombre = req.query.nombre
        model.buscarNombre(nombre)
            .then((data) => {
                if (data.length == 0) {
                    res.status(404).send({ error: 'No se encontraron resultados' })
                }
                else {
                    res.json(data)
                }
            })
            .catch((error) => {
                console.log(error)
                res.status(500).send({ error: 'Error interno del servidor al obtener resultados' })
            })
    } else {
        model.mostrarTodo()
            .then((data) => {
                if (data.length == 0) {
                    res.status(404).send({ error: 'No se encontraron resultados' })
                }
                else {
                    res.json(data)
                }
            })
            .catch((error) => {
                console.log(error)
                res.status(500).send({ error: 'Error interno del servidor al obtener resultados' })
            })
    }
}

export default controllers