// const { Node } = require('../Node')

class ForOfSttmnt extends  Node {
    constructor (dec, array, list, line, column) {
    
    super(line, column)

    this.dec = dec
    this.array = array
    this.list = list

    }

    exec = function (scope) {

        this.scope.root = scope

        let breakAux = Node.breakTag
        let continueAux = Node.continueTag
        Node.continueTag = this.getNewLabel()

        this.setNewCode('\t//  For Of Stt');


        let arrResult = this.array.exec(this.scope)
        this.setNewCode(this.array.parcialCode)


        let size = this.getNewTemporal()
        let index = this.getNewTemporal()
        let node = this.getNewTemporal()

        this.setNewCode(`${size} = Heap[(int) ${arrResult.value}];`)
        this.setNewCode(`${index} = 1;`)



        Node.breakTag = this.getNewLabel()

        this.setNewLabel()
        let label = this.getThisLabel()

        this.setNewCode(`${this.getNewTemporal()} = ${arrResult.value} + ${index};`)
        this.setNewCode(`${this.getNewTemporal()} = Heap[(int) ${this.getThisTemporal(-1)}];`)

        this.dec.value = new Symbol(arrResult.type == 'string' ? 'string' : arrResult.type.replace('[]',''), this.getThisTemporal())
        this.dec.exec(this.scope)
        this.parcialCode += this.dec.parcialCode


        this.list.exec(this.scope)

        this.setNewCode(`if( ${index} > ${size}) goto ${Node.breakTag};`)

        this.setNewCode(this.list.getParcialCode())

        this.setNewCode(`${Node.continueTag}:`)

        this.setNewCode(`${index} = ${index} + 1;`)

        this.setNewCode(`goto ${label};`)
        this.setNewCode(Node.breakTag + ":\n")

        Node.breakTag = breakAux
        Node.continueTag = continueAux
    };
}

