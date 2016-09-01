all: build/presentation.dvi

build/presentation.dvi: presentation.tex build
	cd build; latex -shell-escape ../presentation.tex; cd ..

build:
	mkdir build

