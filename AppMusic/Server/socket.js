const categoryDB = require('./Models/Category')
const eventName = require('./Utilities/SocketEventName')
module.exports = function (io) {
    io.sockets.on("connection",(socket)=> {
        console.log(`Opened: ${socket.id}`)

        io.sockets.emit("langnghe","dimeme")

        socket.on("disconnect",()=>{
            console.log(`Closed: ${socket.id}` )
        })
    })
}