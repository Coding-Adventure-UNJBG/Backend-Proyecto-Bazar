import { Router } from "express";
const router = new Router()

import controllers from "../controllers/entrada.js";

router.get("/obtener/id", controllers.obtenerId)

export default router

