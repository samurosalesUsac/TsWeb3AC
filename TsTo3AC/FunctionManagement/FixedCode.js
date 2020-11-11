

class FixedCode extends  Node{
    constructor(code, lin, tin) {
        super()

        this.parcialCode = code
        this.lin = lin
        this.tin = tin

    }

    exec = function (){
        // Node.lIndex += this.lin
        // Node.tIndex += this.tin

        for(let i = 0; i < this.tin; i++){
            let tag = this.getNewTemporal()

            this.parcialCode = this.parcialCode.replace(new RegExp(`#_t${i} `,"g"), tag + ' ')
            this.parcialCode = this.parcialCode.replace(new RegExp(`#_t${i};`,"g"), tag + ';')
            this.parcialCode = this.parcialCode.replace(new RegExp(`#_t${i}]`,"g"), tag + ']')
            try {
                this.parcialCode = this.parcialCode.replace(new RegExp(`#_t${i})`,"g"), tag + ')')
            }catch (e) {

            }

        }


        this.parcialCode = this.parcialCode.replace(new RegExp(`#L0`,"g"), this.getThisLabel(0))

        for(let i = 0; i < this.lin; i++){

            let lab = this.getNewLabel()

            this.parcialCode = this.parcialCode.replace(new RegExp(`#L${i + 1}:`,"g"), lab + ':')
            this.parcialCode = this.parcialCode.replace(new RegExp(`#L${i + 1};`,"g"), lab + ';')
        }

    }
}