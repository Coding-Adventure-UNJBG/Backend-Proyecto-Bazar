const controllers= {};
import model from '../model/producto.js';

import { cleanTemporaryFile, deleteFile } from '../config/multer.js';
import helperImg from '../config/sharp.js'

controllers.mostrar = async (req, res) => {
    console.log(req.body)
    if(req.body.nombre){ // mostrar resultado por nombre
        let nombre = req.body.nombre;
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
    let id = req.params.codigo;
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
    model.insertar(req.body)
    .then((response) => {
    console.log(response);
    if (response[1] === 1) {
        res.status(201).send({ message: 'Datos insertados correctamente' });
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
        helperImg(req.file.path, `op-${req.file.filename}`, 700)
        res.status(201).send({ message: 'Imagen almacenada' });
        //deleteFile(req.file.filename);
    } else {
        cleanTemporaryFile();
        res.status(500).send({ error: 'Falta la marca de tiempo UNIX' });
    }
};

export default controllers;
