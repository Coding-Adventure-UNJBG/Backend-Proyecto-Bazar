const model = {}
import sequelize from '../config/db.js'

model.mostrarTodo = () => {
  const query = `SELECT * FROM venta ORDER BY id_venta DESC`
  return sequelize.query(query, { raw: true })
    .then(([result, metadata]) => {
      // console.log(metadata)
      return result
    })
    .catch((errror) => { throw errror })
}

export default model