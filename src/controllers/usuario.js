const controllers= {};
import model from '../model/usuario.js';

controllers.login = async (req, res) => {
    console.log(req.query)
    if(req.query.cuenta){ // mostrar resultado por cuenta
        let cuenta = req.query.cuenta;
        model.ingreso(cuenta)
        .then((data) => {
            if(data.length == 0){
                res.status(404).send({error: 'Usuario no encontrado'});
            } else {
                res.json(data)
            }
        })
        .catch((error) => {
            console.error(error);
            res.status(500).send({error:'Error interno del servidor al obtener los datos'});
        });
    } else {
        res.status(500).send({error:'Error: Falta el nombre de la cuenta'});
    }
}

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

export default controllers;
