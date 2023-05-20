import { Router } from 'express';
const router = new Router();

import controllers from '../controllers/producto.js';

router.route("/:id")
.get( controllers.buscarId );

router.route("/")
.get( controllers.mostrar );

export default router;
