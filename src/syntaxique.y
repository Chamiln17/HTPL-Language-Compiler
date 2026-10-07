
%code requires {
#include <stdbool.h>
#include "tableSymbole.h"

#define MAX_ATTRIBUTES 10
#define MAX_ELEMENTS 10

typedef struct {
    char* name;
    char* value;
    DataType type;
} SingleAttribute;

typedef struct {
    SingleAttribute attrs[MAX_ATTRIBUTES];
    int count;
} AttributeValue;

typedef struct {
    char* values[MAX_ELEMENTS];
    int count;
} elementsArray;
}


%union {
    int intVal;
    float floatVal;
    char* strVal;
    bool boolVal;
    AttributeValue attr;
    elementsArray elementsValues;
}

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <stdarg.h>
#include "tableSymbole.h"
extern int yylineno;
extern int yyleng;
int yylex();
void yyerror(const char *s);
void yysuccess(char *s);
int currentColumn = 1;
int trace = 0;

SymbolTable symbolTable;

char* trimQuotes(char* str) {
    size_t len = strlen(str);
    if (len >= 2 && str[0] == '"' && str[len - 1] == '"') {
        str[len - 1] = '\0';
        return str + 1;
    }
    return str;
}

// Formats a message into a heap string (used for error messages and quad operands).
char* format(const char* fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    int len = vsnprintf(NULL, 0, fmt, ap);
    va_end(ap);
    char* s = malloc(len + 1);
    va_start(ap, fmt);
    vsnprintf(s, len + 1, fmt, ap);
    va_end(ap);
    return s;
}

void initAttributeValue(AttributeValue* av) {
    av->count = 0;
}

void addAttribute(AttributeValue* av, const char* name, const char* value, DataType type) {
    if (av->count >= MAX_ATTRIBUTES) {
        yyerror("Too many attributes in one tag");
    }
    av->attrs[av->count].name = strdup(name);
    av->attrs[av->count].value = strdup(value);
    av->attrs[av->count].type = type;
    av->count++;
}

// One attribute followed by the attributes parsed after it.
AttributeValue prependAttribute(const char* name, const char* value, DataType type, const AttributeValue* rest) {
    AttributeValue av;
    initAttributeValue(&av);
    addAttribute(&av, name, value, type);
    for (int i = 0; rest && i < rest->count; i++) {
        addAttribute(&av, rest->attrs[i].name, rest->attrs[i].value, rest->attrs[i].type);
    }
    return av;
}

void addElement(elementsArray* ea, const char* value) {
    if (ea->count >= MAX_ELEMENTS) {
        yyerror("Too many elements in one array");
    }
    ea->values[ea->count++] = strdup(value);
}

bool isArrayReference(const char* str) {
    const char* bracket = strchr(str, '[');
    return bracket != NULL && strchr(bracket, ']') != NULL;
}

char* getArrayName(const char* arrayRef) {
    const char* bracket = strchr(arrayRef, '[');
    if (!bracket) return NULL;
    return strndup(arrayRef, bracket - arrayRef);
}


#define MAX_QUADS 1000

int QC = 0;
int ti = 0;

typedef struct quadruplet {
    char* op;
    char* opr1;
    char* opr2;
    char* res;
} Quad;

Quad quad[MAX_QUADS];

void createQuad(const char* op, const char* opr1, const char* opr2, const char* res) {
    if (QC >= MAX_QUADS) {
        yyerror("Too many quadruples");
    }
    quad[QC].op = strdup(op);
    quad[QC].opr1 = strdup(opr1);
    quad[QC].opr2 = strdup(opr2);
    quad[QC].res = strdup(res);
    QC++;
}

// Writes the jump target into the first operand of an already emitted BZ or BR.
void patchQuad(int index, int target) {
    free(quad[index].opr1);
    quad[index].opr1 = format("%d", target);
}

char* newTemp() {
    return format("T%d", ti++);
}

