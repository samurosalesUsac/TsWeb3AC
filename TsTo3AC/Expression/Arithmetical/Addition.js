class Addition extends Node {

    constructor(left, right, line, column) {
        super(line, column)

        this.left = left
        this.right = right
    }


    exec = function (scope) {

        if(this.left instanceof Symbol && this.left.type == 'string'){
            this.left = new Expression(this.left)
        }
        if(this.right instanceof Symbol && this.right.type == 'string'){
            this.right = new Expression(this.right)
        }

        let actualLeft = this.left.exec(scope)
        let actualRight = new Symbol()


        if (this.right instanceof Call) {
            if (this.left instanceof Call) {

                this.parcialCode += this.left.parcialCode

                //     Node.secondCall = true


                let retAux = scope.getNewIndex()
                this.setNewCode(`${this.getNewTemporal()} = p + ${retAux};`)
                this.setNewCode(`Stack[(int)${this.getThisTemporal()}] = ${actualLeft.value};`)

                this.setNewCode(`p = p + 1; // salto para conservar retorno 1`)
                Node.relativeP += 1

                actualRight = this.right.exec(scope)

                this.parcialCode += this.right.parcialCode


                this.setNewCode(`p = p - 1; // retorno el puntero a su origen despues de la segunda llamada`)
                Node.relativeP -= 1

                this.setNewCode(`${this.getNewTemporal()} = p + ${retAux};`)
                this.setNewCode(`${this.getNewTemporal()} = Stack[(int)${this.getThisTemporal(-1)}];`)
                actualLeft.value = this.getThisTemporal()

            } else {
                actualRight = this.right.exec(scope)
                this.parcialCode += this.right.parcialCode
                this.parcialCode += this.left.parcialCode
            }
        } else {
            actualRight = this.right.exec(scope)
            this.parcialCode += this.left.parcialCode
            this.parcialCode += this.right.parcialCode
        }

        if ((actualLeft.type == "number" || actualLeft.type == "boolean")
            && (actualRight.type == "number" || actualRight.type == "boolean")) {


            this.setNewCode(this.getNewTemporal() + " = " + actualLeft.getValue() + " + " + actualRight.getValue() + ";")

            // this.concatCode()
            return new Symbol("number", this.getThisTemporal(), this.line, this.column)

        } else if (actualLeft.type == "string" || actualRight.type == "string") {

            if(actualLeft.type == "number"){



                this.setNewCode(`\n// number + string`)

                let callString = new Call({name : `__call_concatString__`}, [actualLeft, actualRight])
                let tag = callString.exec(this.scope)
                this.setNewCode(callString.parcialCode)

                return new Symbol("string", tag.value, this.line, this.column)

            }else if(actualRight.type == 'number'){

                this.setNewCode(`\n// string + number`)

                let callString = new Call({name : `__call_concatString__`}, [actualLeft, actualRight])
                let tag = callString.exec(this.scope)
                this.setNewCode(callString.parcialCode)

                return new Symbol("string", tag.value, this.line, this.column)

            }else if(actualLeft.type == 'boolean'){

                this.setNewCode(`\n// boolena + string`)

                let callString = new Call({name : `__call_concatString__`}, [actualLeft,actualRight])
                let tag = callString.exec(this.scope)
                this.setNewCode(callString.parcialCode)

                return new Symbol("string", tag.value, this.line, this.column)

            }else if(actualRight.type == 'boolean'){

                this.setNewCode(`\n// string + boolean`)

                let callString = new Call({name : `__call_concatString__`}, [actualLeft, actualRight])
                let tag = callString.exec(this.scope)
                this.setNewCode(callString.parcialCode)

                return new Symbol("string", tag.value, this.line, this.column)

            }else if(actualLeft.type == 'string' && actualRight.type == 'string'){
                this.setNewCode(`\n// string + string`)

                let callString = new Call({name : `__call_concatString__`}, [actualLeft, actualRight])
                let tag = callString.exec(this.scope)
                this.setNewCode(callString.parcialCode)

                return new Symbol("string", tag.value, this.line, this.column)
            }

            return new Symbol("Error")
        } else if (actualLeft.type != "Error" && actualRight.type != "Error") {

            ErrorList = ErrorList.concat({
                type : 'Semantico',
                description : `Error en suma`,
                line : this.line,
                column : this.column});
            return new Symbol("Error")


        }

        // this.concatCode()
        return new Symbol("Error")

    };


    castToString = function (val) {

        switch (val.type) {
            case "integer":
                this.setNewCode(this.getNewTemporal() + " = p;")
                this.setNewCode("Stack[ " + this.getThisTemporal() + " ] = " + val.getValue() + ";")
                this.setNewCode("p = p + 2;         // 1parametro + 1return = 2")
                this.setNewCode("call integerToString;")
                this.setNewCode("p = p - 2;         // Limpiar 1parametro + 1return = 2")
                this.setNewCode(this.getNewTemporal() + " = p + 1")
                this.setNewCode(this.getNewTemporal() + " = " + "Stack[ " + this.getThisTemporal() + " ];")
                // this.cleanStack(2)
                // this.concatCode()
                return this.getThisTemporal()

            case "digit":
                this.setNewCode(this.getNewTemporal() + " = p;")
                this.setNewCode("Stack[ " + this.getThisTemporal() + " ] = " + val.getValue() + ";")
                this.setNewCode("p = p + 2;         // 1parametro + 1return = 2")
                this.setNewCode("call digitToString;")
                this.setNewCode("p = p - 2;         // Limpiar 1parametro + 1return = 2")
                this.setNewCode(this.getNewTemporal() + " = p + 1")
                this.setNewCode(this.getNewTemporal() + " = " + "Stack[ " + this.getThisTemporal() + " ];")
                // this.cleanStack(2)
                // this.concatCode()
                return this.getThisTemporal()

            case "boolean":
                this.setNewCode(this.getNewTemporal() + " = p;")
                this.setNewCode("Stack[ " + this.getThisTemporal() + " ] = " + val.getValue() + ";")
                this.setNewCode("p = p + 2;         // 1parametro + 1return = 2")
                this.setNewCode("call booleanToString;")
                this.setNewCode("p = p - 2;         // Limpiar 1parametro + 1return = 2")
                this.setNewCode(this.getNewTemporal() + " = p + 1")
                this.setNewCode(this.getNewTemporal() + " = " + "Stack[ " + this.getThisTemporal() + " ];")
                // this.cleanStack(2)
                // this.concatCode()
                return this.getThisTemporal()

            case "char":

                let temp = this.getNewTemporal()
                this.setNewCode(temp + " = p;")
                this.setNewCode(this.getNewTemporal() + " = h;")
                this.setNewCode("Stack[ " + this.getLastTemporal() + " ] = " + this.getThisTemporal() + ";")
                this.setNewCode("p = p + 1;")
                this.setNewCode("Heap[" + this.getThisTemporal + "] = " + val.getValue() + ";")
                this.setNewCode(this.getNewTemporal() + " = " + this.getLastTemporal() + " + 1;")
                this.setNewCode("Heap[" + this.getThisTemporal + "] = 0;")
                this.setNewCode("h = h + 2;         // posChar + posNull = 2")

                // this.concatCode()
                return temp;

        }

        // this.concatCode()
        return ""
    }
}