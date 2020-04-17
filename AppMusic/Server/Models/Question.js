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
    testID: {
        type: mongoose.Schema.Types.ObjectId, 
        require: true
    }
})

module.exports = mongoose.model("Question",CategorySchema)