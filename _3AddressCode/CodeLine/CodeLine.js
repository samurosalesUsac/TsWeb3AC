// let TemporalCall = require('./TemporalCall').TemporalCall;

class CodeLine {
    constructor (name, value) {
        this.name = name
        this.value = value
    }
    
    exec = function () {
        let temporalValue  = this.value.exec() //scope inside

        let  hash  = TemporalCall.scope[TemporalCall.scope.length - 1]
        hash[this.name] = temporalValue
    }
}


