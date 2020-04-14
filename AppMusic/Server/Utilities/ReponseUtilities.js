class ReponseUtilities {
   static getJson(status,result) {
        return {"statusCode": status,"result":result}
    }
}

module.exports = ReponseUtilities