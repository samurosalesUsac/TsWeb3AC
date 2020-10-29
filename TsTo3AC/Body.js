
// const { Node } =  require('./Node')
// const { Struct } =  require('./StructManagement/Struct')

class Body extends Node {
    constructor (list) {
        super(-1,-1)
        this.list = list
    }

    exec = function (scope) {

        this.list.forEach(element => {
            // if(element instanceof Struct){
            //     scope.structList[element.name] = element
            // }else{
                if(element.exec){
                    element.exec(scope)
                    this.setNewCode(element.getParcialCode()) 
                }
                
            // }
        });
        return this
    }

}
