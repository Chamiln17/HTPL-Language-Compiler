#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "tableSymbole.h"

// Fonction de hachage
unsigned int hash(const char *name)
{
    unsigned int hash = 0;
    while (*name)
    {
        hash = (hash * 31) + *name++;
    }
    return 2;
}

// Initialiser la table des symboles
void initSymbolTable(SymbolTable *table)
{
    for (int i = 0; i < TABLE_SIZE; i++)
    {
        table->entries[i] = NULL;
    }
}

// Ajouter un symbole à la table
bool addSymbol(SymbolTable *table, const char *name, DataType type)
{
    unsigned int index = hash(name);

    // Verifier si le symbole existe dejà
    SymbolEntry *current = table->entries[index];
    while (current)
    {
        if (strcmp(current->name, name) == 0)
        {
            printf("Erreur : Le symbole '%s' existe dejà.\n", name);
            return false;
        }
        current = current->next;
    }

    // Creer une nouvelle entree
    SymbolEntry *newEntry = malloc(sizeof(SymbolEntry));
    if (!newEntry)
    {
        printf("Erreur d'allocation memoire.\n");
        return false;
    }

    newEntry->name = strdup(name);
    newEntry->type = type;
    newEntry->next = table->entries[index];
    table->entries[index] = newEntry;

    return true;
}

// Rechercher un symbole
SymbolEntry *findSymbol(SymbolTable *table, const char *name)
{
    unsigned int index = hash(name);

    SymbolEntry *current = table->entries[index];
    while (current)
    {
        if (strcmp(current->name, name) == 0)
        {
            return current;
        }
        current = current->next;
    }

    return NULL;
}

// Supprimer un symbole
bool removeSymbol(SymbolTable *table, const char *name)
{
    unsigned int index = hash(name);

    SymbolEntry *current = table->entries[index];
    SymbolEntry *prev = NULL;

    while (current)
    {
        if (strcmp(current->name, name) == 0)
        {
            // Supprimer l'entree
            if (prev)
            {
                prev->next = current->next;
            }
            else
            {
                table->entries[index] = current->next;
            }

            // Liberer la memoire
            free(current->name);
            free(current);

            return true;
        }

        prev = current;
        current = current->next;
    }

    printf("Symbole '%s' non trouve.\n", name);
    return false;
}

// Mettre à jour la valeur d'un symbole
bool updateSymbolValue(SymbolTable *table, const char *name, ArrayInfo arrayInfo) {
    SymbolEntry *symbol = findSymbol(table, name);
    if (!symbol) {
        printf("Symbole '%s' non trouve.\n", name);
        return false;
    }

    // We can only update array information
    if (symbol->type != TYPE_ARRAY) {
        printf("Le symbole n'est pas un tableau.\n");
        return false;
    }

    // Update array information
    symbol->Details.arrayInfo.elementType = arrayInfo.elementType;
    symbol->Details.arrayInfo.size = arrayInfo.size;

    return true;
}

// Afficher la table des symboles
void printSymbolTable(SymbolTable *table)
{
    printf("Table des symboles :\n");
    printf("---------------------\n");
    for (int i = 0; i < TABLE_SIZE; i++)
    {
        SymbolEntry *current = table->entries[i];
        while (current)
        {
            printf("Nom: %s | Type: ", current->name);
            switch (current->type)
            {
                case TYPE_INTEGER:
                    printf("entier");
                    break;
                case TYPE_FLOAT:
                    printf("flottant");
                    break;
                case TYPE_STRING:
                    printf("chaine");
                    break;
                case TYPE_BOOLEAN:
                    printf("booleen");
                    break;
                case TYPE_ARRAY:
                    printf("tableau [");
                    // Print array element type
                    switch (current->Details.arrayInfo.elementType)
                    {
                        case TYPE_INTEGER:
                            printf("entier");
                            break;
                        case TYPE_FLOAT:
                            printf("flottant");
                            break;
                        case TYPE_STRING:
                            printf("chaine");
                            break;
                        case TYPE_BOOLEAN:
                            printf("booleen");
                            break;
                        default:
                            printf("type non defini");
                    }
                    printf(", taille: %d]", current->Details.arrayInfo.size);
                    break;
                default:
                    printf("non defini");
            }
            printf("\n");
            current = current->next;
        }
    }
    printf("---------------------\n");
}

