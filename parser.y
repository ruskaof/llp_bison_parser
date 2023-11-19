%define parse.error verbose

%{
    #include <stdio.h>
    #include <math.h>
    #include <stdbool.h>
    extern void yyerror (char const *);
    extern int yylex(void);
%}
%union {
    char *sval;
    double dval;
    int ival;
    bool bval;
}

// base
%token TOKEN_DOUBLE TOKEN_IDENTIFIER TOKEN_INTEGER TOKEN_BOOLEAN

// keywords
%token TOKEN_FROM
%token TOKEN_IN
%token TOKEN_LET
%token TOKEN_EQ
%token TOKEN_WHERE
%token TOKEN_JOIN
%token TOKEN_ON
%token TOKEN_EQUALS
%token TOKEN_INTO
%token TOKEN_ORDERBY
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

%%

query_expression
    : from_clause query_body {
        
    }
    ;

from_clause
    : TOKEN_FROM TOKEN_IDENTIFIER TOKEN_IN expression
    ;

query_body
    : query_body_clauses select_or_group_clause query_continuation
    ;

query_body_clauses
    : query_body_clause
    | query_body_clauses query_body_clause
    | /* empty */
    ;

query_body_clause
    : from_clause
    | let_clause
    | where_clause
    | join_clause
    | join_into_clause
    | orderby_clause
    ;

let_clause
    : TOKEN_LET TOKEN_IDENTIFIER TOKEN_EQ expression
    ;

where_clause
    : TOKEN_WHERE boolean_expression
    ;

join_clause
    : TOKEN_JOIN TOKEN_IDENTIFIER TOKEN_IN expression TOKEN_ON expression TOKEN_EQUALS expression
    ;

join_into_clause
    : TOKEN_JOIN TOKEN_IDENTIFIER TOKEN_IN expression TOKEN_ON expression TOKEN_EQUALS expression TOKEN_INTO TOKEN_IDENTIFIER
    ;

orderby_clause
    : TOKEN_ORDERBY orderings
    ;

orderings
    : ordering
    : orderings TOKEN_COMMA ordering
    ;

ordering
    : expression ordering_direction
    ;

ordering_direction
    : TOKEN_ASCENDING
    | TOKEN_DESCENDING
    | /* empty */
    ;

select_or_group_clause
    : select_clause
    | group_clause
    ;

select_clause
    : TOKEN_SELECT expression
    ;

group_clause
    : TOKEN_GROUP expression TOKEN_BY expression
    ;

query_continuation
    : TOKEN_INTO TOKEN_IDENTIFIER query_body
    | /* empty */
    ;

expression
    : TOKEN_IDENTIFIER
    | TOKEN_DOUBLE
    | TOKEN_INTEGER
    | TOKEN_PAR_OPEN expression TOKEN_PAR_CLOSE
    | expression TOKEN_PLUS expression
    | expression TOKEN_MINUS expression
    | expression TOKEN_TIMES expression
    | expression TOKEN_DIVIDE expression
    | expression TOKEN_MOD expression
    | TOKEN_IDENTIFIER TOKEN_PAR_OPEN expression TOKEN_PAR_CLOSE

boolean_expression
    : TOKEN_IDENTIFIER
    | TOKEN_DOUBLE
    | TOKEN_INTEGER
    | TOKEN_PAR_OPEN boolean_expression TOKEN_PAR_CLOSE
    | boolean_expression TOKEN_EQ_OP boolean_expression
    | boolean_expression TOKEN_PLUS boolean_expression
    | boolean_expression TOKEN_MINUS boolean_expression
    | boolean_expression TOKEN_TIMES boolean_expression
    | boolean_expression TOKEN_DIVIDE boolean_expression
    | boolean_expression TOKEN_MOD boolean_expression
    | boolean_expression TOKEN_AND boolean_expression
    | boolean_expression TOKEN_OR boolean_expression
    | boolean_expression TOKEN_EQUALS boolean_expression
    | boolean_expression TOKEN_LE boolean_expression
    | boolean_expression TOKEN_GE boolean_expression
    | boolean_expression TOKEN_LT boolean_expression
    | boolean_expression TOKEN_GT boolean_expression
    | boolean_expression TOKEN_NE boolean_expression
    | TOKEN_IDENTIFIER TOKEN_PAR_OPEN boolean_expression TOKEN_PAR_CLOSE
    | TOKEN_NOT boolean_expression
    ;

%%
