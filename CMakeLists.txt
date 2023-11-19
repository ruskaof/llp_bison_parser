cmake_minimum_required(VERSION 3.22)
project(llp_bison_parser C)

set(CMAKE_C_STANDARD 17)

# Find Bison and Flex
find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

# Specify the input files for Bison and Flex
set(BISON_INPUT_FILE parser.y)
set(FLEX_INPUT_FILE lexer.l)

# Generate lexer and parser source files
BISON_TARGET(MyParser ${BISON_INPUT_FILE} ${CMAKE_CURRENT_BINARY_DIR}/parser.c)
FLEX_TARGET(MyLexer ${FLEX_INPUT_FILE} ${CMAKE_CURRENT_BINARY_DIR}/lexer.c)
ADD_FLEX_BISON_DEPENDENCY(MyLexer MyParser)

# Add the executable target and include generated source files
add_executable(llp_bison_parser main.c ${BISON_MyParser_OUTPUTS} ${FLEX_MyLexer_OUTPUTS}
        ast.c
        ast.h
        ast_node_type.h)