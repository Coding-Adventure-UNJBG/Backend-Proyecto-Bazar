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
  const { id_proveedor, id_producto, descripcion, cantidad, precio_compra, importe_total, costo_operacion } = data
  const query = `INSERT INTO compra(id_proveedor, id_producto, descripcion, cantidad, precio_compra, importe_total, costo_operacion)
                VALUES ('${id_proveedor}', '${id_producto}', '${descripcion}', '${cantidad}', '${precio_compra}', '${cantidad}'*'${precio_compra}', '${costo_operacion}')`
  return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
      // console.log(metadata)
      return result
    })
    .catch((errror) => { throw errror })
}

model.actualizarStock = (data) => {
  const { id_producto, cantidad } = data
  // const query = `UPDATE producto SET stock = stock + '${cantidad}' WHERE id_producto = '${id_producto}'`
  const query = `UPDATE producto SET 
                  stock = stock + '${cantidad}', 
                  estado = IF(stock = 0, 'AGOTADO', 'DISPONIBLE') 
                  WHERE id_producto = '${id_producto}'`
  return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
      // console.log(metadata)
      return result
    })
    .catch((errror) => { throw errror })
}

model.actualizarPrecio = (data) => {
  // Utilidad 30% + precio_compra + costo operacin (flete)
  // Utilidad 30% = (precio compra + costo operacion) * 30 %
  const { id_producto, precio_compra, costo_operacion } = data
  const costoOperacionDecimal = parseFloat(costo_operacion || 0);
  const pv = precio_compra + costoOperacionDecimal + ((precio_compra + costoOperacionDecimal) * 0.30)
  const query = `INSERT INTO precio_producto (id_producto, precio_venta)
                SELECT '${id_producto}', '${pv}'
                WHERE NOT EXISTS (SELECT * FROM precio_producto WHERE id_producto = '${id_producto}')
                OR '${pv}' != (SELECT precio_venta FROM precio_producto WHERE id_producto = '${id_producto}' ORDER BY fechaInicio DESC LIMIT 1)`
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

model.reporte = (data) => {
  const { fechaInicio, fechaFin } = data
  const query = `SELECT pd.nombre AS producto, pd.marca, pd.unidad, pv.nombre AS proveedor, c.cantidad, 
                ROUND(c.precio_compra, 2) AS "precio compra", ROUND(c.costo_operacion, 2) AS "flete + comision banco",
                ROUND(c.importe_total, 2) AS "total factura", ROUND( ((c.precio_compra + c.costo_operacion) * 0.30), 2) AS "utilidad 30%", 
                ROUND( (c.precio_compra + c.costo_operacion + ((c.precio_compra + c.costo_operacion) * 0.30)), 2) AS "precio venta", 
                DATE_FORMAT(c.fecha, '%Y-%m-%d') AS fecha FROM compra c
                INNER JOIN producto pd
                ON c.id_producto = pd.id_producto
                INNER JOIN proveedor pv
                ON c.id_proveedor = pv.id_proveedor
                WHERE DATE_FORMAT(c.fecha, '%Y-%m-%d') BETWEEN '${fechaInicio}' AND '${fechaFin}'`
  return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
      // console.log(metadata)
      return result
    })
    .catch((errror) => { throw errror })
}

export default model