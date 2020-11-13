// let Cycle = require('./Cycle').Cycle

class Main  {
    constructor (mainList) {
        this.mainList = new Array()
        this.labelList = {}
        this.methodList = {}
        this.mainOptList = []
        this.originalMainList = [... mainList]

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

    optCode = function (){
        this.mainOptList = [... this.originalMainList]
        this.optCode1()
        console.log(this.originalMainList)
        console.log(this.mainOptList)
    }

    optCode1 = function () {

        let beg = -1
        let gotoLabel = ''
        let removeList = []

        for(let index = 0 ; index < this.mainOptList.length ; index++){
            let node = this.mainOptList[index]
            if (node instanceof Goto) {
                beg = index
                gotoLabel = node.name

                let auxIndex = index + 1

                while (!(this.mainOptList[auxIndex] instanceof Label)) {
                    auxIndex++
                }

                if (auxIndex != index + 1) {
                    if (this.mainOptList[auxIndex].name === node.name) {
                        this.mainOptList.splice(index, auxIndex - index)
                    } else {
                        this.mainOptList.splice(index + 1, auxIndex - index -1)
                    }
                }

            }
        }
    }

    printCode = function (){
        let optCode = ''

        this.mainOptList.forEach((node, index) =>{
            try {
                optCode += node.toString()
            }catch (e) {
               console.log('lina de codigo opt',index)
            }

        })

        return optCode
    }

}

