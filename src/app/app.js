const express = require("express");
const morgan = require("morgan");

const router = require("../router/ciudad")

const app = express();

app.use(morgan("dev")); // para analizar las solicitudes HTTP y verlas en la consola

app.get("/", (req, res) => {
    res.send("Primera Api para la universidad");
});

app.use("/api/v1", router); //v1 = version #1

module.exports = app;