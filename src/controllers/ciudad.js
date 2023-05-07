const controllers= {};
import sequelize from '../config/db.js';

controllers.mostrarTodo = async (req, res) => {
    const posts = await sequelize.query('SELECT * FROM country', { raw: true });
    console.log(req.query);
    console.log(req.params);
    res.json(posts);
}

export default controllers;
