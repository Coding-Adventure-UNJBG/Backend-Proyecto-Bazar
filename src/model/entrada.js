const model = {}
import sequelize from "../config/db.js"

model.obtenerId = () => {
  return sequelize.query(`SELECT COUNT(id_compra) AS 'id' FROM compra`, { raw: true })
    .then(([result, metadata]) => {
      // console.log(metadata)
      return result
    })
    .catch((errror) => { throw errror })
}

model.insertarCompra = (data) => {
  const { id_compra, id_proveedor, numero_comprobante, descripcion, importe_total, costo_flete, comision_banco, fecha, comentario } = data
  const query = `INSERT INTO compra(id_compra, id_proveedor, numero_comprobante, descripcion, importe_total, costo_flete, comision_banco, fecha, comentario)
                    VALUES ('${id_compra}', '${id_proveedor}', '${numero_comprobante}', '${descripcion}', '${importe_total}', '${costo_flete}', '${comision_banco}', '${fecha}', '${comentario}')`
  return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
      // console.log(metadata)
      return result
    })
    .catch((errror) => { throw errror })
}

model.comprobarComprobante = (data) => {
  const { id_compra, numero_comprobante } = data
  const query = `SELECT * FROM compra WHERE id_compra != '${id_compra}' AND numero_comprobante = '${numero_comprobante}'`
  return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
      // console.log(metadata)
      return result
    })
    .catch((errror) => { throw errror })
}

model.borrarEntrada = (data) => {
  const { id_compra } = data
  const query = `DELETE FROM compra WHERE id_compra = '${id_compra}'`
  return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
      // console.log(metadata)
      return result
    })
    .catch((errror) => { throw errror })
}


//Detalle de compra

model.mostrarDetalle = (id_compra) => {
  const query = `SELECT d.id_compra, d.id_producto, p.nombre, p.marca, d.cantidad, ROUND(d.precio_bruto, 2) AS precio_bruto
                FROM  detalle_compra d INNER JOIN producto p ON d.id_producto = p.id_producto
                WHERE d.id_compra = '${id_compra}'`
  return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
      // console.log(metadata)
      return result
    })
    .catch((errror) => { throw errror })
}


model.insertarDetalleCompra = (data) => {
  const { id_compra, id_producto, cantidad, precio_bruto } = data
  const query = `INSERT INTO detalle_compra(id_compra, id_producto, cantidad, precio_bruto)
                VALUES ('${id_compra}', '${id_producto}', '${cantidad}', '${precio_bruto}')`
  return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
      return metadata;
    })
    .catch((error) => { throw error });
}

model.mostrarProducto = (data) => {
  const { id_compra, id_producto } = data
  const query = `SELECT * FROM detalle_compra WHERE '${id_compra}' AND id_producto = '${id_producto}'`
}

model.borrarProducto = (data) => {
  const { id_compra, id_producto } = data
  const query = `DELETE FROM detalle_compra WHERE id_compra = '${id_compra}' AND id_producto = '${id_producto}'`
  return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
      return metadata;
    })
    .catch((error) => { throw error });
}

model.updateProducto = (data) => {
  const { id_compra, id_producto, cantidad, precio_bruto } = data
  const query = `UPDATE detalle_compra SET 
                cantidad = '${cantidad}', precio_bruto = '${precio_bruto}'
                WHERE id_compra = '${id_compra}' AND id_producto = '${id_producto}'`
  return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
      return metadata;
    })
    .catch((error) => { throw error });
}


export default model