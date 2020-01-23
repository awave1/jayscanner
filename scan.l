%{
  #include <iostream>
  #include <fstream>
%}

%option noyywrap
%option c++

%%

a   { std::cout << "found 'a'" << std::endl; }
b   { std::cout << "found 'b'" << std::endl; }
^#  {
      int ch;
      while ((ch = yyinput()) != EOF && ch != '\n') {}
    }

%%

int main(int argc, char **argv) {
  std::ifstream fs;

  fs.open(argv[1]);

  // read from file and fallback to stdin/stdout
  FlexLexer* lexer = new yyFlexLexer(&fs, 0);
  lexer->yylex();

  delete lexer;
  return 0;
}

