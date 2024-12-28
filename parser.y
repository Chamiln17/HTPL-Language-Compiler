%{
#include <stdio.h>
#include <stdlib.h>
#include "table_symbole.h"

Node *table_symbole;

extern int yylineno;
extern int yyleng;
extern int current_column;

int yylex();
void yyerror(const char *s);
%}

%token CONST FUNCTION PROCEDURE MAIN RETURN IF ELSE FOR WHILE DO PRINT READ TRUE FALSE
%token INT FLOAT DOUBLE CHAR BOOL
%token IDENTIFIER INTEGER REAL
%token EQ NE LT GT LE GE
%token PLUS MINUS MULTIPLY DIVIDE ASSIGN AND OR NOT MOD
%token PARENOUV PARENFERM ACCOLADEOUV ACCOLADEFERM CROCHETOUV CROCHETFERM POINTVIRGULE VIRGULE


%%

program:
    declaration_list function_list main_function
    ;

declaration_list:
    declaration_list declaration
    | /* void */
    ;

declaration:
    CONST type IDENTIFIER POINTVIRGULE
    | type IDENTIFIER POINTVIRGULE
    ;

type:
    typeSimple
    | typeCompose

typeSimple:
    INT
    | FLOAT
    | DOUBLE
    | CHAR
    | BOOL
    ;

typeCompose:
    type CROCHETOUV INTEGER CROCHETFERM

function_list:
    function_list function_definition
    | /* void */
    ;

function_definition:
    FUNCTION IDENTIFIER PARENOUV parameter_list PARENFERM type body
    | PROCEDURE IDENTIFIER PARENOUV parameter_list PARENFERM body
    ;

parameter_list:
    parameter_list parameter
    | /* void */
    ;

parameter:
    type IDENTIFIER VIRGULE
    | type IDENTIFIER
    ;

main_function:
    FUNCTION MAIN PARENOUV PARENFERM body 
    ;

body:
    ACCOLADEOUV instruction_list ACCOLADEFERM
    ;

instruction_list:
    instruction_list instruction
    | /* void */
    ;

instruction:
    declaration
    | assignment
    | conditional_statement
    | loop
    | io
    | RETURN expression POINTVIRGULE
    | RETURN POINTVIRGULE /*pour une procedure car elle ne retourne rien*/
    ;

assignment:
    IDENTIFIER ASSIGN expression POINTVIRGULE
    ;

conditional_statement:
    IF PARENOUV expression PARENFERM body
    | IF PARENOUV expression PARENFERM body ELSE body
    ;

loop:
    FOR PARENOUV assignment expression POINTVIRGULE assignment PARENFERM body
    | WHILE PARENOUV expression PARENFERM body
    | DO body WHILE PARENOUV expression PARENFERM POINTVIRGULE
    ;

io:
    PRINT PARENOUV expression PARENFERM POINTVIRGULE
    | READ PARENOUV IDENTIFIER PARENFERM POINTVIRGULE
    ;

expression:
    logical_or_expression
    ;

logical_or_expression:
    logical_or_expression OR logical_and_expression
    | logical_and_expression
    ;

logical_and_expression:
    logical_and_expression AND relational_expression
    | relational_expression
    ;

relational_expression:
    relational_expression EQ additive_expression
    | relational_expression NE additive_expression
    | relational_expression LT additive_expression
    | relational_expression GT additive_expression
    | relational_expression LE additive_expression
    | relational_expression GE additive_expression
    | additive_expression
    ;

additive_expression:
    additive_expression PLUS multiplicative_expression
    | additive_expression MINUS multiplicative_expression
    | multiplicative_expression
    ;

multiplicative_expression:
    multiplicative_expression MULTIPLY unary_expression
    | multiplicative_expression DIVIDE unary_expression
    | multiplicative_expression MOD unary_expression
    | unary_expression
    ;

unary_expression:
    NOT unary_expression
    | primary_expression
    ;

primary_expression:
    PARENOUV expression PARENFERM
    | IDENTIFIER
    | INTEGER
    | REAL
    | TRUE
    | FALSE
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "File \"Test\", line %d, character %d: syntaxic error\n", 
        yylineno, current_column-yyleng);
}

int main(void) {
  yyparse();
}