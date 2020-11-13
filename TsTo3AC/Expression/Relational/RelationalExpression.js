

class RelationalExpression extends Node {
    constructor (operator, left, right, line, column) {
        super(line, column)

        this.operator = operator
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

                this.setNewCode("if (" + actualLeft.getValue() + " " + this.operator + " " + actualRight.getValue() + ") goto " + this.getThisLabel(1) + ";")
                this.setNewCode("goto " + this.getThisLabel(2) + ";")
                this.setNewLabel()
                this.setNewCode(this.getNewTemporal() + " = 1;")
                this.setNewCode("goto " + this.getThisLabel(2) + ";")
                this.setNewLabel()
                this.setNewCode(this.getThisTemporal() + " = 0;")
                this.setNewLabel()

                // this.concatCode()
                return new Symbol("boolean", this.getThisTemporal())


        } else if (actualLeft.type != "Error" && actualRight.type != "Error") {

           ErrorList = ErrorList.concat({
               type : 'Semantico',
               description : `Error en operacion relacional ${this.operator}`,
               line : this.line,
               column : this.column});

            return new Symbol("Error")


        }

        return new Symbol("Error")
    }

}



