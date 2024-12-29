# HTPL-Language-Compiler

# Lexical analyzer commands
flex htpl_lexer.l && gcc lex.yy.c
./a.out test.htpl

# Syntaxical analyzer commands
cd analyseur_syntaxique
gcc analyseur_syntaxique.c -o analyseur
./analyseur input.txt output.txt