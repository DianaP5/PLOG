/***************************************************************
***********************      WALLS_5     ***********************
***************************************************************/

:- use_module(library(clpfd)).
:- use_module(library(lists)).

/* Board Representation */

board_test([[_, _, 4, _, _, 1],
            [_, 2, _, _, _, _],
            [3, _, _, 1, _, _],
            [_, _, 1, _, _, 2],
            [_, _, _, _, 2, _],
            [2, _, _, 3, _, _]]).

board_test_4x4([[   ?, p(2),    ?,    ?],
                [   ?,    ?, p(2),    ?],
                [   ?, p(0),    ?,    ?],
                [p(5),    ?,    ?, p(4)]]).

board_test_6x6([[   ?,    ?, p(4),    ?,    ?, p(1)],
                [   ?, p(2),    ?,    ?,    ?,    ?],
                [p(3),    ?,    ?, p(1),    ?,    ?],
                [   ?,    ?, p(1),    ?,    ?, p(2)],
                [   ?,    ?,    ?,    ?, p(2),    ?],
                [p(2),    ?,    ?, p(3),    ?,    ?]]).

% ? for unknown integers
% terms of the form p(P) to denote de pivot element P


/*
http://stackoverflow.com/questions/40954472/constraints-over-arbitrary-length-sublists-using-clpfd
http://stackoverflow.com/questions/41168767/non-termination-when-generating-lists-of-arbitrary-length-in-clpfd
http://stackoverflow.com/questions/41166685/constrain-two-lists-to-begin-with-n-consecutive-elements-in-total-using-clpfd
*/

%clean Representation

test:-
        X = [?,?,?,p(3),?,?,?,p(4),?,?,p(2),?],
        nth0(3, X, p(Elem)),
        write(Elem),
        isDefined(Elem).

testRow:- X = [[   ?, p(2),    ?,    ?],
                [   ?,    ?, p(2),    ?],
                [   ?, p(0),    ?,    ?],
                [p(5),    ?,    ?, p(4)]],
        getRow(3, X, Row),
        write(Row).

testLeft:- board_test_4x4(Board),
        getLeftList(3, 3, Board, Left),
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

testAllListsCell:-board_test_4x4(Board),
        getAllListsCell(1, 2, Board, Lists),
        write(Lists).

testAllListsBoard:- board_test_4x4(Board),
        getAllListsBoard(0, 0, Board, List),
        write(List).


/********************************************************************************************
*********************************************************************************************
***********************************        SOLVER         ***********************************
*********************************************************************************************
********************************************************************************************/

isUndefined(Elem):-
        Elem == '?'.

isDefined(Elem):-
        Elem \= '?'.
        
getRow(Y, Board, Row):-
        nth0(Y, Board, Row).

getDefinedElement(X, Y, Board, Elem):-
        getRow(Y, Board, Row),
        nth0(X, Row, p(Elem)).

getUndefinedElement(X, Y, Board, Elem):-
        getRow(Y, Board, Row),
        nth0(X, Row, Elem),
        isUndefined(Elem).

%get left list
getLeftList(X, Y, Board, [_|List]):-
        getRow(Y, Board, Row),
        Position is X - 1,
        Position >= 0,
        nth0(Position, Row, Elem),
        isUndefined(Elem),
        X1 is X-1,
        getLeftList(X1, Row, List).

getLeftList(X, Y, Board, [])     :- [].

getLeftList(X, Row, [_|List]):-
        Position is X - 1,
        Position >= 0,
        nth0(Position, Row, Elem),
        isUndefined(Elem),
        X1 is X-1,
        getLeftList(X1, Row, List).

getLeftList(X, Row, [])     :- [].


%get right list
getRightList(X, Y, Board, [_|List]):-
        getRow(Y, Board, Row),
        Position is X + 1,
        length(Row, Size),
        Position < Size,
        nth0(Position, Row, Elem),
        isUndefined(Elem),
        X1 is X+1,
        getRightList(X1, Row, List).

getRightList(X, Y, Board, [])     :- [].

getRightList(X, Row, [_|List]):-
        Position is X + 1,
        length(Row, Size),
        Position < Size ,
        nth0(Position, Row, Elem),
        isUndefined(Elem),
        X1 is X+1,
        getRightList(X1, Row, List).

getRightList(X, Row, [])     :- [].


%get top list
getTopList(X, Y, Board, [_|List]):-
        Position is Y - 1,
        Position >= 0,
        getRow(Position, Board, Row),
        nth0(X, Row, Elem),
        isUndefined(Elem),
        Y1 is Y - 1,
        getTopList(X, Y1, Board, List).

getTopList(X, Y, Board, [])     :- [].


%get bottom list
getBottomList(X, Y, Board, [_|List]):-
        Position is Y + 1,
        length(Board, Size),
        Position < Size,
        getRow(Position, Board, Row),
        nth0(X, Row, Elem),
        isUndefined(Elem),
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



/*
%conversion to triples
is_p_is([Ls|Rest]) :-
        is(Ls),
        is_p_is_(Rest).

is_p_is_([Pivot,Rs]) :- [p(Pivot)], is(Rs).
is_p_is_([Pivot,Rs,Rs|IPIs]) :-
        [p(Pivot)],
        is(Rs),
        is_p_is_(IPIs).

is([])     :- [].
is([_|Is]) :- [?], is(Is).


%posting constraints

constraints([]).
constraints([Left,Pivot,Right|Rest]) :-
        domain(Left, 0, 1),
        domain(Right, 0, 1),
        sum(Left, #=, SL),
        sum(Right, #=, SR),
        Pivot #= SL + SR,
        constraints(Rest).


%extracting the variables
variables([]) :- [].
variables([Left,_,Right|Rest]) :-
        seq(Left),
        seq(Right),
        variables(Rest).

seq([]) :- [].
seq([L|Ls]) :- [L], seq(Ls).


%test

test(example(Es)):- 
   phrase(is_p_is(Ls), Es),
   constraints(Ls),
   phrase(variables(Ls), Vs),
   labeling([], Vs), 
   write(Es), nl, write(Ls), nl, write(Vs).*/
