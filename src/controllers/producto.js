const controllers= {};
import model from '../model/producto.js';

controllers.mostrarTodo = async (req, res) => {
    //res.status(200).send({message: 'Mostrando lista de produtos'});
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

export default controllers;
