
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "tableSymbole.h"
extern int yylineno;
extern int yyleng;
extern int current_column;
int yylex();
void yyerror(const char *s);
void yysuccess(char *s);
int currentColumn = 1; 

SymbolTable symbolTable;

char* trimQuotes(char* str) {
    size_t len = strlen(str);
    if (len >= 2 && str[0] == '"' && str[len - 1] == '"') {
        str[len - 1] = '\0';
        return str + 1;
    }
    return str;
}

typedef struct {
    char* name;
    char* value;
    DataType type;
} AttributeValue;

int QC=0;
int ti=0;

typedef struct quadruplet{
char op[15];
char opr1[15];
char opr2[15];
char res[15];
}Quad;

Quad quad[1000];

void createQuad(char* op, char* opr1, char* opr2, char* res) {
    strcpy(quad[QC].op, op);
    strcpy(quad[QC].opr1, opr1);
    strcpy(quad[QC].opr2, opr2);
    strcpy(quad[QC].res, res);
    QC++;
}


    void printQuad() {
        printf("\n=== Quadruplets ===\n");
        for(int i = 0; i < QC; i++) {
            printf("%d- (%s, %s, %s, %s)\n", i, quad[i].op, quad[i].opr1, quad[i].opr2, quad[i].res);
        }
        printf("==================\n");
    }


int sauv_begin_if[100];
int sauv_fin_if[100];
int sauv_fin_else[100];
int sauv_begin_While[100];
int sauv_fin_while[100];
int top_begin_if = -1;
int top_fin_if = -1;
int top_fin_else = -1;
int top_begin_While = -1;
int top_fin_while = -1;
void push(int stack[], int *top, int value) {
    stack[++(*top)] = value;
}

int pop(int stack[], int *top) {
    if (*top == -1) {
        fprintf(stderr, "Stack underflow\n");
        exit(EXIT_FAILURE);
    }
    return stack[(*top)--];
}

%}
%union {
    int intVal;
    float floatVal;
    char* strVal;
    bool boolVal;
    AttributeValue attr;
}






/* Token declarations */
%token TOKEN_UNRECOGNIZED
%token TOKEN_PROGRAM_OPEN TOKEN_PROGRAM_CLOSE
%token TOKEN_VARIABLES_OPEN TOKEN_VARIABLES_CLOSE 
%token TOKEN_INSTRUCTIONS_OPEN TOKEN_INSTRUCTIONS_CLOSE
%token TOKEN_ASSIGN_OPEN TOKEN_ASSIGN_CLOSE
%token TOKEN_PRINT_OPEN TOKEN_PRINT_CLOSE
%token TOKEN_IF_OPEN TOKEN_IF_CLOSE TOKEN_ELSE
%token TOKEN_WHILE_OPEN TOKEN_WHILE_CLOSE
%token TOKEN_ARRAY_OPEN TOKEN_ARRAY_CLOSE
%token TOKEN_ELEMENT_OPEN TOKEN_END_TAG TOKEN_SELF_CLOSING_TAG
%token TOKEN_VAR_INT_OPEN TOKEN_VAR_INT_CLOSE
%token TOKEN_VAR_FLOAT_OPEN TOKEN_VAR_FLOAT_CLOSE
%token TOKEN_VAR_BOOLEAN_OPEN TOKEN_VAR_BOOLEAN_CLOSE
%token TOKEN_VAR_STRING_OPEN TOKEN_VAR_STRING_CLOSE
%token TOKEN_EXPRESSION
%token <strVal> TOKEN_STRING
%token TOKEN_PLUS TOKEN_MINUS TOKEN_MULTIPLY TOKEN_DIVIDE
%token TOKEN_GREATER_THAN TOKEN_LOWER_THAN
%token TOKEN_GREATER_OR_EQUAL TOKEN_LOWER_OR_EQUAL TOKEN_EQUAL
%token TOKEN_OPEN_PARENTHESIS TOKEN_CLOSE_PARENTHESIS
%token TOKEN_ASSIGN TOKEN_QUOTE
%token <strVal> IDENTIFICATEUR
%token <intVal> TOKEN_INT
%token <floatVal> TOKEN_FLOAT
%token <boolVal> TOKEN_BOOLEAN

