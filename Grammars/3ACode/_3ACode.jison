

/* description: Parses and executes mathematical expressions. */

/* lexical grammar */
%lex
%options ranges
%options case-insensitive

number                      [0-9]+                 
digit                       [0-9]+("."[0-9]+)+     
label                       [L][0-9]+

id                          [_a-zA-Z][_a-zA-Z0-9ñÑ]*

%s                comment

%%

"#".*                /* skip comments */
"#*"                  this.begin('comment');
<comment>"*#"         this.popState();
<comment>.            /* skip comment content*/



"stack"                     return 'stack';
"heap"                      return 'heap';

"goto"                      return 'goto';
"ifFalse"                   return 'ifFalse';
"if"                        return 'if';

"proc"                      return 'proc';
"begin"                     return 'begin';
"end"                       return 'end';

"call"                      return 'call';
"print"                     return 'print';
"end"                       return 'end';

"error"                     return 'error';


"\"%d\""                     return 'dd';
"\"%i\""                     return 'ee';
"\"%c\""                     return 'cc';



{label}                     return 'label';
{digit}                     return 'digit';
{number}                    return 'number';
{id}                        return 'id';



/* Operators */
/* 5 */
"=="                        return 'equality';
"!="                        return 'inequality';
/* .. 5 */

/* 6 */
">"                         return 'greaterThan';
"<"                         return 'lessThan';
">="                        return 'greaterEqual';
"<="                        return 'lessEqual';
/* .. 6 */

/* 7 */
"+"                         return 'plus';
"-"                         return 'minus';
/* .. 7 */

/* 8 */
"*"                         return 'times';
"/"                         return 'divide';
"%"                         return 'module';
/* .. 8 */

// /* 9 */
// "^"                         return 'potency';
// /* .. 9 */



"@+"                         return 'at+';
"@-"                         return 'at-';
"@/"                         return 'at/';
"@*"                         return 'at*';
"@^"                         return 'at^';
"@%"                         return 'at%';

"["                         return 'leftSquareBraquet';
"]"                         return 'rightSquareBraquet';

"("                         return 'leftParen';
")"                         return 'rightParen';

"="                         return 'equal';
";"                         return 'semicolon';
":"                         return 'colon';
","                         return 'comma';


\s+                         /* skip whitespace */


"."                         throw 'Illegal character';

<<EOF>>                     return 'endOfFile';



/lex


%{


   
%}



%% 


/*
   _____                                          
  / ____|                                         
 | |  __ _ __ __ _ _ __ ___  _ __ ___   __ _ _ __ 
 | | |_ | '__/ _` | '_ ` _ \| '_ ` _ \ / _` | '__|
 | |__| | | | (_| | | | | | | | | | | | (_| | |   
  \_____|_|  \__,_|_| |_| |_|_| |_| |_|\__,_|_|   
                                                  
*/



InitCode
    : LineOfCodeList endOfFile
        { return  new Main($1); }
    | endOfFile
    ;


Method
    : proc id begin Label_LabelList_OrEmpty end
        { $$ = new Method($2, $4); }
    ;



Label_LabelList_OrEmpty
    :  Label_LabelList
        { $$ = $1; }
|
    { $$ = new Array(); }
    ;

Label_LabelList
    : Label_LabelList LabelList
        { var list =   $1  ; list.concat( $2 );   $$ = list;  }
    | LabelList
        { var list = new Array($1);             $$ = list;  }
    | Code_Memory_List
        { var list = new Label('l'); list.add($1);           $$ = list;  }
    | Method
        { $$ = Array($1); }
    ;

LabelList
    : LabelList Code_Memory
        { var list = $1;  list.add($2); $$ = list;  }
    | Label
        { $$ = new Label($1);   }
    ;


Code_Memory_List
    : Code_Memory_List Code_Memory
        { var list =   $1  ; list.concat( $2 );   $$ = list;  }
    | Code_Memory
        { var list = new Array($1);             $$ = list;  }
    ;

Code_Memory
    : CodeLine
        { $$ = $1; }
    | MemoryAccess
        { $$ = $1; }
    | Print
        { $$ = $1; }
    | MethodCall
        { $$ = $1; }
    ;


// CodeLine
//     : id equal Expression semicolon
//         { $$ = new CodeLine($1, $3); }
//     | goto label semicolon
//         { $$ = new Goto($2); }
//     | if        leftParen Expression rightParen goto label semicolon
//         { $$ = new If($3, $6); }
//     | ifFalse   leftParen Expression rightParen goto label semicolon
//         { $$ = new IfFalse($3, $6); }

