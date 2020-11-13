
class Const extends Node {
    constructor(list, line, column) {
        super(line, column);
        this.list = list
    }

    exec = function (scope, global) {
        this.list.forEach(node => {
            node.exec(scope, 'const', undefined, global)
            this.setNewCode(node.parcialCode)
        })
    };

    setIndex = function (scope){

        for(let i = 0; i < this.list.length; i++){
            this.list[i].setIndex(scope)
        }

    }

}