htplc: src/syntaxique.tab.c src/lex.yy.c src/tableSymboles.c src/tableSymbole.h
	gcc -o $@ src/syntaxique.tab.c src/tableSymboles.c src/lex.yy.c -lfl

src/syntaxique.tab.c src/syntaxique.tab.h &: src/syntaxique.y
	bison -d -o src/syntaxique.tab.c src/syntaxique.y

src/lex.yy.c: src/htpl_lexer.l src/syntaxique.tab.h
	flex -o $@ src/htpl_lexer.l

run: htplc
	./htplc < examples/test.htpl

check: htplc
	./htplc < examples/test.htpl | diff -u examples/test.expected -

clean:
	rm -f htplc src/syntaxique.tab.c src/syntaxique.tab.h src/lex.yy.c lexical-lexemes

.PHONY: run check clean
