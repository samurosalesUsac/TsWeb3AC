
class SwitchSttmnt extends Node{
   constructor(value, list, line, column) {
      super(line, column)
       this.value = value
      this.list = list
   }

   exec = function (scope) {
      this.scope.root = scope
      let breakAux = Node.breakTag

      this.setNewCode(`// Switch`)
      Node.breakTag = this.getNewLabel()

      let valResult = this.value.exec(this.scope)
      this.setNewCode(this.value.getParcialCode())

       for(let i = 0; i< this.list.length; i++){
          this.list[i].exec(this.scope)
           if(this.list[i].value){
               let caseResult = this.list[i].value.exec(this,scope)
               this.setNewCode(this.list[i].value.parcialCode)
               this.setNewCode(`if(${valResult.value} == ${caseResult.value}) goto ${this.list[i].caseLabel};`)
           }
       }

      for(let i = 0; i< this.list.length; i++){
          if(!this.list[i].value){
              this.setNewCode(`goto ${this.list[i].caseLabel};`)
          }
      }
       for(let i = 0; i< this.list.length; i++){
           this.setNewCode(this.list[i].parcialCode)
       }
      this.setNewCode(`${Node.breakTag}: // Switch End Tag.`)
      Node.breakTag = breakAux
   };
}