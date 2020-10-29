//
// let TemporalCall = require('../CodeLine/TemporalCall').TemporalCall
// let Value = require('../CodeLine/Value').Value

class SetHeap {
    constructor  (heapIndex, temporalValue) {
        this.heapIndex = heapIndex
        this.temporalValue = temporalValue

        SetHeap.heap = SetHeap.heap == undefined ?  new Array() : SetHeap.heap
    }

    exec = function () {

        let heapIndexI = this.heapIndex.exec(this.scope)
        let temporalValueT = this.temporalValue.exec(this.scope)

        let hash = TemporalCall.scope[TemporalCall.scope.length - 1]
        let index = heapIndexI.value
        // let index = 0

        SetHeap.heap[index] = temporalValueT.value

    }
}



class GetHeap {
    constructor (temporalTag, heapIndex) {
        this.heapIndex = heapIndex
        this.temporalTag = temporalTag
    }

    exec = function () {

        let heapIndexI = this.heapIndex.exec()

        let hash = TemporalCall.scope[TemporalCall.scope.length - 1]
        let index = heapIndexI.value

        hash[this.temporalTag] = new Value( index )

    }
}

