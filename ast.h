//
// Created by ruskaof on 11/12/23.
//

#ifndef LLP_BISON_PARSER_AST_H
#define LLP_BISON_PARSER_AST_H

#include <stddef.h>
#include <stdbool.h>

#include "ast_node_type.h"

struct AstNode {
    enum AstNodeType type;
    union {
        char *string_value;
        int int_value;
        float float_value;
        bool bool_value;
    } value;
    size_t children_count;
    struct AstNode **children;
};

struct AstNode *create_bool_literal_ast_node(bool value);

struct AstNode *create_int_literal_ast_node(int value);

struct AstNode *create_double_literal_ast_node(float value);

struct AstNode *create_string_literal_ast_node(char *value);

struct AstNode *create_identifier_ast_node(char *value);

struct AstNode *create_ast_node(enum AstNodeType type, size_t children_count, ...);

struct AstNode *create_empty_ast_node(enum AstNodeType type);

void set_root_ast_node(struct AstNode *root_to_set);

struct AstNode *get_root_ast_node();

void free_ast_node(struct AstNode *node);

void print_ast_node(struct AstNode *node);

#endif //LLP_BISON_PARSER_AST_H
