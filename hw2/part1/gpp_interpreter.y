%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "gpp_interpreter.h"
    extern FILE *yyin;
    void yyerror(char *);
    int yylex(void);
    int result=1;
    int* concat(int* arrA,int* arrB);
    int* append(int num,int* arr);
    void printArray(int* arr);
    int findAndSetID(char*,int);
    int findID(char*);
    void init();
    typedef union value{
            int num; 
            int* list;
    }value;
    typedef struct Variable{
        char id[10]; // Variable Name
        char type; // Int = I || Char = C || List = L
        value val; 
        
    }Variable;
    typedef struct VariableArray{
        int size;
        Variable* vars;
    }VariableArray;
%}
%union {
    int val;
    int* list;
    char id[10];
}
%start Input

%token KW_AND KW_OR KW_NOT KW_EQUAL KW_LESS KW_NIL KW_LIST KW_APPEND KW_CONCAT KW_SET KW_DEFFUN 
%token KW_FOR KW_IF KW_EXIT KW_LOAD KW_DISP KW_TRUE KW_FALSE
%token OP_PLUS  OP_MINUS OP_DIV OP_MULT OP_OP OP_CP OP_DBLMULT OP_OC OP_CC OP_COMMA
%token COMMENT
%token <val> VALUE
%token <id>IDENTIFIER

%type <val> Input
%type <val> ExpI
%type <val> ExpB
%type <list> ListValue
%type <list> Values
%type <list> ExpList

%%

Input: 
    COMMENT {;}
    |
    OP_OP KW_EXIT OP_CP {exit(0);}
    |
    ExpI { printf("Syntax OK.\nResult: %d\n", $1);}
    |
    ExpList { printf("Syntax OK.\nResult: "); printArray($1);}
    | 
    Input COMMENT {;}
    |
    Input ExpI { printf("Syntax OK.\nResult: %d\n", $2);}
    |
    Input ExpList { printf("Syntax OK.\nResult: ");printArray($2);}
    ;

ExpI:
    OP_OP OP_PLUS ExpI ExpI OP_CP {$$= $3 + $4;}
    |
    OP_OP OP_MINUS ExpI ExpI OP_CP {$$= $3 - $4;}
    |
    OP_OP OP_MULT ExpI ExpI OP_CP {$$= $3 * $4;}
    |
    OP_OP OP_DIV ExpI ExpI OP_CP {$$= $3 / $4;}
    |
    OP_OP OP_DBLMULT ExpI ExpI OP_CP {
                                        for (int i = 0; i < $4; ++i){
                                            result  = result *  $3; 
                                        }
                                        $$ = result;
                                    }   
    |
    OP_OP OP_MINUS VALUE OP_CP { $$ = -$3; }
    |
    IDENTIFIER {$$= findID($1);}
    |
    VALUE {$$ =$1;}
    |
    OP_OP KW_SET IDENTIFIER ExpI OP_CP {$$ = findAndSetID($3,$4);}
    |
    OP_OP KW_IF ExpB ExpI OP_CP {(1==$3)? ($$=$4):($$=0) ;}
    |
    OP_OP KW_IF ExpB ExpI ExpI OP_CP {$$=( ($3==1)? $4 :$5) ;}
    |
    OP_OP KW_FOR OP_OP IDENTIFIER ExpI ExpI OP_CP ExpList OP_CP {
                                                                    int i= findID($4);
                                                                    for(i;i<$5;findAndSetID($4,i+$6)){
                                                                        
                                                                    };
                                                                }
    |
    OP_OP KW_DISP ExpI OP_CP {$$=$3;}
    |
    OP_OP KW_DISP ExpB OP_CP {$$=$3;}
  /*  |
    OP_OP IDENTIFIER ExpList OP_CP { find($2,$3)}//func call
    |
    OP_OP KW_DEFFUN IDENTIFIER IDLIST ExpList OP_CP {$$=0;}//deffun func*/
    ;
/*IDLIST:
    IDENTIFIER
    |
    IDLIST IDENTIFIER
    ;*/

