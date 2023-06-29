const model = {};
import sequelize from "../config/db.js";

model.mostrarTodo = () => {
    return sequelize.query(`SELECT id_proveedor, nombre, ruc, razon_social, direccion, estado, DATE_FORMAT(fecha_registro, '%Y-%m-%d') AS fecha_registro, comentario FROM proveedor ORDER BY id_proveedor DESC`, { raw:true} )
    .then(([result, metadata]) => {
        // console.log(metadata)
        return result
    })
    .catch((errror) => { throw errror})
}

model.buscarNombre = (name) => {
    const query = `SELECT id_proveedor, nombre, ruc, razon_social, direccion, estado, DATE_FORMAT(fecha_registro, '%Y-%m-%d') AS fecha_registro, comentario FROM proveedor WHERE nombre LIKE '%${name}%' OR ruc LIKE '%${name}%' ORDER BY id_proveedor DESC`
    return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
        // console.log(metadata)
        return result
    })
    .catch((errror) => { throw errror})
}

model.obtenerId = () => {
    return sequelize.query(`SELECT MAX(id_proveedor) AS 'id' FROM proveedor`, { raw: true })
    .then(([result, metadata]) => {
        // console.log(metadata)
        return result
    })
    .catch((errror) => { throw errror})
}

model.insertarProveedor = (data) => {
    const { id_proveedor, nombre, ruc, razon_social, direccion, comentario } = data
    const query = `INSERT INTO proveedor(id_proveedor, nombre, ruc, razon_social, direccion, comentario) 
                    VALUES ('${id_proveedor}', '${nombre}', '${ruc}', '${razon_social}', '${direccion}', '${comentario}')`
    return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
        // console.log(metadata)
        return result
    })
    .catch((errror) => { throw errror})
}

model.comprobarRUC = (data) => {
    const { id_proveedor, ruc } = data
    const query = `SELECT * FROM proveedor WHERE id_proveedor != '${id_proveedor}' AND ruc = '${ruc}'`
    return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
        // console.log(metadata)
        return result
    })
    .catch((errror) => { throw errror})
}

model.buscarID = (id) => {
    const query = `SELECT id_proveedor, nombre, ruc, razon_social, direccion, estado, DATE_FORMAT(fecha_registro, '%Y-%m-%d') AS fecha_registro, comentario FROM proveedor WHERE id_proveedor = '${id}'`
    return sequelize.query(query, { raw:true } )
    .then(([result, metadata]) => {
        // console.log(metadata)
        return result
    })
    .catch((errror) => { throw errror})
}

model.update = (data) => {
    const { id_proveedor, nombre, ruc, razon_social, direccion, comentario } = data
    // console.log(data)
    const query = `UPDATE proveedor 
                    SET nombre = "${nombre}", 
                    ruc = '${ruc}', 
                    razon_social = '${razon_social}', 
                    direccion = '${direccion}', 
                    comentario = '${comentario}' 
                    WHERE id_proveedor = '${id_proveedor}'`
    return sequelize.query(query, { raw:true } )
    .then(([result, metadata]) => {
        // console.log(metadata)
        return result
    })
    .catch((errror) => { throw errror})
}

export default model