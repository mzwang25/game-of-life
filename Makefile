all: gol.ss
	raco exe --gui gol.ss  

clean:
	rm -rf gol
