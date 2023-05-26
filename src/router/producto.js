import { Router } from 'express';
const router = new Router();

import controllers from '../controllers/producto.js';
import { upload } from '../config/multer.js';

router.route("/:id")
.get( controllers.buscarId )
.patch( controllers.update );

router.route("/")
.get( controllers.mostrar )
.post( controllers.insertar );

router.route("/imagen")
.post( upload.single('imagen'), controllers.cargarImagen );

export default router;
