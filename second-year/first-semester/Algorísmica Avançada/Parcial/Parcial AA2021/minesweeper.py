import random
class MineSweeper:
    def __init__(self, height, width, num_mines, seed=17):        
        self.height = height
        self.width = width
        self.num_mines = num_mines
        self.grid = [[Cell(i,j) for j in range(width)] for i in range(height)]        
        
        random.seed(seed)
        self.set_neighbours()
        self.set_mines()
    
    
    def set_neighbours(self):
        for i in range(self.height):
            for j in range(self.width):
                for idx, idy in [(1,1),(1,-1),(-1,1),(-1,-1),(1,0),(-1,0),(0,1),(0,-1)]:
                    if (0<=i+idx<self.height) and (0<=j+idy<self.width):
                        self.grid[i][j].neighbours.append(self.grid[i+idx][j+idy])
                        
                        
    def set_mines(self):
        candidates = [(i,j) for i in range(self.height) for j in range(self.width)]
        random.shuffle(candidates)
        for cidx in range(self.num_mines):
            mx, my = candidates[cidx]
            self.grid[mx][my].mine = True
            self.grid[mx][my].num = -1
            for nei in self.grid[mx][my].neighbours:
                if not nei.mine:
                    nei.num += 1           
        
    
    def display_grid(self, show_hidden=True):        
        for i in range(self.height):
            print('-'*(4*self.width+1))
            print('| ', end="")
            for j in range(self.width):
                if (not show_hidden and self.grid[i][j].discovered) or (show_hidden):
                    if self.grid[i][j].mine:
                        print(f"\x1b[1m\x1b[31mB\x1b[0m", end=' | ')
                    elif self.grid[i][j].num==0:
                        print(f" ", end=' | ')
                    else:
                        print(f"\x1b[1m\x1b[34m{self.grid[i][j].num}\x1b[0m", end=' | ')
                else:
                    print(f"X", end=' | ')
            print()
        print('-'*(4*self.width+1))

class Cell:
    def __init__(self, x, y, mine=False, num=0):
        self.x = x
        self.y = y
        self.mine = mine
        self.num = num        
        self.neighbours = [] 
        self.discovered = False
        
    def __repr__(self):
        return f"Cell({self.x}, {self.y}, mine={self.mine}, num={self.num})"
