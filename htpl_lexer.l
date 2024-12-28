%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "syntaxique.tab.h"

#define OUTPUT_METHOD "FILE" // FILE or CONSOLE
#define OUTPUTFILE "lexical-lexemes" // Output file name

// Define token types


// Global variable to hold the current token type
int current_token;
FILE *output_file;

void token_action(int token, char* text, FILE* output_file) {
    const char* token_name;
    switch (token) {
        case TOKEN_PROGRAM_OPEN: token_name = "PROGRAM_OPEN"; break;
        case TOKEN_PROGRAM_CLOSE: token_name = "PROGRAM_CLOSE"; break;
        case TOKEN_VARIABLES_OPEN: token_name = "VARIABLES_OPEN"; break;
        case TOKEN_VARIABLES_CLOSE: token_name = "VARIABLES_CLOSE"; break;
        case TOKEN_INSTRUCTIONS_OPEN: token_name = "INSTRUCTIONS_OPEN"; break;
        case TOKEN_INSTRUCTIONS_CLOSE: token_name = "INSTRUCTIONS_CLOSE"; break;
        case TOKEN_ASSIGN_OPEN: token_name = "ASSIGN_OPEN"; break;
        case TOKEN_ASSIGN_CLOSE: token_name = "ASSIGN_CLOSE"; break;
        case TOKEN_PRINT_OPEN: token_name = "PRINT_OPEN"; break;
        case TOKEN_PRINT_CLOSE: token_name = "PRINT_CLOSE"; break;
        case TOKEN_IF_OPEN: token_name = "IF_OPEN"; break;
        case TOKEN_IF_CLOSE: token_name = "IF_CLOSE"; break;
        case TOKEN_ELSE: token_name = "ELSE"; break;
        case TOKEN_VAR_INT_OPEN: token_name = "VAR_INT_OPEN"; break;
        case TOKEN_VAR_INT_CLOSE: token_name = "VAR_INT_CLOSE"; break;
        case TOKEN_VAR_FLOAT_OPEN: token_name = "VAR_FLOAT_OPEN"; break;
        case TOKEN_VAR_FLOAT_CLOSE: token_name = "VAR_FLOAT_CLOSE"; break;
        case TOKEN_VAR_BOOLEAN_OPEN: token_name = "VAR_BOOLEAN_OPEN"; break;
        case TOKEN_VAR_BOOLEAN_CLOSE: token_name = "VAR_BOOLEAN_CLOSE"; break;
        case TOKEN_VAR_STRING_OPEN: token_name = "VAR_STRING_OPEN"; break;
        case TOKEN_VAR_STRING_CLOSE: token_name = "VAR_STRING_CLOSE"; break;
        case TOKEN_EXPRESSION: token_name = "EXPRESSION"; break;
        case TOKEN_STRING: token_name = "STRING"; break;
        case TOKEN_SELF_CLOSING_TAG: token_name = "SELF_CLOSING_TAG"; break;
        case TOKEN_END_TAG: token_name = "END_TAG"; break;
        case TOKEN_WHILE_CLOSE: token_name = "WHILE_CLOSE"; break;
        case TOKEN_WHILE_OPEN: token_name = "WHILE_OPEN"; break;
        case TOKEN_ARRAY_CLOSE: token_name = "ARRAY_CLOSE"; break;
        case TOKEN_ARRAY_OPEN: token_name = "ARRAY_OPEN"; break;
        case TOKEN_ELEMENT_OPEN: token_name = "ELEMENT_OPEN"; break;
        case TOKEN_PLUS: token_name = "PLUS"; break;
        case TOKEN_MINUS: token_name = "MINUS"; break;
        case TOKEN_MULTIPLY: token_name = "MULTIPLY"; break;
        case TOKEN_DIVIDE: token_name = "DIVIDE"; break;
        case TOKEN_GREATER_THAN: token_name = "GREATER_THAN"; break;
        case TOKEN_LOWER_THAN: token_name = "LOWER_THAN"; break;
        case TOKEN_ASSIGN: token_name = "ASSIGN"; break;
        case TOKEN_LOWER_OR_EQUAL: token_name = "LOWER_OR_EQUAL"; break;
        case TOKEN_GREATER_OR_EQUAL: token_name = "GREATER_OR_EQUAL"; break;
        case TOKEN_OPEN_PARENTHESIS: token_name = "OPEN_PARENTHESIS"; break;
        case TOKEN_CLOSE_PARENTHESIS: token_name = "CLOSE_PARENTHESIS"; break;
        case TOKEN_QUOTE: token_name = "QUOTE"; break;
        case TOKEN_EQUAL: token_name = "EQUAL"; break;
        case IDENTIFICATEUR: token_name = "IDENTIFICATEUR"; break;
        case TOKEN_INT: token_name = "TOKEN_INT"; break;
        case TOKEN_FLOAT: token_name = "TOKEN_FLOAT"; break;
        case TOKEN_BOOLEAN: token_name = "TOKEN_BOOLEAN"; break;

        default: token_name = "UNRECOGNIZED"; break;
    }

    if (output_file) {
        fprintf(output_file, "%s , %s \n", token_name , text);
    }
    else {
        printf("Token: %d, Content: %s\n", token, text);
    }
}

