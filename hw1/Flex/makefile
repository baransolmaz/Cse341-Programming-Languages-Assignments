target: test

test: gpp_lexer.l
	flex -o gpp_lexer.c gpp_lexer.l && gcc gpp_lexer.c -o lex && ./lex 