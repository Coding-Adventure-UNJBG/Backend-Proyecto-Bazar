const express = require("express");

const app = express();


app.get("/", (req, res) => {
    res.send("Primera Api para la universidad");
});

module.exports = app;