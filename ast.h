//
// Created by ruskaof on 11/12/23.
//

#ifndef LLP_BISON_PARSER_AST_H
#define LLP_BISON_PARSER_AST_H

#include <stddef.h>

#include "ast_node_type.h"

struct AstNode {
    enum AstNodeType type;
    char *value;
    size_t children_count;
    struct AstNode **children;
};

struct AstNode *create_ast_node(enum AstNodeType type, char *value, size_t children_count, ...);

char *to_string_ast_node(struct AstNode *node);

void free_ast_node(struct AstNode *node);

#endif //LLP_BISON_PARSER_AST_H
