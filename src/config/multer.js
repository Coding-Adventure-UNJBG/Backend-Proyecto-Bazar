import express from 'express';
import multer from 'multer';
import fs from 'fs'; // file System -> nativa en NODE

// está libreria se usara para cargar imagenes
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'photos');
    },
    filename: (req, file, cb) => {
        //console.log(req.query)
        const { unixTimestamp } = req.query
        //console.log(file)
        const ext = file.originalname.split('.').pop() // captura la extension del archivo
        //cb(null, `producto-${unixTimestamp}.${ext}`);
        if (unixTimestamp) {
            cb(null, `producto-${unixTimestamp}.${ext}`);
        } else
            cb(null, 'toDelete');
    }
});

const upload = multer({ storage });

export { upload };

export async function cleanTemporaryFile () {
    fs.unlink('photos/toDelete', () => {});
}

// borrar imagen especifica
export async function deleteFile(nameImage) {
    //nameImage = nameImage.substring(39)
    nameImage = `photos/${nameImage}`
    fs.unlink(nameImage, (error) => {
        if (error){
            console.log("error al borrar la iamgen: " + error)
        } else {
            console.log("eliminando: " + nameImage)
        }
    });
}