void printQuad() {
    printf("\n=== Quadruplets ===\n");
    for (int i = 0; i < QC; i++) {
        printf("%d- (%s, %s, %s, %s)\n", i, quad[i].op, quad[i].opr1, quad[i].opr2, quad[i].res);
    }
    printf("==================\n");
}


#define STACK_SIZE 100

int sauv_begin_if[STACK_SIZE];
int sauv_fin_if[STACK_SIZE];
int sauv_begin_While[STACK_SIZE];
int sauv_cond_While[STACK_SIZE];
int top_begin_if = -1;
int top_fin_if = -1;
int top_begin_While = -1;
int top_cond_While = -1;

void push(int stack[], int *top, int value) {
    if (*top + 1 >= STACK_SIZE) {
        yyerror("Control structures nested too deeply");
    }
    stack[++(*top)] = value;
}

int pop(int stack[], int *top) {
    if (*top == -1) {
        fprintf(stderr, "Stack underflow\n");
        exit(EXIT_FAILURE);
    }
    return stack[(*top)--];
}


// Checks that a value (literal, variable or temporary) suits a target of the given type.
void checkValue(DataType type, const char* value) {
    switch (type) {
    case TYPE_INTEGER:
        if (!isInteger(value) && !isVariable(value)) yyerror("Invalid value for integer variable");
        break;
    case TYPE_FLOAT:
        if (!isFloat(value) && !isInteger(value) && !isVariable(value)) yyerror("Invalid value for float variable");
        break;
    case TYPE_STRING:
        if (!isString(value)) yyerror("Invalid value for string variable");
        break;
    case TYPE_BOOLEAN:
        if (!isBoolean(value) && !isVariable(value)) yyerror("Invalid value for boolean variable");
        break;
    default:
        break;
    }
}

void declareSymbol(const char* name, DataType type) {
    if (!addSymbol(&symbolTable, name, type)) {
        yyerror(format("Variable '%s' already declared", name));
    }
}

void declareScalar(const AttributeValue* attrs, DataType type, const char* value) {
    const char* name = attrs->attrs[0].name;
    declareSymbol(name, type);
    checkValue(type, value);
    createQuad(":=", value, "", name);
}

void declareArray(const AttributeValue* attrs, const elementsArray* elements) {
    const char* arrayName = attrs->attrs[0].name;
    const char* arrayType = NULL;
    int arraySize = 0;

    for (int i = 1; i < attrs->count; i++) {
        if (strcmp(attrs->attrs[i].name, "type") == 0) {
            arrayType = attrs->attrs[i].value;
        } else if (strcmp(attrs->attrs[i].name, "size") == 0) {
            arraySize = atoi(attrs->attrs[i].value);
        }
    }

    if (!arrayType || arraySize <= 0) {
        yyerror("Invalid array declaration: missing name, type, or size");
    }
    if (strcmp(arrayType, "\"int\"") && strcmp(arrayType, "\"float\"")
        && strcmp(arrayType, "\"string\"") && strcmp(arrayType, "\"boolean\"")) {
        yyerror("Invalid array type");
    }
    if (elements->count > arraySize) {
        yyerror("More elements than the array size");
    }

    declareSymbol(arrayName, TYPE_ARRAY);
    createQuad("Bounds", "1", format("%d", arraySize), "");
    createQuad("ADEC", arrayName, "", "");
    for (int i = 0; i < elements->count; i++) {
        createQuad(":=", elements->values[i], "", format("%s[%d]", arrayName, i + 1));
    }
}

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
%token TOKEN_EXPRESSION
%token <strVal> TOKEN_STRING
%token TOKEN_PLUS TOKEN_MINUS TOKEN_MULTIPLY TOKEN_DIVIDE
%token TOKEN_GREATER_THAN TOKEN_LOWER_THAN
%token TOKEN_GREATER_OR_EQUAL TOKEN_LOWER_OR_EQUAL TOKEN_EQUAL
%token TOKEN_OPEN_PARENTHESIS TOKEN_CLOSE_PARENTHESIS
%token TOKEN_ASSIGN TOKEN_QUOTE
%token TOKEN_OPEN_BRACKET TOKEN_CLOSE_BRACKET
%token <strVal> IDENTIFICATEUR
%token <intVal> TOKEN_INT
%token <floatVal> TOKEN_FLOAT
%token <boolVal> TOKEN_BOOLEAN

