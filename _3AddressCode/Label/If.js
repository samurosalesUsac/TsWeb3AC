// let Value = require('../CodeLine/Value')
// let Goto = require('./Goto')

class If {
	constructor (node, label) {
		this.node = node
		this.label = label
	}

	exec = function () {

		let val = this.node.exec(this.scope)

		if (val.value == 1) {
			return this.label
		}
	}
}

