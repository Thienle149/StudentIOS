const express = require("express");
const route = express.Router();
const response = require("../Utilities/ReponseUtilities");
const answerDB = require("../Models/Answer");
const questionDB = require("../Models/Question");
const mongoose = require("mongoose");
const utility = require("../Utilities/Utility");

const objectID = mongoose.Types.ObjectId;

route.use((req, res, next) => {
  next();
});

/* #region  "/" */
route.get("/", (req, res) => {});

route.post("/", async (req, res) => {
  var numRight = 0;
  let questions = req.body.questions;
  let numQuestion = questions.length;
  await utility.asyncForEach(questions, async (question) => {
    var answers = question.answers;
    let questionID = question._id;
    let answerRight = await answerDB.findOne({
      questionID: questionID,
      result: true,
    });
    answers.forEach((answer) => {
      if (
        answer._id == answerRight._id &&
        answer.result == answerRight.result
      ) {
        numRight += 1;
        question.answers = [answer];
        return;
      } else if (
        answer._id == answerRight._id &&
        answer.result != answerRight.result
      ) {
        answer.repaired = true;
        answer.result = answerRight.result;
        question.answers = [answer];
        return;
      }
    });
  });
  let result = { right: numRight, count: numQuestion, questions: questions };
  console.log(result);
  res.json(response.getJson(res.statusCode, result));
});

route.put("/", async (req,res)=> {
  try {
  let id = req.body["_id"]
  let questionPost = await questionDB.updateOne({_id: objectID(id)},{$set:{name: req.body["name"]}})
  res.json(response.getJson(res.statusCode,questionPost))
  } catch (err) {
    res.json(response.getJson(400,err))
  }
})

route.delete("/", async (req,res)=> {
  try {
    let id = req.body["_id"]
    console.log(id)
    await answerDB.deleteMany({questionID: objectID(id)})
    let questionPost = await questionDB.deleteOne({_id: objectID(id)})
    res.json(response.getJson(res.statusCode,questionPost))
  } catch (err) {
    res.json(response.getJson(400,err))
  }
})
/* #endregion */

/* #region  "/id/:postID" */
route.get("/id/:postID", async (req, res) => {
  let questionID = req.params.postID;
  await answerDB.find({ questionID: questionID }, (err, answers) => {
    if (err === null || err === undefined) {
      res.json(response.getJson(res.statusCode, answers));
    } else {
      res.json(response.getJson(400, err));
    }
  });
});
/* #endregion */
module.exports = route;
