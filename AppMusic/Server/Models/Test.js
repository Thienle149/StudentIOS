var mongoose = require("mongoose")

const CategorySchema = mongoose.Schema({
    name:{
        type: String,
        require: true
    },
    timer: {
        type: Number,
        default: 0
    },
    date: {
        type: Date,
        default: Date.now()
    },
})

module.exports = mongoose.model("Test",CategorySchema)