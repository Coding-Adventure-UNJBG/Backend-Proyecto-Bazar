const model = {};
import sequelize from "../config/db.js";

model.mostrarTodo = () => {
    // const query = ''
    return sequelize.query(`SELECT id_proveedor, nombre, ruc, razon_social, direccion, estado, DATE_FORMAT(fecha_registro, '%Y-%m-%d') AS fecha_registro, comentario FROM proveedor ORDER BY id_proveedor DESC`, { raw:true} )
    .then(([result, metadata]) => {
        console.log(metadata)
        return result
    })
    .catch((errror) => { throw errror})
}

model.buscarNombre = (name) => {
    const query = `SELECT id_proveedor, nombre, ruc, razon_social, direccion, estado, DATE_FORMAT(fecha_registro, '%Y-%m-%d') AS fecha_registro, comentario FROM proveedor WHERE nombre LIKE '%${name}%' OR ruc LIKE '%${name}%' ORDER BY id_proveedor DESC`
    return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
        console.log(metadata)
        return result
    })
    .catch((errror) => { throw errror})
}

model.buscarId = (id) => {
    const query = `SELECT * FROM proveedor WHERE id_producto = '${id}'`
    return sequelize.query(query, { raw:true } )
    .then(([result, metadata]) => {
        console.log(metadata)
        return result
    })
    .catch((errror) => { throw errror})
}

// model.insertar = (data) => {
//     const { nombre, ruc, razon_social, direccion, estado, comentario } = data
//     const query = `INSERT INTO `
// }

export default model