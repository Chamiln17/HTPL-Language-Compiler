
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

#define MAX_ATTRIBUTES 10

typedef struct {
    char* name;
    char* value;
    DataType type;
} SingleAttribute;

typedef struct {
    SingleAttribute attrs[MAX_ATTRIBUTES];
    int count;
} AttributeValue;


void initAttributeValue(AttributeValue* av) {
    av->count = 0;
}

void addAttribute(AttributeValue* av, const char* name, const char* value, DataType type) {
    if (av->count < MAX_ATTRIBUTES) {
        av->attrs[av->count].name = strdup(name);
        av->attrs[av->count].value = strdup(value);
        av->attrs[av->count].type = type;
        av->count++;
    }
}

typedef struct {
    char* values[10];
    int count;
} elementsArray;

void addElement(elementsArray* ea, const char* value) {
    if (ea->count < 10) {
        ea->values[ea->count++] = strdup(value);
    }
}

// Function to check if a string is an array reference
bool isArrayReference(const char* str) {
    char* bracket = strchr(str, '[');
    return bracket != NULL && strchr(bracket, ']') != NULL;
}

// Function to extract array name from reference
char* getArrayName(const char* arrayRef) {
    char* bracket = strchr(arrayRef, '[');
    if (!bracket) return NULL;
    
    int nameLen = bracket - arrayRef;
    char* name = malloc(nameLen + 1);
    strncpy(name, arrayRef, nameLen);
    name[nameLen] = '\0';
    return name;
}

// Function to extract array index from reference
int getArrayIndex(const char* arrayRef) {
    char* bracket = strchr(arrayRef, '[');
    if (!bracket) return -1;
    return atoi(bracket + 1);
}


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
    elementsArray elementsValues;
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


