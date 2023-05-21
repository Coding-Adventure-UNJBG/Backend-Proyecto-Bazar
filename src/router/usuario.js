import { Router } from 'express';
const router = new Router();

import controllers from '../controllers/usuario.js';

router.route('/login')
.get( controllers.login );

router.route('/:codigo')
.get( controllers.buscarId );

router.route("/") // route es la abrevitura de get, post, delete  y put
.get( controllers.mostrar );

export default router;
