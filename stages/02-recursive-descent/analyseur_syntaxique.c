#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define MAX_TOKEN_LENGTH 256

// OPTINISATION : Utilisation d'une énumération pour les types de token pour eviter comparaison de chaines
typedef enum {
    TOKEN_VARIABLES_OPEN,
    TOKEN_VARIABLES_CLOSE,
    TOKEN_VAR_STRING_OPEN,
    TOKEN_VAR_STRING_CLOSE,
    TOKEN_END_TAG,
    TOKEN_SELF_CLOSING_TAG,
    TOKEN_IDENTIFICATEUR,
    TOKEN_ASSIGN,
    TOKEN_STRING,
    TOKEN_EOF,
    TOKEN_DIAZ,
} TokenType;

// Structure pour représenter un token
typedef struct {
    TokenType type;
    char value[MAX_TOKEN_LENGTH];
} Token;

// Variables globales ou statiques pour la simplicité de la démonstration

// Pointeur sur la chaîne d'entrée
static char* input;

// Position courante dans la chaîne
static int indexInput = 0;

// Token courant
static Token currentToken;

// Taille du fichier
static long fileSize;

// Fichier d'erreurs
FILE* err_file;

// --------------------------------------------------------------------
// Fonction pour lire le fichier
// --------------------------------------------------------------------
char* readFile(const char* filename) {
    FILE* file = fopen(filename, "rb");
    if (!file) {
        fprintf(stderr, "Impossible d'ouvrir le fichier %s\n", filename);
        exit(EXIT_FAILURE);
    }

    // Obtenir la taille du fichier
    fseek(file, 0, SEEK_END);
    fileSize = ftell(file);
    fseek(file, 0, SEEK_SET);

    // Allouer le buffer avec un octet supplémentaire pour le \0
    char* buffer = (char*)malloc(fileSize + 1);
    if (!buffer) {
        fprintf(stderr, "Erreur d'allocation mémoire\n");
        fclose(file);
        exit(EXIT_FAILURE);
    }

    // Lire le fichier
    if (fread(buffer, 1, fileSize, file) != fileSize) {
        fprintf(stderr, "Erreur de lecture du fichier\n");
        free(buffer);
        fclose(file);
        exit(EXIT_FAILURE);
    }

    buffer[fileSize] = '\0';  // Ajouter le caractère de fin de chaîne
    fclose(file);
    return buffer;
}

// --------------------------------------------------------------------
// Fonction pour écrire le résultat
// --------------------------------------------------------------------
void writeResult(const char* filename, bool success, const char* message) {
    FILE* outFile = fopen(filename, "w");
    if (!outFile) {
        fprintf(stderr, "Impossible d'ouvrir le fichier de sortie %s\n", filename);
        free(input);
        exit(EXIT_FAILURE);
    }
    
    fprintf(outFile, "Résultat de l'analyse syntaxique de %s :\n", input);
    fprintf(outFile, "--------------------------------\n");
    fprintf(outFile, "Statut: %s\n", success ? "Succès" : "Échec");
    fprintf(outFile, "Message: %s\n", message);
    
    fclose(outFile);
}

// --------------------------------------------------------------------
// Fonction pour afficher une erreur et quitter
// --------------------------------------------------------------------
void error(const char* message) {
    if (err_file) {
        fprintf(err_file, "ERREUR SYNTAXIQUE: %s\n", message);
        fclose(err_file);
    }
    free(input);
    exit(EXIT_FAILURE);
}

// --------------------------------------------------------------------
// Fonction pour lire le prochain token (Equivalent de ts)
// --------------------------------------------------------------------
void nextToken(void) {
    // Ignorer les espaces
    while (input[indexInput] == ' ' || input[indexInput] == '\n' || input[indexInput] == '\t') {
        indexInput++;
    }

    // Fin de la chaîne
    if (input[indexInput] == '\0') {
        currentToken.type = TOKEN_EOF;
        return;
    }

    // Buffer pour stocker le token
    char tokenBuffer[MAX_TOKEN_LENGTH] = {0};
    int bufferIndex = 0;

    // Lire jusqu'au prochain espace ou fin de fichier
    while (input[indexInput] != ' ' && input[indexInput] != '\n' && 
           input[indexInput] != '\t' && input[indexInput] != '\0' && 
           bufferIndex < MAX_TOKEN_LENGTH - 1) {
        tokenBuffer[bufferIndex++] = input[indexInput++];
    }
    tokenBuffer[bufferIndex] = '\0';

    // Déterminer un type au token
    if (strcmp(tokenBuffer, "VARIABLES_OPEN") == 0)
        currentToken.type = TOKEN_VARIABLES_OPEN;
    else if (strcmp(tokenBuffer, "VARIABLES_CLOSE") == 0)
        currentToken.type = TOKEN_VARIABLES_CLOSE;
    else if (strcmp(tokenBuffer, "VAR_STRING_OPEN") == 0)
        currentToken.type = TOKEN_VAR_STRING_OPEN;
    else if (strcmp(tokenBuffer, "VAR_STRING_CLOSE") == 0)
        currentToken.type = TOKEN_VAR_STRING_CLOSE;
    else if (strcmp(tokenBuffer, "END_TAG") == 0)
        currentToken.type = TOKEN_END_TAG;
    else if (strcmp(tokenBuffer, "SELF_CLOSING_TAG") == 0)
        currentToken.type = TOKEN_SELF_CLOSING_TAG;
    else if (strcmp(tokenBuffer, "IDENTIFICATEUR") == 0)
        currentToken.type = TOKEN_IDENTIFICATEUR;
    else if (strcmp(tokenBuffer, "ASSIGN") == 0)
        currentToken.type = TOKEN_ASSIGN;
    else if (strcmp(tokenBuffer, "STRING") == 0)
        currentToken.type = TOKEN_STRING;
    else if (strcmp(tokenBuffer, "#") == 0)
        currentToken.type = TOKEN_DIAZ;
    else if (strcmp(tokenBuffer, "UNRECOGNIZED") == 0)
        error("Token non reconnu");
    else
        currentToken.type = TOKEN_EOF;

    strcpy(currentToken.value, tokenBuffer);
}



