import ciudad from './ciudad.js';
import pruebas from './pruebas.js';

const app = Express();

// importanto rutas
app.use("/api/v1", ciudad);
app.use("/api/v1", pruebas);

export default app;
