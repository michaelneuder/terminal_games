#!/usr/bin/env python3
import curses
from checkers_backend import checkers_backend

class checkers_terminal:
    def __init__(self):
        self.stdscr = curses.initscr()
        self.backend = checkers_backend()
        curses.noecho()
        curses.start_color()
        curses.use_default_colors()
        curses.init_pair(1, 110, 16)
        curses.init_pair(2, 250, 23)
        curses.init_pair(3, 250, 13)
        curses.init_pair(4, 203, 16)
        curses.init_pair(5, 230, 16)
        self.stdscr.bkgdset(curses.color_pair(2))
        curses.curs_set(0)
        self.coords = self.stdscr.getmaxyx()
        self.start_col_board = int(self.coords[1]/2) - 24
        self.square_coords = {}
        self.square_colors = {}
        self.populate_square_colors()
        self.populate_square_coords()
        self.handle_user_input()
        self.stdscr.refresh()
        curses.endwin()

    def populate_square_coords(self):
        for i in range(64):
            self.square_coords[i] = [13+3*(int(i/8)), self.start_col_board + 6* (i%8)]

    def populate_square_colors(self):
        for i in range(64):
            if i < 8:
                self.square_colors[i] = i%2
            elif i < 16:
                self.square_colors[i] = 1-i%2
            elif i < 24:
                self.square_colors[i] = i%2
            elif i < 32:
                self.square_colors[i] = 1-i%2
            elif i < 40:
                self.square_colors[i] = i%2
            elif i < 48:
                self.square_colors[i] = 1-i%2
            elif i < 56:
                self.square_colors[i] = i%2
            elif i < 64:
                self.square_colors[i] = 1-i%2

    def print_title(self):
        col = int(self.coords[1]/2)-36
        self.stdscr.addstr(2,col, ' _______           _______  _______  _        _______  _______  _______ ')
        self.stdscr.addstr(3,col, '(  ____ \|\     /|(  ____ \(  ____ \| \    /\(  ____ \(  ____ )(  ____ \\')
        self.stdscr.addstr(4,col, '| (    \/| )   ( || (    \/| (    \/|  \  / /| (    \/| (    )|| (    \/')
        self.stdscr.addstr(5,col, '| |      | (___) || (__    | |      |  (_/ / | (__    | (____)|| (_____ ')
        self.stdscr.addstr(6,col, '| |      |  ___  ||  __)   | |      |   _ (  |  __)   |     __)(_____  )')
        self.stdscr.addstr(7,col, '| |      | (   ) || (      | |      |  ( \ \ | (      | (\ (         ) |')
        self.stdscr.addstr(8,col, '| (____/\| )   ( || (____/\| (____/\|  /  \ \| (____/\| ) \ \__/\____) |')
        self.stdscr.addstr(9,col, '(_______/|/     \|(_______/(_______/|_/    \/(_______/|/   \__/\_______)')
        self.stdscr.addstr(10,col, '------------------------------------------------------------------------')

    def print_frame(self):
        self.stdscr.hline(0,0,'-', self.coords[1]-1)
        self.stdscr.hline(self.coords[0]-1,0,'-', self.coords[1]-1)
        for row in range(self.coords[0]):
            self.stdscr.addstr(row, 0, '|')
            self.stdscr.addstr(row, self.coords[1]-2, '|')

    def print_board(self):
        for square in self.square_coords:
            row, col  = self.square_coords[square][0], self.square_coords[square][1]
            color = self.square_colors[square]
            if color == 0:
                self.print_white_sq(row, col)
            else:
                if self.backend.legend_dict_flat[square]:
                    square_id = self.backend.legend_dict_flat[square]
                    if square_id < 10:
                        square_id = '{} '.format(square_id)
                    if self.backend.board_flattened[square] == 0:
                        self.print_black_sq_empty(row, col, square_id)
                    elif self.backend.board_flattened[square] == 1:
                        self.print_black_sq_white(row, col,square_id)
                    elif self.backend.board_flattened[square] == 2:
                        self.print_black_sq_red(row, col,square_id)

    def print_white_sq(self, row, col):
        for i in range(3):
            self.stdscr.addstr(row+i,col,'      ', curses.color_pair(3))

    def print_black_sq_empty(self,row,col, cell_id):
        self.stdscr.addstr(row,col,'      ', curses.color_pair(5))
        self.stdscr.addstr(row+1,col,'  {}  '.format(cell_id), curses.color_pair(5))
        self.stdscr.addstr(row+2,col,'      ', curses.color_pair(5))

    def print_black_sq_white(self,row,col,cell_id):
        self.stdscr.addstr(row,col, '  ##  ', curses.color_pair(1))
        self.stdscr.addstr(row+1,col, '##{}##'.format(cell_id), curses.color_pair(1))
        self.stdscr.addstr(row+2,col, '  ##  ', curses.color_pair(1))

    def print_black_sq_red(self,row,col,cell_id):
        self.stdscr.addstr(row,col, '  ##  ', curses.color_pair(4))
        self.stdscr.addstr(row+1,col, '##{}##'.format(cell_id), curses.color_pair(4))
        self.stdscr.addstr(row+2,col, '  ##  ', curses.color_pair(4))

    def print_main_menu(self):
        self.stdscr.clear()
        col = int(self.coords[1]/2)
        self.print_title()
        self.print_frame()
        self.stdscr.addstr(15, col-14, ' _ __ ___    ___  _ __   _   _ ')
        self.stdscr.addstr(16, col-14, '| \'_ ` _ \  / _ \| \'_ \ | | | |')
        self.stdscr.addstr(17, col-14, '| | | | | ||  __/| | | || |_| |')
        self.stdscr.addstr(18, col-14, '|_| |_| |_| \___||_| |_| \__,_|')
        self.stdscr.addstr(19, col-14, '-------------------------------')
        self.stdscr.addstr(20, col-7, '(1) play game')
        self.stdscr.addstr(21, col-7, '(2) see rules')
        self.stdscr.addstr(22, col-7, '(3) quit')

    def handle_user_input(self):
        self.print_main_menu()
        user_input = 0
        while user_input != 'q' and user_input != '3':
            user_input = self.stdscr.getkey()
            if user_input == '1':
                if self.play_game() == -1:
                    user_input = 'q'
            elif user_input == '2':
                if self.print_rules() == -1:
                    user_input == 'q'

    def play_game(self):
        self.stdscr.clear()
        col = int(self.coords[1]/2)
        self.print_title()
        self.print_frame()
        self.print_board()
        self.stdscr.addstr(self.coords[0]-6, 1, '------------')
        self.stdscr.addstr(self.coords[0]-5, 1, 's - start  |')
        self.stdscr.addstr(self.coords[0]-4, 1, 'r - reset  |')
        self.stdscr.addstr(self.coords[0]-3, 1, 'm - menu   |')
        self.stdscr.addstr(self.coords[0]-2, 1, 'q - quit   |')
        user_input = 0
        while user_input != 'm' and user_input !='q':
            user_input = self.stdscr.getkey()
            if user_input == 'm':
                self.print_main_menu()
                return 1
            elif user_input == 'q':
                return -1
            elif user_input == 's':
                self.get_move()
            elif user_input == 'r':
                self.backend = checkers_backend()
                self.stdscr.clear()
                self.print_title()
                self.print_board()
                self.print_frame()
                self.stdscr.addstr(self.coords[0]-6, 1, '------------')
                self.stdscr.addstr(self.coords[0]-5, 1, 's - start  |')
                self.stdscr.addstr(self.coords[0]-4, 1, 'r - reset  |')
                self.stdscr.addstr(self.coords[0]-3, 1, 'm - menu   |')
                self.stdscr.addstr(self.coords[0]-2, 1, 'q - quit   |')
                self.stdscr.refresh()

    def get_move(self):
        curses.echo()
        curses.curs_set(1)
        self.stdscr.addstr(self.coords[0] - 3, int(self.coords[1]/2)-10, 'please enter the first square: ')
        start_square = self.stdscr.getstr()
        self.stdscr.move(self.coords[0] - 3, int(self.coords[1]/2)-10)
        self.stdscr.clrtoeol()
        self.print_frame()
        self.stdscr.refresh()
        self.stdscr.addstr(self.coords[0] - 3, int(self.coords[1]/2)-10, 'please enter the second square: ')
        end_square = self.stdscr.getstr()
        self.stdscr.move(self.coords[0] - 3, int(self.coords[1]/2)-10)
        self.stdscr.clrtoeol()
        self.print_frame()
        self.stdscr.refresh()
        curses.noecho()
        curses.curs_set(0)
        start = int(start_square)
        end = int(end_square)
        self.backend.make_non_capture_move(start,end)
        self.print_board()


    def print_rules(self):
        self.stdscr.clear()
        col = int(self.coords[1]/2)
        self.print_title()
        self.print_frame()
        self.stdscr.addstr(14, col-14, '              _            ')
        self.stdscr.addstr(15, col-14, ' _ __  _   _ | |  ___  ___ ')
        self.stdscr.addstr(16, col-14, '| \'__|| | | || | / _ \/ __|')
        self.stdscr.addstr(17, col-14, '| |   | |_| || ||  __/\__ \\')
        self.stdscr.addstr(18, col-14, '|_|    \__,_||_| \___||___/')
        self.stdscr.addstr(19, col-14, '---------------------------')
        self.stdscr.addstr(21, col-16, 'these are the rules of checkers')
        self.stdscr.addstr(self.coords[0]-4,1, '------------')
        self.stdscr.addstr(self.coords[0]-3,1, 'm - menu   |')
        self.stdscr.addstr(self.coords[0]-2,1, 'q - quit   |')
        user_input = 0
        while user_input != 'm' and user_input !='q':
            user_input = self.stdscr.getkey()
            if user_input == 'm':
                self.print_main_menu()
                return 1
            elif user_input == 'q':
                return -1

def main():
    term = checkers_terminal()

if __name__ == '__main__':
    main()
