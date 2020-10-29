// let Cycle = require('./Cycle').Cycle

class Main  {
    constructor (mainList) {
        this.mainList = new Array()
        this.labelList = {}
        this.methodList = {}

       mainList.forEach(node =>{
           if(node instanceof Label){
              this.labelList[node.name] = this.mainList.length
           }else if (node instanceof Begin) {
               this.methodList[node.name] = this.mainList.length
           }else{
               this.mainList.push(node)
           }
       })

        this.mainList.push(new Label('L'))
    }

    exec = function () {


        for (let i = 0; i < this.mainList.length; i++){

            let retValue = this.mainList[i].exec()
            if(retValue != undefined){
                if(this.mainList[i] instanceof Goto || this.mainList[i] instanceof If){
                    i = this.labelList[retValue] - 1
                    continue
                }else if (this.mainList[i] instanceof CodeCall) {
                    this.methodCall(this.methodList[retValue])
                }
            }

        }

    }

    methodCall = function (begin){
        for (let i = begin; i < this.mainList.length; i++){
            if(this.mainList[i] instanceof  End){
                return
            }
            let retValue = this.mainList[i].exec()
            if(retValue != undefined){
                if(this.mainList[i] instanceof Goto || this.mainList[i] instanceof If){
                    i = this.labelList[retValue] - 1
                    continue
                }else if (this.mainList[i] instanceof CodeCall) {
                    this.methodCall(this.methodList[retValue])
                }
            }
        }
    }
}

