
class AssignVariable extends Node{

    constructor(id, value, line, column) {
        super(line, column);

        this.id = id
        this.value = value
        this.index = -1
    }

    exec = function (scope, state, addTo, global) {

        this.scope = scope || this.scope

        let retTemp = ''


        this.setNewCode(`// Expresion para ${this.id.name}`)

        let expValue = this.value.exec(this.scope)
            // expValue.concatCode()
            this.setNewCode(this.value.getParcialCode())
            this.value.parcialCode = ''

        this.setNewCode(`// Apuntador hacia espacio en variable ${this.id.name}`)

        let variable = this.id.exec(this.scope)
        this.setNewCode(this.id.getParcialCode())
        this.id.parcialCode = ''


        retTemp = this.getThisTemporal()

            this.setNewCode(`// Asignando valor a variable ${this.id.name}`)
        if(!variable.heap){
            this.setNewCode(`Stack[(int)${variable.index}] = ${expValue.value};`)
        }else{
            this.setNewCode(`Heap[(int)${variable.index}] = ${expValue.value};`)
        }

        if(variable.type != expValue.type){

            //error
            ErrorList = ErrorList.concat({
                type : 'Semantico',
                description : `tipo no coinside para ASIGNAR a variciable ${this.id.name}`,
                line : this.line,
                column : this.column});

            this.parcialCode = ''
            return new Symbol()

        }

            // if(!addTo){
            //     this.scope.varList[this.name] = {
            //         index : this.scope.getNewIndex(),
            //         type : this.type
            //     }
            // }else{
            //     this.scope.varList[addTo + '.' + this.name] = {
            //         index : this.scope.getNewIndex(),
            //         type : this.type
            //     }
            // }


        return retTemp

    }

    getDefVal = function (){
        switch (this.type) {
            case "number":
                return 0
            case "string":
                return -1
            case "digit":
                return 0.0
            case "boolean":
                return 0
            case "null":
                return -1
            default :
                return -1
        }
    }


}