/* Type declarations for non-terminals */
%type <attr> attributes
%type <strVal> expr_arithmetique terme facteur
%type <strVal> expr_logique


%%

program: 
   TOKEN_PROGRAM_OPEN 
   variables_list
   TOKEN_INSTRUCTIONS_OPEN instruction_list TOKEN_INSTRUCTIONS_CLOSE 
   TOKEN_PROGRAM_CLOSE
   ;

variables_list:
   TOKEN_VARIABLES_OPEN declaration_list TOKEN_VARIABLES_CLOSE
   | /* empty */


declaration_list:
   TOKEN_VAR_INT_OPEN attributes TOKEN_END_TAG expr_arithmetique TOKEN_VAR_INT_CLOSE {
        //addSymbol(&symbolTable, $2.name, TYPE_INTEGER);
        // int value = $4;
        //updateSymbolValue(&symbolTable, $2.name, &value);
        printf("Declaration:" );
        printf("Name: %s\n", $4);
        char temp[15];
        sprintf(temp, "%s", $4);
        createQuad(":=", temp, "", $2.name);
    } declaration_list
   | TOKEN_VAR_FLOAT_OPEN attributes TOKEN_END_TAG expr_arithmetique TOKEN_VAR_FLOAT_CLOSE {
        //addSymbol(&symbolTable, $2.name, TYPE_FLOAT);
        // float value = (float)$4;
        //updateSymbolValue(&symbolTable, $2.name, &value);
        char temp[15];
        sprintf(temp, "%s", $4);
        createQuad(":=", temp, "", $2.name);
    } declaration_list
   | TOKEN_VAR_STRING_OPEN attributes TOKEN_END_TAG TOKEN_STRING TOKEN_VAR_STRING_CLOSE {
        //addSymbol(&symbolTable, $2.name, TYPE_STRING);
        //updateSymbolValue(&symbolTable, $2.name, &$4);
        char temp[15];
        sprintf(temp, "%s", $4);
        createQuad(":=", temp, "", $2.name);
    } declaration_list
   | TOKEN_VAR_BOOLEAN_OPEN attributes TOKEN_END_TAG expr_logique TOKEN_VAR_BOOLEAN_CLOSE {
        //addSymbol(&symbolTable, $2.name, TYPE_BOOLEAN);
        //updateSymbolValue(&symbolTable, $2.name, &$4);
        char temp[15];
        sprintf(temp, "%s", $4);
        createQuad(":=", temp, "", $2.name);
    } declaration_list
   | TOKEN_ARRAY_OPEN attributes TOKEN_END_TAG elements TOKEN_ARRAY_CLOSE declaration_list
   | TOKEN_VAR_INT_OPEN attributes TOKEN_END_TAG expr_arithmetique TOKEN_VAR_INT_CLOSE {
        //addSymbol(&symbolTable, $2.name, TYPE_INTEGER);
        // int value = $4;
        //updateSymbolValue(&symbolTable, $2.name, &value);
        printf("Declaration:" );
        printf("Name: %s\n", $4);
        char temp[15];
        sprintf(temp, "%s", $4);
        createQuad(":=", temp, "", $2.name);
    }
   | TOKEN_VAR_FLOAT_OPEN attributes TOKEN_END_TAG expr_arithmetique TOKEN_VAR_FLOAT_CLOSE {
        //addSymbol(&symbolTable, $2.name, TYPE_FLOAT);
        // float value = (float)$4;
        //updateSymbolValue(&symbolTable, $2.name, &value);
        char temp[15];
        sprintf(temp, "%s", $4);
        createQuad(":=", temp, "", $2.name);
    }
   | TOKEN_VAR_STRING_OPEN attributes TOKEN_END_TAG TOKEN_STRING TOKEN_VAR_STRING_CLOSE {
        //addSymbol(&symbolTable, $2.name, TYPE_STRING);
        //updateSymbolValue(&symbolTable, $2.name, &$4);
        char temp[15];
        sprintf(temp, "%s", $4);
        createQuad(":=", temp, "", $2.name);
    }
   | TOKEN_VAR_BOOLEAN_OPEN attributes TOKEN_END_TAG expr_logique TOKEN_VAR_BOOLEAN_CLOSE {
        //addSymbol(&symbolTable, $2.name, TYPE_BOOLEAN);
        //updateSymbolValue(&symbolTable, $2.name, &$4);
        char temp[15];
        sprintf(temp, "%s", $4);
        createQuad(":=", temp, "", $2.name);
    }
   | TOKEN_ARRAY_OPEN attributes TOKEN_END_TAG elements TOKEN_ARRAY_CLOSE
   | TOKEN_VAR_INT_OPEN attributes TOKEN_SELF_CLOSING_TAG declaration_list {
        createQuad(":=", "0", "", $2.name);
    }
   | TOKEN_VAR_FLOAT_OPEN attributes TOKEN_SELF_CLOSING_TAG declaration_list {
        //addSymbol(&symbolTable, $2.name, TYPE_FLOAT);
        createQuad(":=", "0.0", "", $2.name);
    }
   | TOKEN_VAR_STRING_OPEN attributes TOKEN_SELF_CLOSING_TAG declaration_list {
        //addSymbol(&symbolTable, $2.name, TYPE_STRING);
        createQuad(":=", "", "", $2.name);
    }
   | TOKEN_VAR_BOOLEAN_OPEN attributes TOKEN_SELF_CLOSING_TAG declaration_list {
        //addSymbol(&symbolTable, $2.name, TYPE_BOOLEAN);
        
        createQuad(":=", "0", "", $2.name);
    }
   | TOKEN_ARRAY_OPEN attributes TOKEN_SELF_CLOSING_TAG declaration_list
   | TOKEN_VAR_INT_OPEN attributes TOKEN_SELF_CLOSING_TAG {
        //addSymbol(&symbolTable, $2.name, TYPE_INTEGER);
        createQuad(":=", "0", "", $2.name);
    }
   | TOKEN_VAR_FLOAT_OPEN attributes TOKEN_SELF_CLOSING_TAG {
        //addSymbol(&symbolTable, $2.name, TYPE_FLOAT);
        
        createQuad(":=", "0.0", "", $2.name);
    }
   | TOKEN_VAR_STRING_OPEN attributes TOKEN_SELF_CLOSING_TAG {
        //addSymbol(&symbolTable, $2.name, TYPE_STRING);
        createQuad(":=", "", "", $2.name);
    }
   | TOKEN_VAR_BOOLEAN_OPEN attributes TOKEN_SELF_CLOSING_TAG {
        //addSymbol(&symbolTable, $2.name, TYPE_BOOLEAN);
        createQuad(":=", "0", "", $2.name);
    }
    | TOKEN_ARRAY_OPEN attributes TOKEN_SELF_CLOSING_TAG
    ;


