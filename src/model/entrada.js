const model = {}
import sequelize from "../config/db.js"

model.obtenerId = () => {
    return sequelize.query(`SELECT COUNT(id_compra) AS 'id' FROM compra`, { raw: true })
    .then(([result, metadata]) => {
        // console.log(metadata)
        return result
    })
    .catch((errror) => { throw errror})
}

export default model