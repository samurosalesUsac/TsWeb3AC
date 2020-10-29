3

class Cycle {
    constructor (nodeList) {
        this.nodeList = nodeList
    }



execCicle = function (mainList , startLabel) {

    let start = (startLabel == undefined) ? true : false;

    if (startLabel == undefined) {

        for (let i = 0; i < this.nodeList.length; i++) {

            let value = this.nodeList[i].exec(mainList)

            if (value != undefined) {
                return value
            }
        }
    } else {

        for (let i = 0; i < this.nodeList.length; i++) {

            if ((this.nodeList[i]).label == startLabel) {
                start = true
            }
            if (start) {
                let value = this.nodeList[i].exec(mainList)
                if (value != undefined) {
                    return value
                }
            }


        }
    }

}

}

