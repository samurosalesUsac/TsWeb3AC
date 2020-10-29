


/* description: Parses and executes mathematical expressions. */

/* lexical grammar */
%lex
%options ranges

// blockcomment                [/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]   /* IGNORE */

// number                      [0-9]+                 
// digit                       [0-9]+("."[0-9]+)+     
number                          [0-9]+("."[0-9]+)? 
chr                        [']([^'\\\n]|\\(.|\n))*['] /*'*/
backstick                    [`]([^'\\\n]|\\(.|\n))*[`] /*'*/
// chr                         ("'" [^'/*'*/ ]* "'" )
// backstick                    ("`" [^`]* "`" )

// file                        (([-a-zA-Z0-9ñÑ]|".")+ "."[j])
id                          [_a-zA-Z][_a-zA-Z0-9ñÑ]*

%s                comment

%%

"//".*                /* skip comments */
"/*"                  this.begin('comment');
<comment>"*/"         this.popState();
<comment>.            /* skip comment content*/

"?"                         return 'questionMark';
"||"                        return 'or';
"&&"                        return 'and';
"=="                        return 'equality';
"!="                        return 'inequality';
"!"                         return 'not';
">="                        return 'greaterEqual';
"<="                        return 'lessEqual';
">"                         return 'greaterThan';
"<"                         return 'lessThan';

"++"                         return 'increase';
"--"                         return 'decrease';

"+"                         return 'plus';
"-"                         return 'minus';

"**"                         return 'power';
"*"                         return 'times';
"/"                         return 'divide';
"%"                         return 'module';

// "^"                         return 'potency';

"null"                      return 'null'

/* braquets */

"{"                         return 'leftCrlBrkt';
"}"                         return 'rightCrlBrkt';

"["                         return 'leftSqrBrkt';
"]"                         return 'rightSqrBrkt';


"instanceof"                       return 'instanceof';

// "extends"                       return 'extends';
"new"                           return 'new';
"null"                           return 'null';

"in"                           return 'in';
"of"                           return 'of';


"number"                       return 'number';

"string"                         return 'string';
"boolean"                         return 'boolean';

"const"                         return 'const';
"let"                           return 'let';


"if"                            return 'if';
"else"                          return 'else';


"switch"                        return 'switch';
"case"                          return 'case';
"default"                       return 'default';
"break"                         return 'break';

"void"                          return 'void';
"type"                          return 'type';

"function"                         return 'function';


"continue"                      return 'continue';
"return"                        return 'return';
// "print"                         return 'print';


"for"                           return 'for';
"while"                         return 'while';
// "define"                        return 'define';

// "as"                            return 'as';
// "strc"                          return 'strc';
"do"                            return 'do'

// "try"                           return 'try';
// "catch"                         return 'catch';
// "throw"                         return 'throw';



"="                         return 'equal';
// ":="                        return 'colonEqual';
":"                         return 'colon';

";"                         return 'semicolon';
","                         return 'comma';
"."                         return 'dot';

// "goto"                      return 'goto';



/* .. Reserved Words */




"("                         return 'leftPar';
")"                         return 'rightPar';

{number}                    return 'number';

\"(?:'\\'[\\"bfnrt/]|'\\u'[a-fA-F0-9]{4}|[^\\\0-\x09\x0a-\x1f"])*\"  /*"*/  yytext = yytext.substr(1,yyleng-2); return 'strng'
{chr}                       yytext = yytext.substr(1,yyleng-2); return 'strng'
{backstick}                       yytext = yytext.substr(1,yyleng-2); return 'strng'

"true"                      return 'true';
"false"                     return 'false';

{id}                        return 'id';

\s+                         /* skip whitespace */


// "."                        return 'error';
"."                         throw 'Illegal character';

<<EOF>>                     return 'endOfFile';



/lex


%{
var globalIndex = 0
   
newIndex = function () {
    return globalIndex++
}

getIndex = function (offset) {
    return globalIndex + offset 
}

   
%}

%left       comma
%right      pEqual mEqual tEqual dEequal aEqual oEqual xEqual mdEqual equal colonEqual
%right      questionMark colon
%left       or
%left       and
%left       potency power
%left       equality inequality 
%nonassoc   lessThan greaterThan lessEqual greaterEqual instanceof
%left       plus minus
%left       times divide module
%right      new castLeftPar 
%right      uminus uplus not preincrease predecrease
%nonassoc   increase decrease
%left       dot leftPar leftSqrBrkt


%% 


/*
   _____                                          
  / ____|                                         
 | |  __ _ __ __ _ _ __ ___  _ __ ___   __ _ _ __ 
 | | |_ | '__/ _` | '_ ` _ \| '_ ` _ \ / _` | '__|
 | |__| | | | (_| | | | | | | | | | | | (_| | |   
  \_____|_|  \__,_|_| |_| |_|_| |_| |_|\__,_|_|   
                                                  
*/

InitMain 
    : BodyList endOfFile
        {
            $1[0].parent = getIndex(0)
            $$ = [{ key: newIndex(), text: "InitMain", fill: "#f68c06", stroke: "#4d90fe", parent : -1 }].concat($1)
            $$ = $$.concat({ key: newIndex(), text: "EndOfFile", fill: "#f68c06", stroke: "#4d90fe", parent: getIndex(-2) })
            return $$;
        }
    | endOfFile
        {
            return [{ key: newIndex(), text: "InitMain", fill: "#f68c06", stroke: "#4d90fe" },
               { key: newIndex(), text: "EndOfFile", fill: "#f68c06", stroke: "#4d90fe", parent: getIndex(-2) }, 
            ];
        }
    ;

SemicolonE
    : semicolon
        {$$ = $1;}
    |   
    ;

FunctionBody
    : BodyList
    | 

    ;

RightFunctionBody
    : RightBodyList
        {$$ = $1;}
    |
    ;

RightBodyList
    : BodyElement
    {
        $1[0].parent = getIndex(0);
        $$ = [
            { key: newIndex(), text: "RBodyList", fill: "#f68c06", stroke: "#4d90fe", parent : -1 }
        ].concat($1);

    } 
    | BodyElement RightBodyList
    {
        $1[0].parent = getIndex(0);
        $2[0].parent = getIndex(0);
        $$ = [
            { key: newIndex(), text: "RBodyList", fill: "#f68c06", stroke: "#4d90fe", parent : -1 }
        ]
        .concat($1)
        .concat($2)

    } 
    ;

BodyList
    : BodyList BodyElement      
        {
            $1[0].parent = getIndex(0);
            $2[0].parent = getIndex(0);
            $$ = [
                { key: newIndex(), text: "BodyList", fill: "#f68c06", stroke: "#4d90fe", parent : -1 }
            ];

            $$ = $$.concat($1);
            $$ = $$.concat($2);
        }
    | BodyElement        
        {
            $1[0].parent = getIndex(0);
            $$ = [
                { key: newIndex(), text: "BodyList", fill: "#f68c06", stroke: "#4d90fe", parent : -1 }
            ].concat($1);

        } 
    ;

TypeAttribute
    : colon VariableType
        {
            $$ = [
                    
                { key: newIndex(), text: "TypeAttribute", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
                { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
                { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) }
                    
            ];
        }
    |
    ;


VariableExpression
    : equal Expression
    {
        $2[0].parent = getIndex(0);

        $$ = [

                { key: newIndex(), text: "VariableExpression", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
                { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) }
        ].concat($2);
    }
    |
    ;

VariableDec
    : VariableDec comma id TypeAttribute VariableExpression
    {
            
        $1[0].parent = getIndex(0);
        $4[0].parent = getIndex(0);
        $5[0].parent = getIndex(0);
        
        $$ = [

                { key: newIndex(), text: "VariableDec", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
                { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
                { key: newIndex(), text: $3, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) },
        ]


        $$ = $$.concat($1)
        $$ = $$.concat($4)
        $$ = $$.concat($5)
            
    }
    | let   id TypeAttribute VariableExpression
    {
        
        if($3) $3[0].parent = getIndex(0);
        if($4) $4[0].parent = getIndex(0);
        
        $$ = [

                { key: newIndex(), text: "VariableDec", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
                { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
                { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) },
        ]


        if($3) $$ = $$.concat($3)
        if($4) $$ = $$.concat($4)
            
    }
    | const id TypeAttribute VariableExpression
    {
            
        if($3) $3[0].parent = getIndex(0);
        if($4) $4[0].parent = getIndex(0);
        
        $$ = [

                { key: newIndex(), text: "VariableDec", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
                { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
                { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) },
        ]


        if($3) $$ = $$.concat($3)
        if($4) $$ = $$.concat($4)
            
    }
    ;


ObjectList
    : leftCrlBrkt rightCrlBrkt
    | leftCrlBrkt ObjectAttList rightCrlBrkt
    ;

ObjectAttList
    : ObjectAttList comma id colon VariableType
    | id colon VariableType
    ;

BodyElement 
    : VariableDec SemicolonE
    {
            
        $1[0].parent = getIndex(0);
        
        $$ = [

                { key: newIndex(), text: "BodyElement", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
        ].concat($1);

        if($2 !== undefined){
            $$ = $$.concat({ key: newIndex(), text: ";", fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2)});
        };


            
    }
    | IdCall SemicolonE
        {
            
        $1[0].parent = getIndex(0);
        
        $$ = [

                { key: newIndex(), text: "BodyElement", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
        ].concat($1);

        if($2 !== undefined){
            $$ = $$.concat({ key: newIndex(), text: ";", fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2)});
        };


            
    }
    | IdCall equal Expression SemicolonE 
    {
            
        $1[0].parent = getIndex(0);
        $3[0].parent = getIndex(0);
        
        $$ = [

                { key: newIndex(), text: "BodyElement", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
        ]
        .concat($1)
        .concat([{ key: newIndex(), text: "BodyElement", fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2)},])
        .concat($3);

        if($2 !== undefined){
            $$ = $$.concat({ key: newIndex(), text: ";", fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2)});
        };


            
    }
    | type id equal ObjectList SemicolonE
        
    | IfStatement 
    | WhileStatement 
    | DoWhileStatement 
    | ForStatement
    | SwitchStatement

    // Print
    // | print leftPar Expression rightPar SemicolonE

    | break SemicolonE

        {
            $$ = [
                { key: newIndex(), text: "BodyElement", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
                { key: newIndex(), text: "break", fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2)}
            ];

            if($2 !== undefined){
                $$ = $$.concat({ key: newIndex(), text: ";", fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3)});
            };


        }

    | return Expression SemicolonE
        {
            $$ = [
                { key: newIndex(), text: "BodyElement", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
                { key: newIndex(), text: "return", fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2)}
            ];

            $2[0].parent = getIndex(-2)
            
            $$ = $$.concat($2)
            if($2 !== undefined){
                $$ = $$.concat({ key: newIndex(), text: ";", fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3)});
            };


        }
    | return semicolon
        {
            $$ = [
                { key: newIndex(), text: "BodyElement", fill: "#f68c06", stroke: "#4d90fe", parent : -1},
                { key: newIndex(), text: "return", fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2)}
            ];

            if($2 !== undefined){
                $$ = $$.concat({ key: newIndex(), text: ";", fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3)});
            };


        }
    | continue SemicolonE
        {
            $$ = [
                { key: newIndex(), text: "BodyElement", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
                { key: newIndex(), text: "continue", fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2)}
            ];

            if($2 !== undefined){
                $$ = $$.concat({ key: newIndex(), text: ";", fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3)});
            };


        }
    | function id leftPar FunctionparameterListOrEmpty rightPar 
        TypeAttribute
        leftCrlBrkt RightFunctionBody rightCrlBrkt
    
    {
        
        if($8) $8[0].parent = getIndex(0)
        if($4) $4[0].parent = getIndex(0)
        if($6) $6[0].parent = getIndex(0)
        
         $$ = [
                { key: newIndex(), text: "BodyElement", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
                { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2)},
                { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3)},
                { key: newIndex(), text: $3, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-4)},
            ]
            .concat($4 !== undefined ? $4 : [])
            .concat([{ key: newIndex(), text: $5, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-5)}])
            .concat($6 !== undefined ? $6 : [])
            .concat([{ key: newIndex(), text: $7, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-6)}])
            .concat($8 !== undefined ? $8 : [])
            .concat([{ key: newIndex(), text: $9, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-7)}]);

    }
  

    ;


