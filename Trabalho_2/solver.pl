:- use_module(library(clpfd)).
:- use_module(library(lists)).


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

/*********************************************************************************************************/

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

/*********************************************************************************************************/

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

/*********************************************************************************************************/

%get top list

getTopList(X, Y, Board, [Elem|List]):-
        Position is Y - 1,
        Position >= 0,
        getRow(Position, Board, Row),
        getUndefinedElement(X, Row, Elem),
        Y1 is Y - 1,
        getTopList(X, Y1, Board, List).

getTopList(_, _, _, [])     :- [].

/*********************************************************************************************************/

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

/*********************************************************************************************************/

%get all possible lists of a cell

getAllListsCell(X, Y, Board, List, ListAux, ListNumbers):-
        getDefinedElement(X, Y, Board, Elem),
        getLeftList(X, Y, Board, Left),
        getRightList(X, Y, Board, Right),
        getTopList(X, Y, Board, Top),
        getBottomList(X, Y, Board, Bottom),
        List = [Left, Right, Elem, Top, Bottom], 
        ListAux = [Left, Right, Top, Bottom],
        Elem == 0,
        ListNumbers = [X, Y].

getAllListsCell(X, Y, Board, List, ListAux, ListNumbers):-
        getDefinedElement(X, Y, Board, Elem),
        getLeftList(X, Y, Board, Left),
        getRightList(X, Y, Board, Right),
        getTopList(X, Y, Board, Top),
        getBottomList(X, Y, Board, Bottom),
        List = [Left, Right, Elem, Top, Bottom], 
        ListAux = [Left, Right, Top, Bottom],
        Elem == 1,
        ListNumbers = [X, Y].

getAllListsCell(X, Y, Board, List, ListAux, ListNumbers):-
        getDefinedElement(X, Y, Board, Elem),
        getLeftList(X, Y, Board, Left),
        getRightList(X, Y, Board, Right),
        getTopList(X, Y, Board, Top),
        getBottomList(X, Y, Board, Bottom),
        List = [Left, Right, Elem, Top, Bottom], 
        ListAux = [Left, Right, Top, Bottom].


/*********************************************************************************************************/

%case when Element is UNDEFINED

%case when x and y are both less than BoardSize
getAllListsBoard(X, Y, Board, List, ListAux, ListNumbers):-
        length(Board, BoardSize),
        Y < BoardSize,
        X < BoardSize,
        isUndefinedElement(X, Y, Board),
        X1 is X + 1,
        getAllListsBoard(X1, Y, Board, List, ListAux, ListNumbers).

%case when x is equal to BoardSize 
getAllListsBoard(X, Y, Board, List, ListAux, ListNumbers):-
        length(Board, BoardSize),
        X is BoardSize,
        X1 is 0,
        Y1 is Y+1,
        Y1 < BoardSize,
        isUndefinedElement(X1, Y1, Board),
        X2 is X1 + 1,
        getAllListsBoard(X2, Y1, Board, List, ListAux, ListNumbers).


%case when Element is DEFINED

%case when x and y are both less than BoardSize
getAllListsBoard(X, Y, Board, [H|List], [H2|ListAux], [H3|ListNumbers]):-
        length(Board, BoardSize),
        Y < BoardSize,
        X < BoardSize,
        getDefinedElement(X, Y, Board, Elem),
        getAllListsCell(X, Y, Board, H, H2, H3),
        X1 is X + 1,
        Elem == 1,
        getAllListsBoard(X1, Y, Board, List, ListAux, ListNumbers).

getAllListsBoard(X, Y, Board, [H|List], [H2|ListAux], [H3|ListNumbers]):-
        length(Board, BoardSize),
        Y < BoardSize,
        X < BoardSize,
        getDefinedElement(X, Y, Board, Elem),
        getAllListsCell(X, Y, Board, H, H2, H3),
        X1 is X + 1,
        Elem == 0,
        getAllListsBoard(X1, Y, Board, List, ListAux, ListNumbers).

getAllListsBoard(X, Y, Board, [H|List], [H2|ListAux], ListNumbers):-
        length(Board, BoardSize),
        Y < BoardSize,
        X < BoardSize,
        isDefinedElement(X, Y, Board),
        getAllListsCell(X, Y, Board, H, H2, H3),
        X1 is X + 1,
        getAllListsBoard(X1, Y, Board, List, ListAux, ListNumbers).


%case when x is equal to BoardSize 
getAllListsBoard(X, Y, Board, [H|List], [H2|ListAux], [H3|ListNumbers]):-
        length(Board, BoardSize),
        X is BoardSize,
        X1 is 0,
        Y1 is Y+1,
        Y1 < BoardSize,
        getDefinedElement(X1, Y1, Board, Elem),
        getAllListsCell(X1, Y1, Board, H, H2, H3),
        X2 is X1 + 1,
        Elem == 1,
        getAllListsBoard(X2, Y1, Board, List, ListAux, ListNumbers).

getAllListsBoard(X, Y, Board, [H|List], [H2|ListAux], [H3|ListNumbers]):-
        length(Board, BoardSize),
        X is BoardSize,
        X1 is 0,
        Y1 is Y+1,
        Y1 < BoardSize,
        getDefinedElement(X1, Y1, Board, Elem),
        getAllListsCell(X1, Y1, Board, H, H2, H3),
        X2 is X1 + 1,
        Elem == 0,
        getAllListsBoard(X2, Y1, Board, List, ListAux, ListNumbers).

getAllListsBoard(X, Y, Board, [H|List], [H2|ListAux], ListNumbers):-
        length(Board, BoardSize),
        X is BoardSize,
        X1 is 0,
        Y1 is Y+1,
        Y1 < BoardSize,
        isDefinedElement(X1, Y1, Board),
        getAllListsCell(X1, Y1, Board, H, H2, H3),
        X2 is X1 + 1,
        getAllListsBoard(X2, Y1, Board, List, ListAux, ListNumbers).

getAllListsBoard(_, _, _, [], [], []).


/*********************************************************************************************************/

%count consecutive cells

countConsecutiveHorizontal([], N, N).
countConsecutiveHorizontal([0|_], N, N).
countConsecutiveHorizontal([H|List], N, Aux):-
        H #= 1, 
        NAux is Aux+1,
        countConsecutiveHorizontal(List, N, NAux).


countConsecutiveVertical([], N, N).
countConsecutiveVertical([1|_], N, N).
countConsecutiveVertical([H|List], N, Aux):-
        H #= 0, 
        NAux is Aux+1,
        countConsecutiveVertical(List, N, NAux).

/*********************************************************************************************************/

%extracting variables

variables(InputList, OutputList):-
        append(InputList, AuxList),
        append(AuxList, OutputList).

/*********************************************************************************************************/

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

/*********************************************************************************************************/
:- include('wallsTestBoards.pl').
%solve puzzle
solve(Board, ListNumbers):-

        getAllListsBoard(0, 0, Board, Ls, LAux, ListNumbers),
        constraints(Ls),
        variables(LAux, Vs), 

        %initiate statistics
	statistics(walltime, _),

        labeling([], Vs),

        %Obtain and print statistics
	statistics(walltime, [_, ElapsedTime | _]),
        format('An answer has been found!~nElapsed time: ~3d seconds', ElapsedTime), nl.

/*********************************************************************************************************/
