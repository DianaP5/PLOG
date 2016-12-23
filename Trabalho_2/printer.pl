
printBoard(Board):-
    length(Board, N),
    printSeparator(N),
    printBoardAux(Board, N),
    nl, !.

printResultBoard(Board, Result, S):-
    length(Board, N),
    printSeparator(N),
    %printBoard(Board, 1, N, Result, S),
    nl, !.


printSeparator(N):-
    write('    +'),
    createSeparator(N, '-------+'), nl.

%print empty board
printBoardAux([], _).

printBoardAux([Row|Board], N):-
    write('    |'),
    createSeparator(N, '       |'), nl,
    write('    |'),
    printRow(Row), nl,!,
    write('    |'),
    createSeparator(N, '       |'), nl,
    printSeparator(N),
    printBoardAux(Board, N).

/*********************************************************************************************************/

printRow([]).

printRow([H|Row]):-
    integer(H),
    write('   '),
    write(H),
    write('   |'),
    printRow(Row).

printRow([H|Row]):-
    var(H),
    write('       |'),
    printRow(Row).

/*********************************************************************************************************/

createSeparator(0, _).
createSeparator(N, SS):-
	N>0,
	write(SS),
	N1 is N - 1,
	createSeparator(N1, SS), !.

/*********************************************************************************************************/


/*********************************************************************************************************/