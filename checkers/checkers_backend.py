#!/usr/bin/env python3
import numpy as np
from termcolor import colored, cprint

class checkers_backend(object):
    def __init__(self):
        self.board = np.zeros([8,8], np.uint8)
        self.board_flattened = np.reshape(self.board, [64])
        self.initialize_board()
        self.legend_dict = {
            1:[0,1],
            2:[0,3],
            3:[0,5],
            4:[0,7],
            5:[1,0],
            6:[1,2],
            7:[1,4],
            8:[1,6],
            9:[2,1],
            10:[2,3],
            11:[2,5],
            12:[2,7],
            13:[3,0],
            14:[3,2],
            15:[3,4],
            16:[3,6],
            17:[4,1],
            18:[4,3],
            19:[4,5],
            20:[4,7],
            21:[5,0],
            22:[5,2],
            23:[5,4],
            24:[5,6],
            25:[6,1],
            26:[6,3],
            27:[6,5],
            28:[6,7],
            29:[7,0],
            30:[7,2],
            31:[7,4],
            32:[7,6],
        }
        self.legend_dict_flat = {
            1:1,
            3:2,
            5:3,
            7:4,
            8:5,
            10:6,
            12:7,
            14:8,
            17:9,
            19:10,
            21:11,
            23:12,
            24:13,
            26:14,
            28:15,
            30:16,
            33:17,
            35:18,
            37:19,
            39:20,
            40:21,
            42:22,
            44:23,
            46:24,
            49:25,
            51:26,
            53:27,
            55:28,
            56:29,
            58:30,
            60:31,
            62:32
        }

    def initialize_board(self):
        initial_cols = [0,2,4,6]
        for row in range(3):
            if row % 2 == 0:
                for col in initial_cols:
                    self.board[row, col+1] = 1
            else:
                for col in initial_cols:
                    self.board[row, col] = 1
        for row in range(5,8):
            if row % 2 == 0:
                for col in initial_cols:
                    self.board[row, col+1] = 2
            else:
                for col in initial_cols:
                    self.board[row, col] = 2
        self.board_flattened = np.reshape(self.board, [64])

    def make_non_capture_move(self, start_id, end_id):
        for square in self.legend_dict_flat:
            if self.legend_dict_flat[square] == start_id:
                start = square
            elif self.legend_dict_flat[square] == end_id:
                end = square
        if self.board_flattened[end] == 0:
            self.board_flattened[end] = self.board_flattened[start]
            self.board_flattened[start] = 0

def main():
    pass

if __name__ == '__main__':
    main()
'''
legend
-------------------------
|  |1 |  |2 |  |3 |  |4 |
|5 |  |6 |  |7 |  |8 |  |
|  |9 |  |10|  |11|  |12|
|13|  |14|  |15|  |16|  |
|  |17|  |18|  |19|  |20|
|21|  |22|  |23|  |24|  |
|  |25|  |26|  |27|  |28|
|29|  |30|  |31|  |32|  |
-------------------------
'''
