// const { Node } = require('../Node')

class ForSttmnt extends  Node {
    constructor (dec, ver, inc, list, line, column) {
    
    super(line, column)

    this.dec = dec
    this.ver = ver
    this.inc = inc

    this.list = list

    }

    exec = function (scope) {

        this.scope.root = scope

        let breakAux = Node.breakTag
        let continueAux = Node.continueTag
        Node.continueTag = this.getNewLabel()

        this.setNewCode('\t//  For Stt');

        if (this.dec) {
            this.dec.exec(this.scope)
            this.parcialCode += this.dec.parcialCode
        }


        Node.breakTag = this.getNewLabel()

        this.setNewLabel()
        let label = this.getThisLabel()

        if (this.ver) {
            this.ver.exec(this.scope)
            this.setNewCode(this.ver.getParcialCode())
            var boolTemporal = this.getThisTemporal()
        }

        this.list.exec(this.scope)

        if (this.ver)
            this.setNewCode("if (" + boolTemporal + " == 0) goto " + Node.breakTag + ";")

        this.setNewCode(this.list.getParcialCode())

        this.setNewCode(`${Node.continueTag}:`)

        if (this.inc) {
            this.inc.exec(this.scope)
            this.parcialCode += this.inc.parcialCode
        }

        this.setNewCode(`goto ${label};`)
        this.setNewCode(Node.breakTag + ":\n")

        Node.breakTag = breakAux
        Node.continueTag = continueAux
    };
}

