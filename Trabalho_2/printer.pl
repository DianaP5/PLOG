
printBoard(Board):-
    length(Board, N),
    printSeparator(N),
    printBoardAux(Board, N),
    nl, !.

printResultBoard(Board, ListNumbers):-
    length(Board, N),
    printSeparator(N),
    printBoardSolvedAux(Board, 0, N, ListNumbers),
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


%print board solved
printBoardSolvedAux([], _, _, _).

printBoardSolvedAux([Row|Board], Y, N, ListNumbers):-
    write('    |'),
    createSeparator(N, '       |'), nl,
    write('    |'),
    printRowSolved(Row, 0, Y, ListNumbers, ListNumbers2), nl,!,
    write('    |'),
    createSeparator(N, '       |'), nl,
    printSeparator(N),
    Y1 is Y+1,
    printBoardSolvedAux(Board, Y1, N, ListNumbers2).

/*********************************************************************************************************/

%print empty row
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

%print solved row
printRowSolved([], _, _, ListNumbers, ListNumbers).

printRowSolved([H|Row], PosX, PosY, [[X, Y]|ListNumbers], ListNumbers2):-
    PosY == Y,
    PosX == X,  
    write('   '),
    write(H),
    write('   |'),
    PosX1 is PosX+1,
    printRowSolved(Row, PosX1, PosY, ListNumbers, ListNumbers2).


printRowSolved([H|Row], PosX, PosY, ListNumbers, ListNumbers2):-
    piece(H, Char),
    write('  '),
    write(Char),
    write('  |'),
    PosX1 is PosX+1,
    printRowSolved(Row, PosX1, PosY, ListNumbers, ListNumbers2).

printRowSolved([H|Row], PosX, PosY, ListNumbers, ListNumbers2):-
    
    write('   '),
    write(H),
    write('   |'),
    PosX1 is PosX+1,
    printRowSolved(Row, PosX1, PosY, ListNumbers, ListNumbers2).



/*********************************************************************************************************/

createSeparator(0, _).
createSeparator(N, SS):-
	N>0,
	write(SS),
	N1 is N - 1,
	createSeparator(N1, SS), !.

/*********************************************************************************************************/

piece(1, '---').
piece(0, ' | ').

/*********************************************************************************************************/