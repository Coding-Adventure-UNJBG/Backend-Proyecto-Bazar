import { Router } from 'express';
const router = new Router();

router.get("/", (req, res) => {
    res.send("Nueva ruta el otro archivo");
})

export default router;
