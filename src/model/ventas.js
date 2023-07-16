const model = {}
import sequelize from '../config/db.js'

model.mostrarTodo = () => {
  // const query = `SELECT * FROM venta ORDER BY id_venta DESC`
  const query = `SELECT v.id_venta, v.serie, v.correlativo, v.tipo_pago, ROUND(v.total_dinero, 2) AS total_dinero,  DATE_FORMAT(v.fecha, "%d-%m-%Y") AS fecha, COUNT(dv.id_venta) as items FROM venta AS v
                INNER JOIN detalle_venta AS dv
                ON v.id_venta = dv.id_venta
                GROUP BY v.id_venta
                ORDER BY v.id_venta DESC`
  return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
      // console.log(metadata)
      return result
    })
    .catch((errror) => { throw errror })
}

model.obtenerId = () => {
  const query = `SELECT MAX(id_venta) AS id FROM venta`
  return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
      // console.log(metadata)
      return result
    })
    .catch((errror) => { throw errror })
}

model.insertarVenta = (data) => {
  const { serie, correlativo, tipo_pago, total_dinero, comentario } = data
  const query = `INSERT INTO venta(serie, correlativo, tipo_pago, total_dinero, comentario)
                  VALUES ('${serie}', '${correlativo}', '${tipo_pago}', '${total_dinero}', '${comentario}')`
  return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
      // console.log(metadata)
      return result
    })
    .catch((errror) => { throw errror })
}

model.insertarDetalle = (id_venta, data) => {
  const { id_producto, cantidad, precio_venta } = data
  const query = `INSERT INTO detalle_venta(id_venta, id_producto, cantidad, costo_unitario)
                VALUES ('${id_venta}', '${id_producto}', '${cantidad}', '${precio_venta}')`
  return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
      // console.log(metadata)
      console.log(result)
      return result
    })
    .catch((errror) => { throw errror })
}

model.actualizarStock = (data) => {
  const { id_producto, cantidad } = data
  const query = `UPDATE producto SET stock = stock - '${cantidad}'
                WHERE id_producto = '${id_producto}'`
  return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
      // console.log(metadata)
      return result
    })
    .catch((errror) => { throw errror })
}

model.obtenerCorrelativo = () => {
  const query = `SELECT MAX(correlativo) AS correlativo FROM venta`
  return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
      // console.log(metadata)
      return result
    })
    .catch((errror) => { throw errror })
}
export default model