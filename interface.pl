
:-consult('tabuleiro_hexagonal.pl').
:-consult('dataBase.pl').
:-consult('logic.pl').
:-consult('utils.pl').
:- dynamic piece/2.

%:-use_module(library(lists)).

yavalath:- start.

start:-          nl,write('+-----------------------------------------+'),nl,
                write('|                                         |'),nl,
                                write('|                                         |'),nl,
                write('|                YAVALATH                 |'),nl,
                write('|                                         |'),nl,
                                write('|                                         |'),nl,
                write('+-----------------------------------------+'),nl,nl,nl,
                menu.
                                

%menu principal
menu:- write(' _ _ _ _ _ _ _'), nl,
           write('|1. Start Game'), nl,
       write('|0. Quit'), nl, nl,
           get_code(Code), get_code(_),
           (Code =:= 49, nl, modoJogo).
          
modoJogo:- /*repeat,*/
                   nl,write('+-----------------------------------------+'),nl,
              write('|              Modos de Jogo              |'),nl,
                          write('+-----------------------------------------+'),nl,
                      write('|                                         |'),nl,
              write('|1. Humano vs Humano                      |'),nl,
              write('|2. Humano vs Computador                  |'),nl,
                      write('|3. Computador vs Computador              |'),nl,
                          write('|0. Voltar                                |'),nl,
              write('+-----------------------------------------+'),nl,nl,nl,
                          get_code(Code2), get_code(_), 
                          ((Code2 == 48, nl, modoJogo);
                          (Code2 == 49, nl, getPlayerName(Name1), assert(piece(Name1, b)), getPlayerName(Name2), assert(piece(Name2, w)), play_game(_, T, Name1, Name2));
                          (Code2 == 50, nl,dificuldadeJogo);
                          (Code2 == 51, nl, start)).
                          %play_game.
                          
                          
dificuldadeJogo:- write(' _ _ _ _ _ _ _'), nl,
                                  write('|1. Facil     '), nl,
                                  write('|2. Medium    '), nl,
                                  write('|3. Hard      '), nl,
                                  write('|0. Voltar    '), nl,nl,
                                  get_code(Code2), get_code(_),
                                  (Code2 =:= 48, nl, start).
                                  %play_game.