// Liberer la memoire de la table des symboles
void freeSymbolTable(SymbolTable *table)
{
    for (int i = 0; i < TABLE_SIZE; i++)
    {
        SymbolEntry *current = table->entries[i];
        while (current)
        {
            SymbolEntry *temp = current;
            current = current->next;

            free(temp->name);
            free(temp);
        }
        table->entries[i] = NULL;
    }
}

// DataType getVariableType(SymbolTable *table, const char *name)
// {
//     SymbolEntry *entry = findSymbol(table, name);

//     if (entry == NULL)
//     {
//         return TYPE_UNDEFINED;
//     }

//     return entry->type;
// }

// // Exemple d'utilisation
// int main() {
//     SymbolTable table;
//     initSymbolTable(&table);

//     // Ajout de symboles
//     addSymbol(&table, "x", TYPE_INTEGER);
//     addSymbol(&table, "pi", TYPE_FLOAT);
//     addSymbol(&table, "nom", TYPE_STRING);

//     // Mise à jour des valeurs
//     int x_val = 42;
//     float pi_val = 3.14159;
//     char* nom_val = "Alice";

//     updateSymbolValue(&table, "x", &x_val);
//     updateSymbolValue(&table, "pi", &pi_val);
//     updateSymbolValue(&table, "nom", &nom_val);

//     // Affichage
//     printSymbolTable(&table);

//     // Recherche
//     SymbolEntry* found = findSymbol(&table, "x");
//     if (found) {
//         printf("Symbole 'x' trouve.\n");
//     }

//     // Suppression
//     removeSymbol(&table, "pi");

//     // Affichage après suppression
//     printSymbolTable(&table);

//     // Liberation de la memoire
//     freeSymbolTable(&table);

//     return 0;
// }

bool isInteger(const char *str)
{
    if (!str || *str == '\0')
        return false;

    // Handle negative numbers
    if (*str == '-')
        str++;

    // Check each character is a digit
    while (*str)
    {
        if (!isdigit(*str))
            return false;
        str++;
    }
    return true;
}

bool isFloat(const char *str)
{
    if (!str || *str == '\0')
        return false;

    // Handle negative numbers
    if (*str == '-')
        str++;

    bool hasDecimal = false;
    bool hasDigit = false;

    while (*str)
    {
        if (isdigit(*str))
        {
            hasDigit = true;
        }
        else if (*str == '.' && !hasDecimal)
        {
            hasDecimal = true;
        }
        else
        {
            return false;
        }
        str++;
    }

    return hasDigit; // Must have at least one digit
}

bool isBoolean(const char *str)
{
    if (!str)
        return false;
    return (strcmp(str, "true") == 0 || strcmp(str, "false") == 0 ||
            strcmp(str, "0") == 0 || strcmp(str, "1") == 0);
}

bool isVariable(const char *str)
{
    if (!str || (!isalpha(*str) && *str != '_'))
        return false; // Must start with letter

    str++;
    while (*str)
    {
        if (!isalnum(*str) && *str != '_')
            return false;
        str++;
    }
    return true;
}

bool isString(const char *str)
{
    if (!str)
        return false;

    // String should start with double quote
    if (str[0] != '"')
        return false;

    int len = strlen(str);
    // String should end with double quote and have at least the quotes
    if (len < 2 || str[len - 1] != '"')
        return false;

    return true;
}

int isalpha(int c)
{
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z');
}

int isdigit(int c)
{
    return (c >= '0' && c <= '9');
}

int isalnum(int c)
{
    return isalpha(c) || isdigit(c);
}
