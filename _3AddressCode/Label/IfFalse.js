// let Value = require('../CodeLine/Value')
// let Goto = require('./Goto')

class IfFalse {
	constructor (node, label) {
		this.node = node
		this.label = label
	}
	exec = function () {

		let val = this.node.exec(this.scope)

		if (val.value == 0) {
			return this.label
		}
	}
}