declaration_list:
   TOKEN_VAR_INT_OPEN attributes TOKEN_END_TAG expr_arithmetique TOKEN_VAR_INT_CLOSE {
        
        addSymbol(&symbolTable, $2.attrs[0].name , TYPE_INTEGER);
        char temp[15];
        sprintf(temp, "%s", $4);

        if (!isInteger(temp) && !isVariable(temp)) {
            yyerror("Invalid value for integer variable ");
        }
        createQuad(":=", temp, "", $2.attrs[0].name);
    } declaration_list
   | TOKEN_VAR_FLOAT_OPEN attributes TOKEN_END_TAG expr_arithmetique TOKEN_VAR_FLOAT_CLOSE {
        addSymbol(&symbolTable, $2.attrs[0].name, TYPE_FLOAT);
        char temp[15];
        sprintf(temp, "%s", $4);
        if (!isFloat(temp) && !isInteger(temp) && !isVariable(temp)) {
            yyerror("Invalid value for float variable");
        }
        createQuad(":=", temp, "", $2.attrs[0].name);
    } declaration_list
   | TOKEN_VAR_STRING_OPEN attributes TOKEN_END_TAG TOKEN_STRING TOKEN_VAR_STRING_CLOSE {
        addSymbol(&symbolTable, $2.attrs[0].name, TYPE_STRING);
        char temp[15];
        sprintf(temp, "%s", $4);
        if (!isString(temp)) {
            yyerror("Invalid value for string variable");
        }
        createQuad(":=", temp, "", $2.attrs[0].name);
    } declaration_list
   | TOKEN_VAR_BOOLEAN_OPEN attributes TOKEN_END_TAG expr_logique TOKEN_VAR_BOOLEAN_CLOSE {
        addSymbol(&symbolTable, $2.attrs[0].name, TYPE_BOOLEAN);
        char temp[15];
        sprintf(temp, "%s", $4);
        if (!isBoolean(temp) && !isVariable(temp)) {
            yyerror("Invalid value for boolean variable");
        }
        createQuad(":=", temp, "", $2.attrs[0].name);
    } declaration_list
   | TOKEN_ARRAY_OPEN attributes TOKEN_END_TAG elements TOKEN_ARRAY_CLOSE declaration_list {// Get array attributes (name, type, size)
        char* arrayName = NULL;
        char* arrayType = NULL;
        int arraySize = 0;
        DataType type = TYPE_UNDEFINED;


        // Parse through attributes to find name, type, and size
        if ($2.attrs[0].name) {
                arrayName = $2.attrs[0].name;
            }
        for(int i = 1; i < $2.count; i++) {
            printf("name: %s\n", $2.attrs[i].name);
            
            if (strcmp($2.attrs[i].name, "type") == 0) {
                arrayType = trimQuotes($2.attrs[i].value);
                // Convert string type to DataType enum
                if (strcmp(arrayType, "int") == 0) type = TYPE_INTEGER;
                else if (strcmp(arrayType, "float") == 0) type = TYPE_FLOAT;
                else if (strcmp(arrayType, "string") == 0) type = TYPE_STRING;
                else if (strcmp(arrayType, "boolean") == 0) type = TYPE_BOOLEAN;
            }
            else if (strcmp($2.attrs[i].name, "size") == 0) {
                arraySize = atoi($2.attrs[i].value);
            }
        }

        // Validate array attributes
        if (!arrayName || !arrayType || arraySize <= 0) {
            yyerror("Invalid array declaration: missing name, type, or size");
        }

        // Add to symbol table with array type
        bool added = addSymbol(&symbolTable, arrayName, TYPE_ARRAY);
        if (!added) {
            yyerror("Failed to add array to symbol table");
        }
        ArrayInfo arrayDetails;
        
        arrayDetails.elementType = type;  
        arrayDetails.size = arraySize;    
        updateSymbolValue(&symbolTable, arrayName, arrayDetails);


        // Generate quadruplets for array declaration
        char sizeStr[15];
        sprintf(sizeStr, "%d", arraySize);
        
        // Generate bounds quadruplet (Bounds, lower_bound, upper_bound, )
        createQuad("Bounds", "1", sizeStr, "");
        
        // Generate array declaration quadruplet (ADEC, array_name, , )
        createQuad("ADEC", arrayName, "", "");

        //add quadruplet for each element
        for(int i = 0; i < $4.count; i++) {
            char temp[15];
            sprintf(temp, "%s", $4.values[i]);
            char indexedName[30];
            sprintf(indexedName, "%s[%d]", arrayName, i + 1);
            createQuad(":=", temp, "", indexedName);
        }
   }
   | TOKEN_VAR_INT_OPEN attributes TOKEN_END_TAG expr_arithmetique TOKEN_VAR_INT_CLOSE {
        addSymbol(&symbolTable, $2.attrs[0].name, TYPE_INTEGER);
        
        char temp[15];
        sprintf(temp, "%s", $4);
        if (!isInteger(temp) && !isVariable(temp)) {
            yyerror("Invalid value for integer variable");
        }
        createQuad(":=", temp, "", $2.attrs[0].name);
    }
   | TOKEN_VAR_FLOAT_OPEN attributes TOKEN_END_TAG expr_arithmetique TOKEN_VAR_FLOAT_CLOSE {
        addSymbol(&symbolTable, $2.attrs[0].name, TYPE_FLOAT);
        char temp[15];
        sprintf(temp, "%s", $4);
        if (!isFloat(temp) && !isInteger(temp) && !isVariable(temp)) {
            yyerror("Invalid value for float variable");
        }
        createQuad(":=", temp, "", $2.attrs[0].name);
    }
   | TOKEN_VAR_STRING_OPEN attributes TOKEN_END_TAG TOKEN_STRING TOKEN_VAR_STRING_CLOSE {
        addSymbol(&symbolTable, $2.attrs[0].name, TYPE_STRING);
        char temp[15];
        sprintf(temp, "%s", $4);
        if (!isString(temp)) {
            yyerror("Invalid value for string variable");
        }
        createQuad(":=", temp, "", $2.attrs[0].name);
    }
   | TOKEN_VAR_BOOLEAN_OPEN attributes TOKEN_END_TAG expr_logique TOKEN_VAR_BOOLEAN_CLOSE {
        addSymbol(&symbolTable, $2.attrs[0].name, TYPE_BOOLEAN);
        char temp[15];
        sprintf(temp, "%s", $4);
        if (!isBoolean(temp) && !isVariable(temp)) {
            yyerror("Invalid value for boolean variable");
        }
        createQuad(":=", temp, "", $2.attrs[0].name);
    }
   | TOKEN_ARRAY_OPEN attributes TOKEN_END_TAG elements TOKEN_ARRAY_CLOSE{// Get array attributes (name, type, size)
        char* arrayName = NULL;
        char* arrayType = NULL;
        int arraySize = 0;
        DataType type = TYPE_UNDEFINED;


        // Parse through attributes to find name, type, and size
        if ($2.attrs[0].name) {
                arrayName = $2.attrs[0].name;
            }
        for(int i = 1; i < $2.count; i++) {
            printf("name: %s\n", $2.attrs[i].name);
            printf("value: %s\n", $2.attrs[i].value);
            if (strcmp($2.attrs[i].name, "type") == 0) {
            arrayType = trimQuotes($2.attrs[i].value);
                // Convert string type to DataType enum
                if (strcmp(arrayType, "int") == 0) type = TYPE_INTEGER;
                else if (strcmp(arrayType, "float") == 0) type = TYPE_FLOAT;
                else if (strcmp(arrayType, "string") == 0) type = TYPE_STRING;
                else if (strcmp(arrayType, "boolean") == 0) type = TYPE_BOOLEAN;
            }
            else if (strcmp($2.attrs[i].name, "size") == 0) {
                arraySize = atoi($2.attrs[i].value);
            }
        }

        // Validate array attributes
        if (!arrayName || !arrayType || arraySize <= 0) {
            yyerror("Invalid array declaration: missing name, type, or size");
        }

        // Add to symbol table with array type
        bool added = addSymbol(&symbolTable, arrayName, TYPE_ARRAY);
        if (!added) {
            yyerror("Failed to add array to symbol table");
        }
        ArrayInfo arrayDetails;
        arrayDetails.elementType = type;
        arrayDetails.size = arraySize;
        updateSymbolValue(&symbolTable, arrayName, arrayDetails);

        // Generate quadruplets for array declaration
        char sizeStr[15];
        sprintf(sizeStr, "%d", arraySize);
        
        // Generate bounds quadruplet (Bounds, lower_bound, upper_bound, )
        createQuad("Bounds", "1", sizeStr, "");
        
        // Generate array declaration quadruplet (ADEC, array_name, , )
        createQuad("ADEC", arrayName, "", "");
        //add quadruplet for each element
        for(int i = 0; i < $4.count; i++) {
            char temp[15];
            sprintf(temp, "%s", $4.values[i]);
            char indexedName[30];
            sprintf(indexedName, "%s[%d]", arrayName, i + 1);
            createQuad(":=", temp, "", indexedName);
        }
   }
   | TOKEN_VAR_INT_OPEN attributes TOKEN_SELF_CLOSING_TAG declaration_list {
        createQuad(":=", "0", "", $2.attrs[0].name);
    }
   | TOKEN_VAR_FLOAT_OPEN attributes TOKEN_SELF_CLOSING_TAG declaration_list {
        addSymbol(&symbolTable, $2.attrs[0].name, TYPE_FLOAT);
        createQuad(":=", "0.0", "", $2.attrs[0].name);
    }
   | TOKEN_VAR_STRING_OPEN attributes TOKEN_SELF_CLOSING_TAG declaration_list {
        addSymbol(&symbolTable, $2.attrs[0].name, TYPE_STRING);
        createQuad(":=", "", "", $2.attrs[0].name);
    }
   | TOKEN_VAR_BOOLEAN_OPEN attributes TOKEN_SELF_CLOSING_TAG declaration_list {
        addSymbol(&symbolTable, $2.attrs[0].name, TYPE_BOOLEAN);
        
        createQuad(":=", "0", "", $2.attrs[0].name);
    }
   | TOKEN_ARRAY_OPEN attributes TOKEN_SELF_CLOSING_TAG declaration_list{
        char* arrayName = NULL;
        char* arrayType = NULL;
        int arraySize = 0;
        DataType type = TYPE_UNDEFINED;


        // Parse through attributes to find name, type, and size
        if ($2.attrs[0].name) {
                arrayName = $2.attrs[0].name;
            }
        for(int i = 1; i < $2.count; i++) {
            if (strcmp($2.attrs[i].name, "type") == 0) {
                arrayType = trimQuotes($2.attrs[i].value);
                // Convert string type to DataType enum
                if (strcmp(arrayType, "int") == 0) type = TYPE_INTEGER;
                else if (strcmp(arrayType, "float") == 0) type = TYPE_FLOAT;
                else if (strcmp(arrayType, "string") == 0) type = TYPE_STRING;
                else if (strcmp(arrayType, "boolean") == 0) type = TYPE_BOOLEAN;
            }
            else if (strcmp($2.attrs[i].name, "size") == 0) {
                arraySize = atoi($2.attrs[i].value);
            }
        }

        // Validate array attributes
        if (!arrayName || !arrayType || arraySize <= 0) {
            yyerror("Invalid array declaration: missing name, type, or size");
        }

        // Add to symbol table with array type
        bool added = addSymbol(&symbolTable, arrayName, TYPE_ARRAY);
        if (!added) {
            yyerror("Failed to add array to symbol table");
        }
        ArrayInfo arrayDetails;
        arrayDetails.elementType = type;
        arrayDetails.size = arraySize;
        updateSymbolValue(&symbolTable, arrayName, arrayDetails);

        // Generate quadruplets for array declaration
        char sizeStr[15];
        sprintf(sizeStr, "%d", arraySize);
        
        // Generate bounds quadruplet (Bounds, lower_bound, upper_bound, )
        createQuad("Bounds", "1", sizeStr, "");
        
        // Generate array declaration quadruplet (ADEC, array_name, , )
        createQuad("ADEC", arrayName, "", "");
   }
   | TOKEN_VAR_INT_OPEN attributes TOKEN_SELF_CLOSING_TAG {
        addSymbol(&symbolTable, $2.attrs[0].name, TYPE_INTEGER);
        createQuad(":=", "0", "", $2.attrs[0].name);
    }
   | TOKEN_VAR_FLOAT_OPEN attributes TOKEN_SELF_CLOSING_TAG {
        addSymbol(&symbolTable, $2.attrs[0].name, TYPE_FLOAT);
        
        createQuad(":=", "0.0", "", $2.attrs[0].name);
    }
   | TOKEN_VAR_STRING_OPEN attributes TOKEN_SELF_CLOSING_TAG {
        addSymbol(&symbolTable, $2.attrs[0].name, TYPE_STRING);
        createQuad(":=", "", "", $2.attrs[0].name);
    }
   | TOKEN_VAR_BOOLEAN_OPEN attributes TOKEN_SELF_CLOSING_TAG {
        addSymbol(&symbolTable, $2.attrs[0].name, TYPE_BOOLEAN);
        createQuad(":=", "0", "", $2.attrs[0].name);
    }
    | TOKEN_ARRAY_OPEN attributes TOKEN_SELF_CLOSING_TAG {
        char* arrayName = NULL;
        char* arrayType = NULL;
        int arraySize = 0;
        DataType type = TYPE_UNDEFINED;


        // Parse through attributes to find name, type, and size
        if ($2.attrs[0].name) {
                arrayName = $2.attrs[0].name;
            }
        for(int i = 1; i < $2.count; i++) {
                        printf("name: %s\n", $2.attrs[i].name);

            if (strcmp($2.attrs[i].name, "type") == 0) {
                arrayType = trimQuotes($2.attrs[i].value);
                // Convert string type to DataType enum
                if (strcmp(arrayType, "int") == 0) type = TYPE_INTEGER;
                else if (strcmp(arrayType, "float") == 0) type = TYPE_FLOAT;
                else if (strcmp(arrayType, "string") == 0) type = TYPE_STRING;
                else if (strcmp(arrayType, "boolean") == 0) type = TYPE_BOOLEAN;
            }
            else if (strcmp($2.attrs[i].name, "size") == 0) {
                arraySize = atoi($2.attrs[i].value);
            }
        }

        // Validate array attributes
        if (!arrayName || !arrayType || arraySize <= 0) {
            yyerror("Invalid array declaration: missing name, type, or size");
        }

        // Add to symbol table with array type
        bool added = addSymbol(&symbolTable, arrayName, TYPE_ARRAY);
        if (!added) {
            yyerror("Failed to add array to symbol table");
        }
        ArrayInfo arrayDetails;
        arrayDetails.elementType = type;
        arrayDetails.size = arraySize;
        updateSymbolValue(&symbolTable, arrayName, arrayDetails);

        // Generate quadruplets for array declaration
        char sizeStr[15];
        sprintf(sizeStr, "%d", arraySize);
        
        // Generate bounds quadruplet (Bounds, lower_bound, upper_bound, )
        createQuad("Bounds", "1", sizeStr, "");
        
        // Generate array declaration quadruplet (ADEC, array_name, , )
        createQuad("ADEC", arrayName, "", "");
    }
    ;


