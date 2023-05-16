import { Router } from 'express';
const router = new Router();

import controllers from '../controllers/ciudad.js';

router.route('/:codigo')
.get( controllers.buscarId )
.patch( controllers.update );

router.route("/") // route es la abrevitura de get, post, delete  y put
.get( controllers.mostrarTodo )
.post( controllers.insertar )
.patch( controllers.updateQuery );
/*
.post("algo")
.put("algo")
.delete("algo");

simplemente hace que las coas sean mas fáciles de leer
*/

export default router;
