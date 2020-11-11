

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


        if ((actualLeft.type == "number" )
            && (actualRight.type == "number" )) {

            let callString = new Call({name : `__call_powerMethod__`}, [actualLeft, actualRight])
            let tag = callString.exec(this.scope)
            this.setNewCode(callString.parcialCode)

            return new Symbol("number", tag.value, this.line, this.column)
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