%}

%option noyywrap

chiffre     [0-9]
ID          [a-zA-Z_][a-zA-Z0-9_]* 
int         {chiffre}+
float       {int}"."{int}
string      \"(\\.|[^"\\])*\"
boolean     "true"|"false"
type        ("int"|"float"|"string"|"boolean")
comment     \#[^\n]*

%%



[ \t\n]+              { /* Ignore spaces, tabs, and newlines */ }
{comment}             { /* Ignore comments */ }

"<program>"            { current_token = TOKEN_PROGRAM_OPEN; token_action(current_token, yytext, output_file); return current_token; }
"</program>"          { current_token = TOKEN_PROGRAM_CLOSE; token_action(current_token, yytext, output_file); return current_token; }
"<variables>"         { current_token = TOKEN_VARIABLES_OPEN; token_action(current_token, yytext, output_file); return current_token; }
"</variables>"        { current_token = TOKEN_VARIABLES_CLOSE; token_action(current_token, yytext, output_file); return current_token; }
"<instructions>"      { current_token = TOKEN_INSTRUCTIONS_OPEN; token_action(current_token, yytext, output_file); return current_token; }
"</instructions>"     { current_token = TOKEN_INSTRUCTIONS_CLOSE; token_action(current_token, yytext, output_file); return current_token; }
"<assign"             { current_token = TOKEN_ASSIGN_OPEN; token_action(current_token, yytext, output_file); return current_token; }
"</assign>"           { current_token = TOKEN_ASSIGN_CLOSE; token_action(current_token, yytext, output_file); return current_token; }
"<print"              { current_token = TOKEN_PRINT_OPEN; token_action(current_token, yytext, output_file); return current_token; }
"</print>"            { current_token = TOKEN_PRINT_CLOSE; token_action(current_token, yytext, output_file); return current_token; }
"<if"                 { current_token = TOKEN_IF_OPEN; token_action(current_token, yytext, output_file); return current_token; }
"</if>"               { current_token = TOKEN_IF_CLOSE; token_action(current_token, yytext, output_file); return current_token; }
"<else>"              { current_token = TOKEN_ELSE; token_action(current_token, yytext, output_file); return current_token; }
"<while"              { current_token = TOKEN_WHILE_OPEN; token_action(current_token, yytext, output_file); return current_token; }
"</while>"            { current_token = TOKEN_WHILE_CLOSE; token_action(current_token, yytext, output_file); return current_token; }
"<array"            { current_token = TOKEN_ARRAY_OPEN; token_action(current_token, yytext, output_file); return current_token; }
"</array>"            { current_token = TOKEN_ARRAY_CLOSE; token_action(current_token, yytext, output_file); return current_token; }
"<element"            { current_token = TOKEN_ELEMENT_OPEN; token_action(current_token, yytext, output_file); return current_token; }


"<int"             { current_token = TOKEN_VAR_INT_OPEN; token_action(current_token, yytext, output_file); return current_token; }
"</int>"         { current_token = TOKEN_VAR_INT_CLOSE; token_action(current_token, yytext, output_file); return current_token; }


