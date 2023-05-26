import { Router } from 'express';
const router = new Router();

import controllers from '../controllers/usuario.js';


router.get("/obtener/id", controllers.obtenerId);
router.get("/comprobar", controllers.comprobarCuentaDni);

router.route('/login')
.get( controllers.login );

router.route('/:codigo')
.get( controllers.buscarId )
.patch( controllers.deshabilitar );

router.route("/") // route es la abrevitura de get, post, delete  y put
.get( controllers.mostrar )
.post( controllers.insertar );

export default router;
