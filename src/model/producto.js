const model = {};
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
  return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
      //console.log(metadata);
      return result;
    })
    .catch((error) => { throw error });
};

model.obtenerId = () => {
  return sequelize.query(`SELECT MAX(id_producto) AS 'id' FROM producto`, { raw: true })
    .then(([result, metadata]) => {
      // console.log(metadata)
      return result
    })
    .catch((errror) => { throw errror })
}

model.buscarNombre = (name) => {
  const query = `SELECT * FROM producto where nombre LIKE '%${name}%' ORDER BY id_producto DESC`;
  return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
      //console.log(metadata);
      return result;
    })
    .catch((error) => { throw error });
};

model.insertar = (data) => {
  const { nombre, marca, unidad, foto, comentario } = data
  const query = `INSERT INTO producto(nombre, marca, unidad, foto, comentario)
                  VALUES ('${nombre}', '${marca}', '${unidad}', '${foto}', '${comentario}')`
  return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
      //console.log(result + " -> result");
      //console.log(metadata + " -> result");
      return metadata;
    })
    .catch((error) => { throw error });
};

model.update = (id, data) => {
  const { nombre, marca, unidad, foto, comentario } = data
  // const { nombre, medida, marca, tipo_unidad, cantidad_unidad, foto } = data;
  const query = `UPDATE producto SET
                    nombre = "${nombre}",
                    marca = "${marca}",
                    unidad = "${unidad}",
                    foto = "${foto}",
                    comentario = '${comentario}'
                    WHERE id_producto = ${id}`;
  return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
      //console.log(metadata);
      return result;
    })
    .catch((error) => { throw error });
};

export default model;