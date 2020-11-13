class MainScope extends Node {
    constructor(list) {
        super()
        this.list = list
    }

    exec = function () {
        let theWholeShebang = ''

        this.list.forEach((element, index) => {
            if (element instanceof ObjectClass) {
                this.scope.classes[element.name] = this.list[index]
            }
        })

        this.list.forEach((element, index) => {
            if (element instanceof Let || element instanceof Const) {
                this.list[index].setIndex(this.scope)
            }
        })

        this.addFixedFunctions()

        let functionsCode = this.declareFunctions()

        let head = this.createHead()

        Node.globalOffset = head + 3

        let mainCode = ''
        for(let index = 0; index < this.list.length; index++ ){
            if(this.list[index] instanceof Let ||this.list[index] instanceof Const){
                this.list[index].exec(this.scope,true)
                mainCode += this.list[index].parcialCode
            }else{
                this.list[index].exec(this.scope)
                mainCode += this.list[index].parcialCode
            }
        }


        theWholeShebang += `

#include <stdio.h>
#include <math.h>

double Heap[16384]; //Estructura para heap 
double Stack[16394]; //Estructura para stack 
double p = ${head + 3}; // Puntero p
double h = ${head + 3}; // Puntero h
double ${this.temporalList()}; //Lista de temporales utilizados 
char decSize[] = "%.3f";

${functionsCode}
void main()
{
    Stack[(int)p - 2] = 0;
    Heap[2] = -1;
    
    ${this.getGlobalObj(head)}
    
\n${mainCode.replace(/^/gm, "\t")}\n
    return;
}

`
        Node.clean()
        return theWholeShebang
    }

    temporalList = function () {
        let str = '_t0'
        for (let i = 1; i <= Node.tIndex; i++) {
            str += `, _t${i}`
        }
        return str
    }

    declareFunctions = function () {

        this.list.forEach((element, index) => {
            if (element instanceof Function) {


                let newName = ''
                // let params = new Array()

                element.parameters.forEach(param => {

                    newName += param.type + "_"
                    // params.push(param.type)

                })


                let nname = element.name

                this.list[index].name = `${element.name}_${newName}`
                //
                // if(Scope.functions[`${element.name}_`]){
                //
                //     Scope.functions[`${nname}_`].push(element)
                //
                // }else{

                this.list[index].name = this.list[index].name.replace(/\[]/gm, "")

                Scope.functions[`${nname}_`] = element

                // }


            }
        })


        let code = ''
        let newArr = []
        this.list.forEach((element, index) => {
            if (element instanceof Function) {

                element.exec(this.scope)
                code += element.parcialCode

            } else {
                newArr.push(element)
            }
        })

        this.list = newArr


        return code

    }

    createHead = function () {

        let count = 0

        this.list.forEach((element, index) => {
            if (element instanceof Let || element instanceof Const) {
                count += element.list.length
            }
        })

        return count

    }

    getGlobalObj = function (count) {
        let code = ''

        for (let i = 2; i < count + 2; i++) {
            code += `Heap[${i + 1}] = ${i - 2};\n\t`
        }
        return code
    }

    addFixedFunctions = function () {

        this.list.unshift(new Function(`void`, `__call_printBoolean__`, new Array({
                type: 'boolean',
                name: 'booelanVar'
            }),
            new FixedCode(`\t\t#_t0 = p - 2;
\t\t#_t1 = Stack[(int)#_t0];
\t\t
\t\tif (#_t1 == 0) goto #L1;
\t  
\t//116 114 117 101
\t\tprintf("%c", 116);
\t  \tprintf("%c", 114);
\t  \tprintf("%c", 117);
\t  \tprintf("%c", 101);
\t\t
\t\t
\t\tgoto #L2;
\t\t#L1:
\t//102 97 108 115 101
\t\tprintf("%c", 102);
\t  \tprintf("%c", 97);
\t  \tprintf("%c", 108);
\t  \tprintf("%c", 115);
\t    printf("%c", 101);
\t\t
\t\t
\t\t
\t\t#L2:`, 2, 2)));


        this.list.unshift(new Function(`void`, `__call_printString__`, new Array({
                type: 'string',
                name: 'StringVar'
            }),
            new FixedCode(`#_t0 = p - 2;
\t\t#_t1 = Stack[(int)#_t0];
\t
\t  \t
\t  \t#L1:
\t  \t#_t1 = #_t1 + 1;
\t  \t#_t2 = Heap[(int) #_t1];
\t  \t
\t  \tif(#_t2 == -1) goto #L2;
\t\tif(#_t2 < -1)goto #L3; 
  \t\tif(#_t2 > 1000) goto #L4; 
\t  \tprintf("%c",(int) #_t2 );
\t  \tgoto #L1;
\t\t
\t\t#L3:
\t  \t#_t2 = #_t2 + 1;
\t\tprintf(decSize, #_t2 );
  \t\tgoto #L1;

  \t\t#L4: 
\t  \t#_t2 = #_t2 - 1000;
\t\tprintf(decSize, #_t2 );
\t  \tgoto #L1;
\t   
\t  \t#L2:`, 4, 3)));


        this.list.unshift(new Function(`string`, `__call_concatString__`, [
                {
                    type: 'number',
                    name: 'numberVar'
                },
                {
                    type: 'string',
                    name: 'stringVar'
                }
            ],
            new FixedCode(`\t// number
\t#_t0 = p - 2;
\t#_t1 = Stack[(int)#_t0];
\t
\t//string
\t#_t2 = p - 3;
\t#_t3 = Stack[(int)#_t2];


\t// nuevo string
\t#_t5 = h;
\t#_t6 = #_t5 + 1;

\t//number to string
\tif(#_t1 > -1) goto #L1;
\t\t#_t1 = #_t1 - 1;
\tgoto #L2;
\t#L1: 
\t\t#_t1 = #_t1 + 1000;
\t#L2:



\tHeap[(int) #_t6] = #_t1;   // number pos 1
\t#_t6 = #_t6 + 1;
\t

\t#_t7 = #_t3;
\t#L3:
\t#_t7 = #_t7 + 1;
\t#_t8 = Heap[(int) #_t7]; 
\tif(#_t8 == -1) goto #L4;

\tHeap[(int) #_t6] = #_t8;
\t#_t6 = #_t6 + 1;

\tgoto #L3;
\t#L4:


\t#_t9 = Heap[(int) #_t3]; 
\t#_t9 = #_t9 + 1;

\tHeap[(int) #_t5] = #_t9;   // length 
\t
\t
\tHeap[(int) #_t6] = -1;    // null
\t#_t6 = #_t6 + 1;
\th = #_t6;
\t

\t#_t10 = p - 1;
\tStack[(int) #_t10] = #_t5;
`, 4, 12)));

        this.list.unshift(new Function(`string`, `__call_concatString__`, [
                {
                    type: 'string',
                    name: 'numberVar'
                },
                {
                    type: 'number',
                    name: 'stringVar'
                }
            ],
            new FixedCode(`\t// number
\t#_t0 = p - 3;
\t#_t1 = Stack[(int)#_t0];
\t
\t//string
\t#_t2 = p - 2;
\t#_t3 = Stack[(int)#_t2];


\t// nuevo string
\t#_t5 = h;
\t#_t6 = #_t5 + 1;

\t//number to string
\tif(#_t1 > -1) goto #L1;
\t\t#_t1 = #_t1 - 1;
\tgoto #L2;
\t#L1: 
\t\t#_t1 = #_t1 + 1000;
\t#L2:




\t#_t7 = #_t3;
\t#L3:
\t#_t7 = #_t7 + 1;
\t#_t8 = Heap[(int) #_t7]; 
\tif(#_t8 == -1) goto #L4;

\tHeap[(int) #_t6] = #_t8;
\t#_t6 = #_t6 + 1;

\tgoto #L3;
\t#L4:

\tHeap[(int) #_t6] = #_t1;   // number pos 1
\t#_t6 = #_t6 + 1;
\t

\t#_t9 = Heap[(int) #_t3]; 
\t#_t9 = #_t9 + 1;

\tHeap[(int) #_t5] = #_t9;   // length 
\t
\t
\tHeap[(int) #_t6] = -1;    // null
\t#_t6 = #_t6 + 1;
\th = #_t6;
\t

\t#_t10 = p - 1;
\tStack[(int) #_t10] = #_t5;
`, 4, 12)));

        this.list.unshift(new Function(`string`, `__call_concatString__`, [
                {
                    type: 'boolean',
                    name: 'numberVar'
                },
                {
                    type: 'string',
                    name: 'stringVar'
                }
            ],
            new FixedCode(`// boolean
\t#_t0 = p - 2;
\t#_t1 = Stack[(int)#_t0];
\t
\t//string
\t#_t2 = p - 3;
\t#_t3 = Stack[(int)#_t2];

\t//contador
\t#_t4 = 0;

\t// nuevo string
\t#_t5 = h;
\t#_t6 = #_t5 + 1;

\t//boolean to string
\tif(#_t1 == 0) goto #L1;

\t#_t4 = 4;
\t//116 114 117 101
\tHeap[(int) #_t6] = 116;   // t
\t#_t6 = #_t6 + 1;
\tHeap[(int) #_t6] = 114;   // r
\t#_t6 = #_t6 + 1;
\tHeap[(int) #_t6] = 117;   // u
\t#_t6 = #_t6 + 1;
\tHeap[(int) #_t6] = 101;   // e
\t#_t6 = #_t6 + 1;
\t\t
\tgoto #L2;
\t#L1: 

\t#_t4 = 5;
\t// 102 97 108 115 101
\tHeap[(int) #_t6] = 102;   \t// f
\t#_t6 = #_t6 + 1;
\tHeap[(int) #_t6] = 97;   \t// a
\t#_t6 = #_t6 + 1;
\tHeap[(int) #_t6] = 108;   \t// l
\t#_t6 = #_t6 + 1;
\tHeap[(int) #_t6] = 115;   \t// s
\t#_t6 = #_t6 + 1;
\tHeap[(int) #_t6] = 101;   \t// e
\t#_t6 = #_t6 + 1;

\t#L2:

\t#_t7 = #_t3;
\t#L3:
\t#_t7 = #_t7 + 1;
\t#_t8 = Heap[(int) #_t7]; 
\tif(#_t8 == -1) goto #L4;

\tHeap[(int) #_t6] = #_t8;
\t#_t6 = #_t6 + 1;

\tgoto #L3;
\t#L4:



\t#_t9 = Heap[(int) #_t3]; 
\t#_t9 = #_t9 + #_t4;

\tHeap[(int) #_t5] = #_t9;   // length 
\t
\t
\tHeap[(int) #_t6] = -1;    // null
\t#_t6 = #_t6 + 1;
\th = #_t6;
\t

\t#_t10 = p - 1;
\tStack[(int) #_t10] = #_t5;
`, 4, 12)))

        this.list.unshift(new Function(`string`, `__call_concatString__`, [
                {
                    type: 'string',
                    name: 'numberVar'
                },
                {
                    type: 'boolean',
                    name: 'stringVar'
                }
            ],
            new FixedCode(`// boolean
\t#_t0 = p - 3;
\t#_t1 = Stack[(int)#_t0];
\t
\t//string
\t#_t2 = p - 2;
\t#_t3 = Stack[(int)#_t2];

\t//contador
\t#_t4 = 0;

\t// nuevo string
\t#_t5 = h;
\t#_t6 = #_t5 + 1;


\t#_t7 = #_t3;
\t#L3:
\t#_t7 = #_t7 + 1;
\t#_t8 = Heap[(int) #_t7]; 
\tif(#_t8 == -1) goto #L4;

\tHeap[(int) #_t6] = #_t8;
\t#_t6 = #_t6 + 1;

\tgoto #L3;
\t#L4:

\t//boolean to string
\tif(#_t1 == 0) goto #L1;

\t#_t4 = 4;
\t//116 114 117 101
\tHeap[(int) #_t6] = 116;   // t
\t#_t6 = #_t6 + 1;
\tHeap[(int) #_t6] = 114;   // r
\t#_t6 = #_t6 + 1;
\tHeap[(int) #_t6] = 117;   // u
\t#_t6 = #_t6 + 1;
\tHeap[(int) #_t6] = 101;   // e
\t#_t6 = #_t6 + 1;
\t\t
\tgoto #L2;
\t#L1: 

\t#_t4 = 5;
\t// 102 97 108 115 101
\tHeap[(int) #_t6] = 102;   \t// f
\t#_t6 = #_t6 + 1;
\tHeap[(int) #_t6] = 97;   \t// a
\t#_t6 = #_t6 + 1;
\tHeap[(int) #_t6] = 108;   \t// l
\t#_t6 = #_t6 + 1;
\tHeap[(int) #_t6] = 115;   \t// s
\t#_t6 = #_t6 + 1;
\tHeap[(int) #_t6] = 101;   \t// e
\t#_t6 = #_t6 + 1;

\t#L2:


\t#_t9 = Heap[(int) #_t3]; 
\t#_t9 = #_t9 + #_t4;

\tHeap[(int) #_t5] = #_t9;   // length 
\t
\t
\tHeap[(int) #_t6] = -1;    // null
\t#_t6 = #_t6 + 1;
\th = #_t6;
\t

\t#_t10 = p - 1;
\tStack[(int) #_t10] = #_t5;
`, 4, 12)));



        this.list.unshift(new Function(`string`, `__call_concatString__`, [
                {
                    type: 'string',
                    name: 'numberVar'
                },
                {
                    type: 'string',
                    name: 'stringVar'
                }
            ],
            new FixedCode(`
\t// string
\t#_t0 = p - 2;
\t#_t1 = Stack[(int)#_t0];
\t
\t//string
\t#_t2 = p - 3;
\t#_t3 = Stack[(int)#_t2];


\t// nuevo string
\t#_t5 = h;
\t#_t6 = #_t5 + 1;

\t

\t#_t4 = #_t1;
\t#L1:
\t#_t4 = #_t4 + 1;
\t#_t12 = Heap[(int) #_t4]; 
\tif(#_t12 == -1) goto #L2;

\tHeap[(int) #_t6] = #_t12;
\t#_t6 = #_t6 + 1;

\tgoto #L1;
\t#L2:
\t
\t

\t#_t7 = #_t3;
\t#L3:
\t#_t7 = #_t7 + 1;
\t#_t8 = Heap[(int) #_t7]; 
\tif(#_t8 == -1) goto #L4;

\tHeap[(int) #_t6] = #_t8;
\t#_t6 = #_t6 + 1;

\tgoto #L3;
\t#L4:


\t#_t9 = Heap[(int) #_t1]; 
\t#_t10 = Heap[(int) #_t3]; 
\t#_t9 = #_t9 + #_t10;

\tHeap[(int) #_t5] = #_t9;   // length 
\t
\t
\tHeap[(int) #_t6] = -1;    // null
\t#_t6 = #_t6 + 1;
\th = #_t6;
\t

\t#_t11 = p - 1;
\tStack[(int) #_t11] = #_t5;
`, 4, 13)));




        this.list.unshift(new Function(`string`, `__call_stringToLowerCase__`, [
                {
                    type: 'string',
                    name: 'stringVar'
                }
            ],
            new FixedCode(`\t// String to lowercase

\t
\t// string
\t#_t0 = p - 2;
\t#_t1 = Stack[(int)#_t0];
\t

\t// nuevo string
\t#_t2 = h;

\t// length
\t#_t3 = Heap[(int) #_t1]; 
\tHeap[(int) #_t2] = #_t3;
\t#_t4 = #_t2 + 1;

\t

\t#_t5 = #_t1;
\t#L1:
\t#_t5 = #_t5 + 1;
\t#_t6 = Heap[(int) #_t5]; 
\tif(#_t6 == -1) goto #L2;


\tif(#_t6 < 65) goto #L3;
\tif(#_t6 > 90) goto #L3;

\t#_t6 = #_t6 + 32;

\t#L3:


\tHeap[(int) #_t4] = #_t6;
\t#_t4 = #_t4 + 1;




\tgoto #L1;
\t#L2:
\t
\t
\tHeap[(int) #_t4] = -1;    // null
\t#_t4 = #_t4 + 1;
\th = #_t4;
\t

\t#_t7 = p - 1;
\tStack[(int) #_t7] = #_t2;
`, 3, 8)));


        this.list.unshift(new Function(`string`, `__call_stringToUpperCase__`, [
                {
                    type: 'string',
                    name: 'stringVar'
                }
            ],
            new FixedCode(`\t// String to lowercase

\t
\t// string
\t#_t0 = p - 2;
\t#_t1 = Stack[(int)#_t0];
\t

\t// nuevo string
\t#_t2 = h;

\t// length
\t#_t3 = Heap[(int) #_t1]; 
\tHeap[(int) #_t2] = #_t3;
\t#_t4 = #_t2 + 1;

\t

\t#_t5 = #_t1;
\t#L1:
\t#_t5 = #_t5 + 1;
\t#_t6 = Heap[(int) #_t5]; 
\tif(#_t6 == -1) goto #L2;


\tif(#_t6 < 97) goto #L3;
\tif(#_t6 > 122) goto #L3;

\t#_t6 = #_t6 - 32;

\t#L3:


\tHeap[(int) #_t4] = #_t6;
\t#_t4 = #_t4 + 1;




\tgoto #L1;
\t#L2:
\t
\t
\tHeap[(int) #_t4] = -1;    // null
\t#_t4 = #_t4 + 1;
\th = #_t4;
\t

\t#_t7 = p - 1;
\tStack[(int) #_t7] = #_t2;
`, 3, 8)));


        this.list.unshift(new Function(`number`,`__call_powerMethod__`, [
                {
                    type: 'number',
                    name: 'stringVar'
                },
                {
                    type: 'number',
                    name: 'stringVar'
                }
            ],
            new FixedCode(`\t
#_t0 = p - 3;
\t#_t1 = Stack[(int)#_t0];
\t// 0
\tif (#_t1 <= 0) goto #L1;
\tgoto #L2;
\t#L1:
\t#_t2 = 1;
\tgoto #L3;
\t#L2:
\t#_t2 = 0;
\t#L3:
\t
\tif (#_t2 == 0) goto #L4;
\t#_t3 = 1;
\t\t// Return
\t
\t#_t4 = p - 1;
\t
\tStack[(int)#_t4] = 1;
\t
\t\tgoto #L0;
\t
\t
\tgoto #L5;
\t#L4:
\t#L5:
\t
\t// Expresion para a
\t#_t5 = p - 2;
\t#_t6 = Stack[(int)#_t5];
\t
\t// Apuntador hacia espacio en variab#Le a
\t#_t7 = p + 0;
\t// Asignando va#Lor a variab#Le a
\tStack[(int)#_t7] = #_t6;
\t
\t// Expresion para pot
\t#_t8 = p - 3;
\t#_t9 = Stack[(int)#_t8];
\t// 1
\t#_t10 = #_t9 - 1;
\t
\t// Apuntador hacia espacio en variab#Le pot
\t#_t11 = p - 3;
\t#_t12 = Stack[(int)#_t11];
\t
\t// Asignando va#Lor a variab#Le pot
\tStack[(int)#_t11] = #_t10;
\t
\t#L7:
\t#_t13 = p - 3;
\t#_t14 = Stack[(int)#_t13];
\t// 0
\tif (#_t14 > 0) goto #L8;
\tgoto #L9;
\t#L8:
\t#_t15 = 1;
\tgoto #L10;
\t#L9:
\t#_t15 = 0;
\t#L10:
\t
\tif (#_t15 == 0) goto #L6;
\t// Expresion para a
\t#_t16 = p + 0;
\t#_t17 = Stack[(int)#_t16];
\t#_t18 = p - 2;
\t#_t19 = Stack[(int)#_t18];
\t#_t20 = #_t17 * #_t19;
\t
\t// Apuntador hacia espacio en variab#Le a
\t#_t21 = p + 0;
\t#_t22 = Stack[(int)#_t21];
\t
\t// Asignando va#Lor a variab#Le a
\tStack[(int)#_t21] = #_t20;
\t
\t// Expresion para pot
\t#_t23 = p - 3;
\t#_t24 = Stack[(int)#_t23];
\t// 1
\t#_t25 = #_t24 - 1;
\t
\t// Apuntador hacia espacio en variab#Le pot
\t#_t26 = p - 3;
\t#_t27 = Stack[(int)#_t26];
\t
\t// Asignando va#Lor a variab#Le pot
\tStack[(int)#_t26] = #_t25;
\t
\t
\tgoto #L7;
\t#L6:
\t
\t
\t#_t28 = p + 0;
\t#_t29 = Stack[(int)#_t28];
\t
\t\t// Return
\t
\t#_t30 = p - 1;
\t
\tStack[(int)#_t30] = #_t29;
\t
\t\tgoto #L0;
\t
`, 10, 31)));


        this.list.unshift(new Function(`boolean`, `__call_compareString__`, [
                {
                    type: 'string',
                    name: 'numberVar'
                },
                {
                    type: 'string',
                    name: 'stringVar'
                }
            ],
            new FixedCode(`

`, 4, 13)));

    }
}

