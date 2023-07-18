import { Router } from "express";
const router = new Router()

import controllers from "../controllers/entrada.js";

router.get("/reporte", controllers.reporte )

router.route("/")
.post( controllers.insertar )

export default router

