start :- read_line_to_codes(user_input, Cs),
	atom_codes(A, Cs),
	atomic_list_concat(L,' ', A),
	parse(L).

% Relate nouns to nouns
% all combinations of articles should be included
parse([X,is,a,Y|_]) :-
	assert(relate(X,Y)),
	write('ok'),nl,
	start.
	
parse([X,is,an,Y|_]) :-
	assert(relate(X,Y)),
	write('ok'),nl,
	start.

% two articles
parse([a,X,is,a,Y|_]):-
	assert(relate(X,Y)),
	write('ok'),nl,
	start.
	
parse([a,X,is,an,Y|_]):-
	assert(relate(X,Y)),
	write('ok'),nl,
	start.
	
parse([an,X,is,a,Y|_]):-
	assert(relate(X,Y)),
	write('ok'),nl,
	start.
	
parse([an,X,is,an,Y|_]):-
	assert(relate(X,Y)),
	write('ok'),nl,
	start.

% Questions
% all combinations of articles should be included.
% is there any way to cut down on code duplication?
parse([is,X,a,Y|_]) :-
	related(X,Y), start.

% two articles
parse([is,a,X,a,Y|_]) :-
	related(X,Y), start.
	
parse([is,a,X,an,Y|_]) :-
	related(X,Y), start.
	
parse([is,an,X,a,Y|_]) :-
	related(X,Y), start.
	
parse([is,an,X,an,Y|_]) :-
	related(X,Y), start.

% exit the program with goodbye
parse([goodbye|_]) :-
	write('goodbye'),nl.

% print whether two nouns are related
related(X,Y) :-
	relate(X,Y) -> write('yes'),nl; % just one relation
	relate(X,Z),
	relate(Z,Y) -> write('yes'),nl; % extended relation (two links in chain)
	write('unknown'),nl.

