% knowledge base
:- style_check(-singleton).
flight(canakkale,erzincan,6).
flight(erzincan,antalya,3).
flight(antalya,izmir,2).
flight(izmir,istanbul,2).
flight(antalya,diyarbakir,4).
flight(diyarbakir,ankara,8).
flight(izmir,ankara,6).
flight(ankara,istanbul,1).
flight(istanbul,rize,4).
flight(ankara,rize,5).
flight(ankara,van,4).
flight(van,gaziantep,3).

flight(erzincan,canakkale,6).
flight(antalya,erzincan,3).
flight(izmir,antalya,2).
flight(istanbul,izmir,2).
flight(diyarbakir,antalya,4).
flight(ankara,diyarbakir,8).
flight(ankara,izmir,6).
flight(istanbul,ankara,1).
flight(rize,istanbul,4).
flight(rize,ankara,5).
flight(van,ankara,4).
flight(gaziantep,van,3).
%------ RULES -------
% Symmetry
route_base(X,Y,Z) :- flight(X,Y,Z).

route(X, Y, Cost):-
        check_route(X, Y, [Y|Rest],Cost).

check_route(X, Y,Routes,Cost) :- 
        search_route(X, Y,[X],Routes,Cost).

search_route(X, Y, P, [Y|P],Cost) :- 
        route_base(X,Y,Cost).

search_route(X, Y, Routes, A, Cost) :-
    route_base(X, Z, Cost1),
    not(Z == X),not(Z == Y),
    not(in(Z, Routes)),           
    search_route(Z, Y, [Z|Routes],A,Cost2),
    Cost is Cost1+Cost2.

%To check whether an element is in array
in(E, [E|Rest]).
in(E, [I|Rest]):- in(E, Rest).