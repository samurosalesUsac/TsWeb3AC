/* eslint-disable */

// var Node = require('../Node.js').Node


class Symbol extends Node {
    constructor(type, value, line, column){
        
        super(line , column )

        this.type = type || ''
        this.value = value

        this.setNewCode(`// ${this.value}`)
    }


    exec = function() {

        return this
   }

   getValue = function () {
        switch (this.type) {
            case "number":
                return this.value
            case "string":

                if (this.line != -1) {
                    return this.getString();
                } else {
                    return this.value
                }

            case "char":
                if (this.line != -1) {
                    return this.value.charCodeAt(0)
                } else {
                    return this.value
                }
            case "digit":
                return this.value
            case "boolean":
                return this.value
            case "null":
                return this.value  // 0
        }
   }
        // getValue = function () {
        //     switch (this.type) {
        //     case 2:
        //         return this.value
        //     case 3:
        //
        //         if (this.line != -1) {
        //         return this.getString();
        //         } else {
        //         return this.value
        //         }
        //
        //     case "char":
        //         if (this.line != -1) {
        //         return this.value.charCodeAt(0)
        //         } else {
        //         return this.value
        //         }
        //     case "digit":
        //         return this.value
        //     case 1:
        //         return this.value
        //     case "null":
        //         return this.value  // 0
        //     default :
        //         return this.value  // 0
        //
        //     }
        // }

    getinteger = function () {

    }

    getString = function () {

        let pTemp = this.getNewTemporal()

        this.setNewCode(pTemp + " = h;")                              // tn = h;

        // heap[_tn-1] = size
        this.setNewCode("Heap[(int) " + this.getThisTemporal() + " ] = " + this.value.length + ";   // " + this.value.length)
        //tn = _tn-1 + 1
        this.setNewCode(this.getNewTemporal() + " = " + this.getLastTemporal() + " + 1;")

        for (let charVal in this.value) {
        // heap[_tn-1] = ascii
        this.setNewCode("Heap[(int) " + this.getThisTemporal() + " ] = " + this.value[charVal].charCodeAt(0) + ";   // " + this.value[charVal])
        //tn = _tn-1 + 1
        this.setNewCode(this.getNewTemporal() + " = " + this.getLastTemporal() + " + 1;")

        }

        // heap[_tn-1] = ascii
        this.setNewCode("Heap[(int) " + this.getThisTemporal() + " ] = " + "-1;    // null") //null
        //tn = _tn-1 + 1
        this.setNewCode(this.getNewTemporal() + " = " + this.getLastTemporal() + " + 1;")

        this.setNewCode("h = " + this.getThisTemporal() + ";")

        this.setNewCode(`${this.getNewTemporal()} = ${pTemp};`)



        return pTemp
    }

}