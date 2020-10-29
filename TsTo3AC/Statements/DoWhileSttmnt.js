// const { Node } = require('../Node')



class DoWhileSttmnt extends  Node {
    constructor (value, list,  line, column) {
        super(line, column)

        this.value = value
        this.list = list

    }
    
    exec = function (scope) {

        let breakAux = Node.breakTag
        let continueAux = Node.continueTag

        this.setNewCode(`// Do While`)
        Node.breakTag = this.getNewLabel()
        this.setNewLabel()
        let label = this.getThisLabel()
        Node.continueTag = label

        this.list.exec(scope)
        this.setNewCode(this.list.getParcialCode())

        this.value.exec(scope)
        this.setNewCode(this.value.getParcialCode())
        let boolTemporal =  this.getThisTemporal()
        
        this.setNewCode("if (" + boolTemporal + " == 1) goto " + label + ";")
        
        this.setNewCode(`${Node.breakTag}: // Do While End Tag.`)

        Node.breakTag = breakAux
        Node.continueTag = continueAux

     

    }

}

