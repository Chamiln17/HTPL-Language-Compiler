#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "tableSymbole.h"


// Fonction de hachage
unsigned int hash(const char* name) {
    unsigned int hash = 0;
    while (*name) {
        hash = (hash * 31) + *name++;
    }
    return 2;
}

// Initialiser la table des symboles
void initSymbolTable(SymbolTable* table) {
    for (int i = 0; i < TABLE_SIZE; i++) {
        table->entries[i] = NULL;
    }
}

// Ajouter un symbole à la table
bool addSymbol(SymbolTable* table, const char* name, DataType type) {
    unsigned int index = hash(name);
    
    // Verifier si le symbole existe dejà
    SymbolEntry* current = table->entries[index];
    while (current) {
        if (strcmp(current->name, name) == 0) {
            printf("Erreur : Le symbole '%s' existe dejà.\n", name);
            return false;
        }
        current = current->next;
    }
    
    // Creer une nouvelle entree
    SymbolEntry* newEntry = malloc(sizeof(SymbolEntry));
    if (!newEntry) {
        printf("Erreur d'allocation memoire.\n");
        return false;
    }
    
    newEntry->name = strdup(name);
    newEntry->type = type;
    newEntry->is_initialized = false;
    newEntry->memory_address = -1;  // Adresse non assignee
    newEntry->next = table->entries[index];
    table->entries[index] = newEntry;
    
    return true;
}

// Rechercher un symbole
SymbolEntry* findSymbol(SymbolTable* table, const char* name) {
    unsigned int index = hash(name);
    
    SymbolEntry* current = table->entries[index];
    while (current) {
        if (strcmp(current->name, name) == 0) {
            return current;
        }
        current = current->next;
    }
    
    return NULL;
}

// Supprimer un symbole
bool removeSymbol(SymbolTable* table, const char* name) {
    unsigned int index = hash(name);
    
    SymbolEntry* current = table->entries[index];
    SymbolEntry* prev = NULL;
    
    while (current) {
        if (strcmp(current->name, name) == 0) {
            // Supprimer l'entree
            if (prev) {
                prev->next = current->next;
            } else {
                table->entries[index] = current->next;
            }
            
            // Liberer la memoire
            free(current->name);
            if (current->type == TYPE_STRING && current->value.string_value) {
                free(current->value.string_value);
            }
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
bool updateSymbolValue(SymbolTable* table, const char* name, void* value) {
    SymbolEntry* symbol = findSymbol(table, name);
    
    if (!symbol) {
        printf("Symbole '%s' non trouve.\n", name);
        return false;
    }
    
    switch (symbol->type) {
        case TYPE_INTEGER:
            symbol->value.int_value = *(int*)value;
            break;
        case TYPE_FLOAT:
            symbol->value.float_value = *(float*)value;
            break;
        case TYPE_STRING:
            if (symbol->value.string_value) {
                free(symbol->value.string_value);
            }
            symbol->value.string_value = strdup(*(char**)value);
            break;
        case TYPE_BOOLEAN:
            symbol->value.bool_value = *(bool*)value;
            break;
        default:
            printf("Type de donnees non supporte.\n");
            return false;
    }
    
    symbol->is_initialized = true;
    return true;
}

// Afficher la table des symboles
void printSymbolTable(SymbolTable* table) {
    printf("Table des symboles :\n");
    printf("---------------------\n");
    
    for (int i = 0; i < TABLE_SIZE; i++) {
        SymbolEntry* current = table->entries[i];
        while (current) {
            printf("Nom: %s | Type: ", current->name);
            
            switch (current->type) {
                case TYPE_INTEGER:
                    printf("entier");
                    if (current->is_initialized) 
                        printf(" | Valeur: %d", current->value.int_value);
                    break;
                case TYPE_FLOAT:
                    printf("flottant");
                    if (current->is_initialized)
                        printf(" | Valeur: %f", current->value.float_value);
                    break;
                case TYPE_STRING:
                    printf("chaine");
                    if (current->is_initialized)
                        printf(" | Valeur: %s", current->value.string_value);
                    break;
                case TYPE_BOOLEAN:
                    printf("booleen");
                    if (current->is_initialized)
                        printf(" | Valeur: %s", current->value.bool_value ? "true" : "false");
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
void freeSymbolTable(SymbolTable* table) {
    for (int i = 0; i < TABLE_SIZE; i++) {
        SymbolEntry* current = table->entries[i];
        while (current) {
            SymbolEntry* temp = current;
            current = current->next;
            
            free(temp->name);
            if (temp->type == TYPE_STRING && temp->value.string_value) {
                free(temp->value.string_value);
            }
            free(temp);
        }
        table->entries[i] = NULL;
    }
}

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