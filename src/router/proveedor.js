import { Router } from "express"
const router = new Router()

import controllers from '../controllers/proveedor.js'

router.get("/obtener/id", controllers.obtenerId)
router.get("/comprobar", controllers.comprobarRUC)

router.route("/:id")
.get( controllers.buscarID )

router.route("/")
.get( controllers.mostrar )
.post( controllers.insertar )
.patch( controllers.actualizar );


export default router