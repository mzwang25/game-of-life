all: gol-gui gol-tty

gol-gui: gol.ss
	raco exe --gui gol.ss
	mv gol gol-gui
gol-tty: gol.c
	gcc -o gol-tty gol.c -fopenmp

clean:
	rm -rf gol
