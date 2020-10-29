/* eslint-disable */

// const { Node } = require('../Node')
// const { Symbol } = require('../Expression/Symbol')

class NewObj extends Node {
    constructor (name, constructor, line, column) {
        super(line, column)
    
        this.name = name
        this.constructor = constructor
    }

    exec = function (scope) {

        let objClass = scope.getObjClass(this.name)
        let list = objClass.attributes

        let strVal = new Symbol('string', this.name, -2,-2)
        let firstPtr = strVal.getValue()

        this.parcialCode += strVal.parcialCode

        this.setNewCode(`Heap[h] = ${Object.entries(list).length};`)

        this.setNewCode(`h = h + 1;`)

        let firstInnerObj = this.getNewTemporal()

        this.setNewCode(`${firstInnerObj} = h;`)

        this.setNewCode(`h = h + ${Object.entries(list).length};`)

        Object.entries(list).forEach(([key, element], index) => {
    
            if(element.type != this.name){

                let temp = element.exec(scope, this.name)
                this.parcialCode += element.parcialCode
                element.parcialCode = ''

                this.setNewCode(`${this.getNewTemporal()} = ${firstInnerObj} + ${index};`)
                this.setNewCode(`Heap[${this.getThisTemporal()}] = ${temp};`)

            }else{
                console.log('meterle el nulo')
            }

        });


        // this.setNewCode(`${this.getNewTemporal()} = ${firstPtr};`)
        return new Symbol(this.name, firstPtr)

    }

}
