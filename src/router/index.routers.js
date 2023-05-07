
import express from 'express';
import ciudad from './ciudad.js';
import pruebas from './pruebas.js';

const app = express();

// middleware inicial
app.use("/", (req, res, next) => {
    console.log("test middleware");
    next();
});

// ruta raiz
app.get("/", (req, res) => {
    res.send("Primera Api para la universidad");
});
// importanto rutas
app.use("/api/v1", ciudad);
app.use("/api/v1", pruebas);

export default app;
