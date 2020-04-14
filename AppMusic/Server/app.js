// Server for app music

const express = require("express");
const app = express();
const server = require("http").Server(app);
const io = require("socket.io")(server);
const categories = require("./Routes/Category");
const medias = require("./Routes/Media");
const bodyParser = require("body-parser");
const resize = require("./resize");
const fs = require("fs");

require("./socket")(io);
require("./db");

const PORT = 3000;

app.use("/Public", express.static("Public"));
// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }));
// parse application/json
app.use(bodyParser.json());

//Route
app.use("/categories", categories);
app.use("/medias", medias);

//Socket
app.locals.io = io;
// Resize image return image technology stream pipe
app.get("/Public/medias/:file/", (req, res) => {
  const widthStr = req.query.width;
  const heightStr = req.query.height;
  const format = req.query.format;

  let width, height;

  if (widthStr && !isNaN(widthStr))  {
    width = parseInt(widthStr)
  }
  if (heightStr && !isNaN(heightStr)) {
    height = parseInt(heightStr);
  }
  var path = `./Public/medias/${req.params.file}`;
  console.log(req.params.file)
  fs.exists(path, (exists) => {
    if (!exists) {
      path = `./Public/System/icons8-error-160.png`;
    }
    res.type(`image/${format || "png"}`);
    resize(path, format, width, height).pipe(res);
  });
});

server.listen(PORT, () => {
  console.log("server listenning: " + PORT);
});
