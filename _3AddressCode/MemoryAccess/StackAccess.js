// let TemporalCall = require('../CodeLine/TemporalCall').TemporalCall
// let Value = require('../CodeLine/Value').Value


class SetStack {
    constructor (stackIndex, temporalValue) {
        this.stackIndex = stackIndex
        this.temporalValue = temporalValue

        SetStack.stack = new Array()
    }
    
    exec = function () {

        let stackIndexI = this.stackIndex.exec()
        this.temporalValue = this.temporalValue.exec(this.scope)

        let hash = TemporalCall.scope[TemporalCall.scope.length - 1]
        let index = stackIndexI.value
        // let index = 0

        SetStack.stack[index] = this.temporalValue.value
    }
}

class GetStack {
    constructor (temporalTag, stackIndex) {
        this.temporalTag = temporalTag
        this.stackIndex = stackIndex
    }

    exec = function () {

        let stackIndexI = this.stackIndex.exec()

        let hash = TemporalCall.scope[TemporalCall.scope.length - 1]
        let index = stackIndexI.value

        hash[this.temporalTag] = new Value( SetStack.stack[index] )

    }
}



