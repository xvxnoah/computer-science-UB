# -*- coding: utf-8 -*-
"""
Created on Wed Nov 22 15:13:08 2023

@author: gemma & noah
"""

import numpy as np
import random
 
class QLearning:
    """
    Class to implement the Q-learning algorithm for finding the optimal path in a grid world.
 
    Attributes:
    - grid_size: tuple
        The size of the grid world in the format (rows, columns).
    - goal: tuple
        The coordinates of the goal state in the format (row, column).
    - inaccessible: tuple
        The coordinates of the inaccessible state in the format (row, column).
    - rewards: numpy.ndarray
        The rewards matrix representing the rewards at each state.
    - q_table: numpy.ndarray
        The Q-values matrix representing the expected rewards for each action at each state.
    - alpha: float
        The learning rate parameter for updating the Q-values.
    - gamma: float
        The discount factor parameter for balancing immediate and future rewards.
    """
 
    def __init__(self, grid_size, goal, rewards, inaccessible, alpha, gamma, epsilon):
        self.grid_size = grid_size
        self.goal = goal
        self.inaccessible = inaccessible
        self.alpha = alpha
        self.gamma = gamma
        self.epsilon = epsilon
        self.rewards = rewards
        self.q_table = np.zeros(grid_size + (4,))

    def get_valid_actions(self, state):
        row, col = state
        valid_actions = []
        if row > 0 and (row - 1, col) != inaccessible:
            valid_actions.append(1)  # left
        if row < grid_size[0] - 1 and (row + 1, col) != inaccessible:
            valid_actions.append(0)  # right
        if col > 0 and (row, col - 1) != inaccessible:
            valid_actions.append(2)  # down
        if col < grid_size[1] - 1 and (row, col + 1) != inaccessible:
            valid_actions.append(3)  # up

        return valid_actions

    def update_q_table(self, state, action, next_state, reward):
        self.q_table[state][action] = (1 - self.alpha) * self.q_table[state][action] + \
                                      self.alpha * (reward + self.gamma * np.max(self.q_table[next_state]))

    def find_optimal_path(self, start, drunk_sailor=False):
        state = start
        path = [state]
        actions = []
        while state != self.goal:
            action = np.argmax(self.q_table[state])
            action_name = self.get_action_name(action)
            next_state = self.get_next_state(state, action, drunk_sailor)
            if next_state != state:  # Only add if next state is different from current state
                path.append(next_state)
                actions.append(action_name)
            state = next_state
        return path, actions

    def get_next_state(self, state, intended_action, drunk_sailor=False):
        if drunk_sailor:
            # 99% chance to take the intended action, 1% chance for a random action
            if random.random() < 0.99:
                action = intended_action
            else:
                valid_actions = self.get_valid_actions(state)
                action = random.choice(valid_actions)
        else:
            action = intended_action

        row, col = state
        if action == 0:  # up
            return (row + 1, col)
        elif action == 1:  # down
            return (row - 1, col)
        elif action == 2:  # left
            return (row, col - 1)
        elif action == 3:  # right
            return (row, col + 1)
        return state  # remain in the same state if the action is invalid

    def get_action_name(self, action):
        return {0: "right", 1: "left", 2: "down", 3: "up"}.get(action, "none")

    def is_converged(self, old_q_table, new_q_table, threshold=0.01):
        return np.max(np.abs(old_q_table - new_q_table)) < threshold

    def train(self, start, convergence_threshold=0.01, max_episodes=10000, drunk_sailor=False):
        converged = False

        for episode in range(max_episodes):
            old_q_table = np.copy(self.q_table)
            state = start

            while state != self.goal:
                valid_actions = self.get_valid_actions(state)

                # Exploration or explotation
                if np.random.uniform(0, 1) > self.epsilon:
                    action = np.random.choice(valid_actions)
                else:
                    action_values = [self.q_table[state][a] for a in valid_actions]
                    action = valid_actions[np.argmax(action_values)]

                next_state = self.get_next_state(state, action, drunk_sailor)
                reward = self.rewards[next_state]
                self.update_q_table(state, action, next_state, reward)
                state = next_state

            if self.is_converged(old_q_table, self.q_table, convergence_threshold):
                print("\n========================================")
                print(f"Convergence achieved after {episode} episodes")
                print("========================================")
                converged = True
                break

            if episode in [50, 100]:
                print(f"\nQ-table after {episode + 1} episodes:")
                print(self.q_table)
                optimal_path, actions = self.find_optimal_path(start)
                print("\nOptimal Path:", optimal_path)
                print("Actions:", actions)
        if not converged:
            print("\n=======================================")
            print("Not converged within 10000 episodes")
            print("=======================================")
        return converged
    
def section_a(grid_size, start, goal, inaccessible, alpha, gamma, epsilon, max_episodes=10000, convergence_threshold=0.01, drunk_sailor=False):
    # Create rewards matrix
    rewards = np.full(grid_size, -1)
    rewards[goal] = 100

    # Create QLearning instance
    q_learning = QLearning(grid_size, goal, rewards, inaccessible, alpha, gamma, epsilon)

    print("Initial Q-table:")
    print(q_learning.q_table)

    # Train the model
    q_learning.train(start, convergence_threshold, max_episodes, drunk_sailor)
    optimal_path, actions = q_learning.find_optimal_path(start, drunk_sailor)

    return q_learning, optimal_path, actions
    
