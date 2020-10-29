

/* description: Parses and executes mathematical expressions. */

/* lexical grammar */
%lex
%name parse
// %options ranges


blockcomment                [/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]   /* IGNORE */

number                      [0-9]+
digit                       [0-9]+("."[0-9]+)+
chr                         ("'" [^'/*'*/ ] "'" )
label                       [L][0-9]+

// file                        (([-a-zA-Z0-9ñÑ]|".")+ "."[j])
id                          [_a-zA-Z][_a-zA-Z0-9ñÑ]*

%s                comment



%%

// "//".*                /* skip comments */
// "/*"                  this.begin('comment');
// <comment>"*/"         this.popState();
// <comment>.            /* skip comment content*/




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

"\"%d\""                     return 'dd';
"\"%e\""                     return 'ee';
"\"%c\""                     return 'cc';


{label}                     return 'label';
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




"["                         return 'leftSquareBraquet';
"]"                         return 'rightSquareBraquet';

"("                         return 'leftParen';
")"                         return 'rightParen';

"="                         return 'equal';
";"                         return 'semicolon';
":"                         return 'colon';
","                         return 'comma';




"//".*                                /* IGNORE */
{blockcomment}





\s+                         /* skip whitespace */
"."                         throw 'Illegal character';
<<EOF>>                     return 'endOfFile';



/lex


%{

  

// //import {Temporal, TemporalLeave} from '../../App/Temporal/Temporal';

//  var CodeLine = require('../../models/_3AddressCode/CodeLine/CodeLine').CodeLine;
//  var Expression = require('../../models/_3AddressCode/CodeLine/Expression').Expression;
//  var Value = require('../../models/_3AddressCode/CodeLine/Value').Value;
//  var TemporalCall = require('../../models/_3AddressCode/CodeLine/TemporalCall').TemporalCall;

// //stack { set, get }
//  var SetStack = require('../../models/_3AddressCode/MemoryAccess/StackAccess').SetStack;
//  var GetStack = require('../../models/_3AddressCode/MemoryAccess/StackAccess').GetStack;

// //heap { set, get }
//  var SetHeap = require('../../models/_3AddressCode/MemoryAccess/HeapAccess').SetHeap;
//  var GetHeap = require('../../models/_3AddressCode/MemoryAccess/HeapAccess').GetHeap;

// // Label
// var Label = require('../../models/_3AddressCode/Label/Label').Label;

// // Goto
// var Goto = require('../../models/_3AddressCode/Label/Goto').Goto;

// // if - ifFalse
// var IfFalse = require('../../models/_3AddressCode/Label/IfFalse').IfFalse;
// var If = require('../../models/_3AddressCode/Label/If').If;

// // Method - Call
// var Method = require('../../models/_3AddressCode/Method/Method').Method;
// var Call = require('../../models/_3AddressCode/Method/Call').Call;

// // Print
// var Print = require('../../models/_3AddressCode/Print/Print').Print;


   
   
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
    : MainList endOfFile
        // { return  $1; }
    | endOfFile

    ;

MainList
    : MethodList Code_Label_List
        // { $$ = $1.concat($2); }
    ;

MethodList
    : MethodList Method
        // { var list =   $1  ; list.push( $2 );   $$ = list;  }
    | Method
        { var list = new Array($1);             $$ = list;  }
    ;

Method
    : proc id begin Code_Label_List end
        // { $$ = new Method($2, $4); }
    ;

Code_Label_List
    : Code Label_LabelList_OrEmpty
        // { $$ = $1.concat($2); }
    ;

Code
    :  Code_Memory_List
        // { $$ = $1; }
    |
        // { $$ = new Array(); }
    ;

Label_LabelList_OrEmpty
    :  Label_LabelList
        // { $$ = $1; }
|
    // { $$ = new Array(); }
    ;

Label_LabelList
    : Label_LabelList LabelList
        // { var list =   $1  ; list.push( $2 );   $$ = list;  }
    | LabelList
        // { var list = new Array($1);             $$ = list;  }
    ;

LabelList
    : LabelList Code_Memory
        // { var list = $1;  list.add($2); $$ = list;  }
    | Label
        // { $$ = new Label($1);   }
    ;


Code_Memory_List
    : Code_Memory_List Code_Memory
        // { var list =   $1  ; list.push( $2 );   $$ = list;  }
    | Code_Memory
        // { var list = new Array($1);             $$ = list;  }
    ;

Code_Memory
    : CodeLine
        // { $$ = $1; }
    | MemoryAccess
        // { $$ = $1; }
    | Print
        // { $$ = $1; }
    | MethodCall
        // { $$ = $1; }
    ;


CodeLine
    : id equal Expression semicolon
        // { $$ = new CodeLine($1, $3); }
    | goto label semicolon
        // { $$ = new Goto($2); }
    | if        leftParen Expression rightParen goto label semicolon
        // { $$ = new If($3, $6); }
    | ifFalse   leftParen Expression rightParen goto label semicolon
        // { $$ = new IfFalse($3, $6); }
    ;

MemoryAccess
    : stack leftSquareBraquet Value rightSquareBraquet equal Value semicolon
        // { $$ = new SetStack ($3, $6); }
    | heap  leftSquareBraquet Value rightSquareBraquet equal Value semicolon
        // { $$ = new SetHeap  ($3, $6); }

    | id equal stack    leftSquareBraquet Value rightSquareBraquet semicolon
        // { $$ = new GetStack ($1, $5); }
    | id equal heap     leftSquareBraquet Value rightSquareBraquet semicolon
        // { $$ = new GetHeap  ($1, $5); }
    ;

Print
    : print leftParen cc comma id rightParen semicolon
        // { $$ = new Print($3, new TemporalCall($5)); }
    | print leftParen ee comma id rightParen semicolon
        // { $$ = new Print($3, new TemporalCall($5)); }
    | print leftParen dd comma id rightParen semicolon
        // { $$ = new Print($3, new TemporalCall($5)); }
    ;

MethodCall
    : call id semicolon
        // { $$ = new Call($2); }
    ;

Label
    : label colon
        // { $$ = $1; }
    ;

Expression
    :
    // Value 'equality'         Value
    // //     { $$ = new Expression($2, $1, $3); }
    // | Value 'inequality'       Value
    // //     { $$ = new Expression($2, $1, $3); }

    // | Value 'lessThan'         Value
    // //     { $$ = new Expression($2, $1, $3); }
    // | Value 'greaterThan'      Value
    // //     { $$ = new Expression($2, $1, $3); }
    // | Value 'lessEqual'
    // //     { $$ = new Expression($2, $1, $3); }
    // | Value 'greaterEqual'     Value
    // //     { $$ = new Expression($2, $1, $3); }

    // |
    Value 'plus'             Value
        // { $$ = new Expression($2, $1, $3); }
    | Value 'minus'            Value
        // { $$ = new Expression($2, $1, $3); }

    // | Value 'times'            Value
    // //     { $$ = new Expression($2, $1, $3); }
    // | Value 'divide'           Value
    // //     { $$ = new Expression($2, $1, $3); }
    // | Value 'module'           Value
    // //     { $$ = new Expression($2, $1, $3); }
    | Value
        // { $$ = $1; }
    ;

Value
    : number
        // { $$ = new Value($1);           }
    | id
        // { $$ = new TemporalCall($1);    }
    ;



