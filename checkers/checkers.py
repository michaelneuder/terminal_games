#!/usr/bin/env python3
import numpy as np
from termcolor import colored, cprint

class checkers(object):
    def __init__(self):
        self.board = np.zeros([8,8], np.uint8)
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

    def print_board(self):
        self.print_h_line()
        cprint('----------- board ----------------------------- legend -------------------','white','on_grey')
        self.print_h_line()
        legend_labels = [1,2,3,4]
        for row in range(8):
            for col in range(8):
                cprint('|', 'white', 'on_grey', end='')
                if self.board[row,col] == 0:
                    cprint('   ', 'white', 'on_grey', end='')
                elif self.board[row,col] == 1:
                    cprint(' o ', 'red', 'on_grey', end='')
                elif self.board[row,col] == 2:
                    cprint(' o ', 'blue', 'on_grey', end='')
            cprint('|', 'white', 'on_grey', end='')
            if row % 2 == 0 and (row == 0):
                cprint('|    | {}  |    | {}  |    | {}  |    | {}  |'.format(4*row+legend_labels[0],4*row+legend_labels[1],4*row+legend_labels[2],4*row+legend_labels[3]),'white', 'on_grey')
            elif row % 2 == 0 and (row != 2):
                cprint('|    | {} |    | {} |    | {} |    | {} |'.format(4*row+legend_labels[0],4*row+legend_labels[1],4*row+legend_labels[2],4*row+legend_labels[3]),'white', 'on_grey')
            elif row == 1:
                cprint('| {}  |    | {}  |    | {}  |    | {}  |    |'.format(4*row+legend_labels[0],4*row+legend_labels[1],4*row+legend_labels[2],4*row+legend_labels[3]),'white', 'on_grey')
            elif row == 2:
                cprint('|    | {}  |    | {} |    | {} |    | {} |'.format(4*row+legend_labels[0],4*row+legend_labels[1],4*row+legend_labels[2],4*row+legend_labels[3]),'white', 'on_grey')
            else:
                cprint('| {} |    | {} |    | {} |    | {} |    |'.format(4*row+legend_labels[0],4*row+legend_labels[1],4*row+legend_labels[2],4*row+legend_labels[3]),'white', 'on_grey')
            self.print_h_line()

    def print_h_line(self):
        cprint('--------------------------------------------------------------------------', 'white', 'on_grey')

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

    def make_non_capture_move(self, start, end):
        if self.board[end[0], end[1]] == 0:
            self.board[end[0], end[1]] = self.board[start[0], start[1]]
            self.board[start[0], start[1]] = 0
            self.print_board()

def main():
    check1 = checkers()
    check1.print_board()
    start = input('enter the start square: ')
    end = input('enter the end square: ')
    check1.make_non_capture_move(check1.legend_dict[int(start)], check1.legend_dict[int(end)])



if __name__ == '__main__':
    main()
