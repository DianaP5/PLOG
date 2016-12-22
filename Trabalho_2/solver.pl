:- use_module(library(clpfd)).
:- use_module(library(lists)).


%tirar daqui
%Representation of board 

board_test_4x4([[ A1,  2, A3, A4],
                [ B1, B2,  2, B4],
                [ C1,  0, C3, C4],
                [  5, D2, D3,  4]]).

board_test_6x6([[ A1, A2,  4, A4, A5,  1],
                [ B1,  2, B3, B4, B5, B6],
                [  3, C2, C3,  1, C5, C6],
                [ D1, D2,  1, D4, D5,  2],
                [ E1, E2, E3, E4,  2, E6],
                [  2, F2, F3,  3, F5, F6]]).

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
        getAllListsBoard(0, 0, Board, List),
        write(List).



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

getLeftList(X, Y, Board, [Elem|List]):-
        getRow(Y, Board, Row),
        Position is X - 1,
        Position >= 0,
        getUndefinedElement(Position, Row, Elem),
        X1 is X-1,
        getLeftList(X1, Row, List).

getLeftList(X, Y, Board, [])     :- [].

getLeftList(X, Row, [Elem|List]):-
        Position is X - 1,
        Position >= 0,
        getUndefinedElement(Position, Row, Elem),
        X1 is X-1,
        getLeftList(X1, Row, List).

getLeftList(X, Row, [])     :- [].


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

getTopList(X, Y, Board, [Elem|List]):-
        Position is Y - 1,
        Position >= 0,
        getRow(Position, Board, Row),
        getUndefinedElement(X, Row, Elem),
        Y1 is Y - 1,
        getTopList(X, Y1, Board, List).

getTopList(X, Y, Board, [])     :- [].


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



count:-countConsecutiveHorizontal([0, 1, 1, 0, 1, 0, 1, 1], N, 0), write(N).

countConsecutiveHorizontal([], N, N).
countConsecutiveHorizontal([0|_], N, N).
countConsecutiveHorizontal([H|List], N, Aux):-
        H is 1, 
        NAux is Aux+1,
        countConsecutiveHorizontal(List, N, NAux).


countConsecutiveVertical([], N, N).
countConsecutiveVertical([1|_], N, N).
countConsecutiveVertical([H|List], N, Aux):-
        H is 0, 
        NAux is Aux+1,
        countConsecutiveVertical(List, N, NAux).

%posting constraints

constraints([]).
constraints([[Left, Right, Pivot, Top, Bottom]|Rest]) :-
        domain(Left, 0, 1),
        domain(Right, 0, 1),
        domain(Top, 0, 1),
        domain(Bottom, 0, 1),
        countConsecutiveHorizontal(Left, CountLeft, 0),
        countConsecutiveHorizontal(Right, CountRight, 0),
        countConsecutiveVertical(Top, CountTop, 0),
        countConsecutiveVertical(Bottom, CountBottom, 0),
        Pivot #= CountLeft + CountRight + CountTop + CountBottom,
        constraints(Rest).


%extracting the variables
variables([]) :- [].
variables([[Left, Right, _, Top, Bottom]|Rest]) :-
        write(Left), nl, 
        write(Right), nl,
        write(Top), nl, 
        write(Bottom), nl,
        seq(Left),
        seq(Right),
        seq(Top),
        seq(Bottom),
        variables(Rest).

seq([]) :- [].
seq([L|Ls]) :- [L], seq(Ls).


%test

test_board:- board_test_6x6(Board),
        getAllListsBoard(0, 0, Board, List),
        constraints(List),
        write(List),
        phrase(variables(List), Vs),
        labeling([], Vs),
        write(List), nl, write(Vs).


