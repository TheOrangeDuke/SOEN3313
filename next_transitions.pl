next_transitions(State, Event, Guard, Action, Exclude, List) :-
(
	%! if State is the superstate of Next and Next is an initial state,
	%! without being in the excluded states
	(superstate(State,Next), initial_state(Next), member(Next,Exclude),!,fail) ->
	%! then assume we are entering the substate
	(
		%! check if implementation enables transitions to substate or
		%! if false means the state directly transitions in the initial substate
		%! without a defined transition.
		sub_transition(State) ->
		%! then
		(findall([State,Next,Event,Guard,Action], transition(State,Next,Event,Guard,Action), L1));
		%! else
		(List is [[State,Next,null,null,null]])
	);
	%! else
	(findall([State,Next,Event,Guard,Action], transition(State,Next,Event,Guard,Action), L1),
		(
			(length(L1,X), X == 0)->
	 		(
				(
					(superstate(Super,State))->
					(next_transitions(Super, Event, Guard, Action, [State], List));
					(List is L1)

				)
			);
	 		(List is L1)
		)
	)
).
