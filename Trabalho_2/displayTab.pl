% imprime no ecrã os delimitadores das células do tabuleiro
createSeparator(0, _).
createSeparator(N, SS):-
	write(SS),
	N1 is N - 1,
	createSeparator(N1, SS), !.
	
	
% escolhe uma das duas representações do tabuleiro com base no tamanho deste
printBoard(Board, Black, White):-
	length(White, Length),
	Length > 11, !.
	%printBoardAuxMinified(Board, Black, White).
printBoard(Board, Black, White):-
	printBoardAux(Board, Black, White).
	
	
% imprime no ecrã uma representação do tabuleiro de jogo (tamanho normal)
printBoardAux(Board, Black, White):-
	%printBlack(Black),
	write('    +'),
	length(Black, Length),
	createSeparator(Length, '------+'), nl,
	printRows(Board, Length, White), nl, !.
	
% imprime no ecrã todas as linhas do tabuleiro (tamanho normal)
printRows([], _, []).
printRows([H|T], Length, [White|Next]):-
	printRow(H, Length, White),
	printRows(T, Length, Next), !.
	
% imprime no ecrã uma linha do tabuleiro (tamanho normal)
printRow(Row, Length, White):-
	write('    | '),
	printLine(Row),
	write('\n    | '),
	printLine(Row),
	%printWhite(White),
	write('\n    | '),
	printLine(Row),
	write('\n    +'),
	createSeparator(Length, '------+'), nl, !.
	
% imprime no ecrã uma linha do tabuleiro (tamanho normal)
printLine([]).
printLine([H|T]):-
	piece(H, Char),
	write(Char),
	write(' | '),
	printLine(T), !.
	
	
piece(1, '----').
piece(0, '    ').
	
