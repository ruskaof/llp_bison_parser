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
%token TOKEN_INSERT
%token TOKEN_VALUES
%token TOKEN_UPDATE
%token TOKEN_SET
%token TOKEN_DELETE

// etc
%token TOKEN_PAR_OPEN
%token TOKEN_PAR_CLOSE
%token TOKEN_COMMA
%token TOKEN_DOT
%token TOKEN_CONTAINS

// operators
%token TOKEN_OR
%token TOKEN_AND
%token TOKEN_EQ_OP TOKEN_NE
%token TOKEN_LT TOKEN_GT TOKEN_LE TOKEN_GE
%token TOKEN_PLUS TOKEN_MINUS
%token TOKEN_TIMES TOKEN_DIVIDE TOKEN_MOD
%token TOKEN_NOT
%token TOKEN_QUOTED_STRING

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
%type <sval> TOKEN_QUOTED_STRING
%type <ast_node> boolean_expression
%type <ast_node> expression
%type <ast_node> from_clause
%type <ast_node> query_body
%type <ast_node> query_body_clauses
%type <ast_node> query_body_clause
%type <ast_node> where_clause
%type <ast_node> join_clause
%type <ast_node> select_clause
%type <ast_node> select_query
%type <ast_node> insert_query
%type <ast_node> field_identifier
%type <ast_node> field_or_simple_identifier
%type <ast_node> value
%type <ast_node> values
%type <ast_node> values_clause
%type <ast_node> any_query
%type <ast_node> update_query
%type <ast_node> delete_query


// end of statement
%token END_OF_STATEMENT

%%


any_query
    : select_query END_OF_STATEMENT {
        set_root_ast_node($1);
        $$ = $1;
    }
    | insert_query END_OF_STATEMENT {
        set_root_ast_node($1);
        $$ = $1;
    }
    | update_query END_OF_STATEMENT {
        set_root_ast_node($1);
        $$ = $1;
    }
    | delete_query END_OF_STATEMENT {
        set_root_ast_node($1);
        $$ = $1;
    }
    ;

// linq does not support insert, update, delete so
// these statements will be added to the grammar
insert_query
    : TOKEN_INSERT TOKEN_INTO TOKEN_IDENTIFIER TOKEN_VALUES values_clause {
        struct AstNode *insert_into = create_ast_node(ANT_INSERT_INTO, 1, create_identifier_ast_node($3));
        struct AstNode *insert_values = create_ast_node(ANT_INSERT_VALUES, 1, $5);
        $$ = create_ast_node(ANT_INSERT_QUERY, 2, insert_into, insert_values);
    }
    ;

values_clause
    : TOKEN_PAR_OPEN values TOKEN_PAR_CLOSE { $$ = $2; }
    ;

values
    : value { $$ = $1; }
    | values TOKEN_COMMA value { $$ = create_ast_node(ANT_INSERT_VALUES, 2, $1, $3); }
    ;

value
    : TOKEN_INTEGER { $$ = create_int_literal_ast_node($1); }
    | TOKEN_DOUBLE { $$ = create_double_literal_ast_node($1); }
    | TOKEN_QUOTED_STRING { $$ = create_string_literal_ast_node($1); }
    | TOKEN_BOOLEAN { $$ = create_bool_literal_ast_node($1); }
    ;

update_query
    : TOKEN_UPDATE TOKEN_IDENTIFIER TOKEN_SET field_identifier TOKEN_EQ expression {
        struct AstNode *update_field = create_ast_node(ANT_UPDATE_FIELD, 1, create_identifier_ast_node($2));
        struct AstNode *update_set = create_ast_node(ANT_UPDATE_SET, 2, $4, $6);
        $$ = create_ast_node(ANT_UPDATE_QUERY, 2, update_field, update_set);
    }
    ;

delete_query
    : TOKEN_DELETE TOKEN_FROM TOKEN_IDENTIFIER TOKEN_WHERE boolean_expression {
        struct AstNode *delete_from = create_ast_node(ANT_DELETE_FROM, 1, create_identifier_ast_node($3));
        struct AstNode *delete_where = create_ast_node(ANT_DELETE_WHERE, 1, $5);
        $$ = create_ast_node(ANT_DELETE_QUERY, 2, delete_from, delete_where);
    }

select_query
    : from_clause query_body {
     $$ = create_ast_node(ANT_SELECT_QUERY, 2, $1, $2);
     set_root_ast_node($$);
    }
    ;

