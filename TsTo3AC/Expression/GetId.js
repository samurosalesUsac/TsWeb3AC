// const { Node } = require('../Node')
// const { Symbol } = require('./Symbol')

class GetId extends Node {
    constructor (name, line, column) {
        super(line, column) 

        this.name = name
    }

    exec = function (scope){
        let variable = scope.getVariable(this.name)
        let globalVariable = scope.getGlobalVariable(this.name)

        if(variable){
            globalVariable = false
        }

        if(globalVariable){

            this.setNewCode(`${this.getNewTemporal()} = p - 2;`)  // -2 fixed place for 'this' att
            this.setNewCode(`${this.getNewTemporal()} = Stack[(int)${this.getThisTemporal(-1)}];\n`)

            this.setNewLabel();
            this.setNewCode(`\t${this.getThisTemporal()} = ${this.getThisTemporal()} + 1;`)
            this.setNewCode(`\t${this.getNewTemporal()} = Heap[(int)${this.getThisTemporal(-1)}];`)
            this.setNewCode(`if(${this.getThisTemporal()} != -1) goto ${this.getThisLabel()};\n`)
            this.setNewCode(`${this.getThisTemporal(-1)} = ${this.getThisTemporal(-1)} + 1;\n`)

            this.setNewCode(`${this.getNewTemporal()} = ${this.getThisTemporal(-2)} + ${globalVariable.index};`)
            this.setNewCode(`${this.getNewTemporal()} = Heap[(int)${this.getThisTemporal(-1)}];`)
            this.setNewCode(`${this.getNewTemporal()} = Stack[(int)${this.getThisTemporal(-1)}];`)

            // this.setNewCode(`${this.getNewTemporal()} = ${globalVariable ? '':'p'} ${thisIndex <0 ? '- ' + (thisIndex* -1) : '+ ' + thisIndex };`)
            // this.setNewCode(`${this.getNewTemporal()} = Stack[(int)${this.getThisTemporal(-1)}];`)
            let idValue = new Symbol(globalVariable.type, this.getThisTemporal())
            idValue.index = this.getThisTemporal(-1)
            return idValue
        }

        if(variable || globalVariable){

            if(globalVariable) variable = globalVariable

            let thisIndex = variable.index - Node.relativeP

            this.setNewCode(`${this.getNewTemporal()} = ${globalVariable ? '':'p'} ${thisIndex <0 ? '- ' + (thisIndex* -1) : '+ ' + thisIndex };`)
            this.setNewCode(`${this.getNewTemporal()} = Stack[(int)${this.getThisTemporal(-1)}];`)

            let idValue = new Symbol(variable.type, this.getThisTemporal())
            idValue.index = this.getThisTemporal(-1)
            return idValue
        }

       
    }
}

    
