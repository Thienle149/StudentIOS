module.exports = function (io) {
    io.sockets.on("connection",(socket)=> {
        console.log(`Opened: ${socket.id}`)

        socket.on("disconnect",()=>{
            console.log(`Closed: ${socket.id}` )
        })
    })
}