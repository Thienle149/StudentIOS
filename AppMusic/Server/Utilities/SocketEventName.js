class SocketEventName {
    static emit = {
        media : "server-emit-data-media",
        medias: "server-emit-data-medias"
    }
    static on = {
        media : "server-on-data-media"
    }
}
module.exports = SocketEventName