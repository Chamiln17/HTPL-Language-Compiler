
%{
#include <stdio.h>
#include <stdlib.h>
extern int yylineno;
extern int yyleng;
extern int current_column;
int yylex();
void yyerror(const char *s);
int current_column = 0; // Define it globally
%}

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
%token TOKEN_EXPRESSION TOKEN_STRING
%token TOKEN_PLUS TOKEN_MINUS TOKEN_MULTIPLY TOKEN_DIVIDE
%token TOKEN_GREATER_THAN TOKEN_LOWER_THAN
%token TOKEN_GREATER_OR_EQUAL TOKEN_LOWER_OR_EQUAL TOKEN_EQUAL
%token TOKEN_OPEN_PARENTHESIS TOKEN_CLOSE_PARENTHESIS
%token TOKEN_ASSIGN TOKEN_QUOTE
%token IDENTIFICATEUR TOKEN_INT TOKEN_FLOAT TOKEN_BOOLEAN

/* Operator precedence */
%left TOKEN_PLUS TOKEN_MINUS
%left TOKEN_MULTIPLY TOKEN_DIVIDE
%left TOKEN_GREATER_THAN TOKEN_LOWER_THAN TOKEN_GREATER_OR_EQUAL TOKEN_LOWER_OR_EQUAL TOKEN_EQUAL

%%

program: 
   TOKEN_PROGRAM_OPEN 
   TOKEN_VARIABLES_OPEN declaration_list TOKEN_VARIABLES_CLOSE 
   TOKEN_INSTRUCTIONS_OPEN instruction_list TOKEN_INSTRUCTIONS_CLOSE 
   TOKEN_PROGRAM_CLOSE
   ;

declaration_list:
   declaration_list declaration 
   | /* empty */
   ;

declaration:
   TOKEN_VAR_INT_OPEN IDENTIFICATEUR TOKEN_ASSIGN TOKEN_STRING TOKEN_END_TAG expr_arithmetique TOKEN_VAR_INT_CLOSE
   | TOKEN_VAR_FLOAT_OPEN IDENTIFICATEUR TOKEN_ASSIGN TOKEN_STRING TOKEN_END_TAG expr_arithmetique TOKEN_VAR_FLOAT_CLOSE 
   | TOKEN_VAR_STRING_OPEN IDENTIFICATEUR TOKEN_ASSIGN TOKEN_STRING TOKEN_END_TAG TOKEN_STRING TOKEN_VAR_STRING_CLOSE
   | TOKEN_VAR_BOOLEAN_OPEN IDENTIFICATEUR TOKEN_ASSIGN TOKEN_STRING TOKEN_END_TAG expr_logique TOKEN_VAR_BOOLEAN_CLOSE
   | TOKEN_ARRAY_OPEN attributes TOKEN_END_TAG elements TOKEN_ARRAY_CLOSE
   ;

attributes:
   IDENTIFICATEUR TOKEN_ASSIGN TOKEN_STRING attributes
   | /* void */
   ;
elements:
   element elements  | /* void */
   ;
element:
   TOKEN_ELEMENT_OPEN IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_arithmetique TOKEN_CLOSE_PARENTHESIS TOKEN_SELF_CLOSING_TAG



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
   TOKEN_ASSIGN_OPEN IDENTIFICATEUR TOKEN_ASSIGN expr TOKEN_SELF_CLOSING_TAG
   ;

if_statement:
   TOKEN_IF_OPEN IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_logique TOKEN_CLOSE_PARENTHESIS TOKEN_END_TAG 
   instruction_list 
   TOKEN_IF_CLOSE
   |    TOKEN_IF_OPEN IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_logique TOKEN_CLOSE_PARENTHESIS TOKEN_END_TAG  
   instruction_list 
   TOKEN_ELSE 
   instruction_list 
   TOKEN_IF_CLOSE
   ;

while_statement:
   TOKEN_WHILE_OPEN IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_logique TOKEN_CLOSE_PARENTHESIS TOKEN_END_TAG 
   instruction_list 
   TOKEN_WHILE_CLOSE
   ;

print_statement:
   TOKEN_PRINT_OPEN IDENTIFICATEUR TOKEN_ASSIGN expr TOKEN_SELF_CLOSING_TAG
   ;

expr:
   expr_arithmetique
   | expr_logique
   | TOKEN_STRING
   ;

expr_arithmetique:
   terme
   | expr_arithmetique TOKEN_PLUS terme  
   | expr_arithmetique TOKEN_MINUS terme
   ;

terme:
   facteur
   | terme TOKEN_MULTIPLY facteur
   | terme TOKEN_DIVIDE facteur  
   ;

facteur:
   TOKEN_INT
   | TOKEN_FLOAT  
   | IDENTIFICATEUR
   | TOKEN_OPEN_PARENTHESIS expr_arithmetique TOKEN_CLOSE_PARENTHESIS
   ; 

expr_logique:
   expr_arithmetique TOKEN_EQUAL expr_arithmetique
   | expr_arithmetique TOKEN_GREATER_THAN expr_arithmetique
   | expr_arithmetique TOKEN_LOWER_THAN expr_arithmetique
   | expr_arithmetique TOKEN_GREATER_OR_EQUAL expr_arithmetique 
   | expr_arithmetique TOKEN_LOWER_OR_EQUAL expr_arithmetique
   | TOKEN_OPEN_PARENTHESIS expr_logique TOKEN_CLOSE_PARENTHESIS
   | TOKEN_BOOLEAN
   ;

%%
   
void yyerror(const char *s) {
   fprintf(stderr, "File \"Test\", line %d, character %d: syntaxic error\n", 
      yylineno, current_column-yyleng);
}

int main(void) {
   yyparse();
   return 0;
}