
class CaseSttmnt extends Node{
    constructor(value, list, line, column) {
        super(line, column);
        this.value = value
        this.list = list

    }
    exec = function (scope){
        this.scope.root = scope

        this.caseLabel = this.getNewLabel()
        this.setNewCode(`${this.caseLabel}:`)
        this.list.exec(this.scope)
        this.setNewCode(this.list.parcialCode)
    }
}