const express = require("express");
var route = express.Router();
var mongoose = require("mongoose");
const testDB = require("../Models/Test");
const questionDB = require("../Models/Question");
const answerDB = require("../Models/Answer");
const response = require("../Utilities/ReponseUtilities");

var objectID = mongoose.Types.ObjectId;
///middleware
route.use((req, res, next) => {
  next();
});

route.get("/", async (req, res) => {
  let tests = await testDB.find();
  res.json(response.getJson(res.statusCode, tests));
});

route.post("/", async (req, res) => {
  let testName = req.body.name;
  let questions = req.body.questions;
  let test = new testDB({ name: testName });
  console.log(testName);
  let testSave = await test.save();
  questions.forEach(async (question) => {
    question.testID = testSave._id;
    let questionModel = new questionDB(question);
    let questionSave = await questionModel.save();
    question.answers.forEach(async (answer) => {
      answer.questionID = questionSave._id;
      console.log(answer);
      let answerModel = new answerDB(answer);
      await answerModel.save();
    });
  });
  res.json(response.getJson(res.statusCode, testSave));
});

route.get("/id/:postID", async (req, res) => {
  let testID = objectID(req.params.postID);
  questionDB.aggregate(
    [
      { $match: { testID: testID } },
      {
        $lookup: {
          from: "answers",
          let: { tempID: "$_id" },
          pipeline: [
            {
              $match: {
                $expr: {
                  $eq: ["$questionID", "$$tempID"],
                },
              },
            },
          ],
          as: "answers",
        },
      },
    ],
    (error, result) => {
      console.log(result);
      res.json(response.getJson(res.statusCode, result));
    }
  );
});

module.exports = route;
