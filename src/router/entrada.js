import { Router } from "express";
const router = new Router()

import controllers from "../controllers/entrada.js";

router.route("/")
.get( controllers.reporte )
.post( controllers.insertar )

export default router

