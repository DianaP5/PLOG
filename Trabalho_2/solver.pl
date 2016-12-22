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
isDefinedElement(X, Y, Board):-
        getElem(X, Y, Board, Elem),
        integer(Elem).

isUndefinedElement(X, Y, Board):-
        getElem(X, Y, Board, Elem),
        var(Elem).
        
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

getLeftList(_, _, _, [])     :- [].

getLeftList(X, Row, [Elem|List]):-
        Position is X - 1,
        Position >= 0,
        getUndefinedElement(Position, Row, Elem),
        X1 is X-1,
        getLeftList(X1, Row, List).

getLeftList(_, _, [])     :- [].


%get right list
getRightList(X, Y, Board, [Elem|List]):-
        getRow(Y, Board, Row),
        Position is X + 1,
        length(Row, Size),
        Position < Size,
        getUndefinedElement(Position, Row, Elem),
        X1 is X+1,
        getRightList(X1, Row, List).

getRightList(_, _, _, [])     :- [].

getRightList(X, Row, [Elem|List]):-
        Position is X + 1,
        length(Row, Size),
        Position < Size ,
        getUndefinedElement(Position, Row, Elem),
        X1 is X+1,
        getRightList(X1, Row, List).

getRightList(_, _, [])     :- [].


%get top list

getTopList(X, Y, Board, [Elem|List]):-
        Position is Y - 1,
        Position >= 0,
        getRow(Position, Board, Row),
        getUndefinedElement(X, Row, Elem),
        Y1 is Y - 1,
        getTopList(X, Y1, Board, List).

getTopList(_, _, _, [])     :- [].


%get bottom list
getBottomList(X, Y, Board, [Elem|List]):-
        Position is Y + 1,
        length(Board, Size),
        Position < Size,
        getRow(Position, Board, Row),
        getUndefinedElement(X, Row, Elem),
        Y1 is Y + 1,
        getBottomList(X, Y1, Board, List).

getBottomList(_, _, _, [])     :- [].

%get all possible lists of a cell
getAllListsCell(X, Y, Board, List, ListAux):-
        getDefinedElement(X, Y, Board, Elem),
        getLeftList(X, Y, Board, Left),
        getRightList(X, Y, Board, Right),
        getTopList(X, Y, Board, Top),
        getBottomList(X, Y, Board, Bottom),
        List = [Left, Right, Elem, Top, Bottom], 
        ListAux = [Left, Right, Top, Bottom].


%case when Element is UNDEFINED

%case when x and y are both less than BoardSize
getAllListsBoard(X, Y, Board, List, ListAux):-
        length(Board, BoardSize),
        Y < BoardSize,
        X < BoardSize,
        isUndefinedElement(X, Y, Board),
        X1 is X + 1,
        getAllListsBoard(X1, Y, Board, List, ListAux).

%case when x is equal to BoardSize 
getAllListsBoard(X, Y, Board, List, ListAux):-
        length(Board, BoardSize),
        X is BoardSize,
        X1 is 0,
        Y1 is Y+1,
        Y1 < BoardSize,
        isUndefinedElement(X1, Y1, Board),
        X2 is X1 + 1,
        getAllListsBoard(X2, Y1, Board, List, ListAux).


%case when Element is DEFINED

%case when x and y are both less than BoardSize
getAllListsBoard(X, Y, Board, [H|List], [H2|ListAux]):-
        length(Board, BoardSize),
        Y < BoardSize,
        X < BoardSize,
        isDefinedElement(X, Y, Board),
        getAllListsCell(X, Y, Board, H, H2),
        X1 is X + 1,
        getAllListsBoard(X1, Y, Board, List, ListAux).



%case when x is equal to BoardSize 
getAllListsBoard(X, Y, Board, [H|List], [H2|ListAux]):-
        length(Board, BoardSize),
        X is BoardSize,
        X1 is 0,
        Y1 is Y+1,
        Y1 < BoardSize,
        isDefinedElement(X1, Y1, Board),
        getAllListsCell(X1, Y1, Board, H, H2),
        X2 is X1 + 1,
        getAllListsBoard(X2, Y1, Board, List, ListAux).

getAllListsBoard(_, _, _, [], _):- [].


%count consecutive cells

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


%extracting variables

variables(InputList, OutputList):-
        append(InputList, AuxList),
        append(AuxList, OutputList).


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


%test

test_board:- board_test_6x6(Board),
        getAllListsBoard(0, 0, Board, List),
        constraints(List),
        write(List),
        phrase(variables(List), Vs),
        labeling([], Vs),
        write(List), nl, write(Vs).


test:- board_test_4x4(Board),
        getAllListsBoard(0, 0, Board, Ls, LAux),
        constraints(Ls),
        variables(LAux, Vs), 
        labeling([], Vs), write(Ls).

test2:- 
        board_test_4x4(Board),
        getAllListsBoard(0, 0, Board, Ls, LAux), write(LAux),nl,
        variables(LAux, OutputList), 
        labeling([], OutputList), write(Ls).