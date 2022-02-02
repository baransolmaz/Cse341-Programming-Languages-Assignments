%{
    #include <stdio.h>
    #include <ctype.h>
    #include "gpp_interpreter.h"
    void yyerror(char *);
    extern YYSTYPE yylval; 
    int count=0;
%}
%%
"and" { return KW_AND;}
"or" {return KW_OR;}
"not" {return KW_NOT;}
"equal" {return KW_EQUAL;} 
"less" {return KW_LESS;}
"nil" {return KW_NIL;}
"list" {return KW_LIST;}
"append" {return KW_APPEND;}
"concat" {return KW_CONCAT;}
"set" {return KW_SET;}
"deffun" {return KW_DEFFUN;}
"for" {return KW_FOR;}
"if" {return KW_IF;}
"exit" {return KW_EXIT;}
"load" {return KW_LOAD;}
"disp" {return KW_DISP;}
"true" {return KW_TRUE;}
"false" {return KW_FALSE;}

"(" {return OP_OP;}
")" {return OP_CP;}
"+ " {return OP_PLUS;}
"-" {return OP_MINUS;}
"* " {return OP_MULT;}
"/ " {return OP_DIV;}
"**" {return OP_DBLMULT;}
"\"" { if (count==0){ count=1; return OP_OC;}
        else{ count=0; return OP_CC;}}
"," {return OP_COMMA;}

";;".* {return COMMENT;} 
[0]|[1-9][0-9]*[.]?[0-9]*|[0][.][0-9]* { yylval.val=atoi(yytext); return VALUE;}
[a-zA-Z_][a-zA-Z_0-9]* {strcpy(yylval.id,yytext);return IDENTIFIER;}

"\t"|" "|"\n" { ;}
[0][0-9]* {yyerror("INVALID VALUE-- Leading 0");}
[0-9]+[a-zA-Z_][a-zA-Z_0-9]* {yyerror("INVALID IDENTIFIER-- Leading Digit");}
. {yyerror("SYNTAX_ERROR Expression not recognized");}
%%

int yywrap(){ }