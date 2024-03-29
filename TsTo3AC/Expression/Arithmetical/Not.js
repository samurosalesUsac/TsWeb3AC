
class Not extends Node{
    constructor(exp, line, column) {
        super(line, column);
        this.exp = exp
    }

    exec = function (scope) {
        let newExp = this.exp.exec(scope)
        this.setNewCode(this.exp.parcialCode)

        if(newExp.type == 'boolean'){

            let ternaryOp = new Ternary(newExp,new Symbol('boolean', 0), new Symbol('boolean', 1), this.line, this.column)
            let terResult = ternaryOp.exec(scope)
            this.setNewCode(ternaryOp.parcialCode)

            return new Symbol('boolean', terResult.value )

        }else{
            ErrorList = ErrorList.concat({
                type : 'Semantico',
                description : `no se puede realizar Not '!' de una variable no booleana`,
                line : this.line,
                column : this.column});
            return new Symbol("Error")
        }
        return new Symbol("Error")
    }
}