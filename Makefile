htplc: syntaxique.tab.c lex.yy.c tableSymboles.c tableSymbole.h
	gcc -o $@ syntaxique.tab.c tableSymboles.c lex.yy.c -lfl

syntaxique.tab.c syntaxique.tab.h &: syntaxique.y
	bison -d syntaxique.y

lex.yy.c: htpl_lexer.l syntaxique.tab.h
	flex htpl_lexer.l

run: htplc
	./htplc < test.htpl

check: htplc
	./htplc < test.htpl | diff -u test.expected -

clean:
	rm -f htplc syntaxique.tab.c syntaxique.tab.h lex.yy.c lexical-lexemes

.PHONY: run check clean
