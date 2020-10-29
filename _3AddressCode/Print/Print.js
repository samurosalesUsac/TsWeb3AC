
class Print {
    constructor (parameter, temporal) {
        this.parameter = parameter
        this.temporal = temporal
    }

    exec = function () {


        // console.log(TemporalCall.scope[0])
        // console.log(SetStack.stack)
        // console.log(SetHeap.heap)
        let val = this.temporal.exec()

        if(this.parameter == "\"%c\""){

            console.log(String.fromCharCode(val.value))

        }else if(this.parameter == "\"%i\""){

            let num = parseInt(val.value.toString())
            console.log(num.toFixed())

        }else if(this.parameter == "\"%d\""){

            let numfix = parseFloat(val.value)
            console.log(numfix)

        }


    }

}


