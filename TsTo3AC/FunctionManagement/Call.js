



class Call extends Node {
    constructor(name, parameters, line, column, obj) {
        super(line, column)

        this.name = name
        this.parameters = parameters
        this.obj = obj
    }


    exec = function (scope) {


        this.scope = new Scope(scope.getRootScope())
        this.scope.obj = scope.getRootScope().obj

        if (this.obj) {

            let id = new GetId(this.obj)
            var idValue = id.exec(scope)
            this.parcialCode += id.parcialCode

            var actualObj = idValue.type


        }

        let classObj = actualObj || this.scope.obj

        let actualFunction = Scope.functions[`${this.name.name}_`]
        if (!actualFunction) {
            this.addError('funcion no encontrada. nombre o numero de parametros incorrectos')
            return
        }

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


        } else if (this.parameters.every(parameter => parameter.name != undefined)) {
            console.log('Expressions && names')
        } else {
            this.addError('todos los parametros deben d ser les mismo tipo, por posicion o por nombre')

        }

        Node.relativeP -= jumpP

        let callName = `${this.name.name}_${newName}`

        this.setNewCode(`\n${callName}();\n`)

        this.setNewCode(`${this.getNewTemporal()} = p - 1;`)

        this.setNewCode(`${this.getNewTemporal()} = Stack[(int)${this.getThisTemporal(-1)}];`)

        this.setNewCode(`p =  p - ${jumpP};`)


        return new Symbol(actualFunction.type, this.getThisTemporal())

    }
}

