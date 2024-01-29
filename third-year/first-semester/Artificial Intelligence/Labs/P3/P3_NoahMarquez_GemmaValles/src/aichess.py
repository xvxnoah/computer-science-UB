#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Sep  8 11:22:03 2022

@author: ignasi
"""
import ast
from collections import defaultdict
from tqdm import tqdm
import copy
import time

import chess as ch
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

    isCheckMate(mystate) -> bool
        Checks if a state represents a checkmate.

    movePieces(start, depthStart, to, depthTo) -> None
        Moves all pieces between states.

    h(state) -> int
        Calculates a heuristic value for a state using Manhattan distance.

    translate(s) -> tuple
        Translates traditional chess coordinates to list indices.

    """

    def __init__(self, TA, White, myinit=True, alpha=0.1, gamma=0.9, epsilon=0.95, episode=100000):
        if myinit:
            self.chess = ch.Chess(TA, True)
        else:
            self.chess = ch.Chess([], False)

        self.whitePlayer = White
        self.whiteTurn = White
        
        self.listNextStates = []

        self.listVisitedStates = []
        self.listVisitedStatesW = []
        self.listVisitedStatesB = []

        self.innitialStateW = self.chess.board.currentStateW
        self.innitialStateB = self.chess.board.currentStateB
        
        self.currentStateW = self.chess.boardSim.currentStateW
        self.currentStateB = self.chess.boardSim.currentStateB

        self.chessStack = [self.chess]

        self.checkMate = False

        self.depthMax = 8

        self.pathToTarget = []
        self.path = defaultdict()
        self.paths = {}
        self.paths['path'] = []
        self.paths['visited'] = []

        # Q-learning 
        self.lr = alpha
        self.gamma = gamma
        self.epsilon = epsilon
        self.episode = episode
        self.qTable = dict()

    def getCurrentState(self):
        if self.whiteTurn:
            return self.currentStateW
        else:
            return self.currentStateB
    
    def getListNextStates(self, myState):
        reOrderedState = self.ensure_order(myState)

        if self.whiteTurn:    
            self.chess.boardSim.getListNextStatesW(reOrderedState)
        else:
            self.chess.boardSim.getListNextStatesB(reOrderedState)

        self.listNextStates = self.chess.boardSim.listNextStates.copy()

        return self.listNextStates

    def isCheckMate(self, mystate):
        '''
        Check if is CheckMate

        @param mystate --> list(): 
            current piece on the chessboard

        @return --> bool:
            return true if is Checkmate otherwise false
        '''

        reOrderedState = self.ensure_order(mystate)

        # Check mate for exercise 1 (the black king is fixed at position [0,4]
        # we put the possible states where check mate occurs
        listCheckMateStates = [[[0,0,2],[2,4,6]],[[0,1,2],[2,4,6]],[[0,2,2],[2,4,6]],[[0,6,2],[2,4,6]],[[0,7,2],[2,4,6]]]

        if reOrderedState in listCheckMateStates:
            return True
        
        return False
        
    def ensure_order(self, state):
        # Ensure the first list in the pair ends with 2
        if state[0][-1] != 2:
            state = [state[1], state[0]]
        return state
        
    def updateActions(self, state):
        '''
        Add to qTable after encountering a new state
        '''
        reOrderedState = self.ensure_order(state)

        if str(reOrderedState) not in self.qTable.keys():    
            self.qTable[str(reOrderedState)] = dict()
            
        nextstatelist = copy.deepcopy(self.getListNextStates(reOrderedState))
        for nextstate in nextstatelist:
            if str(nextstate) not in self.qTable[str(reOrderedState)].keys():
                self.qTable[str(reOrderedState)][str(nextstate)] = 0

    def chooseAction(self, state, drunk_sailor=False, stochasticity_rate=0.8):
        '''
        Select Action from qTable based on state
        '''

        # Determine whether the state exists in the qtable
        self.updateActions(state)
        nextstatelist = self.getListNextStates(state)

        # Choose an action to take  
        # According to the probability of epsilon, select according to the best in qTable
        if drunk_sailor:
            if np.random.uniform() < stochasticity_rate:
                # Intended action - choose according to the Q-learning policy
                if np.random.uniform() < self.epsilon:
                    stateActionList = self.qTable[str(state)]
                    max_list = []
                    max_value = max(stateActionList.values())
                    for k, v in stateActionList.items():
                        if v == max_value:
                            max_list.append(k)
                    action = np.random.choice(max_list)
                else:
                    choicelist = []
                    for nextstate in nextstatelist:
                        choicelist.append(str(nextstate))
                    action = np.random.choice(choicelist)
            else:
                # Random action - not the intended one
                choicelist = [str(nextstate) for nextstate in nextstatelist if str(nextstate) != str(state)]
                action = np.random.choice(choicelist)

            return ast.literal_eval(action)
        
        else:
            if np.random.uniform() < self.epsilon:
                stateActionList = self.qTable[str(state)]
                max_list = []
                max_value = max(stateActionList.values())
                for k, v in stateActionList.items():
                    if v == max_value:
                        max_list.append(k)
                action = np.random.choice(max_list)
            else:
                choicelist = []
                for nextstate in nextstatelist:
                    choicelist.append(str(nextstate))
                action = np.random.choice(choicelist)

            return ast.literal_eval(action)
    
    def feelBack(self, state, action, heuristic=False):
        '''
        Return the next state and current reward according to State and action
        '''
        nextstate = action
        if self.isCheckMate(state):
            reward = 100
        else:
            if heuristic:
                # Use heuristic function to calculate a penalty based on the distance
                # from the goal state. The farther away, the larger the penalty.
                reward = -1 * self.h(nextstate)
            else:
                reward = -1
        return nextstate, reward
    
    def updateTable(self, state, action, nextState, reward):
        '''
        Update qtable according to current state, action, next state, reward
        '''
        # Determine whether the state exists in the qtable
        self.updateActions(nextState)

        # current state value
        qPredict = self.qTable[str(state)][str(action)]

        # next state value
        if self.isCheckMate(nextState):
            qTarget = reward
        else:
            qTarget = reward + self.gamma * max(self.qTable[str(nextState)].values())
        
        # update qTable
        self.qTable[str(state)][str(action)] += self.lr * (qTarget - qPredict)

    def filterCheckMateStates(self, qTable, checkMateStates):
        '''
        Filter the qTable to keep only the states that have actions leading to check-mate states
        '''
        filteredQTable = {}
        for state, actions in qTable.items():
            for action, value in actions.items():
                if eval(action) in checkMateStates:
                    if state not in filteredQTable:
                        filteredQTable[state] = {}
                    filteredQTable[state][action] = value
        return filteredQTable
        
    def Q_Learning(self, heuristic=False, drunk_sailor=False, stochasticity_rate=0.8):
        convergence_threshold = 0.00001

        self.listNextStates = self.getListNextStates(self.currentStateW)
        self.updateActions(self.currentStateW)

        result = []

        print_episodes = [0, 500, 1000]
        checkMateStates = [[[0,0,2],[2,4,6]],[[0,1,2],[2,4,6]],[[0,2,2],[2,4,6]],
                       [[0,6,2],[2,4,6]],[[0,7,2],[2,4,6]]]

        for episode in tqdm(range(self.episode)):
            total_difference = 0

            # Set the initial state
            state = self.innitialStateW

            actionSrc = ""

            # if episode in print_episodes:
            #     filteredQTable = self.filterCheckMateStates(self.qTable, checkMateStates)
            #     print(f"\n\nQ-Table at episode {episode}:")
            #     print(filteredQTable)

            while True:
                reOrderedState = self.ensure_order(state)

                # choose action
                action = self.chooseAction(reOrderedState, drunk_sailor, stochasticity_rate)
                
                actionSrc += str(reOrderedState) + " -> "
                result.append(reOrderedState)

                old_value = self.qTable[str(reOrderedState)][str(action)]

                # get state and reward
                nextState, reward = self.feelBack(reOrderedState, action, heuristic)

                # if nextState in checkMateStates:
                #     reward = 100

                reOrderedNewState = self.ensure_order(nextState)

                # update qTable
                self.updateTable(reOrderedState, action, reOrderedNewState, reward)

                total_difference += abs(self.qTable[str(reOrderedState)][str(action)] - old_value)

                # update state
                state = reOrderedNewState

                # Termination condition
                if self.isCheckMate(action):
                    break
            
            if total_difference < convergence_threshold:
                print("\n========================================")
                print(f"Convergence achieved at episode {episode}")
                print("========================================\n")

                # filteredQTable = self.filterCheckMateStates(self.qTable, checkMateStates)
                # print(f"\n\nQ-Table at episode {episode}:")
                # print(filteredQTable)

                reOrderedState = self.ensure_order(state)
                actionSrc += str(reOrderedState) + ".\n"
                result.append(state)

                print("The path is: ")
                print(actionSrc)

                return result
            
            else:
                result = []

        print("\n\n========================================")
        print(f"NO CONVERGENCE achieved after {episode} episodes.")
        print("========================================\n")

        # filteredQTable = self.filterCheckMateStates(self.qTable, checkMateStates)
        # print(f"\n\nQ-Table at episode {episode}:")
        # print(filteredQTable)

        reOrderedState = self.ensure_order(state)
        actionSrc += str(reOrderedState) + ".\n"
        result.append(state)

        print("The path is: ")
        print(actionSrc)

        return result
    
    def chess_a(TA):
        # Q-learning parameters
        alpha = 0.5 # Learning rate
        gamma = 0.8 # Discount factor
        epsilon = 0.95 # Exploration rate
        episode = 100000 # Number of episodes

        use_heuristic = False

        chess = ch.Chess(TA)

        # Initialise the board and Aichess with the parameters
        print("\nStarting AI chess... \n")
        whiteAichess = Aichess(TA, True, True, alpha, gamma, epsilon, episode)

        print("----Printing board----")
        chess.boardSim.print_board()

        # Print current state of the board
        currentState = chess.board.currentStateW.copy() # currentState is a list of lists
        print("\nCurrent State --> ", currentState,"\n")

        start = time.time()
        path = whiteAichess.Q_Learning(use_heuristic)
        end = time.time()

        elapsed_time = end - start
        minutes = int(elapsed_time // 60)
        seconds = int(elapsed_time % 60)
        print("Time elapsed: {} minutes {} seconds".format(minutes, seconds))
        print("Number of steps: ", len(path)-1)
        print()

        # Run the path generated by Q-learning
        startState = path[0]
        path = path[1:]
        for nextState in path:
            Aichess.movePiece(whiteAichess, startState, nextState)
            startState = nextState
            whiteAichess.chess.board.print_board()

    def chess_b(TA):
        # Q-learning parameters
        alpha = 0.5 # Learning rate
        gamma = 0.9 # Discount factor
        epsilon = 0.95 # Exploration rate
        episode = 100000 # Number of episodes

        use_heuristic = True

        chess = ch.Chess(TA)

        # Initialise the board and Aichess with the parameters
        print("\nStarting AI chess... \n")
        whiteAichess = Aichess(TA, True, True, alpha, gamma, epsilon, episode)

        print("----Printing board----")
        chess.boardSim.print_board()

        # Print current state of the board
        currentState = chess.board.currentStateW.copy() # currentState is a list of lists
        print("\nCurrent State --> ", currentState,"\n")

        start = time.time()
        path = whiteAichess.Q_Learning(use_heuristic)
        end = time.time()

        elapsed_time = end - start
        minutes = int(elapsed_time // 60)
        seconds = int(elapsed_time % 60)
        print("Time elapsed: {} minutes {} seconds".format(minutes, seconds))
        print("Number of steps: ", len(path)-1)
        print()

        # Run the path generated by Q-learning
        startState = path[0]
        path = path[1:]
        for nextState in path:
            Aichess.movePiece(whiteAichess, startState, nextState)
            startState = nextState
            whiteAichess.chess.board.print_board()

    def chess_c(TA):
        # Q-learning parameters
        alpha = 0.5 # Learning rate
        gamma = 0.9 # Discount factor
        epsilon = 0.95 # Exploration rate
        episode = 100000 # Number of episodes

        use_heuristic = True
        stochasticity_rate = 0.95

        chess = ch.Chess(TA)

        # Initialise the board and Aichess with the parameters
        print("\nStarting AI chess... \n")
        whiteAichess = Aichess(TA, True, True, alpha, gamma, epsilon, episode)

        print("----Printing board----")
        chess.boardSim.print_board()

        # Print current state of the board
        currentState = chess.board.currentStateW.copy() # currentState is a list of lists
        print("\nCurrent State --> ", currentState,"\n")

        start = time.time()
        path = whiteAichess.Q_Learning(use_heuristic, drunk_sailor=True, stochasticity_rate=stochasticity_rate)
        end = time.time()

        elapsed_time = end - start
        minutes = int(elapsed_time // 60)
        seconds = int(elapsed_time % 60)
        print("Time elapsed: {} minutes {} seconds".format(minutes, seconds))
        print("Number of steps: ", len(path)-1)
        print()

        # Run the path generated by Q-learning
        startState = path[0]
        path = path[1:]
        for nextState in path:
            Aichess.movePiece(whiteAichess, startState, nextState)
            startState = nextState
            whiteAichess.chess.board.print_board()

    def chess_d(TA):
        # Q-learning parameters
        alpha = 0.5 # Learning rate
        gamma = 0.9 # Discount factor
        epsilon = 0.95 # Exploration rate
        episode = 100000 # Number of episodes

        use_heuristic = True
        stochasticity_rate = 0.85

        chess = ch.Chess(TA)

        # Initialise the board and Aichess with the parameters
        print("\nStarting AI chess... \n")
        whiteAichess = Aichess(TA, True, True, alpha, gamma, epsilon, episode)

        print("----Printing board----")
        chess.boardSim.print_board()

        # Print current state of the board
        currentState = chess.board.currentStateW.copy() # currentState is a list of lists
        print("\nCurrent State --> ", currentState,"\n")

        start = time.time()
        path = whiteAichess.Q_Learning(use_heuristic, drunk_sailor=True, stochasticity_rate=stochasticity_rate)
        end = time.time()

        elapsed_time = end - start
        minutes = int(elapsed_time // 60)
        seconds = int(elapsed_time % 60)
        print("Time elapsed: {} minutes {} seconds".format(minutes, seconds))
        print("Number of steps: ", len(path)-1)
        print()

        # Run the path generated by Q-learning
        startState = path[0]
        path = path[1:]
        for nextState in path:
            Aichess.movePiece(whiteAichess, startState, nextState)
            startState = nextState
            whiteAichess.chess.board.print_board()

    def movePiece(aichess, currentState, nextState):
        start = [e for e in currentState if e not in nextState][0][0:2]
        to = [e for e in nextState if e not in currentState][0][0:2]
        aichess.chess.move(start, to)
        return

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
    if len(sys.argv) < 1:
        sys.exit(1)

    board_size = (8, 8)

    # Intialize board
    TA = np.zeros(board_size)

    # Load initial state
    TA[7][0] = 2 # White rook
    TA[7][4] = 6 # White king
    TA[0][4] = 12 # Black king

    ##########
    # CHESS Q-TABLE
    # Print only 4 rows per table, corresponding to states near check make so that Q-values are easy to check
    ##########

    #### Section 1: Adapt your Q-learning implementation to find the optimal path to a check mate
    #### considering a reward of -1 everywhere except for the goal (check mate for the
    #### whites), with reward 100.

    print()
    print("+" + "-" * 10 + " SECTION 1 " + "-" * 10 + "+")
    Aichess.chess_a(TA)

    #### Section 2: Try now with a more sensible reward function adapted from the heuristic used
    #### for the A* search.

    print()
    print()

    # Intialize board
    TA = np.zeros(board_size)

    # Load initial state
    TA[7][0] = 2 # White rook
    TA[7][4] = 6 # White king
    TA[0][4] = 12 # Black king

    print("+" + "-" * 10 + " SECTION 2 " + "-" * 10 + "+")
    Aichess.chess_b(TA)

    #### Section 3: Drunken sailor. White and Black play.

    print()
    print()

    # Intialize board
    TA = np.zeros(board_size)

    # Load initial state
    TA[7][0] = 2 # White rook
    TA[7][4] = 6 # White king

    TA[0][4] = 12 # Black king

    print("+" + "-" * 10 + " SECTION 3 " + "-" * 10 + "+")
    Aichess.chess_c(TA)

    #### +1 point section

    print()
    print()

    # Intialize board
    TA = np.zeros(board_size)

    # Load initial state
    TA[7][0] = 2 # White rook
    TA[7][7] = 6 # White king (second board configuration of P1)

    TA[0][4] = 12 # Black king

    print("+" + "-" * 10 + " EXTRA SECTION " + "-" * 10 + "+")
    Aichess.chess_d(TA)


    
    