/* eslint-disable */

// const { Node } = require('../Node')

class IfSttmnt extends Node {
    
    constructor (value, list, elseIf, line, column) {
        super(line, column)

        this.value = value
        this.list = list
        this.elseIf = elseIf

    }
    
    exec = function (scope) {
        this.scope.root = scope
        

        if (!this.value && !this.elseIf) {
            // Last `else`

            this.list.exec(this.scope)
            this.setNewCode(this.list.getParcialCode())
        
        }else{
            // if sttmnt
           
            let res = this.value.exec(this.scope)
            console.log(res)
            this.setNewCode(this.value.getParcialCode())
            let boolTemporal =  res.value
            this.list.exec(this.scope)


            this.setNewCode("if (" + boolTemporal + " == 0) goto " + this.getThisLabel(1) + ";")
            this.setNewCode(this.list.getParcialCode())
            this.setNewCode("goto " + this.getThisLabel(2) + ";")
            this.setNewLabel()

            let endIf = this.getNewLabel()
            if(this.elseIf){

                this.elseIf.exec(scope)
                this.setNewCode(this.elseIf.getParcialCode())

            }

            this.setNewCode(`${endIf}:`)



        }

    }

}

