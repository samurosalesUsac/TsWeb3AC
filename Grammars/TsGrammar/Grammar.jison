

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
"console.log"                   return 'print';


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


   
%}

%left       comma
%right      pEqual mEqual tEqual dEequal aEqual oEqual xEqual mdEqual equal colonEqual
%right      questionMark colon
%left       or
%left       and
%left       potency
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


        
        // { return new MainScope($1,$2);  }
        // {  $$ = new ImportFiles(new Array()); }
        // ArrayList
        // {$$ = new ObjectClass($1, $3, $6, $4, @1.first_line, @1.first_column);}
        // Arraylist
        // {$$ = new Function ($1, $2, $3, $4, $6, @1.first_line, @1.first_column );}

InitMain 
    : BodyList endOfFile
        { 

            
            //                      Access     type    name  parameters  body 
            let func = new Function (undefined,'void', 'main', new Array(),new Body($1.filter(node => !(node instanceof VariableCreation))), -2, -2);
            let classList =$1.filter(node => node instanceof VariableCreation).concat(new Array(func));
            let classObj = new ObjectClass(undefined, '_0', classList,'Object',-2,-2);
            
            return new MainScope(new Array(), new Array(classObj));
        }
    | endOfFile
        {console.log(Symbol)}
    ;

SemicolonE
    : semicolon
    |
    ;

FunctionBody
    : BodyList 
        { $$ = new Body($1); }
    | 
        { $$ = new Body(new Array()); } 
    ;


BodyList
    : BodyList BodyElement      
        { $$ = $1.concat($2); } 
    | BodyElement               
        { $$ = new Array($1); }
    ;

TypeAttribute
    : colon VariableType
        {$$ = $2;}
    |
        {$$ = undefined;}
    ;

BodyElement 
    : let id TypeAttribute equal Expression SemicolonE
        {$$ = new VariableCreation(undefined, $3? $3 : $1, $2, $5, @1.first_line, @1.first_column );}
    | const id TypeAttribute equal Expression SemicolonE
        {$$ = new VariableCreation(undefined, $3? $3 : $1, $2, $5, @1.first_line, @1.first_column );}
        

    | IdCall SemicolonE
    | IdCall equal Expression SemicolonE 


    | IfStatement 
        { $$ = $1; }  
    | WhileStatement 
        { $$ = $1; }  
    | DoWhileStatement 
        { $$ = $1; }

    // Print
    | print leftPar Expression rightPar SemicolonE
        {$$ = new PrintSttmnt($3, @1.first_line, @1.first_column);}

    | break SemicolonE
        { $$ = new BreakSttmnt(@1.first_line, @1.first_column)}
    | return Expression SemicolonE
        {$$ = new ReturnSttmnt($2, @1.first_line, @1.first_column)}
    | return semicolon
        {$$ = new ReturnSttmnt(undefined, @1.first_line, @1.first_column)}
        // Functions
    // | VariableType id leftPar FunctionparameterListOrEmpty rightPar leftCrlBrkt FunctionBody rightCrlBrkt
    //      {$$ = new Function ($1, $2, $4, $7, @1.first_line, @1.first_column );}

    | function id leftPar FunctionparameterListOrEmpty rightPar 
        TypeAttribute
        leftCrlBrkt FunctionBody rightCrlBrkt

         {$$ = new Function (undefined, $6, $2, $4, $8, @1.first_line, @1.first_column );}
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
    : FunctionparameterList {  $$ = $1 }
    | { $$ = new Array(); }
    ;

FunctionparameterList
    : FunctionparameterList comma  id colon VariableType     { let list = $1; list.push({ type : $5, name : $3 }); $$ = list; }
    |  id colon VariableType                                 { $$ = new Array({ type : $3, name : $1 }); }
    ;




// InitMain 
//     : ImportOr ObjClassList endOfFile    
//         {return 'hola mierda';}
//     | endOfFile
//         {return 'adios mierda';}
//     ;

// AccessLevel
//     : public AccessState
//     | private AccessState
//     | protected AccessState
//     | AccessState
//     ;
    
// AccessState
//     : abstract
//     | final
//     | static
//     |
//     ;

// ObjClassList
//     : ObjClassList ObjClass
//     | ObjClass 
//     ;

