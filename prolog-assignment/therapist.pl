
% start the program
start :-
    write('What seems to be the issue?'), nl,
    get_input.

% get input from user
get_input :-
    read_line_to_codes(user_input, Cs),
    atom_codes(A, Cs),
    atomic_list_concat(L, ' ', A),
    match(L).

match([this, is|Rest]) :-
    write('What else do you regard as '),
    write(Rest),
    write('?'), nl, get_input.

% exit the program
match([goodbye|_]) :-
    write('goodbye'), nl.

% match on a specific element in the input list
match(List) :-
    member('brother', List)   -> write('Tell me about your family.'),   nl, get_input;
	member('sister', List)    -> write('Tell me about your family.'),   nl, get_input;
    member('mom', List)       -> write('Tell me about your family.'),   nl, get_input;
    member('mother', List)    -> write('Tell me about your family.'),   nl, get_input;
    member('dad', List)       -> write('Tell me about your family.'),   nl, get_input;
    member('father', List)    -> write('Tell me about your family.'),   nl, get_input;
    
    member('boss', List)      -> write('Tell me more about work.'),     nl, get_input;
	member('work', List)      -> write('Tell me more about work.'),     nl, get_input;
    member('job', List)       -> write('Tell me more about work.'),     nl, get_input;

    member('school', List)    -> write('Tell me more about school.'),   nl, get_input;    
    member('class', List)     -> write('Tell me more about school.'),   nl, get_input;
	member('teacher', List)   -> write('Tell me more about school.'),   nl, get_input;
    member('professor', List) -> write('Tell me more about school.'),   nl, get_input;
    
    member('me', List)        -> write('Tell me more about yourself.'), nl, get_input;
	member('myself', List)    -> write('Tell me more about yourself.'), nl, get_input;
	
	write('I see. Please, continue.'), nl, get_input.

