//
// Created by ruskaof on 11/12/23.
//

#ifndef LLP_BISON_PARSER_AST_NODE_TYPE_H
#define LLP_BISON_PARSER_AST_NODE_TYPE_H

// ANT = AST Node Type
#define FOREACH_AST_NODE_TYPE(AST_NODE_TYPE) \
    AST_NODE_TYPE(ANT_QUERY) \
    AST_NODE_TYPE(ANT_SELECT) \
    AST_NODE_TYPE(ANT_FROM) \
    AST_NODE_TYPE(ANT_FROM_VARNAME)          \
    AST_NODE_TYPE(ANT_FROM_COLLECTION_NAME)  \
    AST_NODE_TYPE(ANT_WHERE) \
    AST_NODE_TYPE(ANT_AND) \
    AST_NODE_TYPE(ANT_OR) \
    AST_NODE_TYPE(ANT_NOT) \
    AST_NODE_TYPE(ANT_EQ_OP) \
    AST_NODE_TYPE(ANT_NE) \
    AST_NODE_TYPE(ANT_LT) \
    AST_NODE_TYPE(ANT_GT) \
    AST_NODE_TYPE(ANT_LE) \
    AST_NODE_TYPE(ANT_GE) \
    AST_NODE_TYPE(ANT_PLUS) \
    AST_NODE_TYPE(ANT_MINUS) \
    AST_NODE_TYPE(ANT_TIMES) \
    AST_NODE_TYPE(ANT_DIVIDE) \
    AST_NODE_TYPE(ANT_IDENTIFIER) \
    AST_NODE_TYPE(ANT_STRING) \
    AST_NODE_TYPE(ANT_INTEGER) \
    AST_NODE_TYPE(ANT_DOUBLE) \
    AST_NODE_TYPE(ANT_BOOLEAN) \
    AST_NODE_TYPE(ANT_JOIN) \
    AST_NODE_TYPE(ANT_JOIN_IN) \
    AST_NODE_TYPE(ANT_JOIN_ON) \
    AST_NODE_TYPE(ANT_SELECT_QUERY_BODY)     \
    AST_NODE_TYPE(ANT_QUERY_BODY_CLAUSES)    \
    AST_NODE_TYPE(ANT_QUERY_BODY)            \
    AST_NODE_TYPE(ANT_SELECT_QUERY)          \
    AST_NODE_TYPE(ANT_FIELD_IDENTIFIER)      \
    AST_NODE_TYPE(ANT_CONTAINS)              \
    AST_NODE_TYPE(ANT_INSERT_QUERY)                \
    AST_NODE_TYPE(ANT_INSERT_INTO)           \
    AST_NODE_TYPE(ANT_INSERT_VALUES)         \
    AST_NODE_TYPE(ANT_UPDATE_QUERY)          \
    AST_NODE_TYPE(ANT_UPDATE_FIELD)          \
    AST_NODE_TYPE(ANT_UPDATE_SET)            \
    AST_NODE_TYPE(ANT_DELETE_QUERY)          \
    AST_NODE_TYPE(ANT_DELETE_FROM)           \
    AST_NODE_TYPE(ANT_DELETE_WHERE)          \


#define GENERATE_ENUM(ENUM) ENUM,
#define GENERATE_STRING(STRING) #STRING,

enum AstNodeType {FOREACH_AST_NODE_TYPE(GENERATE_ENUM)};
static const char *AstNodeTypeString[] = {FOREACH_AST_NODE_TYPE(GENERATE_STRING)};

#endif //LLP_BISON_PARSER_AST_NODE_TYPE_H