IdCall
    : IdCall leftPar rightPar
    {
        $1[0].parent = getIndex(0)
        $$ = [
            { key: newIndex(), text: "IdCall", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
           
        ].concat($1)
        .concat([
             { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
            { key: newIndex(), text: $3, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) },
        ]);
    }
    | IdCall leftPar ParameterList rightPar
        {
        $1[0].parent = getIndex(0)
        $3[0].parent = getIndex(0)
        $$ = [
            { key: newIndex(), text: "IdCall", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
           
        ]
        .concat($1)
        .concat([
             { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
        ])
        .concat($3)
        .concat([
             { key: newIndex(), text: $4, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) },
        ])
        
        ;
    }
    | IdCall leftSqrBrkt Expression rightSqrBrkt
    {
        $1[0].parent = getIndex(0)
        $3[0].parent = getIndex(0)
        $$ = [
            { key: newIndex(), text: "IdCall", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
           
        ]
        .concat($1)
        .concat([
             { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
        ])
        .concat($3)
        .concat([
             { key: newIndex(), text: $4, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) },
        ])
        
        ;
    }
    | IdCall dot id
    {
        $1[0].parent = getIndex(0)
        $$ = [
            { key: newIndex(), text: "IdCall", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
           
        ].concat($1)
        .concat([
             { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
            { key: newIndex(), text: $3, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) },
        ]);
    }
    | id
        {
        $$ = [
            { key: newIndex(), text: "IdCall", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
            { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2)},
        ];

    }
    | id increase
        {
        $$ = [
            { key: newIndex(), text: "IdCall", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
            { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2)},
            { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3)},
        ];

    }
    | id decrease
        {
        $$ = [
            { key: newIndex(), text: "IdCall", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
            { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2)},
            { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3)},
        ];

    }

    ; 



 FunctionparameterListOrEmpty
    : FunctionparameterList
    | 
    ;

FunctionparameterList
    : FunctionparameterList comma  id colon VariableType     
    {
        $1[0].parent = getIndex(0) 
        $$ = [ 
            { key: newIndex(), text: "IdCall", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
            
            ]
            .concat($1)
            .concat([
                { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2)},
                { key: newIndex(), text: $3, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3)},
                { key: newIndex(), text: $4, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-4)},
                { key: newIndex(), text: $5, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-5)},
            ]);
    }
    |  id colon VariableType                                
    {
        $$ = [ 
            { key: newIndex(), text: "IdCall", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
            { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2)},
            { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3)},
            { key: newIndex(), text: $3, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-4)},
            ]
    }
    ;




