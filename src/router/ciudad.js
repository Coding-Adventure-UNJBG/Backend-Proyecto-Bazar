import { Router } from 'express';
const router = new Router();

import sequelize from '../config/db.js';
import controllers from '../controllers/ciudad.js';

router.route("/ciudad") // route es la abrevitura de get, post, delete  y put
.get(controllers.mostrarTodo);
/*
.post("algo")
.put("algo")
.delete("algo");

simplemente hace que las coas sean mas fáciles de leer
*/

export default router;
