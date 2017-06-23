#!/usr/bin/env perl
use strict;
use warnings;
use Curses;
use Time::HiRes qw( usleep );

# initialize
my $move = "enter a move (1-9) or q to quit: ";
my @current_board = (' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', );
my $h_line = "-----------";
my $h_line_long = "-------------";

# starting the curses screen
initscr();
getmaxyx(my $row, my $col);

sub print_title{
	addstr(1,40,'| | (_)               | |                      | |            ');
	addstr(2,40,'| |_ _  ___   ______  | |_ __ _  ___   ______  | |_ ___   ___');
	addstr(3,40,"| __| |/ __| |______| | __/ _` |/ __| |______| | __/ _ \\ / _ \\");
	addstr(4,40,'| |_| | (__           | || (_| | (__           | || (_) |  __/');
	addstr(5,40,' \__|_|\___|           \__\__,_|\___|           \__\___/ \___|');
	addstr(6,40,'==============================================================');
}

sub print_board{
	addstr($row/2 -6, $col/2-5, " $_[0] | $_[1] | $_[2] ");
	addstr($row/2 -5, $col/2-5, $h_line);
	addstr($row/2 -4, $col/2-5, " $_[3] | $_[4] | $_[5] ");
	addstr($row/2 -3, $col/2-5, $h_line);
	addstr($row/2 -2, $col/2-5, " $_[6] | $_[7] | $_[8] ");
	addstr($row/2+1, ($col - length($move))/2, $move);
	refresh();
}

sub print_legend{
	addstr(1 ,$col-10, "key");
	addstr(2, $col-15, $h_line_long);
	addstr(3, $col-15, "| 1 | 2 | 3 |");
	addstr(4, $col-15, $h_line_long);
	addstr(5, $col-15, "| 4 | 5 | 6 |");
	addstr(6, $col-15, $h_line_long);
	addstr(7, $col-15, "| 7 | 8 | 9 |");
	addstr(8, $col-15, $h_line_long);
	refresh();
}

sub check_cell{
	for(my $i = 1; $i<10; $i++){
		if($_[0] eq $i){
			return 1;
		}
	}
	return 0;
}

sub check_three{
	if($_[0] eq $_[1] && $_[1] eq $_[2] && $_[0] ne ' '){
		return 1;
	}
	return 0;
}

sub check_win{
	if(check_three($_[0], $_[1], $_[2]) || check_three($_[3], $_[4], $_[5]) ||
	   check_three($_[6], $_[7], $_[8]) || check_three($_[0], $_[3], $_[6]) ||
		 check_three($_[1], $_[4], $_[7]) || check_three($_[2], $_[5], $_[8]) ||
	   check_three($_[0], $_[4], $_[8]) || check_three($_[2], $_[4], $_[6])){
		return 1;
	}
	return 0;
}

sub check_draw{
	my $zeros_exist = 0;
	for(my $i=0; $i<9; $i++){
		if($_[$i] eq ' '){
			return 0;
		}
	}
	return 1;
}

sub check_input{
	if($_[0] ne '1' && $_[0] ne '2' && $_[0] ne '3' && $_[0] ne '4' && $_[0] ne '5' &&
	   $_[0] ne '6' && $_[0] ne '7' && $_[0] ne '8' && $_[0] ne '9'){
			 addstr($row - 2, 0, "please enter a valid input: digit 1-9 or q to quit.");
			 move($row/2+1, ($col + length($move))/2);
			 clrtoeol();
			 return 0;
		 }
		return 1;
}

sub replay{
	if($_[0] eq 1){
		return 1;
	} else {
		addstr($row-3, $col/2 -17, "do you want to play again? (y/n): ");
		my $response = '';
		while($response ne 'y' && $response ne 'yes' && $response ne 'n' && $response ne 'no' && $response ne 'q'){
			getstr($response);
			chomp $response;
			move($row-3, 0);
			clrtoeol();
			addstr($row-3, $col/2 -17,"please enter 'y' or 'n': ");
		}
		if($response eq 'y' || $response eq 'yes'){
			move($row-3, 0);
			clrtoeol();
			move($row-2, 0);
			clrtoeol();
			return 1;
		} else {
			move($row-3, $col/2);
			clrtoeol();
			return 0;
		}
	}
}

sub add_win_border{
	addstr(1,1,'+--------------------+');
	addstr(2,1,'|                    |');
	addstr(3,1,'|                    |');
	addstr(4,1,"|                    |");
	addstr(5,1,'|                    |');
	addstr(6,1,'|                    |');
	addstr(7,1,'|                    |');
	addstr(8,1,'+--------------------+');
	refresh();
}

sub add_main_border{
	addstr(8,1, '+--------------------+---------------------------------------------------------------------------------------------------------------------+');
	addstr($row-1,1, '+------------------------------------------------------------------------------------------------------------------------------------------+');
}