attributes:
   IDENTIFICATEUR TOKEN_ASSIGN TOKEN_STRING attributes {
        if (strcmp($1,"name")==0){
        $$.name = strdup(trimQuotes($3));  // this is the variable name
        $$.type = TYPE_STRING;
        }else{// else so the attribute isn't for naming a var , we just return the name of attribute and its value (will be used in case of assign)
        $$.name = strdup($1);
        $$.value = strdup($3);  
        $$.type = TYPE_STRING;
        }
    }
   | IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_arithmetique TOKEN_CLOSE_PARENTHESIS attributes {
        //this is to get just the value of the attribute and its name
        $$.name = strdup($1);
        $$.value = $4;  
        $$.type = TYPE_INTEGER;
    }
   | IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_logique TOKEN_CLOSE_PARENTHESIS attributes {
        $$.name = strdup($1);
        $$.value = $4;  
        $$.type = TYPE_BOOLEAN;
    }
   | IDENTIFICATEUR TOKEN_ASSIGN TOKEN_STRING {
        if (strcmp($1,"name")==0){
        $$.name = strdup(trimQuotes($3));  // this is the variable name
        $$.type = TYPE_STRING;
        }else{// else so the attribute isn't for naming a var , we just return the name of attribute and its value (will be used in case of assign)
        $$.name = strdup($1);
        $$.value = strdup($3);  
        $$.type = TYPE_STRING;
        }
    }
   | IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_arithmetique TOKEN_CLOSE_PARENTHESIS {
        $$.name = strdup($1);
        $$.value = $4;  
        $$.type = TYPE_INTEGER;
    }
   | IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_logique TOKEN_CLOSE_PARENTHESIS {
        $$.name = strdup($1);
        $$.value = $4;  
        $$.type = TYPE_BOOLEAN;
    }
   ;

