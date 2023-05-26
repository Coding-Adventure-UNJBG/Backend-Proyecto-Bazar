const model= {};
import sequelize from '../config/db.js';

model.mostrarTodo = () => {
    return sequelize.query('SELECT * FROM producto ORDER BY id_producto DESC', { raw: true })
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
    const query = `SELECT * FROM producto where nombre LIKE '%${name}%' ORDER BY id_producto DESC`;
    return sequelize.query(query , { raw: true })
        .then(([result, metadata]) => {
            //console.log(metadata);
            return result;
        })
        .catch((error) => { throw error });
};

model.insertar = (data) => {
    const { nombre, medida, marca, tipo_unidad, cantidad_unidad, foto } = data;

    const query = `INSERT INTO producto(nombre,medida,marca,tipo_unidad,cantidad_unidad,foto)
                    VALUES ('${nombre}', '${medida}', '${marca}', '${tipo_unidad}', '${cantidad_unidad}', '${foto}')`;
    return sequelize.query(query, { raw: true })
        .then(([result, metadata]) => {
            //console.log(result + " -> result");
            //console.log(metadata + " -> result");
            return metadata;
        })
        .catch((error) => { throw error });
};

model.update = (id, data) => {
    const { nombre, medida, marca, tipo_unidad, cantidad_unidad, foto } = data;
    const query = `UPDATE producto SET
                    nombre = "${nombre}",
                    medida = "${medida}",
                    marca = "${marca}",
                    tipo_unidad = "${tipo_unidad}",
                    cantidad_unidad = "${cantidad_unidad}",
                    foto = "${foto}"
                    WHERE id_producto = ${id}`;
    return sequelize.query(query, { raw: true })
        .then(([result, metadata]) => {
            //console.log(metadata);
            return result;
        })
        .catch((error) => { throw error });
};

export default model;