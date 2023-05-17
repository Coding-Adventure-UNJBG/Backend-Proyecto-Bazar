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

export default model;