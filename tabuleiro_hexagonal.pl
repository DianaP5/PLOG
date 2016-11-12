/*Yavalath's board*/
         
/***************        Board Representation          ******************/
board(  [[s, s, s, s, s],
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
        get_max_size([L1|Ls], S_max, 0),
        div(Ls, A, B),
        length(L1, S_list),
        S is S_max-S_list,
        display_spaces(S+1),
        display_first_line(L1),
        display_top_board([L1|A], S_max),
        display_bottom_board(B, S_max).

/***    Display Top Half Board   ***/

display_top_board([Ls], S_max):- 
        length(Ls, S_list),
        S is S_max-S_list,
        display_spaces(S+1),
        display_top_line(Ls),
        display_spaces(S+1),
        display_char_line_bottom(Ls),
        display_spaces(S+1),
        display_bottom_line(Ls).


display_top_board([L1|Ls], S_max):-
        length(L1, S_list),
        S is S_max-S_list,
        display_spaces(S+1),
        display_top_line(L1),
        display_spaces(S),
        display_char_line_top(L1),
        display_top_board(Ls, S_max).



/***    Display Bottom Half Board   ***/

display_bottom_board([], S_max):- nl.
display_bottom_board([L1|Ls], S_max):-
        length(L1, S_list),
        S is S_max-S_list,
        display_spaces(S+1),
        display_char_line_bottom(L1),
        display_spaces(S+1),
        display_bottom_line(L1),
        display_bottom_board(Ls, S_max).


/***    Display First Line of Board  ***/
display_first_line([E]):-
        write(' ___'), nl.

display_first_line([E|Es]):-
        write(' ___    '),
        display_first_line(Es).
        

/* Display Top Line */
display_top_line([E]):-
        write('/   '\''), nl.

display_top_line([E|Es]):-
        write('/   '\'___'),
        display_top_line(Es).


/* Display Char line Top */

display_char_line_top([]):- 
        write(' ___'), nl.

display_char_line_top([E|Es]):-
        translate(E, V),
        write(' ___  '),
        write(V),
        write(' '),
        display_char_line_top(Es).



/***    Display Bottom Line   ***/
display_bottom_line([]):- nl.

display_bottom_line([E|Es]):-
        write(''\'___'),
        write('/   '),
        display_bottom_line(Es).


/* Display Char line Bottom */

display_char_line_bottom([E]):- 
        translate(E, V),
        write('  '),
        write(V),
        write('  '), nl.

display_char_line_bottom([E|Es]):-
        translate(E, V),
        write('  '),
        write(V),
        write('  ___'),
        display_char_line_bottom(Es).



/***    Display Spaces   ***/
display_spaces(0).

%S -> size of list
display_spaces(S):-
        S>0,
        write('    '),
        S1 is S-1,
        display_spaces(S1).


/* Get Size of longest list */
get_max_size([], Size, MaxSize):-Size is MaxSize, 
        write(Size), nl.

get_max_size([L1|Ls], Size, MaxSize):-
        length(L1, S),
        Size1 is max(MaxSize, S),
        get_max_size(Ls, Size, Size1).

           
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


