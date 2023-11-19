//
// Created by ruskaof on 11/12/23.
//

#ifndef LLP_BISON_PARSER_AST_NODE_TYPE_H
#define LLP_BISON_PARSER_AST_NODE_TYPE_H

#define FOREACH_AST_NODE_TYPE(AST_NODE_TYPE) \
    AST_NODE_TYPE(ANT_QUERY) \
    AST_NODE_TYPE(ANT_SELECT) \
    AST_NODE_TYPE(ANT_FROM) \
    AST_NODE_TYPE(ANT_WHERE) \
    AST_NODE_TYPE(ANT_AND) \
    AST_NODE_TYPE(ANT_OR) \
    AST_NODE_TYPE(ANT_NOT) \
    AST_NODE_TYPE(ANT_COMPARISON) \
    AST_NODE_TYPE(ANT_EQUAL) \
    AST_NODE_TYPE(ANT_NOT_EQUAL) \
    AST_NODE_TYPE(ANT_LESS_THAN) \
    AST_NODE_TYPE(ANT_LESS_THAN_OR_EQUAL) \
    AST_NODE_TYPE(ANT_GREATER_THAN) \
    AST_NODE_TYPE(ANT_GREATER_THAN_OR_EQUAL) \
    AST_NODE_TYPE(ANT_PLUS) \
    AST_NODE_TYPE(ANT_MINUS) \
    AST_NODE_TYPE(ANT_TIMES) \
    AST_NODE_TYPE(ANT_DIVIDE) \
    AST_NODE_TYPE(ANT_MODULO) \
    AST_NODE_TYPE(ANT_NEGATE) \
    AST_NODE_TYPE(ANT_IDENTIFIER) \
    AST_NODE_TYPE(ANT_STRING) \
    AST_NODE_TYPE(ANT_INTEGER) \
    AST_NODE_TYPE(ANT_FLOAT) \
    AST_NODE_TYPE(ANT_BOOLEAN) \
    AST_NODE_TYPE(ANT_TRUE) \
    AST_NODE_TYPE(ANT_FALSE) \
    AST_NODE_TYPE(ANT_NULL) \
    AST_NODE_TYPE(ANT_COLUMN) \
    AST_NODE_TYPE(ANT_TABLE) \
    AST_NODE_TYPE(ANT_TABLE_COLUMN) \
    AST_NODE_TYPE(ANT_TABLE_COLUMN_ALIAS)

#define GENERATE_ENUM(ENUM) ENUM,
#define GENERATE_STRING(STRING) #STRING,

enum AstNodeType {FOREACH_AST_NODE_TYPE(GENERATE_ENUM)};

const char *AST_NODE_TYPE_STRING[] = {FOREACH_AST_NODE_TYPE(GENERATE_STRING)};

#endif //LLP_BISON_PARSER_AST_NODE_TYPE_H
