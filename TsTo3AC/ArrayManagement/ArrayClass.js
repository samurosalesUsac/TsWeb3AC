
class ArrayClass extends Node{
   constructor(list, line, column) {
       super(line, column);
       this.list = list

   }

   exec = function (scope) {
       this.scope.root = scope;

       let newArray = []

       this.list.forEach((node) => {
          newArray.push(node.exec(this.scope))
           this.setNewCode(node.parcialCode)
       })

       if(newArray.every(node => node.type == newArray[0].type)){

           this.setNewCode(`\n// Array Structure`)
           let initTag = this.getNewTemporal()
           this.setNewCode(`${initTag} = h;\n`)

           this.setNewCode(`Heap[(int) ${initTag}] = ${newArray.length};`)
           this.setNewCode(`${this.getNewTemporal()} = ${initTag} + 1;`)

           let index = this.getThisTemporal()
           newArray.forEach(node =>{

               this.setNewCode(`Heap[(int) ${index}] = ${node.value};`)
               this.setNewCode(`${index} = ${index} + 1;`)

           })

           this.setNewCode(`Heap[(int) ${index}] = -1;`)
           this.setNewCode(`h = ${index} + 1;`);

           return new Symbol(newArray[0].type + '[]', initTag)
       }else{
           // error no homongeneo
           ErrorList = ErrorList.concat({
               type : 'Semantico',
               description : `Vector con atributos de diferente tipo`,
               line : this.line,
               column : this.column});
       }
        return new Symbol()
   }
}