
class OrOp extends Node {
    constructor (left, right, line, column) {
        super(line, column)

        this.left = left
        this.right = right
    }


    exec = function (scope) {

        let booleanPin = false;

        if(Node.trueTagIndex == -1){

            // this.setNewCode("goto " + this.getThisLabel(2) + ";")

            //false tag
            this.setNewLabel()
            this.setNewCode("\t" + this.getNewTemporal() + " = 0;")
            this.setNewCode("goto " + this.getThisLabel(2) + ";")
            Node.falseTagIndex = this.getThisLabel()


            //true tag
            this.setNewLabel()
            this.setNewCode("\t" + this.getThisTemporal() + " = 1;")
            Node.trueTagIndex = this.getThisLabel()
            //out tag
            this.setNewLabel()

            Node.returnTemp = this.getThisTemporal()
            var booleanTags = this.getParcialCode()
            this.cleanParcialCode()

            booleanPin = true
        }



        let returnSymbol = ''

        returnSymbol =  this.generateOr(scope)


        if(booleanPin){

            if(Node.gotoCode) {
                this.setNewCode(`goto ${Node.trueTagIndex};\n`)
            }else{
                // this.concatCode(`goto ${Node.falseTagIndex};\n`)
            }

            this.setNewCode("\n"+booleanTags)
            returnSymbol.value = Node.returnTemp

            Node.falseTagIndex = -1
            Node.trueTagIndex = -1
            Node.returnTemp = -1
        }



        return returnSymbol
    }

    generateOr = function (scope) {

        var actualLeft = this.left.exec(scope)
        this.parcialCode += "\n" + this.left.parcialCode



        if (actualLeft.type == "boolean" ) {

            this.setNewCode("if (" + actualLeft.getValue() + " == 1) goto " + Node.trueTagIndex + ";")
            this.setNewLabel()


            var actualRight = this.right.exec(scope)
            this.parcialCode += "\n" + this.right.parcialCode


            if(actualRight.type == "boolean" && !(this.right instanceof AndOp || this.right instanceof OrOp)){

                this.setNewCode("if (" + actualRight.getValue() + " == 1) goto " + Node.trueTagIndex + ";")
                Node.gotoCode = false


            }

            return new Symbol("boolean", this.getThisTemporal())

        } else if (actualLeft.type != "Error" && actualRight.type != "Error") {

            // this.setError(
            //     "los tipos de dato : "
            //     + actualLeft.type + " y " + actualRight.type +
            //     "no son operables por el operador: " + this.operator)
            //
            // return new Symbol("Error")

        }

        return new Symbol()
    }

}