//     // | proc id begin Code_Label_List end
//     //     { $$ = new Method($2, $4); }
//     ;

// MemoryAccess
//     : stack leftSquareBraquet Value rightSquareBraquet equal Value semicolon
//         { $$ = new SetStack ($3, $6); }
//     | heap  leftSquareBraquet Value rightSquareBraquet equal Value semicolon
//         { $$ = new SetHeap  ($3, $6); }

//     | id equal stack    leftSquareBraquet Value rightSquareBraquet semicolon
//         { $$ = new GetStack ($1, $5); }
//     | id equal heap     leftSquareBraquet Value rightSquareBraquet semicolon
//         { $$ = new GetHeap  ($1, $5); }
//     ;

// Print
//     : print leftParen cc comma id rightParen semicolon
//         { $$ = new Print($3, new TemporalCall($5)); }
//     | print leftParen ee comma id rightParen semicolon
//         { $$ = new Print($3, new TemporalCall($5)); }
//     | print leftParen dd comma id rightParen semicolon
//         { $$ = new Print($3, new TemporalCall($5)); }
//     ;

// MethodCall
//     : call id semicolon
//         { $$ = new CodeCall($2); }
//     ;

// Label
//     : label colon
//         { $$ = $1; }
//     ;

LineOfCodeList
    : LineOfCodeList LineOfCode
        {$$ = $1.concat($2);}
    | LineOfCode
        {$$=new Array($1);}
    ;

LineOfCode
    : id equal Expression semicolon
        { $$ = new CodeLine($1, $3); }
    | goto label semicolon
        { $$ = new Goto($2); }
    | if        leftParen Expression rightParen goto label semicolon
        { $$ = new If($3, $6); }
    | ifFalse   leftParen Expression rightParen goto label semicolon
        { $$ = new IfFalse($3, $6); }

    | stack leftSquareBraquet Value rightSquareBraquet equal Value semicolon
        { $$ = new SetStack ($3, $6); }
    | heap  leftSquareBraquet Value rightSquareBraquet equal Value semicolon
        { $$ = new SetHeap  ($3, $6); }

    | id equal stack    leftSquareBraquet Value rightSquareBraquet semicolon
        { $$ = new GetStack ($1, $5); }
    | id equal heap     leftSquareBraquet Value rightSquareBraquet semicolon
        { $$ = new GetHeap  ($1, $5); }

    | print leftParen cc comma Value rightParen semicolon
        { $$ = new Print($3, $5); }
    | print leftParen ee comma Value rightParen semicolon
        { $$ = new Print($3, $5); }
    | print leftParen dd comma Value rightParen semicolon
        { $$ = new Print($3, $5); }

    | call id semicolon
        { $$ = new CodeCall($2); }

    | label colon
        { $$ = new Label($1); }

    | proc id begin
        {$$= new Begin($2);}
    | end
        {$$= new End();}

    | error Value colon Value
        {$$ = new Error($2, $4)}
    ;




Expression
    : Value 'equality'         Value
        { $$ = new CodeExpression($2, $1, $3); }
    | Value 'inequality'       Value
        { $$ = new CodeExpression($2, $1, $3); }

    | Value 'lessThan'         Value
        { $$ = new CodeExpression($2, $1, $3); }
    | Value 'greaterThan'      Value
        { $$ = new CodeExpression($2, $1, $3); }
    | Value 'lessEqual'
        { $$ = new CodeExpression($2, $1, $3); }
    | Value 'greaterEqual'     Value
        { $$ = new CodeExpression($2, $1, $3); }

    | Value 'plus'             Value
        { $$ = new CodeExpression($2, $1, $3); }
    | Value 'minus'            Value
        { $$ = new CodeExpression($2, $1, $3); }

    | Value 'times'            Value
        { $$ = new CodeExpression($2, $1, $3); }
    | Value 'divide'           Value
        { $$ = new CodeExpression($2, $1, $3); }
    | Value 'module'           Value
        { $$ = new CodeExpression($2, $1, $3); }

    | Value 'at+' Value

    | Value
        { $$ = $1; }
    ;

Value
    : number
        { $$ = new Value($1);           }
    | id
        { $$ = new TemporalCall($1);    }
    ;



