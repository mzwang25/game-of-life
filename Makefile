all: gol.ss gol.c
	raco exe --gui gol.ss
	mv gol gol-gui
	gcc -o gol-tty gol.c

clean:
	rm -rf gol