// Déclarations des fonctions pour les procédures
void Z(void);
void V(void);
void E(void);
void E1(void);
void E2(void);
void A(void);

// ====================================================================
// Implémentation des procédures
// ====================================================================


// --------------------------------------------------------------------
// <Z> ::= <V> # EOF
// --------------------------------------------------------------------
void Z(void) {
    V();
    if (currentToken.type != TOKEN_DIAZ) {
        error("Symbole '#' attendu à la fin");
    }
    nextToken();
    if (currentToken.type != TOKEN_EOF) {
        error("Caractères supplémentaires après '#'");
    }
}

// --------------------------------------------------------------------
// 1. <V> ::= TOKEN_VARIABLES_OPEN <E> TOKEN_VARIABLES_CLOSE
// 2. <V> ::= ε 
// --------------------------------------------------------------------
void V(void) {
    if (currentToken.type == TOKEN_VARIABLES_OPEN) {
        nextToken();
        E();
        if (currentToken.type != TOKEN_VARIABLES_CLOSE) {
            error("Token TOKEN_VARIABLES_CLOSE attendu");
        }
        nextToken();
    }
    // ε case - ne rien faire
}

// --------------------------------------------------------------------
// 3. <E> ::= TOKEN_VAR_STRING_OPEN <A> <E1>
// --------------------------------------------------------------------
void E(void) {
    if (currentToken.type != TOKEN_VAR_STRING_OPEN) {
        error("TOKEN_VAR_STRING_OPEN attendu");
    }
    nextToken();
    A();
    E1();
}

// --------------------------------------------------------------------
// 4. <E1> ::= TOKEN_END_TAG TOKEN_STRING TOKEN_VAR_STRING_CLOSE <E2>
// 5. <E1> ::= TOKEN_SELF_CLOSING_TAG <E2>
// --------------------------------------------------------------------
void E1(void) {
    if (currentToken.type == TOKEN_END_TAG) {
        nextToken();
        if (currentToken.type != TOKEN_STRING) {
            error("TOKEN_STRING attendu après TOKEN_END_TAG");
        }
        nextToken();
        if (currentToken.type != TOKEN_VAR_STRING_CLOSE) {
            error("TOKEN_VAR_STRING_CLOSE attendu");
        }
        nextToken();
        E2();
    } else if (currentToken.type == TOKEN_SELF_CLOSING_TAG) {
        nextToken();
        E2();
    } else {
        error("TOKEN_END_TAG ou TOKEN_SELF_CLOSING_TAG attendu");
    }
}

// --------------------------------------------------------------------
// 6. <E2> ::= <E>
// 7. <E2> ::= ε
// --------------------------------------------------------------------
void E2(void) {
    if (currentToken.type == TOKEN_VAR_STRING_OPEN) {
        E();
    }
    // ε case - ne rien faire
}

// --------------------------------------------------------------------
// 8. <A> ::= TOKEN_IDENTIFICATEUR TOKEN_ASSIGN TOKEN_STRING
// --------------------------------------------------------------------
void A(void) {
    if (currentToken.type != TOKEN_IDENTIFICATEUR) {
        error("TOKEN_IDENTIFICATEUR attendu");
    }
    nextToken();

    if (currentToken.type != TOKEN_ASSIGN) {
        error("TOKEN_ASSIGN attendu");
    }
    nextToken();

    if (currentToken.type != TOKEN_STRING) {
        error("TOKEN_STRING attendu");
    }
    nextToken();
}


int main(int argc, char* argv[]) {

    // Vérifier les arguments (fichier d'entrée et de sortie)
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <fichier_entree> <fichier_sortie>\n", argv[0]);
        return EXIT_FAILURE;
    }

    // Ouvrir le fichier d'erreurs
    err_file = fopen(argv[2], "w");
    if (!err_file) {
        fprintf(stderr, "Cannot open output file %s\n", argv[2]);
        return EXIT_FAILURE;
    }

    // Lire le fichier d'entrée
    input = readFile(argv[1]);

    // Initialiser l'analyseur lexical
    indexInput = 0;

    // Lire le premier token
    nextToken();

    // Démarrer l'analyse syntaxique
    Z();

    // Écrire le résultat (Dans le cas ou il n'y a pas d'erreur)
    writeResult(argv[2], true, "Analyse syntaxique terminée avec succès");
    
    // Libérer la mémoire et fermer les fichiers
    free(input);

    // Fermer le fichier d'erreurs
    fclose(err_file);

    // Terminer le programme
    return EXIT_SUCCESS;
}