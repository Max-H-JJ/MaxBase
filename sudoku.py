digits = colums = '123456789'
rows = 'ABCDEFGHI'
# ---------------------------------------------------------------#
# initilization of peers, units and square                       #
# ---------------------------------------------------------------#

def cross(A,B): # function to initialize cross multiplication
    result = []
    for a in A:
        for b in B:
           result.append(a+b) 
    return result

squares = cross(rows,colums) #output correct
box_unit = list(cross(r,c) for r in ('ABC','DEF','GHI') for c in ('123','456','789'))#output correct
colum_unit= list(cross(rows,c) for c in colums)#output correctW
row_unit= list(cross(r,colums) for r in rows)#output correct
unit_list = row_unit + box_unit +colum_unit

#associate the units with related suqare in dictionary form
suqare_unit = {}
for square in squares:#traverse all the squares
    suqare_unit.setdefault(square,[]) #initialzie the key-value pairs in empty dictionary
    for unit in unit_list:#traverse all the squares in unit_list
        if square in unit:#
            if square not in unit:
                suqare_unit[square] = {}
            suqare_unit[square].append(unit)
#square_unit output correctly

#associate the peers wiht related square in dictionary form
square_peers={}
for square in squares:
    peer = set()#create a new set to stor related peers for each square
    for u in suqare_unit[square]:#traverse relared unit for a certain square 's' 
        for n in u:# traverse all the elements in u
            if n != square:#abandon the square itself
                peer.add(n) # add the reset units into the peers set
    square_peers[square] = peer # combine the peers set with related square
#output correctly

def test():
    "A set of unit tests."
    assert len(squares) == 81
    assert len(unit_list) == 27
    assert all(len(suqare_unit[s]) == 3 for s in squares)
    assert all(len(square_peers[s]) == 20 for s in squares)
    print ('All tests pass.')


#--------------------------------------------#
# define functions to display the whole grid #
#--------------------------------------------#
#------------------------------------------------------------------------------------#
# constrain propagration & local search  to find a general way to solve sudoku puzzle#
#------------------------------------------------------------------------------------#

# function to eliminate a value 'num' form related square 's' in a given grid dictionary 'grid', where store the relfection of all values and squares
def elimination(grid,s,num):
# if a square 's' only left 'sum', then eliminate it from its peers
    if num not in grid[s]: # if num has already been abandoned
        return grid
    grid[s].replace(num,'') #eliminate num form corresponding square
    if len(grid[s]) == 0: #check the rest values
        return False
    elif len(grid[s]) == 1: # if only one num left after elimination
        num2 = grid[s]
        for s2 in square_peers[s]:
            elimination(grid, s2, num2) # eliminate num2 from s2's peers          
#if a unit only have one possible place for a value, put the value there
    places = []
    for unit in suqare_unit[s]:#traverse all the units of 's'
        for square in unit: 
            if num in grid[square]: # if d is a potential num for a square of unit
                places.append(square)
        if len(places) == 0:
            return False
        elif len(places) ==1:# if there is only one possible place for "num", assign 'num'to this square
            assign(grid,places[0],num)
    return grid

# function to "assign" a value "num" to a certain square
def assign(grid,s,num): # assigning a value means eliminate all values from 's' except "num"
    temp_num = grid[s].replace(num,'')
    for d in temp_num:
        elimination(grid,s,d) #eliminate other values from 's'
    return grid


grid = '003020600900305001001806400008102900700000008006708200002609500800203009005010300'

# function to combine squares and values in dictonary form
def grid_values1(grid):
    point_grid= {} #initialize an empty dictionary
    value_list = []
    values = dict((s, digits) for s in squares)
    for v in grid: #extract the values in each squares
        if v in ".0" or v in digits:
            if v in ".0": #replace . and 0 by digits
                v = digits
            value_list.append(v)
    for k, v in zip(squares,value_list): #initialize values into related square
        point_grid[k] = v  
    for s,d in point_grid.items():
        if d in digits:
            elimination(point_grid,s,d)
    return point_grid #output correctly
print(grid_values1(grid))