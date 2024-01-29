#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Sep  8 11:22:03 2022

@author: ignasi
"""
import copy
import math
import random

import chess
import board
import numpy as np
import sys
import queue
import time
from typing import List
import csv

RawStateType = List[List[List[int]]]

from itertools import permutations

class Aichess():
    """
    A class to represent the game of chess.

    ...

    Attributes:
    -----------
    chess : Chess
        represents the chess game

    Methods:
    --------
    startGame(pos:stup) -> None
        Promotes a pawn that has reached the other side to another, or the same, piece

    """
    POS_INF = 99999
    NEG_INF = -99999

    BLACK_KING = 12
    BLACK_ROOK = 8
    WHITE_KING = 6
    WHITE_ROOK = 2

    WHITES_TURN = False
    BLACKS_TURN = False

    def __init__(self, TA, myinit=True):

        if myinit:
            self.chess = chess.Chess(TA, True)
        else:
            self.chess = chess.Chess([], False)

        self.listNextStates = []

        self.listVisitedStates = []

        self.listVisitedSituations = [] # set????
        self.pathToTarget = []
        self.currentStateW = self.chess.boardSim.currentStateW
        self.depthMax = 8
        # self.checkMate = False

    def copyState(self, state):
        copyState = []
        for piece in state:
            copyState.append(piece.copy())
        return copyState
        
    def isVisitedSituation(self, color, mystate):
        if (len(self.listVisitedSituations) > 0):
            perm_state = list(permutations(mystate))

            isVisited = False
            for j in range(len(perm_state)):

                for k in range(len(self.listVisitedSituations)):
                    if self.isSameState(list(perm_state[j]), self.listVisitedSituations.__getitem__(k)[1]) and color == \
                            self.listVisitedSituations.__getitem__(k)[0]:
                        isVisited = True

            return isVisited
        else:
            return False

    def getCurrentStateW(self):
        return self.myCurrentStateW

    def getListNextStatesW(self, myState):
        self.chess.boardSim.getListNextStatesW(myState)
        self.listNextStates = self.chess.boardSim.listNextStates.copy()

        return self.listNextStates

    def getListNextStatesB(self, myState):
        self.chess.boardSim.getListNextStatesB(myState)
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
    
    def isWatched(self, currentState, color=None):
        if color is None:
            self.newBoardSim(currentState)
            
            if self.BLACKS_TURN:
                kingState = self.getPieceState(currentState, self.BLACK_KING)[0:2]
                opponentKingState = self.getPieceState(currentState, self.WHITE_KING)
                opponentRookState = self.getPieceState(currentState, self.WHITE_ROOK)
            else:
                kingState = self.getPieceState(currentState, self.WHITE_KING)[0:2]
                opponentKingState = self.getPieceState(currentState, self.BLACK_KING)
                opponentRookState = self.getPieceState(currentState, self.BLACK_ROOK)

            # Si blanques o negres maten al rei contrari, no és una configuració correcta
            if opponentKingState == None:
                return False
            
            # Mirem les possibles posicions del rei i mirem si en alguna pot "matar" a l'altre rei
            for oppKingPosition in self.getNextPositions(opponentKingState):
                if kingState == oppKingPosition:
                    # Tindríem un check
                    return True

            if opponentRookState != None:
                # Mirem les possibles posicions de la torre i mirem si en alguna pot "matar" al rei
                for oppRookPosition in self.getNextPositions(opponentRookState):
                    if kingState == oppRookPosition:
                        return True

            return False
        else:
            self.newBoardSim(currentState)
            if color:
                kingState = self.getPieceState(currentState, self.WHITE_KING)[0:2]
                opponentKingState = self.getPieceState(currentState, self.BLACK_KING)
                opponentRookState = self.getPieceState(currentState, self.BLACK_ROOK)

                # Si blanques maten al rei contrari, no és una configuració correcta
                if opponentKingState == None:
                    return False
                
                # Mirem les possibles posicions del rei i mirem si en alguna pot "matar" a l'altre rei
                for oppKingPosition in self.getNextPositions(opponentKingState):
                    if kingState == oppKingPosition:
                        # Tindríem un check
                        return True
                    
                if opponentRookState != None:
                    # Mirem les possibles posicions de la torre i mirem si en alguna pot "matar" al rei
                    for oppRookPosition in self.getNextPositions(opponentRookState):
                        if kingState == oppRookPosition:
                            return True
                
                return False
            else:
                kingState = self.getPieceState(currentState, self.BLACK_KING)[0:2]
                opponentKingState = self.getPieceState(currentState, self.WHITE_KING)
                opponentRookState = self.getPieceState(currentState, self.WHITE_ROOK)

                # Si negres maten al rei contrari, no és una configuració correcta
                if opponentKingState == None:
                    return False
                
                # Mirem les possibles posicions del rei i mirem si en alguna pot "matar" a l'altre rei
                for oppKingPosition in self.getNextPositions(opponentKingState):
                    if kingState == oppKingPosition:
                        # Tindríem un check
                        return True
                    
                if opponentRookState != None:
                    # Mirem les possibles posicions de la torre i mirem si en alguna pot "matar" al rei
                    for oppRookPosition in self.getNextPositions(opponentRookState):
                        if kingState == oppRookPosition:
                            return True
                        
                return False

    def movesThreatened(self, currentState, color=None):
        if color is None:
            self.newBoardSim(currentState)
            
            # Només considerem la posició del rei actual, i la torre contraria
            if self.BLACKS_TURN:
                kingState = self.getPieceState(currentState, self.BLACK_KING)[0:2]
                opponentRookState = self.getPieceState(currentState, self.WHITE_ROOK)
                getNextStatesFunc = self.getListNextStatesB
                opponentStateFunc = self.getWhiteState
                getState = self.getBlackState
            else:
                kingState = self.getPieceState(currentState, self.WHITE_KING)[0:2]
                opponentRookState = self.getPieceState(currentState, self.BLACK_ROOK)
                getNextStatesFunc = self.getListNextStatesW
                opponentStateFunc = self.getBlackState
                getState = self.getWhiteState
            
            allChecked = False

            # És important comprovar si el rei està situat a una paret, ja que és una situació que determina
            # un estat d'amenaça
            if kingState[0] in [0, 7] or kingState[1] in [0, 7]:
                otherColorState = opponentStateFunc(currentState)

                allChecked = True
                nextStates = getNextStatesFunc(getState(currentState))

                for state in nextStates:
                    newState = otherColorState.copy()

                    # Comprovar si la torre contraria ha estat eliminada, en aquest cas, eliminar-la de l'estat
                    if opponentRookState != None and opponentRookState[0:2] == state[0][0:2]:
                        newState.remove(opponentRookState)

                    state = state + newState

                    # Moure les peces a l'estat nou
                    self.newBoardSim(state)

                    # Està el rei amenaçat o no?
                    if not self.isWatched(state):
                        allChecked = False
                        break
            
            self.newBoardSim(currentState)

            return allChecked
        else:
            self.newBoardSim(currentState)
            if color:
                kingState = self.getPieceState(currentState, self.WHITE_KING)[0:2]
                opponentRookState = self.getPieceState(currentState, self.BLACK_ROOK)
                getNextStatesFunc = self.getListNextStatesW
                opponentStateFunc = self.getBlackState
                getState = self.getWhiteState

                allChecked = False

                # És important comprovar si el rei està situat a una paret, ja que és una situació que determina
                # un estat d'amenaça
                if kingState[0] in [0, 7] or kingState[1] in [0, 7]:
                    otherColorState = opponentStateFunc(currentState)

                    allChecked = True
                    nextStates = getNextStatesFunc(getState(currentState))

                    for state in nextStates:
                        newState = otherColorState.copy()

                        # Comprovar si la torre contraria ha estat eliminada, en aquest cas, eliminar-la de l'estat
                        if opponentRookState != None and opponentRookState[0:2] == state[0][0:2]:
                            newState.remove(opponentRookState)

                        state = state + newState

                        # Moure les peces a l'estat nou
                        self.newBoardSim(state)

                        # Està el rei amenaçat o no?
                        if not self.isWatched(state, color):
                            allChecked = False
                            break
                
                self.newBoardSim(currentState)

                return allChecked
            else:
                kingState = self.getPieceState(currentState, self.BLACK_KING)[0:2]
                opponentRookState = self.getPieceState(currentState, self.WHITE_ROOK)
                getNextStatesFunc = self.getListNextStatesB
                opponentStateFunc = self.getWhiteState
                getState = self.getBlackState

                allChecked = False

                # És important comprovar si el rei està situat a una paret, ja que és una situació que determina
                # un estat d'amenaça
                if kingState[0] in [0, 7] or kingState[1] in [0, 7]:
                    otherColorState = opponentStateFunc(currentState)

                    allChecked = True
                    nextStates = getNextStatesFunc(getState(currentState))

                    for state in nextStates:
                        newState = otherColorState.copy()

                        # Comprovar si la torre contraria ha estat eliminada, en aquest cas, eliminar-la de l'estat
                        if opponentRookState != None and opponentRookState[0:2] == state[0][0:2]:
                            newState.remove(opponentRookState)

                        state = state + newState

                        # Moure les peces a l'estat nou
                        self.newBoardSim(state)

                        # Està el rei amenaçat o no?
                        if not self.isWatched(state, color):
                            allChecked = False
                            break
                
                self.newBoardSim(currentState)

                return allChecked

    def checkMate(self, currentState, color=None):
        # Si el rei està amenaçat i per tots els seus moviments també està amenaçat,
        # el rei està en check mate!
        return self.isWatched(currentState, color) and self.movesThreatened(currentState, color)

    def newBoardSim(self, listStates):
        # We create a  new boardSim
        TA = np.zeros((8, 8))
        for state in listStates:
            TA[state[0]][state[1]] = state[2]

        self.chess.newBoardSim(TA)

        # self.chess.boardSim.print_board()

    def getPieceState(self, state, piece):
        pieceState = None
        for i in state:
            if i[2] == piece:
                pieceState = i
                break
        return pieceState

    def getCurrentState(self):
        listStates = []
        for i in self.chess.board.currentStateW:
            listStates.append(i)
        for j in self.chess.board.currentStateB:
            listStates.append(j)
        return listStates

    def getNextPositions(self, state):
        # Given a state, we check the next possible states
        # From these, we return a list with position, i.e., [row, column]
        if state == None:
            return None
        if state[2] > 6:
            nextStates = self.getListNextStatesB([state])
        else:
            nextStates = self.getListNextStatesW([state])
        nextPositions = []
        for i in nextStates:
            nextPositions.append(i[0][0:2])
        return nextPositions

    def getWhiteState(self, currentState):
        whiteState = []
        wkState = self.getPieceState(currentState, 6)
        whiteState.append(wkState)
        wrState = self.getPieceState(currentState, 2)
        if wrState != None:
            whiteState.append(wrState)
        return whiteState

    def getBlackState(self, currentState):
        blackState = []
        bkState = self.getPieceState(currentState, 12)
        blackState.append(bkState)
        brState = self.getPieceState(currentState, 8)
        if brState != None:
            blackState.append(brState)
        return blackState

    def getMovement(self, state, nextState):
        # Given a state and a successor state, return the postiion of the piece that has been moved in both states
        pieceState = None
        pieceNextState = None
        for piece in state:
            if piece not in nextState:
                movedPiece = piece[2]
                pieceNext = self.getPieceState(nextState, movedPiece)
                if pieceNext != None:
                    pieceState = piece
                    pieceNextState = pieceNext
                    break

        return [pieceState, pieceNextState]

    def heuristica(self, currentState, color):
        #In this method, we calculate the heuristics for both the whites and black ones
        #The value calculated here is for the whites, 
        # but finally from verything, as a function of the color parameter, we multiply the result by -1
        value = 0

        bkState = self.getPieceState(currentState, self.BLACK_KING)
        wkState = self.getPieceState(currentState, self.WHITE_KING)
        wrState = self.getPieceState(currentState, self.WHITE_ROOK)
        brState = self.getPieceState(currentState, self.BLACK_ROOK)

        filaBk = bkState[0]
        columnaBk = bkState[1]
        filaWk = wkState[0]
        columnaWk = wkState[1]

        if wrState != None:
            filaWr = wrState[0]
            columnaWr = wrState[1]
        if brState != None:
            filaBr = brState[0]
            columnaBr = brState[1]

        # We check if they killed the black tower
        if brState == None:
            value += 50
            fila = abs(filaBk - filaWk)
            columna = abs(columnaWk - columnaBk)
            distReis = min(fila, columna) + abs(fila - columna)
            if distReis >= 3 and wrState != None:
                filaR = abs(filaBk - filaWr)
                columnaR = abs(columnaWr - columnaBk)
                value += (min(filaR, columnaR) + abs(filaR - columnaR))/10
            # If we are white white, the closer our king from the oponent, the better
            # we substract 7 to the distance between the two kings, since the max distance they can be at in a board is 7 moves
            value += (7 - distReis)
            # If they black king is against a wall, we prioritize him to be at a corner, precisely to corner him
            if bkState[0] == 0 or bkState[0] == 7 or bkState[1] == 0 or bkState[1] == 7:
                value += (abs(filaBk - 3.5) + abs(columnaBk - 3.5)) * 10
            #If not, we will only prioritize that he approahces the wall, to be able to approach the check mate
            else:
                value += (max(abs(filaBk - 3.5), abs(columnaBk - 3.5))) * 10

        # They killed the black tower. Within this method, we consider the same conditions than in the previous condition
        # Within this method we consider the same conditions than in the previous section, but now with reversed values.
        if wrState == None:
            value += -50
            fila = abs(filaBk - filaWk)
            columna = abs(columnaWk - columnaBk)
            distReis = min(fila, columna) + abs(fila - columna)

            if distReis >= 3 and brState != None:
                filaR = abs(filaWk - filaBr)
                columnaR = abs(columnaBr - columnaWk)
                value -= (min(filaR, columnaR) + abs(filaR - columnaR)) / 10
            # If we are white, the close we have our king from the oponent, the better
            # If we substract 7 to the distance between both kings, as this is the max distance they can be at in a chess board
            value += (-7 + distReis)

            if wkState[0] == 0 or wkState[0] == 7 or wkState[1] == 0 or wkState[1] == 7:
                value -= (abs(filaWk - 3.5) + abs(columnaWk - 3.5)) * 10
            else:
                value -= (max(abs(filaWk - 3.5), abs(columnaWk - 3.5))) * 10

        if self.isWatched(currentState, color):
            # White threatened
            if color:
                value += -20
            
            # Black threatened
            else:
                value += 20

        # If black, values are negative, otherwise positive
        if not color:
            value = (-1) * value

        return value

    def minimaxAlgorithm(self, depthWhite, depthBlack):
        currentState = self.getCurrentState()

        self.listVisitedStates.append(currentState)

        # Are white pieces in a check-mate position?
        if self.checkMate(currentState, True):
            return False
        
        # Is black king in a check-mate position?
        if self.checkMate(currentState, False):
            return True
        
        # Copy the current state
        copyState = self.copyState(currentState)
        self.listVisitedSituations.append((False, copyState))

        # Assign to a variable the color of the pieces that will win
        # White wins = 'True'
        # Black wins = 'False'
        # If no one wins, tie is represented by 'None'
        colorWin = None

        for i in range(1000):
            currentState = self.getCurrentState()

            # White pieces turn
            if i % 2 == 0:
                self.WHITES_TURN = True
                self.BLACKS_TURN = False

                if not self.minimax(currentState, depthWhite):
                    print("\nAlready visited situation (white)\n")
                    break

                if self.checkMate(currentState, False):
                    colorWin = True
                    break
                
            # Black pieces turn
            else:
                self.WHITES_TURN = False
                self.BLACKS_TURN = True

                if not self.minimax(currentState, depthBlack):
                    print("\nAlready visited situation (black)\n")
                    break

                if self.checkMate(currentState, True):
                    colorWin = False
                    break
            
            # Print the board after each turn
            self.chess.board.print_board()
        
        # Print the final board
        self.chess.board.print_board()
        return colorWin
    
    def minimax(self, state, maxDepth):
        nextState = self.maximum(state, 0, maxDepth)

        copyState = self.copyState(nextState)

        if self.isVisitedSituation(True, copyState):
            return False
        
        self.listVisitedSituations.append((True, copyState))

        # Get the movement of the piece
        movement = self.getMovement(state, nextState)

        self.listVisitedStates.append(nextState)

        # Move the piece with this movement in the board of the match
        self.chess.move(movement[0], movement[1])
        
        return True
    
    def initialize_for_turn(self, currentState):
        if self.WHITES_TURN:
            return {
                "getNextStates": self.getListNextStatesW,
                "getOpponentNextStates": self.getListNextStatesB,
                "getPieceState": self.getPieceState(currentState, self.WHITE_ROOK),
                "getOpponentPiece": self.getPieceState(currentState, self.BLACK_ROOK),
                "getOpponentState": self.getBlackState,
                "getSelfState": self.getWhiteState,
                "heuristicColor": True
            }
        else:
            return {
                "getNextStates": self.getListNextStatesB,
                "getOpponentNextStates": self.getListNextStatesW,
                "getPieceState": self.getPieceState(currentState, self.BLACK_ROOK),
                "getOpponentPiece": self.getPieceState(currentState, self.WHITE_ROOK),
                "getOpponentState": self.getWhiteState,
                "getSelfState": self.getBlackState,
                "heuristicColor": False
            }


    def maximum(self, currentState, depth, maxDepth):
        # Print that we are in a maximum node and the turn of the pieces
        settings = self.initialize_for_turn(currentState)

        heuristicColor = settings["heuristicColor"]
        getSelfState = settings["getSelfState"]
        getOpponentState = settings["getOpponentState"]
        getNextStates = settings["getNextStates"]
        getOpponentPiece = settings["getOpponentPiece"]

        # The reason we add/subtract depth is to prioritize checkmates
        # that happen earlier in the game. This way, if there are multiple
        # checkmate paths, the algorithm will favor the quickest one.
        if self.movesThreatened(currentState, heuristicColor):
            if self.isWatched(currentState, heuristicColor):
                return -1000
            return 0

        # Com si haguéssim arribat a un terminal-node
        if depth == maxDepth:
            return self.heuristica(currentState, heuristicColor)

        maximumValue = self.NEG_INF
        maximumState = None
        selfState = getSelfState(currentState)
        opponentState = getOpponentState(currentState)
        oppRook = getOpponentPiece

        for state in getNextStates(selfState):
            newOppState = opponentState.copy()

            # Comprovar si la torre contraria ha estat eliminada, en aquest cas, eliminar-la de l'estat
            if oppRook is not None and oppRook[0:2] == state[0][0:2]:
                newOppState.remove(oppRook)

            # Actualitzar l'estat
            state = state + newOppState

            # Don't analize the movements in which the white king is threatened
            if not self.isWatched(state, heuristicColor):
                valueState = self.minimum(state, depth + 1, maxDepth)

                # És un bon estat? Si és així, actualitzem el valor màxim i l'estat màxim
                if valueState > maximumValue:
                    maximumValue = valueState
                    maximumState = state
        
        if depth == 0:
            return maximumState
        return maximumValue

    def minimum(self, currentState, depth, maxDepth):
        settings = self.initialize_for_turn(currentState)

        heuristicColor = settings["heuristicColor"]
        getSelfState = settings["getSelfState"]
        getPieceState = settings["getPieceState"]
        getOpponentNextMoves = settings["getOpponentNextStates"]
        getOpponentState = settings["getOpponentState"]

        if self.movesThreatened(currentState, not heuristicColor):
            if self.isWatched(currentState, not heuristicColor):
                # It's important to arribe to the checkmate position
                # in the less number of possible movements
                return self.POS_INF / depth
            return 0

        if depth == maxDepth:
            return self.heuristica(currentState, heuristicColor)
        
        opponentState = getOpponentState(currentState)
        selfState = getSelfState(currentState)
        currentRook = getPieceState

        # Assign the minimum value as a very positive number
        minimumValue = self.POS_INF

        for state in getOpponentNextMoves(opponentState):
            newState = selfState.copy()

            # Has it removed the opponent's rook? Remove it!
            if currentRook is not None and currentRook[0:2] == state[0][0:2]:
                newState.remove(currentRook)
            
            # Update state
            state = state + newState

            # Don't analize the movements in which the current king is threatened
            if not self.isWatched(state, not heuristicColor):
                # Update minimum value
                minimumValue = min(minimumValue, self.maximum(state, depth + 1, maxDepth))

        return minimumValue


    def alphaBetaPoda(self, depthWhite, depthBlack):
        currentState = self.getCurrentState()

        self.listVisitedStates.append(currentState)

        # Are white pieces in a check-mate position?
        if self.checkMate(currentState, True):
            return False
        
        # Is black king in a check-mate position?
        if self.checkMate(currentState, False):
            return True
        
        # Copy the current state
        copyState = self.copyState(currentState)
        self.listVisitedSituations.append((False, copyState))

        # Assign to a variable the color of the pieces that will win
        # White wins = 'True'
        # Black wins = 'False'
        # If no one wins, tie is represented by 'None'
        colorWin = None

        for i in range(1000):
            currentState = self.getCurrentState()

            # White pieces turn
            if i % 2 == 0:
                self.WHITES_TURN = True
                self.BLACKS_TURN = False

                if not self.poda(currentState, depthWhite):
                    print("\nAlready visited situation (white)\n")
                    break

                if self.checkMate(currentState, False):
                    colorWin = True
                    break
                
            # Black pieces turn
            else:
                self.WHITES_TURN = False
                self.BLACKS_TURN = True

                if not self.poda(currentState, depthBlack):
                    print("\nAlready visited situation (black)\n")
                    break

                if self.checkMate(currentState, True):
                    colorWin = False
                    break
            
            # Print the board after each turn
            self.chess.board.print_board()
        
        # Print the final board
        self.chess.board.print_board()
        return colorWin
    
    def poda(self, state, maxDepth):
        # We assign the variable alpha as a very negative number and beta as a very negative number
        alpha = -99999
        beta = 99999
        nextState = self.podaMaxValue(state, 0, maxDepth, alpha, beta)

        self.listVisitedStates.append(nextState)

        copyState = self.copyState(nextState)
        if self.isVisitedSituation(True, copyState):
            return False
        
        self.listVisitedSituations.append((True, copyState))

        # Get the movement of the piece
        movement = self.getMovement(state, nextState)

        # Move the piece with this movement in the board of the match
        self.chess.move(movement[0], movement[1])
        return True
    
    def podaMaxValue(self, currentState, depth, maxDepth, alpha, beta):
        settings = self.initialize_for_turn(currentState)

        heuristicColor = settings["heuristicColor"]
        getSelfState = settings["getSelfState"]
        getOpponentState = settings["getOpponentState"]
        getNextStates = settings["getNextStates"]
        getOpponentPiece = settings["getOpponentPiece"]
        
        if self.movesThreatened(currentState):
            # If white king is threatened now, it's in a check mate position!
            if self.isWatched(currentState, heuristicColor):
                return -1000
            # If not, the pieces are in a tie position
            return 0
        
        #If arrive to the maximum depth, calculate the image of the evaluation function for that state
        if depth == maxDepth:
            return self.heuristica(currentState, heuristicColor)

        # Assign the maximun value as a very negative number
        maximumValue = self.NEG_INF
        maximumState = None
        selfState = getSelfState(currentState)
        opponentState = getOpponentState(currentState)
        oppRook = getOpponentPiece

        for state in getNextStates(selfState):
            newOppState = opponentState.copy()

            # Comprovar si la torre contraria ha estat eliminada, en aquest cas, eliminar-la de l'estat
            if oppRook is not None and oppRook[0:2] == state[0][0:2]:
                newOppState.remove(oppRook)

            # Actualitzar l'estat
            state = state + newOppState

            # Don't analize the movements in which the white king is threatened
            if not self.isWatched(state, heuristicColor):
                valueState = self.podaMinValue(state, depth + 1, maxDepth, alpha, beta)

                # És un bon estat? Si és així, actualitzem el valor màxim i l'estat màxim
                if valueState > maximumValue:
                    maximumValue = valueState
                    maximumState = state
                
                # Make a prunning in case of fulfill the beta's condition
                if maximumValue >= beta:
                    break
                # Update the alpha's value
                alpha = max(alpha, maximumValue)
        
        if depth == 0:
            return maximumState
        return maximumValue
    
    def podaMinValue(self, currentState, depth, maxDepth, alpha, beta):
        settings = self.initialize_for_turn(currentState)

        heuristicColor = settings["heuristicColor"]
        getSelfState = settings["getSelfState"]
        getPieceState = settings["getPieceState"]
        getOpponentNextMoves = settings["getOpponentNextStates"]
        getOpponentState = settings["getOpponentState"]

        if self.movesThreatened(currentState, not heuristicColor):
            if self.isWatched(currentState, not heuristicColor):
                # It's important to arribe to the checkmate position
                # in the less number of possible movements
                return self.POS_INF / depth
            return 0

        if depth == maxDepth:
            return self.heuristica(currentState, heuristicColor)
        
        opponentState = getOpponentState(currentState)
        selfState = getSelfState(currentState)
        currentRook = getPieceState

        # Assign the minimum value as a very positive number
        minimumValue = self.POS_INF

        for state in getOpponentNextMoves(opponentState):
            newState = selfState.copy()

            # Has it removed the our rook? Remove it!
            if currentRook is not None and currentRook[0:2] == state[0][0:2]:
                newState.remove(currentRook)
            
            # Update state
            state = state + newState

            # Don't analize the movements in which the current king is threatened
            if not self.isWatched(state, not heuristicColor):
                # Update minimum value
                minimumValue = min(minimumValue, self.podaMaxValue(state, depth + 1, maxDepth, alpha, beta))

                # Make a prunning in case of fulfill the alpha's condition
                if minimumValue <= alpha:
                    break
                # Update the beta's value
                beta = min(beta, minimumValue)

        return minimumValue
    
    def mitjana(self, values):
        sum = 0
        N = len(values)
        for i in range(N):
            sum += values[i]

        return sum / N

    def desviacio(self, values, mitjana):
        sum = 0
        N = len(values)

        for i in range(N):
            sum += pow(values[i] - mitjana, 2)

        return pow(sum / N, 1 / 2)

    def calculateValue(self, values):
        if len(values) == 0:
            return 0
        mitjana = self.mitjana(values)
        desviacio = self.desviacio(values, mitjana)
        # If deviation is 0, we cannot standardize values, since they are all equal, thus probability willbe equiprobable
        if desviacio == 0:
            # We return another value
            return values[0]

        esperanca = 0
        sum = 0
        N = len(values)
        for i in range(N):
            #Normalize value, with mean and deviation - zcore
            normalizedValues = (values[i] - mitjana) / desviacio
            # make the values positive with function e^(-x), in which x is the standardized value
            positiveValue = pow(1 / math.e, normalizedValues)
            # Here we calculate the expected value, which in the end will be expected value/sum            
            # Our positiveValue/sum represent the probabilities for each value
            # The larger this value, the more likely
            esperanca += positiveValue * values[i]
            sum += positiveValue

        return esperanca / sum
        
    def expectimaxAlgorithm(self, depthWhite, depthBlack):
        currentState = self.getCurrentState()

        self.listVisitedStates.append(currentState)

        # Are white pieces in a check-mate position?
        if self.checkMate(currentState, True):
            return False
        
        # Is black king in a check-mate position?
        if self.checkMate(currentState, False):
            return True
        
        # Copy the current state
        copyState = self.copyState(currentState)
        self.listVisitedSituations.append((False, copyState))

        # Assign to a variable the color of the pieces that will win
        # White wins = 'True'
        # Black wins = 'False'
        # If no one wins, tie is represented by 'None'
        colorWin = None

        for i in range(100):
            currentState = self.getCurrentState()

            # White pieces turn
            if i % 2 == 0:
                self.WHITES_TURN = True
                self.BLACKS_TURN = False

                if not self.expectimax(currentState, depthWhite):
                    print("\nAlready visited situation (white)\n")
                    break

                if self.checkMate(currentState, False):
                    colorWin = True
                    break
                
            # Black pieces turn
            else:
                self.WHITES_TURN = False
                self.BLACKS_TURN = True

                if not self.expectimax(currentState, depthBlack):
                    print("\nAlready visited situation (black)\n")
                    break

                if self.checkMate(currentState, True):
                    colorWin = False
                    break
            
            # Print the board after each turn
            self.chess.board.print_board()
        
        # Print the final board
        self.chess.board.print_board()
        return colorWin      

    def expectimax(self, state, maxDepth):
        nextState = self.expMaxValue(state, 0, maxDepth)

        copyState = self.copyState(nextState)

        if self.isVisitedSituation(True, copyState):
            return False
        
        self.listVisitedSituations.append((True, copyState))

        # Get the movement of the piece
        movement = self.getMovement(state, nextState)

        self.listVisitedStates.append(nextState)

        # Move the piece with this movement in the board of the match
        self.chess.move(movement[0], movement[1])
        
        return True
    
    def expMaxValue(self, currentState, depth, maxDepth):
        settings = self.initialize_for_turn(currentState)

        heuristicColor = settings["heuristicColor"]
        getSelfState = settings["getSelfState"]
        getOpponentState = settings["getOpponentState"]
        getNextStates = settings["getNextStates"]
        getOpponentPiece = settings["getOpponentPiece"]

        # The reason we add/subtract depth is to prioritize checkmates
        # that happen earlier in the game. This way, if there are multiple
        # checkmate paths, the algorithm will favor the quickest one.
        if self.movesThreatened(currentState, heuristicColor):
            if self.isWatched(currentState, heuristicColor):
                return -9999
            # If not, the pieces are in a tie position
            return 0

        # If we arrive to the maximum depth, calculate the image of the evaluation function for that state
        if depth == maxDepth:
            return self.heuristica(currentState, heuristicColor)

        maximumValue = self.NEG_INF
        maximumState = None
        selfState = getSelfState(currentState)
        opponentState = getOpponentState(currentState)
        oppRook = getOpponentPiece

        for state in getNextStates(selfState):
            newOppState = opponentState.copy()

            # Comprovar si la torre contraria ha estat eliminada, en aquest cas, eliminar-la de l'estat
            if oppRook is not None and oppRook[0:2] == state[0][0:2]:
                newOppState.remove(oppRook)

            # Actualitzar l'estat
            state = state + newOppState

            # Don't analize the movements in which the white king is threatened
            if not self.isWatched(state, heuristicColor):
                valueState = self.expValue(state, depth + 1, maxDepth)

                # És un bon estat? Si és així, actualitzem el valor màxim i l'estat màxim
                if valueState > maximumValue:
                    maximumValue = valueState
                    maximumState = state

        # If it reaches the root node, return the state that represents the next white's movement
        if depth == 0:
            return maximumState
        return maximumValue
    
    def expValue(self, currentState, depth, maxDepth):
        settings = self.initialize_for_turn(currentState)

        heuristicColor = settings["heuristicColor"]
        getSelfState = settings["getSelfState"]
        getPieceState = settings["getPieceState"]
        getOpponentNextMoves = settings["getOpponentNextStates"]
        getOpponentState = settings["getOpponentState"]

        if self.movesThreatened(currentState, not heuristicColor):
            if self.isWatched(currentState, not heuristicColor):
                # It's important to arribe to the checkmate position
                # in the less number of possible movements
                return self.POS_INF / depth
            return 0

        if depth == maxDepth:
            return self.heuristica(currentState, heuristicColor)
        
        opponentState = getOpponentState(currentState)
        selfState = getSelfState(currentState)
        currentRook = getPieceState

        # Create a list of all the values
        values = []

        for state in getOpponentNextMoves(opponentState):
            newState = selfState.copy()

            # Has it removed the opponent's rook? Remove it!
            if currentRook is not None and currentRook[0:2] == state[0][0:2]:
                newState.remove(currentRook)
            
            # Update state
            state = state + newState

            # Don't analize the movements in which the current king is threatened
            if not self.isWatched(state, not heuristicColor):
                # Save all the next values in a list
                value = self.expMaxValue(state, depth + 1, maxDepth)
                values.append(value)

        # Assign probabilities and calculate the expectation
        return self.calculateValue(values)

    def initialiseBoard(self):
        # intiialize board
        TA = np.zeros((8, 8))

        # Initial configuration of the board
        TA[7][0] = WHITE_ROOK
        TA[7][4] = WHITE_KING
        TA[0][7] = BLACK_ROOK
        TA[0][4] = BLACK_KING

        return TA

    def exercici1(self, aichess):
        # Run the game a few times to see how often do whites win (with depth==4 they always win)

        whitesWin = 0
        tieCount = 0
        blacksWin = 0
        
        for match in range(4):
            start = time.time()
            winner = aichess.minimaxAlgorithm(4, 4)
            end = time.time()

            # White wins = 'True'
            # Black wins = 'False'
            # If no one wins, tie is represented by 'None'
            if winner == True:
                print("\nWhite wins")
                whitesWin += 1
            elif winner == False:
                print("\nBlack wins")
                blacksWin += 1
            else:
                print("\nTie")
                tieCount += 1

            print("\n------------------------")
            print("List of visited states: " + str(aichess.listVisitedStates))
            print("------------------------")

            print("\nTime taken (minutes): " + str((end - start) / 60))


            if match < 3:
                # Initialise board and AI chess
                print("\n----Starting AI chess----")
                aichess = Aichess(self.initialiseBoard(), True)

                print("----Printing board----\n")
                aichess.chess.boardSim.print_board()

        print("\n------------------------")
        print("Number of times white wins: " + str(whitesWin))
        print("Percentage of times white wins: " + str(whitesWin / 4 * 100) + "%")
        print("\n------------------------")
        print("Number of times black wins: " + str(blacksWin))
        print("Percentage of times black wins: " + str(blacksWin / 4 * 100) + "%")
        print("\n------------------------")
        print("Number of times tie: " + str(tieCount))
        print("Percentage of times tie: " + str(tieCount / 4 * 100) + "%")
        print("------------------------")
    
    def exercici2(self, aichess):
        # Run the same simulations, but varying the depth of the minimax algorithm
        # from 1 to 4 moves both for whites and blacks. Run each possible combination
        # of depths a few times (it is the exact same result, there is no randomness)

        results = {}  # Dictionary to store the results for each depth combination

        # Run each possible combination of depths
        for white_depth in range(1, 5):
            for black_depth in range(1, 5):
                print(f"\nWhite depth: {white_depth}")
                print(f"Black depth: {black_depth}\n")

                start = time.time()
                winner = aichess.minimaxAlgorithm(white_depth, black_depth)
                end = time.time()

                # Update results dictionary
                depth_key = (white_depth, black_depth)
                if depth_key not in results:
                    results[depth_key] = {'whitesWin': 0, 'blacksWin': 0, 'tieCount': 0}

                if winner == True:
                    results[depth_key]['whitesWin'] += 1
                    print("\nWhite wins with white_depth={} && black_depth={}".format(white_depth, black_depth))
                elif winner == False:
                    results[depth_key]['blacksWin'] += 1
                    print("\nBlack wins with white_depth={} && black_depth={}".format(white_depth, black_depth))
                else:
                    results[depth_key]['tieCount'] += 1
                    print("\nTie with white_depth={} && black_depth={}".format(white_depth, black_depth))

                print("\n------------------------")
                print("List of visited states: " + str(aichess.listVisitedStates))
                print("------------------------")

                print("\nTime taken (minutes): " + str((end - start) / 60))

                if white_depth < 5 and black_depth < 5:
                    # Initialise board and AI chess
                    print("\n----Starting AI chess----")
                    aichess = Aichess(self.initialiseBoard(), True)

                    print("----Printing board----\n")
                    aichess.chess.boardSim.print_board()

        # Export the results to a CSV file
        with open('ex2_simulation_results.csv', 'w', newline='') as file:
            writer = csv.writer(file)
            writer.writerow(['White Depth', 'Black Depth', 'Whites Win', 'Blacks Win', 'Ties'])

            for depth_combination, outcomes in results.items():
                writer.writerow([
                    depth_combination[0],
                    depth_combination[1],
                    outcomes['whitesWin'],
                    outcomes['blacksWin'],
                    outcomes['tieCount']
                ])

    def exercici3(self):
        # Implement the alfa-beta pruning for the blacks only, whites still play with minimax
        currentState = self.getCurrentState()

        self.listVisitedStates.append(currentState)

        # Are white pieces in a check-mate position?
        if self.checkMate(currentState, True):
            return False
        
        # Is black king in a check-mate position?
        if self.checkMate(currentState, False):
            return True
        
        # Copy the current state
        copyState = self.copyState(currentState)
        self.listVisitedSituations.append((False, copyState))

        # Assign to a variable the color of the pieces that will win
        # White wins = 'True'
        # Black wins = 'False'
        # If no one wins, tie is represented by 'None'
        colorWin = None
        
        for i in range(1000):
            currentState = self.getCurrentState()

            # White pieces turn
            if i % 2 == 0:
                self.WHITES_TURN = True
                self.BLACKS_TURN = False

                if not self.minimax(currentState, 4):
                    print("\nAlready visited situation (white)\n")
                    break

                if self.checkMate(currentState, False):
                    colorWin = True
                    break
                
            # Black pieces turn
            else:
                self.WHITES_TURN = False
                self.BLACKS_TURN = True

                if not self.poda(currentState, 4):
                    print("\nAlready visited situation (black)\n")
                    break

                if self.checkMate(currentState, True):
                    colorWin = False
                    break
            
            # Print the board after each turn
            self.chess.board.print_board()
        
        # Print the final board
        self.chess.board.print_board()
        return colorWin
    
    def exercici4(self, aichess):
        # Both whites and blacks use the same alfa-beta pruning.
        # Run three simulations each while varying the depth with which each team plays (1-5).

        results = {}  # Dictionary to store the results for each depth combination

        # Run each possible combination of depths
        for white_depth in range(1, 6):
            for black_depth in range(1, 6):
                print(f"\nWhite depth: {white_depth}")
                print(f"Black depth: {black_depth}\n")

                start = time.time()
                winner = aichess.alphaBetaPoda(white_depth, black_depth)
                end = time.time()

                # Update results dictionary
                depth_key = (white_depth, black_depth)
                if depth_key not in results:
                    results[depth_key] = {'whitesWin': 0, 'blacksWin': 0, 'tieCount': 0}

                if winner == True:
                    results[depth_key]['whitesWin'] += 1
                    print("\nWhite wins with white_depth={} && black_depth={}".format(white_depth, black_depth))
                elif winner == False:
                    results[depth_key]['blacksWin'] += 1
                    print("\nBlack wins with white_depth={} && black_depth={}".format(white_depth, black_depth))
                else:
                    results[depth_key]['tieCount'] += 1
                    print("\nTie with white_depth={} && black_depth={}".format(white_depth, black_depth))

                print("\n------------------------")
                print("List of visited states: " + str(aichess.listVisitedStates))
                print("------------------------")

                print("\nTime taken (minutes): " + str((end - start) / 60))

                if white_depth < 6 and black_depth < 6:
                    # Initialise board and AI chess
                    print("\n----Starting AI chess----")
                    aichess = Aichess(self.initialiseBoard(), True)

                    print("----Printing board----\n")
                    aichess.chess.boardSim.print_board()

        # Export the results to a CSV file
        with open('ex4_simulation_results.csv', 'w', newline='') as file:
            writer = csv.writer(file)
            writer.writerow(['White Depth', 'Black Depth', 'Whites Win', 'Blacks Win', 'Ties'])

            for depth_combination, outcomes in results.items():
                writer.writerow([
                    depth_combination[0],
                    depth_combination[1],
                    outcomes['whitesWin'],
                    outcomes['blacksWin'],
                    outcomes['tieCount']
                ])

    def exercici5(self, whiteDepth, blackDepth):
        # Implement the alfa-beta pruning for the blacks only, whites still play with minimax
        currentState = self.getCurrentState()

        self.listVisitedStates.append(currentState)

        # Are white pieces in a check-mate position?
        if self.checkMate(currentState, True):
            return False
        
        # Is black king in a check-mate position?
        if self.checkMate(currentState, False):
            return True
        
        # Copy the current state
        copyState = self.copyState(currentState)
        self.listVisitedSituations.append((False, copyState))

        # Assign to a variable the color of the pieces that will win
        # White wins = 'True'
        # Black wins = 'False'
        # If no one wins, tie is represented by 'None'
        colorWin = None
        
        for i in range(1000):
            currentState = self.getCurrentState()

            # White pieces turn
            if i % 2 == 0:
                self.WHITES_TURN = True
                self.BLACKS_TURN = False

                if not self.expectimax(currentState, white_depth):
                    print("\nAlready visited situation (white)\n")
                    break

                if self.checkMate(currentState, False):
                    colorWin = True
                    break
                
            # Black pieces turn
            else:
                self.WHITES_TURN = False
                self.BLACKS_TURN = True

                if not self.poda(currentState, black_depth):
                    print("\nAlready visited situation (black)\n")
                    break

                if self.checkMate(currentState, True):
                    colorWin = False
                    break
            
            # Print the board after each turn
            self.chess.board.print_board()
        
        # Print the final board
        self.chess.board.print_board()
        return colorWin

if __name__ == "__main__":
    #   if len(sys.argv) < 2:
    #       sys.exit(usage())

    # intiialize board
    TA = np.zeros((8, 8))

    BLACK_KING = 12
    BLACK_ROOK = 8
    WHITE_KING = 6
    WHITE_ROOK = 2

    # Configuració inicial del taulell
    TA[7][0] = WHITE_ROOK
    TA[7][4] = WHITE_KING
    TA[0][7] = BLACK_ROOK
    TA[0][4] = BLACK_KING

    # initialise board
    print("\n----Starting AI chess----")
    aichess = Aichess(TA, True)

    print("----Printing board----\n")
    aichess.chess.boardSim.print_board()

    #### Run exercise 1 ####
    # print("\n----Exercise 1----")
    # aichess.exercici1(aichess)
    
    #### Run exercise 2 ####
    # print("\n----Exercise 2----")
    # aichess.exercici2(aichess)
    
    #### Run exercise 3 ####
    # print("\n----Exercise 3----")
    # whiteWins = 0
    # blackWins = 0
    # tieCount = 0

    # for simulation in range(3):
    #     print(f"\nSimulation {simulation+1}\n")

    #     start = time.time()
    #     winner = aichess.exercici3()
    #     end = time.time()

    #     if winner == True:
    #         print("\nWhite wins")
    #         whiteWins += 1
    #     elif winner == False:
    #         print("\nBlack wins")
    #         blackWins += 1
    #     else:
    #         print("\nTie")
    #         tieCount += 1

    #     print("\n------------------------")
    #     print("List of visited states: " + str(aichess.listVisitedStates))
    #     print("------------------------")

    #     print("\nTime taken (minutes): " + str((end - start) / 60))

    #     if simulation < 2:
    #         # Initialise board and AI chess
    #         print("\n----Starting AI chess----")
    #         aichess = Aichess(aichess.initialiseBoard(), True)

    #         print("----Printing board----\n")
    #         aichess.chess.boardSim.print_board()
    
    # print(f"\nTotal percentage of times white wins: {whiteWins*100/3:.2f}%")
    # print(f"Total percentage of times black wins: {blackWins*100/3:.2f}%")
    # print(f"Total percentage of times tie: {tieCount*100/3:.2f}%")

    ### Run exercise 4 ###
    # print("\n----Exercise 4----")
    # aichess.exercici4(aichess)    

    #### Run exercise 5 ####
    # print("\n----Exercise 5----")
    # results = {}  # Dictionary to store the results for each depth combination

    # Run each possible combination of depths
    # for white_depth in range(1, 6):
    #     for black_depth in range(1, 6):
    #         print(f"\nWhite depth: {white_depth}")
    #         print(f"Black depth: {black_depth}\n")

    #         start = time.time()
    #         winner = aichess.exercici5(white_depth, black_depth)
    #         end = time.time()

    #         # Update results dictionary
    #         depth_key = (white_depth, black_depth)
    #         if depth_key not in results:
    #             results[depth_key] = {'whitesWin': 0, 'blacksWin': 0, 'tieCount': 0}

    #         if winner == True:
    #             results[depth_key]['whitesWin'] += 1
    #             print("\nWhite wins with white_depth={} && black_depth={}".format(white_depth, black_depth))
    #         elif winner == False:
    #             results[depth_key]['blacksWin'] += 1
    #             print("\nBlack wins with white_depth={} && black_depth={}".format(white_depth, black_depth))
    #         else:
    #             results[depth_key]['tieCount'] += 1
    #             print("\nTie with white_depth={} && black_depth={}".format(white_depth, black_depth))

    #         print("\n------------------------")
    #         print("List of visited states: " + str(aichess.listVisitedStates))
    #         print("------------------------")

    #         print("\nTime taken (minutes): " + str((end - start) / 60))

    #         if white_depth < 6 and black_depth < 6:
    #             # Initialise board and AI chess
    #             print("\n----Starting AI chess----")
    #             aichess = Aichess(aichess.initialiseBoard(), True)

    #             print("----Printing board----\n")
    #             aichess.chess.boardSim.print_board()

    # # Export the results to a CSV file
    # with open('ex5_simulation_results.csv', 'w', newline='') as file:
    #     writer = csv.writer(file)
    #     writer.writerow(['White Depth', 'Black Depth', 'Whites Win', 'Blacks Win', 'Ties'])

    #     for depth_combination, outcomes in results.items():
    #         writer.writerow([
    #             depth_combination[0],
    #             depth_combination[1],
    #             outcomes['whitesWin'],
    #             outcomes['blacksWin'],
    #             outcomes['tieCount']
    #         ])

