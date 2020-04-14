const mongoose = require('mongoose')
mongoose.connect("mongodb://localhost/AppMusic",{useNewUrlParser: true,useUnifiedTopology: true},(err)=>{
    if (err === null) {
        console.log("Connected DB")
    }
}) 

module.exports = mongoose