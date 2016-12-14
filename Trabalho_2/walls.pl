:- ensure_loaded('displayTab.pl').

walls:-
	%initializeRandomSeed, !,
	start.

start:- nl,
	write('+================================+'), nl,
	write('+            Walls               +'), nl,
	write('+================================+'), nl,
	write('|                                |'), nl,
	write('|   1. Solve 3x3                 |'), nl,
	write('|   2. Solve 4x4                 |'), nl,
	write('|   3. Solve 5x5                 |'), nl,
	write('|   4. Solve 6x6                 |'), nl,
	write('|   5. Solve 7x7                 |'), nl,
	write('|   6. Solve 10x10               |'), nl,
	write('|                                |'), nl,
	write('|   9. Exit                      |'), nl,
	write('|                                |'), nl,
	write('+================================+'), nl, nl,
	write('Please choose an option:'), nl,
	getInt(Input),
	mainMenuAction(Input), !.
	

getInt(Input):-
	get_code(TempInput),
	get_code(_),
	Input is TempInput - 48.
	

mainMenuAction(1):- staticPuzzle3x3.
mainMenuAction(2):- staticPuzzle4x4.
mainMenuAction(3):- staticPuzzle5x5.
mainMenuAction(4):- staticPuzzle6x6.
mainMenuAction(5):- staticPuzzle7x7.
mainMenuAction(6):- staticPuzzle10x10.
mainMenuAction(8):- aboutMenu, !, start.
mainMenuAction(9).
mainMenuAction(_):- !, start.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

staticPuzzle3x3:-
	Blacks = [[1,1],[1],[1]],
	Whites = [[1],[1],[1]],
	startSolver(Blacks, Whites), !.
	
staticPuzzle4x4:-
	Blacks = [[2],[1],[2],[3]],
	Whites = [[1],[2],[1],[1]],
	startSolver(Blacks, Whites), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

startSolver(Blacks, Whites):-
	length(Blacks, BlackLength),
	length(Whites, WhiteLength),
	generateEmptyMatrix(Board, BlackLength, WhiteLength),
	printBoard(Board, Blacks, Whites),
	pressEnterToContinue.
	
startSolver(_,_):-
	write('\nERROR: could not find any suitable solution for the given problem!'), nl,
	pressEnterToContinue, nl, fail.
	
startSolver4x4(Blacks, Whites):-
	length(Blacks, BlackLength),
	length(Whites, WhiteLength),
	generateEmptyMatrix(Board, 4, 4),
	printBoard(Board, Blacks, Whites),
	pressEnterToContinue.
	
startSolver4x4(_,_):-
	write('\nERROR: could not find any suitable solution for the given problem!'), nl,
	pressEnterToContinue, nl, fail.

pressEnterToContinue:-
	write('Press <Enter> to continue...'), nl,
	get_code(_), !.
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

generateEmptyMatrix([], _, 0).
generateEmptyMatrix([H|T], Width, Height):-
	Height > 0,
	generateEmptyRow(H, Width),
	RemainingHeight is Height - 1,
	generateEmptyMatrix(T, Width, RemainingHeight), !.

generateEmptyRow([], 0).
generateEmptyRow([0|T],Width):-
	Width > 0,
	RemainingWidth is Width - 1,
	generateEmptyRow(T, RemainingWidth), !.