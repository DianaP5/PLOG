
:-consult('tabuleiro_hexagonal.pl').
:-consult('utils.pl').
:-use_module(library(lists)).
:-use_module(library(random)).


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


/**----------------- PIECE -------------------**/
isFreeCell(X, Y, Board, Cell):-
        getPiece(X, Y, Board, Cell),
        isFree(Cell).

isBlackCell(X, Y, Board, Cell):-
        getPiece(X, Y, Board, Cell),
        isBlack(Cell).

isWhiteCell(X, Y, Board, Cell):-
        getPiece(X, Y, Board, Cell),
        isWhite(Cell).


getPiece(X, Y, Board, Piece):-
        nth0(Y, Board, ListY),
        nth0(X, ListY, Piece).


movePieceToCell(X, Y, Board_Input, Name, Board_Output):-
        repeat,
        getCoordinates(X, Y),
        ((getPiece(X, Y, Board_Input, Cell), isFree(Cell))
        ; 
        (write('Invalid coordinates'), nl, fail)), !,
        piece(Name, Piece),
        replace(Board_Input , X , Y , Piece , Board_Output).



isSamePiece(X, Y, Board, Piece):- getPiece(X, Y, Board, Cell), Cell = Piece.


/**----------------- WIN GAME -------------------**/
checkWonGame(X, Y, Board, Name):-

        piece(Name, Piece), 

        /* Verify if there are four followed pieces in a row of the same type*/
        (
        (checkTwoRightPieces(X, Y, Board, Piece), checkBeforeAfterPieces(X, Y, Board, Piece))
        ;
        (checkTwoLeftPieces(X, Y, Board, Piece), checkBeforeAfterPieces(X, Y, Board, Piece))
        ;
        (checkBetweenPieces1(X, Y, Board, Piece), checkTwoDownPieces1(X, Y, Board, Piece))
        ;
        (checkBetweenPieces1(X, Y, Board, Piece), checkTwoUpPieces1(X, Y, Board, Piece))
        ;
        (checkBetweenPieces2(X, Y, Board, Piece), checkTwoDownPieces2(X, Y, Board, Piece))
        ;
        (checkBetweenPieces2(X, Y, Board, Piece), checkTwoUpPieces2(X, Y, Board, Piece))
        
        ).


/**----------------- LOST GAME -------------------**/
checkLostGame(X, Y, Board, Name):-

        piece(Name, Piece), 

        /* Verify if there are only three followed pieces in a row */

        ((checkTwoRightPieces(X, Y, Board, Piece))
        ;
        (checkTwoLeftPieces(X, Y, Board, Piece))
        ;
        (checkBeforeAfterPieces(X, Y, Board, Piece))
        ;
        (checkBetweenPieces1(X, Y, Board, Piece))
        ;
        (checkTwoDownPieces1(X, Y, Board, Piece))
        ;
        (checkTwoUpPieces1(X, Y, Board, Piece))
        ;
        (checkBetweenPieces2(X, Y, Board, Piece))
        ;
        (checkTwoDownPieces2(X, Y, Board, Piece))
        ;
        (checkTwoUpPieces2(X, Y, Board, Piece))
        ).
        

/**----------------- HORIZONTAL -------------------**/
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


/**----------------- DIAGONAL 1 (Right Bottom)-------------------**/

checkBetweenPieces1(X, Y, Board, Piece):-
        ((Y < 4, X1 is X+1, Y1 is Y+1, isSamePiece(X1, Y1, Board, Piece),
        X2 is X-1, Y2 is Y-1, isSamePiece(X2, Y2, Board, Piece))
        ;
        (Y =:= 4, X1 is X-1, Y1 is Y-1, isSamePiece(X1, Y1, Board, Piece),
        Y2 is Y+1, isSamePiece(X, Y2, Board, Piece))
        ;
        (Y>4, Y1 is Y+1, isSamePiece(X, Y1, Board, Piece),
        Y2 is Y-1, isSamePiece(X, Y2, Board, Piece))).