/* Type declarations for non-terminals */
%type <attr> attributes
%type <strVal> expr_arithmetique terme facteur
%type <strVal> expr_logique
%type <strVal> array_reference
%type <strVal> element
%type <elementsValues> elements


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
   ;

/* Left recursion: each declaration's action runs as soon as it is parsed,
   so the quads come out in source order. */
declaration_list:
   declaration_list declaration
   | /* empty */
   ;

declaration:
   TOKEN_VAR_INT_OPEN attributes TOKEN_END_TAG expr_arithmetique TOKEN_VAR_INT_CLOSE {
        declareScalar(&$2, TYPE_INTEGER, $4);
    }
   | TOKEN_VAR_FLOAT_OPEN attributes TOKEN_END_TAG expr_arithmetique TOKEN_VAR_FLOAT_CLOSE {
        declareScalar(&$2, TYPE_FLOAT, $4);
    }
   | TOKEN_VAR_STRING_OPEN attributes TOKEN_END_TAG TOKEN_STRING TOKEN_VAR_STRING_CLOSE {
        declareScalar(&$2, TYPE_STRING, $4);
    }
   | TOKEN_VAR_BOOLEAN_OPEN attributes TOKEN_END_TAG expr_logique TOKEN_VAR_BOOLEAN_CLOSE {
        declareScalar(&$2, TYPE_BOOLEAN, $4);
    }
   | TOKEN_ARRAY_OPEN attributes TOKEN_END_TAG elements TOKEN_ARRAY_CLOSE {
        declareArray(&$2, &$4);
    }
   | TOKEN_VAR_INT_OPEN attributes TOKEN_SELF_CLOSING_TAG {
        declareScalar(&$2, TYPE_INTEGER, "0");
    }
   | TOKEN_VAR_FLOAT_OPEN attributes TOKEN_SELF_CLOSING_TAG {
        declareScalar(&$2, TYPE_FLOAT, "0.0");
    }
   | TOKEN_VAR_STRING_OPEN attributes TOKEN_SELF_CLOSING_TAG {
        declareScalar(&$2, TYPE_STRING, "\"\"");
    }
   | TOKEN_VAR_BOOLEAN_OPEN attributes TOKEN_SELF_CLOSING_TAG {
        declareScalar(&$2, TYPE_BOOLEAN, "0");
    }
   | TOKEN_ARRAY_OPEN attributes TOKEN_SELF_CLOSING_TAG {
        elementsArray none = { .count = 0 };
        declareArray(&$2, &none);
    }
   ;


array_reference:
    IDENTIFICATEUR TOKEN_OPEN_BRACKET expr_arithmetique TOKEN_CLOSE_BRACKET {
        $$ = format("%s[%s]", $1, $3);
    }
    ;

