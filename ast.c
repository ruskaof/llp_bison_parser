//
// Created by ruskaof on 11/12/23.
//

#include "ast.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <stdbool.h>

#define AST_NODE_STRING_MAX_LENGTH 1024


struct AstNode *create_bool_literal_ast_node(bool value) {
    struct AstNode *node = malloc(sizeof(struct AstNode));
    node->type = ANT_BOOLEAN;
    node->value.bool_value = value;
    node->children_count = 0;
    node->children = NULL;
    return node;
}

struct AstNode *create_int_literal_ast_node(int value) {
    struct AstNode *node = malloc(sizeof(struct AstNode));
    node->type = ANT_INTEGER;
    node->value.int_value = value;
    node->children_count = 0;
    node->children = NULL;
    return node;
}

struct AstNode *create_double_literal_ast_node(float value) {
    struct AstNode *node = malloc(sizeof(struct AstNode));
    node->type = ANT_DOUBLE;
    node->value.float_value = value;
    node->children_count = 0;
    node->children = NULL;
    return node;
}

struct AstNode *create_string_literal_ast_node(char *value) {
    struct AstNode *node = malloc(sizeof(struct AstNode));
    node->type = ANT_STRING;
    node->value.string_value = value;
    node->children_count = 0;
    node->children = NULL;
    return node;
}

struct AstNode *create_identifier_ast_node(char *value) {
    struct AstNode *node = malloc(sizeof(struct AstNode));
    node->type = ANT_IDENTIFIER;
    node->value.string_value = value;
    node->children_count = 0;
    node->children = NULL;
    return node;
}

struct AstNode *create_ast_node(enum AstNodeType type, size_t children_count, ...) {
    struct AstNode *node = malloc(sizeof(struct AstNode));
    node->type = type;
    node->children_count = children_count;
    node->children = malloc(sizeof(struct AstNode *) * children_count);

    va_list args;
    va_start(args, children_count);
    for (size_t i = 0; i < children_count; i++) {
        node->children[i] = va_arg(args, struct AstNode *);
    }
    va_end(args);

    return node;
}

struct AstNode *root = NULL;

void set_root_ast_node(struct AstNode *root_to_set) {
    root = root_to_set;
}

void print_ast_node_internal(struct AstNode *node, int level) {
    if (node == NULL) {
        printf("NULL\n");
        return;
    }

    char *indent = malloc(sizeof(char) * (level + 1));
    for (int i = 0; i < level; i++) {
        indent[i] = '\t';
    }
    indent[level] = '\0';

    char *value = malloc(sizeof(char) * AST_NODE_STRING_MAX_LENGTH);
    switch (node->type) {
        case ANT_BOOLEAN:
            sprintf(value, "%s", node->value.bool_value ? "true" : "false");
            break;
        case ANT_INTEGER:
            sprintf(value, "%d", node->value.int_value);
            break;
        case ANT_DOUBLE:
            sprintf(value, "%f", node->value.float_value);
            break;
        case ANT_STRING:
            sprintf(value, "\'%s\'", node->value.string_value);
            break;
        case ANT_IDENTIFIER:
            sprintf(value, "%s", node->value.string_value);
            break;
        default:
            sprintf(value, "%s", AstNodeTypeString[node->type]);
            break;
    }

    printf("%s%s\n", indent, value);

    for (size_t i = 0; i < node->children_count; i++) {
        print_ast_node_internal(node->children[i], level + 1);
    }

    free(indent);
    free(value);
}

void print_ast_node(struct AstNode *node) {
    print_ast_node_internal(node, 0);
}

struct AstNode *get_root_ast_node() {
    return root;
}

void free_ast_node(struct AstNode *node) {
    if (node == NULL) {
        return;
    }

    if (node->children_count > 0) {
        for (size_t i = 0; i < node->children_count; i++) {
            free_ast_node(node->children[i]);
        }
        free(node->children);
    }
    free(node);
}