ExpB:
    OP_OP KW_AND ExpB ExpB OP_CP {$$= $3 && $4;}
    |
    OP_OP KW_OR ExpB ExpB OP_CP {$$= $3 || $4;}
    |
    OP_OP KW_NOT ExpB OP_CP {$$= !$3;}
    |
    OP_OP KW_EQUAL ExpB ExpB OP_CP {$$= ($3==$4);}
    |
    OP_OP KW_EQUAL ExpI ExpI OP_CP {$$= ($3==$4);}
    |
    OP_OP KW_LESS ExpI ExpI OP_CP {$$= ($3<$4);}
    |
    KW_TRUE {$$=1;}
    |
    KW_FALSE {$$=0;}
    ;

ExpList :
    OP_OP KW_CONCAT ExpList ExpList OP_CP { $$=concat($3,$4);}
    |
    OP_OP KW_APPEND ExpI ExpList OP_CP {$$=append($3,$4) ;}
    |
    OP_OP KW_DISP ExpList OP_CP {$$=$3;}
    |
    OP_OP KW_LIST Values OP_CP {$$=$3;}
    |
    OP_OP KW_IF ExpB ExpList OP_CP {(1==$3)? ($$=$4):($$=0) ;}
    |
    OP_OP KW_IF ExpB ExpList ExpList OP_CP {$$=( ($3==1)? $4 :$5) ;}
    |
    ListValue
    ;

ListValue:
    OP_OP Values OP_CP {$$=$2;}
    | 
    OP_OP OP_CP {$$=NULL;}
    | 
    KW_NIL {$$=NULL;}
    ;
Values:
    Values VALUE {$$=append($2,$1);}
    |
    VALUE {$$=append($1,NULL);}
    ;
%%
                // C Code //
VariableArray variables;

void init(){
    variables.size=0;
    variables.vars=NULL;
}
int findAndSetID(char* id,int num){
    if(variables.size==0 || variables.vars==NULL){
        variables.vars=(Variable*) malloc(1);
        strcpy(variables.vars[0].id,id);
        variables.vars[0].type='I';
        variables.vars[0].val.num=num;
        variables.size=1;
        return num;
    }
    for(int i=0;i< variables.size;i++){
        if(strcmp(variables.vars[i].id,id)==0){
            variables.vars[i].type='I';
            variables.vars[i].val.num=num;
            return num;
        }
    }
    /*if not exist ,create*/
    variables.vars=(Variable*)realloc(variables.vars,sizeof(Variable)*(variables.size+1));
    strcpy(variables.vars[variables.size].id,id);
    variables.vars[variables.size].type='I';
    variables.vars[variables.size].val.num=num;
    variables.size++;
    
    return num;
}
int findID(char* id){
    for(int i=0;i< variables.size;i++){
        if(strcmp(variables.vars[i].id,id)==0)
            return  variables.vars[i].val.num;
    }
    printf("Does not exist %s\n",id);
    exit(-1);
}
int main(int argc, char **argv)
{
    init();
    FILE* fileInput;
    if (argc > 1 && argv[1]){
        if((fileInput=fopen(argv[1],"r"))!=NULL){
            yyin=fileInput;
            while(!feof(yyin))
                yyparse();
        }
    }else
        while(1)
            yyparse();

    return 0;
}
/*Concatenates 2 Lists*/
int* concat(int* arrA,int* arrB){
    int size=arrA[0]+arrB[0];
    arrA = (int *) realloc(arrA, size+1);
    int last=arrA[0];
    arrA[0]=size;
    for(int i=last+1; i<=size;i++)
        arrA[i]=arrB[i-last];
    return arrA;
}
/*Appends Element to a List*/
int* append(int num,int* arr){
    if(arr==NULL){
        arr= (int*)malloc(2);
        arr[0]=1;
        arr[1]=num;
        return arr;
    }
    int size=arr[0];
    arr = (int *) realloc(arr, sizeof(int)*(size+2));
    arr[0]++;
    arr[size+1]=num;
    return arr;
}
/*Prints List*/
void printArray(int* arr){
    printf("(");
    if(arr!=NULL){
        int size=arr[0];
        for(int i=1; i<=size;i++)
            printf("%d ",arr[i]);
    }
    printf(")\n");
}
/* Yacc Error Handler */
void yyerror(char * s){  
    printf ("%s\n", s);
    exit(0);
}