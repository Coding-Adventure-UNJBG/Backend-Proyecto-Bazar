import dotenv from 'dotenv';
import express from 'express';
import morgan from 'morgan';

dotenv.config();

const app = express();
app.use(morgan("dev")); // para analizar las solicitudes HTTP y verlas en la consola


// rutas de la API
import misrouters from "./src/router/index.routers.js";
app.use( misrouters );

//console.log(process.env); // prueba de variables de entorno
app.set('port', process.env.PORT || 3001);

app.listen(app.get('port'), () => {
    console.log(`---------- Servidor corriendo en el puerto: `, app.get('port'));
});
