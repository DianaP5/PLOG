
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
                                                                 getColumn(Coluna, Linha)), 
                                                                 write(Coluna), write('_'),write(Linha).
                                                                 
                                                                 
/*getLine(Linha):- write('  Linha: '),
                                 get_code(Y), get_code(_),
                                 inverse_line(Y,Linha),
                                 write(Y), nl,
                                 validLine(Linha).*/
                                 
inverse_line(Lin, Y):- Y is Lin - 48.
                                 
%mudar numera��o das linhas para come�ar no numero 1
validLine(Linha):- Linha >= 0, Linha < 10.

validLine(Linha):- write('Linha Invalida!'),
                                        getLine(Linha).
                                 
/*getColumn(Coluna, Linha):- write('  Coluna: '),
                                        get_code(Y), get_code(_),
                                        inverse_column(Y, Coluna2),
                                        write(Y), nl, write(Coluna2), nl, write(Linha),
                                        validColumn(Coluna2, Linha),
                                        write('depois do valid'),write(Coluna2), write(Linha), nl,
                                        readCoords(Coluna2, Linha, Coluna),
                                        write('depois do read'),write(Coluna2), write(Coluna), nl.*/

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

movePieceToCell(X, Y, Board_Input, Name, Board_Output):-
        repeat,
        getCoordinates(X, Y),
        (getPiece(X, Y, Board_Input, Cell)
        ; 
        (write('Invalid coordinates'), nl, fail)), !,
        isFree(Cell),
        piece(Name, Piece),
        replace(Board_Input , X , Y , Piece , Board_Output).

test:- board(B), replace(B, 0, 0, b, Board), write(B), nl,write(Board), nl,B = Board, write(B).

% Verifies if piece is on right border %
isOnRightBorder(X, Y, Board):-
        nth0(Y, Board, ListY),
        length(ListY, Size),
        X =:= Size-1.

% Verificar a seguir a colocar peca %
checkWonGame(X, Y, Board, Name):-

        piece(Name, Piece), 

        /* Verify if there are four followed pieces in a row of the same type*/

        ((checkTwoRightPieces(X, Y, Board, Piece), checkFourthPieceRight(X, Y, Board, Piece))
        ;
        (checkTwoLeftPieces(X, Y, Board, Piece), checkFourthPieceLeft(X, Y, Board, Piece))
        ;
        (checkTwoRightPieces(X, Y, Board, Piece), checkBeforeAfterPieces(X, Y, Board, Piece))
        ;
        (checkTwoLeftPieces(X, Y, Board, Piece), checkBeforeAfterPieces(X, Y, Board, Piece))).


checkLostGame(X, Y, Board, Name):-

        piece(Name, Piece), 

        /* Verify if there are only three followed pieces in a row */

        ((checkTwoRightPieces(X, Y, Board, Piece))
        ;
        (checkTwoLeftPieces(X, Y, Board, Piece))
        ;
        (checkBeforeAfterPieces(X, Y, Board, Piece))).
        

checkTwoRightPieces(X, Y, Board, Piece) :- 
        X1 is X+1, isSamePiece(X1, Y, Board, Piece),
        X2 is X+2, isSamePiece(X2, Y, Board, Piece).

checkTwoLeftPieces(X, Y, Board, Piece) :- 
        X1 is X-1, isSamePiece(X1, Y, Board, Piece),
        X2 is X-2, isSamePiece(X2, Y, Board, Piece).

checkBeforeAfterPieces(X, Y, Board, Piece):-
        X1 is X+1, isSamePiece(X1, Y, Board, Piece),
        X2 is X-1, isSamePiece(X2, Y, Board, Piece).

checkFourthPieceRight(X, Y, Board, Piece):- 
        X1 is X+3, isSamePiece(X1, Y, Board, Piece).

checkFourthPieceLeft(X, Y, Board, Piece):- 
        X1 is X-3, isSamePiece(X1, Y, Board, Piece).


isSamePiece(X, Y, Board, Piece):- getPiece(X, Y, Board, Cell), Cell = Piece.
               
            
%game(+Level, +Tab, +Name1, +Name2)
play_game(Level, Board, Name1, Name2):- 
        board(Board), 
        display_board(Board), !,
        playing(Board, Name1, Name2, UpdateBoard).
        

playerTurn(Board, Name, UpdateBoard, X, Y):-
        nl, nl, write('  ------ '), write(Name), write(' ------'), nl,
        movePieceToCell(X, Y, Board, Name, UpdateBoard),
        display_board(UpdateBoard).

stopPlaying(X, Y, Board, Name) :-
        ((checkWonGame(X, Y, Board, Name), write('Player '), write(Name), write(' won the game.'), nl)
        ;
        (checkLostGame(X, Y, Board, Name), write('Player '), write(Name), write(' lost the game.'), nl)).
 

playing(Board, Name1, Name2, UpdateBoard):-
        playerTurn(Board, Name1, UpdateBoard1, X, Y), !,
        (\+ stopPlaying(X, Y, UpdateBoard1, Name1)), 

        %verificacao de paragem        
        playerTurn(UpdateBoard1, Name2, UpdateBoard2, X1, X2), !,
        (\+ stopPlaying(X1, Y1, UpdateBoard2, Name2)),

        %verificacao de paragem     
        playing(UpdateBoard2, Name1, Name2, UpdateBoard).

fim:- board(B), getPlayerName(Name1), assert(piece(Name1, b)), getPlayerName(Name2), assert(piece(Name2, w)), playing(B, Name1, Name2, Board).