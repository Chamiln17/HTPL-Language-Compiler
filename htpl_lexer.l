%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Define token types
enum TokenType {
    TOKEN_PROGRAM_OPEN = 1,
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
    TOKEN_VAR_OPEN,
    TOKEN_VAR_CLOSE,
    TOKEN_ATTRIBUTE_VALUE,
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
    TOKEN_UNRECOGNIZED
};

// Global variable to hold the current token type
int current_token;

%}

%option noyywrap

chiffre     [0-9]
ID          [a-zA-Z_][a-zA-Z0-9_]* 
int         {chiffre}+
float       {int}"."{int}
string      \"(\\.|[^"\\])*\"
boolean     "true" | "false"
type        ("int"|"float"|"string"|"boolean")
comment     \#[^\n]*

operation   [+\-*/]
comparison  "<<|>>|>>=|<<="
expression "("({ID}|{int}|{float}|{operation}|{comparison}|[ \t])*")"

%%

[ \t\n]+              { /* Ignore spaces, tabs, and newlines */ }
{comment}             { /* Ignore comments */ }

"<program"            { current_token = TOKEN_PROGRAM_OPEN; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }
"</program>"          { current_token = TOKEN_PROGRAM_CLOSE; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }
"<variables>"         { current_token = TOKEN_VARIABLES_OPEN; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }
"</variables>"        { current_token = TOKEN_VARIABLES_CLOSE; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }
"<instructions>"      { current_token = TOKEN_INSTRUCTIONS_OPEN; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }
"</instructions>"     { current_token = TOKEN_INSTRUCTIONS_CLOSE; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }
"<assign"             { current_token = TOKEN_ASSIGN_OPEN; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }
"</assign>"           { current_token = TOKEN_ASSIGN_CLOSE; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }
"<print"              { current_token = TOKEN_PRINT_OPEN; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }
"</print>"            { current_token = TOKEN_PRINT_CLOSE; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }
"<if"                 { current_token = TOKEN_IF_OPEN; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }
"</if>"               { current_token = TOKEN_IF_CLOSE; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }
"<else>"              { current_token = TOKEN_ELSE; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }
"<while"              { current_token = TOKEN_WHILE_OPEN; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }
"</while>"            { current_token = TOKEN_WHILE_CLOSE; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }
"<array"            { current_token = TOKEN_ARRAY_OPEN; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }
"</array>"            { current_token = TOKEN_ARRAY_CLOSE; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }
"<element"            { current_token = TOKEN_ELEMENT_OPEN; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }


"<"{type}             { current_token = TOKEN_VAR_OPEN; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }
"</"{type}">"         { current_token = TOKEN_VAR_CLOSE; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }

"="({expression}|{string}) { current_token = TOKEN_ATTRIBUTE_VALUE; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }
{expression}          { current_token = TOKEN_EXPRESSION; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }
{string}              { current_token = TOKEN_STRING; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }
{ID}                  { current_token = TOKEN_ATTRIBUTE_NAME; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }

"/>"                  { current_token = TOKEN_SELF_CLOSING_TAG; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }
">"                   { current_token = TOKEN_END_TAG; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }

.                     { current_token = TOKEN_UNRECOGNIZED; printf("Token: %d, Content: %s\n", current_token, yytext); return current_token; }

%%

int main(int argc, char **argv) {
    // Open input file if provided
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            fprintf(stderr, "Cannot open file %s\n", argv[1]);
            return 1;
        }
    }

    printf("Starting lexical analysis:\n");
    while (yylex() != 0) {
        // Token processing happens inside yylex
    }

    if (argc > 1) {
        fclose(yyin);
    }

    printf("Lexical analysis complete.\n");
    return 0;
}
