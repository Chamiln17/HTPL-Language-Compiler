English | [Français](README.fr.md)

<p align="center">
  <img src="docs/assets/htpl.webp" alt="HTPL logo" width="320">
</p>

# HTPL compiler

HTPL is a small teaching language whose programs are written as XML-style tags: `<variables>` declares typed variables and arrays, `<instructions>` holds assignments, `if`/`else`, `while` and `print`. This repository holds a compiler front end for it, built with Flex and Bison. `htplc` reads an HTPL program, checks its syntax, fills a symbol table, and emits intermediate code as quadruples.

## A short HTPL program

```htpl
<program>
<variables>
    <int name="counter">(3)</int>
</variables>
<instructions>
    <if condition=(counter >> 0)>
        <assign counter=(counter - 1)/>
    </if>
</instructions>
</program>
```

Comparisons are spelled `>>`, `<<`, `>>=`, `<<=` and `==`, because a single `>` closes a tag. The full syntax is in the [language reference](docs/language.md).

## Pipeline

```mermaid
flowchart LR
    A[HTPL source] --> B[Lexer<br/>Flex]
    B -- tokens --> C[Parser and semantic actions<br/>Bison]
    C <--> D[(Symbol table)]
    C --> E[Quadruples]
```

Everything happens in a single pass: the parser pulls tokens from the lexer, and its semantic actions update the symbol table and append quadruples as each construct is recognised. The [architecture note](docs/architecture.md) covers temporaries and how jumps for `if`/`else` and `while` are back-patched.

## Build and run

You need flex, bison, gcc and make. On Ubuntu or Debian:

```sh
sudo apt install flex bison gcc make
```

On Windows, install [WSL](https://learn.microsoft.com/windows/wsl/install) with Ubuntu and run everything inside it.

```sh
make          # build htplc
make run      # compile examples/test.htpl
make check    # compare the output with examples/test.expected
make clean    # remove htplc and the generated sources
```

`htplc` reads the program on standard input, so you can compile your own file with `./htplc < program.htpl`.

## Sample output

`make run` first prints a trace of every token read, then the quadruples. This excerpt is the quadruple listing for [examples/test.htpl](examples/test.htpl), copied from [examples/test.expected](examples/test.expected):

```text
=== Quadruplets ===
0- (:=, 3, , counter)
1- (:=, "Test", , message)
2- (Bounds, 1, 5, )
3- (ADEC, numbers, , )
4- (:=, 2, , numbers[1])
5- (:=, 1, , numbers[2])
6- (>, counter, 0, T0)
7- (BZ, 11, , T0)
8- (+, numbers[1], 1, T1)
9- (:=, T1, , numbers[2])
10- (BR, 7, , )
11- (==, counter, 0, T2)
12- (BZ, 18, , T2)
13- (-, 3, 1, T3)
14- (:=, T3, , counter)
15- (-, 4, 1, T4)
16- (:=, T4, , counter)
17- (BR, 22, , )
18- (+, counter, 1, T5)
19- (:=, T5, , counter)
20- (+, counter, 1, T6)
21- (:=, T6, , counter)
==================
```

Each line is `index- (operator, operand 1, operand 2, result)`. `BZ` jumps when its operand is zero, `BR` jumps unconditionally, and `T0`, `T1`, ... are temporaries. After the listing, `htplc` prints `Parsing successful` and the symbol table.

## Project stages

The project was built in three steps. Only the last one is the current compiler.

| Stage | Folder | What it is |
| --- | --- | --- |
| 1 | [stages/01-lexer](stages/01-lexer/README.md) | Standalone Flex lexer that writes the token list to a file |
| 2 | [stages/02-recursive-descent](stages/02-recursive-descent/README.md) | Hand-written recursive-descent parser in C for the `<variables>` section |
| 3 (current) | [src](src) | Flex and Bison compiler with symbol table and quadruples, built as `htplc` |

## Current limitations

- Type checking covers declarations and assignments only, and array elements are only partially checked.
- A `while` loop does not re-evaluate its condition: it jumps back to the test and skips the code that computes the condition.
- `print` generates no quadruples.
- Buffers have fixed sizes: quadruple fields hold 14 characters, and an array keeps at most 10 initial elements.

The full list, with examples, is in the [language reference](docs/language.md#limitations).

## Documentation

- [Language reference](docs/language.md): syntax, types, expressions, and differences from the original spec
- [Architecture note](docs/architecture.md): symbol table, quadruples, back-patching
- Original reports, in French: [language annex](docs/reports/Annexe%20langage.pdf) and [lexical analysis report](docs/reports/Rapport%20analyse%20lexicale.pdf)

## Credits

Compilation project, 2CS, SIL track, ESI, 2024–2025

Team: Arabet Mohamed Ilyes, Bengherbia Abdelkarim, Bouacha Chamel Nadir, Mezenner Fares, Yekene Sofiane

**My contribution** (Chamel Nadir Bouacha): design and implementation of the syntax analysis, operator-precedence design for arithmetic expressions, and overall project design.
