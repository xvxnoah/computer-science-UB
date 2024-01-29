#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Sep  8 11:22:03 2022

@author: ignasi
"""
import math
import queue
import time
import random

import chess
import numpy as np
import sys

from itertools import permutations

class Aichess():

    """
    A class to represent the game of chess.

    ...

     Attributes:
    -----------
    chess : Chess
        Represents the current state of the chess game.
    listNextStates : list
        A list to store the next possible states in the game.
    listVisitedStates : list
        A list to store visited states during search.
    pathToTarget : list
        A list to store the path to the target state.
    currentStateW : list
        Represents the current state of the white pieces.
    depthMax : int
        The maximum depth to search in the game tree.
    checkMate : bool
        A boolean indicating whether the game is in a checkmate state.
    dictVisitedStates : dict
        A dictionary to keep track of visited states and their depths.
    dictPath : dict
        A dictionary to reconstruct the path during search.

    Methods:
    --------
    getCurrentState() -> list
        Returns the current state for the whites.

    getListNextStatesW(myState) -> list
        Retrieves a list of possible next states for the white pieces.

    isSameState(a, b) -> bool
        Checks whether two states are the same.

    isVisited(mystate) -> bool
        Checks if a state has been visited.

    isCheckMate(mystate) -> bool
        Checks if a state represents a checkmate.

    DepthFirstSearch(currentState, depth) -> bool
        Depth-first search algorithm.

    worthExploring(state, depth) -> bool
        Checks if a state is worth exploring during search using the optimised DFS algorithm.

    DepthFirstSearchOptimized(currentState, depth) -> bool
        Optimized depth-first search algorithm.

    reconstructPath(state, depth) -> None
        Reconstructs the path to the target state. Updates pathToTarget attribute.

    canviarEstat(start, to) -> None
        Moves a piece from one state to another.

    movePieces(start, depthStart, to, depthTo) -> None
        Moves all pieces between states.

    BreadthFirstSearch(currentState, depth) -> None
        Breadth-first search algorithm.

    h(state) -> int
        Calculates a heuristic value for a state using Manhattan distance.

    AStarSearch(currentState) 
        A* search algorithm -> To be implemented by you

    translate(s) -> tuple
        Translates traditional chess coordinates to list indices.

    """

    def __init__(self, TA, myinit=True):

        if myinit:
            self.chess = chess.Chess(TA, True)
        else:
            self.chess = chess.Chess([], False)

        self.listNextStates = []
        self.listVisitedStates = []
        self.pathToTarget = []
        self.currentStateW = self.chess.boardSim.currentStateW
        self.depthMax = 8
        self.checkMate = False

        # Prepare a dictionary to control the visited state and at which
        # depth they were found
        self.dictVisitedStates = {}
        # Dictionary to reconstruct the BFS path
        self.dictPath = {}

    def getCurrentState(self):
    
        return self.myCurrentStateW

    def getListNextStatesW(self, myState):

        self.chess.boardSim.getListNextStatesW(myState)
        self.listNextStates = self.chess.boardSim.listNextStates.copy()

        return self.listNextStates

    def isSameState(self, a, b):

        isSameState1 = True
        # a and b are lists
        for k in range(len(a)):

            if a[k] not in b:
                isSameState1 = False

        isSameState2 = True
        # a and b are lists
        for k in range(len(b)):

            if b[k] not in a:
                isSameState2 = False

        isSameState = isSameState1 and isSameState2
        return isSameState

    def isVisited(self, mystate):

        if (len(self.listVisitedStates) > 0):
            perm_state = list(permutations(mystate))

            isVisited = False
            for j in range(len(perm_state)):

                for k in range(len(self.listVisitedStates)):

                    if self.isSameState(list(perm_state[j]), self.listVisitedStates[k]):
                        isVisited = True

            return isVisited
        else:
            return False

    def isCheckMate(self, mystate):
        
        # list of possible check mate states
        listCheckMateStates = [[[0,0,2],[2,4,6]],[[0,1,2],[2,4,6]],[[0,2,2],[2,4,6]],[[0,6,2],[2,4,6]],[[0,7,2],[2,4,6]]]

        # Check all state permuations and if they coincide with a list of CheckMates
        for permState in list(permutations(mystate)):
            if list(permState) in listCheckMateStates:
                return True

        return False

    def DepthFirstSearch(self, currentState, depth):
        
        # We visited the node, therefore we add it to the list
        # In DFS, when we add a node to the list of visited, and when we have
        # visited all noes, we eliminate it from the list of visited ones
        self.listVisitedStates.append(currentState)

        # is it checkmate?
        if self.isCheckMate(currentState):
            print("Depth: ", depth)
            self.pathToTarget.append(currentState)
            return True

        if depth + 1 <= self.depthMax:
            for son in self.getListNextStatesW(currentState):
                if not self.isVisited(son):
                    # in the state son, the first piece is the one just moved
                    # We check the position of currentState
                    # matched by the piece moved
                    if son[0][2] == currentState[0][2]:
                        fitxaMoguda = 0
                    else:
                        fitxaMoguda = 1

                    # we move the piece to the new position
                    self.chess.moveSim(currentState[fitxaMoguda],son[0])
                    # We call again the method with the son, 
                    # increasing depth
                    if self.DepthFirstSearch(son,depth+1):
                        #If the method returns True, this means that there has
                        # been a checkmate
                        # We ad the state to the list pathToTarget
                        self.pathToTarget.insert(0,currentState)
                        return True
                    # we reset the board to the previous state
                    self.chess.moveSim(son[0],currentState[fitxaMoguda])

        # We eliminate the node from the list of visited nodes
        # since we explored all successors
        self.listVisitedStates.remove(currentState)

    def worthExploring(self, state, depth):
        # First of all, we check that the depth is bigger than depthMax
        if depth > self.depthMax: return False
        visited = False
        # check if the state has been visited
        for perm in list(permutations(state)):
            permStr = str(perm)
            if permStr in list(self.dictVisitedStates.keys()):
                visited = True
                # If there state has been visited at a epth bigger than 
                # the current one, we are interestted in visiting it again
                if depth < self.dictVisitedStates[perm]:
                    # We update the depth associated to the state
                    self.dictVisitedStates[permStr] = depth
                    return True
        # Whenever not visited, we add it to the dictionary 
        # at the current depth
        if not visited:
            permStr = str(state)
            self.dictVisitedStates[permStr] = depth
            return True

    def DepthFirstSearchOptimized(self, currentState, depth):
        # is it checkmate?
        if self.isCheckMate(currentState):
            print("Depth: ", depth)
            self.pathToTarget.append(currentState)
            return True

        for son in self.getListNextStatesW(currentState):
            if self.worthExploring(son,depth+1):
                
                # in state 'son', the first piece is the one just moved
                # we check which position of currentstate matche
                # the piece just moved
                if son[0][2] == currentState[0][2]:
                    fitxaMoguda = 0
                else:
                    fitxaMoguda = 1

                # we move the piece to the novel position
                self.chess.moveSim(currentState[fitxaMoguda], son[0])
                # we call the method with the son again, increasing depth
                if self.DepthFirstSearchOptimized(son, depth + 1):
                    # If the method returns true, this means there was a checkmate
                    # we add the state to the list pathToTarget
                    self.pathToTarget.insert(0, currentState)
                    return True
                # we return the board to its previous state
                self.chess.moveSim(son[0], currentState[fitxaMoguda])

    def reconstructPath(self, state, depth):
        # When we found the solution, we obtain the path followed to get to this        
        for i in range(depth):
            self.pathToTarget.insert(0,state)
            
            # Convert [[]] to (())
            state = (tuple(state[0]), tuple(state[1]))

            # Per cada node, mirem quin és el seu pare
            state = self.dictPath[state][0]

        self.pathToTarget.insert(0,state)

    # def reconstructPath(self, state, depth):
    #     # When we found the solution, we obtain the path followed to get to this        
    #     for i in range(depth):
    #         self.pathToTarget.insert(0,state)
    #         #Per cada node, mirem quin és el seu pare
    #         state = self.dictPath[str(state)][0]

    #     self.pathToTarget.insert(0,state)

    def canviarEstat(self, start, to):
        # We check which piece has been moved from one state to the next
        if start[0] == to[0]:
            fitxaMogudaStart=1
            fitxaMogudaTo = 1
        elif start[0] == to[1]:
            fitxaMogudaStart = 1
            fitxaMogudaTo = 0
        elif start[1] == to[0]:
            fitxaMogudaStart = 0
            fitxaMogudaTo = 1
        else:
            fitxaMogudaStart = 0
            fitxaMogudaTo = 0
        # move the piece changed
        self.chess.moveSim(start[fitxaMogudaStart], to[fitxaMogudaTo])

    def movePieces(self, start, depthStart, to, depthTo):
        
        # To move from one state to the next for BFS we will need to find
        # the state in common, and then move until the node 'to'
        moveList = []
        # We want that the depths are equal to find a common ancestor
        nodeTo = to
        nodeStart = start
        # if the depth of the node To is larger than that of start, 
        # we pick the ancesters of the node until being at the same
        # depth
        while(depthTo > depthStart):
            moveList.insert(0,to)
            nodeTo = self.dictPath[str(nodeTo)][0]
            depthTo-=1
        # Analogous to the previous case, but we trace back the ancestors
        #until the node 'start'
        while(depthStart > depthTo):
            ancestreStart = self.dictPath[str(nodeStart)][0]
            # We move the piece the the parerent state of nodeStart
            self.canviarEstat(nodeStart, ancestreStart)
            nodeStart = ancestreStart
            depthStart -= 1

        moveList.insert(0,nodeTo)
        # We seek for common node
        while nodeStart != nodeTo:
            ancestreStart = self.dictPath[str(nodeStart)][0]
            # Move the piece the the parerent state of nodeStart
            self.canviarEstat(nodeStart,ancestreStart)
            # pick the parent of nodeTo
            nodeTo = self.dictPath[str(nodeTo)][0]
            # store in the list
            moveList.insert(0,nodeTo)
            nodeStart = ancestreStart
        # Move the pieces from the node in common
        # until the node 'to'
        for i in range(len(moveList)):
            if i < len(moveList) - 1:
                self.canviarEstat(moveList[i],moveList[i+1])

    def BreadthFirstSearch(self, currentState, depth):
        """
        Check mate from currentStateW
        """
        BFSQueue = queue.Queue()
        # The node root has no parent, thus we add None, and -1, which would be the depth of the 'parent node'
        self.dictPath[str(currentState)] = (None, -1)
        depthCurrentState = 0
        BFSQueue.put(currentState)
        self.listVisitedStates.append(currentState)
        # iterate until there is no more candidate nodes
        while BFSQueue.qsize() > 0:
            # Find the optimal configuration
            node = BFSQueue.get()
            depthNode = self.dictPath[str(node)][1] + 1
            if depthNode > self.depthMax:
                break
            # If it not the root node, we move the pieces from the previous to the current state
            if depthNode > 0:
                self.movePieces(currentState, depthCurrentState, node, depthNode)

            if self.isCheckMate(node):
                print("Depth: ", depthNode)
                # Si és checkmate, construïm el camí que hem trobat més òptim
                self.reconstructPath(node, depthNode)
                break

            for son in self.getListNextStatesW(node):
                if not self.isVisited(son):
                    self.listVisitedStates.append(son)
                    BFSQueue.put(son)
                    self.dictPath[str(son)] = (node, depthNode)
            currentState = node
            depthCurrentState = depthNode

    # Check that the order of the pieces is correct (rock first, king second)
    def orderComprovation(self, state):
        if state[0][2] == 6:
            state2 = []
            state2.append(state[1])
            state2.append(state[0])
            state = state2
        return state

    def h(self,state):
        if state[0][2] == 2:
            posicioRei = state[1]
            posicioTorre = state[0]
        else:
            posicioRei = state[0]
            posicioTorre = state[1]

        # With the king we wish to reach configuration (2,4), calculate Manhattan distance
        fila = abs(posicioRei[0] - 2)
        columna = abs(posicioRei[1]-4)

        # Pick the minimum for the row and column, this is when the king has to move in diagonal
        # We calculate the difference between row an colum, to calculate the remaining movements
        # which it should go straight
        hRei = min(fila, columna) + abs(fila-columna)

        # Modification of the heuristic for the king
        # hRei = math.sqrt((posicioRei[0] - 2)**2 + (posicioRei[1] - 4)**2)

        # with the tower we have 3 different cases
        if posicioTorre[0] == 0 and (posicioTorre[1] < 3 or posicioTorre[1] > 5):
            hTorre = 0
        elif posicioTorre[0] != 0 and posicioTorre[1] >= 3 and posicioTorre[1] <= 5:
            hTorre = 2
        else:
            hTorre = 1
        # In our case, the heuristics is the real cost of movements
        return hRei + hTorre

    def AStarSearch(self, currentState):
        
        # We create frontera as a priority queue to store the states to be visited
        frontera = queue.PriorityQueue()

        # We add the current state to the frontier
        frontera.put((self.h(currentState),currentState))

        # We create a set to store the visited states
        visited = set()

        # Set the depth to 0
        depth = 0

        while not frontera.empty():
            # Extract the element with the lowest heuristic
            f, currentState = frontera.get()

            # print("Frontera: ", f)
            # print("Current State: ", currentState)
            currentTuple = (tuple(currentState[0]), tuple(currentState[1]))

            # Check if it is the first iteration
            if depth > 0: 
                # Save the previous state and the depth of the current state used as key
                previousState, actual_depth = aichess.dictPath[currentTuple]
            else:
                # Set the depth to 0 and the previous state as the current because it's the first iteration
                actual_depth = 0
                previousState = currentState
            
            depth += 1

            # Move the table to advance the search
            aichess.canviarEstat(previousState, currentState)

            # Print the current state of the board
            aichess.chess.boardSim.print_board()

            # Check if it's in a checkmate position
            if(self.isCheckMate(currentState)):
                # print("Dict path: ", aichess.dictPath)
                print("Checkmate found!\n")

                # If it's affirmative, call reconstructPath to build the path by performing 'backtracking'
                self.reconstructPath(currentState, actual_depth)

                aichess.listVisitedStates = list(visited)

                return actual_depth

           # If we are not in a checkmate position, we loop to visit all the next states of the current one
            for i in aichess.getListNextStatesW(currentState):

                # Check that the order of the pieces is correct (rock first, king second) 
                # Just to be sure, it should not be necessary
                i = self.orderComprovation(i)

                i_tuple = (tuple(i[0]), tuple(i[1]))

                # Calculate the heuristic value of the current state
                h_i = self.h(i)

                # Check if the state has been visited already and if the new f value is lower
                if i_tuple in visited and f < h_i + aichess.dictPath[i_tuple][1]:
                    continue  # Skip this state as it's already been visited with a lower f value

                # We check if the rook or king is not repeated (possible code errors) and that we don't have
                # the pieces in the same position
                if (i[0][2] != i[1][2]) and (i[0][0] != i[1][0] or i[0][1] != i[1][1]):
                    # Add the current state of the iteration in the visited and frontier list, now it's another frontier
                    visited.add(i_tuple)

                    # Update the f value in the dictPath dictionary
                    aichess.dictPath[i_tuple] = (currentState, actual_depth + 1)

                    frontera.put((h_i + actual_depth, i))

        return False

def translate(s):
    """
    Translates traditional board coordinates of chess into list indices
    """

    try:
        row = int(s[0])
        col = s[1]
        if row < 1 or row > 8:
            print(s[0] + "is not in the range from 1 - 8")
            return None
        if col < 'a' or col > 'h':
            print(s[1] + "is not in the range from a - h")
            return None
        dict = {'a': 0, 'b': 1, 'c': 2, 'd': 3, 'e': 4, 'f': 5, 'g': 6, 'h': 7}
        return (8 - row, dict[col])
    except:
        print(s + "is not in the format '[number][letter]'")
        return None

if __name__ == "__main__":
    start = time.time()
    if len(sys.argv) < 1:
        sys.exit(1)

    # intiialize board
    TA = np.zeros((8, 8))
    # load initial state
    # white pieces
    TA[7][0] = 2
    TA[7][4] = 6
    TA[0][4] = 12

    # Uncomment this part and comment the previous one (not the white king) to test the A* algorithm with a random initial state

    # Randomly place white king and rook on the board
    # white_king_row = random.randint(0, 7)
    # white_king_col = random.randint(0, 7)
    # white_rook_row = random.randint(0, 7)
    # white_rook_col = random.randint(0, 7)

    # # Make sure white king and rook positions are not the same as black king
    # while (white_king_row, white_king_col) == (0, 4) or (white_rook_row, white_rook_col) == (0, 4):
    #     white_king_row = random.randint(0, 7)
    #     white_king_col = random.randint(0, 7)
    #     white_rook_row = random.randint(0, 7)
    #     white_rook_col = random.randint(0, 7)

    # # Set the new positions for white king and rook
    # TA[white_king_row][white_king_col] = 6
    # TA[white_rook_row][white_rook_col] = 2
    
    # initialise bord
    print("\nStarting AI chess... \n")
    aichess = Aichess(TA, True)
    currentState = aichess.chess.board.currentStateW.copy() # currentState is a list of lists
    
    print("----Printing board----")
    aichess.chess.boardSim.print_board()

    # Print current state of the board
    print("\nCurrent State --> ",currentState,"\n")

    # Get list of next states for current state
    print("----Printing next states----\n", aichess.getListNextStatesW(currentState), "\n")
    
    #### A* TEST ####
    depth =  aichess.AStarSearch(currentState)

    if (depth != False):
        print("A* End\n")

        print("A* printing end state")
        aichess.chess.boardSim.print_board()

        print("\n#A* move sequence...  ", aichess.pathToTarget)
        print("\n#A* visited states... ", aichess.listVisitedStates)
        print("\n#A* depth... ", depth, "\n")

        currentState = aichess.chess.board.currentStateW.copy()   
    
    else:
        print("A* End. No checkmate found. \n")

    end = time.time()
    print("Time elapsed A*: ", end - start)

    #### BFS TEST ####
    # start_bfs = time.time()
    # aichess.BreadthFirstSearch(currentState, 0)
    # end_bfs = time.time()
    # print("Time elapsed BFS: ", end_bfs - start_bfs)

    #### DFS TEST ####
    # start_dfs = time.time()
    # aichess.DepthFirstSearch(currentState, 0)
    # end_dfs = time.time()
    # print("Time elapsed DFS: ", end_dfs - start_dfs)

    #### DFS OPTIMIZED TEST ####
    # start_dfs_opt = time.time()
    # aichess.DepthFirstSearchOptimized(currentState, 0)
    # end_dfs_opt = time.time()
    # print("Time elapsed DFS optimized: ", end_dfs_opt - start_dfs_opt)