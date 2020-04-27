/* #region  SocketIO */
var socket = io("http://localhost:3000/");

socket.on("server-emit-data-test", (test) => {
  $(".js-body-test").append(`   
  <tr class="js-test" onclick="clickTest(this,'${test._id}')">
      <td>${test._id}</td>
      <td>${test.name}</td>
      <td>${test.timer}</td>
      <td>
        <div class="dropdown">
          <img class="three_dot dropdown-toggle" src="../../Resource/icon/feedmenu.png"
              id="dropdownMenu2" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          <div class="dropdown-menu" style="width: 50px;">
              <a class="dropdown-item" data-toggle="modal" data-target="#exampleModal"
                  data-whatever="@mdo"
                  onclick="updateUITest('${test._id}','${test.name}','${test.timer}')">Update</a>
              <a class="dropdown-item" href="#" onclick = "deleteTest('${test._id}')">Delete</a>
          </div>
       </td>
</tr>`);
});
/* #endregion */

/* #region Function Utility */
function handleTagTestUI(id, callback) {
  $(".js-test").each(function (index, element) {
    let tagChildID = $(element).children()[0];
    let tagChildTimer = $(element).children()[2];
    let tagFuncUITest = $(
      $($($(element).children()[3]).children()[0]).children("div")
    ).children()[0];
    if ($.trim($(tagChildID).text()) === id) {
      return callback(
        $(element),
        $(tagChildID),
        $(tagChildTimer),
        $(tagFuncUITest)
      );
    }
  });
}

function handleTagQuestionUI(id, callback) {
  $(".js-question").each((index, element) => {
    let tagChildID = $(element).children()[0];
    let tagChildName = $(element).children()[1];
    let tagFuncUIQuestion = $(
      $($($(element).children()[2]).children()[0]).children("div")
    ).children()[0];
    if ($.trim($(tagChildID).text()) === $.trim(id)) {
      return callback($(element), $(tagChildName), $(tagFuncUIQuestion));
    }
  });
}

function handleTagAnswerUI(id, callback) {
  $(".js-answer").each((index, element) => {
    let tagChildID = $(element).children()[0];
    let tagChildName = $(element).children()[1];
    let tagChildResult = $(element).children()[2];
    let tagFuncAnswer = $(
      $($($(element).children()[3]).children()[0]).children("div")
    ).children()[0];
    if ($.trim($(tagChildID).text()) === $.trim(id)) {
      return callback(
        $(element),
        $(tagChildName),
        $(tagChildResult),
        $(tagFuncAnswer)
      );
    }
  });
}

function alertResponse(message = String, color = "green") {
  $("#alertID").html(message);
  $("#alertID").css({ color: color });
}
/* #endregion */

/* #region  UI */
$("#js-answer-result-false").click(function (e) {
  e.preventDefault();
  $("#js-answer-result-false").addClass("focus active");
  $("#js-answer-result-true").removeClass("focus active");
});

$("#js-answer-result-true").click(function (e) {
  e.preventDefault();
  $("#js-answer-result-true").addClass("focus active");
  $("#js-answer-result-false").removeClass("focus active");
});
/* #endregion */

/* #region  Function Main */

/* #region  Send Question Answer */
$("#submitID").click(() => {
  var files = $("input#fileID")[0].files;
  f = files[0];
  var result = {};
  var reader = new FileReader();
  reader.onload = function (e) {
    var data = new Uint8Array(e.target.result);
    var workbook = XLSX.read(data, { type: "array" });
    var sheet_name_list = workbook.SheetNames;

    sheet_name_list.forEach((sheetName) => {
      var worksheet = workbook.Sheets[sheetName];
      var headers = {};
      var data = [];

      for (z in worksheet) {
        if (z[0] === "!") continue;
        //parse out the column, row, and value
        var col = z.substring(0, 1);
        var row = parseInt(z.substring(1));
        var value = worksheet[z].v;

        //store header names
        if (row == 1) {
          headers[col] = value;
          continue;
        }
        // ignore cell empty or cell = ""
        if (value == "") {
          continue;
        }

        if (!data[row]) data[row] = {};
        data[row][headers[col].toLowerCase()] = value;
      }
      //drop those first two rows which are empty
      data.shift();
      data.shift();
      result[sheetName.toLowerCase()] = data;
    });
    $.ajax({
      type: "Post",
      url: "http://localhost:3000/test/import",
      data: JSON.stringify(result),
      contentType: "application/json",
      success: function (response) {
        if (response.statusCode == 200) {
          let id = response.result._id;
          alertResponse("Successed upload", "green");
          $("input#fileID").val("").clone(true);
        }
      },
    });
  };
  reader.readAsArrayBuffer(f);
});

