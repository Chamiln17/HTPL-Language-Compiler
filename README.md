# HTPL-Language-Compiler

# Lexical analyzer commands
flex htpl_lexer.l && gcc lex.yy.c
./a.out test.htpl