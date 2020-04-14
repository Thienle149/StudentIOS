const express = require("express");
var route = express.Router();
const categoryDB = require("../Models/Category");
const mediaDB = require("../Models/Media");
const response = require("../Utilities/ReponseUtilities");
///middleware
route.use((req, res, next) => {
  next();
});

/* #region "/" */
route.get("/", async (req, res) => {
  try {
    const items = await categoryDB.find();
    res.json(response.getJson(res.statusCode, items));
  } catch (err) {
    res.json(response.getJson(res.statusCode, err));
  }
});

route.post("/", async (req, res) => {
  const category = new categoryDB({
    name: req.body.name,
    image: req.body.image,
  });
  try {
    const savePost = await category.save();
    res.json(response.getJson(res.statusCode, savePost));
  } catch (err) {
    res.json(response.getJson(res.sendStatus, err));
  }
});
/* #endregion */

/* #region  "/:postID" */
route.get("/id/:postID/", async (req, res) => {
  try {
    let id = req.params.postID;
    let strOffset = req.query.offset;
    let strLimit = req.query.limit;
    var medias;
    if (strOffset && strLimit && !isNaN(strOffset) && !isNaN(strLimit)) {
      var offset, limit;
      offset = parseInt(strOffset);
      limit = parseInt(strLimit);
      medias = await mediaDB.find({ categoryID: id });
      medias = medias.slice(offset, limit);
    } else {
      medias = await mediaDB.find({ categoryID: id });
    }

    res.json(response.getJson(res.statusCode, medias));
  } catch (err) {
    res.json(response.getJson(res.statusCode, err));
  }
});

route.delete("/postID", async (req, res) => {
  try {
    let ID = req.params.postID;
    const deleteCategory = await categoryDB.remove({ _id: ID });
    res.json(response.getJson(res.sendStatus, deleteCategory));
  } catch (err) {
    res.json(response.getJson(res.sendStatus, err));
  }
});

route.put("/postID", async (req, res) => {
  try {
    let ID = req.params.postID;
    let updateCategory = await categoryDB.update(
      { _id: ID },
      { $set: { name: req.body.name, image: req.body.image } }
    );
    res.json(response.getJson(res.statusCode, updateCategory));
  } catch (err) {
    res.json(response.getJson(res.statusCode, err));
  }
});

/* #endregion */

/* #region  "/medias" */
route.get("/medias", async (req, res) => {
  // object = [{category:{},medias:[]},...]
  try {
    let strOffset = req.query.offset;
    let strLimit = req.query.limit;
    var limit = 0;
    if (strLimit && !isNaN(strLimit)) {
      limit = Number(strLimit);

    await categoryDB.aggregate(
      [ 
        {
          $lookup: {
            from: "media",
            let:{tempID: "$_id"},
            pipeline:[{$match:{
              $expr: {
                $eq:["$categoryID","$$tempID"]
              }
            }},{$limit:limit}],
            as: "medias"
          }, 
        }
      ],
      (err, result) => {
        if (err == undefined || err == null) {
          res.json(response.getJson(res.statusCode, result));
        } else {
          res.json(response.getJson(res.statusCode, err));
        }
      }
    );
    } else {
      await categoryDB.aggregate([{
        $lookup: {
          from: "media",
          localField: "_id",
          foreignField:"categoryID",
          as: "medias"
        }
      }],(err,result) => {
        if (err == null || err == undefined) {
          res.json(response.getJson(res.statusCode,result))
        } else {
          res.json(response.statusCode,err)
        }
      })
    }
  } catch (err) {
    res.json(response(res.statusCode, err));
  }
});
/* #endregion */

module.exports = route;
