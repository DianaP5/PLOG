/*Tabuleiro do Jogo Yavalath*/

%s - empty space
%a - doesn't matter

tabuleiro([[a, a, a, a, b1, s, s, s, s, s, b2],
      [a, a, a, b1, s, s, s, s, s, s, b2],
      [a, a, b1, s, s, s, s, s, s, s, b2],
      [a, b1, s, s, s, s, s, s, s, s, b2],
      [b3, s, s, s, s, s, s, s, s, s, b3],
      [a, b2, s, s, s, s, s, s, s, s, b1],
      [a, a, b2, s, s, s, s, s, s, s, b1],
      [a, a, a, b2, s, s, s, s, s, s, b1],
      [a, a, a, a, b2, s, s, s, s, s, b1]]).

display:-tabuleiro(T), display_borda_cima, display_tab(T).

display_tab([]):-display_borda_baixo.
display_linha([]).

display_borda_cima :- write('     _________'), nl.
display_borda_baixo:- write('     ---------').

display_tab([L1|Ls]):-
        display_linha(L1),
        nl,
        display_tab(Ls).

display_linha([E|Es]):-
        translate(E,V),
        write(V),
        display_linha(Es).


translate(a, ' ').
translate(s, 's ').
translate(b1, '/').
translate(b2, ''\'').
translate(b3, '|').