def section_b(grid_size, start, goal, inaccessible, alpha, gamma, epsilon, max_episodes=10000, convergence_threshold=0.01, drunk_sailor=False):
    # Create rewards matrix
    rewards = np.full(grid_size, -2)
    rewards[(0,0)] = -5
    rewards[(0,1)] = -4
    rewards[(0,2)] = -3
    rewards[(1,0)] = -4
    rewards[(1,2)] = -2
    rewards[(2,0)] = -3
    rewards[(2,1)] = -2
    rewards[(2,2)] = -1
    rewards[(3,0)] = -2
    rewards[(3,1)] = -1
    rewards[goal] = 100

    # Create QLearning instance
    q_learning = QLearning(grid_size, goal, rewards, inaccessible, alpha, gamma, epsilon)

    print("Initial Q-table:")
    print(q_learning.q_table)

    # Train the model
    q_learning.train(start, convergence_threshold, max_episodes, drunk_sailor)
    optimal_path, actions = q_learning.find_optimal_path(start, drunk_sailor)

    return q_learning, optimal_path, actions
    
def section_c(grid_size, start, goal, inaccessible, alpha, gamma, epsilon, max_episodes=10000, convergence_threshold=0.01, drunk_sailor=False):
    # Create rewards matrix
    rewards = np.full(grid_size, -2)
    rewards[(0,0)] = -5
    rewards[(0,1)] = -4
    rewards[(0,2)] = -3
    rewards[(1,0)] = -4
    rewards[(1,2)] = -2
    rewards[(2,0)] = -3
    rewards[(2,1)] = -2
    rewards[(2,2)] = -1
    rewards[(3,0)] = -2
    rewards[(3,1)] = -1
    rewards[goal] = 100

    # Create QLearning instance
    q_learning = QLearning(grid_size, goal, rewards, inaccessible, alpha, gamma, epsilon)

    print("Initial Q-table:")
    print(q_learning.q_table)

    # Train the model
    q_learning.train(start, convergence_threshold, max_episodes, drunk_sailor)
    optimal_path, actions = q_learning.find_optimal_path(start, drunk_sailor)

    return q_learning, optimal_path, actions
    
def print_optimal_path(optimal_path, actions):
    print("\nOptimal Path:", optimal_path)
    print("Actions:", actions)

def visual_q_table(q_table):
    print("\nVisual Q-table:\n")

    # Step 1: Store the actions for each state in a 2D list
    stored_actions = []
    for i in range(q_table.shape[0]):
        row_actions = []
        for j in range(q_table.shape[1]):
            state = (i, j)
            valid_actions = q_learning.get_valid_actions(state)

            if state == (1, 1) or state == (3, 2):
                row_actions.append("N/A")
            else:
                action_values = [q_table[state][a] for a in valid_actions]
                best_action_index = np.argmax(action_values)
                best_action = valid_actions[best_action_index]
                row_actions.append(q_learning.get_action_name(best_action))
        stored_actions.append(row_actions)

    # Step 2: Print the stored actions in the desired format
    # Print the third column (index 2) as the first row
    for action in [row[2] for row in stored_actions]:
        print(f"{action:<10}", end=" | ")
    print()

    # Print the second column (index 1) as the second row
    for action in [row[1] for row in stored_actions]:
        print(f"{action:<10}", end=" | ")
    print()

    # Print the first column (index 0) as the last row
    for action in [row[0] for row in stored_actions]:
        print(f"{action:<10}", end=" | ")
    print("\n")

if __name__ == "__main__":
    # Example of using the QLearning class
    grid_size = (4, 3)
    goal = (3, 2)
    inaccessible = (1, 1)
    start = (0, 0)
    max_episodes = 10000
    convergence_threshold = 0.01

    alpha = 0.1 # learning rate
    gamma = 0.9 # discount factor
    epsilon = 0.4 # exploration rate


    #### Section A ####
    drunk_sailor = False

    print("\n\n+" + "-" * 10 + " SECTION A " + "-" * 10 + "+\n")
    q_learning, optimal_path, actions = section_a(grid_size, start, goal, inaccessible, alpha, gamma, epsilon, max_episodes, convergence_threshold, drunk_sailor)

    # Print the optimal path and actions
    print_optimal_path(optimal_path, actions)

    # Final Q-table
    print("\nFinal Q-table:")
    print(q_learning.q_table)

    # Visual Q-table
    visual_q_table(q_learning.q_table)


    #### Section B ####
    drunk_sailor = False

    print("\n+" + "-" * 10 + " SECTION B " + "-" * 10 + "+\n")
    q_learning, optimal_path, actions = section_b(grid_size, start, goal, inaccessible, alpha, gamma, epsilon, max_episodes, convergence_threshold, drunk_sailor)

    # Print the optimal path and actions
    print_optimal_path(optimal_path, actions)

    # Final Q-table
    print("\nFinal Q-table:")
    print(q_learning.q_table)

    # Visual Q-table
    visual_q_table(q_learning.q_table)


    #### Section C ####
    drunk_sailor = True

    print("+" + "-" * 10 + " SECTION C " + "-" * 10 + "+\n")
    q_learning, optimal_path, actions = section_c(grid_size, start, goal, inaccessible, alpha, gamma, epsilon, max_episodes, convergence_threshold, drunk_sailor)

    # Print the optimal path and actions
    print_optimal_path(optimal_path, actions)

    # Final Q-table
    print("\nFinal Q-table:")
    print(q_learning.q_table)

    # Visual Q-table
    visual_q_table(q_learning.q_table)