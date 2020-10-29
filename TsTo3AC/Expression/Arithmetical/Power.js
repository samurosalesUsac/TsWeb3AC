

class Power extends Node {

    constructor (left, right, line, column) {
        super(line, column)

        this.left = left
        this.right = right
    }

    exec = function (scope) {
        let actualLeft = this.left.exec(scope)
        let actualRight = this.right.exec(scope)

        if(this.right instanceof Call){
            this.parcialCode += this.right.parcialCode
            this.parcialCode += this.left.parcialCode
        }else{
            this.parcialCode += this.left.parcialCode
            this.parcialCode += this.right.parcialCode
        }


        if ((actualLeft.type == "number" || actualLeft.type == "boolean")
            && (actualRight.type == "number" || actualRight.type == "boolean")) {

            this.setNewCode(this.getNewTemporal() + " = " + actualLeft.getValue() + " ** " + actualRight.getValue() + ";")

            // this.concatCode()
            return new Symbol("number", this.getThisTemporal(), this.line, this.column)
        } else if (actualLeft.type != "Error" && actualRight.type != "Error") {

            // this.setError(
            //     "los tipos de dato : "
            //     + actualLeft.type + " y " + actualRight.type +
            //     "no son operables por el operador: " + this.operator)

            return new Symbol("Error")

        }


        // this.concatCode()
        return new Symbol()
    }
}