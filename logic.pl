
:-consult('tabuleiro_hexagonal.pl').
:-consult('utils.pl').
:-use_module(library(lists)).
:-use_module(library(random)).


isBlack(b).
isWhite(w).


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
        

/**----------------- DRAW -------------------**/

checkDraw(X, 9, Board).
checkDraw(X, Y, Board) :-

        ((isBlackCell(X, Y, Board, Cell))
        ;
        (isWhiteCell(X, Y, Board, Cell))),

        nth0(Y, Board, ListY), 
        length(ListY, Size),
        ((X >= Size-1, X1 is 0, Y1 is Y+1)
        ;
        (X < Size-1, X1 is X+1, Y1 is Y)),

        checkDraw(X1, Y1, Board).

draw:- board(B), checkDraw(0, 0, B).



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



stopPlaying(X, Y, Board, Name, Name1) :-  
        ((checkWonGame(X, Y, Board, Name), write('Player '), write(Name), write(' won the game.'), nl)
        ;
        (checkLostGame(X, Y, Board, Name), write('Player '), write(Name1), write(' won the game.'), nl)
        ;
        (checkDraw(0, 0, Board), write('Draw.'), nl)).


/**----------------- HUMAN-------------------**/      

playerTurn(Board, Name, UpdateBoard, X, Y):-
        displayName(Name),
        movePieceToCell(X, Y, Board, Name, UpdateBoard),
        display_board(UpdateBoard).



/**----------------- BOT-------------------**/   

botTurn(Board, Name, UpdateBoard, X, Y):-
        displayName(Name),
        movePieceToCellBot(X, Y, Board, Name, UpdateBoard),
        display_board(UpdateBoard).


movePieceToCellBot(X, Y, Board_Input, Name, Board_Output):-
        piece(Name, Piece),
        replace(Board_Input , X , Y , Piece , Board_Output).

        
generateRandomCoordinates(X, Y, Board):-
        repeat,
        random(0, 9, Y),
        nth0(Y, Board, ListY),
        length(ListY, Size),
        random(0, Size, X),
        ((isFreeCell(X, Y, Board, Cell))
        ; 
        (fail)), !.


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


/**----------------- PLAY GAME HUMAN VS HUMAN-------------------**/     

%game(+Level, +Tab, +Name1, +Name2)
play_game_humans(Board, Name1, Name2):- 
        board(Board), 
        display_board(Board), !,
        (\+ playingHumans(Board, Name1, Name2, UpdateBoard)).

playingHumans(Board, Name1, Name2, UpdateBoard):-
        playerTurn(Board, Name1, UpdateBoard1, X, Y), !,
        (\+ stopPlaying(X, Y, UpdateBoard1, Name1, Name2)), 
     
        playerTurn(UpdateBoard1, Name2, UpdateBoard2, X1, Y1), !,
        (\+ stopPlaying(X1, Y1, UpdateBoard2, Name2, Name1)),
  
        playingHumans(UpdateBoard2, Name1, Name2, UpdateBoard).


/**----------------- PLAY GAME HUMAN VS BOT-------------------**/

play_game_human_bot(Level, Board, Name1, Name2):-
        board(Board), 
        display_board(Board), !,
        (\+ playingHumanBot(Level, Board, Name1, Name2, UpdateBoard)).


playingHumanBot(Level, Board, Name1, Name2, UpdateBoard):-
        playerTurn(Board, Name1, UpdateBoard1, X, Y), !,
        (\+ stopPlaying(X, Y, UpdateBoard1, Name1, Name2)),


        ((Level =:= 2, checkPossibleWinTest(0, 0, UpdateBoard1, Name2, X1, Y1))
        ;
        (checkPossibleWinTest(0, 0, UpdateBoard1, Name1, X1, Y1))
        ;
        (generateRandomCoordinates(X1, Y1, UpdateBoard1))),

        %verificacao de paragem       
        botTurn(UpdateBoard1, Name2, UpdateBoard2, X1, Y1), !,
        (\+ stopPlaying(X1, Y1, UpdateBoard2, Name2, Name1)),

        %verificacao de paragem     
        playingHumanBot(Level, UpdateBoard2, Name1, Name2, UpdateBoard).


/**----------------- PLAY GAME BOT VS BOT-------------------**/

play_game_bots(Level, Board, Name1, Name2):-
        board(Board), 
        display_board(Board), !,
        (\+ playingBots(Level, Board, Name1, Name2, UpdateBoard)).


playingBots(Level, Board, Name1, Name2, UpdateBoard):-

        ((Level =:= 2, checkPossibleWinTest(0, 0, Board, Name1, X, Y))
        ;
        (checkPossibleWinTest(0, 0, Board, Name2, X, Y))
        ;
        (generateRandomCoordinates(X, Y, Board))),

        botTurn(Board, Name1, UpdateBoard1, X, Y), !,
        (\+ stopPlaying(X, Y, UpdateBoard1, Name1, Name2)),


        ((Level =:= 2, checkPossibleWinTest(0, 0, UpdateBoard1, Name2, X1, Y1))
        ;
        (checkPossibleWinTest(0, 0, UpdateBoard1, Name1, X1, Y1))
        ;
        (generateRandomCoordinates(X1, Y1, UpdateBoard1))),

        %verificacao de paragem       
        botTurn(UpdateBoard1, Name2, UpdateBoard2, X1, Y1), !,
        (\+ stopPlaying(X1, Y1, UpdateBoard2, Name2, Name1)),

        %verificacao de paragem     
        playingBots(Level, UpdateBoard2, Name1, Name2, UpdateBoard).