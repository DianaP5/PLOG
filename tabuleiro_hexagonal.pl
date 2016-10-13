/*Yavalath's board*/
         
/***************        Board Representation          ******************/
board([[s, s, s, s, s],
       [s, s, s, s, s, s],
       [s, s, s, s, s, s, s],
       [s, s, s, s, s, s, s, s],
       [s, s, s, s, s, s, s, s, s],
       [s, s, s, s, s, s, s, s],
       [s, s, s, s, s, s, s],
       [s, s, s, s, s, s],
       [s, s, s, s, s]]).

play_game:-board(T), display_board(T).



/***************        Board Visualization          ******************/

/***    Display Board   ***/
display_board([]):-nl.

display_board([L1|Ls]):-
        div(Ls, A, B),
        display_top_border,
        display_top_board([L1|A]),
        display_bottom_board(B).

/***    Display Top Half Board   ***/
display_top_board([]).
display_top_board([L1|Ls]):-
        S_max is 9,
        length(L1, S_list),
        S is S_max-S_list,
        display_spaces(S),
        display_top_line(L1),
        display_top_board(Ls).


/***    Display Bottom Half Board   ***/
display_bottom_board([]):-display_last_line.
display_bottom_board([L1|Ls]):-
        S_max is 8,
        length(L1, S_list),
        S is S_max-S_list,
        display_spaces(S),
        display_bottom_line(L1),
        display_bottom_board(Ls).

/***    Display Top Line   ***/
display_top_line([]):- nl.

display_top_line([E|Es]):-
        translate(E,V),
        write('/'),
        write(V),
        write(''\'_'),
        display_top_line(Es).



/***    Display Bottom Line   ***/
display_bottom_line([]):- write(''\'_/'), nl.

display_bottom_line([E|Es]):-
        translate(E, V),
        write(''\'_'),
        write('/'),
        write(V),
        display_bottom_line(Es).



/***    Display Spaces   ***/
display_spaces(0).

%S -> size of list
display_spaces(S):-
        S>0,
        write('  '),
        S1 is S-1,
        display_spaces(S1).



/***    Display Top Border   ***/
display_top_border:-
        write('         _________________'), nl.


/***    Display Bottom Border   ***/
display_last_line:-write('        '\'_/_'\'_/_'\'_/_'\'_/_'\'_/').



           
/***    Splits list in two equal lists   ***/
div(L, A, B) :-
    split(L, L, A, B).

split(B, [], [], B).

split([H|T], [_, _|T1], [H | T2], B) :-
    split(T, T1, T2, B).



/* Translates*/
translate(s, ' ').
%white
translate(w, 'o').
%black
translate(b, '*').

