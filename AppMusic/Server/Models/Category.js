var mongoose = require("mongoose")

const CategorySchema = mongoose.Schema({
    name:{
        type: String,
        require: true
    },
    date: {
        type: Date,
        default: Date.now()
    }, 
    image: {
        type: String,
        require: true
    }
})

module.exports = mongoose.model("Categories",CategorySchema)