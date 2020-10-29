// let Value = require('./Value').Value

class TemporalCall {
    constructor (variable) {
        this.variable = variable
    }

    exec = function () {
        let hash = TemporalCall.scope[TemporalCall.scope.length - 1]
        return hash[this.variable] != undefined ? hash[this.variable] : new Value(0)
    }
}


TemporalCall.scope = new Array({})






