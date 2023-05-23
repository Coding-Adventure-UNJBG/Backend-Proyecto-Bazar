import dotenv from 'dotenv';
import express from 'express';
import morgan from 'morgan';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

dotenv.config();

const app = express();
app.use(morgan("dev")); // para analizar las solicitudes HTTP y verlas en la consola
app.use(express.json()); // para poder usar red.body


// Ruta para servir las imágenes
const currentDir = dirname(fileURLToPath(import.meta.url));
app.use('/photos', express.static(join(currentDir, 'photos')));

// rutas de la API
import misrouters from "./src/router/index.routers.js";
app.use( misrouters );

//console.log(process.env); // prueba de variables de entorno
app.set('port', process.env.PORT || 3001);

app.listen(app.get('port'), () => {
    console.log(`---------- Servidor corriendo en el puerto: `, app.get('port'));
});
