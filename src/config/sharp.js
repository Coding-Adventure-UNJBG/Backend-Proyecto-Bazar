import sharp  from "sharp";

// está libreria se usara para redimenzionar las imagenes cargadas
const helperImg = (filePath, fileName, sizeWidth = 700) => { // 700 pixeles de ancho por defecto
    return sharp(filePath)
            .resize(sizeWidth)
            .toFile(`photos/${fileName}`)
}

export default helperImg;