checkTwoDownPieces1(X, Y, Board, Piece):-
        ((Y < 3, X1 is X+1, Y1 is Y+1, isSamePiece(X1, Y1, Board, Piece),
        X2 is X+2, Y2 is Y+2, isSamePiece(X2, Y2, Board, Piece))
        ;
        (Y =:= 3, X1 is X+1, Y1 is Y+1, isSamePiece(X1, Y1, Board, Piece),
        X2 is X+1, Y2 is Y+2, isSamePiece(X2, Y2, Board, Piece))
        ;
        (Y>3, Y1 is Y+1, isSamePiece(X, Y1, Board, Piece),
        Y2 is Y+2, isSamePiece(X, Y2, Board, Piece))).

checkTwoUpPieces1(X, Y, Board, Piece):-
        ((Y < 5, X1 is X-1, Y1 is Y-1, isSamePiece(X1, Y1, Board, Piece),
        X2 is X-2, Y2 is Y-2, isSamePiece(X2, Y2, Board, Piece))
        ;
        (Y =:= 5, Y1 is Y-1, isSamePiece(X, Y1, Board, Piece),
        X2 is X-1, Y2 is Y-2, isSamePiece(X2, Y2, Board, Piece))
        ;
        (Y>5, Y1 is Y-1, isSamePiece(X, Y1, Board, Piece),
        Y2 is Y-2, isSamePiece(X, Y2, Board, Piece))).


/**----------------- DIAGONAL 2 (Right Up)-------------------**/

checkBetweenPieces2(X, Y, Board, Piece):-
        ((Y < 4, Y1 is Y+1, isSamePiece(X, Y1, Board, Piece),
        Y2 is Y-1, isSamePiece(X, Y2, Board, Piece))
        ;
        (Y =:= 4, Y1 is Y-1, isSamePiece(X, Y1, Board, Piece),
        X2 is X-1, Y2 is Y+1, isSamePiece(X2, Y2, Board, Piece))
        ;
        (Y > 4, X1 is X+1, Y1 is Y-1, isSamePiece(X1, Y1, Board, Piece),
        X2 is X-1, Y2 is Y+1, isSamePiece(X2, Y2, Board, Piece))).

checkTwoDownPieces2(X, Y, Board, Piece):-
        ((Y < 3, Y1 is Y+1, isSamePiece(X, Y1, Board, Piece),
        Y2 is Y+2, isSamePiece(X, Y2, Board, Piece))
        ;
        (Y =:= 3, Y1 is Y+1, isSamePiece(X, Y1, Board, Piece),
        X2 is X-1, Y2 is Y+2, isSamePiece(X2, Y2, Board, Piece))
        ;
        (Y > 3, X1 is X-1, Y1 is Y+1, isSamePiece(X1, Y1, Board, Piece),
        X2 is X-2, Y2 is Y+2, isSamePiece(X2, Y2, Board, Piece))).

checkTwoUpPieces2(X, Y, Board, Piece):-
        ((Y < 5, Y1 is Y-1, isSamePiece(X, Y1, Board, Piece),
        Y2 is Y-2, isSamePiece(X, Y2, Board, Piece))
        ;
        (Y =:= 5, X1 is X+1, Y1 is Y-1, isSamePiece(X1, Y1, Board, Piece),
        X2 is X+1, Y2 is Y-2, isSamePiece(X2, Y2, Board, Piece))
        ;
        (Y > 5, X1 is X+1, Y1 is Y-1, isSamePiece(X1, Y1, Board, Piece),
        X2 is X+2, Y2 is Y-2, isSamePiece(X2, Y2, Board, Piece))).



stopPlaying(X, Y, Board, Name) :-  
        ((checkWonGame(X, Y, Board, Name), write('Player '), write(Name), write(' won the game.'), nl)
        ;
        (checkLostGame(X, Y, Board, Name), write('Player '), write(Name), write(' lost the game.'), nl)).


/**----------------- HUMAN-------------------**/      

playerTurn(Board, Name, UpdateBoard, X, Y):-
        nl, nl, write('  ------ '), write(Name), write(' ------'), nl,
        movePieceToCell(X, Y, Board, Name, UpdateBoard),
        display_board(UpdateBoard).



