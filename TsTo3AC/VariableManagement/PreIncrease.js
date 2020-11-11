
class PreIncrease extends Node{
    constructor(id, line, column) {
        super(line, column)
        this.id = id
    }

    exec = function (scope) {
        this.scope.root = scope;

        this.setNewCode(`\n// PreIncrease`)
        let valResult = this.id.exec(this.scope)
        this.setNewCode(this.id.parcialCode)
        this.setNewCode(`\n`)
        if(valResult.type == 'number'){
            this.setNewCode(`Stack[(int)${valResult.index}] = ${valResult.value} + 1;`)
            this.setNewCode(`${this.getNewTemporal()} = Stack[(int)${valResult.index}];`)
            valResult.value = this.getThisTemporal()
        }else{
            //error
        }


        return valResult
    }
}