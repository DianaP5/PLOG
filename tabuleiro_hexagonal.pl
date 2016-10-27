/*Yavalath's board*/

/***************        Board Representation          ******************/
board(  [[s, s, s, s, s],
         [s, s, s, s, s, s],
         [s, s, w, s, s, s, s],
         [s, s, s, s, b, s, s, s],
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
        display_top_board([L1|A], 0),
        display_bottom_board(B, 5).

/***    Display Top Half Board   ***/

display_top_board([], Aux).
display_top_board([L1|Ls], Aux):-
        S_max is 9,
        length(L1, S_list),
        S is S_max-S_list,
        %write(Aux),
        %write('|'),
        Aux1 is Aux+1,
        display_spaces(S+1),
        display_top_line1(L1),
        display_spaces(S),
        display_top_line2(L1),
        display_top_board(Ls, Aux1).


/***    Display Bottom Half Board   ***/
display_bottom_board([], Aux):- 
        S_max is 8,
        L1=[s, s, s, s],
        length(L1, S_list),
        S is S_max-S_list,
        display_spaces(S),
        display_bottom_line1(L1),
        write('---'),
        display_spaces(S),
        display_bottom_line2(L1).
display_bottom_board([L1|Ls], Aux):-
        S_max is 8,
        length(L1, S_list),
        S is S_max-S_list,
        %write(Aux),
        %write('|'),
        Aux1 is Aux+1,
        display_spaces(S),
        display_bottom_line1(L1),
        display_spaces(S),
        write('   '),
        display_bottom_line2(L1),
        display_bottom_board(Ls, Aux1).

/***    Display Top Line   ***/
display_top_line1([]):- nl.

display_top_line1([E|Es]):-
        translate(E,V),
        write('___  '),
        write(V),
        write('  '),
        display_top_line1(Es).


display_top_line2([]):- nl.

display_top_line2([E|Es]):-
        write('___/'),
        write('   '\''),
        display_top_line2(Es).



/***    Display Bottom Line   ***/
display_bottom_line1([]):- write('___  '), nl.

display_bottom_line1([E|Es]):-
        translate(E, V),
        write('___  '),
        write(V),
        write('  '),
        display_bottom_line1(Es).


display_bottom_line2([]):- write(''\'___/'),nl.

display_bottom_line2([E|Es]):-
        write(''\'___/   '),
        display_bottom_line2(Es).


/***    Display Spaces   ***/
display_spaces(0).

%S -> size of list
display_spaces(S):-
        S>0,
        write('----'),
        S1 is S-1,
        display_spaces(S1).



/***    Display Top Border   ***/
display_top_border:-
        write('   A B C D E_F_G_H_I_J_K_L_M N O P Q'), nl.


/***    Display Bottom Border   ***/
display_last_line:-
        display_spaces(4),
        write(
                display_spaces(5),
                write(''\'_/_'\'_/_'\'_/_'\'_/_'\'_/').




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


