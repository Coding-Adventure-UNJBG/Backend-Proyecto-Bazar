import { Router } from "express";
const router = new Router()
import controllers from "../controllers/ventas.js";

router.get("/correlativo", controllers.obtenerCorrelativo )
router.get("/:id", controllers.buscarID )

router.route("/")
.get( controllers.mostrar )
.post( controllers.insertar )

export default router