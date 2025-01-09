
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
    union {
        int intVal;
        float floatVal;
        char* strVal;
        bool boolVal;
    } value;
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

int sauv_fin_if[100];
int sauv_fin_else[100];
int sauv_begin_While[100];
int sauv_while_condition[100];
int top_fin_if = -1;
int top_fin_else = -1;
int top_begin_While = -1;
int top_while_condition = -1;
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
%type <intVal> expr_arithmetique terme facteur
%type <boolVal> expr_logique


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
        addSymbol(&symbolTable, $2.name, TYPE_INTEGER);
        int value = $4;
        updateSymbolValue(&symbolTable, $2.name, &value);
        quad[QC].op = ":=";
        quad[QC].opr1 = $4;
        quad[QC].opr2 = "";
        quad[QC].res = $2.name;
        QC++;
    } declaration_list
   | TOKEN_VAR_FLOAT_OPEN attributes TOKEN_END_TAG expr_arithmetique TOKEN_VAR_FLOAT_CLOSE {
        addSymbol(&symbolTable, $2.name, TYPE_FLOAT);
        float value = (float)$4;
        updateSymbolValue(&symbolTable, $2.name, &value);
        quad[QC].op = ":=";
        quad[QC].opr1 = $4;
        quad[QC].opr2 = "";
        quad[QC].res = $2.name;
        QC++;
    } declaration_list
   | TOKEN_VAR_STRING_OPEN attributes TOKEN_END_TAG TOKEN_STRING TOKEN_VAR_STRING_CLOSE {
        addSymbol(&symbolTable, $2.name, TYPE_STRING);
        updateSymbolValue(&symbolTable, $2.name, &$4);
        quad[QC].op = ":=";
        quad[QC].opr1 = $4;
        quad[QC].opr2 = "";
        quad[QC].res = $2.name;
        QC++;
    } declaration_list
   | TOKEN_VAR_BOOLEAN_OPEN attributes TOKEN_END_TAG expr_logique TOKEN_VAR_BOOLEAN_CLOSE {
        addSymbol(&symbolTable, $2.name, TYPE_BOOLEAN);
        updateSymbolValue(&symbolTable, $2.name, &$4);
        quad[QC].op = ":=";
        quad[QC].opr1 = $4;
        quad[QC].opr2 = "";
        quad[QC].res = $2.name;
        QC++;
    } declaration_list
   | TOKEN_ARRAY_OPEN attributes TOKEN_END_TAG elements TOKEN_ARRAY_CLOSE declaration_list
   | TOKEN_VAR_INT_OPEN attributes TOKEN_END_TAG expr_arithmetique TOKEN_VAR_INT_CLOSE {
        addSymbol(&symbolTable, $2.name, TYPE_INTEGER);
        int value = $4;
        updateSymbolValue(&symbolTable, $2.name, &value);
        quad[QC].op = ":=";
        quad[QC].opr1 = $4;
        quad[QC].opr2 = "";
        quad[QC].res = $2.name;
        QC++;
    }
   | TOKEN_VAR_FLOAT_OPEN attributes TOKEN_END_TAG expr_arithmetique TOKEN_VAR_FLOAT_CLOSE {
        addSymbol(&symbolTable, $2.name, TYPE_FLOAT);
        float value = (float)$4;
        updateSymbolValue(&symbolTable, $2.name, &value);
        quad[QC].op = ":=";
        quad[QC].opr1 = $4;
        quad[QC].opr2 = "";
        quad[QC].res = $2.name;
        QC++;
    }
   | TOKEN_VAR_STRING_OPEN attributes TOKEN_END_TAG TOKEN_STRING TOKEN_VAR_STRING_CLOSE {
        addSymbol(&symbolTable, $2.name, TYPE_STRING);
        updateSymbolValue(&symbolTable, $2.name, &$4);
        quad[QC].op = ":=";
        quad[QC].opr1 = $4;
        quad[QC].opr2 = "";
        quad[QC].res = $2.name;
        QC++;
    }
   | TOKEN_VAR_BOOLEAN_OPEN attributes TOKEN_END_TAG expr_logique TOKEN_VAR_BOOLEAN_CLOSE {
        addSymbol(&symbolTable, $2.name, TYPE_BOOLEAN);
        updateSymbolValue(&symbolTable, $2.name, &$4);
        quad[QC].op = ":=";
        quad[QC].opr1 = $4;
        quad[QC].opr2 = "";
        quad[QC].res = $2.name;
        QC++;
    }
   | TOKEN_ARRAY_OPEN attributes TOKEN_END_TAG elements TOKEN_ARRAY_CLOSE
   | TOKEN_VAR_INT_OPEN attributes TOKEN_SELF_CLOSING_TAG declaration_list {
        addSymbol(&symbolTable, $2.name, TYPE_INTEGER);
        quad[QC].op = ":=";
        quad[QC].opr1 = 0;
        quad[QC].opr2 = "";
        quad[QC].res = $2.name;
        QC++;
    }
   | TOKEN_VAR_FLOAT_OPEN attributes TOKEN_SELF_CLOSING_TAG declaration_list {
        addSymbol(&symbolTable, $2.name, TYPE_FLOAT);
        quad[QC].op = ":=";
        quad[QC].opr1 = 0;
        quad[QC].opr2 = "";
        quad[QC].res = $2.name;
        QC++;
    }
   | TOKEN_VAR_STRING_OPEN attributes TOKEN_SELF_CLOSING_TAG declaration_list {
        addSymbol(&symbolTable, $2.name, TYPE_STRING);
        quad[QC].op = ":=";
        quad[QC].opr1 = "";
        quad[QC].opr2 = "";
        quad[QC].res = $2.name;
        QC++;
    }
   | TOKEN_VAR_BOOLEAN_OPEN attributes TOKEN_SELF_CLOSING_TAG declaration_list {
        addSymbol(&symbolTable, $2.name, TYPE_BOOLEAN);
        quad[QC].op = ":=";
        quad[QC].opr1 = "true";
        quad[QC].opr2 = "";
        quad[QC].res = $2.name;
        QC++;
    }
   | TOKEN_ARRAY_OPEN attributes TOKEN_SELF_CLOSING_TAG declaration_list
   | TOKEN_VAR_INT_OPEN attributes TOKEN_SELF_CLOSING_TAG {
        addSymbol(&symbolTable, $2.name, TYPE_INTEGER);
        quad[QC].op = ":=";
        quad[QC].opr1 = 0;
        quad[QC].opr2 = "";
        quad[QC].res = $2.name;
        QC++;
    }
   | TOKEN_VAR_FLOAT_OPEN attributes TOKEN_SELF_CLOSING_TAG {
        addSymbol(&symbolTable, $2.name, TYPE_FLOAT);
        quad[QC].op = ":=";
        quad[QC].opr1 = 0;
        quad[QC].opr2 = "";
        quad[QC].res = $2.name;
        QC++;
    }
   | TOKEN_VAR_STRING_OPEN attributes TOKEN_SELF_CLOSING_TAG {
        addSymbol(&symbolTable, $2.name, TYPE_STRING);
        quad[QC].op = ":=";
        quad[QC].opr1 = "";
        quad[QC].opr2 = "";
        quad[QC].res = $2.name;
        QC++;
    }
   | TOKEN_VAR_BOOLEAN_OPEN attributes TOKEN_SELF_CLOSING_TAG {
        addSymbol(&symbolTable, $2.name, TYPE_BOOLEAN);
        quad[QC].op = ":=";
        quad[QC].opr1 = "true";
        quad[QC].opr2 = "";
        quad[QC].res = $2.name;
        QC++;
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
        $$.value.strVal = strdup($3);  
        $$.type = TYPE_STRING;
        }
    }
   | IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_arithmetique TOKEN_CLOSE_PARENTHESIS attributes {
        //this is to get just the value of the attribute and its name
        $$.name = strdup($1);
        $$.value.intVal = $4;  
        $$.type = TYPE_INTEGER;
    }
   | IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_logique TOKEN_CLOSE_PARENTHESIS attributes {
        $$.name = strdup($1);
        $$.value.boolVal = $4;  
        $$.type = TYPE_BOOLEAN;
    }
   | IDENTIFICATEUR TOKEN_ASSIGN TOKEN_STRING {
        if (strcmp($1,"name")==0){
        $$.name = strdup(trimQuotes($3));  // this is the variable name
        $$.type = TYPE_STRING;
        }else{// else so the attribute isn't for naming a var , we just return the name of attribute and its value (will be used in case of assign)
        $$.name = strdup($1);
        $$.value.strVal = strdup($3);  
        $$.type = TYPE_STRING;
        }
    }
   | IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_arithmetique TOKEN_CLOSE_PARENTHESIS {
        $$.name = strdup($1);
        $$.value.intVal = $4;  
        $$.type = TYPE_INTEGER;
    }
   | IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_logique TOKEN_CLOSE_PARENTHESIS {
        $$.name = strdup($1);
        $$.value.boolVal = $4;  
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
        SymbolEntry* entry = findSymbol(&symbolTable, $2.name);
        if (!entry) {
            yyerror("Variable undefined");
        }
        if (entry->type == TYPE_INTEGER) {
            quad[QC].opr1 = $2.value.intVal;
        } else if (entry->type == TYPE_FLOAT) {
            quad[QC].opr1 = $2.value.floatVal;
        } else if (entry->type == TYPE_STRING) {
            quad[QC].opr1 = $2.value.strVal;
        } else if (entry->type == TYPE_BOOLEAN) {
            quad[QC].opr1 = $2.value.boolVal ? "true" : "false";
        }
        quad[QC].op = ":=";
        quad[QC].opr2 = "";
        quad[QC].res = $2.name;
        QC++;
}
;

