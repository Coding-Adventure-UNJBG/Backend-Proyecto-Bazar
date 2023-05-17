import { Router } from 'express';
const router = new Router();

import controllers from '../controllers/producto.js';

router.route("/")
.get( controllers.mostrarTodo );

export default router;
