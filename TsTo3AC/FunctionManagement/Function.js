// const { Scope } = require('../Scope')
// const { Node } = require('../Node')

class Function extends Node {
    constructor (type, name, parameters, body, line, column) {
        super(line, column)

        this.type = type
        this.name = name
        this.parameters =  parameters
        this.body = body
    }
    
    exec = function (scope) {
        
        this.scope.root = scope

        let endTag = this.getNewLabel()

        Node.funcEndLab = endTag

        this.setNewCode(`\nvoid ${this.name} (){\n`)

        this.scope = new Scope(scope)

        this.parameters.forEach((element, index) => {
            this.scope.varList[element.name] = {
                index : - (index + 2  ) ,
                // index : index,
                type : element.type
            }
        });
        
        this.scope.param = true

        this.scope = new Scope(this.scope)


        Node.breakTag = this.parameters.length + 1
        this.body.exec(this.scope)
        this.parcialCode += this.body.getParcialCode()
        Node.breakTag = undefined

        this.parcialCode = this.parcialCode.replace(/^/gm, "\t")
        this.parcialCode = this.parcialCode.replace(/void/gm, "\nvoid")

        this.setNewCode(`${endTag}:\n\treturn;\n}\n`)

        

        return this
    }
    

}

