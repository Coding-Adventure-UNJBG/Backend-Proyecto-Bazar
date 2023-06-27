import { Router } from "express"
const router = new Router()

import controllers from '../controllers/proveedor.js'

router.route("/")
.get( controllers.mostrar );


export default router