if_statement:
   TOKEN_IF_OPEN attributes TOKEN_END_TAG 
   instruction_list 
   TOKEN_IF_CLOSE 
   | TOKEN_IF_OPEN attributes TOKEN_END_TAG  
   instruction_list 
   TOKEN_ELSE 
   instruction_list 
   TOKEN_IF_CLOSE
   ;

while_statement:
   TOKEN_WHILE_OPEN attributes TOKEN_END_TAG 
   instruction_list 
   TOKEN_WHILE_CLOSE
   ;

print_statement:
   TOKEN_PRINT_OPEN attributes TOKEN_SELF_CLOSING_TAG
   ;

expr_arithmetique:
   terme
   | expr_arithmetique TOKEN_PLUS terme { $$ = $1 + $3; }
   | expr_arithmetique TOKEN_MINUS terme { $$ = $1 - $3; }
   ;

terme:
   facteur
   | terme TOKEN_MULTIPLY facteur { $$ = $1 * $3; } 
   | terme TOKEN_DIVIDE facteur { $$ = $1 / $3; }  
   ;

facteur:
   TOKEN_INT { $$ = $1; }
   | TOKEN_FLOAT { $$ = (int)$1; }
   | IDENTIFICATEUR {
        $$=1;
    }
   | TOKEN_OPEN_PARENTHESIS expr_arithmetique TOKEN_CLOSE_PARENTHESIS { $$ = $2; }
   ; 

