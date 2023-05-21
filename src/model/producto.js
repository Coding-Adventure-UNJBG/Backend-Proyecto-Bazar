const model= {};
import sequelize from '../config/db.js';

model.mostrarTodo = () => {
    return sequelize.query('SELECT * FROM producto', { raw: true })
        .then(([result, metadata]) => {
            //console.log(metadata);
            return result;
        })
        .catch((error) => { throw error });
};

model.buscarId = (id) => {
    const query = `SELECT * FROM producto where id_producto ='${id}'`;
    return sequelize.query(query , { raw: true })
        .then(([result, metadata]) => {
            //console.log(metadata);
            return result;
        })
        .catch((error) => { throw error });
};

model.buscarNombre = (name) => {
    const query = `SELECT * FROM producto where nombre LIKE '%${name}%'`;
    return sequelize.query(query , { raw: true })
        .then(([result, metadata]) => {
            //console.log(metadata);
            return result;
        })
        .catch((error) => { throw error });
};

export default model;