// ObjClass
//     : AccessLevel class id ExtendsOr leftCrlBrkt MainList rightCrlBrkt
//     | AccessLevel class id ExtendsOr leftCrlBrkt          rightCrlBrkt
//     ;

// ExtendsOr
//     : extends id 
//     | 
//     ;

// MainListOr
//     : MainList 
//     | 
//     ;

// MainList	
//     : MainList Main 
//     | Main
//     ;
 
// ImportOr
//     : ImportList semicolon
//     |
//     ;

// ImportList
//     : ImportList comma file
//     | import file
//     ;


// Main 
//     : VariablesAndFuntions
//     ;


// ParameterList
//     : ParameterList comma Expression
//     | Expression
//     ;

// ParameterDeclaration
//     : ParameterDeclaration comma VariableType id
//     | VariableType id
//     ;

// Parameters
//     : leftPar ParameterDeclaration rightPar
//     | leftPar rightPar
//     ;

// FunctionBody
//     : BodyList
//     |
//     ;

// BodyList
//     : BodyList BodyElement
//     | BodyElement 
//     ;

VariableType
    : number
    | string
    | void          
    | boolean   
    | id
    ;


// IdList
//     : IdList comma id
//     | id
//     ;   

// SqreList
//     : SqreList leftSqrBrkt rightSqrBrkt
//     | leftSqrBrkt rightSqrBrkt
//     ;

// BrqutExpList
//     : BrqutExpList comma Expression
//     | BrqutExpList comma BrqutList
//     | Expression
//     | BrqutList
//     ;

// BrqutList
//     : leftCrlBrkt BrqutExpList rightCrlBrkt
//     ;




Expression
    : ExpressionOp 
        { $$ = new ExpressionNode($1); } 
    ;

ExpressionOp
    : 
    ExpressionOp questionMark     ExpressionOp colon ExpressionOp
//logical
    | ExpressionOp or               ExpressionOp         
        {$$ = new LogicalExpression($2, $1, $3, @2.first_line, @2.first_column); } 
    | ExpressionOp and              ExpressionOp         
        {$$ = new LogicalExpression($2, $1, $3, @2.first_line, @2.first_column); } 

    | not ExpressionOp

//relacional
    | ExpressionOp equality         ExpressionOp          
        {$$ = new RelationalExpression($2, $1, $3, @2.first_line, @2.first_column); }
    | ExpressionOp inequality       ExpressionOp          
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
        {$$ = new AritmethicalExpression($2, $1, $3, @2.first_line, @2.first_column);} 
    | ExpressionOp minus            ExpressionOp          
        {$$ = new AritmethicalExpression($2, $1, $3, @2.first_line, @2.first_column);} 

    | ExpressionOp times            ExpressionOp          
        {$$ = new AritmethicalExpression($2, $1, $3, @2.first_line, @2.first_column);} 
    | ExpressionOp divide           ExpressionOp          
        {$$ = new AritmethicalExpression($2, $1, $3, @2.first_line, @2.first_column);} 
    | ExpressionOp module           ExpressionOp          
        {$$ = new AritmethicalExpression($2, $1, $3, @2.first_line, @2.first_column);} 

    | ExpressionOp potency          ExpressionOp          
        {$$ = new AritmethicalExpression($2, $1, $3, @2.first_line, @2.first_column);} 

    | leftPar ExpressionOp rightPar                     
        {$$=$2;}

    | leftSqrBrkt ExpressionList rightSqrBrkt
        { $$=$2; }

    | increase id %prec preincrease
    | decrease id %prec predecrease

    | IdAssign equal ExpressionOp
    | IdAssign
        {$$=$1;}


    | 'true'                     {$$ = new Symbol(1,     1, @1.first_line, @1.first_column); }              
    | 'false'                    {$$ = new Symbol(1,     0, @1.first_line, @1.first_column); }              
    | number                     {$$ = new Symbol(2,    $1, @1.first_line, @1.first_column); }          
    // | digit                      {$$ = new Symbol('digit',      $1, @1.first_line, @1.first_column); }      
    | strng                      {$$ = new Symbol(3,     $1, @1.first_line, @1.first_column); }  
    // | chr                        {$$ = new Symbol('char',       $1, @1.first_line, @1.first_column); }          

    ;

ExpressionList
    : ExpressionList comma Expression
        { $$ = $1.concat($3); } 
    | Expression
        { $$ = new Array($1); }
    ;



