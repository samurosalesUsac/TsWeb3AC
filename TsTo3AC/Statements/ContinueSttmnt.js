/* eslint-disable */

// const { Node } = require('../Node')

class ContinueSttmnt extends Node {
    constructor (line, column) {
        super(line, column)
    }
    exec = function () {

        this.setNewCode(`\n// continue`)
        this.setNewCode(`\n\tgoto ${Node.continueTag};`)

    }
}



