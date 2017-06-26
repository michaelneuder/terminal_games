#!/usr/bin/env perl
use strict;
use warnings;
use Curses;
use IO::File;

initscr();
getmaxyx(my $row, my $col);

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
  my $word = get_rand_word();
  chomp $word;
  my $word_length = length($word);
  addstr($row-1, 0, "your word has ".$word_length." letters");
  my $display_col = $col/2 - ($word_length*9)/2;
  for(my $i=0; $i<$word_length; $i++){
    addstr(20, $display_col+(9*$i), "________  ");
  }
}

display_title();
noecho();
display_underscores();

getch();
endwin();
