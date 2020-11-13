/* eslint-disable */

// const { Node } = require('../Node')

class PrintSttmnt extends Node {
     constructor (value, line, column) {
          super(line, column)

          this.value = value
     }
     
     exec = function (scope) {


         this.scope.root = scope
        this.value.forEach(node =>{
    let retVal = node.exec(this.scope)

    if(retVal){

        this.parcialCode += node.getParcialCode()

        if(retVal.type === 'number' || retVal.type === 'let'){

            this.setNewCode(`\nprintf(\"%f\", ${retVal.value});`)

        }else if(retVal.type === 'boolean'){

            this.setNewCode(`\n// imprimir booleanos`)

            let callBoolean = new Call({name : `__call_printBoolean__`}, new Array(retVal))
            callBoolean.exec(this.scope)
            this.setNewCode(callBoolean.parcialCode)

        }else if(retVal.type === 'string'){

            this.setNewCode(`\n// imprimir string`)

            let callString = new Call({name : `__call_printString__`}, new Array(new Symbol('string', retVal.value)))
            callString.exec(this.scope)
            this.setNewCode(callString.parcialCode)


        }else{
            // boolean ans String
        }

    }
    })






         this.setNewCode(`printf(\"%c\", 10);`)
         // this.setNewCode(`printf(\"\\n\");`)
    }

}