/* #endregion */

/* #region  Test */
function updateUITest(id, name, timer) {
  $("#sendTestID").attr("onclick", `updateTest("${id}","${name}")`);
  $("#exampleModalLabel").html(name);
  $("#recipient-name").val(timer);
}

function clickTest(element, id) {
  $(".table-left tbody tr").removeClass("row-selected");
  $(element).addClass("row-selected");
  $.ajax({
    type: "GET",
    url: `/test/id/${id}`,
    dataType: "json",
    success: function (response) {
      if (response.statusCode == 200) {
        let questions = response.result;
        let tabAnswer = $("#table-answerID tbody");
        tabAnswer.empty();
        let tag = $("#table-questionID tbody");
        tag.empty();
        questions.forEach((question) => {
          tag.append(
            `<tr class = "js-question" scope='row' onclick = "clickQuestion(this,'${question._id}')"> 
            <th>${question._id}</th> 
            <td>${question.name}</td>
            <td>
                        <div class="dropdown">
                            <img class="three_dot dropdown-toggle" src="../../Resource/icon/feedmenu.png" id="dropdownMenu2"
                                data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <div class="dropdown-menu">
                                <a class="dropdown-item" data-toggle="modal" data-target="#questionModal" data-whatever="@mdo" onclick ="updateUIQuestion('${question._id}','${question.name}')">Update</a>
                                <a class="dropdown-item" href="#" onclick = "deleteQuestion('${question._id}')">Delete</a>
                            </div>
                    </td>
            </tr>`
          );
        });
      }
    },
  });
}

function updateTest(id, name) {
  let timer = $("#recipient-name").val();
  $.ajax({
    type: "PUT",
    url: "/test",
    data: JSON.stringify({ _id: id, timer: timer }),
    dataType: "json",
    contentType: "application/json",
    success: function (response) {
      if (response.statusCode == 200) {
        let result = response.result;
        if (result.nModified > 0) {
          handleTagTestUI(id, (element, tagID, tagTimer, tagFunc) => {
            tagTimer.text(timer);
            tagFunc.attr({
              onclick: `updateUITest('${id}','${name}','${timer}')`,
            });
          });
          alertResponse("Successed update");
        }
      }
    },
  });
}

function deleteTest(id) {
  $.ajax({
    type: "DELETE",
    url: "/test",
    data: JSON.stringify({ _id: $.trim(id) }),
    dataType: "json",
    contentType: "application/json",
    success: function (response) {
      if (response.statusCode == 200) {
        if (response.result.deletedCount > 0) {
          handleTagTestUI(id, (parent) => {
            parent.remove();
            //UI remove questions answers
            $("#table-questionID tbody").empty();
            $("#table-answerID tbody").empty();
          });
          alertResponse("Successed delete");
        }
      } else {
        alertResponse("Failed delete", "green");
      }
    },
  });
}

function updateRun(element, id, status) {
  
  let open = status === 'true' ? false : true;
  $.ajax({
    type: "PUT",
    url: "/test/import/open",
    data: JSON.stringify({ _id: id, open: open }),
    dataType: "json",
    contentType: "application/json",
    success: function (response) {
      if (response.statusCode === 200) {
        let result = response.result;
        if (result.nModified > 0) {
          $(element).text(open == true ? "Stop" : "Run");
          $(element).attr({
            onclick: `updateRun(this,'${id}','${open}')`,
          });
        }
      }
    },
  });
}
/* #endregion */

/* #region  Question */
function clickQuestion(element, id) {
  $(".table-right tbody tr").removeClass("row-selected");
  $(element).addClass("row-selected");
  $.ajax({
    type: "GET",
    url: `/question/id/${id}`,
    dataType: "json",
    success: function (response) {
      let statusCode = response.statusCode;
      let tab = $("#table-answerID tbody");
      tab.empty();
      if (statusCode === 200) {
        let answers = response.result;
        answers.forEach((answer) => {
          tab.append(`<tr class="js-answer" onclick = "clickAnswer(this)">
             <td>${answer._id}</td>
             <td>${answer.name}</td>
             <td><input type="radio" name="answer" ${
               answer.result === true ? "checked" : ""
             } disabled></td>
             <td>
             <div class="dropdown">
             <img class="three_dot dropdown-toggle" src="../../Resource/icon/feedmenu.png" id="dropdownMenu2"
             data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
             <div class="dropdown-menu">
             <a class="dropdown-item" data-toggle="modal" data-target="#answerModal" data-whatever="@mdo"
                 onclick="updateUIAnswer(this,'${answer._id}','${
            answer.name
          }','${id}')">Update</a>
             <a class="dropdown-item" href="#" onclick = "deleteAnswer('${
               answer._id
             }')">Delete</a>
         </div>
         </div></td>
          </tr>`);
        });
      }
    },
  });
}

