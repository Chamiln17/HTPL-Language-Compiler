all: htplc

htplc: src/syntaxique.tab.c src/lex.yy.c src/tableSymboles.c src/tableSymbole.h
	gcc -o $@ $(filter %.c,$^)

src/syntaxique.tab.c: src/syntaxique.y
	bison -d -o src/syntaxique.tab.c src/syntaxique.y

src/syntaxique.tab.h: src/syntaxique.tab.c

src/lex.yy.c: src/htpl_lexer.l src/syntaxique.tab.h
	flex -o $@ src/htpl_lexer.l

run: htplc
	./htplc < examples/test.htpl

check: htplc
	sh tests/run.sh ./htplc

# Docs samples run through htplc; credits are checked only when the owner's local note exists.
test-docs: htplc
	python3 tests/check_docs.py . ./htplc
	python3 tests/check_readme.py . ./htplc $(wildcard .local/readme-credits.md)

clean:
	rm -f htplc src/syntaxique.tab.c src/syntaxique.tab.h src/lex.yy.c

.PHONY: all run check test-docs clean
