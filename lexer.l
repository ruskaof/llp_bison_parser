%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include <stdbool.h>
    #include "parser.h"
    #include "../ast.h"
%}


identifier [a-zA-Z]+
double [-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?
integer [-+]?[0-9]+
boolean true|false
quoted_string \"[^\"]*\"

%%

"from" { return TOKEN_FROM; }
"in" { return TOKEN_IN; }
"=" { return TOKEN_EQ; }
"==" { return TOKEN_EQ_OP; }
"where" { return TOKEN_WHERE; }
"join" { return TOKEN_JOIN; }
"on" { return TOKEN_ON; }
"equals" { return TOKEN_EQUALS; }
"into" { return TOKEN_INTO; }
"select" { return TOKEN_SELECT; }
"Contains" { return TOKEN_CONTAINS; }
"insert" { return TOKEN_INSERT; }
"values" { return TOKEN_VALUES; }
"update" { return TOKEN_UPDATE; }
"set" { return TOKEN_SET; }
"delete" { return TOKEN_DELETE; }
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
"." { return TOKEN_DOT; }

{boolean} {
    yylval.bval = (strcmp(yytext, "true") == 0);
    return TOKEN_BOOLEAN;
}

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

{quoted_string} {
    yylval.sval = strdup(yytext);
    return TOKEN_QUOTED_STRING;
}

[ \t\n] ;

";" { return END_OF_STATEMENT; }

. { printf("Unrecognized character: %s\n", yytext); }

%%