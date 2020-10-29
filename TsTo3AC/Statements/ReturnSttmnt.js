// const { Node } = require('../Node')

class ReturnSttmnt extends Node {
    constructor (value, line, column) {
        super(line, column)
        
        this.value = value

     }
     
    exec = function (scope) {


        let res = this.value.exec(scope)

        this.parcialCode += this.value.getParcialCode()

        this.setNewCode(`\n\t// Return`);

        this.setNewCode(`\n${this.getNewTemporal()} = p - 1;`)

        this.setNewCode(`\nStack[(int)${this.getThisTemporal()}] = ${res.value};`)

        this.setNewCode(`\n\tgoto ${Node.funcEndLab};`)       

    }

}

