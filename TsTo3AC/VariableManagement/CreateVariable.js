
class CreateVariable extends Node{

    constructor(name, type, value, line, column) {
        super(line, column);

        this.type = type
        this.name = name
        this.value = value
        this.index = -1
    }

    exec = function (scope, state, addTo, global) {

        this.scope = scope || this.scope

        let retTemp = ''


            this.setNewCode(`// Expresion para ${this.name}`)

            let expValue = new Symbol()
            if(this.value){
                expValue = this.value.exec(this.scope)
                // expValue.concatCode()
                this.setNewCode(this.value.getParcialCode())
                this.value.parcialCode = ''
            }else{
                this.setNewCode(`${this.getNewTemporal()} = ${this.getDefVal()};`)
            }

            this.setNewCode(`// Apuntador hacia espacio en variable ${this.name}`)


        let index = this.scope.getNewIndex()
        if(this.scope.root){
            this.setNewCode(`${this.getNewTemporal()} = p + ${index };`)
        }else{
            this.setNewCode(`${this.getNewTemporal()} = p ${ (index - Node.globalOffset)  > 0 ? "+ " + (index - Node.globalOffset) : '- ' + ((index - Node.globalOffset)*-1) };`)

        }


        retTemp = this.getThisTemporal()

            this.setNewCode(`// Asignando valor a variable ${this.name}`)
            this.setNewCode(`Stack[(int)${this.getThisTemporal()}] = ${expValue.value};`)

            if(!addTo){
                this.scope.varList[this.name] = {
                    index : this.scope.getNewIndex(),
                    type : this.type
                }
            }else{
                this.scope.varList[addTo + '.' + this.name] = {
                    index : this.scope.getNewIndex(),
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


}