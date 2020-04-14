const express = require("express");
var route = express.Router();
const mediaDB = require("../Models/Media");
const categoryDB = require('../Models/Category')
const response = require("../Utilities/ReponseUtilities");
const fs = require("fs");
const multer = require("multer"); //==> Framework use upload file from client to server
const path = require("path");
const socketEventName = require('../Utilities/SocketEventName')
//get

//storage

const storage = multer.diskStorage({
  destination: "./Public/medias",
  filename: (req, file, cb) => {
    cb(null,file.fieldname + "-" + Date.now() + path.extname(file.originalname));
  }
});
//config multer
const upload = multer({
  storage: storage
  // fileFilter: (req,file,cb) => {
  //     checkFileType(file,cb)
  // }
}).single("Media");

function checkFileType(file, cb) {
  const filetypes = /jpeg|jpg|png|gif/;

  /// check ext
  const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
  // check filetypes phải image
  const mimetype = filetypes.test(file.mimetyle);

  if (mimetype && extname) {
    cb(null, true);
  } else {
    cb("Error: Image Only");
  }
}

route.use((req, res, next) => {
  next();
});

route.get("/", async (req, res) => {
  try {
    let items = await mediaDB.find();
    res.json(response.getJson(res.statusCode, items));
  } catch (err) {
    res.json(response.getJson(res.statusCode, err));
  }
});
//post
route.post("/", async (req, res) => {
  let song = new mediaDB({
    name: req.body.name,
    author: req.body.author,
    image: req.body.image,
    albumID: req.body.albumID
  });
  console.log(song);
  try {
    let postSong = await song.save();
    res.json(response.getJson(res.statusCode, postSong));
  } catch (err) {
    res.json(response.getJson(res.statusCode, err));
  }
});
//delete
route.delete("/postID", async (req, res) => {
  try {
    let ID = req.params.ID;
    let deleteSong = await mediaDB.remove({ _id: ID });
    res.json(response.getJson(res.statusCode, deleteSong));
  } catch (err) {
    res.json(response.getJson(res.statusCode, err));
  }
});
//update
route.put("/postID", async (req, res) => {
  try {
    let ID = req.params.postID;
    let updateSong = mediaDB.update(
      { _id: ID },
      {
        $set: {
          name: req.body.name,
          author: req.body.author,
          image: req.body.image,
          albumID: req.body.albumID
        }
      }
    );
    res.json(response.getJson(res.statusCode, updateSong));
  } catch (err) {
    res.json(response.statusCode, err);
  }
});

route.post("/upload", async (req, res) => {
  try {
   upload(req, res, async (err) => {
    if (err) {
      res.json(response.getJson(res.statusCode, err));
    } else {
      if (req.file == undefined) {
        res.json(response.getJson(res.statusCode, "No File Selected"));
      }
      let media = new mediaDB({
        name:req.body.name,
        author:req.body.author,
        originalname:req.file.originalname,
        path:req.file.path,
        mimetype:req.file.mimetype,
        size: req.file.size,
        encoding: req.file.encoding,
        categoryID :req.body.categoryID
      })
      let saveMedia = await media.save()

    let io = req.app.locals.io
      io.sockets.emit(socketEventName.emit.media,media)
      res.json(response.getJson(res.statusCode, saveMedia))
    }
  })
} catch (error) {
  res.json(response.getJson(res.statusCode,error))
}
})

route.get('/recent', async (req,res) => {
  try {
  let items = await mediaDB.find().sort({date: -1}).limit(10)
  res.json(response.getJson(res.statusCode,items))
  } catch (error) {
    res.json(response.getJson(res.statusCode,error))
  }
})
module.exports = route;

