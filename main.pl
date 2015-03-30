
%! includes
:- consult(part1),consult(part2),consult(part3),consult(part4),consult(part5).

%! rules

%! from slides
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

%! extended rules
%! 1
%! 2
all_loops(Set) :- findall([Event,Guard], is_loop(Event,Guard), LoopList),
                  list_to_set(LoopList, Set).
%! 3
%! 4
size(Length) :- findall([Event,Guard], is_edge(Event,Guard), EdgeList),
                list_to_set(EdgeList,EdgeSet),
                length(EdgeSet,Length).
%! 5
%! 6
all_superstates(Set) :- findall(State, superstate(State,_), SuperList),
                        list_to_set(SuperList,Set).
%! 7
%! 8
inheritss_transitions(State,List) :-
                    findall([Super,Other,Event,Guard,Action],
                    (superstate(Super,State), transition(Super,Other,Event,Guard,Action)),
                     List).
%! 9
%! 10
all_init_states(L) :- findall(State, init_state(State), L).
%! 11
%! 12
state_is_reflexive(State) :- transition(State,State,_,_,_).
%! 13
%! 14
get_guards(Ret) :-  findall(Guard, guard(Guard), Ret).
%! 15
get_events(Ret) :-  findall(Event, event(Event), Ret).
%! 16
get_actions(Ret) :-  findall(Action, action(Action), Ret).
%! 17

%! 18
legal_events_of(State,L) :- findall(Event,
                            transition(State,_,Event,_,_),
                            L).
