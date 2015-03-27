%rules

%from slides

composite_state(S) :- findall(Composite,
superstate(Composite, _), L),
list_to_set(L, S).
nested_state(S) :- superstate(_, S).
events_per_state(State, EventSet) :-
    findall(Event,
		(superstate(State, Substate),
		transition(Substate, _, Event, _, _)),
		EventList),
	list_to_set(EventList, EventSet).
included_states(S, L) :- findall(State,
(state(State), superstate(S, State)), L).
reachable(Target, Source) :- transition(Source,
Target, _, _, _).
reachable(Target, Source) :- transition(Source,
Node, _, _, _),
reachable(Target, Node).
events(EventSet) :- findall(Event,
transition(_, _, Event, _, _), EventList),
list_to_set(EventList, EventSet).

%extended rules