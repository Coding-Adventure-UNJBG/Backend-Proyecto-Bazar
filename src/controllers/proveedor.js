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
                // console.log(error)
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
                // console.log(error)
                res.status(500).send({ error: 'Error interno del servidor al obtener resultados' })
            })
    }
}

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
    model.insertarProveedor(req.body)
        .then((response) => {
            console.log("Cantidad de filas insertadas: " + response)
            if (response >= 1) {
                res.status(201).send({ message: 'Proveedor registrado correctamente' })
            } else {
                res.status(500).send({ error: 'Error al insertar los datos' })
            }
        })
        .catch((err) => {
            res.status(500).send({ error: 'Error interno del servidor al obtener resultados' })
        })
}

controllers.comprobarRUC = async (req, res) => {
    model.comprobarRUC(req.query)
        .then((data) => {
            if (data.length >= 1) {
                res.status(200).send({ error: 'El RUC ya se encuentra registrado' })
            } else {
                res.status(200).send({ message: 'Datos del proveedor no registrado' })
            }
        })
        .catch((error) => {
            res.status(500).send({ error: 'Error interno del servidor al obtener resultados' })
        })
}

controllers.buscarID = async (req, res) => {
    let id = req.params.id
    model.buscarID(id)
        .then((data) => {
            if (data.length == 0) {
                res.status(400).send({ error: 'No se encontraron resultados' })
            } else {
                res.json(data)
            }
        })
        .catch((error) => {
            res.status(500).send({ error: 'Error interno del servidor al obtener resultados' })
        })
}

controllers.actualizar = async (req, res) => {
    let data = req.body
    model.update(data)
        .then((result) => {
            let info = result.info.split(" ")
            // console.log(info)
            if (result.rowsAffected > 0 || info[2] >= 1) {
                res.json({ message: 'Proveedor actualizado correctamente' })
            } else {
                res.status(404).send({ error: 'No se encontró ningún registro para actualizar' })
            }
        })
        .catch((err) => {
            console.log(error)
            res.status(500).send({ error: 'Error interno del servidor al obtener resultados' })
        })
}

export default controllers