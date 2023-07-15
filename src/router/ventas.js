import { Router } from "express";
const router = new Router()
import controllers from "../controllers/ventas.js";

router.route("/")
.get( controllers.mostrar )

export default router