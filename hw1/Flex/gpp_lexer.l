%{
    int count=0;
%}
%%
"and" { printf("KW_AND\n");}
"or" { printf("KW_OR\n");}
"not" { printf("KW_NOT\n");}
"equal" { printf("KW_EQUAL\n");} 
"less" { printf("KW_LESS\n");}
"nil" { printf("KW_NIL\n");}
"list" { printf("KW_LIST\n");}
"append" {printf("KW_APPEND\n");}
"concat" { printf("KW_CONCAT\n");}
"set" { printf("KW_SET\n");}
"deffun" { printf("KW_DEFFUN\n");}
"for" { printf("KW_FOR\n");}
"if" { printf("KW_IF\n");}
"exit" { printf("KW_EXIT\n"); return 0;}
"load" { printf("KW_LOAD\n");}
"disp" { printf("KW_DISP\n");}
"true" { printf("KW_TRUE\n");}
"false" { printf("KW_FALSE\n");}

"(" {printf("OP_OP\n");}
")" {printf("OP_CP\n");}
"+" {printf("OP_PLUS\n");}
"-" {printf("OP_MINUS\n");}
"*" {printf("OP_MULT\n");}
"/" {printf("OP_DIV\n");}
"**" {printf("OP_DBLMULT\n");}
"\"" { if (count==0){ printf("OP_OC\n");count=1;}
        else{ printf("OP_CC\n");count=0;}}
"," {printf("OP_COMMA\n");}

";;".* {printf("COMMENT\n");} 
[0]|[1-9][0-9]*[.]?[0-9]*|[0][.][0-9]* {printf("VALUE\n");}
[a-zA-Z_][a-zA-Z_0-9]* {printf("IDENTIFIER\n");}

"\n"|"\t"|" " { }
[0]*[0-9]* {printf("INVALID VALUE-- Leading 0\n");return 0;}
[0-9]*[a-zA-Z_][a-zA-Z_0-9]* {printf("INVALID IDENTIFIER-- Leading Digit\n");return 0;}
. {printf("SYNTAX ERROR %s cannot be tokonized \n",yytext);return 0;}
%%

int yywrap(){ }

int main(){
    yylex();
    return 0;
}
