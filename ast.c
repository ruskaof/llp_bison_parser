//
// Created by ruskaof on 11/12/23.
//

#include "ast.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

#define AST_NODE_STRING_MAX_LENGTH 1024

struct AstNode *create_ast_node(enum AstNodeType type, char *value, size_t children_count, ...) {
    struct AstNode *node = malloc(sizeof(struct AstNode));
    node->type = type;
    node->value = value;
    node->children_count = children_count;
    node->children = malloc(sizeof(struct AstNode *) * children_count);

    va_list args;
    va_start(args, children_count);
    for (int i = 0; i < children_count; i++) {
        node->children[i] = va_arg(args, struct AstNode *);
    }
    va_end(args);

    return node;
}

void free_ast_node(struct AstNode *node) {
    for (int i = 0; i < node->children_count; i++) {
        free_ast_node(node->children[i]);
    }
    free(node->children);
    free(node);
}

char *to_string_ast_node_internal(struct AstNode *node, int level) {
    char *result = malloc(sizeof(char) * AST_NODE_STRING_MAX_LENGTH);
    sprintf(result, "%s%s\n", result, AST_NODE_TYPE_STRING[node->type]);
    for (int i = 0; i < node->children_count; i++) {
        for (int j = 0; j < level; j++) {
            sprintf(result, "%s\t", result);
        }
        sprintf(result, "%s%s", result, to_string_ast_node_internal(node->children[i], level + 1));
    }
    result = realloc(result, sizeof(char) * (strlen(result) + 1));
    return result;
}

char *to_string_ast_node(struct AstNode *node) {
    return to_string_ast_node_internal(node, 0);
}

struct AstNode root = {.type = ANT_QUERY};

