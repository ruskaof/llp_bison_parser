%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include <stdbool.h>
    #include "parser.h"
%}


identifier [a-zA-Z]+[.]?[a-zA-Z]*
double [-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?
integer [-+]?[0-9]+

%%

"from" { return TOKEN_FROM; }
"in" { return TOKEN_IN; }
"let" { return TOKEN_LET; }
"=" { return TOKEN_EQ; }
"==" { return TOKEN_EQ_OP; }
"where" { return TOKEN_WHERE; }
"join" { return TOKEN_JOIN; }
"on" { return TOKEN_ON; }
"equals" { return TOKEN_EQUALS; }
"into" { return TOKEN_INTO; }
"orderby" { return TOKEN_ORDERBY; }
"ascending" { return TOKEN_ASCENDING; }
"descending" { return TOKEN_DESCENDING; }
"select" { return TOKEN_SELECT; }
"group" { return TOKEN_GROUP; }
"by" { return TOKEN_BY; }
"(" { return TOKEN_PAR_OPEN; }
")" { return TOKEN_PAR_CLOSE; }
"," { return TOKEN_COMMA; }

"||" { return TOKEN_OR; }
"&&" { return TOKEN_AND; }
"=" { return TOKEN_EQ; }
"!=" { return TOKEN_NE; }
"<" { return TOKEN_LT; }
">" { return TOKEN_GT; }
"<=" { return TOKEN_LE; }
">=" { return TOKEN_GE; }
"+" { return TOKEN_PLUS; }
"-" { return TOKEN_MINUS; }
"*" { return TOKEN_TIMES; }
"/" { return TOKEN_DIVIDE; }
"!" { return TOKEN_NOT; }

{identifier} {
    yylval.sval = strdup(yytext);
    return TOKEN_IDENTIFIER;
}

{integer} {
    yylval.ival = atoi(yytext);
    return TOKEN_INTEGER;
}

{double} {
    yylval.dval = atof(yytext);
    return TOKEN_DOUBLE;
}

[ \t\n] ;

. { printf("Unrecognized character: %s\n", yytext); }

%%