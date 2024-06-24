#include <iostream>

#include "TLexer.h"
#include "TParser.h"
#include "antlr4-runtime.h"

using namespace antlrcpptest;
using namespace antlr4;

int main(int, const char **) {

  ANTLRInputStream input(std::cin);
  TLexer lexer(&input);
  CommonTokenStream tokens(&lexer);

  tokens.fill();
  std::cout << "Tokens:\n";
  for (auto token : tokens.getTokens()) {
    std::cout << token->toString() << std::endl;
  }

  TParser parser(&tokens);
  tree::ParseTree *tree = parser.main();

  std::cout << "AST:\n";
  std::cout << tree->toStringTree(&parser, true) << std::endl << std::endl;

  return 0;
}