elements:
   element elements  | /* void */
   ;

element:
   TOKEN_ELEMENT_OPEN attributes TOKEN_SELF_CLOSING_TAG
   ;

instruction_list:
   instruction_list instruction
   | /* empty */
   ;

instruction:
   assignment
   | if_statement
   | while_statement
   | print_statement
   ;

assignment:
    TOKEN_ASSIGN_OPEN attributes TOKEN_SELF_CLOSING_TAG {
        //update the value of a variable
        // SymbolEntry* entry = findSymbol(&symbolTable, $2.name);
        // if (!entry) {
        //     yyerror("Variable undefined");
        // }
        char temp[15];
        sprintf(temp, "%s", $2.value);
        // if (entry->type == TYPE_INTEGER) {
        //     sprintf(temp, "%d", $2.value);
        // } else if (entry->type == TYPE_FLOAT) {
        //     sprintf(temp, "%f", $2.value);
        // } else if (entry->type == TYPE_STRING) {
        //     sprintf(temp, "%s", $2.value);
        // } else if (entry->type == TYPE_BOOLEAN) {
        //     sprintf(temp, "%d", $2.value);
        // }
        createQuad(":=", temp, "", $2.name);
}
;



if_statement:
   if_condition TOKEN_END_TAG instruction_list {
    char temp[15];
    sprintf(temp, "%d", QC);
    strcpy(quad[sauv_begin_if[top_begin_if--]].opr1, temp);
   } TOKEN_IF_CLOSE 
   | if_condition TOKEN_END_TAG  
   instruction_list {

    sauv_fin_if[++top_fin_if] = QC;
    createQuad("BR", "", "", "");

    char temp[15];
    sprintf(temp, "%d", QC);
    strcpy(quad[sauv_begin_if[top_begin_if--]].opr1, temp);
   }
   TOKEN_ELSE 
   instruction_list 
   TOKEN_IF_CLOSE {
    char temp[15];
    sprintf(temp, "%d", QC);
    strcpy(quad[sauv_fin_if[top_fin_if--]].opr1, temp);
   }
   ;
if_condition:
TOKEN_IF_OPEN attributes {

    if (strcmp($2.name, "condition") == 0) {
        sauv_begin_if[++top_begin_if] = QC;
        char temp[15];
        sprintf(temp, "%s", $2.value);
        createQuad("BZ", "", "", temp);
    } else {
        yyerror("Invalid attribute for if statement");
    }
   } ;

while_statement:
   while_condition TOKEN_END_TAG 
   instruction_list 
   TOKEN_WHILE_CLOSE {
    int begin_while = sauv_begin_While[top_begin_While--];
    char temp[15];
    sprintf(temp, "%d", begin_while);
    createQuad("BR", temp, "", "");

    
    sprintf(quad[begin_while].opr1, "%d", QC);

    

   }
   ;
while_condition:
    TOKEN_WHILE_OPEN attributes {

    if (strcmp($2.name, "condition") == 0) {
        sauv_begin_While[++top_begin_While] = QC;
        char temp[15];
        sprintf(temp, "%s", $2.value);
        createQuad("BZ", "", "", temp);

    } else {
        yyerror("Invalid attribute for if statement");
    }
    };

print_statement:
   TOKEN_PRINT_OPEN attributes TOKEN_SELF_CLOSING_TAG
   ;

expr_arithmetique:
   terme {
    char temp[15];
    sprintf(temp, "%s", $1);
    $$ = strdup(temp);

   }
   | expr_arithmetique TOKEN_PLUS terme {
    char temp[15];
    char opr1[15];
    char opr2[15];
    sprintf(temp, "T%d", ti++);
    sprintf(opr1, "%s", $1);
    sprintf(opr2, "%s", $3);
     createQuad("+", opr1, opr2, temp);
    $$ = strdup(temp);
   }
   | expr_arithmetique TOKEN_MINUS terme { 
    char temp[15];
    sprintf(temp, "T%d", ti++);
     createQuad("-", $1, $3, temp);
    //  sprintf($$, "%s", temp);
    $$ = strdup(temp);

   }
   ;

