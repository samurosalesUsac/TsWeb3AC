/* eslint-disable */

// const { Node } = require('../Node')

class PrintSttmnt extends Node {
     constructor (value, line, column) {
          super(line, column)

          this.value = value
     }
     
     exec = function (scope) {


        let retVal = this.value.exec(scope)

        if(retVal){

          this.parcialCode += this.value.getParcialCode()

          if(retVal.type === 'number' || retVal.type === 'let'){

               this.setNewCode(`\nprintf(\"%d\", (int)${retVal.value});`)

          }else if(retVal.type === 'digit'){

               this.setNewCode(`printf(\"%d\", ${retVal.value});`)

          }else if(retVal.type === 'char'){
               
               this.setNewCode(`printf(\"%c\", ${retVal.value});`)

          }else{
               // boolean ans String
          }

            this.setNewCode(`printf(\"\\n\");`)

        }

    }

}




