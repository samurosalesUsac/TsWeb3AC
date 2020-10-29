
class MainScope extends Node{
    constructor(list) {
        super()
       this.list = list
    }

    exec = function () {
        let theWholeShebang = ''

        let functionsCode = this.declareFunctions()

        let head = this.createHead()

        Node.globalOffset = head + 3

        let mainCode = this.list.exec(this.scope).parcialCode

        theWholeShebang  += `

#include <stdio.h>

double Heap[16384]; //Estructura para heap 
double Stack[16394]; //Estructura para stack 
double p = ${head + 3}; // Puntero p
double h = ${head + 3}; // Puntero h
double ${this.temporalList()}; //Lista de temporales utilizados 


${functionsCode}


int main()
{
    Stack[(int)p - 2] = 0;
    Heap[2] = -1;
    
    ${this.getGlobalObj(head)}
    
\n${mainCode.replace(/^/gm, "\t")}\n
    return 0;
}

`
        Node.clean()
        return theWholeShebang
    }

    temporalList = function (){
        let str = '_t0'
        for (let i = 1 ; i <= Node.tIndex ; i++){
            str += `, _t${i}`
        }
        return str
    }

    declareFunctions = function () {

        this.list.list.forEach((element, index )=>{
            if(element instanceof Function){


                let newName = ''
                // let params = new Array()

                element.parameters.forEach(param =>{

                    newName += param.type + "_"
                    // params.push(param.type)

                })


                let nname = element.name

                this.list.list[index].name = `${element.name}_${newName}`
                //
                // if(Scope.functions[`${element.name}_`]){
                //
                //     Scope.functions[`${nname}_`].push(element)
                //
                // }else{

                    Scope.functions[`${nname}_`] = element

                // }



            }
        })



        let code = ''
        let newArr = []
        this.list.list.forEach((element, index )=>{
            if(element instanceof Function){

                element.exec(this.scope)
                code += element.parcialCode

            }else{
                newArr.push(element)
            }
        })

        this.list.list = newArr


        return code

    }

    createHead = function (){

        let count = 0

        this.list.list.forEach((element, index )=>{
            if(element instanceof CreateVariable){
                count++
            }
        })

        return count

    }

    getGlobalObj = function (count){
        let code = ''

        for(let i = 2; i < count + 2; i++ ){
            code += `Heap[${i + 1}] = ${i - 2};\n\t`
        }
        return code
    }
}