from_clause
    : TOKEN_FROM field_or_simple_identifier TOKEN_IN expression {
        struct AstNode *from_varname = create_ast_node(ANT_FROM_VARNAME, 1, $2);
        struct AstNode *from_collection = create_ast_node(ANT_FROM_COLLECTION_NAME, 1, $4);
        $$ = create_ast_node(ANT_FROM, 2, from_varname, from_collection);
    }
    ;

query_body
    : query_body_clauses select_clause {
        $$ = create_ast_node(ANT_QUERY_BODY, 2, $1, $2);
    }
    ;

query_body_clauses
    : query_body_clause { $$ = $1; }
    | query_body_clauses query_body_clause { $$ = create_ast_node(ANT_QUERY_BODY_CLAUSES, 2, $1, $2); }
    ;

query_body_clause
    : from_clause { $$ = $1; }
    | where_clause { $$ = $1; }
    | join_clause { $$ = $1; }
    ;

where_clause
    : TOKEN_WHERE boolean_expression { $$ = create_ast_node(ANT_WHERE, 1, $2); }
    ;

join_clause
    : TOKEN_JOIN field_or_simple_identifier TOKEN_IN expression TOKEN_ON expression TOKEN_EQUALS expression {
        struct AstNode *join_in = create_ast_node(ANT_JOIN_IN, 2, $2, $4);
        struct AstNode *join_on = create_ast_node(ANT_JOIN_ON, 2, $6, $8);
        $$ = create_ast_node(ANT_JOIN, 2, join_in, join_on);
    }
    ;

select_clause
    : TOKEN_SELECT expression { $$ = create_ast_node(ANT_SELECT, 1, $2); }
    ;

expression
    : field_or_simple_identifier { $$ = $1; }
    | boolean_expression { $$ = $1; }
    | TOKEN_DOUBLE { $$ = create_double_literal_ast_node($1); }
    | TOKEN_INTEGER { $$ = create_int_literal_ast_node($1); }
    | TOKEN_QUOTED_STRING { $$ = create_string_literal_ast_node($1); }
    | TOKEN_PAR_OPEN expression TOKEN_PAR_CLOSE { $$ = $2; }
    | expression TOKEN_PLUS expression { $$ = create_ast_node(ANT_PLUS, 2, $1, $3); }
    | expression TOKEN_MINUS expression { $$ = create_ast_node(ANT_MINUS, 2, $1, $3); }
    | expression TOKEN_TIMES expression { $$ = create_ast_node(ANT_TIMES, 2, $1, $3); }
    | expression TOKEN_DIVIDE expression { $$ = create_ast_node(ANT_DIVIDE, 2, $1, $3); }
    ;

boolean_expression
    : TOKEN_PAR_OPEN boolean_expression TOKEN_PAR_CLOSE { $$ = $2; }
    | expression TOKEN_EQ_OP expression { $$ = create_ast_node(ANT_EQ_OP, 2, $1, $3); }
    | boolean_expression TOKEN_AND boolean_expression { $$ = create_ast_node(ANT_AND, 2, $1, $3); }
    | boolean_expression TOKEN_OR boolean_expression { $$ = create_ast_node(ANT_OR, 2, $1, $3); }
    | expression TOKEN_LE expression { $$ = create_ast_node(ANT_LE, 2, $1, $3); }
    | expression TOKEN_GE expression { $$ = create_ast_node(ANT_GE, 2, $1, $3); }
    | expression TOKEN_LT expression { $$ = create_ast_node(ANT_LT, 2, $1, $3); }
    | expression TOKEN_GT expression { $$ = create_ast_node(ANT_GT, 2, $1, $3); }
    | expression TOKEN_NE expression { $$ = create_ast_node(ANT_NE, 2, $1, $3); }
    | TOKEN_NOT boolean_expression { $$ = create_ast_node(ANT_NOT, 1, $2); }
    | field_or_simple_identifier TOKEN_DOT TOKEN_CONTAINS TOKEN_PAR_OPEN expression TOKEN_PAR_CLOSE { $$ = create_ast_node(ANT_CONTAINS, 2, $1, $5); }
    | TOKEN_BOOLEAN { $$ = create_bool_literal_ast_node($1); }
    | field_or_simple_identifier { $$ = $1; }
    ;

field_or_simple_identifier
    : TOKEN_IDENTIFIER { $$ = create_identifier_ast_node($1); }
    | field_identifier { $$ = $1; }
    ;

field_identifier
    : TOKEN_IDENTIFIER TOKEN_DOT TOKEN_IDENTIFIER { $$ = create_ast_node(ANT_FIELD_IDENTIFIER, 2, create_identifier_ast_node($1), create_identifier_ast_node($3)); }
    ;

%%
