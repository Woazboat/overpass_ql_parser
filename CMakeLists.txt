cmake_minimum_required(VERSION 3.14)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

project(overpass_ql_parser
        LANGUAGES CXX)

find_package(ANTLR REQUIRED)


add_executable(print_ast)

target_sources(print_ast PRIVATE
    print_ast.cpp)


antlr_target(SampleGrammarLexer TLexer.g4 LEXER
             PACKAGE antlrcpptest)
antlr_target(SampleGrammarParser TParser.g4 PARSER
             PACKAGE antlrcpptest
             DEPENDS_ANTLR SampleGrammarLexer
             COMPILE_FLAGS -lib ${ANTLR_SampleGrammarLexer_OUTPUT_DIR})

target_link_libraries(print_ast PRIVATE
    SampleGrammarLexer
    SampleGrammarParser)
