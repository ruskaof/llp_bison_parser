#include <stdio.h>

extern int yyparse();

extern FILE *yyin;

void yyerror(const char *s) {
    printf("ERROR: %s\n", s);
}

int yywrap() { return (1); }

int main() {
    yyin = stdin;
    yyparse();
}
