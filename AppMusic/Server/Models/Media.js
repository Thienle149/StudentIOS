const mongoose = require("mongoose")
const SongSChema = mongoose.Schema({
    name:{
        type: String,
        require:true
    },
    author: {
        type: String
    },
    originalname: {
        type: String,
        require: false
    },
    path: {
        type: String,
        require:true
    },
    date: {
        type: Date,
        default: Date.now()
    },
    mimetype: {
        type: String,
        require:true
    },
    size :{
        type: Number,
        require:true
    },
    encoding: {
        type: String
    },
    categoryID: {
        type: mongoose.Schema.Types.ObjectId,
        require: true
    }
})

module.exports = mongoose.model("Media",SongSChema)