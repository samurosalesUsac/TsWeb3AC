

/* description: Parses and executes mathematical expressions. */

/* lexical grammar */
%lex
%options ranges

// blockcomment                [/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]   /* IGNORE */

// number                      [0-9]+                 
// digit                       [0-9]+("."[0-9]+)+     
number                          [0-9]+("."[0-9]+)? 
// chr                         ("'" [^'\'' ]* "'" )
chr                        [']([^'\\\n]|\\(.|\n))*['] /*'*/
backstick                    [`]([^'\\\n]|\\(.|\n))*[`] /*'*/

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
"==="                        return 'equality2';
"!=="                        return 'inequality2';
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
"console.log"                   return 'print';
"Graficar_ts"                   return 'GraficarTs';


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
.                           {
                                ErrorList = ErrorList.concat({
                                type : 'Lexico',
                                description :  yytext,
                                line :yylloc.first_line, 
                                column : yylloc.first_column});
                            }

<<EOF>>                     return 'endOfFile';



/lex


%{


   
%}

%left       comma
%right      pEqual mEqual tEqual dEequal aEqual oEqual xEqual mdEqual equal colonEqual
%right      questionMark colon
%left       or
%left       and

%left       equality inequality equality2 inequality2
%nonassoc   lessThan greaterThan lessEqual greaterEqual instanceof
%left       plus minus
%left       times divide module
%left       power

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


        
        // { return new MainScope($1,$2);  }
        // {  $$ = new ImportFiles(new Array()); }
        // ArrayList
        // {$$ = new ObjectClass($1, $3, $6, $4, @1.first_line, @1.first_column);}
        // Arraylist
        // {$$ = new Function ($1, $2, $3, $4, $6, @1.first_line, @1.first_column );}

InitMain 
    : BodyList endOfFile
        {console.log($1); return new MainScope(new Body($1));}
    | endOfFile
        {return new MainScope(new Body(new Array()));}
    | error
        {
            ErrorList = ErrorList.concat({
            type : 'Sintactico',
            description : $1,
            line : @1.first_line, 
            column : @1.first_column});
        }

    ;

SemicolonE
    : semicolon
    |
    ;

FunctionBody
    : BodyList 
        {$$ = new Body($1);}
    | 
        {$$ = new Body(new Array());}
    ;

RightFunctionBody
    : RightBodyList
    |
    ;

RightBodyList
    : BodyElement
    | BodyElement RightBodyList
    ;

BodyList
    : BodyList BodyElement      
        {$$ = $1.concat($2);}
    | BodyElement  
        {$$ = new Array($1);}             
    ;

TypeAttribute
    : colon VariableType
        {$$ = $2;}
    ;


VariableExpression
    : equal Expression
        {$$ = $2;}
    |
        {$$ = new Symbol();}
    ;

VariableDec
    : VariableDec comma id TypeAttribute VariableExpression
        
    | let   id TypeAttribute VariableExpression
        {$$ = new CreateVariable($2, $3, $4, @1.first_line, @1.first_column )}
    | const id TypeAttribute VariableExpression
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
    | IdCall SemicolonE
    | IdCall equal Expression SemicolonE 
        {$$ = new AssignVariable($1, $3, @1.first_line, @1.first_column);}

    | type id equal ObjectList SemicolonE
        
    | IfStatement 
    | WhileStatement 
    | DoWhileStatement 
    | ForStatement
    | SwitchStatement

    | print leftPar Expression rightPar SemicolonE
        {$$ = new PrintSttmnt($3, @1.first_line, @1.first_column);}
    // | GraficarTs leftPar rightPar SemicolonE

    | break SemicolonE
        { $$ = new BreakSttmnt(@1.first_line, @1.first_column)}
    | return Expression SemicolonE
        {$$ = new ReturnSttmnt($2, @1.first_line, @1.first_column)}
    | return semicolon
        {$$ = new ReturnSttmnt(undefined, @1.first_line, @1.first_column)}
  | continue SemicolonE
        { $$ = new ContinueSttmnt(@1.first_line, @1.first_column)}


        // Functions
    // | VariableType id leftPar FunctionparameterListOrEmpty rightPar leftCrlBrkt FunctionBody rightCrlBrkt

    | function id leftPar FunctionparameterListOrEmpty rightPar 
        TypeAttribute
        leftCrlBrkt FunctionBody rightCrlBrkt
         {$$ = new Function ($6, $2, $4, $8, @1.first_line, @1.first_column );}

    | error semicolon
        {
                        ErrorList = ErrorList.concat({
                        type : 'Sintactico',
                        description : $1,
                        line : @1.first_line, 
                        column : @1.first_column});
                        $$ = new Symbol();
        }
    ;


IdCall
    : IdCall leftPar rightPar
        {$$ = new Call($1, new Array(), @1.first_line, @1.first_column);}
    | IdCall leftPar ParameterList rightPar
        {$$ = new Call($1, $3, @1.first_line, @1.first_column);}
    | IdCall leftSqrBrkt Expression rightSqrBrkt
    | IdCall dot id

    | id
        {$$ = new GetId ($1, @1.first_line, @1.first_column); }    

    | id increase
    | id decrease
    ; 



FunctionparameterListOrEmpty
    : FunctionparameterList
    | { $$ = new Array(); }
    ;

FunctionparameterList
    : FunctionparameterList comma  id colon VariableType     { let list = $1; list.push({ type : $5, name : $3 }); $$ = list; }
    |  id colon VariableType                                 { $$ = new Array({ type : $3, name : $1 }); }
    ;


SizeList_
    : SizeList
    | {$$ = '';}
    ;

SizeList
    : SizeList leftSqrBrkt rightSqrBrkt
        {$$ = $1 + '[]';}
    | leftSqrBrkt rightSqrBrkt
        {$$ = '[]';}
    ;

VariableType
    : number SizeList_
        {$$ = $1 + $2;}
    | string SizeList_
        {$$ = $1 + $2;}
    | void          
        {$$ = $1 + $2;}
    | boolean SizeList_
        {$$ = $1 + $2;}
    | id SizeList_
        {$$ = $1 + $2;}
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
        {$$ = new Expression($1);}
    ;

ExpressionOp
    : 
    ExpressionOp questionMark     ExpressionOp colon ExpressionOp
//logical
    | ExpressionOp or               ExpressionOp         
        {$$ = new OrOp($1, $3, @2.first_line, @2.first_column); }
    | ExpressionOp and              ExpressionOp         
        {$$ = new AndOp($1, $3, @2.first_line, @2.first_column); }

    | not ExpressionOp

//relacional
    | ExpressionOp equality         ExpressionOp
        {$$ = new RelationalExpression($2, $1, $3, @2.first_line, @2.first_column); }
    | ExpressionOp inequality       ExpressionOp          
        {$$ = new RelationalExpression($2, $1, $3, @2.first_line, @2.first_column); }

    | ExpressionOp equality2         ExpressionOp
        {$$ = new RelationalExpression($2, $1, $3, @2.first_line, @2.first_column); }
    | ExpressionOp inequality2       ExpressionOp          
        {$$ = new RelationalExpression($2, $1, $3, @2.first_line, @2.first_column); }

    | ExpressionOp lessThan         ExpressionOp          
        {$$ = new RelationalExpression($2, $1, $3, @2.first_line, @2.first_column); }
    | ExpressionOp greaterThan      ExpressionOp          
        {$$ = new RelationalExpression($2, $1, $3, @2.first_line, @2.first_column); }
    | ExpressionOp lessEqual        ExpressionOp          
        {$$ = new RelationalExpression($2, $1, $3, @2.first_line, @2.first_column); }
    | ExpressionOp greaterEqual     ExpressionOp          
        {$$ = new RelationalExpression($2, $1, $3, @2.first_line, @2.first_column); }

//Arithmetical

    | ExpressionOp plus             ExpressionOp          
        {$$ = new Addition($1, $3, @1.first_line, @1.first_column);}
    | ExpressionOp minus            ExpressionOp 
        {$$ = new Subtraction($1, $3, @1.first_line, @1.first_column);}

    | ExpressionOp times            ExpressionOp          
        {$$ = new Times($1, $3, @1.first_line, @1.first_column);}
    | ExpressionOp divide           ExpressionOp          
        {$$ = new Divide($1, $3, @1.first_line, @1.first_column);}
    | ExpressionOp module           ExpressionOp          
        {$$ = new Module($1, $3, @1.first_line, @1.first_column);}

    // | ExpressionOp potency          ExpressionOp          
    | ExpressionOp power ExpressionOp                     
        {$$ = new Power($1, $3, @1.first_line, @1.first_column);}

    | leftPar ExpressionOp rightPar                     
        {$$ = $2;}
    
    | leftSqrBrkt ExpressionList rightSqrBrkt

    | increase id %prec preincrease
    | decrease id %prec predecrease



    | minus ExpressionOp %prec uMinus

    | IdAssign equal ExpressionOp
        {$$ = new AssignVariable($1, $3, @1.first_line, @1.first_column);}
    | IdAssign

    | 'true'                     
        {$$ = new Symbol('boolean', 1,              @1.first_line, @1.first_column);}
    | 'false'                    
        {$$ = new Symbol('boolean', 0,              @1.first_line, @1.first_column);}
    | number                    
        {$$ = new Symbol('number',  parseFloat($1), @1.first_line, @1.first_column);}
    | strng                   
        {$$ = new Symbol('string',  $1,             @1.first_line, @1.first_column);}
    | null 
        {$$ = new Symbol();}
    | leftSqrBrkt rightSqrBrkt //[]
    | ObjectStrc

    ;

ExpressionList
    : ExpressionList comma Expression
    | Expression
    ;



IdAssign
    : IdAssign leftSqrBrkt Expression rightSqrBrkt 
    | IdAssign dot id
    | IdAssign leftPar rightPar
        {$$ = new Call($1, new Array(), @1.first_line, @1.first_column);}
    | IdAssign leftPar ParameterList rightPar
        {$$ = new Call($1, $3, @1.first_line, @1.first_column);}
    | id
        {$$ = new GetId ($1, @1.first_line, @1.first_column); }    
    | id increase
    | id decrease
    ;


   

ParameterList
    : ParameterList comma Expression
        {$$ = $1.concat($3);}
    | Expression
        {$$ = new Array($1);}
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
            { $$ = new IfSttmnt($3, $6, undefined, @1.first_line, @1.first_column); }
        | if leftPar Expression rightPar leftCrlBrkt FunctionBody rightCrlBrkt else IfStatement
            { $$ = new IfSttmnt($3, $6, $9, @1.first_line, @1.first_column); }
        | if leftPar Expression rightPar leftCrlBrkt FunctionBody rightCrlBrkt else leftCrlBrkt FunctionBody rightCrlBrkt 
            { $$ = new IfSttmnt($3, $6, new IfSttmnt(undefined, $10, undefined, @8.first_line, @8.first_column), @1.first_line, @1.first_column); }
        ;


    WhileStatement                  
        : while leftPar Expression rightPar leftCrlBrkt FunctionBody rightCrlBrkt 
            { $$ = new WhileSttmnt($3, $6, @1.first_line, @1.first_column); }
        ;

    DoWhileStatement                
        : do leftCrlBrkt FunctionBody rightCrlBrkt while leftPar Expression rightPar SemicolonE
            { $$ = new DoWhileSttmnt($7, $3, @1.first_line, @1.first_column); }
        ;


    SwitchStatement
        : switch leftPar Expression rightPar leftCrlBrkt CaseStatementList_  rightCrlBrkt 
        ;

    CaseStatementList_
        : CaseStatementList
        |
        ;

    CaseStatementList
        : CaseStatementList CaseStatement
        | CaseStatementList DefaultStatement
        | CaseStatement
        | DefaultStatement
        ;


    CaseStatement
        : case Expression colon FunctionBody
        ;

    DefaultStatement
        : default colon FunctionBody
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
        | for leftPar let      id in Expression  rightPar leftCrlBrkt FunctionBody rightCrlBrkt
        | for leftPar const    id in Expression  rightPar leftCrlBrkt FunctionBody rightCrlBrkt
        | for leftPar let      id of Expression  rightPar leftCrlBrkt FunctionBody rightCrlBrkt
        | for leftPar const    id of Expression  rightPar leftCrlBrkt FunctionBody rightCrlBrkt
        ;


    ForDecOr
        : let   id TypeAttribute VariableExpression
        |
        ;

    ExpOr
        : Expression
        |
        ;

 
