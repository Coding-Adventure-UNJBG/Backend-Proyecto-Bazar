import { Router } from "express";
const router = new Router()

import controllers from "../controllers/entrada.js";

router.get("/obtener/id", controllers.obtenerId)
router.get("/comprobar", controllers.comprobarComprobante)

// router.get("/detalle", controllers.mostrarDetalles )
router.route("/detalle")
.get( controllers.mostrarDetalles )
.post( controllers.insertarDetalle )
.patch( controllers.obtenerId )

router.route("detalle/id")
.get()
.post()

router.route("/")
.post( controllers.insertar )
.delete( controllers.borrarEntrada )


export default router

