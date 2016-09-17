all: build/presentation.dvi build/notes.dvi

build/presentation.dvi: presentation.tex build
	cd build; latex -shell-escape ../presentation.tex; cd ..

build/notes.dvi: notes.tex build
	cd build; latex -shell-escape ../notes.tex; cd ..

build:
	mkdir build

