

class Node {
    constructor (line , column, scope = false){
        this.line = line || -1
        this.column = column || -1
        this.scope = new Scope()

        this.parcialCode = ''
        


    }


        static relativeP = 0

        static lIndex = -1
        static tIndex = -1
        static finalCode = ''
        static ErrorList = new Array()

        static falseTagIndex = -1
        static trueTagIndex = -1
        static returnTemp = -1
        static gotoCode = false

        static globalOffset = 0

        static table = new Array()

        
        static getFinalCode = function () {

            let header = 'var '
            for(let i = 0; i<= 18; i++){
                if(i >= 20) { break }
                header += `_t${i}, `
            }

            //  header += `_t${Node.tIndex};\n`

            for(let i = 0; i<= 10; i++){
                
                header += `_t${i + 1}9, `
            }

             header += `_t129;\n`
            
            header += `var Heap[(int)];\n`
            header += `var Stack[(int)];\n`

            header += `var p = 0;\n`
            header += `var h = 0;\n\n`

            return header + Node.finalCode


        }

        static clean = function () {
        
            Node.lIndex = -1
            Node.tIndex = -1
            Node.finalCode = ''
            Node.ErrorList = new Array()

            Node.falseTagIndex = -1
            Node.trueTagIndex = -1
            Node.returnTemp = -1
            Node.gotoCode = false

            Node.table = new Array()

        }


        getNewTemporal = function () {

            Node.tIndex++
            
            return "_t" + Node.tIndex
        }

        getLastLabel = function(index) {
            return "_t" + (Node.lIndex - (index || 1))
        }

        getThisLabel = function (index) {
            return "L" + (Node.lIndex + (index || 0))
        }

        setNewLabel = function () {

            Node.lIndex++
            this.parcialCode += "L" + Node.lIndex + ":\n"

        }

        getNewLabel = function () {

            Node.lIndex++
            return "L" + Node.lIndex 

        }

        getLastTemporal = function (index) {
            return "_t" + (Node.tIndex - (index != undefined ? index : 1))
        }

        getThisTemporal = function (index) {
            return "_t" + (Node.tIndex + (index | 0))
        }

        setNewCode = function (text) {

            this.parcialCode += text + '\n'

        }

        getParcialCode = function (){
            return this.parcialCode
        }

        reNewParcialCode = function (){
            Node.parcialCode = ""
            Node.tIndex = 0
            Node.lIndex = 0
        }


        cleanParcialCode = function () {
            this.parcialCode = ''
        }

        concatCodeUp = function (code) {
            Node.finalCode = ( code || this.parcialCode ) + Node.finalCode
            this.cleanParcialCode()
        }


        concatCode = function (code) {
            Node.finalCode += code || this.parcialCode 
            this.cleanParcialCode()
        }




        cleanStack = function (lenght) {
            this.setNewCode("                               // limpiando " + lenght + " espacios en stack")
            for (let i = 0; i < lenght; i++) {

                this.setNewCode(this.getNewTemporal() + " = p + " + i + ";")
                this.setNewCode("Stack [" + this.getThisTemporal + " ] = 0;")

            }
            this.setNewCode(" // ---------------------------- ")

        }

        //type 0,1,2 || 0 = 'lexical' || 1 = 'syntax' || 2 = 'semantic' 
        addError = function (description, type) { 
            let errType = ''
            switch(type || 2){

                case 0: 
                    errType = 'Lexico'
                break
                
                case 1: 
                    errType = 'Sintactico'
                break
                
                case 2: 
                    errType = 'Semantico'
                break
            }

            Node.ErrorList.push({
                type : errType,
                description : description,
                line : this.line,
                column : this.column
            })

        }


}

