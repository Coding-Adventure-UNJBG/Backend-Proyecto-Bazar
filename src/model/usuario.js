const model= {};
import sequelize from '../config/db.js';

model.mostrarTodo = () => {
    return sequelize.query('SELECT * FROM usuario', { raw: true })
        .then(([result, metadata]) => {
            //console.log(metadata);
            return result;
        })
        .catch((error) => { throw error });
};

model.buscarId = (id) => {
    const query = `SELECT * FROM usuario where id_usuario ='${id}'`;
    return sequelize.query(query , { raw: true })
        .then(([result, metadata]) => {
            //console.log(metadata);
            return result;
        })
        .catch((error) => { throw error });
};

model.ingreso = (name) => {
    const query = `SELECT u.cuenta, u.password, r.tipo, dr.permiso
                    FROM usuario u INNER JOIN detalle_rol dr INNER JOIN rol r
                    ON u.id_usuario = dr.id_usuario AND dr.id_rol=r.id_rol
                    WHERE u.cuenta = '${name}'`;
    return sequelize.query(query , { raw: true })
        .then(([result, metadata]) => {
            //console.log(metadata);
            return result;
        })
        .catch((error) => { throw error });
};

export default model;