# Stage 1: lexer

The first milestone: a standalone Flex lexer for HTPL. It reads an HTPL file and writes one line per token (token name, then lexeme) to `output.txt`.

## Build and run

Needs flex and gcc (on Windows, use WSL).

```sh
flex htpl_lexer.l
gcc lex.yy.c
./a.out test.htpl
cat output.txt
```

The console shows `Starting lexical analysis:` and `Lexical analysis complete.`; the tokens are in `output.txt`. The sample input is [test.htpl](test.htpl), a `<variables>` section with two string declarations.

## What it shows

How HTPL's tag-shaped syntax (`<variables>`, `<string name="x">...</string>`, `/>`) splits into tokens, including the `.` fallback rule that emits `UNRECOGNIZED` for any other character.

## Relation to the current compiler

This lexer grew into [src/htpl_lexer.l](../../src/htpl_lexer.l), which returns Bison tokens to [src/syntaxique.y](../../src/syntaxique.y) instead of writing a file. The same lexer, set to write a token stream for a parser, is used in [stage 2](../02-recursive-descent/README.md). The original report (French) is [Rapport analyse lexicale.pdf](../../docs/reports/Rapport%20analyse%20lexicale.pdf).
