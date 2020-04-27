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
    open: {
        type: Boolean,
        default: false
    }
})

module.exports = mongoose.model("Test",CategorySchema)