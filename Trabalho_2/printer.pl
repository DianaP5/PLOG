
printBoard(Board):-
    length(Board, N),
    printBoardTopBorder(N),
    %printBoard(Board, 1, N),
    nl, !.

printResultBoard(Board, Result, S):-
    length(Board, N),
    printBoardTopBorder(N),
    %printBoard(Board, 1, N, Result, S),
    nl, !.


printBoardTopBorder(N):-
    write('    +'),
    createSeparator(N, '------+'), nl.


/*********************************************************************************************************/

createSeparator(0, _).
createSeparator(N, SS):-
	N>0,
	write(SS),
	N1 is N - 1,
	createSeparator(N1, SS), !.

/*********************************************************************************************************/


/*********************************************************************************************************/


/*********************************************************************************************************/