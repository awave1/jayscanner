%{
  #include <iostream>
  #include <fstream>
  #include <string>
  #include <map>

  enum {
    T_EOF = 0,
    T_ID,
    T_OP,
    T_SEPARATOR,
    T_STR,
    T_RESERVED,
    T_NUM,
    T_COMMENT
  };

  int linenum = 1;
%}

%option noyywrap

newline \r|\n|\r\n

number [1-9][0-9]+

id ^([a-zA-Z_$]|[\w0-9_$])+

string \"(\\.|[^"\\])*\"

comment \/\/.*

op (\+|-|\*|\/|%|!=?|==?|(>|<)=?|&&|\|\|)

separator (;|\(|\)|\{|\}|\[|\]|,)

reserved (true|false|boolean|int|void|if|else|while|break|return)

%%

[ \t]      ;

{newline}  { linenum++; }
<<EOF>>    { return T_EOF; }
{reserved} { return T_RESERVED; }
{number}   { return T_NUM; }
{string}   { return T_STR; }
{comment}  { return T_COMMENT; }
{separator} { return T_SEPARATOR; }
{op}       { return T_OP; }
{id}       { return T_ID; }

.         {
            std::cerr << "unknown char at line: " << linenum << std::endl;
          }

%%

int main(int argc, char** argv) {
  if (argc != 2 || argv[1] == nullptr) {
    std::cerr << "Missing input file" << std::endl;
    return -1;
  }

  int token;
  std::ifstream fs;
  fs.open(argv[1]);

  FlexLexer* lexer = new yyFlexLexer(&fs, 0);

  // Build map to make readable output of the tokens
  std::map<int, std::string> tokens;
  tokens[T_EOF] = "EOF";
  tokens[T_ID] = "id";
  tokens[T_OP] = "operator";
  tokens[T_SEPARATOR] = "separator";
  tokens[T_STR] = "string";
  tokens[T_RESERVED] = "reserved";
  tokens[T_NUM] = "number";
  tokens[T_COMMENT] = "comment";


  while ((token = lexer->yylex()) != T_EOF) {
    std::cout << linenum << ": id = " << tokens[token] << ", val = " << yytext << std::endl;
  }

  if (token == T_EOF) {
    std::cout << linenum << ": id = " << tokens[token] << ", val = EOF" << std::endl;
  }

  delete lexer;
  return 0;
}
