%{
    #include "stdio.h"
    #include "parser.tab.h"
%}

%option noyywrap

%%

[ \t]*"/*".*"*/"[ \t]*\n |
\/\/.* |
^A0\([0x]*[0-9a-fA-F]*\)\; |
R0\([0x]*[0-9a-zA-Z\,_\)\;]* |
W0\([0x]*[0-9a-zA-Z\,_\)\;]* { 
    yylval.str = yytext; 
    return COMMENT; 
}

^[A]\([0x]*[0-9a-fA-F]*\)\; { 
    long long i;
    char *p;
    i = strtoll(&yytext[2], &p, 16);
    yylval.num = i;
	return ADDRESS; 
}

[R]\([0x]*[0-9a-zA-Z\,_\)\;]* { 
    long long i;
    char *p;
    i = strtoll(&yytext[2], &p, 16);
    yylval.num = i;
	return COMPARE_VALUE; 
}

[W]\([0x]*[0-9a-zA-Z\,_\)\;]* { 
    long long i;
    char *p;
    i = strtoll(&yytext[2], &p, 16);
    yylval.num = i;
	return SET_VALUE; 
}

