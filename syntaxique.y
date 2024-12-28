%{
#include <stdio.h>
#include <stdlib.h>


extern int yylineno;
extern int yyleng;
extern int current_column;

int yylex();
void yyerror(const char *s);
%}
%token TOKEN_PROGRAM_OPEN, TOKEN_PROGRAM_CLOSE, 
    TOKEN_VARIABLES_OPEN, TOKEN_VARIABLES_CLOSE, 
    TOKEN_INSTRUCTIONS_OPEN, TOKEN_INSTRUCTIONS_CLOSE, 
    TOKEN_ASSIGN_OPEN, TOKEN_ASSIGN_CLOSE, 
    TOKEN_PRINT_OPEN, TOKEN_PRINT_CLOSE, 
    TOKEN_IF_OPEN, TOKEN_IF_CLOSE, 
    TOKEN_ELSE, 
    TOKEN_VAR_OPEN, TOKEN_VAR_CLOSE, 
    TOKEN_ATTRIBUTE_VALUE, TOKEN_EXPRESSION, 
    TOKEN_STRING, ATTRIBUTE_VAR_NAME, 
    TOKEN_SELF_CLOSING_TAG, TOKEN_END_TAG, 
    TOKEN_WHILE_CLOSE, TOKEN_WHILE_OPEN, 
    TOKEN_ARRAY_CLOSE, TOKEN_ARRAY_OPEN, 
    TOKEN_ELEMENT_OPEN, TOKEN_UNRECOGNIZED, 
    INT_OPEN, INT_CLOSE, 
    FLOAT_OPEN, FLOAT_CLOSE, 
    STRING_OPEN, STRING_CLOSE, 
    BOOLEAN_OPEN, BOOLEAN_CLOSE

%%

program:
    TOKEN_PROGRAM_OPEN  TOKEN_VARIABLES_OPEN declaration_list TOKEN_VARIABLES_CLOSE TOKEN_INSTRUCTIONS_OPEN  body TOKEN_INSTRUCTIONS_CLOSE TOKEN_PROGRAM_CLOSE
    ;

declaration_list:
    declaration_list declaration | /* void */
    ;

declaration:
      INT_OPEN ATTRIBUTE_VAR_NAME EVAL QUOTE ID QUOTE TOKEN_END_TAG arith_expression INT_CLOSE
    | FLOAT_OPEN ATTRIBUTE_VAR_NAME EVAL QUOTE ID QUOTE TOKEN_END_TAG arith_expression FLOAT_CLOSE
    | STRING_OPEN ATTRIBUTE_VAR_NAME EVAL QUOTE ID QUOTE TOKEN_END_TAG STRING STRING_CLOSE
    | BOOLEAN_OPEN ATTRIBUTE_VAR_NAME EVAL QUOTE ID QUOTE TOKEN_END_TAG logical_expression BOOLEAN_CLOSE
;



arith_expression:
    arithmetic_expression PLUS arithmetic_expression
    | arithmetic_expression MINUS arithmetic_expression
    | arithmetic_expression MULTIPLY arithmetic_expression
    | arithmetic_expression DIVIDE arithmetic_expression
    | arithmetic_expression MOD arithmetic_expression
    | PARA_OPEN arithmetic_expression PARA_CLOSE 
    | INTEGER
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



%%

void yyerror(const char *s) {
    fprintf(stderr, "File \"Test\", line %d, character %d: syntaxic error\n", 
        yylineno, current_column-yyleng);
}

int main(void) {
  yyparse();
}