/* name="x" is stored as an attribute named x, so the declared name is always attrs[0].name. */
attributes:
   IDENTIFICATEUR TOKEN_ASSIGN TOKEN_STRING attributes {
        if (strcmp($1, "name") == 0) {
            $$ = prependAttribute(trimQuotes($3), "value", TYPE_STRING, &$4);
        } else {
            $$ = prependAttribute($1, $3, TYPE_STRING, &$4);
        }
    }
   | IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_arithmetique TOKEN_CLOSE_PARENTHESIS attributes {
        $$ = prependAttribute($1, $4, TYPE_INTEGER, &$6);
    }
   | IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_logique TOKEN_CLOSE_PARENTHESIS attributes {
        $$ = prependAttribute($1, $4, TYPE_BOOLEAN, &$6);
    }
   | IDENTIFICATEUR TOKEN_ASSIGN TOKEN_STRING {
        if (strcmp($1, "name") == 0) {
            $$ = prependAttribute(trimQuotes($3), "value", TYPE_STRING, NULL);
        } else {
            $$ = prependAttribute($1, $3, TYPE_STRING, NULL);
        }
    }
   | IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_arithmetique TOKEN_CLOSE_PARENTHESIS {
        $$ = prependAttribute($1, $4, TYPE_INTEGER, NULL);
    }
   | IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_logique TOKEN_CLOSE_PARENTHESIS {
        $$ = prependAttribute($1, $4, TYPE_BOOLEAN, NULL);
    }
   | array_reference TOKEN_ASSIGN TOKEN_STRING {
        $$ = prependAttribute($1, $3, TYPE_STRING, NULL);
    }
   | array_reference TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_arithmetique TOKEN_CLOSE_PARENTHESIS {
        $$ = prependAttribute($1, $4, TYPE_INTEGER, NULL);
    }
   | array_reference TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_logique TOKEN_CLOSE_PARENTHESIS {
        $$ = prependAttribute($1, $4, TYPE_BOOLEAN, NULL);
    }
   ;

/* Left recursion keeps the elements in source order. */
elements:
   elements element {
        $$ = $1;
        addElement(&$$, $2);
    }
   | /* empty */ {
        $$.count = 0;
    }
   ;

element:
   TOKEN_ELEMENT_OPEN attributes TOKEN_SELF_CLOSING_TAG {
        if (strcmp($2.attrs[0].name, "value") != 0) {
            yyerror("An array element needs a value attribute");
        }
        $$ = $2.attrs[0].value;
    }
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
        const char* target = $2.attrs[0].name;
        const char* value = $2.attrs[0].value;
        if (isArrayReference(target)) {
            char* arrayName = getArrayName(target);
            SymbolEntry* entry = findSymbol(&symbolTable, arrayName);
            if (!entry) {
                yyerror(format("Array '%s' undefined", arrayName));
            }
            if (entry->type != TYPE_ARRAY) {
                yyerror(format("Variable '%s' is not an array", arrayName));
            }
            free(arrayName);
        } else {
            SymbolEntry* entry = findSymbol(&symbolTable, target);
            if (!entry) {
                yyerror(format("Variable '%s' undefined", target));
            }
            checkValue(entry->type, value);
        }
        createQuad(":=", value, "", target);
    }
    ;


if_statement:
   if_condition TOKEN_END_TAG instruction_list {
        patchQuad(pop(sauv_begin_if, &top_begin_if), QC);
    } TOKEN_IF_CLOSE
   | if_condition TOKEN_END_TAG instruction_list {
        push(sauv_fin_if, &top_fin_if, QC);
        createQuad("BR", "", "", "");
        patchQuad(pop(sauv_begin_if, &top_begin_if), QC);
    }
   TOKEN_ELSE
   instruction_list
   TOKEN_IF_CLOSE {
        patchQuad(pop(sauv_fin_if, &top_fin_if), QC);
    }
   ;

if_condition:
   TOKEN_IF_OPEN attributes {
        if (strcmp($2.attrs[0].name, "condition") != 0) {
            yyerror("Invalid attribute for if statement");
        }
        push(sauv_begin_if, &top_begin_if, QC);
        createQuad("BZ", "", "", $2.attrs[0].value);
    }
   ;

/* The loop jumps back to the first quad of the condition, so it is recomputed on every iteration. */
while_statement:
   while_condition TOKEN_END_TAG
   instruction_list
   TOKEN_WHILE_CLOSE {
        int bz = pop(sauv_begin_While, &top_begin_While);
        int start = pop(sauv_cond_While, &top_cond_While);
        createQuad("BR", format("%d", start), "", "");
        patchQuad(bz, QC);
    }
   ;

