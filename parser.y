%define parse.error verbose

%{
    #include <stdio.h>
    #include <math.h>
    #include <stdbool.h>
    #include "../ast.h"
    #include "parser.h"
    extern void yyerror (char const *);
    extern int yylex(void);
%}
%union {
    char *sval;
    double dval;
    int ival;
    bool bval;
    struct AstNode *ast_node;
}

// base
%token TOKEN_DOUBLE TOKEN_IDENTIFIER TOKEN_INTEGER TOKEN_BOOLEAN

// keywords
%token TOKEN_FROM
%token TOKEN_IN
%token TOKEN_EQ
%token TOKEN_WHERE
%token TOKEN_JOIN
%token TOKEN_ON
%token TOKEN_EQUALS
%token TOKEN_INTO
%token TOKEN_ASCENDING
%token TOKEN_DESCENDING
%token TOKEN_SELECT
%token TOKEN_GROUP
%token TOKEN_BY

// etc
%token TOKEN_PAR_OPEN
%token TOKEN_PAR_CLOSE
%token TOKEN_COMMA

// operators
%token TOKEN_OR
%token TOKEN_AND
%token TOKEN_EQ_OP TOKEN_NE
%token TOKEN_LT TOKEN_GT TOKEN_LE TOKEN_GE
%token TOKEN_PLUS TOKEN_MINUS
%token TOKEN_TIMES TOKEN_DIVIDE TOKEN_MOD
%token TOKEN_NOT

%left TOKEN_OR
%left TOKEN_AND
%left TOKEN_EQ_OP TOKEN_NE
%left TOKEN_LT TOKEN_GT TOKEN_LE TOKEN_GE
%left TOKEN_PLUS TOKEN_MINUS
%left TOKEN_TIMES TOKEN_DIVIDE TOKEN_MOD
%right TOKEN_NOT

%type <sval> TOKEN_IDENTIFIER
%type <dval> TOKEN_DOUBLE
%type <ival> TOKEN_INTEGER
%type <bval> TOKEN_BOOLEAN
%type <ast_node> boolean_expression
%type <ast_node> expression
%type <ast_node> query_expression
%type <ast_node> from_clause
%type <ast_node> query_body
%type <ast_node> query_body_clauses
%type <ast_node> query_body_clause
%type <ast_node> where_clause
%type <ast_node> join_clause
%type <ast_node> join_into_clause
%type <ast_node> select_clause
%type <ast_node> group_clause
%type <ast_node> query_continuation

// end of statement
%token END_OF_STATEMENT

%%

query_expression
    : from_clause query_body {
     $$ = create_ast_node(ANT_SELECT_QUERY, 2, $1, $2);
     print_ast_node($$);
    }
    ;

from_clause
    : TOKEN_FROM TOKEN_IDENTIFIER TOKEN_IN expression {
        printf("from clause\n");
        struct AstNode *identifier = create_identifier_ast_node($2);
        printf("identifier\n");
        print_ast_node(identifier);
        printf("expression\n");
        print_ast_node($4);
        $$ = create_ast_node(ANT_FROM, 2, identifier, $4);
    }
    ;

query_body
    : query_body_clauses select_clause {
        printf("query body\n");
        printf("query body clauses\n");
        print_ast_node($1);
        printf("select clause\n");
        print_ast_node($2);
        $$ = create_ast_node(ANT_QUERY_BODY, 2, $1, $2);
    }
    ;

query_body_clauses
    : query_body_clause {
        printf("query body clauses\n");
        $$ = $1;
    }
    | query_body_clauses query_body_clause { $$ = create_ast_node(ANT_QUERY_BODY_CLAUSES, 2, $1, $2); }
    ;

query_body_clause
    : from_clause { $$ = $1; }
    | where_clause { $$ = $1; }
    | join_clause { $$ = $1; }
    ;

where_clause
    : TOKEN_WHERE boolean_expression {
        printf("where clause\n");
        printf("boolean expression\n");
        print_ast_node($2);
        $$ = create_ast_node(ANT_WHERE, 1, $2);
    }
    ;

join_clause
    : TOKEN_JOIN TOKEN_IDENTIFIER TOKEN_IN expression TOKEN_ON expression TOKEN_EQUALS expression {
        struct AstNode *join_in = create_ast_node(ANT_JOIN_IN, 2, $2, $4);
        struct AstNode *join_on = create_ast_node(ANT_JOIN_ON, 2, $6, $8);
        $$ = create_ast_node(ANT_JOIN, 2, join_in, join_on);
    }
    ;

select_clause
    : TOKEN_SELECT expression {
        printf("select clause\n");
        $$ = create_ast_node(ANT_SELECT, 1, $2);
    }
    ;

expression
    : TOKEN_IDENTIFIER { $$ = create_identifier_ast_node($1); }
    | boolean_expression { $$ = $1; }
    | TOKEN_DOUBLE { $$ = create_double_literal_ast_node($1); }
    | TOKEN_INTEGER { $$ = create_int_literal_ast_node($1); }
    | TOKEN_PAR_OPEN expression TOKEN_PAR_CLOSE { $$ = $2; }
    | expression TOKEN_PLUS expression { $$ = create_ast_node(ANT_PLUS, 2, $1, $3); }
    | expression TOKEN_MINUS expression { $$ = create_ast_node(ANT_MINUS, 2, $1, $3); }
    | expression TOKEN_TIMES expression { $$ = create_ast_node(ANT_TIMES, 2, $1, $3); }
    | expression TOKEN_DIVIDE expression { $$ = create_ast_node(ANT_DIVIDE, 2, $1, $3); }
    ;

boolean_expression
    : TOKEN_IDENTIFIER { $$ = create_identifier_ast_node($1); }
    | TOKEN_PAR_OPEN boolean_expression TOKEN_PAR_CLOSE { $$ = $2; }
    | boolean_expression TOKEN_EQ_OP boolean_expression { $$ = create_ast_node(ANT_EQ_OP, 2, $1, $3); }
    | boolean_expression TOKEN_AND boolean_expression { $$ = create_ast_node(ANT_AND, 2, $1, $3); }
    | boolean_expression TOKEN_OR boolean_expression { $$ = create_ast_node(ANT_OR, 2, $1, $3); }
    | expression TOKEN_LE expression { $$ = create_ast_node(ANT_LE, 2, $1, $3); }
    | expression TOKEN_GE expression { $$ = create_ast_node(ANT_GE, 2, $1, $3); }
    | expression TOKEN_LT expression { $$ = create_ast_node(ANT_LT, 2, $1, $3); }
    | expression TOKEN_GT expression { $$ = create_ast_node(ANT_GT, 2, $1, $3); }
    | expression TOKEN_NE expression { $$ = create_ast_node(ANT_NE, 2, $1, $3); }
    | TOKEN_NOT boolean_expression { $$ = create_ast_node(ANT_NOT, 1, $2); }
    ;

%%
