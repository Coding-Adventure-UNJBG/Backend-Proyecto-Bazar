
import express from 'express';
import cors from 'cors';
import ciudad from './ciudad.js';
import pruebas from './pruebas.js';
// rutas del proyecto
import producto from './producto.js';
import usuario from './usuario.js';
import proveedor from './proveedor.js';
import entrada from './entrada.js'
import venta from './ventas.js'

const app = express();

app.use(cors())

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
app.use("/api/v1/producto", producto);
app.use("/api/v1/usuario", usuario);
app.use("/api/v1/proveedor", proveedor);
app.use("/api/v1/entrada", entrada);
app.use("/api/v1/venta", venta)

// respuesta por defecto para todas las rutas no especificadas
app.use("*", (req, res) => {
    res.status(404).send({message: "recurso no encontrado!!!"});
})

export default app;
