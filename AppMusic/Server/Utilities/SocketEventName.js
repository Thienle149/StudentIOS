class SocketEventName {
    static emit = {
        media : "server-emit-data-media",
        medias: "server-emit-data-medias",
        test: "server-emit-data-test",
        test_open: "server-emit-data-test-open"
    }
    static on = {
        media : "server-on-data-media",
        test: "server-on-data-test"
    }
}
module.exports = SocketEventName