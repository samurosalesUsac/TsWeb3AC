// let Cycle = require('../Cycle').Cycle

class Method {
    constructor (name, mainList) {
        this.cycle = new Cycle(mainList)
        this.name = name
    }
    exec = function (mainList, label) {

        let value = this.cycle.execCicle(mainList, label)

        if (value != undefined) {
            this.exec(mainList, value.label)
        }
    }

}

