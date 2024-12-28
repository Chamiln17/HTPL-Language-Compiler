%{
#include <stdio.h>
#include <stdlib.h>


extern int yylineno;
extern int yyleng;
extern int current_column;

int yylex();
void yyerror(const char *s);
%}
%token TOKEN_PROGRAM_OPEN = 1,
    TOKEN_PROGRAM_CLOSE,
    TOKEN_VARIABLES_OPEN,
    TOKEN_VARIABLES_CLOSE,
    TOKEN_INSTRUCTIONS_OPEN,
    TOKEN_INSTRUCTIONS_CLOSE,
    TOKEN_ASSIGN_OPEN,
    TOKEN_ASSIGN_CLOSE,
    TOKEN_PRINT_OPEN,
    TOKEN_PRINT_CLOSE,
    TOKEN_IF_OPEN,
    TOKEN_IF_CLOSE,
    TOKEN_ELSE,
    TOKEN_VAR_INT_OPEN,
    TOKEN_VAR_INT_CLOSE,
    TOKEN_VAR_FLOAT_OPEN,
    TOKEN_VAR_FLOAT_CLOSE,
    TOKEN_VAR_BOOLEAN_OPEN,
    TOKEN_VAR_BOOLEAN_CLOSE,
    TOKEN_VAR_STRING_OPEN,
    TOKEN_VAR_STRING_CLOSE,
    TOKEN_EXPRESSION,
    TOKEN_STRING,
    TOKEN_ATTRIBUTE_NAME,
    TOKEN_SELF_CLOSING_TAG,
    TOKEN_END_TAG,
    TOKEN_WHILE_CLOSE,
    TOKEN_WHILE_OPEN,
    TOKEN_ARRAY_CLOSE,
    TOKEN_ARRAY_OPEN,
    TOKEN_ELEMENT_OPEN,
    TOKEN_UNRECOGNIZED,
    TOKEN_PLUS,
    TOKEN_MINUS,
    TOKEN_MULTIPLY,
    TOKEN_DIVIDE,
    TOKEN_GREATER_THAN,
    TOKEN_LOWER_THAN,
    TOKEN_ASSIGN,
    TOKEN_LOWER_OR_EQUAL,
    TOKEN_GREATER_OR_EQUAL,
    TOKEN_OPEN_PARENTHESIS,
    TOKEN_CLOSE_PARENTHESIS,
    TOKEN_QUOTE,
    TOKEN_EQUAL,
    IDENTIFICATEUR,
    TOKEN_FLOAT,
    TOKEN_INT,
    TOKEN_BOOLEAN

%%

program:
    TOKEN_PROGRAM_OPEN  TOKEN_VARIABLES_OPEN declaration_list TOKEN_VARIABLES_CLOSE TOKEN_INSTRUCTIONS_OPEN  body TOKEN_INSTRUCTIONS_CLOSE TOKEN_PROGRAM_CLOSE
    ;

declaration_list:
    declaration_list declaration | /* void */
    ;

declaration:
      TOKEN_VAR_INT_OPEN IDENTIFICATEUR TOKEN_ASSIGN TOKEN_STRING TOKEN_END_TAG arith_expression TOKEN_VAR_INT_OPEN
TOKEN_VAR_INT_CLOSE
    | TOKEN_VAR_FLOAT_OPEN IDENTIFICATEUR TOKEN_ASSIGN TOKEN_STRING TOKEN_END_TAG arith_expression TOKEN_VAR_FLOAT_CLOSE
    | TOKEN_VAR_STRING_OPEN IDENTIFICATEUR TOKEN_ASSIGN TOKEN_STRING TOKEN_END_TAG STRING TOKEN_VAR_STRING_CLOSE
    | TOKEN_VAR_BOOLEAN_OPEN IDENTIFICATEUR TOKEN_ASSIGN TOKEN_STRING TOKEN_END_TAG logical_expression TOKEN_VAR_BOOLEAN_CLOSE
;



arith_expression:
    arith_expression TOKEN_PLUS add_expression
    | arith_expression TOKEN_MINUS add_expression
    | arith_expression TOKEN_MULTIPLY add_expression
    | arith_expression TOKEN_DIVIDE add_expression
    | add_expression  
    ;

add_expression:
    add_expression TOKEN_PLUS mult_expression
    | add_expression TOKEN_MINUS mult_expression
    | mult_expression
    ;

mult_expression:
    mult_expression TOKEN_MULTIPLY unary_expression
    | mult_expression TOKEN_DIVIDE unary_expression
    | unary_expression
    ;

unary_expression:
    TOKEN_MINUS unary_expression
    | TOKEN_PLUS unary_expression
    | primary_expression
    ;

primary_expression:
    TOKEN_OPEN_PARENTHESIS arith_expression TOKEN_CLOSE_PARENTHESIS
    | TOKEN_INT
    | TOKEN_FLOAT
    | TOKEN_BOOLEAN
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