terme:
   facteur {
    
    // strcpy($$, $1);

    char temp[15];
    sprintf(temp, "%s", $1);

    $$ = strdup(temp);
   }
   | terme TOKEN_MULTIPLY facteur { 
    char temp[15];
    sprintf(temp, "T%d", ti++);
     createQuad("*", $1, $3, temp);
    //  sprintf($$, "%s", temp);
    $$ = strdup(temp);
    } 
   | terme TOKEN_DIVIDE facteur {
    char temp[15];
    sprintf(temp, "T%d", ti++);
     createQuad("/", $1, $3, temp);
    //  sprintf($$, "%s", temp);
    $$ = strdup(temp);
     }  
   ;

facteur:
   TOKEN_INT { 

    // printf("heloo");
    char temp[15];
    sprintf(temp, "%d", $1);

    $$ = strdup(temp);

    }
   | TOKEN_FLOAT { 

    char temp[15];
    sprintf(temp, "%f", $1);

    $$ = strdup(temp);
    }
   | IDENTIFICATEUR {
    char temp[15];
    sprintf(temp, "%s", $1);
    printf("Debug - Facteur IDENTIFICATEUR: %s\n", $1);
    $$ = strdup(temp);
    }
   | TOKEN_OPEN_PARENTHESIS expr_arithmetique TOKEN_CLOSE_PARENTHESIS {
    // $$ = $2
        char temp[15];
        sprintf(temp, "%s", $2);

        $$ = strdup(temp);
     }
   ; 

expr_logique:
   expr_arithmetique TOKEN_EQUAL expr_arithmetique {

    

    char tmp3[15];
    sprintf(tmp3, "T%d", ti++);
    
    createQuad("==", $1, $3, tmp3);
// strcpy($$, tmp3);
    $$ = strdup(tmp3);
  }
   | expr_arithmetique TOKEN_GREATER_THAN expr_arithmetique {

    
    char tmp3[15];
    sprintf(tmp3, "T%d", ti++);
    createQuad(">", $1, $3, tmp3);
    $$ = strdup(tmp3);
  }
   | expr_arithmetique TOKEN_LOWER_THAN expr_arithmetique {

    char tmp3[15];
    sprintf(tmp3, "T%d", ti++);
    
    createQuad("<", $1, $3, tmp3);
    // strcpy($$, tmp3);
    $$ = strdup(tmp3);
  }
   | expr_arithmetique TOKEN_GREATER_OR_EQUAL expr_arithmetique  {

    char tmp3[15];
    sprintf(tmp3, "T%d", ti++);
    
    createQuad(">=", $1, $3, tmp3);
// strcpy($$, tmp3);
    $$ = strdup(tmp3);
  }
   | expr_arithmetique TOKEN_LOWER_OR_EQUAL expr_arithmetique {

    char tmp3[15];
    sprintf(tmp3, "T%d", ti++);
    
    createQuad("<=", $1, $3, tmp3);
// strcpy($$, tmp3);
    $$ = strdup(tmp3);
  }
   | TOKEN_OPEN_PARENTHESIS expr_logique TOKEN_CLOSE_PARENTHESIS {
    $$ = strdup($2);
  }
   | TOKEN_BOOLEAN {
    // sprintf($$, "%d", $1);
    char temp[15];
    sprintf(temp, "%d", $1);
    $$ = strdup(temp);
    
   }
   ;

%%

void yysuccess(char *s){
    currentColumn+=yyleng;
}

void yyerror(const char *s) {
    fprintf(stdout, "File output, line %d, character %d :  %s \n", yylineno, currentColumn, s);
}

int main(void) {
    // initSymbolTable(&symbolTable);
    if (yyparse() == 0) {
        printQuad();
        printf("Parsing successful\n");
    } else {
        fprintf(stderr, "Parsing failed\n");
        return 1;
    }

    // printSymbolTable(&symbolTable);
    // freeSymbolTable(&symbolTable);
    return 0;
}