while_condition:
    TOKEN_WHILE_OPEN {
        push(sauv_cond_While, &top_cond_While, QC);
    } attributes {
        if (strcmp($3.attrs[0].name, "condition") != 0) {
            yyerror("Invalid attribute for while statement");
        }
        push(sauv_begin_While, &top_begin_While, QC);
        createQuad("BZ", "", "", $3.attrs[0].value);
    }
    ;

print_statement:
   TOKEN_PRINT_OPEN attributes TOKEN_SELF_CLOSING_TAG {
        if (strcmp($2.attrs[0].name, "value") != 0) {
            yyerror("Invalid attribute for print statement");
        }
        createQuad("PRINT", $2.attrs[0].value, "", "");
    }
   ;

expr_arithmetique:
   terme {
        $$ = $1;
    }
   | expr_arithmetique TOKEN_PLUS terme {
        $$ = newTemp();
        createQuad("+", $1, $3, $$);
    }
   | expr_arithmetique TOKEN_MINUS terme {
        $$ = newTemp();
        createQuad("-", $1, $3, $$);
    }
   ;

terme:
   facteur {
        $$ = $1;
    }
   | terme TOKEN_MULTIPLY facteur {
        $$ = newTemp();
        createQuad("*", $1, $3, $$);
    }
   | terme TOKEN_DIVIDE facteur {
        $$ = newTemp();
        createQuad("/", $1, $3, $$);
    }
   ;

facteur:
    TOKEN_INT {
        $$ = format("%d", $1);
    }
    | TOKEN_FLOAT {
        $$ = format("%f", $1);
    }
    | IDENTIFICATEUR {
        $$ = $1;
    }
    | array_reference {
        $$ = $1;
    }
    | TOKEN_OPEN_PARENTHESIS expr_arithmetique TOKEN_CLOSE_PARENTHESIS {
        $$ = $2;
    }
    ;

expr_logique:
   expr_arithmetique TOKEN_EQUAL expr_arithmetique {
        $$ = newTemp();
        createQuad("==", $1, $3, $$);
    }
   | expr_arithmetique TOKEN_GREATER_THAN expr_arithmetique {
        $$ = newTemp();
        createQuad(">", $1, $3, $$);
    }
   | expr_arithmetique TOKEN_LOWER_THAN expr_arithmetique {
        $$ = newTemp();
        createQuad("<", $1, $3, $$);
    }
   | expr_arithmetique TOKEN_GREATER_OR_EQUAL expr_arithmetique {
        $$ = newTemp();
        createQuad(">=", $1, $3, $$);
    }
   | expr_arithmetique TOKEN_LOWER_OR_EQUAL expr_arithmetique {
        $$ = newTemp();
        createQuad("<=", $1, $3, $$);
    }
   | TOKEN_OPEN_PARENTHESIS expr_logique TOKEN_CLOSE_PARENTHESIS {
        $$ = $2;
    }
   | TOKEN_BOOLEAN {
        $$ = format("%d", $1);
    }
   ;

%%

void yysuccess(char *s) {
    currentColumn += yyleng;
}

void yyerror(const char *s) {
    fprintf(stdout, "File output, line %d, character %d :  %s \n", yylineno, currentColumn, s);
    exit(1);
}

// Usage: htplc [-t] < program.htpl   (-t prints every token as it is read)
int main(int argc, char **argv) {
    trace = argc > 1 && strcmp(argv[1], "-t") == 0;
    initSymbolTable(&symbolTable);
    if (yyparse() == 0) {
        printQuad();
        printf("Parsing successful\n");
    } else {
        fprintf(stderr, "Parsing failed\n");
        return 1;
    }

    printSymbolTable(&symbolTable);
    freeSymbolTable(&symbolTable);
    return 0;
}
