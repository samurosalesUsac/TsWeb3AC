// let Value = require('./Value').Value

class CodeExpression {

    constructor (operator, leftValue, rightValue) {
        this.operator = operator
        this.leftValue = leftValue
        this.rightValue = rightValue
    }

    exec = function () {
        // get Value from a Value Node or a call

        let newLeft = this.leftValue.exec(this.scope) 
        let newRight = this.rightValue.exec(this.scope) 


        // Aritmeticas
        if      (this.operator == "+"){

            return new Value ( parseFloat (newLeft.value) + parseFloat (newRight.value) )

        }else if(this.operator == "-"){

            return new Value ( newLeft.value - newRight.value )

        }else if(this.operator == "*"){

            return new Value ( newLeft.value * newRight.value )

        }else if(this.operator == "/"){

            return new Value ( newLeft.value / newRight.value )

        }else if(this.operator == "%"){

            return new Value ( newLeft.value % newRight.value )

        }
        // Relacionales  
        else if(this.operator == "<"){

            return new Value ( newLeft.value < newRight.value ? 1 : 0 )

        }else if(this.operator == ">"){

            return new Value ( newLeft.value > newRight.value ? 1 : 0 )

        }else if(this.operator == "<="){

            return new Value ( newLeft.value <= newRight.value ? 1 : 0 )

        }else if(this.operator == ">="){;

            return new Value ( newLeft.value >= newRight.value ? 1 : 0 )

        }
        // Logicas
        else if(this.operator == "=="){

            return new Value ( newLeft.value == newRight.value ? 1 : 0 )

        }else if(this.operator == "!="){

            return new Value ( newLeft.value != newRight.value ? 1 : 0 )

        }

        return new Value(0)
    }
}