array_reference:
    IDENTIFICATEUR TOKEN_OPEN_BRACKET expr_arithmetique TOKEN_CLOSE_BRACKET {
        char temp[15];
        snprintf(temp, sizeof(temp), "%s[%s]", $1, $3);
        $$ = strdup(temp);
    }
    ;

attributes:
   IDENTIFICATEUR TOKEN_ASSIGN TOKEN_STRING attributes {
        initAttributeValue(&$$);
        if (strcmp($1,"name") == 0) {
            addAttribute(&$$, trimQuotes($3),"value" , TYPE_STRING);
        } else {
            addAttribute(&$$, $1, $3, TYPE_STRING);
        }
        // Merge attributes from $4
        for(int i = 0; i < $4.count; i++) {
            addAttribute(&$$, $4.attrs[i].name, $4.attrs[i].value, $4.attrs[i].type);
        }
    }
   | IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_arithmetique TOKEN_CLOSE_PARENTHESIS attributes {
        initAttributeValue(&$$);
        addAttribute(&$$, $1, $4, TYPE_INTEGER);
    }
   | IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_logique TOKEN_CLOSE_PARENTHESIS attributes {
        initAttributeValue(&$$);
        addAttribute(&$$, $1, $4, TYPE_BOOLEAN);
    }
   | IDENTIFICATEUR TOKEN_ASSIGN TOKEN_STRING {
        initAttributeValue(&$$);
        if (strcmp($1,"name") == 0) {
            addAttribute(&$$, trimQuotes($3), "value" , TYPE_STRING);
        } else {
            addAttribute(&$$, $1, $3, TYPE_STRING);
        }

    }
   | IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_arithmetique TOKEN_CLOSE_PARENTHESIS {
        initAttributeValue(&$$);
        addAttribute(&$$, $1, $4, TYPE_INTEGER);
    }
   | IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_logique TOKEN_CLOSE_PARENTHESIS {
        initAttributeValue(&$$);
        addAttribute(&$$, $1, $4, TYPE_BOOLEAN);
    }
    | array_reference TOKEN_ASSIGN TOKEN_STRING {
        initAttributeValue(&$$);
        if (strcmp($1,"name") == 0) {
            addAttribute(&$$, trimQuotes($3), "value" , TYPE_STRING);
        } else {
            addAttribute(&$$, $1, $3, TYPE_STRING);
        }

    }
   | array_reference TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_arithmetique TOKEN_CLOSE_PARENTHESIS {
        initAttributeValue(&$$);
        addAttribute(&$$, $1, $4, TYPE_INTEGER);
    }
   | array_reference TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_logique TOKEN_CLOSE_PARENTHESIS {
        initAttributeValue(&$$);
        addAttribute(&$$, $1, $4, TYPE_BOOLEAN);
    }
   ;

