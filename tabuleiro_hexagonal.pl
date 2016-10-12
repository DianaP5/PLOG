/*Yavalath's board*/
         
board([[s, s, s, s, s],
       [s, s, s, s, s, s],
       [s, s, s, s, s, s, s],
       [s, s, s, s, s, s, s, s],
       [s, s, s, s, s, s, s, s, s],
       [s, s, s, s, s, s, s, s],
       [s, s, s, s, s, s, s],
       [s, s, s, s, s, s],
       [s, s, s, s, s]]).

ver:-board(T), display_board(T).

display_board([]):-nl.
display_top_line([]):- write('_'),nl.
display_bottom_line([]):- write(''\'_/'), nl.

display_board([L1|[L2|[L3|[L4|[L5|[L6|[L7|[L8|[L9]]]]]]]]]):-
        display_top_border,
        write('        '),
        display_top_line(L1),
        write('      '),
        display_top_line(L2),
        write('    '),
        display_top_line(L3),
        write('  '),
        display_top_line(L4),
        display_top_line(L5),
        write(' '),
        display_bottom_line(L6),
        write('   '),
        display_bottom_line(L7),
        write('     '),
        display_bottom_line(L8),
        write('       '),
        display_bottom_line(L9),
        write('         '),
        display_last_line.
        

display_top_border:-
        write('          _________________'), nl.

display_top_line([E|Es]):-
        translate(E,V),
        write('_/'),
        write(V),
        write(''\''),
        display_top_line(Es).

display_bottom_line([E|Es]):-
        translate(E, V),
        write(''\'_'),
        write('/'),
        write(V),
        display_bottom_line(Es).

display_last_line:-write(''\'_/_'\'_/_'\'_/_'\'_/_'\'_/').


translate(s, ' ').
%white
translate(w, 'o').
%black
translate(b, '*').

