const controllers= {};
import model from '../model/producto.js';

import { cleanTemporaryFile, deleteFile } from '../config/multer.js';
import helperImg from '../config/sharp.js'

controllers.mostrar = async (req, res) => {
    if(req.query.nombre){ // mostrar resultado por nombre
        let nombre = req.query.nombre;
        model.buscarNombre(nombre)
        .then((data) => {
            if(data.length == 0){
                res.status(404).send({error: 'No se encontraron resultados'});
            } else {
                res.json(data)
            }
        })
        .catch((error) => {
            console.error(error);
            res.status(500).send({error:'Error interno del servidor al obtener los datos'});
        });
    } else { // mostrar todos los resultados
        model.mostrarTodo()
        .then((data) => {
            if(data.length == 0){
                res.status(404).send({error: 'No se encontraron resultados'});
            } else {
                res.json(data)
            }
        })
        .catch((error) => {
            console.error(error);
            res.status(500).send({error:'Error interno del servidor al obtener los datos'});
        });
    }
};

controllers.buscarId = async (req, res) => {
    let id = req.params.id;
    console.log(req.params)
    model.buscarId(id)
    .then((data) => {
        if(data.length == 0){
            res.status(404).send({error: 'No se encontraron resultados'});
        } else {
            res.json(data)
        }
    })
    .catch((error) => {
        console.error(error);
        res.status(500).send({error:'Error interno del servidor al obtener los datos'});
    });
}

controllers.insertar = async (req, res) => {
    console.log(req.body)
    model.insertar(req.body)
    .then((response) => {
        console.log("Cantidad de filas insertadas: " + response);
        if (response >= 1) {
            res.status(201).send({ message: 'Producto guardado de forma segura' });
        } else {
            res.status(500).send({ error: 'Error al insertar los datos' });
        }
    })
    .catch((err) => {
        res.status(500).send({ error: 'Error interno del servidor' });
    });
};

controllers.cargarImagen = async (req, res) => {
    //console.log(req.file)
    const { unixTimestamp } = req.query
    if( unixTimestamp ) {
        await helperImg(req.file.path, `op-${req.file.filename}`, 700)
        deleteFile(req.file.filename)
        res.status(201).send({ message: 'Imagen almacenada' });
    } else {
        cleanTemporaryFile();
        res.status(500).send({ error: 'Falta la marca de tiempo UNIX' });
    }
};

// usando 'req.params' y 'req.body' para recibir datos
controllers.update = async (req, res) => {
    //console.log(req.params);
    //console.log(req.body);

    let id = req.params.id;
    let data = req.body;
    model.update(id, data)
    .then((result) => {
        //console.log(result);
        let info = result.info.split(" "); // convertir respuesta a array
        console.log(info);
        if (result.rowsAffected > 0 || info[2] >= 1) {
            res.json({ message: 'Registro actualizado correctamente' });
        } else {
            res.status(404).send({ error: 'No se encontró ningún registro para actualizar' });
        }
    })
    .catch((err) => {
        console.error(err);
        res.status(500).send({ error: 'Error al actualizar el registro' });
    });
};

export default controllers;
