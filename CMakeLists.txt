cmake_minimum_required(VERSION 3.14)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

project(overpass_ql_parser
        LANGUAGES CXX)

# set(ANTLR4_JAR_LOCATION "/usr/share/java/antlr4.jar")

find_package(ANTLR REQUIRED)


add_executable(${PROJECT_NAME})

target_sources(${PROJECT_NAME} PRIVATE
    main.cpp)


antlr_target(SampleGrammarLexer TLexer.g4 LEXER
             PACKAGE antlrcpptest)
antlr_target(SampleGrammarParser TParser.g4 PARSER
             PACKAGE antlrcpptest
             DEPENDS_ANTLR SampleGrammarLexer
             COMPILE_FLAGS -lib ${ANTLR_SampleGrammarLexer_OUTPUT_DIR})

target_link_libraries(${PROJECT_NAME} PRIVATE
    SampleGrammarLexer
    SampleGrammarParser)
