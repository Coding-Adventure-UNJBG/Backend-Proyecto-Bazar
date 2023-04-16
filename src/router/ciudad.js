const router = require("express").Router()

router.get("/ciudad", (req, res) => {
    res.send("prueba de rutas de ciudad");
})

module.exports = router;
