#include <stdio.h>
#include "ast.h"

extern int yyparse();

extern FILE *yyin;

void yyerror(const char *s) {
    printf("ERROR: %s\n", s);
}

int yywrap() { return (1); }

int main() {
    yyin = stdin;
    yyparse();
    printf("parse complete\n");
    print_ast_node(get_root_ast_node());
    free_ast_node(get_root_ast_node());
}
