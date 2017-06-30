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
    "a"  => (" __ _", "/ _` |", "\\__,_|"),
    "b"  => (" _    ", " | |__ ", " | '_ \\", " |_.__/"),
    "c"  => (" __ ", " / _|", " \\__|"),
    "d"  => ("    _ ", "  __| |", " / _` |", " \\__,_|"),
    "e"  => (" ___ ", " / -_)", " \\___|"),
    "f"  => ("  __ ", "  / _|", " |  _|", " |_|  "),
    "g"  => (" __ _ ", " / _` |", " \\__, |", " \\__, |"),
    "h"  => (" _    ", " | |_  ", " | ' \\ ", " |_||_|"),
    "i"  => (" _ ", " (_)", " | |", " |_|"),
    "j"  => ("  _ ", "  (_)", "  | |", " _/ |", " |__/ "),
    "k"  => (" _   ", " | |__", " | / /", " |_\\_\\"),
    "l"  => (" _ ", " | |", " | |", " |_|"),
    "m"  => (" _ __  ", " | '  \\ ", " |_|_|_|"),
    "n"  => (" _ _  ", " | ' \\ ", " |_||_|"),
    "o"  => (" ___ ", " / _ \\", " \\___/"),
    "p"  => (" _ __ ", " | '_ \\", " | .__/", " |_|   "),
    "q"  => (" __ _ ", " / _` |", " \\__, |", "    |_|"),
    "r"  => (" _ _ ", " | '_|", " |_|  "),
    "s"  => (" ___", " (_-<", " /__/"),
    "t"  => (" _   ", " | |_ ", " |  _|", "  \\__|"),
    "u"  => (" _  _ ", " | || |", "  \\_,_|"),
    "v"  => ("__ __", " \\ V /", "  \\_/ "),
    "w"  => ("__ __ __", " \\ V  V /", "  \\_/\\_/ "),
    "x"  => ("__ __", " \\ \\ /", " /_\\_\\"),
    "y"  => (" _  _ ", " | || |", "  \\_, |", "  |__/ "),
    "z"  => (" ___", " |_ /", " /__|")
  );
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
  addstr(0,1,'*------------*');
  addstr(1,1,'| qq - quit  |');
  addstr(2,1,'| rr - reset |');
  addstr(3,1,'*------------*');
}

sub update_graphic {
  my $frame = $_[0];
  if($frame eq 1){
    add_head();
  } elsif($frame eq 2) {
    add_neck();
  } elsif($frame eq 3) {
    add_left_arm();
  } elsif($frame eq 4) {
    add_right_arm();
  } elsif($frame eq 5) {
    add_body();
  } elsif($frame eq 6) {
    add_left_leg();
  } elsif($frame eq 7) {
    add_right_leg();
    addstr($row -14, $col/2-5, 'your word was : '.$_[1]);
    addstr($row-1, $col/2-30, 'you killed him! do you want to play again? (y/n) ');
    my $answer = '';
    getstr($answer);
    chomp $answer;
    if($answer eq 'y'){
      play();
    } elsif ($answer eq 'n') {
      endwin();
      exit;
    } else {
      move($row-1, $col/2-30);
      clrtoeol();
      addstr($row-1, $col/2-10, 'please enter y or n: ');
      getstr($answer);
      chomp $answer;
      if($answer eq 'y'){
        play();
      } else {
        endwin();
        exit
      }
    }
  }
}

sub guess_box {
  my $display_col = $col-23;
  addstr(0,$display_col, "*---------------------*");
  addstr(1,$display_col, "|wrong:               |");
  addstr(2,$display_col, "*---------------------*");
}

sub display_win {
  addstr($row-1, $col/2-20, 'you win! do you want to play again? (y/n) ');
  my $answer = '';
  getstr($answer);
  chomp $answer;
  if($answer eq 'y'){
    play();
  } elsif ($answer eq 'n') {
    endwin();
    exit;
  } else {
    move($row-1, $col/2-30);
    clrtoeol();
    addstr($row-1, $col/2-10, 'please enter y or n: ');
    getstr($answer);
    chomp $answer;
    if($answer eq 'y'){
      play();
    } else {
      endwin();
      exit
    }
  }
}

sub play {
  clear();
  display_title();
  my $current_word = get_rand_word();
  my @current_wrong;
  chomp $current_word;
  display_underscores($current_word);
  # addstr(4,4,$current_word);
  populate_dict();
  display_gallows();
  add_legend();
  guess_box();

  my $input = '';
  my $guess_count = 0;
  my $correct_letter_count = 0;
  while($input ne 'qq'){
    move($row-2, $col/2);
    clrtoeol();
    addstr($row-2, $col/2-10, "enter your guess: ");
    getstr($input);
    move($row-1, $col/2-15);
    clrtoeol();
    chomp $input;
    if($input eq 'rr'){
      play();
    } elsif($input eq 'qq'){
      endwin();
      exit;
    } elsif($input ne 'a' && $input ne 'b' && $input ne 'c' && $input ne 'd' && $input ne 'e'
     && $input ne 'f' && $input ne 'g' && $input ne 'h' && $input ne 'i' && $input ne 'j'
     && $input ne 'k' && $input ne 'l' && $input ne 'm' && $input ne 'n' && $input ne 'o'
     && $input ne 'p' && $input ne 'q' && $input ne 'r' && $input ne 's' && $input ne 't'
     && $input ne 'u' && $input ne 'v' && $input ne 'w' && $input ne 'x' && $input ne 'y'
     && $input ne 'z') {
       addstr($row-1, $col/2-15, "please enter a valid letter");
    } else {
      my $already_guessed = 0;
      for(my $i=0; $i<scalar @current_wrong; $i++){
        if($current_wrong[$i] eq $input){
          $already_guessed = 1;
          addstr($row-1, $col/2-15, "please enter a new guess");
        }
      }
      if($already_guessed eq 0){
        my $letter_num = 0;
        my $found = 0;
        foreach my $char (split //, $current_word){
          if($char eq $input){
            my $display_col = $col/2 - (length($current_word)*9)/2;
            addstr($row-7, $display_col+9*($letter_num+1)-5, $input);
            $found = 1;
            $correct_letter_count++;
          }
          $letter_num++;
          if($correct_letter_count eq length($current_word)){
            display_win();
          }
        }
        if($found eq 0){
          $guess_count++;
          push @current_wrong, $input;
          addstr(1,$col-15+$guess_count, $input);
          update_graphic($guess_count, $current_word);
        }
      }
    }
  }
}

play();
endwin();