/**----------------- BOT-------------------**/   

botTurn(Board, Name, UpdateBoard, X, Y):-
        nl, nl, write('  ------ '), write(Name), write(' ------'), nl,
        movePieceToCellBot(X, Y, Board, Name, UpdateBoard),
        display_board(UpdateBoard).


movePieceToCellBot(X, Y, Board_Input, Name, Board_Output):-
        piece(Name, Piece),
        replace(Board_Input , X , Y , Piece , Board_Output).

%checkPossibleWinTest(X, 9, Board, Name, Xfinal, Yfinal):- write('Acabei').

checkPossibleWinTest(X, Y, Board, Name, Xfinal, Yfinal) :-
        Y < 9,
        nth0(Y, Board, ListY), 
        length(ListY, Size),
        (((isFreeCell(X, Y, Board, Cell), checkWonGame(X, Y, Board, Name), Xfinal is X, Yfinal is Y)
        ;
        (((X>=Size, X1 is 0, Y1 is Y+1)
        ;
        (X<Size, X1 is X+1, Y1 is Y)),
        checkPossibleWinTest(X1, Y1, Board, Name, Xfinal, Yfinal)))).



test1:- board(B), Name2 = 'cat', assert(piece(Name2, b)), checkPossibleWinTest(0, 0, B, Name2, Xf, Yf), write(Xf), write(' '), write(Yf).


/**----------------- PLAY GAME HUMAN VS HUMAN-------------------**/     

%game(+Level, +Tab, +Name1, +Name2)
play_game_humans(Board, Name1, Name2):- 
        board(Board), 
        display_board(Board), !,
        (\+ playingHumans(Board, Name1, Name2, UpdateBoard)).

playingHumans(Board, Name1, Name2, UpdateBoard):-
        playerTurn(Board, Name1, UpdateBoard1, X, Y), !,
        (\+ stopPlaying(X, Y, UpdateBoard1, Name1)), 
     
        playerTurn(UpdateBoard1, Name2, UpdateBoard2, X1, Y1), !,
        (\+ stopPlaying(X1, Y1, UpdateBoard2, Name2)),
  
        playingHumans(UpdateBoard2, Name1, Name2, UpdateBoard).


/**----------------- PLAY GAME HUMAN VS BOT-------------------**/

play_game_human_bot(Level, Board, Name1, Name2):-
        board(Board), 
        display_board(Board), !,
        (\+ playingHumanBot(Level, Board, Name1, Name2, UpdateBoard)).


playingHumanBot(Level, Board, Name1, Name2, UpdateBoard):-
        playerTurn(Board, Name1, UpdateBoard1, X, Y), !,
        (\+ stopPlaying(X, Y, UpdateBoard1, Name1)),

        ((checkPossibleWinTest(0, 0, UpdateBoard1, Name1, X1, Y1))
        ;
        (generateRandomCoordinates(X1, Y1, UpdateBoard1))),

        %verificacao de paragem       
        botTurn(UpdateBoard1, Name2, UpdateBoard2, X1, Y1), !,
        (\+ stopPlaying(X1, Y1, UpdateBoard2, Name2)),

        %verificacao de paragem     
        playingHumanBot(Level, UpdateBoard2, Name1, Name2, UpdateBoard).

fim:- board(B), getPlayerName(Name1), assert(piece(Name1, b)), getPlayerName(Name2), assert(piece(Name2, w)), playingHumanBot(_, B, Name1, Name2, Board).

generateRandomCoordinates(X, Y, Board):-
        repeat,
        random(0, 9, Y),
        nth0(Y, Board, ListY),
        length(ListY, Size),
        random(0, Size, X),
        ((isFreeCell(X, Y, Board, Cell))
        ; 
        (fail)), !.

testc:-board(B), generateRandomCoordinates(X, Y, B), write(X), write(' '), write(Y).

%PARA FAZER: 

%FALTA CONDICAO DE EMPATE
%FALTA CONDICAO DE POSSIBILIDADE DE GANHAR DO BOT
%FALTA VERIFICACOES DE DIAGONAIS
