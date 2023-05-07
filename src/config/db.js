import { Sequelize, QueryTypes } from 'sequelize';
import dotenv from 'dotenv';

dotenv.config();

const sequelize = new Sequelize(process.env.DB_NAME, process.env.DB_USER, process.env.DB_PASS,{
    host: process.env.DB_HOST,
    //database: process.env.DB_NAME,
    //username: process.env.DB_USER,
    //password: process.env.DB_PASS,
    port: process.env.DB_PORT,
    dialect: process.env.DB_DIALECT,
});

sequelize.authenticate().then(() => {
    console.log('Conexion a DB exitosa');
    }).catch((error) => {
    console.error('No se puede conectar a la base de datos: ', error);
});

export default sequelize;