function updateUIQuestion(id, name) {
  $(".js-question-id").text(`ID: ${id}`);
  $(".js-question-name").val(name);
  $("#js-send-question").attr({ onclick: `updateQuestion("${id}")` });
}

function updateQuestion(id) {
  let name = $(".js-question-name").val();
  $.ajax({
    type: "PUT",
    url: "/question",
    data: JSON.stringify({ _id: id, name: name }),
    dataType: "json",
    contentType: "application/json",
    success: function (response) {
      if (response.statusCode == 200) {
        let result = response.result;
        if (result.nModified > 0) {
          handleTagQuestionUI(id, (tagParent, tagName, tagFunc) => {
            tagName.text(name);
            tagFunc.attr({ onclick: `updateUIQuestion('${id}','${name}')` });
          });
          $("#table-answerID tbody").empty();
          alertResponse("Successed update question");
        } else {
          alertResponse("Failed update question", "red");
        }
      }
    },
  });
}

function deleteQuestion(id) {
  $.ajax({
    type: "DELETE",
    url: "/question",
    data: JSON.stringify({ _id: id }),
    dataType: "json",
    contentType: "application/json",
    success: function (response) {
      if (response.statusCode === 200) {
        let result = response.result;
        if (result.deletedCount > 0) {
          handleTagQuestionUI(id, (parent) => {
            parent.remove();
            alertResponse("Succesed deleted question");
          });
        } else {
          alertResponse("Failed deleted question", "red");
        }
      }
    },
  });
}
/* #endregion */

/* #region  Answer */

function clickAnswer(element) {
  $(".table-answers tbody tr").removeClass("row-selected");
  $(element).addClass("row-selected");
}

function updateUIAnswer(element, id, name, questionID) {
  $(".js-answer-id").text(`ID: ${id}`);
  $(".js-answer-name").val(name);

  let tagResult = $($($(element).parents()[3]).children()[2]).children();
  let tagResultTrue = $("#js-answer-result-true");
  let tagResultFalse = $("#js-answer-result-false");
  let result = $(tagResult).prop("checked");

  if (result === true) {
    $("#js-answer-option-true").prop("checked", true);
    tagResultFalse.removeClass("focus active");
    tagResultTrue.addClass("focus active");
  } else {
    $("#js-answer-option-false").prop("checked", true);
    tagResultTrue.removeClass("focus active");
    tagResultFalse.addClass("focus active");
  }

  $("#js-send-answer").attr({
    onclick: `updateAnswer("${id}","${questionID}")`,
  });
}

function updateAnswer(id, questionID) {
  let result =
    $("input[name='resultAnswer']:checked").val() === "true" ? true : false;
  let name = $(".js-answer-name").val();
  $.ajax({
    type: "PUT",
    url: "/answer",
    data: JSON.stringify({
      _id: id,
      name: name,
      result: result,
      questionID: questionID,
    }),
    dataType: "json",
    contentType: "application/json",
    success: function (response) {
      if (response.statusCode === 200) {
        let res = response.result;
        if (res.nModified > 0) {
          handleTagAnswerUI(id, (parent, tagName, tagResult) => {
            tagName.html(name);
            let tagInput = $(tagResult.children()[0]);
            tagInput.prop({ checked: result });
          });
        }
        alertResponse("Successed update answers", "green");
      } else {
        alertResponse("Failed update answers", "red");
      }
    },
  });
}

function deleteAnswer(id) {
  $.ajax({
    type: "DELETE",
    url: "/answer",
    data: JSON.stringify({ _id: id }),
    dataType: "json",
    contentType: "application/json",
    success: function (response) {
      if (response.statusCode === 200) {
        let result = response.result;
        if (result.deletedCount > 0) {
          handleTagAnswerUI(id, (element) => {
            element.remove();
          });
          alertResponse("Successed deleted answer");
        } else {
          alertResponse("Failed deleted answer", "red");
        }
      } else {
        alertResponse("Failed deleted answer", "red");
      }
    },
  });
}
/* #endregion */

/* #endregion */