elements:
   element elements {
    addElement(&$2, $1);
    //print elements
    for(int i = 0; i < $2.count; i++) {
    }
    $$ = $2;
   } | /* void */ {
        elementsArray ea;
        ea.count = 0;
        $$ = ea;
   }
   ;

element:
   TOKEN_ELEMENT_OPEN attributes TOKEN_SELF_CLOSING_TAG{
    if(strcmp($2.attrs[0].name, "value") == 0){
        char temp[15];
        sprintf(temp, "%s", $2.attrs[0].value);
        $$ = strdup(temp);
    }
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
        //update the value of a variable
        SymbolEntry* entry;
        if(isArrayReference($2.attrs[0].name)){
            char* arrayName = getArrayName($2.attrs[0].name);
            int index = getArrayIndex($2.attrs[0].name);
            entry = findSymbol(&symbolTable, arrayName);
            if (!entry) {
                yyerror("Array undefined");
            }
            if (entry->type != TYPE_ARRAY) {
                yyerror("Variable is not an array");
            }
            free(arrayName);
        }else{//normal variable
            entry = findSymbol(&symbolTable, $2.attrs[0].name);
            if (!entry) {
                yyerror("Variable undefined");
            }
        }
        
        char temp[15];
        sprintf(temp, "%s", $2.attrs[0].value);
        if (entry->type == TYPE_INTEGER) {
            if (!isInteger(temp) && !isVariable(temp)) {
                yyerror("Invalid value for integer variable");
            }
        } else if (entry->type == TYPE_FLOAT) {
            if (!isFloat(temp) && !isInteger(temp) && !isVariable(temp)) {
                yyerror("Invalid value for float variable");
            }
        } else if (entry->type == TYPE_STRING) {
            if (!isString(temp)) {
                yyerror("Invalid value for string variable");
            }
        } else if (entry->type == TYPE_BOOLEAN) {
            if (!isBoolean(temp) && !isVariable(temp)) {
                yyerror("Invalid value for boolean variable");
            }
        } //TODO: handle array type and array refernec type
        createQuad(":=", temp, "", $2.attrs[0].name);
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

    if (strcmp($2.attrs[0].name, "condition") == 0) {
        sauv_begin_if[++top_begin_if] = QC;
        char temp[15];
        sprintf(temp, "%s", $2.attrs[0].value);
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

    if (strcmp($2.attrs[0].name, "condition") == 0) {
        sauv_begin_While[++top_begin_While] = QC;
        char temp[15];
        sprintf(temp, "%s", $2.attrs[0].value);
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
    $$ = strdup(temp);
    }
    | array_reference {
        $$ = $1;
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
    exit(1);
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

    printSymbolTable(&symbolTable);
    freeSymbolTable(&symbolTable);
    return 0;
}


