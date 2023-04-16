const { Sequelize, QueryTypes } = require("sequelize");

const sequelize = new Sequelize({
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    username: process.env.DB_USER,
    password: process.env.DB_PASS,
    dialect: process.env.DB_DIALECT,
    port: process.env.DB_PORT
});

module.exports = sequelize;