VariableType
    : number SizeList_
        {$$=$1 + $2;}
    | string SizeList_
        {$$=$1 + $2;}
    | void          
        {$$=$1;}
    | boolean SizeList_   
        {$$=$1 + $2;}
    | id SizeList_
        {$$=$1 + $2;}
    ;


SizeList_
    : SizeList
    | {$$ = ''}
    ;

SizeList
    : SizeList leftSqrBrkt rightSqrBrkt
        {$$ = $1 + '[]';}
    | leftSqrBrkt rightSqrBrkt
        {$$ = '[]';}
    ;

ObjectStrc
    : leftCrlBrkt ObjectStrcList rightCrlBrkt
    | leftCrlBrkt rightCrlBrkt
    ;

ObjectStrcList
    : ObjectStrcList comma id colon Expression
    | id colon Expression
    ;



Expression
    : ExpressionOp 
    ;

ExpressionOp
    : 
    ExpressionOp questionMark     ExpressionOp colon ExpressionOp
//logical
    | ExpressionOp or               ExpressionOp         
        {
            $1[0].parent = getIndex(0)
            $3[0].parent = getIndex(0)

            $$ = [
                { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : -1 }
            ];

            $$ = $$.concat($1);
            $$ = $$.concat($3);
            

        }
    | ExpressionOp and              ExpressionOp         
        {
            $1[0].parent = getIndex(0)
            $3[0].parent = getIndex(0)

            $$ = [
                { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : -1 }
            ];

            $$ = $$.concat($1);
            $$ = $$.concat($3);
            

        }

    | not ExpressionOp
        {
            $2[0].parent = getIndex(0)
            $$ = [
                { key: newIndex(), text: "Expression", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
                { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) }
            ];

            $$ = $$.concat($2);
            
        }
        