"<float"             { current_token = TOKEN_VAR_FLOAT_OPEN; token_action(current_token, yytext, output_file); return current_token; }
"</float>"         { current_token = TOKEN_VAR_FLOAT_CLOSE; token_action(current_token, yytext, output_file); return current_token; }


"<boolean"             { current_token = TOKEN_VAR_BOOLEAN_OPEN; token_action(current_token, yytext, output_file); return current_token; }
"</boolean>"         { current_token = TOKEN_VAR_BOOLEAN_CLOSE; token_action(current_token, yytext, output_file); return current_token; }


"<string"             { current_token = TOKEN_VAR_STRING_OPEN; token_action(current_token, yytext, output_file); return current_token; }
"</string>"         { current_token = TOKEN_VAR_STRING_CLOSE; token_action(current_token, yytext, output_file); return current_token; }


"+"                   { current_token = TOKEN_PLUS; token_action(current_token, yytext, output_file) ; return current_token; }
"-"                   { current_token = TOKEN_MINUS; token_action(current_token, yytext, output_file); return current_token; }
"*"                   { current_token = TOKEN_MULTIPLY; token_action(current_token, yytext, output_file); return current_token; }
"/"                   { current_token = TOKEN_DIVIDE; token_action(current_token, yytext, output_file); return current_token; }
">>"                  { current_token = TOKEN_GREATER_THAN; token_action(current_token, yytext, output_file); return current_token; }
"<<"                  { current_token = TOKEN_LOWER_THAN; token_action(current_token, yytext, output_file); return current_token; }
"=="                  { current_token = TOKEN_EQUAL; token_action(current_token, yytext, output_file); return current_token; }
"<<="                 { current_token = TOKEN_LOWER_OR_EQUAL; token_action(current_token, yytext, output_file); return current_token; }
">>="                 { current_token = TOKEN_GREATER_OR_EQUAL; token_action(current_token, yytext, output_file); return current_token; }
"("                   { current_token = TOKEN_OPEN_PARENTHESIS; token_action(current_token, yytext, output_file); return current_token; }
")"                   { current_token = TOKEN_CLOSE_PARENTHESIS; token_action(current_token, yytext, output_file); return current_token; }

"="                   { current_token = TOKEN_ASSIGN; token_action(current_token, yytext, output_file); return current_token; }
"\""                  { current_token = TOKEN_QUOTE; token_action(current_token, yytext, output_file); return current_token; }

{float}              { current_token = TOKEN_FLOAT; token_action(current_token, yytext, output_file); return current_token; }
{int}                { current_token = TOKEN_INT; token_action(current_token, yytext, output_file); return current_token; }
{boolean}            { current_token = TOKEN_BOOLEAN; token_action(current_token, yytext, output_file); return current_token; }

{ID}                  { current_token = IDENTIFICATEUR; token_action(current_token, yytext, output_file); return current_token; }

"/>"                  { current_token = TOKEN_SELF_CLOSING_TAG; token_action(current_token, yytext, output_file); return current_token; }
">"                   { current_token = TOKEN_END_TAG; token_action(current_token, yytext, output_file); return current_token; }

{string}              { current_token = TOKEN_STRING; token_action(current_token, yytext, output_file); return current_token; }

.                     { current_token = TOKEN_UNRECOGNIZED; token_action(current_token, yytext, output_file); return current_token; }

%%
/*
int main(int argc, char **argv) {
    
    // Open input file if provided
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            fprintf(stderr, "Cannot open file %s\n", argv[1]);
            return 1;
        }
    }

    // Open output file once at the start
    if (OUTPUT_METHOD == "FILE"){
        output_file = fopen(OUTPUTFILE, "w");
        if (!output_file) {
            fprintf(stderr, "Cannot create output file lexical-lexemes\n");
            if (argc > 1) fclose(yyin);
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

    if (output_file) {  // Only close if we actually opened it
        fclose(output_file);
    }

    printf("Lexical analysis complete.\n");
    return 0;
}*/