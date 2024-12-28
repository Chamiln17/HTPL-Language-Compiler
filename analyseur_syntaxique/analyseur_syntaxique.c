#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

// --------------------------------------------------------------------
// Variables globales ou statiques pour la simplicité de la démonstration
// --------------------------------------------------------------------
static char* input;  // pointeur sur la chaîne d'entrée
static int indexInput = 0; // position courante dans la chaîne
static char tc;            // caractère (token) courant
static long fileSize;     // taille du fichier


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
// nextToken : lit le prochain caractère de l'entrée
// --------------------------------------------------------------------
void nextToken(void) {
    tc = input[indexInput];
    if (tc != '\0') {
        indexInput++;
    }
}

// --------------------------------------------------------------------
// error : en cas d'erreur on affiche un message et on stoppe le programme
// --------------------------------------------------------------------
void error(const char* message) {
    fprintf(stderr, "Erreur de syntaxe: %s\n", message);
    exit(EXIT_FAILURE);
}

// --------------------------------------------------------------------
// Z -> S #
// --------------------------------------------------------------------
void Z(void);

// --------------------------------------------------------------------
// S -> a A b | ε
// --------------------------------------------------------------------
void S(void);

// --------------------------------------------------------------------
// A -> c A | a b
// --------------------------------------------------------------------
void A(void);

// ====================================================================
// Implémentation des procédures
// ====================================================================

// Z -> S #
void Z(void) {
    // On appelle d'abord S
    S();

    // Puis on s'attend à lire le symbole '#'
    if (tc == '#') {
        printf("Chaine syntaxiquement correcte\n");
    } else {
        error("Symbole '#' attendu à la fin");
    }
}

// S -> a A b | ε
void S(void) {
    if (tc == 'a') {
        // On consomme 'a'
        nextToken();   // tc = 'a' lu, on avance

        // On appelle A
        A();

        // On s'attend à lire 'b'
        if (tc == 'b') {
            nextToken(); // consomme 'b'
        } else {
            error("'b' attendu après A");
        }
    }
    else {
        // Ici, la production S -> ε
        // On ne fait rien, MAIS on doit vérifier
        // que le symbole courant est bien dans FOLLOW(S) (= '#' ou éventuellement 'b')
        // D'après l’exemple, FOLLOW(S) = {#, b}.
        // Donc si tc n'est ni '#' ni 'b', c'est une erreur.
        if (tc != '#' && tc != 'b') {
            error("Ni 'a', ni symbole de FOLLOW(S) pour dériver epsilon");
        }
        // Sinon, on laisse passer (epsilon)
    }
}

// A -> c A | a b
void A(void) {
    if (tc == 'c') {
        // On consomme 'c'
        nextToken();

        // Appel récursif de A
        A();
    }
    else if (tc == 'a') {
        // On consomme 'a'
        nextToken();

        // On s'attend à lire 'b'
        if (tc == 'b') {
            nextToken();
            // Fin de la production A -> a b
        } else {
            error("'b' attendu après 'a' pour la production A -> a b");
        }
    }
    else {
        // Ici, pas de ε pour A : c'est nécessairement une erreur
        error("Symbole inattendu dans A");
    }
}

// ====================================================================
// Programme principal
// ====================================================================
int main(int argc, char* argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <fichier_entree> <fichier_sortie>\n", argv[0]);
        return EXIT_FAILURE;
    }

    input = readFile(argv[1]);
    indexInput = 0;
    nextToken();


    Z();
    writeResult(argv[2], true, "Analyse syntaxique terminée avec succès");
    
    free(input);
    return EXIT_SUCCESS;
}