//relacional
    | ExpressionOp equality         ExpressionOp          
        {
            $1[0].parent = getIndex(0)
            $3[0].parent = getIndex(0)

            $$ = [
                { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : -1 }
            ];

            $$ = $$.concat($1);
            $$ = $$.concat($3);
            

        }
    | ExpressionOp inequality       ExpressionOp          
        {
            $1[0].parent = getIndex(0)
            $3[0].parent = getIndex(0)

            $$ = [
                { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : -1 }
            ];

            $$ = $$.concat($1);
            $$ = $$.concat($3);
            

        }


    | ExpressionOp lessThan         ExpressionOp          
        {
            $1[0].parent = getIndex(0)
            $3[0].parent = getIndex(0)

            $$ = [
                { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : -1 }
            ];

            $$ = $$.concat($1);
            $$ = $$.concat($3);
            

        }
    | ExpressionOp greaterThan      ExpressionOp          
        {
            $1[0].parent = getIndex(0)
            $3[0].parent = getIndex(0)

            $$ = [
                { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : -1 }
            ];

            $$ = $$.concat($1);
            $$ = $$.concat($3);
            

        }
    | ExpressionOp lessEqual        ExpressionOp          
        {
            $1[0].parent = getIndex(0)
            $3[0].parent = getIndex(0)

            $$ = [
                { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : -1 }
            ];

            $$ = $$.concat($1);
            $$ = $$.concat($3);
            

        }
    | ExpressionOp greaterEqual     ExpressionOp          
        {
            $1[0].parent = getIndex(0)
            $3[0].parent = getIndex(0)

            $$ = [
                { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : -1 }
            ];

            $$ = $$.concat($1);
            $$ = $$.concat($3);
            

        }

