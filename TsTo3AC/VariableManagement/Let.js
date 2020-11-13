
class Let extends Node {
    constructor(list, line, column) {
        super(line, column);
        this.list = list
    }

    exec = function (scope, global) {
        this.list.forEach(node =>{
            node.exec(scope, 'let', undefined, global)
            this.setNewCode(node.parcialCode)
        })
    }


    setIndex = function (scope){

        for(let i = 0; i < this.list.length; i++){
            this.list[i].setIndex(scope)
        }

    }

}