const express = require("express");
var route = express.Router();
var mongoose = require("mongoose");
const testDB = require("../Models/Test");
const questionDB = require("../Models/Question");
const answerDB = require("../Models/Answer");
const response = require("../Utilities/ReponseUtilities");
const utility = require("../Utilities/Utility");
const socketEventName = require("../Utilities/SocketEventName");
const elsx = require("xlsx");
const multer = require("multer");
const path = require("path");

var objectID = mongoose.Types.ObjectId;
//configure multer
const storage = multer.diskStorage({
  destination: "./Public/excel",
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});

const upload = multer({
  storage: storage,
}).single("elsx");

///middleware
route.use((req, res, next) => {
  next();
});

/* #region  "/" */
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
  await utility.asyncForEach(questions, async (question) => {
    question.testID = testSave._id;
    let questionModel = new questionDB(question);
    let questionSave = await questionModel.save();
    await utility.asyncForEach(question.answers, async (answer) => {
      answer.questionID = questionSave._id;
      console.log(answer);
      let answerModel = new answerDB(answer);
      await answerModel.save();
    });
  });
  let io = req.app.locals.io;
  io.sockets.emit(socketEventName.emit.test, testSave);
  res.json(response.getJson(res.statusCode, testSave));
});

route.put("/", async (req, res) => {
  try {
    let testPost = await testDB.updateOne(
      { _id: objectID(req.body["_id"]) },
      { $set: { timer: req.body["timer"] } }
    );
    res.json(response.getJson(res.statusCode, testPost));
  } catch (err) {
    res.json(response.getJson(400, err));
  }
});

route.delete("/", async (req,res)=>{
  try {
  let testID = req.body["_id"]
  let questions = await questionDB.find({testID: objectID(testID)}) 
  await utility.asyncForEach(questions,async (question)=>{
    await answerDB.deleteMany({questionID: objectID(question._id)})
  })
  await questionDB.deleteMany({testID: objectID(testID)})
  let testPost = await testDB.deleteOne({_id: objectID(testID)})
  res.json(response.getJson(res.statusCode,testPost))
  } catch (err) {
    res.json(response.getJson(400,err))
  }
});
/* #endregion */

/* #region  "/id/:postID" */
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
            {
              $project: { result: 0 },
            },
          ],
          as: "answers",
        },
      },
    ],
    (error, result) => {
      res.json(response.getJson(res.statusCode, result));
    }
  );
});
/* #endregion */

/* #region  "/import" */
route.get("/import", async (req, res) => {
  let tests = await testDB.find();
  res.render("pages/import", { tests: tests });
});

route.post("/import", async (req, res) => {
  let tests = req.body["tests"];
  let questions = req.body["questions"];
  let answers = req.body["answers"];
  console.log(req.body)
  await utility.asyncForEach(tests, async (test) => {
    let testSave = new testDB({ name: test.name });
    await testSave.save();
    questions.forEach(async (question) => {
      if (question.testid === test.id) {
        let questionSave = new questionDB({
          name: question.name,
          testID: testSave._id,
        });
        await questionSave.save();
        answers.forEach(async (answer) => {
          if (answer.questionid === question.id) {
            let answerSave = new answerDB({
              name: answer.name,
              result: answer.result,
              questionID: questionSave._id,
            });
            await answerSave.save();
          }
        });
      }
    });
    let io = req.app.locals.io;
    io.sockets.emit(socketEventName.emit.test, testSave);
  });
  res.json(response.getJson(res.statusCode, "Successed!"));
});

route.put("/import/open", async (req,res)=>{
  console.log(req.body["_id"])
  let testPost = await testDB.updateOne({_id: req.body["_id"]},{$set:{open: req.body["open"]}}) 
  res.json(response.getJson(res.statusCode,testPost))
}) 
/* #endregion */
module.exports = route;