//Arithmetical

    | ExpressionOp plus             ExpressionOp          
        {
            $1[0].parent = getIndex(0)
            $3[0].parent = getIndex(0)

            $$ = [
                { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : -1 }
            ];

            $$ = $$.concat($1);
            $$ = $$.concat($3);
            

        }
        
    | ExpressionOp minus            ExpressionOp          
        {
            $1[0].parent = getIndex(0)
            $3[0].parent = getIndex(0)

            $$ = [
                { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : -1 }
            ];

            $$ = $$.concat($1);
            $$ = $$.concat($3);
            

        }
    | ExpressionOp times            ExpressionOp          
        {
            $1[0].parent = getIndex(0)
            $3[0].parent = getIndex(0)

            $$ = [
                { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : -1 }
            ];

            $$ = $$.concat($1);
            $$ = $$.concat($3);
            

        }
    | ExpressionOp divide           ExpressionOp          
        {
            $1[0].parent = getIndex(0)
            $3[0].parent = getIndex(0)

            $$ = [
                { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : -1 }
            ];

            $$ = $$.concat($1);
            $$ = $$.concat($3);
            

        }
    | ExpressionOp module           ExpressionOp          
        {
            $1[0].parent = getIndex(0)
            $3[0].parent = getIndex(0)

            $$ = [
                { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : -1 }
            ];

            $$ = $$.concat($1);
            $$ = $$.concat($3);
            

        }

    // | ExpressionOp potency          ExpressionOp          
    | ExpressionOp power ExpressionOp                     
        {
            $1[0].parent = getIndex(0)
            $3[0].parent = getIndex(0)

            $$ = [
                { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : -1 }
            ];

            $$ = $$.concat($1);
            $$ = $$.concat($3);
            

        }

    | leftPar ExpressionOp rightPar                     
     {$$ = $2;}
    | leftSqrBrkt ExpressionList rightSqrBrkt
        {
            $2[0].parent = getIndex(0)
            $$ = [
                { key: newIndex(), text: "Expression", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
                { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) }
            ];

            $$ = $$.concat($2);
            $$ = $$.concat([{ key: newIndex(), text: $3, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) }]);
            
        }
    | increase id %prec preincrease
    | decrease id %prec predecrease

    // | id increase
    // | id decrease

    | minus ExpressionOp %prec uMinus
        {
            $2[0].parent = getIndex(0)
            $$ = [
                { key: newIndex(), text: "Expression", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
                { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) }
            ];

            $$ = $$.concat($2);
            
        }
    | IdAssign equal ExpressionOp
    {
            $1[0].parent = getIndex(0)
            $3[0].parent = getIndex(0)

            $$ = [
                { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : -1 }
            ];

            $$ = $$.concat($1);
            $$ = $$.concat($3);
            
    }
        
    | IdAssign

    | leftSqrBrkt rightSqrBrkt
        {$$ = [{ key: newIndex(), text: '[]', fill: "#f68c06", stroke: "#4d90fe", parent : -1 }];}

    | 'true'                     
        {$$ = [{ key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : -1 }];}
    | 'false'                    
        {$$ = [{ key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : -1 }];}
    | number                    
        {$$ = [{ key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : -1 }];}
    | strng                   
        {$$ = [{ key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : -1 }];}
    | null 
        {$$ = [{ key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : -1 }];}


    | ObjectStrc

    ;

