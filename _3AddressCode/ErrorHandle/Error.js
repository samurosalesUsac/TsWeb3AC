
class Error {
    constructor(type, value) {
        this.type = type
        this.value = value
    }
    exec = function () {
       if(this.type !== this.value){
           throw this.type
       }
    }
}