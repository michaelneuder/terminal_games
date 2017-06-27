#!/usr/bin/env perl
use strict;
use warnings;
use Curses;
use IO::File;

initscr();
getmaxyx(my $row, my $col);
my %dictionary;

sub display_title {
  my $col_title = $col/2-30;
  addstr(2,$col_title,"          _______  _        _______  _______  _______  _       ");
  addstr(3,$col_title,"|\\     /|(  ___  )( (    /|(  ____ \\(       )(  ___  )( (    /|");
  addstr(4,$col_title,"| )   ( || (   ) ||  \\  ( || (    \\/| () () || (   ) ||  \\  ( |");
  addstr(5,$col_title,"| (___) || (___) ||   \\ | || |      | || || || (___) ||   \\ | |");
  addstr(6,$col_title,"|  ___  ||  ___  || (\\ \\) || | ____ | |(_)| ||  ___  || (\\ \\) |");
  addstr(7,$col_title,"| (   ) || (   ) || | \\   || | \\_  )| |   | || (   ) || | \\   |");
  addstr(8,$col_title,"| )   ( || )   ( || )  \\  || (___) || )   ( || )   ( || )  \\  |");
  addstr(9,$col_title,"|/     \\||/     \\||/    )_)(_______)|/     \\||/     \\||/    )_)");
}

sub populate_dict {
  %dictionary = (
    "a"  => " __ _ \n/ _` |\n\\__,_|\n",);
}

sub get_rand_word {
  my $rand_num = int(rand(213));
  my $file = 'words/hangman_words';
  open my $info, $file or die "Could not open $file: $!";
  my $count = 0;
  while( my $line = <$info>)  {
    $count++;
    if ($count == $rand_num) {
      return $line;
    }
  }
}

sub display_underscores {
  my $word = $_[0];
  chomp $word;
  my $word_length = length($word);
  move($row-1, 0);
  clrtoeol();
  addstr($row-1, 0, "your word has ".$word_length." letters");
  my $display_col = $col/2 - ($word_length*9)/2;
  move($row-7, 0);
  clrtoeol();
  for(my $i=0; $i<$word_length; $i++){
    addstr($row-7, $display_col+(9*$i), "________  ");
  }
}

sub display_gallows {
  addstr(14, $col/2-5, "  ---------|       ");
  addstr(15, $col/2-5, "  |        |       ");
  addstr(16, $col/2-5, "           |       ");
  addstr(17, $col/2-5, "           |       ");
  addstr(18, $col/2-5, "           |       ");
  addstr(19, $col/2-5, "           |       ");
  addstr(20, $col/2-5, "           |       ");
  addstr(21, $col/2-5, "   ________|_______");
}

sub add_head {
  move(16, $col/2-5);
  clrtoeol();
  addstr(16, $col/2-5, "  O        |       ");
}

sub add_neck {
  move(17, $col/2-5);
  clrtoeol();
  addstr(17, $col/2-5, "  |        |       ");
}

sub add_left_arm {
  move(17, $col/2-5);
  clrtoeol();
  addstr(17, $col/2-5, "\\ |        |       ");
}

sub add_right_arm {
  move(17, $col/2-5);
  clrtoeol();
  addstr(17, $col/2-5, "\\ | /      |       ");
}

sub add_body {
  move(18, $col/2-5);
  clrtoeol();
  addstr(18, $col/2-5, "  |        |       ");
}

sub add_left_leg {
  move(19, $col/2-5);
  clrtoeol();
  addstr(19, $col/2-5, " /         |       ");
}

sub add_right_leg {
  move(19, $col/2-5);
  clrtoeol();
  addstr(19, $col/2-5, " / \\       |       ");
}

sub add_legend {
  addstr(0,1,'--------------');
  addstr(1,1,'| qq - quit  |');
  addstr(2,1,'| rr - reset |');
  addstr(3,1,'--------------');
}

sub play {
  display_title();
  my $current_word = get_rand_word();
  display_underscores($current_word);
  populate_dict();
  display_gallows();
  add_legend();

  my $input = '';
  my $guess_count = 0;
  while($input ne 'qq'){
    move($row-2, $col/2);
    clrtoeol();
    addstr($row-2, $col/2-10, "enter your guess: ");
    getstr($input);
    chomp $input;
    if($input eq 'rr'){
      play();
    } elsif($input eq 'qq'){
      endwin();
      exit;
    } else {
      for
    }
  }
}

play();
endwin();

#### useful stuff
# display_gallows();
# getch();
# add_head();
# getch();
# add_neck();
# getch();
# add_left_arm();
# getch();
# add_right_arm();
# getch();
# add_body();
# getch();
# add_left_leg();
# getch();
# add_right_leg();
# getch();
