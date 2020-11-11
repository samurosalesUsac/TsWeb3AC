/* eslint-disable */

// const { Node } = require('../Node')
// const { Scope } = require('../Scope')
// const { CreateVariable } = require('../VariableManagement/CreateVariable')
// const { Function } = require('../FunctionManagement/Function')

class ObjectClass extends Node {
    constructor (name, list, line, column) {
        super(line, column)
        
        this.name = name
        this.list = list

        this.attributes = {} 

    }
    exec = function (scope) {
        // getting variables/atributes

        this.scope.obj = this.name
        this.scope.classes = scope.classes
       
        // console.log(name)
        this.list.forEach((element, index) =>{
            if(element instanceof CreateVariable){
                
                this.attributes[element.name] = this.list[index]
                this.attributes[element.name].exec(this.scope)
                
                this.attributes[element.name].parcialCode = ''
            }
        }) 



        this.list.forEach((element, index )=>{
            if(element instanceof Function){


                let newName = ''
                let params = new Array()

                element.parameters.forEach(param =>{

                    newName += param.type + "_"
                    params.push(param.type)

                })

                if(!Node.main && element.name == 'main'){
                    // Node.main = {class : this.name, name : element.name}
                    Node.main = this
                }

                let nname = element.name

                this.list[index].name = `${this.name}_${element.name}_${newName}`

                if(Scope.functions[`${this.name}_${element.name}_`]){

                    Scope.functions[`${this.name}_${nname}_`].push({params,element}) 

                }else{

                    Scope.functions[`${this.name}_${nname}_`] = new Array({params,element}) 

                }



            }
        }) 

        

        this.list.forEach((element, index )=>{
            if(element instanceof Function){
 
                element.exec(this.scope)
                this.parcialCode += element.parcialCode

            }
        }) 


        
        
        
        // this.list.forEach((element, index) =>{
        //     if(element instanceof CreateVariable){
                
        //         // this.attributes[element.name] = this.list[index]
        //         // this.attributes[element.name].exec(this.scope)
        //          this.parcialCode += this.attributes[element.name].parcialCode 
        //         // this.attributes[element.name].parcialCode = ''
        //     }
        // }) 
       
    }
}


