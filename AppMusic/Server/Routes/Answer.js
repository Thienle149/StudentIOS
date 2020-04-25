const express = require('express')
const router = express.Router()
const answerDB = require("../Models/Answer")
const mongoose = require("mongoose")
const objectID = mongoose.Types.ObjectId
const response = require('../Utilities/ReponseUtilities')

router.use((req,res,next)=>{
    next()
})

router.put("/", async (req, res) => {
  try {
    let id = req.body["_id"];
    let questionID = req.body["questionID"]
    let answerPost = await answerDB.updateOne(
      { _id: objectID(id) },
      { $set: { name: req.body["name"], result: req.body["result"] } }
    );
    if (req.body["result"] === true) {
      await answerDB.updateMany(
        { _id: { $ne: objectID(id) },questionID: questionID},
        { $set: { result: false } }
      );
    }
    res.json(response.getJson(res.statusCode,answerPost))
  } catch (err) {
    res.json(response.getJson(400, err));
  }
});

router.delete('/', async(req,res)=>{
    try {

        let id = req.body["_id"]
        console.log(id)
        let answerPost = await answerDB.deleteOne({_id: objectID(id)})
        res.json(response.getJson(res.statusCode,answerPost))
    } catch(err) {
        res.json(response.getJson(400,err))
    }
})

module.exports = router