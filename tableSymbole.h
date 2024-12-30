#ifndef TABLE_SYMBOLE_H
#define TABLE_SYMBOLE_H

#include <stdbool.h>

typedef enum {
    TYPE_INTEGER,
    TYPE_FLOAT,
    TYPE_STRING,
    TYPE_BOOLEAN,
    TYPE_ARRAY,
    TYPE_UNDEFINED
} DataType;

typedef struct SymbolEntry {
    char* name;
    DataType type;
    int memory_address;
    bool is_initialized;
    union {
        int int_value;
        float float_value;
        char* string_value;
        bool bool_value;
    } value;
    struct SymbolEntry* next;
} SymbolEntry;

#define TABLE_SIZE 1000

typedef struct {
    SymbolEntry* entries[TABLE_SIZE];
} SymbolTable;

void initSymbolTable(SymbolTable* table);
bool addSymbol(SymbolTable* table, const char* name, DataType type);
SymbolEntry* findSymbol(SymbolTable* table, const char* name);
bool removeSymbol(SymbolTable* table, const char* name);
bool updateSymbolValue(SymbolTable* table, const char* name, void* value);
void printSymbolTable(SymbolTable* table);
void freeSymbolTable(SymbolTable* table);

#endif // TABLE_SYMBOLE_H