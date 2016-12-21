:- use_module(library(clpfd)).
:- use_module(library(lists)).

%Representation of board 

board_test_4x4([[ A1,  2, A3, A4],
                [ B1, B2,  2, B4],
                [ C1,  0, C3, C4],
                [  5, D2, D3,  4]]).


%Tests


testLeft:- board_test_4x4(Board),
        getLeftList(1, 2, Board, Left),
        write(Left).

testRight:- board_test_4x4(Board),
        getRightList(3, 3, Board, Right),
        write(Right).

testTop:- board_test_4x4(Board),
        getTopList(3, 3, Board, Top),
        write(Top).

testBottom:- board_test_4x4(Board),
        getBottomList(3, 3, Board, Bottom),
        write(Bottom).

testAll:- board_test_4x4(Board),
        getAllListsCell(1, 0, Board, List1),
        write(List1), nl,
        getAllListsCell(1, 2, Board, List2),
        write(List2).



%predicates
        
getRow(Y, Board, Row):-
        nth0(Y, Board, Row).

getElem(X, Y, Board, Elem):-
        getRow(Y, Board, Row),
        nth0(X, Row, Elem).

getDefinedElement(X, Y, Board, Elem):-
        getElem(X, Y, Board, Elem),
        integer(Elem).

getDefinedElement(X, Row, Elem):-
        nth0(X, Row, Elem),
        integer(Elem).

getUndefinedElement(X, Y, Board, Elem):-
        getElem(X, Y, Board, Elem),
        var(Elem).

getUndefinedElement(X, Row, Elem):-
        nth0(X, Row, Elem),
        var(Elem).

%get left list
getLeftList(X, Y, Board, List):-
        getLeftListAux(X, Y, Board, LeftAux),
        reverse(LeftAux, List).

getLeftListAux(X, Y, Board, [Elem|List]):-
        getRow(Y, Board, Row),
        Position is X - 1,
        Position >= 0,
        getUndefinedElement(Position, Row, Elem),
        write(Elem), nl,
        X1 is X-1,
        getLeftListAux(X1, Row, List).

getLeftListAux(X, Y, Board, [])     :- [].

getLeftListAux(X, Row, [Elem|List]):-
        Position is X - 1,
        Position >= 0,
        getUndefinedElement(Position, Row, Elem),
        X1 is X-1,
        getLeftListAux(X1, Row, List).

getLeftListAux(X, Row, [])     :- [].


%get right list
getRightList(X, Y, Board, [Elem|List]):-
        getRow(Y, Board, Row),
        Position is X + 1,
        length(Row, Size),
        Position < Size,
        getUndefinedElement(Position, Row, Elem),
        X1 is X+1,
        getRightList(X1, Row, List).

getRightList(X, Y, Board, [])     :- [].

getRightList(X, Row, [Elem|List]):-
        Position is X + 1,
        length(Row, Size),
        Position < Size ,
        getUndefinedElement(Position, Row, Elem),
        X1 is X+1,
        getRightList(X1, Row, List).

getRightList(X, Row, [])     :- [].


%get top list
getTopList(X, Y, Board, List):-
        getTopListAux(X, Y, Board, ListAux),
        reverse(ListAux, List).

getTopListAux(X, Y, Board, [Elem|List]):-
        Position is Y - 1,
        Position >= 0,
        getRow(Position, Board, Row),
        getUndefinedElement(X, Row, Elem),
        Y1 is Y - 1,
        getTopListAux(X, Y1, Board, List).

getTopListAux(X, Y, Board, [])     :- [].


%get bottom list
getBottomList(X, Y, Board, [Elem|List]):-
        Position is Y + 1,
        length(Board, Size),
        Position < Size,
        getRow(Position, Board, Row),
        getUndefinedElement(X, Row, Elem),
        Y1 is Y + 1,
        getBottomList(X, Y1, Board, List).

getBottomList(X, Y, Board, [])     :- [].


%get all possible lists of a cell
getAllListsCell(X, Y, Board, List):-
        getDefinedElement(X, Y, Board, Elem),
        getLeftList(X, Y, Board, Left),
        getRightList(X, Y, Board, Right),
        getTopList(X, Y, Board, Top),
        getBottomList(X, Y, Board, Bottom),
        List = [Left, Right, Elem, Top, Bottom].


%case when Element is UNDEFINED

%case when x and y are both less than BoardSize
getAllListsBoard(X, Y, Board, List):-
        length(Board, BoardSize),
        Y < BoardSize,
        X < BoardSize,
        getUndefinedElement(X, Y, Board, Elem),
        X1 is X + 1,
        getAllListsBoard(X1, Y, Board, List).

%case when x is equal to BoardSize 
getAllListsBoard(X, Y, Board, List):-
        length(Board, BoardSize),
        X is BoardSize,
        X1 is 0,
        Y1 is Y+1,
        Y1 < BoardSize,
        getUndefinedElement(X1, Y1, Board, Elem),
        X2 is X1 + 1,
        getAllListsBoard(X2, Y1, Board, List).

%case when Element is DEFINED

%case when x and y are both less than BoardSize
getAllListsBoard(X, Y, Board, [H|List]):-
        length(Board, BoardSize),
        Y < BoardSize,
        X < BoardSize,
        getDefinedElement(X, Y, Board, Elem),
        getAllListsCell(X, Y, Board, ListsCell),
        H = ListsCell,
        X1 is X + 1,
        getAllListsBoard(X1, Y, Board, List).

%case when x is equal to BoardSize 
getAllListsBoard(X, Y, Board, [H|List]):-
        length(Board, BoardSize),
        X is BoardSize,
        X1 is 0,
        Y1 is Y+1,
        Y1 < BoardSize,
        getDefinedElement(X1, Y1, Board, Elem),
        getAllListsCell(X1, Y1, Board, ListsCell),
        H = ListsCell,
        X2 is X1 + 1,
        getAllListsBoard(X2, Y1, Board, List).

getAllListsBoard(X, Y, Board, []):- [].