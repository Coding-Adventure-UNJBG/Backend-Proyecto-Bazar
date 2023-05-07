const controllers= {};
import sequelize from '../config/db.js';

controllers.mostrarTodo = async (req, res) => {
    console.log(req.query);
    console.log(req.params);
    //console.log(await sequelize.query('SELECT * FROM payment', { raw: true }));
    await sequelize.query('SELECT * FROM payment', { raw: true })
    .then((response) => {res.json(response)})
    .catch((err) => {res.status(404).send(err)});
}

export default controllers;
