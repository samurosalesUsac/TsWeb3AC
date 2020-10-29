// const { Node } = require('../Node')

class WhileSttmnt extends Node {
    constructor (value, list,  line, column) {
        super(line, column)

        this.value = value
        this.list = list

    }

    exec = function (scope) {

        this.scope.root = scope


        let breakAux = Node.breakTag
        let continueAux = Node.continueTag


        Node.breakTag = this.getNewLabel()

        this.setNewLabel()
        let label = this.getThisLabel()
        Node.continueTag = label

        this.value.exec(this.scope)
        this.setNewCode(this.value.getParcialCode())
        let boolTemporal =  this.getThisTemporal()
        this.list.exec(this.scope)


        this.setNewCode("if (" + boolTemporal + " == 0) goto " + Node.breakTag + ";")
        this.setNewCode(this.list.getParcialCode())

        this.setNewCode(`goto ${label};`)
        this.setNewCode(Node.breakTag + ":\n")

        Node.breakTag = breakAux
        Node.continueTag = continueAux

    }

}

