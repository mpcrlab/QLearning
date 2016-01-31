import numpy as np


class World(object):

    """
     ____ ____ ____ ____ ____
    |_-1_|_-1_|_-1_|_-1_|_-1_|
    |_-1_|_0x_|_00_|_00_|_-1_|
    |_-1_|_00_|_00_|_00_|_-1_|
    |_-1_|_00_|_00_|_15_|_-1_|
    |_-1_|_-1_|_-1_|_-1_|_-1_|

    """

    def __init__(self):

        self.n_actions = 4
        self.n_states = 25

        self.rewards = np.array([[[
            [-1, -1, -1, -1, -1],
            [-1, 0, 0, 0, -1],
            [-1, 0, 0, 0, -1],
            [-1, 0, 0, 15, -1],
            [-1, -1, -1, -1, -1]
        ]]])

        self.terminals = np.array([[[
            [1, 1, 1, 1, 1],
            [1, 0, 0, 0, 1],
            [1, 0, 0, 0, 1],
            [1, 0, 0, 1, 1],
            [1, 1, 1, 1, 1]
        ]]])

    def act(self, state, action):

        state_index = np.nonzero(state)
        # action_index = np.nonzero(action)[1][0]
        action_index = action

        if action_index == 0:  # left
            state_index[3][0] -= 1
        elif action_index == 1:  # right
            state_index[3][0] += 1
        elif action_index == 2:  # up
            state_index[2][0] -= 1
        elif action_index == 3:  # down
            state_index[2][0] += 1

        state_prime = np.zeros_like(state)
        state_prime[state_index] = 1

        reward = self.rewards[state_index]
        terminal = self.terminals[state_index]

        return state_prime, reward, terminal
