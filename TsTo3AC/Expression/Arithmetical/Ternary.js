
class Ternary extends Node{
   constructor(boolOp, left, right, line, column) {
       super(line, column);
       this.boolOp = boolOp
       this.left = left
       this.right = right
   }

   exec = function (scope) {


       let actualLeft = this.left.exec(scope)
       let actualRight = this.right.exec(scope)

       if(this.right instanceof Call){
           this.parcialCode += this.right.parcialCode
           this.parcialCode += this.left.parcialCode
       }else{
           this.parcialCode += this.left.parcialCode
           this.parcialCode += this.right.parcialCode
       }

       let boolVal = this.boolOp.exec(scope)

       if (boolVal.type == 'boolean') {

           this.setNewCode(this.boolOp.parcialCode)
           let retTag = this.getNewTemporal()
           this.setNewCode(`if(${boolVal.value} == 0) goto ${this.getThisLabel(1)} ;`)
           this.setNewCode(`${retTag} = ${actualLeft.value};`)
           this.setNewCode(`goto ${this.getThisLabel(2)};`)
           this.setNewLabel()
           this.setNewCode(`${retTag} = ${actualRight.value};`)
           this.setNewLabel()

           // this.concatCode()
           return new Symbol(actualLeft.type === actualRight.type ? actualLeft.type : '', retTag)


       } else if (actualLeft.type != "Error" && actualRight.type != "Error") {

           // this.setError(
           //     "los tipos de dato : "
           //     + actualLeft.type + " y " + actualRight.type +
           //     "no son operables por el operador: " + this.operator)

           return new Symbol("Error")


       }

       return new Symbol()
   }
}