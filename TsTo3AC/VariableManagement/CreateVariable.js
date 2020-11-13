
class CreateVariable extends Node{

    constructor(name, type, value, line, column) {
        super(line, column);

        this.type = type
        this.name = name
        this.value = value
        this.newIndex = -1
        this.index = -1
    }

    exec = function (scope, state, addTo, global) {

        this.scope = scope || this.scope

        let retTemp = ''


            this.setNewCode(`// Expresion para ~${this.name}`)

            let expValue = new Symbol()
            if(this.value){
                expValue = this.value.exec(this.scope)
                // expValue.concatCode()
                this.setNewCode(this.value.getParcialCode())
                this.value.parcialCode = ''
            }else{
                this.setNewCode(`${this.getNewTemporal()} = ${this.getDefVal()};`)
                expValue.value = this.getThisTemporal()
            }

            this.setNewCode(`// Apuntador hacia espacio en variable ~${this.name}`)

        if(expValue.type != this.type){

            //error
            ErrorList = ErrorList.concat({
                type : 'Semantico',
                description : `tipo no coinside para CREAR a variable ${this.name}`,
                line : this.line,
                column : this.column});
            this.parcialCode = ''
            return new Symbol()

        }

    if(!global){

        this.newIndex = this.scope.getNewIndex()

    }

        if(this.scope.root){
            this.setNewCode(`${this.getNewTemporal()} = p + ${this.newIndex };`)
        }else{
            this.setNewCode(`${this.getNewTemporal()} = p ${ (this.newIndex - Node.globalOffset)  > 0 ? "+ " + (this.newIndex - Node.globalOffset) : '- ' + ((this.newIndex - Node.globalOffset)*-1) };`)

        }

        retTemp = this.getThisTemporal()

            this.setNewCode(`// Asignando valor a variable ~${this.name}`)
            this.setNewCode(`Stack[(int)${retTemp}] = ${expValue.value};\n`)

            if(!addTo){
                this.scope.varList[this.name] = {
                    index : this.newIndex,
                    type : this.type
                }
            }else{
                this.scope.varList[addTo + '.' + this.name] = {
                    index : this.newIndex,
                    type : this.type
                }
            }


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

    setIndex = function (scope){
        this.newIndex = scope.getNewIndex()
        scope.varList[this.name] = {
            index : this.newIndex,
            type : this.type
        }

    }


}