sub fire_works_animation{
	addstr($_[0],$_[1],'|         w          |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|         wi         |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|         win        |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|         winn       |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|         winne      |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|         winner     |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|         winner!!   |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|        winner!!    |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|       winner!!     |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|      winner!!      |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|     winner!!       |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|    winner!!        |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|   winner!!         |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|  winner!!          |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'| winner!!           |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|winner!!            |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|inner!!             |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|nner!!              |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|ner!!               |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|er!!                |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|r!!                 |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|!!                  |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|!                   |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();

	usleep(150000);
	addstr($_[0],$_[1],'|                    |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|          0         |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|                    |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|          0         |');
	addstr($_[0]+5,$_[1],'|          |         |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|                    |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|          0         |');
	addstr($_[0]+4,$_[1],'|          |         |');
	addstr($_[0]+5,$_[1],'|          |         |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|                    |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|          0         |");
	addstr($_[0]+3,$_[1],'|          |         |');
	addstr($_[0]+4,$_[1],'|          |         |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|                    |');
	addstr($_[0]+1,$_[1],'|          .         |');
	addstr($_[0]+2,$_[1],"|         .0.        |");
	addstr($_[0]+3,$_[1],'|          |         |');
	addstr($_[0]+4,$_[1],'|          |         |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|                    |');
	addstr($_[0]+1,$_[1],'|          `         |');
	addstr($_[0]+2,$_[1],"|         -0-        |");
	addstr($_[0]+3,$_[1],'|          |         |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|                    |');
	addstr($_[0]+1,$_[1],'|          |         |');
	addstr($_[0]+2,$_[1],"|        --0--       |");
	addstr($_[0]+3,$_[1],'|          |         |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|                    |');
	addstr($_[0]+1,$_[1],'|          |         |');
	addstr($_[0]+2,$_[1],"|        --0--       |");
	addstr($_[0]+3,$_[1],'|          |         |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|         \'          |');
	addstr($_[0]+1,$_[1],'|          |         |');
	addstr($_[0]+2,$_[1],"|       ---0---      |");
	addstr($_[0]+3,$_[1],'|          |         |');
	addstr($_[0]+4,$_[1],'|          ,         |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|          |         |');
	addstr($_[0]+1,$_[1],'|        \ | /       |');
	addstr($_[0]+2,$_[1],"|       -- 0 --      |");
	addstr($_[0]+3,$_[1],'|        / | \       |');
	addstr($_[0]+4,$_[1],'|          |         |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|          |         |');
	addstr($_[0]+1,$_[1],'|        \ | /       |');
	addstr($_[0]+2,$_[1],"|     -  - 0 -  -    |");
	addstr($_[0]+3,$_[1],'|        / | \       |');
	addstr($_[0]+4,$_[1],'|          |         |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|       \  |  /      |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|     -  - 0 -  -    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|       /  |  \      |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|          `         |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|  -    -  0  -    - |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|    /     |     \   |');
	refresh();
	usleep(150000);
	addstr($_[0],$_[1],'|                    |');
	addstr($_[0]+1,$_[1],'|                    |');
	addstr($_[0]+2,$_[1],"|                    |");
	addstr($_[0]+3,$_[1],'|                    |');
	addstr($_[0]+4,$_[1],'|                    |');
	addstr($_[0]+5,$_[1],'|                    |');
	refresh();
	}

sub play_game{
	print_legend();
	add_win_border();
	add_main_border();
	print_board(@_);
	my $input = '';
	my $move_number = 1;
	while($input ne 'q'){
		getstr($input);
		chomp $input;
		if($input eq 'q'){
			endwin();
			exit;
		}
		if(check_input($input)){
			if($_[$input-1] eq ' '){
				if($move_number % 2 eq 1){
					$_[$input-1] = 'x';
					print_board(@_);
					move($row/2+1, ($col + length($move))/2);
					clrtoeol();
					$move_number++;
					if(check_win(@_)){
						move($row-2, 0);
						clrtoeol();
						addstr($row -2, 1, "player x wins!!");
						fire_works_animation(2,1);
						return;
					}
					if(check_draw(@_)){
						move($row-2, 0);
						clrtoeol();
						addstr($row -2, 1, "draw game!!");
						return;
					}
				} else {
					$_[$input-1] = 'o';
					print_board(@_);
					move($row/2+1, ($col + length($move))/2);
					clrtoeol();
					$move_number++;
					if(check_win(@_)){
						move($row-2, 0);
						clrtoeol();
						addstr($row -2, 1, "player o wins!!");
						fire_works_animation(2,1);
						return;
					}
				}
			} else {
					move($row - 2, 0);
					clrtoeol();
					addstr($row - 2, 1, "please enter an empty square");
					move($row/2+1, ($col + length($move))/2);
					clrtoeol();
			}
		}
	}
}

print_title();
my $game_1_check = 1;
while(replay($game_1_check)){
	@current_board = (' ',' ',' ',' ',' ',' ',' ',' ',' ');
	play_game(@current_board);
	$game_1_check++;
}
endwin();
