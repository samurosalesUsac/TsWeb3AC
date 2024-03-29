
class Unary extends Node{
    constructor(exp, line, column) {
        super(line, column);
        this.exp = exp
    }

    exec = function (scope) {
        let newExp = this.exp.exec(scope)
        this.setNewCode(this.exp.parcialCode)

        if(newExp.type == 'number'){
            this.setNewCode(`${this.getNewTemporal()} = 0 - ${newExp.getValue()};`)

            return new Symbol('number',  this.getThisTemporal())
        }else{
            ErrorList = ErrorList.concat({
                type : 'Semantico',
                description : `un valor no numerico no puede ser negativo`,
                line : this.line,
                column : this.column});
            return new Symbol("Error")
        }
        return  new Symbol("Error")
    }
}