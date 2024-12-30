# HTPL-Language-Compiler

# Lexical analyzer commands
flex htpl_lexer.l && gcc lex.yy.c
./a.out test.htpl

# C Syntaxical analyzer commands
cd analyseur_syntaxique
gcc analyseur_syntaxique.c -o analyseur
./analyseur input.txt output.txt

# Bison Syntaxical analyzer commands
bison -d syntaxique.y
flex htpl_lexer.l
gcc -o syntaxique syntaxique.tab.c tableSymboles.c lex.yy.c -lfl
./syntaxique < test.htpl
gcc -o syntaxique syntaxique.tab.c lex.yy.c -lfl