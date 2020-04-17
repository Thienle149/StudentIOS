var mongoose = require("mongoose")

const CategorySchema = mongoose.Schema({
    name:{
        type: String,
        require: true
    },
    result: {
        type: Boolean,
        require: true
    },
    questionID: {
        type: mongoose.Schema.Types.ObjectId, 
        require: true
    }
})

module.exports = mongoose.model("Answer",CategorySchema)