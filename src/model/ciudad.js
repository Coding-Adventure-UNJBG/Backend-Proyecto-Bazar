const model= {};
import sequelize from '../config/db.js';

model.mostrarTodo = () => {
    return new Promise((resolve, reject) => {
        sequelize.query('SELECT * FROM country', { raw: true })
        .then(([result]) => resolve(result))
        .catch((error) => reject(error));
    });
};

model.buscarId = (id) => {
    return new Promise((resolve, reject) => {
        sequelize.query('SELECT * FROM country where country_id = ?', {
            replacements: [id],
            raw: true
        })
        .then(([result]) => resolve(result))
        .catch((error) => reject(error));
    });
};

model.insertar = (data) => {
    return new Promise((resolve, reject) => {
        const { name, coment } = data;
        const query = `INSERT INTO country (country, coment) VALUES ('${name}', '${coment}')`;
        sequelize.query(query, { raw: true })
        .then((result) => { resolve(result) })
        .catch((error) => { reject(error) });
    });
};

model.update = (id, name) => {
    // update ya devuelve una promesa por lo mismo no es necesario crear una
    const query = `UPDATE country SET country = "${name}" WHERE country_id = ${id}`;
    return sequelize.query(query, { raw: true })
    .then(([result]) => result)
    .catch((error) => { throw error });
};

export default model;