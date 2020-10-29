//
// let Method = require('./Method').Method

class CodeCall {
    constructor (name) {
        this.name = name
    }

    exec = function (mainList) {

        // mainList.forEach((node) => {
        //
        //     if (node instanceof Method && (node).name == this.name) {
        //         node.exec(mainList)
        //     }
        //
        // })

        return this.name

    }

}


