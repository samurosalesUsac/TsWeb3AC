
class VectorialAccess extends Node{
    constructor(id, place, line, column) {
        super(line. column)
        this.place = place
        this.id = id
    }

    exec = function (scope) {
        this.scope.root = scope;

        let idValue = this.id.exec(this.scope)


        if(idValue.type == 'string' || idValue.type.indexOf('[') != -1){
            let placeExp = this.place.exec(this.scope)

            if(placeExp.type == 'number'){

                this.setNewCode(`\n// acceso a ${placeExp.value}\n`)
                this.setNewCode(this.id.parcialCode)
                this.setNewCode(this.place.parcialCode)

                let index = this.getNewTemporal()
                this.setNewCode(`${index} = ${idValue.value};`)

                let value =  this.getNewTemporal()
                this.setNewCode(`if(${index} < 0) goto ${this.getNewLabel()};`)

                this.setNewCode(`${this.getNewTemporal()} = Heap[(int) ${index}];`)
                this.setNewCode(`if(${placeExp.value} >= ${this.getThisTemporal()}) goto ${this.getThisLabel()};`)
                this.setNewCode(`${index} = ${index} + 1;`)
                this.setNewCode(`${index} = ${index} + ${placeExp.value};`)
                this.setNewCode(`${value} = Heap[(int) ${index}];`)

                this.setNewCode(`goto ${this.getThisLabel(1)};`)
                this.setNewCode(`${this.getThisLabel()}:`)
                this.setNewCode(`${value} = -1;`)
                this.setNewLabel()



                let retVal = new Symbol(idValue.type.replace('[]',''), value)
                retVal.index = index
                retVal.heap = true
                return retVal

            }
        }else {
            ErrorList = ErrorList.concat({
                type : 'Semantico',
                description : `variable no vectorial`,
                line : this.line,
                column : this.column});
        }

        return new Symbol()

    }
}