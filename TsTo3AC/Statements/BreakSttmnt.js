/* eslint-disable */

// const { Node } = require('../Node')

class BreakSttmnt extends Node {
    constructor (line, column) {
        super(line, column)
    }
    exec = function () {

        this.setNewCode(`\n// break`)
        this.setNewCode(`\n\tgoto ${Node.breakTag};`)

    }
}



