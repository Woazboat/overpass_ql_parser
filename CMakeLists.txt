cmake_minimum_required(VERSION 3.14)

project(overpass_ql_parser
        LANGUAGES CXX)

# find_package(antlr4-generator REQUIRED)


add_executable(${PROJECT_NAME})

target_sources(${PROJECT_NAME} PRIVATE
    main.cpp)

# antlr4_generate(
#     antlrcpptest_parser
#     ${CMAKE_CURRENT_SOURCE_DIR}/TLexer.g4
#     LEXER
#     FALSE
#     TRUE
#     "antlrcpptest"
#     )
