class SocketEventName {
    static emit = {
        media : "server-emit-data-media",
        medias: "server-emit-data-medias",
        test: "server-emit-data-test"
    }
    static on = {
        media : "server-on-data-media",
        test: "server-on-data-test"
    }
}
module.exports = SocketEventName