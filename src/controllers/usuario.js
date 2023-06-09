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

controllers.obtenerId = async (req, res) => {
    model.obtenerId()
    .then((data) => {
        if(data.length == 0){
            res.status(404).send({error: 'No se encontraron resultados'});
        } else {
            res.json(data)
        }
    })
    .catch((error) => {
        //console.error(error);
        res.status(500).send({error:'Error interno del servidor al obtener los datos'});
    });
}

controllers.insertar = async (req, res) => {
    //console.log(req.body)
    let permisos = ''
    await model.obtenerPermisos(req.body.rol)
    .then((data) => {
        if(data.length == 0){
            res.status(404).send({error: 'No se encontraron resultados del permiso indicado'});
        } else {
            permisos = data[0].permiso_defecto;
            //console.log("Permisos:" + permisos)
        }
    })
    .catch((error) => {
        //console.error(error);
        res.status(500).send({error:'Error interno del servidor al obtener los datos'});
    });

    let boolInsertUser = false;
    await model.insertarUsuario(req.body)
    .then((response) => {
        //console.log("Cantidad de filas insertadas: " + response);
        if (response >= 1) {
            //console.log(response + "test")
            boolInsertUser = true;
            //console.log("boolInsertUser: " + boolInsertUser)
        } else {
            res.status(500).send({ error: 'Error al insertar los datos' });
        }
    })
    .catch((err) => {
        res.status(500).send({ error: 'Error interno del servidor' });
    });

    if(boolInsertUser){
        await model.insertarDetalleUsuario(req.body, permisos)
        .then((response) => {
            //console.log("Cantidad de filas insertadas: " + response);
            if (response >= 1) {
                //console.log("Detalle de usuario ingresado correctamente")
                res.status(200).send({ message: 'Detalle de usuario ingresado correctamente' });
            } else {
                res.status(500).send({ error: 'Error al insertar los datos' });
            }
        })
        .catch((err) => {
            res.status(500).send({ error: 'Error interno del servidor' });
        });
    }
};

controllers.comprobarCuentaDni = async (req, res) => {
    //console.log(req.query)
    model.comprobarCuentaDni(req.query)
    .then((data) => {
        //console.log(data.length)
        if(data.length >= 1){
            res.status(200).send({ error: 'El DNI o el nombre de usuario ya fue registrado'});
        } else {
            res.status(200).send({ message: 'Datos de usuario no registrado' });
        }
    })
    .catch((error) => {
        //console.error(error);
        res.status(500).send({error:'Error interno del servidor al obtener los datos'});
    });
}

controllers.deshabilitar = async (req, res) => {
    //console.log(req.params);
    //console.log(req.body);
    let id = req.params.codigo;
    let data = req.body.estado;
    model.deshabilitar(id, data)
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

controllers.actualizar = async (req, res) => {
    //console.log(req.body);
    let permisos = ''
    await model.obtenerPermisos(req.body.id_rol)
    .then((data) => {
        if(data.length == 0){
            res.status(404).send({error: 'No se encontraron resultados del permiso indicado'});
        } else {
            permisos = data[0].permiso_defecto;
            console.log("Permisos: " + permisos)
        }
    })
    .catch((error) => {
        //console.error(error);
        res.status(500).send({error:'Error interno del servidor al obtener los datos'});
    });

    let boolUpdateUser = false;
    await model.actualizarPermisos(req.body.id_usuario, req.body.id_rol, permisos)
    .then((result) => {
        //console.log(result);
        let info = result.info.split(" "); // convertir respuesta a array
        console.log(info);
        if (result.rowsAffected > 0 || info[2] >= 1) {
            //res.json({ message: 'Registro actualizado correctamente' });
            boolUpdateUser = true
        } else {
            res.status(404).send({ error: 'No se encontró ningún registro para actualizar' });
        }
    })
    .catch((error) => {
        //console.error(error);
        res.status(500).send({error:'Error interno del servidor al obtener los datos'});
    });

    if(boolUpdateUser){
        model.actualizar(req.body)
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
    }
};

export default controllers;
