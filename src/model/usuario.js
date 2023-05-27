const model= {};
import sequelize from '../config/db.js';

model.mostrarTodo = () => {
    const query = `SELECT u.id_usuario, u.cuenta, r.tipo, u.estado, DATE_FORMAT(u.fecha_registro, "%Y-%m-%d") AS 'fecha_registro', u.comentario
                    FROM usuario u INNER JOIN detalle_rol dr INNER JOIN rol r
                    ON u.id_usuario = dr.id_usuario AND dr.id_rol=r.id_rol
                    GROUP BY u.id_usuario DESC`
    return sequelize.query(query, { raw: true })
        .then(([result, metadata]) => {
            //console.log(metadata);
            return result;
        })
        .catch((error) => { throw error });
};

model.buscarNombre = (name) => {
    const query = `SELECT u.id_usuario, u.cuenta, r.tipo, u.estado, DATE_FORMAT(u.fecha_registro, "%Y-%m-%d") AS 'fecha_registro', u.comentario
                    FROM usuario u INNER JOIN detalle_rol dr INNER JOIN rol r
                    ON u.id_usuario = dr.id_usuario AND dr.id_rol=r.id_rol
                    where u.cuenta LIKE '%${name}%' GROUP BY u.id_usuario DESC`
    return sequelize.query(query, { raw: true })
        .then(([result, metadata]) => {
            //console.log(metadata);
            return result;
        })
        .catch((error) => { throw error });
};

model.buscarId = (id) => {
    const query = `SELECT u.id_usuario, u.cuenta, u.password, dr.id_rol, u.dni, u.nombres, u.telefono, u.direccion, u.estado
                    FROM usuario u INNER JOIN detalle_rol dr INNER JOIN rol r
                    ON u.id_usuario = dr.id_usuario AND dr.id_rol=r.id_rol
                    where u.id_usuario ='${id}'`;
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

model.obtenerId = () => {
    const query = `SELECT MAX(id_usuario) AS 'id' FROM usuario`;
    return sequelize.query(query , { raw: true })
        .then(([result, metadata]) => {
            //console.log(metadata);
            return result;
        })
        .catch((error) => { throw error });
};

model.obtenerPermisos = async (rol) => {
    const query = `SELECT permiso_defecto FROM rol WHERE id_rol = '${rol}'`
    return sequelize.query(query, { raw: true })
        .then(([result, metadata]) => {
            //console.log(result)
            return result
        })
        .catch((error) => { throw error });
}

model.insertarUsuario = (data) => {
    const { id_usuario, cuenta, password, dni, nombres, telefono, direccion, estado, comentario } = data;
    const query = `INSERT INTO usuario(id_usuario, cuenta,password,dni,nombres,telefono,direccion,estado,comentario)
                    VALUES ('${id_usuario}', '${cuenta}', '${password}', '${dni}', '${nombres}', '${telefono}', '${direccion}', '${estado}', '${comentario}')`;
    return sequelize.query(query, { raw: true })
        .then(([result, metadata]) => {
            //console.log(metadata + "test")
            return metadata;
        })
        .catch((error) => { throw error });
};

model.insertarDetalleUsuario = (data, selctRol) => {
    const { id_usuario, rol} = data;
    const query = `INSERT INTO detalle_rol(id_usuario,id_rol,permiso)
                            VALUES ('${id_usuario}', '${rol}', '${selctRol}');`
    return sequelize.query(query, { raw: true })
        .then(([result, metadata]) => {
            return metadata;
        })
        .catch((error) => { throw error });
};

model.comprobarCuentaDni = (data) => {
    const {cuenta, dni} = data
    const query = `SELECT * FROM usuario where cuenta ='${cuenta}' OR dni ='${dni}'`;
    return sequelize.query(query , { raw: true })
        .then(([result, metadata]) => {
            //console.log(metadata);
            //console.log(result);
            return result;
        })
        .catch((error) => { throw error });
};

model.deshabilitar = (id, data) => {
    const { estado } = data;
    const query = `UPDATE usuario SET estado = '${data}' WHERE id_usuario = ${id}`;
    return sequelize.query(query, { raw: true })
        .then(([result, metadata]) => {
            //console.log(metadata);
            return result;
        })
        .catch((error) => { throw error });
};

model.actualizarPermisos = (idUser, idPermisos, permisos) => {
    const query = `UPDATE detalle_rol SET
                    permiso = '${permisos}',
                    id_rol = ${idPermisos}
                    WHERE id_usuario = ${idUser}`;
    return sequelize.query(query, { raw: true })
        .then(([result, metadata]) => {
            //console.log(metadata);
            return result;
        })
        .catch((error) => { throw error });
};

model.actualizar = (data) => {
    const { id_usuario, password, dni, nombres, telefono, direccion, estado } = data;
    const query = `UPDATE usuario SET
                    password = "${password}",
                    dni = "${dni}",
                    nombres = "${nombres}",
                    telefono = "${telefono}",
                    direccion = "${direccion}",
                    estado = "${estado}"
                    WHERE id_usuario = ${id_usuario}`;
    return sequelize.query(query, { raw: true })
        .then(([result, metadata]) => {
            //console.log(metadata);
            return result;
        })
        .catch((error) => { throw error });
};

export default model;