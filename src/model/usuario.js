const model= {};
import sequelize from '../config/db.js';

model.mostrarTodo = () => {
    const query = `SELECT u.id_usuario, u.cuenta, r.tipo, u.estado, DATE_FORMAT(u.fecha_registro, "%Y-%m-%d") AS 'fecha_registro', u.comentario
                    FROM usuario u INNER JOIN detalle_rol dr INNER JOIN rol r
                    ON u.id_usuario = dr.id_usuario AND dr.id_rol=r.id_rol`
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
                    where u.cuenta LIKE '%${name}%'`
    return sequelize.query(query, { raw: true })
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

model.obtenerId = () => {
    const query = `SELECT MAX(id_usuario) AS 'id' FROM usuario`;
    return sequelize.query(query , { raw: true })
        .then(([result, metadata]) => {
            //console.log(metadata);
            return result;
        })
        .catch((error) => { throw error });
};

model.obtenerPermisos = async (data) => {
    const { rol } = data;
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

/*
model.insertar = async (data) => {
    const { id_usuario, cuenta, password, rol, dni, nombres, telefono, direccion, estado, comentario } = data;

    const queryObtIdUser = `SELECT MAX(id_usuario) AS 'id' FROM usuario`;
    const obtenerIdUser = await sequelize.query(queryObtIdUser, { raw: true })
    console.log(obtenerIdUser[0][0].id)
    const data1 = obtenerIdUser[0][0].id;

    const insertUser = `INSERT INTO usuario(id_usuario, cuenta,password,dni,nombres,telefono,direccion,estado,comentario)
                    VALUES ('${obtenerIdUser}', '${cuenta}', '${password}', '${dni}', '${nombres}', '${telefono}', '${direccion}', '${estado}', '${comentario}')`;
    sequelize.query(insertUser, { raw: true })

    const querySelctRol = `SELECT permiso_defecto FROM rol WHERE id_rol = '${rol}'`
    const selctRol = await sequelize.query(querySelctRol, { raw: true })
    console.log(selctRol[0][0].permiso_defecto)
    const data2 = selctRol[0][0].permiso_defecto

    const queryInsertDetall = `INSERT INTO detalle_rol(id_usuario,id_rol,permiso)
                                VALUES ('${data1}', '${rol}', '${data2}')`
    const insertDetall = await sequelize.query(queryInsertDetall, { raw: true })




    const selctRol = ''
    const querySelctRol = `SELECT permiso_defecto FROM rol WHERE id_rol = '${rol}'`
    await sequelize.query(querySelctRol, { raw: true })
        .then(([result, metadata]) => {
            console.log(result[0][0].permiso_defecto)
            selctRol = result[0][0].permiso_defecto;
        })
        .catch((error) => { throw error });

    const boolInsertUser = ''
    const queryInsertUser = `INSERT INTO usuario(id_usuario, cuenta,password,dni,nombres,telefono,direccion,estado,comentario)
                    VALUES ('${id_usuario}', '${cuenta}', '${password}', '${dni}', '${nombres}', '${telefono}', '${direccion}', '${estado}', '${comentario}')`;
    await sequelize.query(queryInsertUser, { raw: true })
        .then(([result, metadata]) => {
            boolInsertUser = result;
        })
        .catch((error) => { throw error });

    if(boolInsertUser){
        const query = `INSERT INTO detalle_rol(id_usuario,id_rol,permiso)
                        VALUES ('${id_usuario}', '${rol}', '${selctRol}');`
        return sequelize.query(query, { raw: true })
            .then(([result, metadata]) => {
                return metadata;
            })
            .catch((error) => { throw error });
    }
};
*/

export default model;