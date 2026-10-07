# Stage 2: recursive-descent parser

The second milestone: a hand-written recursive-descent parser in C, fed by the stage 1 lexer. It covers the `<variables>` section with string declarations only.

It runs in two steps:

1. [htpl_lexer_manual.l](htpl_lexer_manual.l) (the [stage 1](../01-lexer/README.md) lexer set to parser mode) turns an HTPL file into a space-separated token stream ending in `#`, written to `input.txt`.
2. [analyseur_syntaxique.c](analyseur_syntaxique.c) reads that token stream, parses it with one C function per grammar rule, and writes the verdict to the output file.

## Build and run

Needs flex and gcc (on Windows, use WSL).

```sh
flex htpl_lexer_manual.l
gcc lex.yy.c -o lexer
gcc analyseur_syntaxique.c -o analyseur
./lexer test.htpl
./analyseur input.txt output.txt
cat output.txt
```

`output.txt` ends with `Statut: Succès` and `Message: Analyse syntaxique terminée avec succès`. [input_example.txt](input_example.txt) is a ready-made token stream you can parse directly: `./analyseur input_example.txt output.txt`.

## What it shows

The grammar, as written in the comments of `analyseur_syntaxique.c`:

```text
<Z>  ::= <V> # EOF
<V>  ::= VARIABLES_OPEN <E> VARIABLES_CLOSE | ε
<E>  ::= VAR_STRING_OPEN <A> <E1>
<E1> ::= END_TAG STRING VAR_STRING_CLOSE <E2> | SELF_CLOSING_TAG <E2>
<E2> ::= <E> | ε
<A>  ::= IDENTIFICATEUR ASSIGN STRING
```

Each non-terminal is a C function that checks the current token and calls the next rule. Any unexpected token stops the parse with `ERREUR SYNTAXIQUE` in the output file.

## Relation to the current compiler

The current compiler replaces this hand-written parser with a Bison grammar, [src/syntaxique.y](../../src/syntaxique.y), that covers the whole language and generates quadruples.