ExpressionList
    : ExpressionList comma Expression
    {

        $1[0].parent = getIndex(0)
        $3[0].parent = getIndex(0)
        $$ = [
            { key: newIndex(), text: "ExpressionList", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
        ]
        .concat($1)
        .concat([ { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },])
        .concat($3);
    }
    | Expression
    {

        $1[0].parent = getIndex(0)
        $$ = [
            { key: newIndex(), text: "ExpressionList", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
        ].concat($1);
    }
    ;



IdAssign
    : IdAssign leftSqrBrkt Expression rightSqrBrkt 
    {
        $1[0].parent = getIndex(0)
        $3[0].parent = getIndex(0)
        $$ = [
            { key: newIndex(), text: "IdAssign", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
           
        ]
        .concat($1)
        .concat([
             { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
        ])
        .concat($3)
        .concat([
             { key: newIndex(), text: $4, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) },
        ])
        
        ;
    }
    | IdAssign dot id
    {
        $1[0].parent = getIndex(0)
        $$ = [
            { key: newIndex(), text: "IdAssign", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
           
        ].concat($1)
        .concat([
             { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
            { key: newIndex(), text: $3, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) },
        ]);
    }
    | IdAssign leftPar rightPar
    {
        $1[0].parent = getIndex(0)
        $$ = [
            { key: newIndex(), text: "IdAssign", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
           
        ].concat($1)
        .concat([
             { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
            { key: newIndex(), text: $3, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) },
        ]);
    }
    | IdAssign leftPar ParameterList rightPar
    {
        $1[0].parent = getIndex(0)
        $3[0].parent = getIndex(0)

        $$ = [
            { key: newIndex(), text: "IdAssign", fill: "#f68c06", stroke: "#4d90fe", parent : -1 }
        ];

        $$ = $$.concat($1);
        $$ = $$.concat({ key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2)});
        $$ = $$.concat($3);
        $$ = $$.concat({ key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3)});
    }
    | id
    {
        $$ = [
            { key: newIndex(), text: "IdAssign", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
            { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2)},
        ];

    }
    | id increase
    {
        $$ = [
            { key: newIndex(), text: "IdAssign", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
            { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2)},
            { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3)},
        ];

    }
    | id decrease
    {
        $$ = [
            { key: newIndex(), text: "IdAssign", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
            { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2)},
            { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3)},
        ];

    }
    ;

   

ParameterList
    : ParameterList comma Expression
    {

        $1[0].parent = getIndex(0)
        $3[0].parent = getIndex(0)
        $$ = [
            { key: newIndex(), text: "ParameterList", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
        ]
        .concat($1)
        .concat([ { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },])
        .concat($3);
    }
    | Expression
    {

        $1[0].parent = getIndex(0)
        $$ = [
            { key: newIndex(), text: "ParameterList", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
        ].concat($1);
    }
    ;




/*
 _____ _   
/  ___| |  
\ `--.| |_ 
 `--. \ __|
/\__/ / |_ 
\____/ \__|

*/


    IfStatement
        : if leftPar Expression rightPar leftCrlBrkt FunctionBody rightCrlBrkt  
    {

        $3[0].parent = getIndex(0)
        if($6) $6[0].parent = getIndex(0)
        $$ = [
            { key: newIndex(), text: "IfStatement", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
            { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
            { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) },
        ]
        .concat($3)
        .concat([ { key: newIndex(), text: $4, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-4) },])
        .concat([ { key: newIndex(), text: $5, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-5) },])
        .concat($6 !== undefined ? $6 : [])
        .concat([ { key: newIndex(), text: $7, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-6) },])
    }
        | if leftPar Expression rightPar leftCrlBrkt FunctionBody rightCrlBrkt else IfStatement
    {

        $3[0].parent = getIndex(0)
        if($6) $6[0].parent = getIndex(0)
        $9[0].parent = getIndex(0)
        $$ = [
            { key: newIndex(), text: "IfStatement", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
            { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
            { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) },
        ]
        .concat($3)
        .concat([ { key: newIndex(), text: $4, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-4) },])
        .concat([ { key: newIndex(), text: $5, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-5) },])
        .concat($6 !== undefined ? $6 : [])
        .concat([ { key: newIndex(), text: $7, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-6) },])
        .concat([ { key: newIndex(), text: $8, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-7) },])
        .concat($9);
    }
        | if leftPar Expression rightPar leftCrlBrkt FunctionBody rightCrlBrkt else leftCrlBrkt FunctionBody rightCrlBrkt 
    {

        $3[0].parent = getIndex(0)
        if($6) $6[0].parent = getIndex(0)
        $9[0].parent = getIndex(0)
        $$ = [
            { key: newIndex(), text: "IfStatement", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
            { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
            { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) },
        ]
        .concat($3)
        .concat([ { key: newIndex(), text: $4, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-4) },])
        .concat([ { key: newIndex(), text: $5, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-5) },])
        .concat($6 !== undefined ? $6 : [])
        .concat([ { key: newIndex(), text: $7, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-6) },])
        .concat([ { key: newIndex(), text: $8, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-7) },])
        .concat([ { key: newIndex(), text: $9, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-8) },])
        .concat($10 !== undefined ? $10 : [])
        .concat([ { key: newIndex(), text: $11, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-9) },]);
    }
        ;


    WhileStatement                  
        : while leftPar Expression rightPar leftCrlBrkt FunctionBody rightCrlBrkt 
    {

        $3[0].parent = getIndex(0)
        if($6) $6[0].parent = getIndex(0)
        $$ = [
            { key: newIndex(), text: "WhileStatement", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
            { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
            { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) },
        ]
        .concat($3)
        .concat([ { key: newIndex(), text: $4, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-4) },])
        .concat([ { key: newIndex(), text: $5, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-5) },])
        .concat($6 !== undefined ? $6 : [])
        .concat([ { key: newIndex(), text: $7, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-6) },])
    }
        ;

    DoWhileStatement                
        : do leftCrlBrkt FunctionBody rightCrlBrkt while leftPar Expression rightPar SemicolonE
    {

        if($3) $3[0].parent = getIndex(0)
        $7[0].parent = getIndex(0)
        $$ = [
            { key: newIndex(), text: "DoWhileStatement", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
            { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
            { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) },
        ]
        .concat($3 !== undefined ? $3 : [])
        .concat([ { key: newIndex(), text: $4, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-4) },])
        .concat([ { key: newIndex(), text: $5, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-5) },])
        .concat([ { key: newIndex(), text: $6, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-6) },])
        .concat($7)
        .concat([ { key: newIndex(), text: $8, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-7) },]);

        if($9) $$ = $$.concat([ { key: newIndex(), text: $9, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-8) },]);
        
    }
        ;


    SwitchStatement
        : switch leftPar Expression rightPar leftCrlBrkt CaseStatementList_  rightCrlBrkt 
    {

        $3[0].parent = getIndex(0)
        if($6) $6[0].parent = getIndex(0)
        $$ = [
            { key: newIndex(), text: "SwitchStatement", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
            { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
            { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) },
        ]
        .concat($3)
        .concat([ { key: newIndex(), text: $4, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-4) },])
        .concat([ { key: newIndex(), text: $5, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-5) },])
        .concat($6 !== undefined ? $6 : [])
        .concat([ { key: newIndex(), text: $7, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-6) },])
    }
        ;

    CaseStatementList_
        : CaseStatementList
        |
        ;

    CaseStatementList
        : CaseStatementList CaseStatement
        {

            $1[0].parent = getIndex(0)
            $2[0].parent = getIndex(0)
            $$ = [
                { key: newIndex(), text: "CaseList", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
            ]
            .concat($1)
            .concat($2);
        }
        | CaseStatementList DefaultStatement
        {

            $1[0].parent = getIndex(0)
            $2[0].parent = getIndex(0)
            $$ = [
                { key: newIndex(), text: "CaseList", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
            ]
            .concat($1)
            .concat($2);
        }
        | CaseStatement
        {

            $1[0].parent = getIndex(0)
            $$ = [
                { key: newIndex(), text: "CaseList", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
            ].concat($1);
        }
        | DefaultStatement
        {

            $1[0].parent = getIndex(0)
            $$ = [
                { key: newIndex(), text: "CaseList", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
            ].concat($1);
        }
        ;




    CaseStatement
        : case Expression colon FunctionBody
          {
            $2[0].parent = getIndex(0)
            if($4) $4[0].parent = getIndex(0)
            $$ = [
                { key: newIndex(), text: "CaseList", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
                { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
                
            ]
            .concat($2)
            .concat([{ key: newIndex(), text: $3, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) },])
            .concat($4 !== undefined ? $4 : []);
        }
        ;

    DefaultStatement
        : default colon FunctionBody
        {
            if($3) $3[0].parent = getIndex(0)
            $$ = [
                { key: newIndex(), text: "CaseList", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
                { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
                { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) },
            ]
            .concat($3 !== undefined ? $3 : []);
        }
        ;

  

    ForStatement
        : for leftPar 
            ForDecOr 
        semicolon
            ExpOr
        semicolon
            ExpOr 
        rightPar

        leftCrlBrkt FunctionBody rightCrlBrkt
        {
            if($3) $3[0].parent = getIndex(0)
            if($5) $5[0].parent = getIndex(0)
            if($7) $7[0].parent = getIndex(0)
            if($10) $10[0].parent = getIndex(0)
            $$ = [
                { key: newIndex(), text: "ForStatement", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
                { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
                { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) },
                
            ]
            .concat($3 !== undefined ? $3 : [])
            .concat([{ key: newIndex(), text: $4, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-4) },])
            .concat($5 !== undefined ? $5 : [])
            .concat([{ key: newIndex(), text: $5, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-5) },])
            .concat($7 !== undefined ? $7 : [])
            .concat([{ key: newIndex(), text: $8, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-6) },])
            .concat([{ key: newIndex(), text: $9, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-7) },])
            .concat($10 !== undefined ? $10 : [])
            .concat([{ key: newIndex(), text: $11, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-8) },]);
        }
        | for leftPar let      id in Expression  rightPar leftCrlBrkt FunctionBody rightCrlBrkt
    {

        $6[0].parent = getIndex(0)
        if($9) $9[0].parent = getIndex(0)
        $$ = [
            { key: newIndex(), text: "ForStatement", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
            { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
            { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) },
            { key: newIndex(), text: $3, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-4) },
            { key: newIndex(), text: $4, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-5) },
            { key: newIndex(), text: $5, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-6) },
        ]
        .concat($6)
        .concat([ { key: newIndex(), text: $7, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-7) },])
        .concat([ { key: newIndex(), text: $8, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-8) },])
        .concat($9 !== undefined ? $9 : [])
        .concat([ { key: newIndex(), text: $10, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-9) },])
    }
        | for leftPar const    id in Expression  rightPar leftCrlBrkt FunctionBody rightCrlBrkt
    {

        $6[0].parent = getIndex(0)
        if($9) $9[0].parent = getIndex(0)
        $$ = [
            { key: newIndex(), text: "ForStatement", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
            { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
            { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) },
            { key: newIndex(), text: $3, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-4) },
            { key: newIndex(), text: $4, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-5) },
            { key: newIndex(), text: $5, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-6) },
        ]
        .concat($6)
        .concat([ { key: newIndex(), text: $7, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-7) },])
        .concat([ { key: newIndex(), text: $8, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-8) },])
        .concat($9 !== undefined ? $9 : [])
        .concat([ { key: newIndex(), text: $10, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-9) },])
    }
        | for leftPar let      id of Expression  rightPar leftCrlBrkt FunctionBody rightCrlBrkt
    {

        $6[0].parent = getIndex(0)
        if($9) $9[0].parent = getIndex(0)
        $$ = [
            { key: newIndex(), text: "ForStatement", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
            { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
            { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) },
            { key: newIndex(), text: $3, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-4) },
            { key: newIndex(), text: $4, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-5) },
            { key: newIndex(), text: $5, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-6) },
        ]
        .concat($6)
        .concat([ { key: newIndex(), text: $7, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-7) },])
        .concat([ { key: newIndex(), text: $8, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-8) },])
        .concat($9 !== undefined ? $9 : [])
        .concat([ { key: newIndex(), text: $10, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-9) },])
    }
        | for leftPar const    id of Expression  rightPar leftCrlBrkt FunctionBody rightCrlBrkt
    {

        $6[0].parent = getIndex(0)
        if($9) $9[0].parent = getIndex(0)
        $$ = [
            { key: newIndex(), text: "ForStatement", fill: "#f68c06", stroke: "#4d90fe", parent : -1 },
            { key: newIndex(), text: $1, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-2) },
            { key: newIndex(), text: $2, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-3) },
            { key: newIndex(), text: $3, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-4) },
            { key: newIndex(), text: $4, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-5) },
            { key: newIndex(), text: $5, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-6) },
        ]
        .concat($6)
        .concat([ { key: newIndex(), text: $7, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-7) },])
        .concat([ { key: newIndex(), text: $8, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-8) },])
        .concat($9 !== undefined ? $9 : [])
        .concat([ { key: newIndex(), text: $10, fill: "#f68c06", stroke: "#4d90fe", parent : getIndex(-9) },])
    }
        ;


    ForDecOr
        : VariableDec
        |
        ;

    ExpOr
        : Expression
        |
        ;

 
