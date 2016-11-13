
%Replace column

replace([L|Ls] , X , 0 , Z , [R|Ls] ) :-  % once we find the desired row,
  replace_row(L,X,Z,R).                % - we replace specified column, and we're done.
                                   
replace( [L|Ls] , X , Y , Z , [L|Rs] ) :- % if we haven't found the desired row yet
  Y > 0 ,                                 % - and the row offset is positive,
  Y1 is Y-1 ,                             % - we decrement the row offset
  replace( Ls , X , Y1 , Z , Rs ).        % - and recurse down

replace_row( [_|Cs] , 0 , Z , [Z|Cs] ) .  % once we find the specified offset, just make the substitution and finish up.
replace_row( [C|Cs] , X , Z , [C|Rs] ) :- % otherwise,
  X > 0 ,                                    % - assuming that the column offset is positive,
  X1 is X-1 ,                                % - we decrement it
  replace_row( Cs , X1 , Z , Rs ).        % - and recurse down.        


getPlayerName(Name) :-
  write('Please type name of player:'),
  nl,
  read(Name).

displayName(Name) :-
        write('Player: '),
        write(Name).

getLine(Y):- 
        write('  Line: '),
        read(Y).

getColumn(X) :- 
        write(' Column: '),
        read(X).

getCoordinates(X, Y):-
        nl, write(' Insert coordinates: '), nl,
        getColumn(X), nl,
        getLine(Y).


generateRandomCoordinates(X, Y, Board):-
        repeat,
        random(0, 9, Y),
        nth0(Y, Board, ListY),
        length(ListY, Size),
        random(0, Size, X),
        ((getPiece(X, Y, Board_Input, Cell), isFree(Cell))
        ; 
        (write('Invalid coordinates'), nl, fail)), !.