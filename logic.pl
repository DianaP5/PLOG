
:-consult('tabuleiro_hexagonal.pl').
:-consult('utils.pl').
:-use_module(library(lists)).

%game(+Level, +Tab, +Name1, +Name2)
game(Level, Board, Name1, Name2):- board(Board), display_board(Board),
                                                                        processarMov(Level, Name1, Board, NewBoard, XCol, Linha, XFinal, YFinal), !.
                                                                        
                                                                                                                                                        
processarMov(Level, NamePlayer, Board, NewBoard, XCol, Linha, XFinal, YFinal):- 
                                                                                                getMove(NamePlayer, Coluna, Linha), !.
                                                                                                                                                        
                                                                                                                                                        
getMove(Player, Coluna, Linha):- 
                                                                 (nl, nl, write('  ------ '), write(Player), write(' ------'), nl,
                                                                 repeat, 
                                                                 getLine(Linha), !,
                                                                 %getColumn(Coluna)),
                                                                 getColumn(Coluna, Linha)), 
                                                                 write(Coluna), write('_'),write(Linha).
                                                                 
                                                                 
getLine(Linha):- write('  Linha: '),
                                 get_code(Y), get_code(_),
                                 inverse_line(Y,Linha),
                                 write(Y), nl,
                                 validLine(Linha).
                                 
inverse_line(Lin, Y):- Y is Lin - 48.
                                 
%mudar numeração das linhas para começar no numero 1
validLine(Linha):- Linha >= 0, Linha < 10.

validLine(Linha):- write('Linha Invalida!'),
                                        getLine(Linha).

/*getColumn(Coluna):- get_code(Y), get_code(_),
                                 inverse_column(Y,Coluna),
                                 write(Y), nl.
                                 %validColumn(Coluna).*/
                                 
getColumn(Coluna, Linha):- write('  Coluna: '),
                                        get_code(Y), get_code(_),
                                        inverse_column(Y, Coluna2),
                                        write(Y), nl, write(Coluna2), nl, write(Linha),
                                        validColumn(Coluna2, Linha),
                                        write('depois do valid'),write(Coluna2), write(Linha), nl,
                                        readCoords(Coluna2, Linha, Coluna),
                                        write('depois do read'),write(Coluna2), write(Coluna), nl.

inverse_column(Col, X):- X is Col - 65.
                                        
%validColumn(+Coluna, +Linha)
validColumn(Coluna, Linha):- (Coluna < 4, (write('  Coluna Invalida!'), nl, 
                                                                getColumn(Coluna, Linha))),
                                                        ((Linha < 6, XColuna is 4 + Linha);
                                                        (Linha > 5, XColuna is 9 - Linha + 5)),
                                                        Coluna =< XColuna.
                                                        
validColumn(Coluna, Linha):- (Coluna > 12, (write('  Coluna Invalida!'), nl,
                                                          getColumn(Coluna, Linha))).
                                                        
validColumn1(Coluna, Linha):- Coluna >= 0,
                                                        ((Linha < 6, XColuna is 4 + Linha);
                                                        (Linha > 5, XColuna is 9 - Linha + 5)),
                                                        Coluna =< XColuna.

%parseCoords(+Col, +Lin, -Res)
readCoords(Col, Lin, Res):- ((Lin < 6, Res is (Col + 5 - Lin));
                             (Lin > 5, Res is (Col + Lin - 5))).
                                                
                                                
                                                %%%%%%%%%%%%%%%%
                                        %%%%CELULAS VIZINHAS%%%%
                                                %%%%%%%%%%%%%%%%
                                                         
                
%casaVizinha(+L1, +C1, -L2, -C2)        (MESMA LINHA OU MESMA COLUNA)                    
casaVizinha(L1, C1, L2, C2):- (C2 is C1, L2 is L1 + 1).
casaVizinha(L1, C1, L2, C2):- (C2 is C1, L2 is L1 - 1).
casaVizinha(L1, C1, L2, C2):- (C2 is C1 + 1, L2 is L1).
casaVizinha(L1, C1, L2, C2):- (C2 is C1 - 1, L2 is L1).

%casaVizinha(+L1, +C1, -L2, -C2)        (MESMA DIAGONAL)
casaVizinha(L1, C1, L2, C2):- L1 < 5, ((C2 is C1 + 1, L2 is L1 - 1);
                                                                                (C2 is C1 - 1, L2 is L1 + 1)).
casaVizinha(L1, C1, L2, C2):- L1 > 5, ((C2 is C1 + 1, L2 is L1 + 1);
                                                                                (C2 is C1 - 1, L2 is L1 - 1)).
casaVizinha(L1, C1, L2, C2):- L1 =:= 5, ((C2 is C1, L2 is L1 - 1);
                                                                                (C2 is C1 + 1, L2 is L1 + 1)).
                                                                                
casaVizinha(L1, C1, L2, C2):- (C2 is C1, L2 is L1).








%isFree(s).
isBlack(b).
isWhite(w).


%nth0(?Y, ?List, ?Elem)

%append(?List1, ?List2, ?List1AndList2)

isFreeCell(X, Y, Board, Cell):-
        getPiece(X, Y, Board, Cell),
        isFree(Cell).

isBlackCell(X, Y, Board, Cell):-
        getPiece(X, Y, Board, Cell),
        isBlack(Cell).

isWhiteCell(X, Y, Board, Cell):-
        getPiece(X, Y, Board, Cell),
        isWhite(Cell).

/* get piece of board */
getPiece(X, Y, Board, Piece):-
        nth0(Y, Board, ListY),
        nth0(X, ListY, Piece).

movePieceToCell(X, Y, Board_Input, Piece, Board_Output):-
        getPiece(X, Y, Board_Input, Cell), 
        isFree(Cell),
        replace(Board_Input , X , Y , Piece , Board_Output ).


% Verifies if piece is on right border %
isOnRightBorder(X, Y, Board):-
        nth0(Y, Board, ListY),
        length(ListY, Size),
        write(Size),
        X =:= Size-1.

% Verificar a seguir a colocar peça %
betweenSamePiecesHorizontal(X, Y, Board, Piece):-
        ((X =:= 0, X1 is X+1, getPiece(X1, Y, Board, Cell), Cell = Piece)
        ;
        (X1 is X+1, getPiece(X1, Y, Board, Cell1), Cell1 = Piece, write(Cell1), X2 is X-1, getPiece(X2, Y, Board, Cell2), Cell2 = Piece)
        ;
        (X1 is X-1, getPiece(X1, Y, Board, Cell), Cell = Piece, isOnRightBorder(X, Y, Board))).
        
test:-board(T), betweenSamePiecesHorizontal(3, 1, T, b).


%test:-board(T), movePieceToCell(0, 0, T, w, Y), display_board(Y).


