



class Call extends Node {
    constructor(name, parameters, line, column, obj) {
        super(line, column)

        this.name = name
        this.parameters = parameters
        this.obj = obj
    }


    exec = function (scope) {

        this.scope.root = scope

        if(this.name instanceof ObjectAccess){

            let idValue = this.name.id.exec(this.scope)
            if(idValue.type == 'string'){
                if(this.name.attribute == 'concat'){
                    if(this.parameters.length == 1){

                        this.setNewCode(this.name.id.parcialCode)

                        let seconfPar = this.parameters[0].exec(this.scope)
                        this.setNewCode(this.parameters[0].parcialCode)

                        let newParam = [idValue, seconfPar]
                        let callString = new Call({name : `__call_concatString__`}, newParam)
                        let tag = callString.exec(this.scope)
                        this.setNewCode(callString.parcialCode)

                        return new Symbol("string", tag.value, this.line, this.column)
                    }
                }
                if(this.name.attribute == 'touppercase'){
                    if(this.parameters.length == 0){
                        this.setNewCode(this.name.id.parcialCode)
                        let newParam = [idValue]
                        let callString = new Call({name : `__call_stringToUpperCase__`}, newParam)
                        let tag = callString.exec(this.scope)
                        this.setNewCode(callString.parcialCode)

                        return new Symbol("string", tag.value, this.line, this.column)
                    }
                }
                if(this.name.attribute == 'tolowercase'){
                    if(this.parameters.length == 0){
                        this.setNewCode(this.name.id.parcialCode)
                        let newParam = [idValue]
                        let callString = new Call({name : `__call_stringToLowerCase__`}, newParam)
                        let tag = callString.exec(this.scope)
                        this.setNewCode(callString.parcialCode)

                        return new Symbol("string", tag.value, this.line, this.column)
                    }
                }

                if(this.name.attribute == 'charat'){
                    if(this.parameters.length == 1){
                        idValue.parcialCode = this.name.id.parcialCode
                        // let newParam = [idValu]
                        // let callString = new Call({name : `__call_stringToLowerCase__`}, newParam)
                        // let tag = callString.exec(this.scope)
                        // this.setNewCode(callString.parcialCode)


                        let getChar = new VectorialAccess(idValue,this.parameters[0], this.line, this.column)
                        let aCharResult = getChar.exec(this.scope)
                        this.setNewCode(getChar.parcialCode)

                        let index = this.getNewTemporal()
                        this.setNewCode(`${index} = h;`)
                        this.setNewCode(`Heap[(int) ${index}] = 1;`)
                        this.setNewCode(`${this.getNewTemporal()} = ${index} + 1;`)
                        this.setNewCode(`Heap[(int) ${this.getThisTemporal()}] = ${aCharResult.value};`)
                        this.setNewCode(`${this.getThisTemporal()} = ${this.getThisTemporal()} + 1;`)
                        this.setNewCode(`Heap[(int) ${this.getThisTemporal()}] = -1;`)
                        this.setNewCode(`${this.getThisTemporal()} = ${this.getThisTemporal()} + 1;`)
                        this.setNewCode(`h = ${this.getThisTemporal()};`)

                        return new Symbol("string", index, this.line, this.column)
                    }
                }
            }

            return new Symbol()
        }

        this.scope = new Scope(scope.getRootScope())
        this.scope.obj = scope.getRootScope().obj

        if (this.obj) {

            let id = new GetId(this.obj)
            var idValue = id.exec(this.scope)
            this.parcialCode += id.parcialCode

            var actualObj = idValue.type


        }

        let classObj = actualObj || this.scope.obj

        let actualFunction = Scope.functions[`${this.name.name}_`]
        if (!actualFunction) {
            ErrorList = ErrorList.concat({
                type : 'Semantico',
                description : `funcion no encontrada ${this.name.name}`,
                line : this.line,
                column : this.column});
            return
        }


        // for(let i = 0; i< this.parameters.length; i++){
        //     let val = this.parameters[i].exec(scope)
        //     this.setNewCode(this.parameters[i].parcialCode)
        //     this.parameters[i] = val
        // }

        let jumpP = scope.getNewIndex() + this.parameters.length + 3 //(return, this, super)
        this.setNewCode(`\np = p + ${jumpP}; \t // p en inicio de metodo -> salto + parametros + return`)

        Node.relativeP += jumpP
        let newName = ''

        if (idValue) {

            this.setNewCode(`${idValue.value} = ${idValue.value} + 2; // no se necesitan verificar`)

            this.setNewLabel()

            this.setNewCode(`${this.getNewTemporal()} = Heap[(int)${idValue.value}];`)

            this.setNewCode("if (" + this.getThisTemporal() + " == 0) goto " + this.getThisLabel(1) + ";")

            this.setNewCode(`${idValue.value} = ${idValue.value} + 1; // no se necesitan verificar`)

            this.setNewCode("goto " + this.getThisLabel() + ";")

            this.setNewLabel()

            this.setNewCode(`${idValue.value} = ${idValue.value} + 2; // no se necesitan verificar`)


            this.setNewCode(`${this.getNewTemporal()} = p - ${this.parameters.length + 2}; // espacio para this`)
            this.setNewCode(`Stack[(int)${this.getThisTemporal()}] = ${idValue.value};`)
        }


        if (this.parameters.every(parameter => parameter.name == undefined)) {

            // Node.relativeP += Node.globalOffset
            this.parameters.forEach((element, index) => {

                this.setNewCode(`\n\t// parametro -> ${index + 1}`) // retorn en - length

                let param = element.exec(scope)
                newName += param.type + "_"

                // let res = this.getThisTemporal()
                this.setNewCode(element.getParcialCode())
                this.setNewCode(`${this.getNewTemporal()} = p - ${index + 2};`) // quite un + 4
                this.setNewCode(`Stack[(int)${this.getThisTemporal()}] = ${param.value};`)

                // actualFunction.scope.varList[actualFunction.parameters[index].name] = {
                //     index : - (index + 1) ,
                //     type : element.type
                // }

            });

            // Node.relativeP -= Node.globalOffset

        } else if (this.parameters.every(parameter => parameter.name != undefined)) {
            console.log('Expressions && names')
        } else {
            this.addError('todos los parametros deben d ser les mismo tipo, por posicion o por nombre')

        }

        Node.relativeP -= jumpP

        let callName = `${this.name.name}_${newName}`

        this.setNewCode(`\n${callName.replace(/\[]/gm, "")}();\n`)

        this.setNewCode(`${this.getNewTemporal()} = p - 1;`)

        this.setNewCode(`${this.getNewTemporal()} = Stack[(int)${this.getThisTemporal(-1)}];`)

        this.setNewCode(`p =  p - ${jumpP};`)


        return new Symbol(actualFunction.type, this.getThisTemporal())

    }
}