IdAssign
    : IdAssign leftSqrBrkt Expression rightSqrBrkt 
    | IdAssign dot id
    | IdAssign leftPar rightPar
    | IdAssign leftPar ParameterList rightPar
    | id
        {$$ = new GetId ($1, @1.first_line, @1.first_column); }    
    | id increase
    | id decrease
    ;

// IdCall
//     : leftPar rightPar
//     | leftPar ParameterList rightPar
//     | leftSqrBrkt Expression rightSqrBrkt
//     | dot id

//     | IdCall leftPar rightPar
//     | IdCall leftPar ParameterList rightPar
//     | IdCall leftSqrBrkt Expression rightSqrBrkt
//     | IdCall dot id

//     ; 
    
    
    
// IdCall
//     : leftPar rightPar
//     | leftPar ParameterList rightPar
//     | leftSqrBrkt Expression rightSqrBrkt
//     | dot id

//     | IdCall leftPar rightPar
//     | IdCall leftPar ParameterList rightPar
//     | IdCall leftSqrBrkt Expression rightSqrBrkt
//     | IdCall dot id

//     ; 

// BodyElement
//     : VariableType IdList SemicolonE 
//     | VariableType IdList equal Expression SemicolonE 

//     | VariableType id SqreList SemicolonE
//     | VariableType id SqreList equal BrqutList SemicolonE

//     | var          IdList equal Expression SemicolonE

//     | id leftPar rightPar SemicolonE
//     | id leftPar ParameterList rightPar SemicolonE
//     | id leftSqrBrkt Expression rightSqrBrkt equal Expression SemicolonE
//     | id dot id equal Expression SemicolonE
    
//     | id leftPar rightPar IdCall SemicolonE
//     | id leftPar ParameterList rightPar IdCall SemicolonE
//     | id leftSqrBrkt Expression rightSqrBrkt IdCall equal Expression SemicolonE
//     | id dot id IdCall equal Expression SemicolonE

//     | id increase
//     | id decrease

//     | IfStatement
//     | WhileStatement
//     | DoWhileStatement
//     | ForStatement

//     ;

// VariablesAndFuntions
//     : AccessLevel VariableType IdList SemicolonE
//     | AccessLevel VariableType IdList equal Expression SemicolonE
//     | AccessLevel VariableType id Parameters leftCrlBrkt FunctionBody rightCrlBrkt
//     ;





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
        //   {: RESULT = new IfStatement(ifst, exp, beg, iflleft, iflright); :}
        | if leftPar Expression rightPar leftCrlBrkt FunctionBody rightCrlBrkt else leftCrlBrkt FunctionBody rightCrlBrkt 
          { $$ = new IfSttmnt($3,$6, new IfSttmnt(undefined, $10, undefined, @8.first_line, @8.first_column), @1.first_line, @1.first_column); }
        ;


    WhileStatement                  
        : while leftPar Expression rightPar leftCrlBrkt FunctionBody rightCrlBrkt 
          { $$ = new WhileSttmnt($3, $6, @1.first_line, @1.first_column); }
        ;

    DoWhileStatement                
        : do leftCrlBrkt FunctionBody rightCrlBrkt while leftPar Expression rightPar SemicolonE
          { $$ = new DoWhileSttmnt($7, $3, @1.first_line, @1.first_column); }
        ;


    // ForStatement
    //     : for leftPar 
    //         ForDecOr 
    //     semicolon
    //         ExpOr
    //     semicolon
    //         ExpOr 
    //     rightPar

    //     leftCrlBrkt FunctionBody rightCrlBrkt 
    //         {$$ = new ForSttmnt($3, $5, $7, $10, @1.first_line, @1.first_column);}
    //     ;


    // ForDecOr
    //     : ForDeclaration
    //     |
    //     ;

    // ExpOr
    //     : Expression
    //     |
    //     ;

    // ForDeclaration
    //     : var               id colonEqual Expression 
        
    //     | VariableType      idList equal  Expression 
    //         {$$ = new VariableCreation(undefined, $1, $2, $4, @1.first_line, @1.first_column );}
    //     | VariableType      idList                   
    //         {$$ = new VariableCreation(undefined, $1, $2, undefined, @1.first_line, @1.first_column );}
    //     ;
