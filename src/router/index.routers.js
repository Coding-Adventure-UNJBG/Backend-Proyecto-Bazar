
import express from 'express';
import ciudad from './ciudad.js';
import pruebas from './pruebas.js';

const app = express();

// middleware inicial
app.use("/", (req, res, next) => {
    console.log(`Test middleware: method=${req.method} - url=${req.originalUrl}`);
    next();
});

// ruta raiz
app.get("/", (req, res) => {
    res.send("Primera Api para la universidad");
});

// importanto rutas
app.use("/api/v1/ciudad", ciudad);
app.use("/api/v1/pruebas", pruebas);

// respuesta por defecto para todas las rutas no especificadas
app.use("*", (req, res) => {
    res.status(404).send({message: "recurso no encontrado!!!"});
})

export default app;
