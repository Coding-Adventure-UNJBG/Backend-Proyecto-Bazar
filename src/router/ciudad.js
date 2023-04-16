const router = require("express").Router()
const sequelize = require("../config/db");

router.get("/ciudad",  async (req, res) => {
    const posts = await sequelize.query('SELECT * FROM country', { raw: true });
    res.json(posts);
});

module.exports = router;
