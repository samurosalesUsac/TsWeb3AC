/* eslint-disable */


class Scope {
    constructor (root){
        this.root = root || false

        this.varList = {}
        this.structList = {}
        this.param = false
        this.obj = ''
        this.classes = {} 
    }

    static functions = new Array()
 
    getNewIndex = function(){
        if(!this.root){
            return  Object.keys(this.varList).length
        }else{
            let index = Object.keys(this.varList).length
            let aux = this.root
            while (aux.root && !aux.param) {
                index += Object.keys(aux.varList).length 
                aux = aux.root
            }
            return index
        }
        
    }

    getObjClass = function (name) {
        let rootSc = this.getRootScope()
        return this.getRootScope().classes[name] 

    }

    getVariable = function (name) {

        let variable = this.varList[name]

        if(variable){
            return this.varList[name]
        }else{
            let aux  = this.root

            while (aux.root) {

                variable = aux.varList[name]

                if(variable){
                    return aux.varList[name]               
                }
                aux = aux.root
            }

        }

    }

    getGlobalVariable = function (name){
        let scope = this.getRootScope()

        let variable = scope.varList[name]
        return variable
    } 

    getRootScope = function () {
        if(!this.root){
            return this
        }else{
            
            let aux = this.root
            while (aux.root) {
                
                aux = aux.root
            }
            return aux
            
        }
    }

}
