
class Expression extends Node {
    constructor (value, line, column) {
        super(line, column)

        this.value = value
    }


    exec = function(scope) {
        if(this.value instanceof Symbol ){
            if(this.value.type === 'string'){
                this.value.getValue(scope)
                this.parcialCode += this.value.getParcialCode()

                return this.value
            }


            this.parcialCode += `${this.getNewTemporal()} = ${this.value.getValue()};`
            this.value.parcialCode = this.parcialCode
            return this.value
        }else{
            let retValue = this.value.exec(scope)

            this.parcialCode += this.value.getParcialCode()
            return retValue
        }
    }
}