expr_logique:
   expr_arithmetique TOKEN_EQUAL expr_arithmetique {
    $$ = ($1 == $3); 
  }
   | expr_arithmetique TOKEN_GREATER_THAN expr_arithmetique {
    $$ = ($1 > $3);
  }
   | expr_arithmetique TOKEN_LOWER_THAN expr_arithmetique {
    $$ = ($1 < $3); 
  }
   | expr_arithmetique TOKEN_GREATER_OR_EQUAL expr_arithmetique  {
    $$ = ($1 >= $3); 
  }
   | expr_arithmetique TOKEN_LOWER_OR_EQUAL expr_arithmetique {
    $$ = ($1 <= $3); 
  }
   | TOKEN_OPEN_PARENTHESIS expr_logique TOKEN_CLOSE_PARENTHESIS {
    $$ = $2 ; 
  }
   | TOKEN_BOOLEAN 
   ;

%%

void yysuccess(char *s){
    currentColumn+=yyleng;
}

void yyerror(const char *s) {
    fprintf(stdout, "File output, line %d, character %d :  %s \n", yylineno, currentColumn, s);
}

int main(void) {
    initSymbolTable(&symbolTable);
    if (yyparse() == 0) {
        printf("Parsing successful\n");
    } else {
        fprintf(stderr, "Parsing failed\n");
        return 1;
    }

    printSymbolTable(&symbolTable);
    freeSymbolTable(&symbolTable);
    return 0;
}


