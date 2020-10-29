

/* description: Parses and executes mathematical expressions. */

/* lexical grammar */
%lex
%options ranges

// blockcomment                [/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]   /* IGNORE */

// number                      [0-9]+                 
// digit                       [0-9]+("."[0-9]+)+     
number                          [0-9]+("."[0-9]+)? 
chr                         ("'" [^'/*'*/ ]* "'" )
backstick                    ("`" [^`]* "`" )

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
   
getIndex = function () {
    return globalIndex++
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
        {return new GraphNode('BodyList', new Array($1, new GraphNode('endOfFile')))}
    | endOfFile
        {return new GraphNode('BodyList', new Array(new GraphNode('endOfFile')))}
    ;

SemicolonE
    : semicolon
        {$$ = new Terminal($1)}
    |
    ;

FunctionBody
    : BodyList
        {$$ = new GraphNode('FunctionBody', new Array($1));}
    | 

    ;
RightFunctionBody
    : RightBodyList
        {$$ = new GraphNode('RightFunctionBody', $1);}
    |
    ;

RightBodyList
    : BodyElement

    | BodyElement RightBodyList

    ;

BodyList
    : BodyList BodyElement      
        {$$ = new GraphNode('BodyList', new Array(new GraphNode('BodyList',$1),new GraphNode('BodyElement',$2)));}
    | BodyElement        
        {$$ = new GraphNode('BodyElement', new Array($1));}
    ;

TypeAttribute
    : colon VariableType
        {$$ = new GraphNode('TypeAttribute', new Array(
            new TerminalNode($1),
            new TerminalNode($2)
        ));}
    |
    ;


VariableExpression
    : equal Expression
        {$$ = new GraphNode('VariableExpression', new Array(
            new TerminalNode($1),
            new TerminalNode($2)
        ));}
    |
    ;

VariableDec
    : VariableDec comma id TypeAttribute VariableExpression
    | let   id TypeAttribute VariableExpression
        {$$ = new GraphNode('VariableDec', new Array(
            new TerminalNode($1),
            new TerminalNode($2),
            $3,
            $4
        ))}
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
        {$$ = new GraphNode('BodyElement', new Array($1,$2));}
    | IdCall SemicolonE
    | IdCall equal Expression SemicolonE 

    | type id equal ObjectList SemicolonE
        
    | IfStatement 
    | WhileStatement 
    | DoWhileStatement 
    | ForStatement
    | SwitchStatement

    // Print
    // | print leftPar Expression rightPar SemicolonE

    | break SemicolonE
    | return Expression SemicolonE
    | return semicolon
    | continue SemicolonE
        // Functions
    // | VariableType id leftPar FunctionparameterListOrEmpty rightPar leftCrlBrkt FunctionBody rightCrlBrkt
    //      {$$ = new Function ($1, $2, $4, $7, @1.first_line, @1.first_column );}

    | function id leftPar FunctionparameterListOrEmpty rightPar 
        TypeAttribute
        leftCrlBrkt RightFunctionBody rightCrlBrkt
    
  

    ;


IdCall
    : IdCall leftPar rightPar
    | IdCall leftPar ParameterList rightPar
    | IdCall leftSqrBrkt Expression rightSqrBrkt
    | IdCall dot id

    | id
    | id increase
    | id decrease

    ; 


FunctionparameterListOrEmpty
    : FunctionparameterList
    | 
    ;

FunctionparameterList
    : FunctionparameterList comma  id colon VariableType     
    |  id colon VariableType                                
    ;




VariableType
    : number
        {$$=$1;}
    | string
        {$$=$1;}
    | void          
        {$$=$1;}
    | boolean   
        {$$=$1;}
    | id
        {$$=$1;}
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
    | ExpressionOp and              ExpressionOp         

    | not ExpressionOp

//relacional
    | ExpressionOp equality         ExpressionOp          
    | ExpressionOp inequality       ExpressionOp          

    | ExpressionOp lessThan         ExpressionOp          
    | ExpressionOp greaterThan      ExpressionOp          
    | ExpressionOp lessEqual        ExpressionOp          
    | ExpressionOp greaterEqual     ExpressionOp          

//Arithmetical

    | ExpressionOp plus             ExpressionOp          
    | ExpressionOp minus            ExpressionOp          

    | ExpressionOp times            ExpressionOp          
    | ExpressionOp divide           ExpressionOp          
    | ExpressionOp module           ExpressionOp          

    // | ExpressionOp potency          ExpressionOp          
    | ExpressionOp power ExpressionOp                     

    | leftPar ExpressionOp rightPar                     
    
    | leftSqrBrkt ExpressionList rightSqrBrkt

    | increase id %prec preincrease
    | decrease id %prec predecrease

    // | id increase
    // | id decrease

    | minus ExpressionOp %prec uMinus

    | IdAssign equal ExpressionOp
    | IdAssign


    | 'true'                     
    | 'false'                    
    | number                    
    | strng                   
    | null 

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
    | IdAssign leftPar ParameterList rightPar
    | id
    | id increase
    | id decrease
    ;

   

ParameterList
    : ParameterList comma Expression
    | Expression
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
        | if leftPar Expression rightPar leftCrlBrkt FunctionBody rightCrlBrkt else IfStatement
        | if leftPar Expression rightPar leftCrlBrkt FunctionBody rightCrlBrkt else leftCrlBrkt FunctionBody rightCrlBrkt 
        ;


    WhileStatement                  
        : while leftPar Expression rightPar leftCrlBrkt FunctionBody rightCrlBrkt 
        ;

    DoWhileStatement                
        : do leftCrlBrkt FunctionBody rightCrlBrkt while leftPar Expression rightPar SemicolonE
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
        : VariableDec
        |
        ;

    ExpOr
        : Expression
        |
        ;

 
