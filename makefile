CXX = clang++
CXXFLAGS = -Wno-deprecated-register -Wall
CXXSTD = -std=c++14

scanner:
	flex++ scan.l

build: scanner
	$(CXX) $(CXXSTD) $(CXXFLAGS) -ll lex.yy.cc -o scanner

run: build
	./scanner

clear:
	rm lex.yy.cc scanner

clean: clear
