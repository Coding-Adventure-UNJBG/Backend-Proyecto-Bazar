const controllers= {};
import model from '../model/ciudad.js';

controllers.mostrarTodo = async (req, res) => {
    console.log(req.query);
    console.log(req.params);
    console.log(req.body);

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
};

// usando 'req.params' para recibir datos
controllers.buscarId = async (req, res) => {
    console.log(req.query);
    console.log(req.params);
    console.log(req.body);

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

// usando 'req.params' y 'req.body' para recibir datos
controllers.update = async (req, res) => {
    console.log(req.query);
    console.log(req.params);
    console.log(req.body);

    let id = req.params.codigo;
    let name = req.body.name;
    model.update(id, name)
    .then((result) => {
        console.log(result);
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

// usando 'req.body' para recibir datos
controllers.insertar = async (req, res) => {
    console.log(req.query);
    console.log(req.params);
    console.log(req.body);

    const { name, coment } = req.body;
    model.insertar({ name, coment })
    .then((response) => {
    console.log(response);
    if (response[1] === 1) {
        res.status(201).send({ message: 'Datos insertados correctamente' });
    } else {
        res.status(500).send({ error: 'Error al insertar los datos' });
    }
    })
    .catch((err) => {
    res.status(500).send({ error: 'Error al insertar los datos' });
    });
};

// usando 'req.query' para recibir datos
controllers.updateQuery = (req, res) => {
    console.log(req.query);
    console.log(req.params);
    console.log(req.body);

    const {id = 0, name = 0} = req.query;
    if(!id)
        res.status(404).send({error: "Falta el campo id"});

    if(!name)
        res.status(404).send({error: "Falta el campo name"});

    model.update(id, name)
    .then((result) => {
        console.log(result);
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

export default controllers;
