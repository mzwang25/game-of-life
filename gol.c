#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <omp.h>
#include <sys/ioctl.h>

#define LOC(i,j) (((i) % MAX_X) * MAX_Y + ((j) % MAX_Y))

unsigned MAX_X = 0;
unsigned MAX_Y = 0;


void
draw(char* grid)
{
  system("clear");
  for(int i = 0; i < MAX_X; i++)
  {
    for(int j = 0; j < MAX_Y; j++)
    {
      if(grid[LOC(i,j)]) printf("\u2596");
      else printf(".");

    }
    printf("\n");
  }
}

int
nbAlive(char* grid, int x, int y)
{
  return (
      grid[LOC(x+1,y)]
    + grid[LOC(x+1,y+1)]
    + grid[LOC(x,y+1)]
    + grid[LOC(x-1,y+1)]
    + grid[LOC(x-1,y)]
    + grid[LOC(x-1,y-1)]
    + grid[LOC(x,y-1)]
    + grid[LOC(x+1,y-1)]
  );
}

void
update(char* grid, char* swap)
{
  memcpy(swap, grid, MAX_X * MAX_Y);

  #pragma omp parallel for
  for(int i = 0; i < MAX_X; i++)
  {
    for(int j = 0; j < MAX_Y; j++)
    {
      int nbA = nbAlive(swap, i, j);
      if(!grid[LOC(i,j)] && nbA  == 3)
        grid[LOC(i,j)] = 1;
      else if (grid[LOC(i,j)] && (nbA == 2 || nbA == 3))
        grid[LOC(i,j)] = 1;
      else
        grid[LOC(i,j)] = 0;

    }

  }

}

int
main()
{
  struct winsize w;
  ioctl(STDOUT_FILENO, TIOCGWINSZ, &w);

  MAX_X = w.ws_row;
  MAX_Y = w.ws_col;


  char* grid = malloc(MAX_X * MAX_Y);
  char* swap = malloc(MAX_X * MAX_Y);

  bzero(grid, MAX_X * MAX_Y);

  grid[LOC(16,11)] = 1;
  grid[LOC(16,13)] = 1;
  grid[LOC(15,13)] = 1;
  grid[LOC(14,15)] = 1;
  grid[LOC(13,15)] = 1;
  grid[LOC(12,15)] = 1;
  grid[LOC(13,17)] = 1;
  grid[LOC(12,17)] = 1;
  grid[LOC(11,17)] = 1;
  grid[LOC(12,18)] = 1;

  while(1)
  {
    draw(grid);
    update(grid, swap);
    //exit(1);
    usleep(100000);
  }

  return 0;
}

