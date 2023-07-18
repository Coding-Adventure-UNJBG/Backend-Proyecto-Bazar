const model = {};
import sequelize from '../config/db.js';

model.mostrarTodo = () => {
  const query = `SELECT p.id_producto, p.nombre, p.marca, p.unidad, p.estado, p.stock, ROUND(pp.precio_venta, 2) AS precio_venta, p.foto, p.fecha, p.comentario 
                  FROM producto AS p
                  LEFT JOIN precio_producto AS pp ON p.id_producto = pp.id_producto
                  WHERE pp.precio_venta = (
                    SELECT precio_venta FROM precio_producto 
                      WHERE id_producto = p.id_producto 
                      ORDER BY fechaInicio DESC LIMIT 1
                  ) OR pp.precio_venta IS NULL
                  ORDER BY p.id_producto DESC`
  // return sequelize.query('SELECT * FROM producto ORDER BY id_producto DESC', { raw: true })
  return sequelize.query(query, { raw: true })
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